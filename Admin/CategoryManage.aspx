<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CategoryManage.aspx.cs" Inherits="AdminCategoryManage" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>分类管理 - 管理后台</title>
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
        
        .action-buttons { display: flex; gap: 8px; }
        
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
        .modal.show { display: flex; }
        .modal-content { background: #fff; border-radius: 8px; width: 90%; max-width: 500px; }
        .modal-header { padding: 20px; border-bottom: 1px solid #e8e8e8; display: flex; justify-content: space-between; align-items: center; }
        .modal-title { font-size: 20px; font-weight: bold; }
        .modal-close { font-size: 24px; cursor: pointer; color: #999; }
        .modal-body { padding: 20px; }
        .modal-footer { padding: 20px; border-top: 1px solid #e8e8e8; display: flex; justify-content: flex-end; gap: 10px; }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #333; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .form-group textarea { min-height: 80px; resize: vertical; }
        
        .category-icon { font-size: 24px; margin-right: 10px; }
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
                    <li class="menu-item active"><a href="CategoryManage.aspx">🏷️ 分类管理</a></li>
                    <li class="menu-item"><a href="OrderManage.aspx">📋 订单管理</a></li>
                    <li class="menu-item"><a href="UserManage.aspx">👥 会员管理</a></li>
                </ul>
            </div>

            <div class="content">
                <div class="page-header">
                    <h1 class="page-title">分类管理</h1>
                    <asp:Button ID="btnShowAdd" runat="server" Text="+ 添加分类" CssClass="btn btn-primary" OnClientClick="showAddModal(); return false;" />
                </div>

                <div class="data-table">
                    <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False" 
                        OnRowCommand="gvCategories_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="id" HeaderText="ID" />
                            
                            <asp:TemplateField HeaderText="分类名称">
                                <ItemTemplate>
                                    <span class="category-icon">🏷️</span>
                                    <%# Eval("Name") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:BoundField DataField="Description" HeaderText="描述" />
                            
                            <asp:TemplateField HeaderText="商品数量">
                                <ItemTemplate>
                                    <%# GetProductCount(Eval("id")) %> 件
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="创建时间">
                                <ItemTemplate>
                                    <%# Eval("CreateDate") != DBNull.Value ? Convert.ToDateTime(Eval("CreateDate")).ToString("yyyy-MM-dd") : "-" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="操作">
                                <ItemTemplate>
                                    <div class="action-buttons">
                                        <asp:Button ID="btnEdit" runat="server" Text="编辑" CssClass="btn btn-primary"
                                            CommandName="EditCategory" CommandArgument='<%# Eval("id") %>' />
                                        <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn btn-danger"
                                            CommandName="DeleteCategory" CommandArgument='<%# Eval("id") %>'
                                            OnClientClick="return confirm('确定要删除这个分类吗？删除后该分类下的商品将无法显示！');" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state">
                                <p>暂无分类数据</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- 添加/编辑分类模态框 -->
        <div id="categoryModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title"><asp:Label ID="lblModalTitle" runat="server" Text="添加分类"></asp:Label></h3>
                    <span class="modal-close" onclick="hideModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="hfCategoryId" runat="server" Value="0" />
                    
                    <div class="form-group">
                        <label>分类名称 *</label>
                        <asp:TextBox ID="txtName" runat="server" placeholder="请输入分类名称"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" 
                            ControlToValidate="txtName" ErrorMessage="请输入分类名称" 
                            ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label>分类描述</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" 
                            placeholder="请输入分类描述（可选）"></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn" 
                        OnClientClick="hideModal(); return false;" CausesValidation="false" />
                    <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn btn-primary" 
                        OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </form>

    <script>
        function showAddModal() {
            document.getElementById('categoryModal').classList.add('show');
        }
        
        function hideModal() {
            document.getElementById('categoryModal').classList.remove('show');
        }
        
        // 如果需要显示模态框（编辑时）
        <asp:Literal ID="litShowModal" runat="server"></asp:Literal>
    </script>
</body>
</html>
