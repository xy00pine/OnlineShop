using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class AdminProductManage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 检查管理员权限
        if (Session["Username"] == null || Session["Role"] == null || Session["Role"].ToString() != "admin")
        {
            Response.Redirect("userLogin.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadCategories();
            LoadProducts();
        }
    }

    /// <summary>
    /// 加载分类列表
    /// </summary>
    private void LoadCategories()
    {
        try
        {
            string sql = "SELECT id, Name FROM categoryInfo ORDER BY id";
            DataTable dt = DBHelper.ExecuteQuery(sql);

            // 工具栏分类下拉框
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "id";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("全部分类", "0"));

            // 模态框分类下拉框
            ddlModalCategory.DataSource = dt;
            ddlModalCategory.DataTextField = "Name";
            ddlModalCategory.DataValueField = "id";
            ddlModalCategory.DataBind();
        }
        catch (Exception ex)
        {
            ShowMessage("加载分类失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 加载商品列表
    /// </summary>
    private void LoadProducts()
    {
        try
        {
            string sql = @"SELECT p.id, p.Name, p.PictureUrl, p.Price, p.Brand, p.Size, 
                          p.ForAges, p.Stock, p.Status, p.Description, p.CategoryID,
                          c.Name as CategoryName 
                          FROM productInfo p 
                          LEFT JOIN categoryInfo c ON p.CategoryID = c.id 
                          WHERE 1=1";

            // 搜索条件
            string searchText = txtSearch.Text.Trim();
            int categoryId = Convert.ToInt32(ddlCategory.SelectedValue);
            int status = Convert.ToInt32(ddlStatus.SelectedValue);

            if (!string.IsNullOrEmpty(searchText))
            {
                sql += " AND (p.Name LIKE @search OR p.Brand LIKE @search)";
            }
            if (categoryId > 0)
            {
                sql += " AND p.CategoryID = @categoryId";
            }
            if (status >= 0)
            {
                sql += " AND p.Status = @status";
            }

            sql += " ORDER BY p.id DESC";

            MySqlParameter[] parameters = {
                new MySqlParameter("@search", "%" + searchText + "%"),
                new MySqlParameter("@categoryId", categoryId),
                new MySqlParameter("@status", status)
            };

            DataTable dt = DBHelper.ExecuteQuery(sql, parameters);
            gvProducts.DataSource = dt;
            gvProducts.DataBind();
        }
        catch (Exception ex)
        {
            ShowMessage("加载商品列表失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 搜索按钮
    /// </summary>
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadProducts();
    }

    /// <summary>
    /// 重置按钮
    /// </summary>
    protected void btnReset_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        ddlCategory.SelectedIndex = 0;
        ddlStatus.SelectedIndex = 0;
        LoadProducts();
    }

    /// <summary>
    /// GridView行命令
    /// </summary>
    protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int productId = Convert.ToInt32(e.CommandArgument);

        switch (e.CommandName)
        {
            case "EditProduct":
                LoadProductForEdit(productId);
                break;

            case "ToggleStatus":
                ToggleProductStatus(productId);
                break;

            case "DeleteProduct":
                DeleteProduct(productId);
                break;
        }
    }

    /// <summary>
    /// GridView行数据绑定
    /// </summary>
    protected void gvProducts_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Button btnToggle = (Button)e.Row.FindControl("btnToggleStatus");
            if (btnToggle != null)
            {
                int status = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Status"));
                btnToggle.Text = status == 1 ? "下架" : "上架";
            }
        }
    }

    /// <summary>
    /// 加载商品信息用于编辑
    /// </summary>
    private void LoadProductForEdit(int productId)
    {
        try
        {
            string sql = "SELECT * FROM productInfo WHERE id = @id";
            MySqlParameter[] parameters = {
                new MySqlParameter("@id", productId)
            };

            DataTable dt = DBHelper.ExecuteQuery(sql, parameters);
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                hfProductId.Value = productId.ToString();
                txtName.Text = row["Name"].ToString();
                txtBrand.Text = row["Brand"].ToString();
                txtPrice.Text = row["Price"].ToString();
                txtStock.Text = row["Stock"].ToString();
                txtSize.Text = row["Size"].ToString();
                txtForAges.Text = row["ForAges"].ToString();
                txtPictureUrl.Text = row["PictureUrl"].ToString();
                txtDescription.Text = row["Description"].ToString();
                ddlModalCategory.SelectedValue = row["CategoryID"].ToString();
                ddlModalStatus.SelectedValue = row["Status"].ToString();

                lblModalTitle.Text = "编辑商品";
                litShowModal.Text = "<script>showAddModal();</script>";
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载商品信息失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 切换商品状态
    /// </summary>
    private void ToggleProductStatus(int productId)
    {
        try
        {
            string sql = "UPDATE productInfo SET Status = 1 - Status WHERE id = @id";
            MySqlParameter[] parameters = {
                new MySqlParameter("@id", productId)
            };

            int result = DBHelper.ExecuteNonQuery(sql, parameters);
            if (result > 0)
            {
                ShowMessage("状态更新成功");
                LoadProducts();
            }
        }
        catch (Exception ex)
        {
            ShowMessage("更新状态失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 删除商品
    /// </summary>
    private void DeleteProduct(int productId)
    {
        try
        {
            string sql = "DELETE FROM productInfo WHERE id = @id";
            MySqlParameter[] parameters = {
                new MySqlParameter("@id", productId)
            };

            int result = DBHelper.ExecuteNonQuery(sql, parameters);
            if (result > 0)
            {
                ShowMessage("删除成功");
                LoadProducts();
            }
        }
        catch (Exception ex)
        {
            ShowMessage("删除失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 保存商品
    /// </summary>
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            int productId = Convert.ToInt32(hfProductId.Value);
            string name = txtName.Text.Trim();
            string brand = txtBrand.Text.Trim();
            decimal price = Convert.ToDecimal(txtPrice.Text);
            int stock = Convert.ToInt32(txtStock.Text);
            string size = txtSize.Text.Trim();
            string forAges = txtForAges.Text.Trim();
            string pictureUrl = txtPictureUrl.Text.Trim();
            string description = txtDescription.Text.Trim();
            int categoryId = Convert.ToInt32(ddlModalCategory.SelectedValue);
            int status = Convert.ToInt32(ddlModalStatus.SelectedValue);

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(brand))
            {
                ShowMessage("请填写必填项");
                return;
            }

            string sql;
            if (productId == 0)
            {
                // 添加
                sql = @"INSERT INTO productInfo (Name, Brand, Price, Stock, Size, ForAges, 
                       PictureUrl, Description, CategoryID, Status) 
                       VALUES (@name, @brand, @price, @stock, @size, @forAges, 
                       @pictureUrl, @description, @categoryId, @status)";
            }
            else
            {
                // 编辑
                sql = @"UPDATE productInfo SET Name=@name, Brand=@brand, Price=@price, 
                       Stock=@stock, Size=@size, ForAges=@forAges, PictureUrl=@pictureUrl, 
                       Description=@description, CategoryID=@categoryId, Status=@status 
                       WHERE id=@id";
            }

            MySqlParameter[] parameters = {
                new MySqlParameter("@name", name),
                new MySqlParameter("@brand", brand),
                new MySqlParameter("@price", price),
                new MySqlParameter("@stock", stock),
                new MySqlParameter("@size", size),
                new MySqlParameter("@forAges", forAges),
                new MySqlParameter("@pictureUrl", pictureUrl),
                new MySqlParameter("@description", description),
                new MySqlParameter("@categoryId", categoryId),
                new MySqlParameter("@status", status),
                new MySqlParameter("@id", productId)
            };

            int result = DBHelper.ExecuteNonQuery(sql, parameters);
            if (result > 0)
            {
                ShowMessage("保存成功");
                ClearForm();
                LoadProducts();
                litShowModal.Text = "<script>hideModal();</script>";
            }
        }
        catch (Exception ex)
        {
            ShowMessage("保存失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 清空表单
    /// </summary>
    private void ClearForm()
    {
        hfProductId.Value = "0";
        txtName.Text = "";
        txtBrand.Text = "";
        txtPrice.Text = "";
        txtStock.Text = "";
        txtSize.Text = "";
        txtForAges.Text = "";
        txtPictureUrl.Text = "";
        txtDescription.Text = "";
        ddlModalCategory.SelectedIndex = 0;
        ddlModalStatus.SelectedIndex = 0;
        lblModalTitle.Text = "添加商品";
    }

    /// <summary>
    /// 退出登录
    /// </summary>
    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Response.Redirect("userLogin.aspx");
    }

    /// <summary>
    /// 显示消息
    /// </summary>
    private void ShowMessage(string message)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + message + "');", true);
    }

}