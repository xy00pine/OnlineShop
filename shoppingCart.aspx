<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShoppingCart.aspx.cs" Inherits="ShoppingCart" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>购物车 - 童装商城</title>
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
            font-size: 14px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* ==================== 顶部通知栏 ==================== */
        .top-bar {
            background: #000;
            color: #fff;
            font-size: 12px;
            padding: 8px 0;
        }

        .top-bar-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .top-bar-links {
            display: flex;
            gap: 15px;
        }

        .top-bar-links a {
            color: #fff;
            text-decoration: none;
        }

        .top-bar-links a:hover {
            text-decoration: underline;
        }

        /* ==================== 主导航栏 ==================== */
        .main-header {
            background: #fff;
            border-bottom: 1px solid #e5e5e5;
            padding: 15px 0;
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo h1 {
            font-size: 24px;
            font-weight: 700;
            letter-spacing: 2px;
            color: #000;
        }

        .logo-subtitle {
            font-size: 10px;
            color: #666;
            letter-spacing: 1px;
        }

        .nav-links {
            display: flex;
            gap: 30px;
        }

        .nav-links a {
            color: #000;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            padding: 10px 0;
            border-bottom: 2px solid transparent;
            transition: all 0.2s;
        }

        .nav-links a:hover,
        .nav-links a.active {
            border-bottom-color: #000;
        }

        /* ==================== 页面标题 ==================== */
        .page-header {
            background: #fff;
            padding: 40px 0;
            margin-bottom: 30px;
            border-bottom: 2px solid #000;
        }

        .page-title {
            font-size: 32px;
            font-weight: 700;
            text-align: center;
            color: #000;
        }

        .breadcrumb {
            text-align: center;
            margin-top: 15px;
            color: #666;
            font-size: 13px;
        }

        .breadcrumb a {
            color: #666;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            color: #000;
        }

        /* ==================== 购物车内容 ==================== */
        .cart-section {
            padding: 30px 0;
            min-height: 500px;
        }

        .cart-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }

        /* 购物车商品列表 */
        .cart-items {
            background: #fff;
            padding: 30px;
        }

        .cart-header {
            display: grid;
            grid-template-columns: 3fr 1fr 1fr 1fr 80px;
            gap: 20px;
            padding: 15px 0;
            border-bottom: 2px solid #000;
            font-weight: 600;
            font-size: 13px;
        }

        .cart-item {
            display: grid;
            grid-template-columns: 3fr 1fr 1fr 1fr 80px;
            gap: 20px;
            padding: 20px 0;
            border-bottom: 1px solid #e5e5e5;
            align-items: center;
        }

        .item-product {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .item-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            background: #f5f5f5;
        }

        .item-details {
            flex: 1;
        }

        .item-name {
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 5px;
            color: #000;
        }

        .item-name a {
            color: #000;
            text-decoration: none;
        }

        .item-name a:hover {
            text-decoration: underline;
        }

        .item-desc {
            font-size: 12px;
            color: #999;
        }

        .item-price {
            font-size: 16px;
            font-weight: 600;
            color: #000;
        }

        .item-quantity {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .qty-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #e5e5e5;
            background: #fff;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.2s;
        }

        .qty-btn:hover {
            background: #000;
            color: #fff;
            border-color: #000;
        }

        .qty-input {
            width: 50px;
            height: 30px;
            text-align: center;
            border: 1px solid #e5e5e5;
            font-size: 14px;
        }

        .item-subtotal {
            font-size: 16px;
            font-weight: 700;
            color: #000;
        }

        .item-remove {
            text-align: center;
        }

        .btn-remove {
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            font-size: 20px;
            transition: all 0.2s;
        }

        .btn-remove:hover {
            color: #c00;
        }

        /* 购物车摘要 */
        .cart-summary {
            background: #fff;
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }

        .summary-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #000;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            font-size: 14px;
        }

        .summary-row.total {
            font-size: 20px;
            font-weight: 700;
            color: #c00;
            border-top: 2px solid #000;
            margin-top: 15px;
            padding-top: 20px;
        }

        .summary-note {
            font-size: 12px;
            color: #999;
            margin: 15px 0;
            padding: 10px;
            background: #f5f5f5;
        }

        .btn-checkout {
            display: block;
            width: 100%;
            padding: 15px;
            background: #000;
            color: #fff;
            text-align: center;
            font-size: 16px;
            font-weight: 600;
            border: 2px solid #000;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            margin-top: 20px;
        }

        .btn-checkout:hover {
            background: #fff;
            color: #000;
        }

        .btn-continue {
            display: block;
            width: 100%;
            padding: 12px;
            background: #fff;
            color: #000;
            text-align: center;
            font-size: 14px;
            border: 1px solid #e5e5e5;
            text-decoration: none;
            margin-top: 10px;
            transition: all 0.2s;
        }

        .btn-continue:hover {
            background: #f5f5f5;
        }

        /* 空购物车 */
        .empty-cart {
            background: #fff;
            padding: 80px 20px;
            text-align: center;
        }

        .empty-icon {
            font-size: 100px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        .empty-cart h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #000;
        }

        .empty-cart p {
            color: #999;
            margin-bottom: 30px;
        }

        .btn-shop {
            display: inline-block;
            padding: 15px 40px;
            background: #000;
            color: #fff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            border: 2px solid #000;
            transition: all 0.3s;
        }

        .btn-shop:hover {
            background: #fff;
            color: #000;
        }

        /* ==================== 页脚 ==================== */
        .main-footer {
            background: #000;
            color: #fff;
            padding: 40px 0 20px;
            margin-top: 60px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
            margin-bottom: 30px;
        }

        .footer-section h3 {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 8px;
        }

        .footer-section a {
            color: #999;
            font-size: 13px;
            text-decoration: none;
        }

        .footer-section a:hover {
            color: #fff;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #333;
            color: #666;
            font-size: 12px;
        }

        /* ==================== 响应式设计 ==================== */
        @media (max-width: 1024px) {
            .cart-container {
                grid-template-columns: 1fr;
            }

            .cart-summary {
                position: static;
            }
        }

        @media (max-width: 768px) {
            .cart-header {
                display: none;
            }

            .cart-item {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .item-product {
                flex-direction: column;
                align-items: flex-start;
            }

            .footer-content {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- 顶部通知栏 -->
        <div class="top-bar">
            <div class="container">
                <div class="top-bar-content">
                    <span>🎉 全场满299元免运费</span>
                    <div class="top-bar-links">
                        <% if (Session["Username"] != null) { %>
                            <span>您好，<%= Session["Username"] %></span>
                            <asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">退出</asp:LinkButton>
                        <% } else { %>
                            <a href="userLogin.aspx">登录</a>
                            <a href="userRegister.aspx">注册</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- 主导航栏 -->
        <header class="main-header">
            <div class="container">
                <div class="header-content">
                    <div class="logo">
                        <a href="Default.aspx">
                            <h1>KIDSTORE</h1>
                            <span class="logo-subtitle">童装商城</span>
                        </a>
                    </div>
                    <nav class="nav-links">
                        <a href="Default.aspx">首页</a>
                        <a href="ShoppingCart.aspx" class="active">购物车</a>
                        <a href="MyOrders.aspx">我的订单</a>
                    </nav>
                </div>
            </div>
        </header>

        <!-- 页面标题 -->
        <div class="page-header">
            <div class="container">
                <h1 class="page-title">购物车</h1>
                <div class="breadcrumb">
                    <a href="Default.aspx">首页</a> / 购物车
                </div>
            </div>
        </div>

        <!-- 购物车内容 -->
        <section class="cart-section">
            <div class="container">
                <!-- 空购物车提示 -->
                <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false">
                    <div class="empty-cart">
                        <div class="empty-icon">🛒</div>
                        <h3>购物车是空的</h3>
                        <p>快去挑选心仪的商品吧</p>
                        <a href="Default.aspx" class="btn-shop">去购物</a>
                    </div>
                </asp:Panel>

                <!-- 购物车商品列表 -->
                <asp:Panel ID="pnlCartContent" runat="server">
                    <div class="cart-container">
                        <!-- 左侧：商品列表 -->
                        <div class="cart-items">
                            <div class="cart-header">
                                <div>商品信息</div>
                                <div>单价</div>
                                <div>数量</div>
                                <div>小计</div>
                                <div>操作</div>
                            </div>

                            <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                                <ItemTemplate>
                                    <div class="cart-item">
                                        <div class="item-product">
                                            <img src='<%# Eval("ProductImage") %>' 
                                                 alt='<%# Eval("ProductName") %>' 
                                                 class="item-image"
                                                 onerror="this.src='images/default-product.jpg'" />
                                            <div class="item-details">
                                                <div class="item-name">
                                                    <a href='ProductDetail.aspx?productId=<%# Eval("ProductId") %>'>
                                                        <%# Eval("ProductName") %>
                                                    </a>
                                                </div>
                                                <div class="item-desc">商品编号：<%# Eval("ProductId") %></div>
                                            </div>
                                        </div>
                                        <div class="item-price">
                                            ¥<%# Eval("Price", "{0:F2}") %>
                                        </div>
                                        <div class="item-quantity">
                                            <asp:LinkButton ID="btnDecrease" runat="server" 
                                                CommandName="Decrease"
                                                CommandArgument='<%# Eval("ProductId") %>'
                                                CssClass="qty-btn">
                                                -
                                            </asp:LinkButton>
                                            <input type="text" value='<%# Eval("Quantity") %>' class="qty-input" readonly />
                                            <asp:LinkButton ID="btnIncrease" runat="server" 
                                                CommandName="Increase"
                                                CommandArgument='<%# Eval("ProductId") %>'
                                                CssClass="qty-btn">
                                                +
                                            </asp:LinkButton>
                                        </div>
                                        <div class="item-subtotal">
                                            ¥<%# Eval("Subtotal", "{0:F2}") %>
                                        </div>
                                        <div class="item-remove">
                                            <asp:LinkButton ID="btnRemove" runat="server" 
                                                CommandName="Remove"
                                                CommandArgument='<%# Eval("ProductId") %>'
                                                CssClass="btn-remove"
                                                OnClientClick="return confirm('确定要删除这件商品吗？');">
                                                ✕
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <!-- 右侧：订单摘要 -->
                        <div class="cart-summary">
                            <h2 class="summary-title">订单摘要</h2>
                            
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
                                <span>¥<asp:Label ID="lblShipping" runat="server"></asp:Label></span>
                            </div>
                            
                            <div class="summary-note">
                                💡 满299元免运费
                            </div>
                            
                            <div class="summary-row total">
                                <span>合计：</span>
                                <span>¥<asp:Label ID="lblTotal" runat="server"></asp:Label></span>
                            </div>

                            <a href="AddOrder.aspx" class="btn-checkout">去结算</a>
                            <a href="Default.aspx" class="btn-continue">继续购物</a>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </section>

        <!-- 页脚 -->
        <footer class="main-footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3>购物指南</h3>
                        <ul>
                            <li><a href="userRegister.aspx">新用户注册</a></li>
                            <li><a href="userLogin.aspx">会员登录</a></li>
                            <li><a href="ShoppingCart.aspx">购物车</a></li>
                            <li><a href="MyOrders.aspx">订单查询</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h3>客户服务</h3>
                        <ul>
                            <li><a href="#">配送说明</a></li>
                            <li><a href="#">退换货政策</a></li>
                            <li><a href="#">常见问题</a></li>
                            <li><a href="#">联系我们</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h3>关于我们</h3>
                        <ul>
                            <li><a href="#">公司简介</a></li>
                            <li><a href="#">加入我们</a></li>
                            <li><a href="#">隐私政策</a></li>
                            <li><a href="#">服务条款</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h3>联系方式</h3>
                        <ul>
                            <li>客服热线：400-888-8888</li>
                            <li>邮箱：service@kidstore.com</li>
                            <li>工作时间：9:00-18:00</li>
                        </ul>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; 2025 KIDSTORE 童装商城 版权所有</p>
                </div>
            </div>
        </footer>
    </form>
</body>
</html>
