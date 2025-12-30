<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminManage.aspx.cs" Inherits="AdminManage" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>后台管理 - 童装商城</title>
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

        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .admin-header {
            background: white;
            padding: 25px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-header h1 {
            color: #333;
            font-size: 28px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info span {
            color: #666;
        }

        .btn-logout {
            background: #ff4d4f;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .btn-logout:hover {
            background: #ff7875;
        }

        .admin-menu {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .menu-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.2);
        }

        .menu-icon {
            font-size: 50px;
            margin-bottom: 15px;
        }

        .menu-card h3 {
            color: #333;
            font-size: 20px;
            margin-bottom: 10px;
        }

        .menu-card p {
            color: #999;
            font-size: 14px;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .stat-card h4 {
            color: #999;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .stat-card .number {
            color: #667eea;
            font-size: 32px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="admin-container">
            <div class="admin-header">
                <h1>🎯 后台管理系统</h1>
                <div class="user-info">
                    <span>👤 管理员：<asp:Label ID="lblUsername" runat="server"></asp:Label></span>
                    <asp:Button ID="btnLogout" runat="server" Text="退出登录" CssClass="btn-logout" OnClick="btnLogout_Click" />
                </div>
            </div>

            <div class="admin-menu">
                <a href="ProductManage.aspx" class="menu-card">
                    <div class="menu-icon">📦</div>
                    <h3>商品管理</h3>
                    <p>查询、添加、修改、删除商品</p>
                </a>

                <a href="CategoryManage.aspx" class="menu-card">
                    <div class="menu-icon">📂</div>
                    <h3>类别管理</h3>
                    <p>管理商品分类</p>
                </a>

                <a href="OrderManage.aspx" class="menu-card">
                    <div class="menu-icon">📋</div>
                    <h3>订单管理</h3>
                    <p>处理订单、修改状态</p>
                </a>

                <a href="UserManage.aspx" class="menu-card">
                    <div class="menu-icon">👥</div>
                    <h3>会员管理</h3>
                    <p>查询、删除会员</p>
                </a>
            </div>

            <div class="stats-container">
                <div class="stat-card">
                    <h4>商品总数</h4>
                    <div class="number"><asp:Label ID="lblProductCount" runat="server" Text="0"></asp:Label></div>
                </div>

                <div class="stat-card">
                    <h4>订单总数</h4>
                    <div class="number"><asp:Label ID="lblOrderCount" runat="server" Text="0"></asp:Label></div>
                </div>

                <div class="stat-card">
                    <h4>会员总数</h4>
                    <div class="number"><asp:Label ID="lblUserCount" runat="server" Text="0"></asp:Label></div>
                </div>

                <div class="stat-card">
                    <h4>商品类别</h4>
                    <div class="number"><asp:Label ID="lblCategoryCount" runat="server" Text="0"></asp:Label></div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
