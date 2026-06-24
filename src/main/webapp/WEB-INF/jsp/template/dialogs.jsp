<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="model.Products"%>
<%
// 🌟 セッションからログインエラーメッセージを取得します
String loginError = (String) session.getAttribute("loginError");

// 🌟【追加】セッションから会員登録成功フラグを取得します
Boolean regSuccess = (Boolean) session.getAttribute("registerSuccess");
%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/dialogs.css">
<style>
</style>

<%-- ========================================================= --%>
<%-- 🔑 ログインモーダル                                        --%>
<%-- ========================================================= --%>
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

<%-- ========================================================= --%>
<%-- 🚪 ログアウト確認モーダル                                   --%>
<%-- ========================================================= --%>
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

<%-- ========================================================= --%>
<%-- 🎉【追加】会員登録完了モーダル                              --%>
<%-- ========================================================= --%>
<div class="modal fade tea-modal" id="registerSuccessModal" tabindex="-1"
	aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="border-radius: 14px; border: none; box-shadow: 0 10px 30px rgba(74, 51, 37, 0.15); background-color: #FFFFFF;">
			<div class="modal-body text-center p-5">
				<%-- register.jsp側の変数は参照できない可能性があるため直接カラーコード or クラスで指定 --%>
				<div style="font-size: 4rem; color: #C5A059;">✨</div>
				<h4 class="fw-bold mb-3" style="color: #4A3325;">会員登録が完了しました！</h4>
				<p class="text-muted small mb-4">マーモット-TEA- へようこそ。<br>特別なティータイムをお楽しみください。</p>
				<div class="d-grid">
					<button type="button" class="btn fw-bold text-white" data-bs-dismiss="modal" style="background-color: #6F4E37; border-radius: 6px; padding: 12px;">
						お買い物を始める
					</button>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
	document.addEventListener("DOMContentLoaded", function() {
		<%-- 🌟 既存処理：ログインエラーがあれば自動表示してクリーンアップ --%>
		<% if (loginError != null) { %>
			new bootstrap.Modal(document.getElementById('loginModal')).show();
			<% session.removeAttribute("loginError"); %>
		<% } %>

		<%-- 🌟【追加】登録成功フラグがあれば自動表示してクリーンアップ --%>
		<% if (regSuccess != null && regSuccess) { %>
			var successModalEl = document.getElementById('registerSuccessModal');
			if (successModalEl) {
				new bootstrap.Modal(successModalEl).show();
			}
			<% session.removeAttribute("registerSuccess"); %>
		<% } %>
	});
</script>