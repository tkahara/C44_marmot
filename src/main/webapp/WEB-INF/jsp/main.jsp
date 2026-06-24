<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.NumberFormat"%>
<%-- 追加 --%>

<%
// pageContextから取得を試みる
NumberFormat nf = (NumberFormat) pageContext.getAttribute("nf");

// もしnull（取得失敗）なら、その場で生成してセットする
if (nf == null) {
	nf = NumberFormat.getNumberInstance();
	pageContext.setAttribute("nf", nf);
}
// 商品リスト取得
List<Products> productsList = (List<Products>) request.getAttribute("productsList");

// 🌟 サーブレットエラー（request優先）
String error = (String) request.getAttribute("error");

if (error == null) {
	error = request.getParameter("error");
}

// 🔥 追加：セッションエラー（OrderCompleteServlet用）
String sessionError = (String) session.getAttribute("errorMessage");

if (error == null) {
	error = sessionError;
}

// 表示後は削除（重要：毎回出ないようにする）
session.removeAttribute("errorMessage");
%>

<%@ include file="template/header.jsp"%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/main.css">
<%@ include file="template/dialogs.jsp"%>
<%@ include file="template/cartSideBar.jsp"%>

<main class="container my-5">

	<%-- 🌟 エラーメッセージ表示エリア --%>
	<%
	if (error != null && !error.isEmpty()) {
	%>
	<%
	boolean isWarning = "invalid_access".equals(error);
	String alertClass = isWarning ? "alert-warning" : "alert-danger";
	%>

	<div class="alert alert-dismissible fade show mb-4 <%=alertClass%>"
		role="alert">
		<strong> <%
 if ("invalid_access".equals(error)) {
 %> ご注意: 注文完了画面へは直接アクセスできません。注文操作を最初からやり連してください。 <%
 } else if ("order_failed".equals(error)) {
 %> エラー: 注文処理中に問題が発生しました。再度お試しください。 <%
 } else if (error.contains("すでに完了")) {
 %> ⚠️ <%=error%> <%
 } else {
 %> <%=error%> <%
 }
 %>
		</strong>

		<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
	</div>
	<%
	}
	%>

	<h2 class="mb-4">商品一覧</h2>

	<div class="row">
		<%
		if (productsList != null && !productsList.isEmpty()) {
		%>
		<%
		for (Products p : productsList) {
		%>
		<div class="col-md-4 mb-4">
			<div class="card h-100 shadow-sm">
				<img src="<%=p.getImagePath()%>" alt="<%=p.getProductName()%>"
					class="card-img-top img-fluid"
					style="height: 200px; object-fit: cover;">

				<div class="card-body d-flex flex-column">
					<h5 class="card-title fw-bold"><%=p.getProductName()%></h5>
					<p class="card-text text-danger fw-bold fs-5">
						<%=nf.format(p.getPrice())%>円
					</p>

					<a href="productDetail?productName=<%=p.getProductName()%>"
						class="btn btn-primary w-100 mt-auto"> 詳細を見る </a>
				</div>
			</div>
		</div>
		<%
		}
		%>
		<%
		} else {
		%>
		<div class="col-12 text-center">
			<p class="alert alert-warning">現在、販売中の商品はございません。</p>
		</div>
		<%
		}
		%>
	</div>
</main>

<%-- 🌟 ここから追加：退会完了通知用モーダル（ダイアログ） --%>
<div class="modal fade" id="withdrawnCompleteModal" tabindex="-1"
	aria-labelledby="withdrawnModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content"
			style="border-radius: 14px; border: 1px solid rgba(111, 78, 55, 0.15); background-color: #FFFFFF;">

			<div class="modal-header"
				style="background-color: rgba(111, 78, 55, 0.03); border-bottom: 1px solid rgba(111, 78, 55, 0.1);">
				<h5 class="modal-title fw-bold" id="withdrawnModalLabel"
					style="color: #6f4e37;">手続き完了</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>

			<div class="modal-body py-4 text-center">
				<div class="mb-3" style="font-size: 2.5rem;">✨</div>
				<h6 class="fw-bold mb-2" style="color: #333333;">退会手続きが完了いたしました</h6>
				<p class="text-muted small mb-0">
					当サイトをご利用いただき、誠にありがとうございました。<br> またのご来店をスタッフ一同、心よりお待ち申し上げております。
				</p>
			</div>

			<div class="modal-footer justify-content-center"
				style="border-top: 1px solid rgba(111, 78, 55, 0.1); background-color: rgba(111, 78, 55, 0.01);">
				<button type="button" class="btn btn-tea-outline px-5"
					data-bs-dismiss="modal"
					style="background-color: #6f4e37; color: white; border: none; border-radius: 6px; padding: 8px 24px;">確認</button>
			</div>

		</div>
	</div>
</div>

<%-- 🌟 パラメータ自動検知＆モーダル起動スクリプト --%>
<script type="text/javascript">
	window.addEventListener('DOMContentLoaded', function() {
		// 1. URLの後ろについているパラメータ（?withdrawn=true）を取得
		const urlParams = new URLSearchParams(window.location.search);

		// 2. 「withdrawn」が「true」だった場合、自動でモーダルを起動する
		if (urlParams.get('withdrawn') === 'true') {
			const myModal = new bootstrap.Modal(document
					.getElementById('withdrawnCompleteModal'));
			myModal.show();

			// 🌟 お見事ポイント
			// モーダル表示後、URLから「?withdrawn=true」という見た目の悪い文字を自動で消去します。
			// これにより、ユーザーがページをF5キーなどで手動リロードした時にダイアログが何度も出なくなります。
			history.replaceState(null, '', window.location.pathname);
		}
	});
</script>
<%-- 🌟 ここまで追加 --%>

<%@ include file="template/footer.jsp"%>