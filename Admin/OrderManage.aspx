
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderManage.aspx.cs" Inherits="AdminOrderManage" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>订单管理 - 管理后台</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Helvetica Neue", Arial, "Microsoft YaHei", sans-serif; background: #f0f2f5; }
        
        .top-nav { background: #001529; color: #fff; padding: 0 20px; display: flex; justify-content: space-between; align-items: center; height: 64px; box-shadow: 0 2px 8px rgba(0,0,0,0.15); }
        .logo { font-size: 20px; font-weight: bold; }
        .user-info { display: flex; align-items: center; gap: 20px; }
        .user-info a { color: #fff; text-decoration: none; padding: 8px 16px; border-radius: 4px; transition: all 0.3s; }
        .user-info a:hover { background: rgba(255,255,255,0.1); }
        
        .main-container { display: flex; min-height: calc(100vh - 64px); }
        
        .sidebar { width: 250px; background: #fff; box-shadow: 2px 0 8px rgba(0,0,0,0.05); }
        .menu { list-style: none; padding: 20px 0; }
        .menu-item { padding: 15px 30px; cursor: pointer; transition: all 0.3s; border-left: 3px solid transparent; }
        .menu-item:hover { background: #e6f7ff; border-left-color: #1890ff; }
        .menu-item.active { background: #e6f7ff; border-left-color: #1890ff; color: #1890ff; font-weight: 500; }
        .menu-item a { text-decoration: none; color: inherit; display: block; }
        
        .content { flex: 1; padding: 30px; }
        .page-header { background: #fff; padding: 24px; border-radius: 8px; margin-bottom: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .page-title { font-size: 24px; color: #333; }
        
        .toolbar { background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; gap: 15px; align-items: center; }
        .toolbar input, .toolbar select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .toolbar input { flex: 1; max-width: 300px; }
        
        .btn { padding: 8px 20px; border: none; border-radius: 4px; font-size: 14px; cursor: pointer; transition: all 0.3s; text-decoration: none; display: inline-block; }
        .btn-primary { background: #1890ff; color: #fff; }
        .btn-primary:hover { background: #40a9ff; }
        .btn-success { background: #52c41a; color: #fff; }
        .btn-success:hover { background: #73d13d; }
        .btn-danger { background: #f5222d; color: #fff; }
        .btn-danger:hover { background: #ff4d4f; }
        .btn-warning { background: #fa8c16; color: #fff; }
        .btn-warning:hover { background: #ffa940; }
        
        .data-table { background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); overflow: hidden; }
        .data-table table { width: 100%; border-collapse: collapse; }
        .data-table thead { background: #fafafa; }
        .data-table th { padding: 16px; text-align: left; font-weight: 500; color: #666; border-bottom: 1px solid #e8e8e8; }
        .data-table td { padding: 16px; border-bottom: 1px solid #f0f0f0; }
        .data-table tr:hover { background: #fafafa; }
        
        .status-badge { padding: 4px 12px; border-radius: 12px; font-size: 12px; }
        .status-0 { background: #fff7e6; color: #fa8c16; }
        .status-1 { background: #e6f7ff; color: #1890ff; }
        .status-2 { background: #f6ffed; color: #52c41a; }
        .status-3 { background: #fff1f0; color: #f5222d; }
        
        .action-buttons { display: flex; gap: 8px; flex-wrap: wrap; }
        
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
        .modal.show { display: flex; }
        .modal-content { background: #fff; border-radius: 8px; width: 90%; max-width: 800px; max-height: 90vh; overflow-y: auto; }
        .modal-header { padding: 20px; border-bottom: 1px solid #e8e8e8; display: flex; justify-content: space-between; align-items: center; }
        .modal-title { font-size: 20px; font-weight: bold; }
        .modal-close { font-size: 24px; cursor: pointer; color: #999; }
        .modal-body { padding: 20px; }
        
        .order-detail-section { margin-bottom: 30px; }
        .section-title { font-size: 16px; font-weight: bold; margin-bottom: 15px; color: #333; border-bottom: 2px solid #1890ff; padding-bottom: 8px; }
        .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .info-item { padding: 12px; background: #fafafa; border-radius: 4px; }
        .info-label { font-size: 12px; color: #999; margin-bottom: 5px; }
        .info-value { font-size: 14px; color: #333; font-weight: 500; }
        
        .order-items-table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .order-items-table th { background: #fafafa; padding: 10px; text-align: left; font-size: 14px; color: #666; }
        .order-items-table td { padding: 10px; border-bottom: 1px solid #f0f0f0; font-size: 14px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="top-nav">
            <div class="logo">👶 童装商城 - 管理后台</div>
            <div class="user-info">
                <a href="AdminManage.aspx">返回首页</a>
                <asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">退出登录</asp:LinkButton>
            </div>
        </div>

        <div class="main-container">
            <div class="sidebar">
                <ul class="menu">
                    <li class="menu-item"><a href="AdminManage.aspx">📊 数据概览</a></li>
                    <li class="menu-item"><a href="ProductManage.aspx">📦 商品管理</a></li>
                    <li class="menu-item"><a href="CategoryManage.aspx">🏷️ 分类管理</a></li>
                    <li class="menu-item active"><a href="OrderManage.aspx">📋 订单管理</a></li>
                    <li class="menu-item"><a href="UserManage.aspx">👥 会员管理</a></li>
                </ul>
            </div>

            <div class="content">
                <div class="page-header">
                    <h1 class="page-title">订单管理</h1>
                </div>

                <div class="toolbar">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="搜索订单号或收货人"></asp:TextBox>
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Value="-1">全部状态</asp:ListItem>
                        <asp:ListItem Value="0">待处理</asp:ListItem>
                        <asp:ListItem Value="1">已发货</asp:ListItem>
                        <asp:ListItem Value="2">已完成</asp:ListItem>
                        <asp:ListItem Value="3">已取消</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="重置" CssClass="btn" OnClick="btnReset_Click" />
                </div>

                <div class="data-table">
                    <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" 
                        OnRowCommand="gvOrders_RowCommand" OnRowDataBound="gvOrders_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="订单号" />
                            <asp:BoundField DataField="UserName" HeaderText="用户名" />
                            <asp:BoundField DataField="Addressee" HeaderText="收货人" />
                            <asp:BoundField DataField="Tel" HeaderText="联系电话" />
                            
                            <asp:TemplateField HeaderText="订单金额">
                                <ItemTemplate>
                                    ¥<%# Eval("TotalMoney", "{0:F2}") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="商品数量">
                                <ItemTemplate>
                                    <%# Eval("TotalNum") %> 件
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="下单时间">
                                <ItemTemplate>
                                    <%# Eval("CreateDate", "{0:yyyy-MM-dd HH:mm}") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="状态">
                                <ItemTemplate>
                                    <span class='status-badge status-<%# Eval("Status") %>'>
                                        <%# GetStatusText(Eval("Status")) %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="操作">
                                <ItemTemplate>
                                    <div class="action-buttons">
                                        <asp:Button ID="btnViewDetail" runat="server" Text="查看详情" CssClass="btn btn-primary"
                                            CommandName="ViewDetail" CommandArgument='<%# Eval("OrderID") %>' />
                                        <asp:Button ID="btnShip" runat="server" Text="发货" CssClass="btn btn-success"
                                            CommandName="ShipOrder" CommandArgument='<%# Eval("OrderID") %>'
                                            Visible='<%# Convert.ToInt32(Eval("Status")) == 0 %>' />
                                        <asp:Button ID="btnComplete" runat="server" Text="完成" CssClass="btn btn-warning"
                                            CommandName="CompleteOrder" CommandArgument='<%# Eval("OrderID") %>'
                                            Visible='<%# Convert.ToInt32(Eval("Status")) == 1 %>' />
                                        <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn btn-danger"
                                            CommandName="CancelOrder" CommandArgument='<%# Eval("OrderID") %>'
                                            Visible='<%# Convert.ToInt32(Eval("Status")) == 0 %>'
                                            OnClientClick="return confirm('确定要取消这个订单吗？');" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state">
                                <p>暂无订单数据</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- 订单详情模态框 -->
        <div id="orderDetailModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">订单详情</h3>
                    <span class="modal-close" onclick="hideModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <!-- 订单基本信息 -->
                    <div class="order-detail-section">
                        <div class="section-title">订单信息</div>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">订单号</div>
                                <div class="info-value"><asp:Label ID="lblOrderID" runat="server"></asp:Label></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">下单时间</div>
                                <div class="info-value"><asp:Label ID="lblCreateDate" runat="server"></asp:Label></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">订单状态</div>
                                <div class="info-value"><asp:Label ID="lblStatus" runat="server" CssClass="status-badge"></asp:Label></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">用户名</div>
                                <div class="info-value"><asp:Label ID="lblUserName" runat="server"></asp:Label></div>
                            </div>
                        </div>
                    </div>

                    <!-- 收货信息 -->
                    <div class="order-detail-section">
                        <div class="section-title">收货信息</div>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">收货人</div>
                                <div class="info-value"><asp:Label ID="lblAddressee" runat="server"></asp:Label></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">联系电话</div>
                                <div class="info-value"><asp:Label ID="lblTel" runat="server"></asp:Label></div>
                            </div>
                            <div class="info-item" style="grid-column: span 2;">
                                <div class="info-label">收货地址</div>
                                <div class="info-value"><asp:Label ID="lblAddress" runat="server"></asp:Label></div>
                            </div>
                        </div>
                    </div>

                    <!-- 商品清单 -->
                    <div class="order-detail-section">
                        <div class="section-title">商品清单</div>
                        <asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="False" CssClass="order-items-table">
                            <Columns>
                                <asp:BoundField DataField="ProductName" HeaderText="商品名称" />
                                <asp:BoundField DataField="size" HeaderText="尺码" />
                                <asp:TemplateField HeaderText="单价">
                                    <ItemTemplate>
                                        ¥<%# Eval("Price", "{0:F2}") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Number" HeaderText="数量" />
                                <asp:TemplateField HeaderText="小计">
                                    <ItemTemplate>
                                        ¥<%# (Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Number"))).ToString("F2") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    <!-- 订单汇总 -->
                    <div class="order-detail-section">
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">商品总数</div>
                                <div class="info-value"><asp:Label ID="lblTotalNum" runat="server"></asp:Label> 件</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">订单总额</div>
                                <div class="info-value" style="color: #f5222d; font-size: 18px;">
                                    ¥<asp:Label ID="lblTotalMoney" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 备注 -->
                    <div class="order-detail-section">
                        <div class="section-title">订单备注</div>
                        <div class="info-item">
                            <asp:Label ID="lblRemark" runat="server" Text="无"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        function hideModal() {
            document.getElementById('orderDetailModal').classList.remove('show');
        }
        
        <asp:Literal ID="litShowModal" runat="server"></asp:Literal>
    </script>
</body>
</html>
