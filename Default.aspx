<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>童装商城 - 优质童装，呵护成长</title>
    <link href="css/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- 顶部通知栏 -->
        <div class="top-bar">
            <div class="container">
                <div class="top-bar-content">
                    <span>🎉 新用户注册立享优惠 | 全场满299元免运费</span>
                    <div class="top-bar-links">
                        <% if (Session["Username"] != null) { %>
                            <span>您好，<%= Session["Username"] %></span>
                            <% if (Session["Role"] != null && Session["Role"].ToString() == "admin") { %>
                                <a href="Admin/AdminManage.aspx">后台管理</a>
                            <% } %>
                            <asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">退出</asp:LinkButton>
                        <% } else { %>
                            <a href="userLogin.aspx">登录</a>
                            <a href="Register.aspx">注册</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- 主导航栏 -->
        <header class="main-header">
            <div class="container">
                <div class="header-content">
                    <!-- Logo -->
                    <div class="logo">
                        <a href="Default.aspx">
                            <h1>KIDSTORE</h1>
                            <span class="logo-subtitle">童装商城</span>
                        </a>
                    </div>

                    <!-- 主导航 -->
                    <nav class="main-nav">
                        <a href="Default.aspx" class="nav-link active">首页</a>
                        <asp:Repeater ID="rptNavCategories" runat="server">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkNavCategory" runat="server" 
                                    CommandArgument='<%# Eval("CategoryId") %>' 
                                    OnClick="lnkCategory_Click"
                                    CssClass="nav-link">
                                    <%# Eval("CategoryName") %>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:Repeater>
                    </nav>

                    <!-- 右侧功能区 -->
                    <div class="header-actions">
                        <!-- 搜索 -->
                        <div class="search-wrapper">
                            <asp:TextBox ID="txtQuickSearch" runat="server" 
                                placeholder="搜索商品" 
                                CssClass="search-input" />
                            <asp:Button ID="btnQuickSearch" runat="server" 
                                Text="🔍" 
                                CssClass="search-btn" 
                                OnClick="btnQuickSearch_Click" />
                        </div>

                        <!-- 购物车 -->
                        <a href="ShoppingCart.aspx" class="icon-link">
                            <span class="icon">🛒</span>
                            <span class="label">购物车</span>
                        </a>

                        <!-- 我的订单 -->
                        <a href="MyOrders.aspx" class="icon-link">
                            <span class="icon">📦</span>
                            <span class="label">订单</span>
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Hero Banner -->
        <section class="hero-banner">
            <div class="hero-content">
                <div class="hero-text">
                    <h2 class="hero-title">优质童装 呵护成长</h2>
                    <p class="hero-subtitle">精选面料 · 舒适透气 · 安全环保</p>
                    <a href="#products" class="hero-btn">立即选购</a>
                </div>
            </div>
        </section>

        <!-- 分类快捷导航 -->
        <section class="category-section">
            <div class="container">
                <div class="category-tabs">
                    <asp:LinkButton ID="lnkAllCategories" runat="server" 
                        OnClick="lnkAllCategories_Click"
                        CssClass='<%# GetSelectedCategoryId() == 0 ? "category-tab active" : "category-tab" %>'>
                        全部商品
                    </asp:LinkButton>
                    <asp:Repeater ID="rptCategories" runat="server">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkCategory" runat="server" 
                                CommandArgument='<%# Eval("CategoryId") %>' 
                                OnClick="lnkCategory_Click"
                                CssClass='<%# Convert.ToInt32(Eval("CategoryId")) == GetSelectedCategoryId() ? "category-tab active" : "category-tab" %>'>
                                <%# Eval("CategoryName") %>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </section>

        <!-- 商品列表 -->
        <section class="products-section" id="products">
            <div class="container">
                <!-- 商品数量统计 -->
                <div class="products-header">
                    <h2 class="section-title">
                        <asp:Label ID="lblCategoryTitle" runat="server" Text="全部商品"></asp:Label>
                    </h2>
                    <div class="products-count">
                        <asp:Label ID="lblProductCount" runat="server" Text="0"></asp:Label> 件商品
                    </div>
                </div>

                <!-- 商品网格 -->
                <asp:Panel ID="pnlProducts" runat="server">
                    <div class="products-grid">
                        <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                            <ItemTemplate>
                                <div class="product-item">
                                    <a href='ProductDetail.aspx?productId=<%# Eval("ProductId") %>' class="product-link">
                                        <div class="product-image">
                                            <img src='<%# Eval("ProductImage") %>' 
                                                 alt='<%# Eval("ProductName") %>'
                                                 onerror="this.src='images/default-product.jpg'" />
                                        </div>
                                        <div class="product-info">
                                            <h3 class="product-name"><%# Eval("ProductName") %></h3>
                                            <p class="product-desc"><%# GetShortDescription(Eval("Description")) %></p>
                                            <div class="product-price">
                                                <span class="price">¥<%# Eval("Price", "{0:F2}") %></span>
                                                <span class="stock">库存 <%# Eval("Stock") %></span>
                                            </div>
                                        </div>
                                    </a>
                                    <div class="product-actions">
                                        <asp:LinkButton ID="lnkAddToCart" runat="server" 
                                            CommandName="AddToCart"
                                            CommandArgument='<%# Eval("ProductId") %>'
                                            CssClass="btn-add-cart">
                                            加入购物车
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <!-- 无商品提示 -->
                <asp:Panel ID="pnlNoProducts" runat="server" Visible="false">
                    <div class="empty-state">
                        <div class="empty-icon">📦</div>
                        <h3>暂无商品</h3>
                        <p>该分类下还没有商品</p>
                        <asp:LinkButton ID="lnkBackToAll" runat="server" 
                            OnClick="lnkAllCategories_Click" 
                            CssClass="btn-back">
                            查看全部商品
                        </asp:LinkButton>
                    </div>
                </asp:Panel>
            </div>
        </section>

        <!-- 特色服务 -->
        <section class="features-section">
            <div class="container">
                <div class="features-grid">
                    <div class="feature-item">
                        <div class="feature-icon">🚚</div>
                        <h3>全国配送</h3>
                        <p>满299元免运费</p>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">🔄</div>
                        <h3>7天无理由退换</h3>
                        <p>购物无忧保障</p>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">✅</div>
                        <h3>品质保证</h3>
                        <p>精选优质面料</p>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">💳</div>
                        <h3>安全支付</h3>
                        <p>多种支付方式</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- 页脚 -->
        <footer class="main-footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3>购物指南</h3>
                        <ul>
                            <li><a href="Register.aspx">新用户注册</a></li>
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
                    <p>Web开发技术课程设计作品</p>
                </div>
            </div>
        </footer>
    </form>

    <script>
        // 平滑滚动
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth' });
                }
            });
        });

        // 搜索框焦点效果
        const searchInput = document.querySelector('.search-input');
        if (searchInput) {
            searchInput.addEventListener('focus', function () {
                this.parentElement.classList.add('focused');
            });
            searchInput.addEventListener('blur', function () {
                this.parentElement.classList.remove('focused');
            });
        }
    </script>
</body>
</html>
