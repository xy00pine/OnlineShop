using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class AdminCategoryManage : System.Web.UI.Page
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
            LoadCategories();
        }
    }

    /// <summary>
    /// 加载分类列表
    /// </summary>
    private void LoadCategories()
    {
        try
        {
            string sql = "SELECT id, Name, Description, CreateDate FROM categoryInfo ORDER BY id";
            DataTable dt = DBHelper.ExecuteQuery(sql);

            gvCategories.DataSource = dt;
            gvCategories.DataBind();
        }
        catch (Exception ex)
        {
            ShowMessage("加载分类列表失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 获取分类下的商品数量
    /// </summary>
    protected int GetProductCount(object categoryId)
    {
        try
        {
            string sql = "SELECT COUNT(*) FROM productInfo WHERE CategoryID = @categoryId";
            MySqlParameter[] parameters = {
                new MySqlParameter("@categoryId", categoryId)
            };

            object result = DBHelper.ExecuteScalar(sql, parameters);
            return result != null ? Convert.ToInt32(result) : 0;
        }
        catch
        {
            return 0;
        }
    }

    /// <summary>
    /// GridView行命令
    /// </summary>
    protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int categoryId = Convert.ToInt32(e.CommandArgument);

        switch (e.CommandName)
        {
            case "EditCategory":
                LoadCategoryForEdit(categoryId);
                break;

            case "DeleteCategory":
                DeleteCategory(categoryId);
                break;
        }
    }

    /// <summary>
    /// 加载分类信息用于编辑
    /// </summary>
    private void LoadCategoryForEdit(int categoryId)
    {
        try
        {
            string sql = "SELECT id, Name, Description FROM categoryInfo WHERE id = @id";
            MySqlParameter[] parameters = {
                new MySqlParameter("@id", categoryId)
            };

            DataTable dt = DBHelper.ExecuteQuery(sql, parameters);
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                hfCategoryId.Value = categoryId.ToString();
                txtName.Text = row["Name"].ToString();
                txtDescription.Text = row["Description"].ToString();

                lblModalTitle.Text = "编辑分类";
                litShowModal.Text = "<script>showAddModal();</script>";
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载分类信息失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 删除分类
    /// </summary>
    private void DeleteCategory(int categoryId)
    {
        try
        {
            // 检查是否有商品使用该分类
            string sqlCheck = "SELECT COUNT(*) FROM productInfo WHERE CategoryID = @categoryId";
            MySqlParameter[] checkParams = {
                new MySqlParameter("@categoryId", categoryId)
            };

            object count = DBHelper.ExecuteScalar(sqlCheck, checkParams);
            if (count != null && Convert.ToInt32(count) > 0)
            {
                ShowMessage("该分类下还有商品，无法删除！");
                return;
            }

            // 删除分类
            string sql = "DELETE FROM categoryInfo WHERE id = @id";
            MySqlParameter[] parameters = {
                new MySqlParameter("@id", categoryId)
            };

            int result = DBHelper.ExecuteNonQuery(sql, parameters);
            if (result > 0)
            {
                ShowMessage("删除成功");
                LoadCategories();
            }
        }
        catch (Exception ex)
        {
            ShowMessage("删除失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 保存分类
    /// </summary>
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        try
        {
            int categoryId = Convert.ToInt32(hfCategoryId.Value);
            string name = txtName.Text.Trim();
            string description = txtDescription.Text.Trim();

            if (string.IsNullOrEmpty(name))
            {
                ShowMessage("请输入分类名称");
                return;
            }

            string sql;
            if (categoryId == 0)
            {
                // 添加
                sql = "INSERT INTO categoryInfo (Name, Description, CreateDate) VALUES (@name, @description, NOW())";
            }
            else
            {
                // 编辑
                sql = "UPDATE categoryInfo SET Name=@name, Description=@description WHERE id=@id";
            }

            MySqlParameter[] parameters = {
                new MySqlParameter("@name", name),
                new MySqlParameter("@description", description),
                new MySqlParameter("@id", categoryId)
            };

            int result = DBHelper.ExecuteNonQuery(sql, parameters);
            if (result > 0)
            {
                ShowMessage("保存成功");
                ClearForm();
                LoadCategories();
                litShowModal.Text = "<script>hideModal();</script>";
            }
        }
        catch (Exception ex)
        {
            ShowMessage("保存失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 清空表单
    /// </summary>
    private void ClearForm()
    {
        hfCategoryId.Value = "0";
        txtName.Text = "";
        txtDescription.Text = "";
        lblModalTitle.Text = "添加分类";
    }

    /// <summary>
    /// 退出登录
    /// </summary>
    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Response.Redirect("userLogin.aspx");
    }

    /// <summary>
    /// 显示消息
    /// </summary>
    private void ShowMessage(string message)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + message + "');", true);
    }
}
