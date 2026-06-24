<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="model.Products"%>
<%
// 🌟 セッションからログインエラーメッセージを取得します
String loginError = (String) session.getAttribute("loginError");
%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/dialogs.css">
<style>
</style>

<div class="modal fade tea-modal" id="loginModal" tabindex="-1"
	aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">🔑 ログイン</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<form action="LoginServlet" method="post">
				<div class="modal-body p-4">
					
					<%-- 🌟 修正：request ではなく、上で取得した session 由来の loginError を参照 --%>
					<% if (loginError != null) { %>
					<div class="alert alert-danger mb-3 py-2 text-center">
						<small class="fw-bold">⚠️ <%= loginError %></small>
					</div>
					<% } %>
					
					<div class="mb-3">
						<label class="form-label fw-bold small">ユーザーID</label> <input
							type="text" class="form-control" name="userId" required>
					</div>
					<div class="mb-3">
						<label class="form-label fw-bold small">パスワード</label> <input
							type="password" class="form-control" name="pass" required>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-tea-modal-cancel"
						data-bs-dismiss="modal">キャンセル</button>
					<button type="submit" class="btn btn-tea-modal-primary px-4">ログインする</button>
				</div>
			</form>
		</div>
	</div>
</div>

<div class="modal fade tea-modal" id="logoutConfirmModal" tabindex="-1"
	aria-hidden="true">
	<div class="modal-dialog modal-sm modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">確認</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body text-center py-4 fw-bold">本当にログアウトしますか？</div>
			<div class="modal-footer d-flex justify-content-center">
				<button type="button" class="btn btn-tea-modal-cancel"
					data-bs-dismiss="modal">キャンセル</button>
				<form action="Logout" method="post" class="m-0">
					<button type="submit" class="btn btn-tea-modal-danger">ログアウト</button>
				</form>
			</div>
		</div>
	</div>
</div>

<script>
	document.addEventListener("DOMContentLoaded", function() {
		<%-- 🌟 修正：共通の loginError 変数で判定 --%>
		<% if (loginError != null) { %>
			new bootstrap.Modal(document.getElementById('loginModal')).show();
			
			<%-- 🌟 表示が終わったら、セッションからエラーを削除してクリーンアップ --%>
			<% session.removeAttribute("loginError"); %>
		<% } %>
	});
</script>