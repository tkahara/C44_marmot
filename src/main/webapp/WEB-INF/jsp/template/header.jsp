<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>マーモット ECサイト</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container">
            
            <a class="navbar-brand fw-bold" href="main">🛒 マーモット</a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <div class="navbar-nav ms-auto gap-2 align-items-center">
                    
                    <%-- Javaのセッションを確認してボタンを切り替え --%>
                    <% if (session.getAttribute("loginUser") == null) { %>
                        
                        <button type="button" class="btn btn-outline-success" data-bs-toggle="offcanvas" data-bs-target="#sideCart">
                            🛒 カート
                        </button>
                        
                        <button type="button" class="btn btn-outline-light" data-bs-toggle="modal" data-bs-target="#loginModal">
                            ログイン
                        </button>
                        <a href="register.jsp" class="btn btn-warning">
                            新規登録
                        </a>
                        
                    <% } else { %>
                        
                        <span class="navbar-text text-white me-2">ようこそ、会員 様</span>
                        
                        <a href="mypage.jsp" class="btn btn-outline-info">
                            マイページ
                        </a>
                        
                        <button type="button" class="btn btn-outline-success" data-bs-toggle="offcanvas" data-bs-target="#sideCart">
                            🛒 カート
                        </button>
                        
                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#logoutConfirmModal">
                            ログアウト
                        </button>
                        
                    <% } %>

                </div>
            </div>
            
        </div>
    </nav>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>