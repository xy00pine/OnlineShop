using MySql.Data.MySqlClient;
using Org.BouncyCastle.Asn1.Cmp;
using System;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;

public partial class TestAddCart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 设置当前登录用户ID
            if (Session["UserId"] != null)
            {
                txtUserId.Text = Session["UserId"].ToString();
            }

            LoadProducts();
            LoadCartData();
        }
    }

    private void LoadProducts()
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT id, Name, Price FROM productinfo WHERE Status = 1 ORDER BY id";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    MySqlDataReader reader = cmd.ExecuteReader();
                    ddlProduct.Items.Clear();
                    ddlProduct.Items.Add(new ListItem("-- 请选择商品 --", "0"));

                    while (reader.Read())
                    {
                        string text = reader["id"] + " - " + reader["Name"] + " (¥" + reader["Price"] + ")";
                        string value = reader["id"].ToString();
                        ddlProduct.Items.Add(new ListItem(text, value));
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载商品失败: " + ex.Message, false);
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        try
        {
            int userId = Convert.ToInt32(txtUserId.Text);
            int productId = Convert.ToInt32(ddlProduct.SelectedValue);
            int quantity = Convert.ToInt32(txtQuantity.Text);

            if (productId == 0)
            {
                ShowMessage("请选择商品", false);
                return;
            }

            if (quantity <= 0)
            {
                ShowMessage("数量必须大于0", false);
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                // 检查商品是否存在
                string checkProductSql = "SELECT Stock FROM productinfo WHERE id = @ProductId";
                using (MySqlCommand checkCmd = new MySqlCommand(checkProductSql, conn))
                {
                    checkCmd.Parameters.AddWithValue("@ProductId", productId);
                    object stockObj = checkCmd.ExecuteScalar();

                    if (stockObj == null)
                    {
                        ShowMessage("商品不存在", false);
                        return;
                    }

                    int stock = Convert.ToInt32(stockObj);
                    if (stock < quantity)
                    {
                        ShowMessage("库存不足，当前库存: " + stock, false);
                        return;
                    }
                }

                // 检查购物车中是否已存在
                string checkCartSql = "SELECT id, Quantity FROM shoppingcart WHERE UserId = @UserId AND ProductId = @ProductId";
                using (MySqlCommand checkCmd = new MySqlCommand(checkCartSql, conn))
                {
                    checkCmd.Parameters.AddWithValue("@UserId", userId);
                    checkCmd.Parameters.AddWithValue("@ProductId", productId);

                    using (MySqlDataReader reader = checkCmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // 已存在，更新数量
                            int cartId = reader.GetInt32(0);
                            int oldQuantity = reader.GetInt32(1);
                            reader.Close();

                            string updateSql = "UPDATE shoppingcart SET Quantity = Quantity + @Quantity WHERE id = @CartId";
                            using (MySqlCommand updateCmd = new MySqlCommand(updateSql, conn))
                            {
                                updateCmd.Parameters.AddWithValue("@Quantity", quantity);
                                updateCmd.Parameters.AddWithValue("@CartId", cartId);
                                int result = updateCmd.ExecuteNonQuery();

                                ShowMessage("更新成功！数量: " + oldQuantity + " → " + (oldQuantity + quantity) + " (影响行数: " + result + ")", true);
                            }
                        }
                        else
                        {
                            reader.Close();

                            // 不存在，插入新记录
                            string insertSql = "INSERT INTO shoppingcart (UserId, ProductId, Quantity, AddTime) VALUES (@UserId, @ProductId, @Quantity, NOW())";
                            using (MySqlCommand insertCmd = new MySqlCommand(insertSql, conn))
                            {
                                insertCmd.Parameters.AddWithValue("@UserId", userId);
                                insertCmd.Parameters.AddWithValue("@ProductId", productId);
                                insertCmd.Parameters.AddWithValue("@Quantity", quantity);
                                int result = insertCmd.ExecuteNonQuery();

                                ShowMessage("添加成功！(影响行数: " + result + ")", true);
                            }
                        }
                    }
                }
            }

            LoadCartData();
        }
        catch (Exception ex)
        {
            ShowMessage("操作失败: " + ex.Message + "<br/>详细: " + ex.ToString(), false);
        }
    }

    private void LoadCartData()
    {
        try
        {
            int userId = Convert.ToInt32(txtUserId.Text);
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                string sql = @"SELECT 
                                c.id AS CartId,
                                c.ProductId,
                                p.Name AS ProductName,
                                c.Quantity,
                                p.Price,
                                (c.Quantity * p.Price) AS Subtotal,
                                c.AddTime
                              FROM shoppingcart c
                              INNER JOIN productinfo p ON c.ProductId = p.id
                              WHERE c.UserId = @UserId
                              ORDER BY c.AddTime DESC";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    gvCart.DataSource = dt;
                    gvCart.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载购物车数据失败: " + ex.Message, false);
        }
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        lblMessage.Text = message;
        pnlMessage.CssClass = isSuccess ? "message success" : "message error";
        pnlMessage.Visible = true;
    }
}
