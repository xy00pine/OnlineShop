using System;
using MySql.Data.MySqlClient;
using System.Configuration;

public partial class OrderSuccess : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string orderIdStr = Request.QueryString["orderId"];
            if (!string.IsNullOrEmpty(orderIdStr))
            {
                LoadOrderInfo(orderIdStr);
            }
            else
            {
                Response.Redirect("Default.aspx");
            }
        }
    }

    private void LoadOrderInfo(string orderId)
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                // 使用实际的字段名
                string sql = "SELECT OrderID, TotalMoney, CreateDate FROM orderinfo WHERE OrderID = @OrderID";
                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@OrderID", orderId);

                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblOrderId.Text = reader["OrderID"].ToString();
                            lblTotalMoney.Text = Convert.ToDecimal(reader["TotalMoney"]).ToString("F2");
                            lblOrderTime.Text = Convert.ToDateTime(reader["CreateDate"]).ToString("yyyy-MM-dd HH:mm:ss");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            lblOrderId.Text = "加载失败: " + ex.Message;
        }
    }
}
