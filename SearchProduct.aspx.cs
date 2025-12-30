using MySql.Data.MySqlClient;
using MySqlX.XDevAPI.Relational;
using System;
using System.Configuration;
using System.Data;
using System.Web.UI;

public partial class SearchProduct : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 如果URL中有搜索关键词，直接搜索
            string keyword = Request.QueryString["keyword"];
            if (!string.IsNullOrEmpty(keyword))
            {
                txtSearch.Text = keyword;
                SearchProducts(keyword);
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string keyword = txtSearch.Text.Trim();
        if (string.IsNullOrEmpty(keyword))
        {
            ShowMessage("请输入搜索关键词！");
            return;
        }
        SearchProducts(keyword);
    }

    private void SearchProducts(string keyword)
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();

                string sql = @"SELECT ProductId, ProductName, Price, ProductImage 
                              FROM productinfo 
                              WHERE Status = 1 
                              AND ProductName LIKE @keyword 
                              ORDER BY ProductId DESC";

                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@keyword", "%" + keyword + "%");

                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        dlProducts.DataSource = dt;
                        dlProducts.DataBind();

                        lblResultCount.Text = dt.Rows.Count.ToString();
                        pnlResult.Visible = true;
                        pnlNoResult.Visible = false;
                    }
                    else
                    {
                        pnlResult.Visible = false;
                        pnlNoResult.Visible = true;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("搜索失败: " + ex.Message);
        }
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Response.Redirect("Default.aspx");
    }

    private void ShowMessage(string message)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + message + "');", true);
    }
}
