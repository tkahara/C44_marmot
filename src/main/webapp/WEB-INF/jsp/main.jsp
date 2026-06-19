<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Products" %>
<%
    // 商品リストを取得
    List<Products> productsList = (List<Products>) request.getAttribute("productsList");

    // 🌟 サーブレットから渡されたエラー属性を最優先で取得（なければURLパラメータも確認）
    String error = (String) request.getAttribute("error");
    if (error == null) {
        error = request.getParameter("error");
    }
%>

<%@ include file="template/header.jsp" %>
<%@ include file="template/dialogs.jsp" %>
<%@ include file="template/cartSideBar.jsp" %>

<main class="container my-5">
    <%-- 🌟 エラーメッセージ表示エリア --%>
    <% if (error != null && !error.isEmpty()) { %>
        <% 
            // エラーの種類に応じてBootstrapのアラート色（黄色か赤色か）を判定
            boolean isWarning = "invalid_access".equals(error);
            String alertClass = isWarning ? "alert-warning" : "alert-danger";
        %>
        <div class="alert alert-dismissible fade show mb-4 <%= alertClass %>" role="alert">
            <strong>
                <% if ("invalid_access".equals(error)) { %>
                    ご注意: 注文完了画面へは直接アクセスできません。注文操作を最初からやり直してください。
                <% } else if ("order_failed".equals(error)) { %>
                    エラー: 注文処理中に問題が発生しました。再度お試しください。
                <% } else { %>
                    <%-- サーブレットから具体的なテキストメッセージが直接渡された場合はそのまま表示 --%>
                    <%= error %>
                <% } %>
            </strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <h2 class="mb-4">商品一覧</h2>
    
    <div class="row">
        <% if (productsList != null && !productsList.isEmpty()) { %>
            <% for (Products p : productsList) { %>
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="<%= p.getImagePath() %>" alt="<%= p.getProductName() %>" class="card-img-top img-fluid" style="height: 200px; object-fit: cover;">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title fw-bold"><%= p.getProductName() %></h5>
                            <p class="card-text text-danger fw-bold fs-5"><%= p.getPrice() %>円</p>
                            <a href="productDetail?productName=<%= p.getProductName() %>" class="btn btn-primary w-100 mt-auto">詳細を見る</a>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="col-12 text-center">
                <p class="alert alert-warning">現在、販売中の商品はございません。</p>
            </div>
        <% } %>
    </div>
</main>

<%@ include file="template/footer.jsp" %>