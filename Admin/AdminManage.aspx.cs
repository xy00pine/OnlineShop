using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;
using System.Configuration;

public partial class AdminManage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 检查是否登录且是管理员
        if (Session["Username"] == null || Session["Role"] == null || Session["Role"].ToString() != "admin")
        {
            Response.Redirect("userLogin.aspx");
            return;
        }

        if (!IsPostBack)
        {
            lblUsername.Text = Session["Username"].ToString();
            LoadStatistics();
        }
    }

    private void LoadStatistics()
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                // 商品总数
                string sql1 = "SELECT COUNT(*) FROM productinfo";
                using (MySqlCommand cmd = new MySqlCommand(sql1, conn))
                {
                    object result = cmd.ExecuteScalar();
                    lblProductCount.Text = result != null ? result.ToString() : "0";
                }

                // 订单总数
                string sql2 = "SELECT COUNT(*) FROM orderinfo";
                using (MySqlCommand cmd = new MySqlCommand(sql2, conn))
                {
                    object result = cmd.ExecuteScalar();
                    lblOrderCount.Text = result != null ? result.ToString() : "0";
                }

                // 会员总数（排除管理员）
                string sql3 = "SELECT COUNT(*) FROM userinfo WHERE Role = 'user'";
                using (MySqlCommand cmd = new MySqlCommand(sql3, conn))
                {
                    object result = cmd.ExecuteScalar();
                    lblUserCount.Text = result != null ? result.ToString() : "0";
                }

                // 类别总数
                string sql4 = "SELECT COUNT(*) FROM categoryinfo";
                using (MySqlCommand cmd = new MySqlCommand(sql4, conn))
                {
                    object result = cmd.ExecuteScalar();
                    lblCategoryCount.Text = result != null ? result.ToString() : "0";
                }
            }
        }
        catch (Exception ex)
        {
            Response.Write("<script>alert('加载统计数据失败: " + ex.Message.Replace("'", "\\'") + "');</script>");
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("userLogin.aspx");
    }
}
