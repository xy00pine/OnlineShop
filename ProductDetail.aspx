<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProductDetail.aspx.cs" Inherits="ProductDetail" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>商品详情 - 童装商城</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        .product-detail-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .breadcrumb {
            padding: 15px 0;
            font-size: 13px;
            color: #666;
        }

        .breadcrumb a {
            color: #666;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            color: #000;
        }

        .product-detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            background: #fff;
            padding: 40px;
        }

        .product-images {
            position: sticky;
            top: 100px;
            height: fit-content;
        }

        .main-image {
            width: 100%;
            aspect-ratio: 3/4;
            object-fit: cover;
            background: #f4f4f4;
            margin-bottom: 15px;
        }

        .thumbnail-images {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }

        .thumbnail {
            width: 100%;
            aspect-ratio: 3/4;
            object-fit: cover;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.3s;
        }

        .thumbnail:hover {
            border-color: #000;
        }

        .product-info-section {
            padding: 20px 0;
        }

        .product-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
            line-height: 1.3;
        }

        .product-brand {
            font-size: 14px;
            color: #999;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .product-price-section {
            padding: 30px 0;
            border-top: 1px solid #e5e5e5;
            border-bottom: 1px solid #e5e5e5;
        }

        .current-price {
            font-size: 36px;
            font-weight: 700;
            color: #000;
        }

        .product-meta {
            padding: 30px 0;
            border-bottom: 1px solid #e5e5e5;
        }

        .meta-row {
            display: flex;
            padding: 12px 0;
            font-size: 14px;
        }

        .meta-label {
            width: 120px;
            color: #666;
            font-weight: 500;
        }

        .meta-value {
            flex: 1;
            color: #000;
        }

        .stock-warning {
            color: #ff6b00;
            font-weight: 500;
        }

        .stock-out {
            color: #f5222d;
            font-weight: 500;
        }

        .product-options {
            padding: 30px 0;
        }

        .option-group {
            margin-bottom: 30px;
        }

        .option-label {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 12px;
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .size-select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e5e5e5;
            font-size: 14px;
            background: #fff;
            cursor: pointer;
        }

        .size-select:focus {
            outline: none;
            border-color: #000;
        }

        .quantity-group {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .quantity-control {
            display: flex;
            border: 1px solid #e5e5e5;
        }

        .quantity-btn {
            width: 40px;
            height: 40px;
            border: none;
            background: #fff;
            cursor: pointer;
            font-size: 18px;
            color: #666;
        }

        .quantity-btn:hover {
            background: #f4f4f4;
        }

        .quantity-input {
            width: 60px;
            height: 40px;
            border: none;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-add-cart {
            flex: 1;
            padding: 16px;
            background: #fff;
            color: #000;
            border: 2px solid #000;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            letter-spacing: 0.5px;
        }

        .btn-add-cart:hover {
            background: #000;
            color: #fff;
        }

        .btn-buy-now {
            flex: 1;
            padding: 16px;
            background: #000;
            color: #fff;
            border: 2px solid #000;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            letter-spacing: 0.5px;
        }

        .btn-buy-now:hover {
            background: #333;
            border-color: #333;
        }

        .btn-add-cart:disabled,
        .btn-buy-now:disabled {
            background: #f4f4f4;
            color: #999;
            border-color: #e5e5e5;
            cursor: not-allowed;
        }

        .product-description {
            padding: 40px 0;
            border-top: 1px solid #e5e5e5;
        }

        .description-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .description-content {
            font-size: 14px;
            line-height: 1.8;
            color: #666;
        }

        @media (max-width: 768px) {
            .product-detail {
                grid-template-columns: 1fr;
                gap: 30px;
                padding: 20px;
            }

            .product-images {
                position: static;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- 顶部栏 -->
        <div class="top-bar">
            <div class="top-bar-container">
                <div>欢迎来到童装商城</div>
                <div>
                    <a href="Default.aspx">返回首页</a>
                    <a href="shoppingCart.aspx">购物车</a>
                </div>
            </div>
        </div>

        <!-- 主导航 -->
        <div class="header">
            <div class="nav-container">
                <a href="Default.aspx" class="logo">👶 童装商城</a>
                <nav class="main-nav">
                    <a href="Default.aspx">首页</a>
                    <a href="Default.aspx?categoryId=1">男童</a>
                    <a href="Default.aspx?categoryId=2">女童</a>
                    <a href="Default.aspx?categoryId=3">婴儿</a>
                </nav>
            </div>
        </div>

        <!-- 面包屑导航 -->
        <div class="product-detail-container">
            <div class="breadcrumb">
                <a href="Default.aspx">首页</a> / 
                <span>商品详情</span>
            </div>

            <!-- 商品详情 -->
            <div class="product-detail">
                <!-- 左侧：商品图片 -->
                <div class="product-images">
                    <asp:Image ID="imgProduct" runat="server" CssClass="main-image" />
                </div>

                <!-- 右侧：商品信息 -->
                <div class="product-info-section">
                    <h1 class="product-title">
                        <asp:Label ID="lblProductName" runat="server"></asp:Label>
                    </h1>
                    <div class="product-brand">
                        品牌：<asp:Label ID="lblBrand" runat="server"></asp:Label>
                    </div>

                    <!-- 价格 -->
                    <div class="product-price-section">
                        <div class="current-price">
                            <asp:Label ID="lblPrice" runat="server"></asp:Label>
                        </div>
                    </div>

                    <!-- 商品信息 -->
                    <div class="product-meta">
                        <div class="meta-row">
                            <span class="meta-label">分类</span>
                            <span class="meta-value">
                                <asp:Label ID="lblCategory" runat="server"></asp:Label>
                            </span>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">适合年龄</span>
                            <span class="meta-value">
                                <asp:Label ID="lblForAges" runat="server"></asp:Label>
                            </span>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">库存</span>
                            <span class="meta-value">
                                <asp:Label ID="lblStock" runat="server"></asp:Label> 件
                            </span>
                        </div>
                    </div>

                    <!-- 选项 -->
                    <div class="product-options">
                        <!-- 尺码选择 -->
                        <div class="option-group">
                            <label class="option-label">选择尺码</label>
                            <asp:DropDownList ID="ddlSize" runat="server" CssClass="size-select">
                                <asp:ListItem Value="">请选择尺码</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- 数量选择 -->
                        <div class="option-group">
                            <label class="option-label">数量</label>
                            <div class="quantity-group">
                                <div class="quantity-control">
                                    <button type="button" class="quantity-btn" onclick="decreaseQuantity()">−</button>
                                    <asp:TextBox ID="txtQuantity" runat="server" CssClass="quantity-input" 
                                        Text="1" TextMode="Number"></asp:TextBox>
                                    <button type="button" class="quantity-btn" onclick="increaseQuantity()">+</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 操作按钮 -->
                    <div class="action-buttons">
                        <asp:Button ID="btnAddToCart" runat="server" Text="加入购物车" 
                            CssClass="btn-add-cart" OnClick="btnAddToCart_Click" />
                        <asp:Button ID="btnBuyNow" runat="server" Text="立即购买" 
                            CssClass="btn-buy-now" OnClick="btnBuyNow_Click" />
                    </div>

                    <!-- 商品描述 -->
                    <div class="product-description">
                        <h3 class="description-title">商品详情</h3>
                        <div class="description-content">
                            <asp:Label ID="lblDescription" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 页脚 -->
        <div class="footer">
            <div class="footer-container">
                <div class="footer-bottom">
                    <p>&copy; 2024 童装商城. All rights reserved.</p>
                </div>
            </div>
        </div>
    </form>

    <script>
        function increaseQuantity() {
            var input = document.getElementById('<%= txtQuantity.ClientID %>');
            var value = parseInt(input.value) || 1;
            input.value = value + 1;
        }

        function decreaseQuantity() {
            var input = document.getElementById('<%= txtQuantity.ClientID %>');
            var value = parseInt(input.value) || 1;
            if (value > 1) {
                input.value = value - 1;
            }
        }
    </script>
</body>
</html>
