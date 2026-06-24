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
                <h1 class="fw-bold" style="color: #4A3325;"><%= products.getProductName() %></h1>
                <h3 class="text-danger fw-bold my-3"><%= products.getPrice() %> 円（税込）</h3>
                <hr style="border-color: rgba(111, 78, 55, 0.15);">
                
                <div class="product-description-section mb-4">
                    <p class="lead mb-2" style="line-height: 1.6; color: #4A3325;"><%= products.getDescription() %></p>
                    
                    <%-- 💡 追記：おひとり様10点までの米印注意書き --%>
    
                </div>
                
                <form action="addToCart" method="post" class="mt-4">
                    <input type="hidden" name="productName" value="<%= products.getProductName() %>">
                    
                    <div class="mb-4 d-flex align-items-center gap-2" style="max-width: 200px;">
                        <label for="quantity" class="form-label mb-0 text-nowrap fw-bold" style="color: #4A3325;">数量：</label>
                        
                        <%-- 💡 修正：input[type=number] から 1〜10 のプルダウン（選択式）へ変更 --%>
                        <select class="form-select" id="quantity" name="quantity" required style="border: 1px solid rgba(111, 78, 55, 0.25);">
                            <% for(int i = 1; i <= 10; i++) { %>
                                <option value="<%= i %>"><%= i %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <%-- ☕ ボタンの色も、もしTea Salonのテーマに合わせるなら以下のように変更可能です --%>
                    <button type="submit" class="btn btn-lg w-100 text-white fw-bold" style="background-color: #6F4E37; border-radius: 6px; box-shadow: 0 2px 4px rgba(111,78,55,0.2);">
                        🛒 カートに追加する
                    </button>
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
  ★カート自動オープン用のJavaScript 
--%>
<%
    String added = request.getParameter("added");
    if ("true".equals(added)) {
%>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var sideCartElement = document.getElementById('sideCart');
            if (sideCartElement) {
                var bsOffcanvas = new bootstrap.Offcanvas(sideCartElement);
                bsOffcanvas.show();
            }
        });
    </script>
<%
    }
%>