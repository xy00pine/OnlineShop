using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Configuration;

public partial class AdminUserManage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 检查管理员权限
        if (Session["Username"] == null || Session["Role"] == null || Session["Role"].ToString() != "admin")
        {
            Response.Redirect("userLogin.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadUsers();
        }
    }

    /// <summary>
    /// 加载所有用户
    /// </summary>
    private void LoadUsers(string searchKeyword = "")
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                string sql = @"SELECT 
                                id,
                                Username,
                                Email,
                                Phone,
                                RegisterTime
                              FROM userinfo
                              WHERE Role = 'user'";

                // 如果有搜索关键词
                if (!string.IsNullOrEmpty(searchKeyword))
                {
                    sql += @" AND (Username LIKE @keyword 
                              OR Email LIKE @keyword 
                              OR Phone LIKE @keyword)";
                }

                sql += " ORDER BY RegisterTime DESC";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (!string.IsNullOrEmpty(searchKeyword))
                    {
                        cmd.Parameters.AddWithValue("@keyword", "%" + searchKeyword + "%");
                    }

                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    gvUsers.DataSource = dt;
                    gvUsers.DataBind();

                    // 显示总数
                    lblTotalUsers.Text = dt.Rows.Count.ToString();
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载用户失败: " + ex.Message);
        }
    }

    /// <summary>
    /// GridView 行数据绑定事件 - 添加删除确认
    /// </summary>
    protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // 获取用户名
            string username = DataBinder.Eval(e.Row.DataItem, "Username").ToString();

            // 找到删除按钮
            LinkButton btnDelete = (LinkButton)e.Row.FindControl("btnDelete");
            if (btnDelete != null)
            {
                // 添加客户端确认脚本
                btnDelete.OnClientClick = "return confirmDelete('" + username + "');";
            }
        }
    }

    /// <summary>
    /// 搜索按钮点击事件
    /// </summary>
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string keyword = txtSearch.Text.Trim();
        LoadUsers(keyword);
    }

    /// <summary>
    /// 显示全部按钮点击事件
    /// </summary>
    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        LoadUsers();
    }

    /// <summary>
    /// 删除用户
    /// </summary>
    protected void gvUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int userId = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);

            // 获取用户名用于显示消息
            GridViewRow row = gvUsers.Rows[e.RowIndex];
            string username = row.Cells[1].Text; // Username 在第2列（索引1）

            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                // 先检查用户是否有订单
                string checkSql = "SELECT COUNT(*) FROM orderinfo WHERE UserId = @userId";
                using (MySqlCommand checkCmd = new MySqlCommand(checkSql, conn))
                {
                    checkCmd.Parameters.AddWithValue("@userId", userId);
                    int orderCount = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (orderCount > 0)
                    {
                        ShowMessage("用户【" + username + "】有 " + orderCount + " 个订单记录，无法删除！");
                        return;
                    }
                }

                // 删除用户
                string sql = "DELETE FROM userinfo WHERE id = @id AND Role = 'user'";
                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@id", userId);
                    int result = cmd.ExecuteNonQuery();

                    if (result > 0)
                    {
                        ShowMessage("用户【" + username + "】删除成功！");
                        LoadUsers(txtSearch.Text.Trim());
                    }
                    else
                    {
                        ShowMessage("删除失败！该用户可能不存在或不是普通会员。");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("删除失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 显示消息
    /// </summary>
    private void ShowMessage(string message)
    {
        string script = "alert('" + message.Replace("'", "\\'").Replace("\n", "\\n") + "');";
        ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
    }
}
