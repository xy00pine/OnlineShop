<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddOrderDet.aspx.cs" Inherits="AddOrderDet" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>订单详情 - 童装商城</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Helvetica Neue", Arial, "Microsoft YaHei", sans-serif; background: #f4f4f4; }
        
        .header { background: #fff; border-bottom: 1px solid #e5e5e5; padding: 20px 0; }
        .nav-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .logo { font-size: 24px; font-weight: bold; color: #ff0000; }
        
        .container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        
        .success-message { background: #fff; border-radius: 8px; padding: 40px; text-align: center; margin-bottom: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .success-icon { font-size: 80px; color: #52c41a; margin-bottom: 20px; }
        .success-message h2 { color: #333; margin-bottom: 10px; }
        .success-message p { color: #666; font-size: 16px; }
        
        .order-detail { background: #fff; border-radius: 8px; padding: 30px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .section-title { font-size: 18px; font-weight: bold; margin-bottom: 20px; color: #333; border-bottom: 2px solid #ff0000; padding-bottom: 10px; }
        
        .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 30px; }
        .info-item { padding: 15px; background: #f8f8f8; border-radius: 4px; }
        .info-label { font-size: 14px; color: #999; margin-bottom: 5px; }
        .info-value { font-size: 16px; color: #333; font-weight: 500; }
        
        .order-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .order-table thead { background: #f8f8f8; }
        .order-table th { padding: 12px; text-align: left; font-weight: 500; color: #666; border-bottom: 2px solid #e5e5e5; }
        .order-table td { padding: 15px 12px; border-bottom: 1px solid #f0f0f0; }
        
        .product-info { display: flex; align-items: center; gap: 15px; }
        .product-image { width: 60px; height: 60px; object-fit: cover; border-radius: 4px; }
        .product-name { font-size: 14px; color: #333; }
        .product-size { font-size: 12px; color: #999; margin-top: 3px; }
        
        .price { color: #ff0000; font-weight: bold; }
        
        .order-summary { background: #fff5f5; padding: 20px; border-radius: 8px; margin-top: 20px; }
        .summary-row { display: flex; justify-content: space-between; margin: 10px 0; font-size: 16px; }
        .summary-row.total { font-size: 20px; font-weight: bold; color: #ff0000; margin-top: 15px; padding-top: 15px; border-top: 2px solid #ffe5e5; }
        
        .action-buttons { margin-top: 30px; display: flex; gap: 15px; justify-content: center; }
        .btn { padding: 15px 40px; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background: #ff0000; color: #fff; }
        .btn-primary:hover { background: #cc0000; }
        .btn-secondary { background: #f5f5f5; color: #666; }
        .btn-secondary:hover { background: #e5e5e5; }
        
        .status-badge { display: inline-block; padding: 5px 15px; border-radius: 20px; font-size: 14px; }
        .status-0 { background: #fff7e6; color: #fa8c16; }
        .status-1 { background: #e6f7ff; color: #1890ff; }
        .status-2 { background: #f6ffed; color: #52c41a; }
        .status-3 { background: #fff1f0; color: #f5222d; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="nav-container">
                <div class="logo">👶 童装商城</div>
            </div>
        </div>

        <div class="container">
            <!-- 成功提示 -->
            <div class="success-message">
                <div class="success-icon">✓</div>
                <h2>订单提交成功！</h2>
                <p>您的订单已提交，我们会尽快为您处理</p>
            </div>

            <!-- 订单信息 -->
            <div class="order-detail">
                <div class="section-title">订单信息</div>
                
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">订单编号</div>
                        <div class="info-value"><asp:Label ID="lblOrderID" runat="server"></asp:Label></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">下单时间</div>
                        <div class="info-value"><asp:Label ID="lblCreateDate" runat="server"></asp:Label></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">订单状态</div>
                        <div class="info-value">
                            <asp:Label ID="lblStatus" runat="server" CssClass="status-badge"></asp:Label>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">收货人</div>
                        <div class="info-value"><asp:Label ID="lblAddressee" runat="server"></asp:Label></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">联系电话</div>
                        <div class="info-value"><asp:Label ID="lblTel" runat="server"></asp:Label></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">收货地址</div>
                        <div class="info-value"><asp:Label ID="lblAddress" runat="server"></asp:Label></div>
                    </div>
                </div>
            </div>

            <!-- 商品清单 -->
            <div class="order-detail">
                <div class="section-title">商品清单</div>
                
                <asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="False" 
                    CssClass="order-table" ShowHeader="true">
                    <Columns>
                        <asp:TemplateField HeaderText="商品信息">
                            <ItemTemplate>
                                <div class="product-info">
                                    <img src='<%# Eval("PictureUrl") %>' alt='<%# Eval("ProductName") %>' 
                                         class="product-image" onerror="this.src='/Images/default.jpg'" />
                                    <div>
                                        <div class="product-name"><%# Eval("ProductName") %></div>
                                        <div class="product-size">尺码: <%# Eval("size") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="单价">
                            <ItemTemplate>
                                <span class="price">¥<%# Eval("Price", "{0:F2}") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="数量">
                            <ItemTemplate>
                                ×<%# Eval("Number") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="小计">
                            <ItemTemplate>
                                <span class="price">¥<%# (Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Number"))).ToString("F2") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <!-- 订单汇总 -->
                <div class="order-summary">
                    <div class="summary-row">
                        <span>商品总数:</span>
                        <span><asp:Label ID="lblTotalNum" runat="server"></asp:Label> 件</span>
                    </div>
                    <div class="summary-row total">
                        <span>订单总额:</span>
                        <span>¥<asp:Label ID="lblTotalMoney" runat="server"></asp:Label></span>
                    </div>
                </div>
            </div>

            <!-- 操作按钮 -->
            <div class="action-buttons">
                <a href="MyOrders.aspx" class="btn btn-primary">查看我的订单</a>
                <a href="Default.aspx" class="btn btn-secondary">继续购物</a>
            </div>
        </div>
    </form>
</body>
</html>
