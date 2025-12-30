using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminOrderManage : System.Web.UI.Page
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
            LoadOrders();
        }
    }

    /// <summary>
    /// 加载订单列表
    /// </summary>
    private void LoadOrders()
    {
        try
        {
            string sql = @"SELECT OrderID, TotalMoney, TotalNum, UserName, Addressee, 
                          Address, Tel, CreateDate, Status, Remark 
                          FROM orderInfo 
                          WHERE 1=1";

            // 搜索条件
            string searchText = txtSearch.Text.Trim();
            int status = Convert.ToInt32(ddlStatus.SelectedValue);

            if (!string.IsNullOrEmpty(searchText))
            {
                sql += " AND (OrderID LIKE @search OR Addressee LIKE @search)";
            }
            if (status >= 0)
            {
                sql += " AND Status = @status";
            }

            sql += " ORDER BY CreateDate DESC";

            MySqlParameter[] parameters = {
                new MySqlParameter("@search", "%" + searchText + "%"),
                new MySqlParameter("@status", status)
            };

            DataTable dt = DBHelper.ExecuteQuery(sql, parameters);
            gvOrders.DataSource = dt;
            gvOrders.DataBind();
        }
        catch (Exception ex)
        {
            ShowMessage("加载订单列表失败: " + ex.Message);
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
    /// 搜索按钮
    /// </summary>
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadOrders();
    }

    /// <summary>
    /// 重置按钮
    /// </summary>
    protected void btnReset_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        ddlStatus.SelectedIndex = 0;
        LoadOrders();
    }

    /// <summary>
    /// GridView行命令
    /// </summary>
    protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string orderId = e.CommandArgument.ToString();

        switch (e.CommandName)
        {
            case "ViewDetail":
                LoadOrderDetail(orderId);
                break;

            case "ShipOrder":
                UpdateOrderStatus(orderId, 1, "订单已发货");
                break;

            case "CompleteOrder":
                UpdateOrderStatus(orderId, 2, "订单已完成");
                break;

            case "CancelOrder":
                CancelOrder(orderId);
                break;
        }
    }

    /// <summary>
    /// GridView行数据绑定
    /// </summary>
    protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        // 可以在这里添加额外的行处理逻辑
    }

    /// <summary>
    /// 加载订单详情
    /// </summary>
    private void LoadOrderDetail(string orderId)
    {
        try
        {
            // 查询订单主信息
            string sqlOrder = @"SELECT OrderID, TotalMoney, TotalNum, UserName, Addressee, 
                               Address, Tel, CreateDate, Status, Remark 
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
                lblUserName.Text = order["UserName"].ToString();
                lblAddressee.Text = order["Addressee"].ToString();
                lblTel.Text = order["Tel"].ToString();
                lblAddress.Text = order["Address"].ToString();
                lblTotalMoney.Text = Convert.ToDecimal(order["TotalMoney"]).ToString("F2");
                lblTotalNum.Text = order["TotalNum"].ToString();
                lblRemark.Text = string.IsNullOrEmpty(order["Remark"].ToString()) ? "无" : order["Remark"].ToString();

                // 设置订单状态
                int status = Convert.ToInt32(order["Status"]);
                lblStatus.Text = GetStatusText(status);
                lblStatus.CssClass = "status-badge status-" + status;

                // 查询订单详情
                string sqlItems = @"SELECT oi.Number, oi.Price, oi.size, 
                                   p.Name as ProductName 
                                   FROM orderItem oi 
                                   LEFT JOIN productInfo p ON oi.ProductID = p.id 
                                   WHERE oi.OrderID = @orderId";

                DataTable dtItems = DBHelper.ExecuteQuery(sqlItems, orderParams);
                gvOrderItems.DataSource = dtItems;
                gvOrderItems.DataBind();

                litShowModal.Text = "<script>document.getElementById('orderDetailModal').classList.add('show');</script>";
            }
        }
        catch (Exception ex)
        {
            ShowMessage("加载订单详情失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 更新订单状态
    /// </summary>
    private void UpdateOrderStatus(string orderId, int status, string message)
    {
        try
        {
            string sql = "UPDATE orderInfo SET Status = @status WHERE OrderID = @orderId";
            MySqlParameter[] parameters = {
                new MySqlParameter("@status", status),
                new MySqlParameter("@orderId", orderId)
            };

            int result = DBHelper.ExecuteNonQuery(sql, parameters);
            if (result > 0)
            {
                ShowMessage(message);
                LoadOrders();
            }
        }
        catch (Exception ex)
        {
            ShowMessage("更新订单状态失败: " + ex.Message);
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
            string sql = "UPDATE orderInfo SET Status = 3 WHERE OrderID = @orderId";
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

                ShowMessage("订单已取消，库存已恢复");
                LoadOrders();
            }
        }
        catch (Exception ex)
        {
            ShowMessage("取消订单失败: " + ex.Message);
        }
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
