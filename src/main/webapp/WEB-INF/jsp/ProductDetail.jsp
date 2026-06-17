<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Products" %>
<%
    // サーブレットで保存した「products」データを取り出す
    Products products = (Products) request.getAttribute("products");
%>

<%@ include file="template/header.jsp" %>
<%@ include file="template/dialogs.jsp" %>
<%@ include file="template/cartSideBar.jsp" %>

<main class="container my-5">
    <% if (products != null) { %>
        <div class="row">
            <div class="col-md-6 text-center bg-light p-5 rounded">
                <img src="<%= products.getImagePath() %>" alt="<%= products.getProductName() %>" class="img-fluid rounded shadow-sm">
            </div>
            
            <div class="col-md-6">
                <h1 class="fw-bold"><%= products.getProductName() %></h1>
                <h3 class="text-danger fw-bold my-3"><%= products.getPrice() %> 円（税込）</h3>
                <hr>
                <p class="lead"><%= products.getDescription() %></p>
                
                <form action="addToCart" method="post" class="mt-4">
                    <input type="hidden" name="productName" value="<%= products.getProductName() %>">
                    
                    <div class="mb-3 d-flex align-items-center gap-2" style="max-width: 200px;">
                        <label class="form-label mb-0 text-nowrap">数量：</label>
                        <input type="number" class="form-control" name="quantity" value="1" min="1">
                    </div>
                    
                    <button type="submit" class="btn btn-success btn-lg w-100">🛒 カートに追加する</button>
                </form>
            </div>
        </div>
    <% } else { %>
        <div class="alert alert-danger text-center">
            該当の商品が見つかりませんでした。
        </div>
    <% } %>
</main>

<%@ include file="template/footer.jsp" %>

<%-- 
  ★ここから追加：カート自動オープン用のJavaScript 
  サーブレット側からリダイレクトやフォワードのURLパラメータとして「added=true」が送られてきた時だけ発動します
--%>
<%
    String added = request.getParameter("added");
    if ("true".equals(added)) {
%>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // template/cartSideBar.jsp の中にある id="sideCart" の要素を取得します
            var sideCartElement = document.getElementById('sideCart');
            
            if (sideCartElement) {
                // BootstrapのOffcanvas機能を使って、裏側から自動で開きます
                var bsOffcanvas = new bootstrap.Offcanvas(sideCartElement);
                bsOffcanvas.show();
            }
        });
    </script>
<%
    }
%>