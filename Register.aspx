<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>用户注册 - 童装商城</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        
        .register-container {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 550px;  /* 从 450px 改为 550px */
            padding: 50px;     /* 从 40px 改为 50px */
        }
        
        .logo {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .logo-icon {
            font-size: 64px;
            margin-bottom: 10px;
        }
        
        .logo-text {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .logo-subtitle {
            font-size: 15px;
            color: #999;
            margin-top: 8px;
        }
        
        .error-panel {
            background: #fff1f0;
            border: 1px solid #ffccc7;
            border-radius: 8px;
            padding: 14px 18px;
            margin-bottom: 24px;
            color: #f5222d;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .error-panel::before {
            content: "⚠️";
            font-size: 18px;
        }
        
        .form-group {
            margin-bottom: 24px;  /* 从 20px 改为 24px */
        }
        
        .form-label {
            display: block;
            margin-bottom: 10px;  /* 从 8px 改为 10px */
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 16px;  /* 从 12px 改为 14px */
            border: 2px solid #e5e5e5;
            border-radius: 8px;
            font-size: 15px;     /* 从 14px 改为 15px */
            transition: all 0.3s;
            box-sizing: border-box;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .validator-message {
            color: #f5222d;
            font-size: 13px;
            margin-top: 6px;
            display: block;
        }
        
        .btn-primary {
            width: 100%;
            padding: 16px;  /* 从 14px 改为 16px */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:active {
            transform: translateY(0);
        }
        
        .login-link {
            text-align: center;
            margin-top: 24px;
            color: #666;
            font-size: 14px;
        }
        
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .required {
            color: #f5222d;
            margin-left: 2px;
        }
        
        .form-hint {
            font-size: 12px;
            color: #999;
            margin-top: 4px;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .register-container {
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
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-container">
            <div class="logo">
                <div class="logo-icon">👶</div>
                <div class="logo-text">童装商城</div>
                <div class="logo-subtitle">欢迎注册，开启购物之旅</div>
            </div>

            <asp:Panel ID="pnlError" runat="server" CssClass="error-panel" Visible="false">
                <asp:Label ID="lblError" runat="server"></asp:Label>
            </asp:Panel>

            <div class="form-group">
                <label class="form-label">
                    用户名 <span class="required">*</span>
                </label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                    placeholder="请输入用户名" MaxLength="20"></asp:TextBox>
                <div class="form-hint">4-20个字符，支持字母、数字和下划线</div>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername" 
                    ErrorMessage="请输入用户名" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revUsername" runat="server" 
                    ControlToValidate="txtUsername" 
                    ValidationExpression="^[a-zA-Z0-9_]{4,20}$" 
                    ErrorMessage="用户名格式不正确，请使用4-20个字母、数字或下划线" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label class="form-label">
                    密码 <span class="required">*</span>
                </label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" 
                    placeholder="请输入密码"></asp:TextBox>
                <div class="form-hint">至少6个字符</div>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                    ControlToValidate="txtPassword" 
                    ErrorMessage="请输入密码" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revPassword" runat="server" 
                    ControlToValidate="txtPassword" 
                    ValidationExpression="^.{6,}$" 
                    ErrorMessage="密码至少需要6个字符" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label class="form-label">
                    确认密码 <span class="required">*</span>
                </label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" 
                    placeholder="请再次输入密码"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                    ControlToValidate="txtConfirmPassword" 
                    ErrorMessage="请确认密码" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPassword" runat="server" 
                    ControlToValidate="txtConfirmPassword" 
                    ControlToCompare="txtPassword" 
                    ErrorMessage="两次输入的密码不一致" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:CompareValidator>
            </div>

            <div class="form-group">
                <label class="form-label">邮箱</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                    placeholder="example@email.com（选填）"></asp:TextBox>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                    ControlToValidate="txtEmail" 
                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" 
                    ErrorMessage="邮箱格式不正确" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label class="form-label">手机号</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" 
                    placeholder="请输入11位手机号（选填）" MaxLength="11"></asp:TextBox>
                <asp:RegularExpressionValidator ID="revPhone" runat="server" 
                    ControlToValidate="txtPhone" 
                    ValidationExpression="^1[3-9]\d{9}$" 
                    ErrorMessage="手机号格式不正确" 
                    CssClass="validator-message" 
                    Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="立即注册" CssClass="btn-primary" 
                OnClick="btnRegister_Click" />

            <div class="login-link">
                已有账号？<a href="userLogin.aspx">立即登录</a>
            </div>
        </div>
    </form>
</body>
</html>
