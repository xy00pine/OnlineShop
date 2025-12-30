<%@ Page Language="C#" AutoEventWireup="true" CodeFile="userLogin.aspx.cs" Inherits="userLogin" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>用户登录 - 童装商城</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        
        .login-container {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 480px;
            padding: 50px;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .logo {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .logo-icon {
            font-size: 64px;
            margin-bottom: 10px;
            animation: bounce 1s ease-in-out;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        .logo-text {
            font-size: 32px;
            font-weight: bold;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 5px;
        }
        
        .logo-subtitle {
            font-size: 15px;
            color: #999;
            margin-top: 8px;
        }
        
        .message-panel {
            border-radius: 8px;
            padding: 14px 18px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: fadeIn 0.3s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .error-panel {
            background: #fff1f0;
            border: 1px solid #ffccc7;
            color: #f5222d;
        }
        
        .error-panel::before {
            content: "⚠️";
            font-size: 18px;
        }

        .success-panel {
            background: #f6ffed;
            border: 1px solid #b7eb8f;
            color: #52c41a;
        }

        .success-panel::before {
            content: "✓";
            font-size: 20px;
            font-weight: bold;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e5e5e5;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s;
            box-sizing: border-box;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-control:hover {
            border-color: #b8c5f2;
        }
        
        .validator-message {
            color: #f5222d;
            font-size: 13px;
            margin-top: 6px;
            display: block;
        }
        
        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            font-size: 14px;
        }

        .remember-forgot label {
            display: flex;
            align-items: center;
            cursor: pointer;
            color: #666;
        }

        .remember-forgot input[type="checkbox"] {
            margin-right: 6px;
            cursor: pointer;
        }
        
        .remember-forgot a {
            color: #667eea;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .remember-forgot a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        .btn-primary {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.2);
            transition: left 0.5s;
        }

        .btn-primary:hover::before {
            left: 100%;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:active {
            transform: translateY(0);
        }
        
        .register-link {
            text-align: center;
            margin-top: 24px;
            color: #666;
            font-size: 14px;
        }
        
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        
        .register-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        .required {
            color: #f5222d;
            margin-left: 2px;
        }

        .divider {
            text-align: center;
            margin: 30px 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 100%;
            height: 1px;
            background: #e5e5e5;
        }

        .divider span {
            background: #fff;
            padding: 0 15px;
            color: #999;
            font-size: 13px;
            position: relative;
            z-index: 1;
        }

        .quick-links {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }

        .quick-link {
            color: #667eea;
            text-decoration: none;
            font-size: 13px;
            transition: color 0.3s;
        }

        .quick-link:hover {
            color: #764ba2;
        }

        @media (max-width: 768px) {
            .login-container {
                max-width: 100%;
                padding: 30px 20px;
                margin: 20px;
            }
            
            .logo-text {
                font-size: 28px;
            }
            
            .logo-icon {
                font-size: 48px;
            }

            .remember-forgot {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="logo">
                <div class="logo-icon">👶</div>
                <div class="logo-text">童装商城</div>
                <div class="logo-subtitle">欢迎回来</div>
            </div>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false">
            </asp:Panel>

            <div class="form-group">
                <label class="form-label">
                    用户名 <span class="required">*</span>
                </label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                    placeholder="请输入用户名" MaxLength="50"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername" 
                    ErrorMessage="请输入用户名" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">
                    密码 <span class="required">*</span>
                </label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" 
                    placeholder="请输入密码"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                    ControlToValidate="txtPassword" 
                    ErrorMessage="请输入密码" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="remember-forgot">
                <label>
                    <asp:CheckBox ID="chkRemember" runat="server" />
                    <span style="margin-left: 5px;">记住我</span>
                </label>
                <a href="Default.aspx">返回首页</a>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="登录" CssClass="btn-primary" 
                OnClick="btnLogin_Click" />

            <div class="register-link">
                还没有账号？<a href="Register.aspx">立即注册</a>
            </div>

            <div class="divider">
                <span>或</span>
            </div>

            <div class="quick-links">
                <a href="Default.aspx" class="quick-link">🏠 返回首页</a>
                <a href="Default.aspx" class="quick-link">🛍️ 继续购物</a>
            </div>
        </div>
    </form>
</body>
</html>
