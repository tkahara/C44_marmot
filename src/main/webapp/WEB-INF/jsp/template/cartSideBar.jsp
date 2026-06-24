<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="model.Products"%>
<%
// カートの構造を Map<Products, Integer> (商品と数量のペア) に変更します
Map<Products, Integer> cartMap = (Map<Products, Integer>) session.getAttribute("cartMap");
int totalAmount = 0;
%>

<div class="offcanvas offcanvas-end" tabindex="-1" id="sideCart"
	aria-labelledby="sideCartLabel">

	<div class="offcanvas-header bg-light">
		<h5 class="offcanvas-title fw-bold" id="sideCartLabel">🛒 あなたのカート</h5>
		<button type="button" class="btn-close" data-bs-dismiss="offcanvas"
			aria-label="Close"></button>
	</div>

	<div class="offcanvas-body d-flex flex-column">

		<div
			class="d-flex justify-content-between border-bottom pb-2 mb-3 fw-bold">
			<div>商品名 / 数量</div>
			<span>値段</span>
		</div>

		<div class="flex-grow-1 overflow-auto" style="max-height: 60vh;">
			<%
			if (cartMap != null && !cartMap.isEmpty()) {
			%>
			<%
			// Mapの中身を1つずつ取り出してループ
			for (Map.Entry<Products, Integer> entry : cartMap.entrySet()) {
				Products p = entry.getKey();
				int qty = entry.getValue();
				int subTotal = p.getPrice() * qty; // 小計（単価 × 数量）
				totalAmount += subTotal; // 合計金額に加算
			%>
			<div class="border-bottom pb-3 mb-3">
				<div class="d-flex justify-content-between align-items-start mb-2">
					<div style="max-width: 70%;">
						<h6 class="mb-1 fw-bold"><%=p.getProductName()%></h6>
						<small class="text-muted">単価: <%=p.getPrice()%>円</small>
					</div>
					<span class="text-danger fw-bold fs-5"><%=subTotal%>円</span>
				</div>

				<div class="d-flex justify-content-between align-items-center">
					<div class="d-flex align-items-center">
						<span class="text-muted small me-2">数量:</span>
						<form action="CartUpdateServlet" method="POST" class="m-0">
							<input type="hidden" name="action" value="update"> 
							<input type="hidden" name="productName" value="<%=p.getProductName()%>"> 
							<select name="quantity" class="form-select form-select-sm"
								style="width: 75px;" onchange="this.form.submit()">
								<%
								for (int i = 1; i <= 10; i++) {
								%>
								<option value="<%=i%>" <%=(i == qty) ? "selected" : ""%>><%=i%></option>
								<%
								}
								%>
							</select>
						</form>
					</div>

					<form action="CartUpdateServlet" method="POST" class="m-0">
						<input type="hidden" name="action" value="delete"> 
						<input type="hidden" name="productName" value="<%=p.getProductName()%>">
						<button type="submit" class="btn btn-outline-danger btn-sm px-3">
							キャンセル
						</button>
					</form>
				</div>
			</div>
			<%
			}
			%>
			<%
			} else {
			%>
			<p class="text-center text-muted my-5">カートに商品は入っていません。</p>
			<%
			}
			%>
		</div>

		<div class="mt-auto pt-3 border-top bg-white">
			<%
			if (cartMap == null || cartMap.isEmpty()) {
			%>
			<div class="d-grid gap-2 pt-2">
				<a href="${pageContext.request.contextPath}/main"
					class="btn btn-success btn-lg text-center"> お買い物を続ける（商品一覧へ） </a>
			</div>
			<%
			} else {
			%>
			<h5 class="text-end fw-bold mb-3">
				合計: <span class="text-danger"><%=totalAmount%></span> 円
			</h5>
			<div class="d-grid gap-2">
				<a href="${pageContext.request.contextPath}/CheckoutServlet"
					class="btn btn-success btn-lg"> 購入手続きへ進む </a> 
				<a href="${pageContext.request.contextPath}/main"
					class="btn btn-outline-secondary"> 買い物を続ける（商品一覧へ） </a>
			</div>
			<%
			}
			%>
		</div>

	</div>
</div>