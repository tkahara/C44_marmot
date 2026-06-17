<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ★JavaのListやモデルクラスを使えるようにインポート --%>
<%@ page import="java.util.List" %>
<%@ page import="model.Products" %>
<%
    // サーブレットから渡された商品のリストを取り出す
    List<Products> productsList = (List<Products>) request.getAttribute("productsList");
%>

<%@ include file="template/header.jsp" %>
<%@ include file="template/dialogs.jsp" %>
<%@ include file="template/cartSideBar.jsp" %>

<main class="container my-5">
    <h2 class="mb-4">商品一覧</h2>
    <div class="row">
        
        <% if (productsList != null && !productsList.isEmpty()) { %>
            <%-- ★商品リストの数だけループ処理を回す --%>
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
            <div class="col-100 text-center">
                <p class="alert alert-warning">現在、販売中の商品はございません。</p>
            </div>
        <% } %>
        
    </div>
</main>

<%@ include file="template/footer.jsp" %>