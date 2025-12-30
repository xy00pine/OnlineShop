using MySql.Data.MySqlClient;
using Org.BouncyCastle.Asn1.Cmp;
using System;
using System.Configuration;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Web;

public partial class userLogin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            pnlMessage.Visible = false;

            // 检查是否有注册成功消息
            if (Request.QueryString["msg"] != null)
            {
                string message = Server.UrlDecode(Request.QueryString["msg"]);
                ShowMessage(message, true);
            }

            // 检查是否有记住的用户名
            if (Request.Cookies["RememberUsername"] != null)
            {
                txtUsername.Text = Request.Cookies["RememberUsername"].Value;
                chkRemember.Checked = true;
            }

            // 如果已经登录，直接跳转到首页
            if (Session["UserId"] != null)
            {
                Response.Redirect("Default.aspx");
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }

        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text.Trim();

        try
        {
            // 验证用户
            var userInfo = ValidateUser(username, password);

            if (userInfo != null)
            {
                // 登录成功，设置 Session
                Session["UserId"] = userInfo.Id;
                Session["Username"] = userInfo.Username;
                Session["Role"] = userInfo.Role;
                Session["Email"] = userInfo.Email;

                // 处理"记住我"功能
                if (chkRemember.Checked)
                {
                    HttpCookie cookie = new HttpCookie("RememberUsername");
                    cookie.Value = username;
                    cookie.Expires = DateTime.Now.AddDays(30);
                    Response.Cookies.Add(cookie);
                }
                else
                {
                    // 清除 Cookie
                    if (Request.Cookies["RememberUsername"] != null)
                    {
                        HttpCookie cookie = new HttpCookie("RememberUsername");
                        cookie.Expires = DateTime.Now.AddDays(-1);
                        Response.Cookies.Add(cookie);
                    }
                }

                // 记录登录日志（可选）
                LogLoginActivity(userInfo.Id, username);

                // 根据角色跳转
                if (userInfo.Role == "admin")
                {
                    Response.Redirect("Admin/AdminDefault.aspx");
                }
                else
                {
                    // 检查是否有返回 URL
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        Response.Redirect(returnUrl);
                    }
                    else
                    {
                        Response.Redirect("Default.aspx");
                    }
                }
            }
            else
            {
                ShowMessage("用户名或密码错误，请重试", false);
            }
        }
        catch (Exception ex)
        {
            ShowMessage("登录失败: " + ex.Message, false);
        }
    }

    private UserInfo ValidateUser(string username, string password)
    {
        string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
        using (MySqlConnection conn = new MySqlConnection(connStr))
        {
            conn.Open();
            string sql = @"SELECT id, Username, Password, Role, Email 
                          FROM userInfo 
                          WHERE Username = @Username";

            using (MySqlCommand cmd = new MySqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Username", username);

                using (MySqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string storedPassword = reader["Password"].ToString();
                        string hashedPassword = HashPassword(password);

                        // 验证密码
                        if (storedPassword == hashedPassword)
                        {
                            return new UserInfo
                            {
                                Id = Convert.ToInt32(reader["id"]),
                                Username = reader["Username"].ToString(),
                                Role = reader["Role"].ToString(),
                                Email = reader["Email"] != DBNull.Value ? reader["Email"].ToString() : ""
                            };
                        }
                    }
                }
            }
        }
        return null;
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

    private void LogLoginActivity(int userId, string username)
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = @"INSERT INTO loginLog (UserId, Username, LoginTime, IpAddress) 
                              VALUES (@UserId, @Username, @LoginTime, @IpAddress)";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@LoginTime", DateTime.Now);
                    cmd.Parameters.AddWithValue("@IpAddress", GetClientIP());

                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch
        {
            // 记录日志失败不影响登录
        }
    }

    private string GetClientIP()
    {
        string ip = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        if (string.IsNullOrEmpty(ip))
        {
            ip = Request.ServerVariables["REMOTE_ADDR"];
        }
        return ip;
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        string cssClass = isSuccess ? "message-panel success-panel" : "message-panel error-panel";
        pnlMessage.CssClass = cssClass;
        pnlMessage.Controls.Clear();
        pnlMessage.Controls.Add(new System.Web.UI.LiteralControl(message));
        pnlMessage.Visible = true;
    }

    // 用户信息类
    private class UserInfo
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string Role { get; set; }
        public string Email { get; set; }
    }
}
