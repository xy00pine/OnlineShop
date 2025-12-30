using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;

public partial class AdminuserLogin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 如果已经登录且是管理员，跳转到管理首页
            if (Session["Username"] != null && Session["Role"] != null && Session["Role"].ToString() == "admin")
            {
                Response.Redirect("AdminManage.aspx");
            }
        }
    }

    /// <summary>
    /// 登录按钮点击事件
    /// </summary>
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        try
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            // 查询管理员信息（只允许管理员登录）
            string sql = "SELECT id, Username, Role, Email FROM userInfo WHERE Username = @username AND Password = @password AND Role = 'admin'";

            MySqlParameter[] parameters = {
                new MySqlParameter("@username", username),
                new MySqlParameter("@password", password)
            };

            DataTable dt = DBHelper.ExecuteQuery(sql, parameters);

            if (dt.Rows.Count > 0)
            {
                // 登录成功
                DataRow admin = dt.Rows[0];
                Session["UserId"] = admin["id"];
                Session["Username"] = admin["Username"];
                Session["Role"] = admin["Role"];
                Session["Email"] = admin["Email"];

                Response.Redirect("AdminManage.aspx");
            }
            else
            {
                // 登录失败
                ShowError("管理员账号或密码错误");
            }
        }
        catch (Exception ex)
        {
            ShowError("登录失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 显示错误信息
    /// </summary>
    private void ShowError(string message)
    {
        pnlError.Visible = true;
        lblError.Text = message;
    }
}
