<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="model.Products" %>
<%@ page import="model.User" %>
<%
    // 1. カート情報の取得
    Map<Products, Integer> confirmCartMap = (Map<Products, Integer>) session.getAttribute("cartMap");

    // =========================================================
    // 🌟【修正】OrderConfirmServletが一本化してくれた共通キーから直接受け取る
    // これにより、ログイン・ゲストに関わらず必ず正しいデータがここに入ります！
    // =========================================================
    String name = (String) session.getAttribute("orderName");
    String email = (String) session.getAttribute("orderEmail");
    String zip = (String) session.getAttribute("orderZip");
    String address = (String) session.getAttribute("orderAddress");
    String tel = (String) session.getAttribute("orderTel");
    
    // 現在選択されている決済方法（セッションにあればそれを利用）
    String currentPayment = (String) session.getAttribute("guestPayment");
    if (currentPayment == null) currentPayment = "credit"; // デフォルト
    
    int confirmTotalAmount = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注文内容の確認</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<%@ include file="template/header.jsp" %>
<%@ include file="template/dialogs.jsp" %>
<%@ include file="template/cartSideBar.jsp" %>

<div class="container my-5" style="max-width: 850px;">
    <h2 class="mb-4 fw-bold text-center">📋 注文内容の確認</h2>
    
    <div class="card shadow-sm p-4 bg-white mb-4">
        <h5 class="fw-bold border-bottom pb-2 mb-3">👤 お届け先・お客様情報</h5>
        <table class="table table-borderless m-0">
            <tr><th style="width: 20%;">お名前</th><td><%= name %> 様</td></tr>
            <tr><th>メール</th><td><%= email %></td></tr>
            <tr><th>郵便番号</th><td><%= (zip != null && !zip.isEmpty()) ? "〒" + zip : "なし" %></td></tr>
            <tr><th>ご住所</th><td><%= address %></td></tr>
            <tr><th>電話番号</th><td><%= tel %></td></tr>
        </table>
    </div>

    <form action="OrderCompleteServlet" method="POST">
        <div class="card shadow-sm p-4 bg-white mb-4">
            <h5 class="fw-bold border-bottom pb-2 mb-3">💳 決済方法の選択</h5>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="payment" id="pay1" value="credit" <%= "credit".equals(currentPayment) ? "checked" : "" %>>
                        <label class="form-check-label" for="pay1">クレジットカード</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="payment" id="pay2" value="bank" <%= "bank".equals(currentPayment) ? "checked" : "" %>>
                        <label class="form-check-label" for="pay2">銀行振込（前払い）</label>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="payment" id="pay3" value="convenience" <%= "convenience".equals(currentPayment) ? "checked" : "" %>>
                        <label class="form-check-label" for="pay3">コンビニ決済（前払い）</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="payment" id="pay4" value="cod" <%= "cod".equals(currentPayment) ? "checked" : "" %>>
                        <label class="form-check-label" for="pay4">代金引換</label>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm p-4 bg-white">
            <h5 class="fw-bold border-bottom pb-2 mb-3">🛒 ご注文商品</h5>
            <table class="table align-middle">
                <thead>
                    <tr class="table-light"><th>商品名</th><th class="text-center">単価</th><th class="text-center">数量</th><th class="text-end">小計</th></tr>
                </thead>
                <tbody>
                <% if (confirmCartMap != null) { 
                    for (Map.Entry<Products, Integer> entry : confirmCartMap.entrySet()) { 
                        Products p = entry.getKey();
                        int qty = entry.getValue();
                        int subTotal = p.getPrice() * qty;
                        confirmTotalAmount += subTotal;
                %>
                    <tr>
                        <td><%= p.getProductName() %></td>
                        <td class="text-center"><%= p.getPrice() %>円</td>
                        <td class="text-center"><%= qty %></td>
                        <td class="text-end"><%= subTotal %>円</td>
                    </tr>
                <% } } %>
                <tr class="table-light fs-5">
                    <td colspan="3" class="text-end fw-bold text-danger">合計金額</td>
                    <td class="text-end fw-bold text-danger"><%= confirmTotalAmount %> 円</td>
                </tr>
                </tbody>
            </table>
            
            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-danger btn-lg fw-bold">この内容で注文を確定する</button>
                <a href="javascript:history.back()" class="btn btn-outline-secondary">修正する</a>
            </div>
        </div>
    </form>
</div>
</body>
</html>