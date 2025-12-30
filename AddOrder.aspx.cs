using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Configuration;

public partial class AddOrder : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 检查是否登录
        if (Session["Username"] == null)
        {
            Response.Redirect("userLogin.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        if (!IsPostBack)
        {
            LoadOrderData();
        }
    }

    /// <summary>
    /// 加载订单数据
    /// </summary>
    private void LoadOrderData()
    {
        // 从Session获取要结算的购物车数据
        DataTable cart = Session["ShoppingCart"] as DataTable;

        if (cart == null || cart.Rows.Count == 0)
        {
            pnlEmptyCart.Visible = true;
            pnlOrderContent.Visible = false;
            return;
        }

        // 绑定商品列表
        rptOrderItems.DataSource = cart;
        rptOrderItems.DataBind();

        // 计算订单金额
        decimal subtotal = 0;
        int totalItems = 0;

        foreach (DataRow row in cart.Rows)
        {
            subtotal += Convert.ToDecimal(row["Subtotal"]);
            totalItems += Convert.ToInt32(row["Quantity"]);
        }

        decimal shipping = subtotal >= 299 ? 0 : 10; // 满299免运费
        decimal total = subtotal + shipping;

        lblTotalItems.Text = totalItems.ToString();
        lblSubtotal.Text = subtotal.ToString("F2");
        lblShipping.Text = shipping.ToString("F2");
        lblTotal.Text = total.ToString("F2");

        pnlEmptyCart.Visible = false;
        pnlOrderContent.Visible = true;
    }

    /// <summary>
    /// 提交订单
    /// </summary>
    protected void btnSubmitOrder_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        try
        {
            // 获取购物车数据
            DataTable cart = Session["ShoppingCart"] as DataTable;

            if (cart == null || cart.Rows.Count == 0)
            {
                ShowMessage("购物车为空，无法提交订单");
                return;
            }

            // 获取当前用户名
            string username = Session["Username"].ToString();

            // 计算订单总金额和总数量
            decimal totalMoney = 0;
            int totalNum = 0;
            foreach (DataRow row in cart.Rows)
            {
                totalMoney += Convert.ToDecimal(row["Subtotal"]);
                totalNum += Convert.ToInt32(row["Quantity"]);
            }

            // 添加运费
            if (totalMoney < 299)
            {
                totalMoney += 10;
            }

            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                MySqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 生成订单号（格式：yyyyMMddHHmmss + 4位随机数）
                    string orderId = DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(1000, 9999);

                    // 1. 插入订单主表
                    string sqlOrder = @"INSERT INTO orderinfo 
                                       (OrderID, UserName, TotalMoney, TotalNum, Status, 
                                        Addressee, Tel, Address, CreateDate) 
                                       VALUES 
                                       (@OrderID, @UserName, @TotalMoney, @TotalNum, 0, 
                                        @Addressee, @Tel, @Address, NOW())";

                    using (MySqlCommand cmd = new MySqlCommand(sqlOrder, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@OrderID", orderId);
                        cmd.Parameters.AddWithValue("@UserName", username);
                        cmd.Parameters.AddWithValue("@TotalMoney", totalMoney);
                        cmd.Parameters.AddWithValue("@TotalNum", totalNum);
                        cmd.Parameters.AddWithValue("@Addressee", txtReceiverName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Tel", txtReceiverPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@Address", txtReceiverAddress.Text.Trim());

                        cmd.ExecuteNonQuery();
                    }

                    // 2. 插入订单详情表（使用实际字段名：Number 代替 Quantity）
                    string sqlOrderItem = @"INSERT INTO orderitem 
                                           (OrderID, ProductID, Number, Price) 
                                           VALUES 
                                           (@OrderID, @ProductID, @Number, @Price)";

                    foreach (DataRow row in cart.Rows)
                    {
                        using (MySqlCommand cmd = new MySqlCommand(sqlOrderItem, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@OrderID", orderId);
                            cmd.Parameters.AddWithValue("@ProductID", row["ProductId"]);
                            cmd.Parameters.AddWithValue("@Number", row["Quantity"]); // Quantity 映射到 Number
                            cmd.Parameters.AddWithValue("@Price", row["Price"]);
                            cmd.ExecuteNonQuery();
                        }

                        // 3. 更新商品库存
                        string sqlUpdateStock = @"UPDATE productinfo 
                                                 SET Stock = Stock - @Quantity 
                                                 WHERE id = @ProductID";
                        using (MySqlCommand cmd = new MySqlCommand(sqlUpdateStock, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Quantity", row["Quantity"]);
                            cmd.Parameters.AddWithValue("@ProductID", row["ProductId"]);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    // 提交事务
                    transaction.Commit();

                    // 清空购物车
                    Session["ShoppingCart"] = null;

                    // 跳转到订单成功页面
                    Response.Redirect("OrderSuccess.aspx?orderId=" + orderId);
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    throw new Exception("订单提交失败: " + ex.Message);
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("提交订单失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 显示消息
    /// </summary>
    private void ShowMessage(string message)
    {
        string script = "alert('" + message.Replace("'", "\\'") + "');";
        ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
    }
}
