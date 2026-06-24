<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dialogs.css">
<style>
    /* ...既存のCSSはそのまま維持... */
    :root {
        --tea-modal-primary: #6F4E37;
        --tea-modal-dark: #4A3325;
        --tea-modal-accent: #C5A059;
        --tea-modal-danger: #A94442;
    }
    .tea-modal .modal-content { border: 1px solid rgba(111, 78, 55, 0.15); border-radius: 14px; box-shadow: 0 10px 30px rgba(74, 51, 37, 0.1); background-color: #FFFFFF; color: var(--tea-modal-dark); }
    .tea-modal .modal-header { border-bottom: 1px solid rgba(111, 78, 55, 0.1); background-color: rgba(111, 78, 55, 0.02); border-top-left-radius: 13px; border-top-right-radius: 13px; padding: 16px 20px; }
    .tea-modal .modal-title { color: var(--tea-modal-dark); font-weight: bold; letter-spacing: 0.03em; }
    .tea-modal .form-control { border: 1px solid rgba(111, 78, 55, 0.25); border-radius: 6px; padding: 10px 12px; }
    .tea-modal .form-control:focus { border-color: var(--tea-modal-primary); box-shadow: 0 0 0 0.25rem rgba(111, 78, 55, 0.15); }
    .btn-tea-modal-primary { background-color: var(--tea-modal-primary); border-color: var(--tea-modal-primary); color: #FFF; font-weight: bold; border-radius: 6px; transition: all 0.2s; }
    .btn-tea-modal-primary:hover { background-color: var(--tea-modal-dark); color: #FFF; }
    .btn-tea-modal-cancel { color: var(--tea-modal-primary); background-color: transparent; border: 1px solid rgba(111, 78, 55, 0.4); border-radius: 6px; }
    .btn-tea-modal-danger { background-color: var(--tea-modal-danger); border-color: var(--tea-modal-danger); color: #FFF; font-weight: bold; border-radius: 6px; }
    .tea-modal-link { color: var(--tea-modal-primary); text-decoration: none; font-weight: 500; }
    .tea-modal-link:hover { color: var(--tea-modal-accent); text-decoration: underline; }
</style>

<div class="modal fade tea-modal" id="loginModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">🔑 ログイン</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="LoginServlet" method="post">
                <div class="modal-body p-4">
                    <% if (request.getAttribute("loginError") != null) { %>
                        <div class="alert alert-danger mb-3 py-2 text-center">
                            <small class="fw-bold">⚠️ <%= request.getAttribute("loginError") %></small>
                        </div>
                    <% } %>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">ユーザーID</label>
                        <input type="text" class="form-control" name="userId" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">パスワード</label>
                        <input type="password" class="form-control" name="pass" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-tea-modal-cancel" data-bs-dismiss="modal">キャンセル</button>
                    <button type="submit" class="btn btn-tea-modal-primary px-4">ログインする</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade tea-modal" id="logoutConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-sm modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">確認</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center py-4 fw-bold">本当にログアウトしますか？</div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-tea-modal-cancel" data-bs-dismiss="modal">キャンセル</button>
                <form action="Logout" method="post" class="m-0">
                    <button type="submit" class="btn btn-tea-modal-danger">ログアウト</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    <% if (request.getAttribute("loginError") != null) { %>
        new bootstrap.Modal(document.getElementById('loginModal')).show();
    <% } %>
});
</script>