using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Configuration;

public partial class _Default : System.Web.UI.Page
{
    private int selectedCategoryId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 获取URL中的分类ID
            if (Request.QueryString["categoryId"] != null)
            {
                int.TryParse(Request.QueryString["categoryId"], out selectedCategoryId);
            }

            LoadCategories();
            LoadProducts(selectedCategoryId);
        }
    }

    /// <summary>
    /// 加载商品分类（用于导航和标签）
    /// </summary>
    private void LoadCategories()
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                // 修改：使用实际的字段名 id 和 Name
                string sql = "SELECT id as CategoryId, Name as CategoryName FROM categoryinfo ORDER BY id";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    // 绑定到导航栏
                    rptNavCategories.DataSource = dt;
                    rptNavCategories.DataBind();

                    // 绑定到分类标签
                    rptCategories.DataSource = dt;
                    rptCategories.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载分类失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 加载商品列表
    /// </summary>
    private void LoadProducts(int categoryId = 0)
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                // 修改：使用实际的字段名
                string sql = @"SELECT p.id as ProductId, 
                                      p.Name as ProductName, 
                                      p.Price, 
                                      p.Stock, 
                                      p.PictureUrl as ProductImage, 
                                      p.Description, 
                                      c.Name as CategoryName
                              FROM productinfo p
                              LEFT JOIN categoryinfo c ON p.CategoryID = c.id
                              WHERE p.Status = 1";

                if (categoryId > 0)
                {
                    sql += " AND p.CategoryID = @categoryId";
                }

                sql += " ORDER BY p.id DESC";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (categoryId > 0)
                    {
                        cmd.Parameters.AddWithValue("@categoryId", categoryId);
                    }

                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptProducts.DataSource = dt;
                        rptProducts.DataBind();

                        lblProductCount.Text = dt.Rows.Count.ToString();
                        pnlProducts.Visible = true;
                        pnlNoProducts.Visible = false;

                        // 更新分类标题
                        if (categoryId > 0 && dt.Rows.Count > 0)
                        {
                            lblCategoryTitle.Text = dt.Rows[0]["CategoryName"].ToString();
                        }
                        else
                        {
                            lblCategoryTitle.Text = "全部商品";
                        }
                    }
                    else
                    {
                        pnlProducts.Visible = false;
                        pnlNoProducts.Visible = true;
                        lblProductCount.Text = "0";
                        lblCategoryTitle.Text = categoryId > 0 ? "该分类" : "全部商品";
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载商品失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 分类点击事件
    /// </summary>
    protected void lnkCategory_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        int categoryId = Convert.ToInt32(btn.CommandArgument);
        selectedCategoryId = categoryId;
        LoadProducts(categoryId);
    }

    /// <summary>
    /// 显示全部商品
    /// </summary>
    protected void lnkAllCategories_Click(object sender, EventArgs e)
    {
        selectedCategoryId = 0;
        LoadProducts(0);
    }

    /// <summary>
    /// 快速搜索
    /// </summary>
    protected void btnQuickSearch_Click(object sender, EventArgs e)
    {
        string keyword = txtQuickSearch.Text.Trim();
        if (!string.IsNullOrEmpty(keyword))
        {
            Response.Redirect("SearchProduct.aspx?keyword=" + Server.UrlEncode(keyword));
        }
        else
        {
            ShowMessage("请输入搜索关键词");
        }
    }

    /// <summary>
    /// 商品命令事件（加入购物车）
    /// </summary>
    protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "AddToCart")
        {
            // 检查是否登录
            if (Session["Username"] == null)
            {
                ShowMessage("请先登录后再购买商品");
                Response.Redirect("userLogin.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            int productId = Convert.ToInt32(e.CommandArgument);
            AddToCart(productId);
        }
    }

    /// <summary>
    /// 添加商品到购物车
    /// </summary>
    private void AddToCart(int productId)
    {
        try
        {
            // 获取或创建购物车
            DataTable cart = Session["ShoppingCart"] as DataTable;
            if (cart == null)
            {
                cart = CreateCartTable();
                Session["ShoppingCart"] = cart;
            }

            // 获取商品信息（使用实际字段名）
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = @"SELECT id as ProductId, 
                                      Name as ProductName, 
                                      Price, 
                                      Stock, 
                                      PictureUrl as ProductImage 
                              FROM productinfo 
                              WHERE id = @productId AND Status = 1";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@productId", productId);

                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int stock = Convert.ToInt32(reader["Stock"]);
                            if (stock <= 0)
                            {
                                ShowMessage("该商品库存不足");
                                return;
                            }

                            // 检查购物车中是否已存在该商品
                            DataRow[] existingRows = cart.Select("ProductId = " + productId);
                            if (existingRows.Length > 0)
                            {
                                // 增加数量
                                int currentQty = Convert.ToInt32(existingRows[0]["Quantity"]);
                                if (currentQty >= stock)
                                {
                                    ShowMessage("已达到该商品的最大库存数量");
                                    return;
                                }
                                existingRows[0]["Quantity"] = currentQty + 1;
                                existingRows[0]["Subtotal"] = (currentQty + 1) * Convert.ToDecimal(reader["Price"]);
                            }
                            else
                            {
                                // 添加新商品
                                DataRow row = cart.NewRow();
                                row["ProductId"] = reader["ProductId"];
                                row["ProductName"] = reader["ProductName"];
                                row["Price"] = reader["Price"];
                                row["Quantity"] = 1;
                                row["Subtotal"] = reader["Price"];
                                row["ProductImage"] = reader["ProductImage"];
                                cart.Rows.Add(row);
                            }

                            Session["ShoppingCart"] = cart;
                            ShowMessageAndRedirect("商品已加入购物车！是否立即查看？", "ShoppingCart.aspx");
                        }
                        else
                        {
                            ShowMessage("商品不存在或已下架");
                        }
                    }
                }
            }
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
        dt.Columns.Add("ProductImage", typeof(string));
        return dt;
    }

    /// <summary>
    /// 退出登录
    /// </summary>
    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Response.Redirect("Default.aspx");
    }

    /// <summary>
    /// 获取当前选中的分类ID
    /// </summary>
    protected int GetSelectedCategoryId()
    {
        if (Request.QueryString["categoryId"] != null)
        {
            int.TryParse(Request.QueryString["categoryId"], out selectedCategoryId);
        }
        return selectedCategoryId;
    }

    /// <summary>
    /// 获取简短描述（用于页面显示）
    /// </summary>
    protected string GetShortDescription(object description)
    {
        if (description == null || string.IsNullOrEmpty(description.ToString()))
            return "暂无描述";

        string desc = description.ToString();
        return desc.Length > 40 ? desc.Substring(0, 40) + "..." : desc;
    }

    /// <summary>
    /// 显示消息
    /// </summary>
    private void ShowMessage(string message)
    {
        string script = "alert('" + message.Replace("'", "\\'") + "');";
        ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
    }

    /// <summary>
    /// 显示确认消息并跳转
    /// </summary>
    private void ShowMessageAndRedirect(string message, string url)
    {
        string script = "if(confirm('" + message.Replace("'", "\\'") + "')) { window.location.href='" + url + "'; }";
        ClientScript.RegisterStartupScript(this.GetType(), "confirm", script, true);
    }
}
