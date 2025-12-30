<%@ Page Language="C#" AutoEventWireup="true" CodeFile="userLogin.aspx.cs" Inherits="AdminuserLogin" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>管理员登录 - 童装商城</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Helvetica Neue", Arial, "Microsoft YaHei", sans-serif; background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        
        .login-container { background: #fff; border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.3); width: 100%; max-width: 400px; padding: 40px; }
        .logo { text-align: center; margin-bottom: 30px; }
        .logo-icon { font-size: 60px; margin-bottom: 10px; }
        .logo-text { font-size: 28px; font-weight: bold; color: #1e3c72; }
        .logo-subtitle { font-size: 14px; color: #999; margin-top: 5px; }
        
        .form-title { font-size: 24px; text-align: center; margin-bottom: 30px; color: #333; }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #333; font-size: 14px; }
        .form-group input { width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; transition: all 0.3s; }
        .form-group input:focus { outline: none; border-color: #1e3c72; box-shadow: 0 0 0 3px rgba(30,60,114,0.1); }
        
        .btn-login { width: 100%; padding: 14px; background: #1e3c72; color: #fff; border: none; border-radius: 6px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.3s; }
        .btn-login:hover { background: #2a5298; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(30,60,114,0.3); }
        
        .back-home { text-align: center; margin-top: 20px; }
        .back-home a { color: #999; text-decoration: none; font-size: 14px; }
        .back-home a:hover { color: #666; }
        
        .error-message { color: #ff0000; font-size: 14px; margin-top: 5px; }
        
        .alert { padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; }
        .alert-error { background: #fff1f0; color: #f5222d; border: 1px solid #ffccc7; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="logo">
                <div class="logo-icon">🔐</div>
                <div class="logo-text">管理后台</div>
                <div class="logo-subtitle">Admin Management System</div>
            </div>
            
            <h2 class="form-title">管理员登录</h2>
            
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-error">
                <asp:Label ID="lblError" runat="server"></asp:Label>
            </asp:Panel>
            
            <div class="form-group">
                <label>管理员账号</label>
                <asp:TextBox ID="txtUsername" runat="server" placeholder="请输入管理员账号"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername" ErrorMessage="请输入管理员账号" 
                    CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <label>密码</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="请输入密码"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                    ControlToValidate="txtPassword" ErrorMessage="请输入密码" 
                    CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            
            <asp:Button ID="btnLogin" runat="server" Text="登录" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <div class="back-home">
                <a href="../Default.aspx">← 返回前台首页</a>
            </div>
        </div>
    </form>
</body>
</html>
