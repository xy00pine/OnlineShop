using System;
using System.Data;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class ProductDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int productId = 0;

            if (Request.QueryString["productId"] != null)
            {
                if (int.TryParse(Request.QueryString["productId"], out productId) && productId > 0)
                {
                    LoadProductDetail(productId);
                }
                else
                {
                    Response.Redirect("Default.aspx");
                }
            }
            else
            {
                Response.Redirect("Default.aspx");
            }
        }
    }

    /// <summary>
    /// 加载商品详情
    /// </summary>
    private void LoadProductDetail(int productId)
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                // 使用正确的字段名，并关联分类表
                string sql = @"SELECT p.id, p.Name, p.PictureUrl, p.Price, p.Brand, 
                              p.Size, p.ForAges, p.Stock, p.Description, 
                              c.Name as CategoryName
                              FROM productinfo p 
                              LEFT JOIN categoryinfo c ON p.CategoryID = c.id
                              WHERE p.id = @id AND p.Status = 1";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@id", productId);

                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // 显示商品信息（使用正确的字段名）
                            imgProduct.ImageUrl = reader["PictureUrl"].ToString();
                            lblProductName.Text = reader["Name"].ToString();
                            lblBrand.Text = reader["Brand"].ToString();
                            lblPrice.Text = "¥" + Convert.ToDecimal(reader["Price"]).ToString("F2");
                            lblCategory.Text = reader["CategoryName"] != DBNull.Value ? reader["CategoryName"].ToString() : "未分类";
                            lblForAges.Text = reader["ForAges"].ToString();
                            lblStock.Text = reader["Stock"].ToString();
                            lblDescription.Text = reader["Description"].ToString();

                            // 绑定尺码选择
                            string sizes = reader["Size"].ToString();
                            if (!string.IsNullOrEmpty(sizes))
                            {
                                string[] sizeArray = sizes.Split(',');
                                ddlSize.Items.Clear();
                                ddlSize.Items.Add(new ListItem("请选择尺码", ""));
                                foreach (string size in sizeArray)
                                {
                                    ddlSize.Items.Add(new ListItem(size.Trim(), size.Trim()));
                                }
                            }

                            // 检查库存
                            int stock = Convert.ToInt32(reader["Stock"]);
                            if (stock <= 0)
                            {
                                btnAddToCart.Enabled = false;
                                btnBuyNow.Enabled = false;
                                btnAddToCart.Text = "已售罄";
                                btnBuyNow.Text = "已售罄";
                                lblStock.Text = "0（已售罄）";
                                lblStock.ForeColor = System.Drawing.Color.Red;
                            }
                            else if (stock < 10)
                            {
                                lblStock.ForeColor = System.Drawing.Color.Orange;
                            }
                        }
                        else
                        {
                            ShowMessage("商品不存在或已下架");
                            Response.Redirect("Default.aspx");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载商品详情失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 加入购物车按钮点击事件
    /// </summary>
    protected void btnAddToCart_Click(object sender, EventArgs e)
    {
        try
        {
            // 检查是否登录
            if (Session["Username"] == null)
            {
                ShowMessageAndRedirect("请先登录", "userLogin.aspx");
                return;
            }

            // 获取商品ID
            int productId = Convert.ToInt32(Request.QueryString["productId"]);

            // 获取选择的尺码
            string selectedSize = ddlSize.SelectedValue;
            if (string.IsNullOrEmpty(selectedSize))
            {
                ShowMessage("请选择尺码");
                return;
            }

            // 获取数量
            int quantity = Convert.ToInt32(txtQuantity.Text);
            if (quantity <= 0)
            {
                ShowMessage("请输入有效的数量");
                return;
            }

            // 检查库存
            int stock = GetProductStock(productId);
            if (quantity > stock)
            {
                ShowMessage("库存不足，当前库存：" + stock.ToString());
                return;
            }

            // 获取或创建购物车
            DataTable cart = Session["ShoppingCart"] as DataTable;
            if (cart == null)
            {
                cart = CreateCartTable();
                Session["ShoppingCart"] = cart;
            }

            // 检查商品是否已在购物车中（相同商品相同尺码）
            string filterExpression = "ProductId = " + productId.ToString() + " AND Size = '" + selectedSize.Replace("'", "''") + "'";
            DataRow[] existingRows = cart.Select(filterExpression);

            if (existingRows.Length > 0)
            {
                // 更新数量
                int currentQty = Convert.ToInt32(existingRows[0]["Quantity"]);
                int newQty = currentQty + quantity;

                if (newQty > stock)
                {
                    ShowMessage("加入购物车失败，超出库存限制");
                    return;
                }

                existingRows[0]["Quantity"] = newQty;
                existingRows[0]["Subtotal"] = Convert.ToDecimal(existingRows[0]["Price"]) * newQty;
            }
            else
            {
                // 添加新行
                DataRow newRow = cart.NewRow();
                newRow["ProductId"] = productId;
                newRow["ProductName"] = lblProductName.Text;
                decimal price = Convert.ToDecimal(lblPrice.Text.Replace("¥", ""));
                newRow["Price"] = price;
                newRow["Quantity"] = quantity;
                newRow["Subtotal"] = price * quantity;
                newRow["Size"] = selectedSize;
                newRow["ImageUrl"] = imgProduct.ImageUrl;
                cart.Rows.Add(newRow);
            }

            Session["ShoppingCart"] = cart;
            ShowMessage("成功加入购物车！");
        }
        catch (Exception ex)
        {
            ShowMessage("加入购物车失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 创建购物车表结构
    /// </summary>
    private DataTable CreateCartTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("ProductId", typeof(int));
        dt.Columns.Add("ProductName", typeof(string));
        dt.Columns.Add("Price", typeof(decimal));
        dt.Columns.Add("Quantity", typeof(int));
        dt.Columns.Add("Subtotal", typeof(decimal));
        dt.Columns.Add("Size", typeof(string));
        dt.Columns.Add("ImageUrl", typeof(string));
        return dt;
    }

    /// <summary>
    /// 获取商品库存
    /// </summary>
    private int GetProductStock(int productId)
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT Stock FROM productinfo WHERE id = @id";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@id", productId);
                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }
        catch
        {
            return 0;
        }
    }

    /// <summary>
    /// 立即购买按钮点击事件
    /// </summary>
    protected void btnBuyNow_Click(object sender, EventArgs e)
    {
        try
        {
            // 检查是否登录
            if (Session["Username"] == null)
            {
                ShowMessageAndRedirect("请先登录", "userLogin.aspx");
                return;
            }

            // 获取选择的尺码
            string selectedSize = ddlSize.SelectedValue;
            if (string.IsNullOrEmpty(selectedSize))
            {
                ShowMessage("请选择尺码");
                return;
            }

            // 获取数量
            int quantity = Convert.ToInt32(txtQuantity.Text);
            if (quantity <= 0)
            {
                ShowMessage("请输入有效的数量");
                return;
            }

            // 检查库存
            int productId = Convert.ToInt32(Request.QueryString["productId"]);
            int stock = GetProductStock(productId);
            if (quantity > stock)
            {
                ShowMessage("库存不足，当前库存：" + stock.ToString());
                return;
            }

            // 先加入购物车
            btnAddToCart_Click(sender, e);

            // 跳转到购物车页面
            Response.Redirect("shoppingCart.aspx");
        }
        catch (Exception ex)
        {
            ShowMessage("操作失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 显示消息
    /// </summary>
    private void ShowMessage(string message)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + message + "');", true);
    }

    /// <summary>
    /// 显示消息并跳转
    /// </summary>
    private void ShowMessageAndRedirect(string message, string url)
    {
        string script = "alert('" + message + "'); window.location.href='" + url + "';";
        ClientScript.RegisterStartupScript(this.GetType(), "redirect", script, true);
    }
}
