using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class MyOrders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 检查是否登录
            if (Session["Username"] == null)
            {
                Response.Redirect("userLogin.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            LoadOrders();
        }
    }

    /// <summary>
    /// 加载订单列表
    /// </summary>
    private void LoadOrders(int status = -1)
    {
        try
        {
            string username = Session["Username"].ToString();
            string sql = @"SELECT OrderID, TotalMoney, TotalNum, CreateDate, Status 
                          FROM orderInfo 
                          WHERE UserName = @username";

            if (status >= 0)
            {
                sql += " AND Status = @status";
            }

            sql += " ORDER BY CreateDate DESC";

            MySqlParameter[] parameters = {
                new MySqlParameter("@username", username),
                new MySqlParameter("@status", status)
            };

            DataTable dt = DBHelper.ExecuteQuery(sql, parameters);

            if (dt.Rows.Count > 0)
            {
                rptOrders.DataSource = dt;
                rptOrders.DataBind();
                pnlOrders.Visible = true;
                pnlEmpty.Visible = false;
            }
            else
            {
                pnlOrders.Visible = false;
                pnlEmpty.Visible = true;
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载订单失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 获取订单商品明细
    /// </summary>
    protected DataTable GetOrderItems(object orderId)
    {
        try
        {
            string sql = @"SELECT oi.Number, oi.Price, oi.size, 
                          p.Name as ProductName, p.PictureUrl 
                          FROM orderItem oi 
                          LEFT JOIN productInfo p ON oi.ProductID = p.id 
                          WHERE oi.OrderID = @orderId";

            MySqlParameter[] parameters = {
                new MySqlParameter("@orderId", orderId.ToString())
            };

            return DBHelper.ExecuteQuery(sql, parameters);
        }
        catch
        {
            return new DataTable();
        }
    }

    /// <summary>
    /// Repeater 数据绑定事件
    /// </summary>
    protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DataRowView drv = (DataRowView)e.Item.DataItem;
            string orderId = drv["OrderID"].ToString();

            Repeater rptOrderItems = (Repeater)e.Item.FindControl("rptOrderItems");
            if (rptOrderItems != null)
            {
                rptOrderItems.DataSource = GetOrderItems(orderId);
                rptOrderItems.DataBind();
            }
        }
    }

    /// <summary>
    /// 获取状态文本
    /// </summary>
    protected string GetStatusText(object status)
    {
        int statusValue = Convert.ToInt32(status);
        switch (statusValue)
        {
            case 0: return "待处理";
            case 1: return "已发货";
            case 2: return "已完成";
            case 3: return "已取消";
            default: return "未知";
        }
    }

    /// <summary>
    /// 订单状态筛选
    /// </summary>
    protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        int status = Convert.ToInt32(ddlStatus.SelectedValue);
        LoadOrders(status);
    }

    /// <summary>
    /// 订单操作
    /// </summary>
    protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string orderId = e.CommandArgument.ToString();

        switch (e.CommandName)
        {
            case "ViewDetail":
                Response.Redirect("AddOrderDet.aspx?orderId=" + orderId);
                break;

            case "CancelOrder":
                CancelOrder(orderId);
                break;
        }
    }

    /// <summary>
    /// 取消订单
    /// </summary>
    private void CancelOrder(string orderId)
    {
        try
        {
            // 更新订单状态为已取消
            string sql = "UPDATE orderInfo SET Status = 3 WHERE OrderID = @orderId AND Status = 0";
            MySqlParameter[] parameters = {
                new MySqlParameter("@orderId", orderId)
            };

            int result = DBHelper.ExecuteNonQuery(sql, parameters);

            if (result > 0)
            {
                // 恢复库存
                string sqlItems = "SELECT ProductID, Number FROM orderItem WHERE OrderID = @orderId";
                DataTable dtItems = DBHelper.ExecuteQuery(sqlItems, parameters);

                foreach (DataRow row in dtItems.Rows)
                {
                    string sqlUpdateStock = "UPDATE productInfo SET Stock = Stock + @quantity WHERE id = @productId";
                    MySqlParameter[] stockParams = {
                        new MySqlParameter("@quantity", row["Number"]),
                        new MySqlParameter("@productId", row["ProductID"])
                    };
                    DBHelper.ExecuteNonQuery(sqlUpdateStock, stockParams);
                }

                ShowMessage("订单已取消");
                LoadOrders();
            }
            else
            {
                ShowMessage("取消订单失败，订单可能已处理");
            }
        }
        catch (Exception ex)
        {
            ShowMessage("取消订单失败: " + ex.Message);
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
