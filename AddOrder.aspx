<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddOrder.aspx.cs" Inherits="AddOrder" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>提交订单 - 童装商城</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Helvetica Neue", Arial, "Microsoft YaHei", sans-serif;
            background: #f5f5f5;
            color: #000;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* 顶部导航 */
        .top-bar {
            background: #000;
            color: #fff;
            padding: 10px 0;
            margin-bottom: 20px;
        }

        .top-bar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 20px;
            font-weight: 700;
            letter-spacing: 2px;
        }

        .nav-links a {
            color: #fff;
            margin-left: 20px;
            text-decoration: none;
        }

        .nav-links a:hover {
            text-decoration: underline;
        }

        /* 页面标题 */
        .page-header {
            background: #fff;
            padding: 30px;
            margin-bottom: 20px;
            border-bottom: 2px solid #000;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #000;
        }

        .steps {
            display: flex;
            justify-content: center;
            gap: 50px;
            margin-top: 20px;
        }

        .step {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #999;
        }

        .step.active {
            color: #000;
            font-weight: 600;
        }

        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #e5e5e5;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }

        .step.active .step-number {
            background: #000;
            color: #fff;
        }

        /* 主要内容区 */
        .main-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }

        .section {
            background: #fff;
            padding: 30px;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e5e5e5;
        }

        /* 收货信息表单 */
        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #000;
        }

        .form-label .required {
            color: #c00;
        }

        .form-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e5e5e5;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-input:focus {
            outline: none;
            border-color: #000;
        }

        .form-input.error {
            border-color: #c00;
        }

        .error-message {
            color: #c00;
            font-size: 12px;
            margin-top: 5px;
        }

        /* 订单商品列表 */
        .order-items {
            margin-bottom: 20px;
        }

        .order-item {
            display: flex;
            gap: 15px;
            padding: 15px 0;
            border-bottom: 1px solid #f5f5f5;
        }

        .item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            background: #f5f5f5;
        }

        .item-info {
            flex: 1;
        }

        .item-name {
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 5px;
        }

        .item-price {
            color: #666;
            font-size: 13px;
        }

        .item-quantity {
            color: #999;
            font-size: 13px;
        }

        .item-subtotal {
            font-weight: 700;
            color: #000;
        }

        /* 订单摘要 */
        .order-summary {
            position: sticky;
            top: 20px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f5f5f5;
        }

        .summary-row.total {
            font-size: 18px;
            font-weight: 700;
            color: #c00;
            border-top: 2px solid #000;
            border-bottom: none;
            padding-top: 20px;
            margin-top: 10px;
        }

        /* 提交按钮 */
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: #000;
            color: #fff;
            border: 2px solid #000;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 20px;
        }

        .btn-submit:hover {
            background: #fff;
            color: #000;
        }

        .btn-submit:disabled {
            background: #ccc;
            border-color: #ccc;
            cursor: not-allowed;
        }

        .btn-back {
            display: block;
            text-align: center;
            padding: 12px;
            background: #fff;
            color: #000;
            border: 1px solid #e5e5e5;
            margin-top: 10px;
            text-decoration: none;
        }

        .btn-back:hover {
            background: #f5f5f5;
        }

        /* 空购物车提示 */
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            background: #fff;
        }

        .empty-cart-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .empty-cart h3 {
            font-size: 20px;
            margin-bottom: 10px;
        }

        .empty-cart p {
            color: #999;
            margin-bottom: 20px;
        }

        .btn-continue {
            display: inline-block;
            padding: 12px 30px;
            background: #000;
            color: #fff;
            text-decoration: none;
        }

        .btn-continue:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- 顶部导航 -->
        <div class="top-bar">
            <div class="container">
                <div class="logo">KIDSTORE</div>
                <div class="nav-links">
                    <a href="Default.aspx">首页</a>
                    <a href="ShoppingCart.aspx">购物车</a>
                    <a href="MyOrders.aspx">我的订单</a>
                </div>
            </div>
        </div>

        <div class="container">
            <!-- 页面标题 -->
            <div class="page-header">
                <h1 class="page-title">提交订单</h1>
                <div class="steps">
                    <div class="step">
                        <span class="step-number">1</span>
                        <span>购物车</span>
                    </div>
                    <div class="step active">
                        <span class="step-number">2</span>
                        <span>确认订单</span>
                    </div>
                    <div class="step">
                        <span class="step-number">3</span>
                        <span>完成</span>
                    </div>
                </div>
            </div>

            <!-- 空购物车提示 -->
            <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false">
                <div class="empty-cart">
                    <div class="empty-cart-icon">🛒</div>
                    <h3>购物车是空的</h3>
                    <p>您还没有选择要结算的商品</p>
                    <a href="ShoppingCart.aspx" class="btn-continue">返回购物车</a>
                </div>
            </asp:Panel>

            <!-- 订单内容 -->
            <asp:Panel ID="pnlOrderContent" runat="server">
                <div class="main-content">
                    <!-- 左侧：收货信息 -->
                    <div>
                        <!-- 收货信息表单 -->
                        <div class="section">
                            <h2 class="section-title">收货信息</h2>
                            
                            <div class="form-group">
                                <label class="form-label">
                                    收货人姓名 <span class="required">*</span>
                                </label>
                                <asp:TextBox ID="txtReceiverName" runat="server" 
                                    CssClass="form-input" 
                                    placeholder="请输入收货人姓名" />
                                <asp:RequiredFieldValidator ID="rfvReceiverName" runat="server" 
                                    ControlToValidate="txtReceiverName"
                                    ErrorMessage="请输入收货人姓名" 
                                    CssClass="error-message"
                                    Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    联系电话 <span class="required">*</span>
                                </label>
                                <asp:TextBox ID="txtReceiverPhone" runat="server" 
                                    CssClass="form-input" 
                                    placeholder="请输入11位手机号码" />
                                <asp:RequiredFieldValidator ID="rfvReceiverPhone" runat="server" 
                                    ControlToValidate="txtReceiverPhone"
                                    ErrorMessage="请输入联系电话" 
                                    CssClass="error-message"
                                    Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revReceiverPhone" runat="server"
                                    ControlToValidate="txtReceiverPhone"
                                    ValidationExpression="^1[3-9]\d{9}$"
                                    ErrorMessage="请输入正确的手机号码"
                                    CssClass="error-message"
                                    Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    收货地址 <span class="required">*</span>
                                </label>
                                <asp:TextBox ID="txtReceiverAddress" runat="server" 
                                    CssClass="form-input" 
                                    TextMode="MultiLine"
                                    Rows="3"
                                    placeholder="请输入详细收货地址" />
                                <asp:RequiredFieldValidator ID="rfvReceiverAddress" runat="server" 
                                    ControlToValidate="txtReceiverAddress"
                                    ErrorMessage="请输入收货地址" 
                                    CssClass="error-message"
                                    Display="Dynamic" />
                            </div>
                        </div>

                        <!-- 订单商品列表 -->
                        <div class="section">
                            <h2 class="section-title">订单商品</h2>
                            <div class="order-items">
                                <asp:Repeater ID="rptOrderItems" runat="server">
                                    <ItemTemplate>
                                        <div class="order-item">
                                            <img src='<%# Eval("ProductImage") %>' 
                                                 alt='<%# Eval("ProductName") %>' 
                                                 class="item-image"
                                                 onerror="this.src='images/default-product.jpg'" />
                                            <div class="item-info">
                                                <div class="item-name"><%# Eval("ProductName") %></div>
                                                <div class="item-price">单价：¥<%# Eval("Price", "{0:F2}") %></div>
                                                <div class="item-quantity">数量：<%# Eval("Quantity") %></div>
                                            </div>
                                            <div class="item-subtotal">
                                                ¥<%# Eval("Subtotal", "{0:F2}") %>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>

                    <!-- 右侧：订单摘要 -->
                    <div>
                        <div class="section order-summary">
                            <h2 class="section-title">订单摘要</h2>
                            
                            <div class="summary-row">
                                <span>商品件数：</span>
                                <span><asp:Label ID="lblTotalItems" runat="server"></asp:Label> 件</span>
                            </div>
                            
                            <div class="summary-row">
                                <span>商品总价：</span>
                                <span>¥<asp:Label ID="lblSubtotal" runat="server"></asp:Label></span>
                            </div>
                            
                            <div class="summary-row">
                                <span>运费：</span>
                                <span>¥<asp:Label ID="lblShipping" runat="server" Text="0.00"></asp:Label></span>
                            </div>
                            
                            <div class="summary-row total">
                                <span>应付总额：</span>
                                <span>¥<asp:Label ID="lblTotal" runat="server"></asp:Label></span>
                            </div>

                            <asp:Button ID="btnSubmitOrder" runat="server" 
                                Text="提交订单" 
                                CssClass="btn-submit"
                                OnClick="btnSubmitOrder_Click" />
                            
                            <a href="ShoppingCart.aspx" class="btn-back">返回购物车</a>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
