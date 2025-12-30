<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestAddCart.aspx.cs" Inherits="TestAddCart" %>

<!DOCTYPE html>
<html>
<head>
    <title>测试添加购物车</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; }
        h2 { color: #667eea; }
        .form-group { margin: 15px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { background: #667eea; color: white; padding: 12px 30px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .btn:hover { background: #5568d3; }
        .message { padding: 15px; margin: 15px 0; border-radius: 4px; }
        .success { background: #f6ffed; border: 1px solid #b7eb8f; color: #52c41a; }
        .error { background: #fff1f0; border: 1px solid #ffccc7; color: #f5222d; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>🛒 测试添加购物车</h2>
            
            <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>

            <div class="form-group">
                <label>用户ID:</label>
                <asp:TextBox ID="txtUserId" runat="server" Text="4" ReadOnly="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>选择商品:</label>
                <asp:DropDownList ID="ddlProduct" runat="server"></asp:DropDownList>
            </div>

            <div class="form-group">
                <label>数量:</label>
                <asp:TextBox ID="txtQuantity" runat="server" Text="1" TextMode="Number"></asp:TextBox>
            </div>

            <asp:Button ID="btnAdd" runat="server" Text="添加到购物车" CssClass="btn" OnClick="btnAdd_Click" />
            
            <hr style="margin: 30px 0;" />
            
            <h3>当前购物车内容：</h3>
            <asp:GridView ID="gvCart" runat="server" AutoGenerateColumns="true" Width="100%"></asp:GridView>
            
            <div style="margin-top: 20px;">
                <asp:Button ID="btnViewCart" runat="server" Text="查看购物车页面" CssClass="btn" 
                    OnClientClick="window.location.href='shoppingCart.aspx'; return false;" />
            </div>
        </div>
    </form>
</body>
</html>
