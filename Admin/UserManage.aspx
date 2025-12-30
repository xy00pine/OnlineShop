<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserManage.aspx.cs" Inherits="AdminUserManage" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>会员管理 - 童装商城</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #eee;
        }

        .header h1 {
            color: #333;
            font-size: 28px;
        }

        .btn-back {
            background: #667eea;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-block;
        }

        .btn-back:hover {
            background: #5568d3;
        }

        .search-box {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .search-box input {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            width: 300px;
        }

        .btn-search {
            background: #667eea;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-search:hover {
            background: #5568d3;
        }

        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .user-table th,
        .user-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .user-table th {
            background: #667eea;
            color: white;
            font-weight: 500;
        }

        .user-table tr:hover {
            background: #f9f9f9;
        }

        .btn-delete {
            background: #ff4d4f;
            color: white;
            padding: 6px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            text-decoration: none;
        }

        .btn-delete:hover {
            background: #ff7875;
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            font-size: 16px;
        }

        .no-data::before {
            content: "📭";
            display: block;
            font-size: 60px;
            margin-bottom: 20px;
        }

        .stats-info {
            background: #f0f7ff;
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            color: #1890ff;
            font-size: 14px;
        }
    </style>
    
    <script type="text/javascript">
        function confirmDelete(username) {
            return confirm('确定要删除用户【' + username + '】吗？\n\n此操作不可恢复！');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>👥 会员管理</h1>
                <a href="AdminManage.aspx" class="btn-back">← 返回后台首页</a>
            </div>

            <div class="stats-info">
                📊 当前共有 <strong><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></strong> 位会员
            </div>

            <div class="search-box">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="搜索用户名、邮箱或电话..." />
                <asp:Button ID="btnSearch" runat="server" Text="🔍 搜索" CssClass="btn-search" OnClick="btnSearch_Click" />
                <asp:Button ID="btnShowAll" runat="server" Text="显示全部" CssClass="btn-search" OnClick="btnShowAll_Click" />
            </div>
            
            <asp:GridView ID="gvUsers" runat="server" 
                AutoGenerateColumns="False" 
                DataKeyNames="id" 
                OnRowDeleting="gvUsers_RowDeleting"
                OnRowDataBound="gvUsers_RowDataBound"
                CssClass="user-table"
                Width="100%" 
                CellPadding="15" 
                GridLines="None"
                BorderStyle="None">
                
                <HeaderStyle BackColor="#667eea" ForeColor="White" Font-Bold="False" Height="50px" />
                <RowStyle BackColor="White" Height="50px" />
                <AlternatingRowStyle BackColor="#f9f9f9" />
                
                <Columns>
                    <asp:BoundField DataField="id" HeaderText="ID" ItemStyle-Width="60px" />
                    <asp:BoundField DataField="Username" HeaderText="用户名" ItemStyle-Width="150px" />
                    <asp:BoundField DataField="Email" HeaderText="邮箱" ItemStyle-Width="220px" />
                    <asp:BoundField DataField="Phone" HeaderText="电话" ItemStyle-Width="150px" />
                    <asp:BoundField DataField="RegisterTime" HeaderText="注册时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" ItemStyle-Width="180px" />
                    
                    <asp:TemplateField HeaderText="操作" ItemStyle-Width="100px">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" 
                                Text="删除" 
                                CommandName="Delete" 
                                CssClass="btn-delete" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                
                <EmptyDataTemplate>
                    <div class="no-data">
                        暂无会员数据
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </form>
</body>
</html>
