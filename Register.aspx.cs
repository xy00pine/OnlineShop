using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

public partial class Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            pnlError.Visible = false;
        }
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }

        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text.Trim();
        string email = txtEmail.Text.Trim();
        string phone = txtPhone.Text.Trim();

        try
        {
            // 检查用户名是否已存在
            if (IsUsernameExists(username))
            {
                ShowError("该用户名已被注册，请使用其他用户名");
                return;
            }

            // 密码加密
            string hashedPassword = HashPassword(password);

            // 插入数据库
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = @"INSERT INTO userInfo (Username, Password, Email, Phone, Address, RegisterTime, Role) 
                              VALUES (@Username, @Password, @Email, @Phone, @Address, @RegisterTime, @Role)";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(email) ? (object)DBNull.Value : email);
                    cmd.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);
                    cmd.Parameters.AddWithValue("@Address", DBNull.Value);
                    cmd.Parameters.AddWithValue("@RegisterTime", DateTime.Now);
                    cmd.Parameters.AddWithValue("@Role", "user");

                    int result = cmd.ExecuteNonQuery();

                    if (result > 0)
                    {
                        // 注册成功，跳转到登录页
                        Response.Redirect("userLogin.aspx?msg=注册成功，请登录");
                    }
                    else
                    {
                        ShowError("注册失败，请稍后重试");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowError("注册失败: " + ex.Message);
        }
    }

    private bool IsUsernameExists(string username)
    {
        string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
        using (MySqlConnection conn = new MySqlConnection(connStr))
        {
            conn.Open();
            string sql = "SELECT COUNT(*) FROM userInfo WHERE Username = @Username";
            using (MySqlCommand cmd = new MySqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Username", username);
                int count = Convert.ToInt32(cmd.ExecuteScalar());
                return count > 0;
            }
        }
    }

    private string HashPassword(string password)
    {
        using (SHA256 sha256 = SHA256.Create())
        {
            byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
            StringBuilder builder = new StringBuilder();
            foreach (byte b in bytes)
            {
                builder.Append(b.ToString("x2"));
            }
            return builder.ToString();
        }
    }

    private void ShowError(string message)
    {
        lblError.Text = message;
        pnlError.Visible = true;
    }
}
