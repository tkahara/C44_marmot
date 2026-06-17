<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="loginModalLabel">🔑 ログイン</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="login" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="userId" class="form-label">ユーザーID</label>
                        <input type="text" class="form-control" id="userId" name="userId" required placeholder="example@marmot.com">
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">パスワード</label>
                        <input type="password" class="form-control" id="password" name="password" required placeholder="••••••••">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">キャンセル</button>
                    <button type="submit" class="btn btn-primary">ログインする</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="logoutConfirmModal" tabindex="-1" aria-labelledby="logoutConfirmLabel" aria-hidden="true">
    <div class="modal-dialog modal-sm modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="logoutConfirmLabel">確認</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                本当にログアウトしますか？
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">キャンセル</button>
                <form action="logout" method="post">
                    <button type="submit" class="btn btn-danger">ログアウト</button>
                </form>
            </div>
        </div>
    </div>
</div>