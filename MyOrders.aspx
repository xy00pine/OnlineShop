<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MyOrders.aspx.cs" Inherits="MyOrders" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>我的订单 - 童装商城</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Helvetica Neue", Arial, "Microsoft YaHei", sans-serif; background: #f4f4f4; }
        
        .header { background: #fff; border-bottom: 1px solid #e5e5e5; padding: 20px 0; }
        .nav-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: bold; color: #ff0000; text-decoration: none; }
        .nav-links a { margin-left: 30px; color: #666; text-decoration: none; }
        .nav-links a:hover { color: #ff0000; }
        
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .page-title { font-size: 28px; margin-bottom: 30px; color: #333; }
        
        .order-list { background: #fff; border-radius: 8px; padding: 20px; }
        .order-item { border: 1px solid #e5e5e5; border-radius: 8px; margin-bottom: 20px; overflow: hidden; }
        
        .order-header { background: #f8f8f8; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e5e5e5; }
        .order-info { font-size: 14px; color: #666; }
        .order-info span { margin-right: 20px; }
        .order-status { font-weight: bold; }
        
        .status-badge { display: inline-block; padding: 4px 12px; border-radius: 12px; font-size: 12px; }
        .status-0 { background: #fff7e6; color: #fa8c16; }
        .status-1 { background: #e6f7ff; color: #1890ff; }
        .status-2 { background: #f6ffed; color: #52c41a; }
        .status-3 { background: #fff1f0; color: #f5222d; }
        
        .order-body { padding: 20px; }
        .order-products { display: flex; flex-direction: column; gap: 15px; }
        .product-row { display: flex; align-items: center; gap: 15px; padding: 10px; background: #fafafa; border-radius: 4px; }
        .product-image { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; }
        .product-details { flex: 1; }
        .product-name { font-size: 14px; color: #333; margin-bottom: 5px; }
        .product-meta { font-size: 12px; color: #999; }
        .product-price { font-size: 16px; color: #ff0000; font-weight: bold; margin: 0 20px; }
        .product-quantity { font-size: 14px; color: #666; }
        
        .order-footer { padding: 15px 20px; background: #fafafa; border-top: 1px solid #e5e5e5; display: flex; justify-content: space-between; align-items: center; }
        .order-total { font-size: 16px; color: #333; }
        .order-total .amount { font-size: 20px; color: #ff0000; font-weight: bold; margin-left: 10px; }
        
        .order-actions { display: flex; gap: 10px; }
        .btn { padding: 8px 20px; border: none; border-radius: 4px; font-size: 14px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-detail { background: #fff; color: #ff0000; border: 1px solid #ff0000; }
        .btn-detail:hover { background: #ff0000; color: #fff; }
        .btn-cancel { background: #f5f5f5; color: #666; }
        .btn-cancel:hover { background: #e5e5e5; }
        
        .empty-state { text-align: center; padding: 80px 20px; }
        .empty-icon { font-size: 80px; margin-bottom: 20px; }
        .empty-state h3 { color: #999; margin-bottom: 20px; }
        .btn-shop { background: #ff0000; color: #fff; padding: 12px 30px; }
        .btn-shop:hover { background: #cc0000; }
        
        .filter-bar { background: #fff; padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; gap: 15px; align-items: center; }
        .filter-bar label { font-size: 14px; color: #666; }
        .filter-bar select { padding: 8px 15px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="nav-container">
                <a href="Default.aspx" class="logo">👶 童装商城</a>
                <div class="nav-links">
                    <a href="Default.aspx">首页</a>
                    <a href="shoppingCart.aspx">购物车</a>
                    <a href="MyOrders.aspx">我的订单</a>
                </div>
            </div>
        </div>

        <div class="container">
            <h1 class="page-title">我的订单</h1>

            <!-- 筛选栏 -->
            <div class="filter-bar">
                <label>订单状态：</label>
                <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                    <asp:ListItem Value="-1" Selected="True">全部订单</asp:ListItem>
                    <asp:ListItem Value="0">待处理</asp:ListItem>
                    <asp:ListItem Value="1">已发货</asp:ListItem>
                    <asp:ListItem Value="2">已完成</asp:ListItem>
                    <asp:ListItem Value="3">已取消</asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- 订单列表 -->
            <asp:Panel ID="pnlOrders" runat="server" CssClass="order-list">
                <asp:Repeater ID="rptOrders" runat="server" OnItemCommand="rptOrders_ItemCommand" OnItemDataBound="rptOrders_ItemDataBound">
                    <ItemTemplate>
                        <div class="order-item">
                            <div class="order-header">
                                <div class="order-info">
                                    <span>订单号: <%# Eval("OrderID") %></span>
                                    <span>下单时间: <%# Eval("CreateDate", "{0:yyyy-MM-dd HH:mm}") %></span>
                                </div>
                                <div class="order-status">
                                    <span class='status-badge status-<%# Eval("Status") %>'>
                                        <%# GetStatusText(Eval("Status")) %>
                                    </span>
                                </div>
                            </div>
                            
                            <div class="order-body">
                                <div class="order-products">
                                    <asp:Repeater ID="rptOrderItems" runat="server">
                                        <ItemTemplate>
                                            <div class="product-row">
                                                <img src='<%# Eval("PictureUrl") %>' alt='<%# Eval("ProductName") %>' 
                                                     class="product-image" onerror="this.src='/Images/default.jpg'" />
                                                <div class="product-details">
                                                    <div class="product-name"><%# Eval("ProductName") %></div>
                                                    <div class="product-meta">尺码: <%# Eval("size") %></div>
                                                </div>
                                                <div class="product-price">¥<%# Eval("Price", "{0:F2}") %></div>
                                                <div class="product-quantity">×<%# Eval("Number") %></div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                            
                            <div class="order-footer">
                                <div class="order-total">
                                    共 <%# Eval("TotalNum") %> 件商品
                                    <span class="amount">¥<%# Eval("TotalMoney", "{0:F2}") %></span>
                                </div>
                                <div class="order-actions">
                                    <asp:LinkButton ID="btnViewDetail" runat="server" Text="查看详情" CssClass="btn btn-detail"
                                        CommandName="ViewDetail" CommandArgument='<%# Eval("OrderID") %>' />
                                    <asp:LinkButton ID="btnCancel" runat="server" Text="取消订单" CssClass="btn btn-cancel"
                                        CommandName="CancelOrder" CommandArgument='<%# Eval("OrderID") %>' 
                                        Visible='<%# Convert.ToInt32(Eval("Status")) == 0 %>'
                                        OnClientClick="return confirm('确定要取消这个订单吗？');" />
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

            <!-- 空状态 -->
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
                <div class="empty-icon">📦</div>
                <h3>暂无订单</h3>
                <p style="color:#999; margin-bottom:30px;">快去挑选心仪的商品吧</p>
                <a href="Default.aspx" class="btn btn-shop">去购物</a>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
