<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DebugCart.aspx.cs" Inherits="DebugCart" %>

<!DOCTYPE html>
<html>
<head>
    <title>购物车调试</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .debug-section { background: white; padding: 20px; margin: 10px 0; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h2 { color: #667eea; border-bottom: 2px solid #667eea; padding-bottom: 10px; }
        .info { padding: 10px; background: #e6f7ff; border-left: 4px solid #1890ff; margin: 10px 0; }
        .error { padding: 10px; background: #fff1f0; border-left: 4px solid #ff4d4f; margin: 10px 0; }
        .success { padding: 10px; background: #f6ffed; border-left: 4px solid #52c41a; margin: 10px 0; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { padding: 10px; text-align: left; border: 1px solid #ddd; }
        th { background: #fafafa; font-weight: bold; }
        .code { background: #f5f5f5; padding: 10px; border-radius: 4px; font-family: monospace; margin: 10px 0; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h1>🔍 购物车调试信息</h1>
        
        <div class="debug-section">
            <h2>1. Session 信息</h2>
            <asp:Label ID="lblSession" runat="server"></asp:Label>
        </div>

        <div class="debug-section">
            <h2>2. 数据库连接</h2>
            <asp:Label ID="lblConnection" runat="server"></asp:Label>
        </div>

        <div class="debug-section">
            <h2>3. 购物车原始数据</h2>
            <asp:Label ID="lblCartRaw" runat="server"></asp:Label>
            <asp:GridView ID="gvCartRaw" runat="server" AutoGenerateColumns="true" 
                CssClass="data-grid" GridLines="Both"></asp:GridView>
        </div>

        <div class="debug-section">
            <h2>4. 购物车关联查询</h2>
            <asp:Label ID="lblCartJoin" runat="server"></asp:Label>
            <asp:GridView ID="gvCartJoin" runat="server" AutoGenerateColumns="true" 
                CssClass="data-grid" GridLines="Both"></asp:GridView>
        </div>

        <div class="debug-section">
            <h2>5. SQL 查询语句</h2>
            <asp:Label ID="lblSQL" runat="server"></asp:Label>
        </div>

        <div class="debug-section">
            <h2>6. 商品信息</h2>
            <asp:Label ID="lblProducts" runat="server"></asp:Label>
            <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="true" 
                CssClass="data-grid" GridLines="Both"></asp:GridView>
        </div>
    </form>
</body>
</html>
