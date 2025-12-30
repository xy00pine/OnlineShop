<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProductManage.aspx.cs" Inherits="AdminProductManage" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>商品管理 - 管理后台</title>
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
        .page-header { background: #fff; padding: 24px; border-radius: 8px; margin-bottom: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
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
        
        .product-image { width: 60px; height: 60px; object-fit: cover; border-radius: 4px; }
        .status-badge { padding: 4px 12px; border-radius: 12px; font-size: 12px; }
        .status-1 { background: #f6ffed; color: #52c41a; }
        .status-0 { background: #fff1f0; color: #f5222d; }
        
        .action-buttons { display: flex; gap: 8px; }
        
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
        .modal.show { display: flex; }
        .modal-content { background: #fff; border-radius: 8px; width: 90%; max-width: 600px; max-height: 90vh; overflow-y: auto; }
        .modal-header { padding: 20px; border-bottom: 1px solid #e8e8e8; display: flex; justify-content: space-between; align-items: center; }
        .modal-title { font-size: 20px; font-weight: bold; }
        .modal-close { font-size: 24px; cursor: pointer; color: #999; }
        .modal-body { padding: 20px; }
        .modal-footer { padding: 20px; border-top: 1px solid #e8e8e8; display: flex; justify-content: flex-end; gap: 10px; }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #333; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .form-group textarea { min-height: 100px; resize: vertical; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
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
                    <li class="menu-item active"><a href="ProductManage.aspx">📦 商品管理</a></li>
                    <li class="menu-item"><a href="CategoryManage.aspx">🏷️ 分类管理</a></li>
                    <li class="menu-item"><a href="OrderManage.aspx">📋 订单管理</a></li>
                    <li class="menu-item"><a href="UserManage.aspx">👥 会员管理</a></li>
                </ul>
            </div>

            <div class="content">
                <div class="page-header">
                    <h1 class="page-title">商品管理</h1>
                    <asp:Button ID="btnShowAdd" runat="server" Text="+ 添加商品" CssClass="btn btn-primary" OnClientClick="showAddModal(); return false;" />
                </div>

                <div class="toolbar">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="搜索商品名称或品牌"></asp:TextBox>
                    <asp:DropDownList ID="ddlCategory" runat="server">
                        <asp:ListItem Value="0">全部分类</asp:ListItem>
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Value="-1">全部状态</asp:ListItem>
                        <asp:ListItem Value="1">上架</asp:ListItem>
                        <asp:ListItem Value="0">下架</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="重置" CssClass="btn" OnClick="btnReset_Click" />
                </div>

                <div class="data-table">
                    <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
                        OnRowCommand="gvProducts_RowCommand" OnRowDataBound="gvProducts_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="id" HeaderText="ID" />
                            
                            <asp:TemplateField HeaderText="商品图片">
                                <ItemTemplate>
                                    <img src='<%# Eval("PictureUrl") %>' alt='<%# Eval("Name") %>' 
                                         class="product-image" onerror="this.src='/Images/default.jpg'" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:BoundField DataField="Name" HeaderText="商品名称" />
                            <asp:BoundField DataField="Brand" HeaderText="品牌" />
                            <asp:BoundField DataField="CategoryName" HeaderText="分类" />
                            
                            <asp:TemplateField HeaderText="价格">
                                <ItemTemplate>
                                    ¥<%# Eval("Price", "{0:F2}") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:BoundField DataField="Stock" HeaderText="库存" />
                            
                            <asp:TemplateField HeaderText="状态">
                                <ItemTemplate>
                                    <span class='status-badge status-<%# Eval("Status") %>'>
                                        <%# Convert.ToInt32(Eval("Status")) == 1 ? "上架" : "下架" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="操作">
                                <ItemTemplate>
                                    <div class="action-buttons">
                                        <asp:Button ID="btnEdit" runat="server" Text="编辑" CssClass="btn btn-primary"
                                            CommandName="EditProduct" CommandArgument='<%# Eval("id") %>' />
                                        <asp:Button ID="btnToggleStatus" runat="server" CssClass="btn btn-warning"
                                            CommandName="ToggleStatus" CommandArgument='<%# Eval("id") %>' />
                                        <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn btn-danger"
                                            CommandName="DeleteProduct" CommandArgument='<%# Eval("id") %>'
                                            OnClientClick="return confirm('确定要删除这个商品吗？');" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state">
                                <p>暂无商品数据</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- 添加/编辑商品模态框 -->
        <div id="productModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title"><asp:Label ID="lblModalTitle" runat="server" Text="添加商品"></asp:Label></h3>
                    <span class="modal-close" onclick="hideModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="hfProductId" runat="server" Value="0" />
                    
                    <div class="form-group">
                        <label>商品名称 *</label>
                        <asp:TextBox ID="txtName" runat="server" placeholder="请输入商品名称"></asp:TextBox>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>品牌 *</label>
                            <asp:TextBox ID="txtBrand" runat="server" placeholder="请输入品牌"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>分类 *</label>
                            <asp:DropDownList ID="ddlModalCategory" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>价格 *</label>
                            <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" step="0.01" placeholder="0.00"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>库存 *</label>
                            <asp:TextBox ID="txtStock" runat="server" TextMode="Number" placeholder="0"></asp:TextBox>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>尺码</label>
                            <asp:TextBox ID="txtSize" runat="server" placeholder="例如: 110/120/130/140"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>适用年龄</label>
                            <asp:TextBox ID="txtForAges" runat="server" placeholder="例如: 3-10岁"></asp:TextBox>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>图片URL</label>
                        <asp:TextBox ID="txtPictureUrl" runat="server" placeholder="/Images/products/xxx.jpg"></asp:TextBox>
                    </div>
                    
                    <div class="form-group">
                        <label>商品描述</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" placeholder="请输入商品描述"></asp:TextBox>
                    </div>
                    
                    <div class="form-group">
                        <label>状态</label>
                        <asp:DropDownList ID="ddlModalStatus" runat="server">
                            <asp:ListItem Value="1" Selected="True">上架</asp:ListItem>
                            <asp:ListItem Value="0">下架</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn" OnClientClick="hideModal(); return false;" />
                    <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </form>

    <script>
        function showAddModal() {
            document.getElementById('productModal').classList.add('show');
        }
        
        function hideModal() {
            document.getElementById('productModal').classList.remove('show');
        }
        
        // 如果需要显示模态框（编辑时）
        <asp:Literal ID="litShowModal" runat="server"></asp:Literal>
    </script>
</body>
</html>
