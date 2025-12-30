<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SearchProduct.aspx.cs" Inherits="SearchProduct" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>商品搜索 - 童装商城</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            background: #f5f5f5;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .nav a {
            color: white;
            text-decoration: none;
            margin-left: 30px;
            transition: opacity 0.3s;
        }

        .nav a:hover {
            opacity: 0.8;
        }

        .search-section {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .search-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .search-input {
            display: flex;
            gap: 10px;
        }

        .search-input input {
            flex: 1;
            padding: 15px 20px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
        }

        .search-input input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn-search {
            background: #667eea;
            color: white;
            padding: 15px 40px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-search:hover {
            background: #5568d3;
        }

        .search-result {
            margin-top: 20px;
        }

        .result-info {
            background: #f0f7ff;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            color: #1890ff;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .product-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: all 0.3s;
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .product-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
        }

        .product-info {
            padding: 15px;
        }

        .product-name {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 10px;
            color: #333;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .product-price {
            color: #ff4d4f;
            font-size: 20px;
            font-weight: bold;
        }

        .no-result {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .no-result::before {
            content: "🔍";
            display: block;
            font-size: 60px;
            margin-bottom: 20px;
        }

        .no-result p {
            color: #999;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- 头部 -->
        <div class="header">
            <div class="header-content">
                <div class="logo">👶 童装商城</div>
                <div class="nav">
                    <a href="Default.aspx">首页</a>
                    <a href="ShoppingCart.aspx">购物车</a>
                    <a href="MyOrders.aspx">我的订单</a>
                    <% if (Session["Username"] != null) { %>
                        <span>欢迎，<%= Session["Username"] %></span>
                        <asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">退出</asp:LinkButton>
                    <% } else { %>
                        <a href="userLogin.aspx">登录</a>
                        <a href="userRegister.aspx">注册</a>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- 搜索区域 -->
        <div class="search-section">
            <div class="search-box">
                <h2 style="margin-bottom: 20px; color: #333;">🔍 搜索商品</h2>
                <div class="search-input">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="请输入商品名称..." />
                    <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn-search" OnClick="btnSearch_Click" />
                </div>
            </div>

            <!-- 搜索结果 -->
            <div class="search-result">
                <asp:Panel ID="pnlResult" runat="server" Visible="false">
                    <div class="result-info">
                        找到 <strong><asp:Label ID="lblResultCount" runat="server"></asp:Label></strong> 个相关商品
                    </div>
                    
                    <asp:DataList ID="dlProducts" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="product-grid">
                        <ItemTemplate>
                            <a href='ProductDetail.aspx?productId=<%# Eval("ProductId") %>' class="product-card">
                                <img src='<%# Eval("ProductImage") %>' alt='<%# Eval("ProductName") %>' class="product-image" />
                                <div class="product-info">
                                    <div class="product-name"><%# Eval("ProductName") %></div>
                                    <div class="product-price">¥<%# Eval("Price", "{0:F2}") %></div>
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:DataList>
                </asp:Panel>

                <asp:Panel ID="pnlNoResult" runat="server" Visible="false">
                    <div class="no-result">
                        <p>没有找到相关商品</p>
                        <p style="margin-top: 10px; color: #ccc;">请尝试其他关键词</p>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>
