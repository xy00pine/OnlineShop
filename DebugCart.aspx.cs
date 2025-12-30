using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Text;

public partial class DebugCart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CheckSession();
            CheckConnection();
            CheckCartRawData();
            CheckCartJoinData();
            CheckProducts();
        }
    }

    private void CheckSession()
    {
        StringBuilder sb = new StringBuilder();

        if (Session["UserId"] != null)
        {
            sb.Append("<div class='success'>");
            sb.Append("<strong>✓ 用户已登录</strong><br/>");
            sb.Append("UserId: " + Session["UserId"] + "<br/>");
            if (Session["Username"] != null)
            {
                sb.Append("Username: " + Session["Username"] + "<br/>");
            }
            if (Session["Role"] != null)
            {
                sb.Append("Role: " + Session["Role"] + "<br/>");
            }
            sb.Append("</div>");
        }
        else
        {
            sb.Append("<div class='error'>");
            sb.Append("<strong>✗ 用户未登录</strong><br/>");
            sb.Append("Session[\"UserId\"] 为空<br/>");
            sb.Append("<a href='userLogin.aspx'>点击登录</a>");
            sb.Append("</div>");
        }

        lblSession.Text = sb.ToString();
    }

    private void CheckConnection()
    {
        StringBuilder sb = new StringBuilder();

        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            sb.Append("<div class='info'>");
            sb.Append("<strong>连接字符串:</strong><br/>");
            sb.Append("<div class='code'>" + connStr + "</div>");
            sb.Append("</div>");

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                sb.Append("<div class='success'>");
                sb.Append("<strong>✓ 数据库连接成功</strong><br/>");
                sb.Append("数据库: " + conn.Database + "<br/>");
                sb.Append("服务器: " + conn.DataSource);
                sb.Append("</div>");
            }
        }
        catch (Exception ex)
        {
            sb.Append("<div class='error'>");
            sb.Append("<strong>✗ 数据库连接失败</strong><br/>");
            sb.Append("错误: " + ex.Message);
            sb.Append("</div>");
        }

        lblConnection.Text = sb.ToString();
    }

    private void CheckCartRawData()
    {
        StringBuilder sb = new StringBuilder();

        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                string sql = "SELECT * FROM shoppingcart";
                if (Session["UserId"] != null)
                {
                    sql += " WHERE UserId = @UserId";
                }

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (Session["UserId"] != null)
                    {
                        cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                    }

                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    sb.Append("<div class='info'>");
                    sb.Append("<strong>查询结果:</strong> 找到 " + dt.Rows.Count + " 条记录<br/>");
                    sb.Append("<strong>SQL:</strong> <div class='code'>" + sql + "</div>");
                    sb.Append("</div>");

                    if (dt.Rows.Count > 0)
                    {
                        gvCartRaw.DataSource = dt;
                        gvCartRaw.DataBind();
                    }
                    else
                    {
                        sb.Append("<div class='error'>购物车表中没有数据</div>");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            sb.Append("<div class='error'>");
            sb.Append("<strong>✗ 查询失败</strong><br/>");
            sb.Append("错误: " + ex.Message + "<br/>");
            sb.Append("详细: " + ex.ToString().Replace("\n", "<br/>"));
            sb.Append("</div>");
        }

        lblCartRaw.Text = sb.ToString();
    }

    private void CheckCartJoinData()
    {
        StringBuilder sb = new StringBuilder();

        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                string sql = @"SELECT 
                                c.id AS CartId,
                                c.UserId,
                                c.ProductId,
                                c.Quantity,
                                c.AddTime,
                                p.id AS ProductInfoId,
                                p.Name,
                                p.Price,
                                p.PictureUrl,
                                p.Stock,
                                (c.Quantity * p.Price) AS Subtotal
                              FROM shoppingcart c
                              LEFT JOIN productinfo p ON c.ProductId = p.id";

                if (Session["UserId"] != null)
                {
                    sql += " WHERE c.UserId = @UserId";
                }

                sql += " ORDER BY c.AddTime DESC";

                lblSQL.Text = "<div class='code'>" + sql + "</div>";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (Session["UserId"] != null)
                    {
                        cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                    }

                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    sb.Append("<div class='info'>");
                    sb.Append("<strong>关联查询结果:</strong> 找到 " + dt.Rows.Count + " 条记录<br/>");
                    sb.Append("<strong>列数:</strong> " + dt.Columns.Count + "<br/>");
                    sb.Append("<strong>列名:</strong> ");
                    foreach (DataColumn col in dt.Columns)
                    {
                        sb.Append(col.ColumnName + " (" + col.DataType.Name + "), ");
                    }
                    sb.Append("</div>");

                    if (dt.Rows.Count > 0)
                    {
                        gvCartJoin.DataSource = dt;
                        gvCartJoin.DataBind();

                        // 检查是否有 NULL 值
                        sb.Append("<div class='info'><strong>数据检查:</strong><br/>");
                        foreach (DataRow row in dt.Rows)
                        {
                            if (row["Name"] == DBNull.Value || row["Name"] == null)
                            {
                                sb.Append("<div class='error'>⚠ ProductId " + row["ProductId"] + " 的商品信息不存在！</div>");
                            }
                        }
                        sb.Append("</div>");
                    }
                    else
                    {
                        sb.Append("<div class='error'>关联查询没有返回数据</div>");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            sb.Append("<div class='error'>");
            sb.Append("<strong>✗ 关联查询失败</strong><br/>");
            sb.Append("错误: " + ex.Message + "<br/>");
            sb.Append("详细: " + ex.ToString().Replace("\n", "<br/>"));
            sb.Append("</div>");
        }

        lblCartJoin.Text = sb.ToString();
    }

    private void CheckProducts()
    {
        StringBuilder sb = new StringBuilder();

        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                string sql = "SELECT id, Name, Price, Stock, PictureUrl, Status FROM productinfo LIMIT 10";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    sb.Append("<div class='info'>");
                    sb.Append("<strong>商品总数:</strong> " + dt.Rows.Count + " 条（显示前10条）");
                    sb.Append("</div>");

                    if (dt.Rows.Count > 0)
                    {
                        gvProducts.DataSource = dt;
                        gvProducts.DataBind();
                    }
                    else
                    {
                        sb.Append("<div class='error'>商品表中没有数据</div>");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            sb.Append("<div class='error'>");
            sb.Append("<strong>✗ 查询商品失败</strong><br/>");
            sb.Append("错误: " + ex.Message);
            sb.Append("</div>");
        }

        lblProducts.Text = sb.ToString();
    }
}
