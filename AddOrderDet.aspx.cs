using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;

public partial class AddOrderDet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 检查是否登录
            if (Session["Username"] == null)
            {
                Response.Redirect("userLogin.aspx");
                return;
            }

            // 获取订单ID
            if (Request.QueryString["orderId"] != null)
            {
                string orderId = Request.QueryString["orderId"];
                LoadOrderDetail(orderId);
            }
            else
            {
                Response.Redirect("MyOrders.aspx");
            }
        }
    }

    /// <summary>
    /// 加载订单详情
    /// </summary>
    private void LoadOrderDetail(string orderId)
    {
        try
        {
            // 查询订单主信息
            string sqlOrder = @"SELECT OrderID, TotalMoney, TotalNum, CreateDate, 
                               Addressee, Address, Tel, Status 
                               FROM orderInfo 
                               WHERE OrderID = @orderId";

            MySqlParameter[] orderParams = {
                new MySqlParameter("@orderId", orderId)
            };

            DataTable dtOrder = DBHelper.ExecuteQuery(sqlOrder, orderParams);

            if (dtOrder.Rows.Count > 0)
            {
                DataRow order = dtOrder.Rows[0];

                lblOrderID.Text = order["OrderID"].ToString();
                lblCreateDate.Text = Convert.ToDateTime(order["CreateDate"]).ToString("yyyy-MM-dd HH:mm:ss");
                lblAddressee.Text = order["Addressee"].ToString();
                lblTel.Text = order["Tel"].ToString();
                lblAddress.Text = order["Address"].ToString();
                lblTotalMoney.Text = Convert.ToDecimal(order["TotalMoney"]).ToString("F2");
                lblTotalNum.Text = order["TotalNum"].ToString();

                // 设置订单状态
                int status = Convert.ToInt32(order["Status"]);
                SetOrderStatus(status);

                // 查询订单详情
                LoadOrderItems(orderId);
            }
            else
            {
                ShowMessage("订单不存在");
                Response.Redirect("MyOrders.aspx");
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载订单详情失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 设置订单状态显示
    /// </summary>
    private void SetOrderStatus(int status)
    {
        switch (status)
        {
            case 0:
                lblStatus.Text = "待处理";
                lblStatus.CssClass = "status-badge status-0";
                break;
            case 1:
                lblStatus.Text = "已发货";
                lblStatus.CssClass = "status-badge status-1";
                break;
            case 2:
                lblStatus.Text = "已完成";
                lblStatus.CssClass = "status-badge status-2";
                break;
            case 3:
                lblStatus.Text = "已取消";
                lblStatus.CssClass = "status-badge status-3";
                break;
            default:
                lblStatus.Text = "未知状态";
                break;
        }
    }

    /// <summary>
    /// 加载订单商品明细
    /// </summary>
    private void LoadOrderItems(string orderId)
    {
        try
        {
            string sql = @"SELECT oi.id, oi.Number, oi.Price, oi.size, 
                          p.Name as ProductName, p.PictureUrl 
                          FROM orderItem oi 
                          LEFT JOIN productInfo p ON oi.ProductID = p.id 
                          WHERE oi.OrderID = @orderId";

            MySqlParameter[] parameters = {
                new MySqlParameter("@orderId", orderId)
            };

            DataTable dt = DBHelper.ExecuteQuery(sql, parameters);
            gvOrderItems.DataSource = dt;
            gvOrderItems.DataBind();
        }
        catch (Exception ex)
        {
            ShowMessage("加载订单商品失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 显示消息
    /// </summary>
    private void ShowMessage(string message)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + message + "');", true);
    }
}
