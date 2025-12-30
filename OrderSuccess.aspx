<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderSuccess.aspx.cs" Inherits="OrderSuccess" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>订单提交成功 - 童装商城</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Helvetica Neue", Arial, "Microsoft YaHei", sans-serif;
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .success-container {
            background: #fff;
            padding: 60px;
            text-align: center;
            max-width: 600px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: scaleIn 0.5s;
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }

        h1 {
            font-size: 28px;
            margin-bottom: 15px;
            color: #000;
        }

        .order-info {
            background: #f5f5f5;
            padding: 20px;
            margin: 30px 0;
            text-align: left;
        }

        .order-info p {
            margin: 10px 0;
            color: #666;
        }

        .order-info strong {
            color: #000;
        }

        .buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .btn {
            padding: 12px 30px;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #000;
            color: #fff;
            border: 2px solid #000;
        }

        .btn-primary:hover {
            background: #fff;
            color: #000;
        }

        .btn-secondary {
            background: #fff;
            color: #000;
            border: 2px solid #e5e5e5;
        }

        .btn-secondary:hover {
            border-color: #000;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="success-container">
            <div class="success-icon">✅</div>
            <h1>订单提交成功！</h1>
            <p>感谢您的购买，我们会尽快为您配送</p>

            <div class="order-info">
                <p><strong>订单编号：</strong><asp:Label ID="lblOrderId" runat="server"></asp:Label></p>
                <p><strong>订单金额：</strong>¥<asp:Label ID="lblTotalMoney" runat="server"></asp:Label></p>
                <p><strong>下单时间：</strong><asp:Label ID="lblOrderTime" runat="server"></asp:Label></p>
            </div>

            <div class="buttons">
                <a href="MyOrders.aspx" class="btn btn-primary">查看订单</a>
                <a href="Default.aspx" class="btn btn-secondary">继续购物</a>
            </div>
        </div>
    </form>
</body>
</html>
