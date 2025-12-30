using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ShoppingCart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCart();
        }
    }

    /// <summary>
    /// 加载购物车
    /// </summary>
    private void LoadCart()
    {
        DataTable cart = Session["ShoppingCart"] as DataTable;

        if (cart == null || cart.Rows.Count == 0)
        {
            pnlEmptyCart.Visible = true;
            pnlCartContent.Visible = false;
            return;
        }

        // 绑定购物车商品
        rptCartItems.DataSource = cart;
        rptCartItems.DataBind();

        // 计算总价
        CalculateTotal(cart);

        pnlEmptyCart.Visible = false;
        pnlCartContent.Visible = true;
    }

    /// <summary>
    /// 计算总价
    /// </summary>
    private void CalculateTotal(DataTable cart)
    {
        decimal subtotal = 0;
        int totalItems = 0;

        foreach (DataRow row in cart.Rows)
        {
            subtotal += Convert.ToDecimal(row["Subtotal"]);
            totalItems += Convert.ToInt32(row["Quantity"]);
        }

        decimal shipping = subtotal >= 299 ? 0 : 10;
        decimal total = subtotal + shipping;

        lblTotalItems.Text = totalItems.ToString();
        lblSubtotal.Text = subtotal.ToString("F2");
        lblShipping.Text = shipping.ToString("F2");
        lblTotal.Text = total.ToString("F2");
    }

    /// <summary>
    /// 购物车商品操作
    /// </summary>
    protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int productId = Convert.ToInt32(e.CommandArgument);
        DataTable cart = Session["ShoppingCart"] as DataTable;

        if (cart == null) return;

        DataRow[] rows = cart.Select("ProductId = " + productId);
        if (rows.Length == 0) return;

        DataRow row = rows[0];

        switch (e.CommandName)
        {
            case "Increase":
                int newQty = Convert.ToInt32(row["Quantity"]) + 1;
                row["Quantity"] = newQty;
                row["Subtotal"] = newQty * Convert.ToDecimal(row["Price"]);
                break;

            case "Decrease":
                int currentQty = Convert.ToInt32(row["Quantity"]);
                if (currentQty > 1)
                {
                    newQty = currentQty - 1;
                    row["Quantity"] = newQty;
                    row["Subtotal"] = newQty * Convert.ToDecimal(row["Price"]);
                }
                break;

            case "Remove":
                cart.Rows.Remove(row);
                break;
        }

        Session["ShoppingCart"] = cart;
        LoadCart();
    }

    /// <summary>
    /// 退出登录
    /// </summary>
    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Response.Redirect("Default.aspx");
    }
}
