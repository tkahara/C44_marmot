<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="model.Products" %>
<%
    // ★変数名を confirmCartMap に変更してサイドバーとの衝突を回避
    Map<Products, Integer> confirmCartMap = (Map<Products, Integer>) session.getAttribute("cartMap");
    String name = (String) session.getAttribute("guestName");
    String email = (String) session.getAttribute("guestEmail");
    String zip = (String) session.getAttribute("guestZip");
    String address = (String) session.getAttribute("guestAddress");
    String tel = (String) session.getAttribute("guestTel");
    String paymentCode = (String) session.getAttribute("guestPayment");
    
    // 🌟【追加】セッションからクレジットカード情報を取得
    String guestCardName = (String) session.getAttribute("guestCardName");
    String guestCardNumber = (String) session.getAttribute("guestCardNumber");
    
    // 🌟【追加】クレジットカードの安全なマスク処理（下4桁以外を隠す）
    String displayCardNumber = "";
    if ("credit".equals(paymentCode) && guestCardNumber != null && guestCardNumber.length() >= 4) {
        String lastFour = guestCardNumber.substring(guestCardNumber.length() - 4);
        displayCardNumber = "************" + lastFour;
    }
    
    // 決済コードを日本語に変換
    String paymentMethod = "";
    if ("credit".equals(paymentCode)) paymentMethod = "クレジットカード";
    else if ("bank".equals(paymentCode)) paymentMethod = "銀行振込（前払い）";
    else if ("convenience".equals(paymentCode)) paymentMethod = "コンビニ決済（前払い）";
    else if ("cod".equals(paymentCode)) paymentMethod = "代金引換";

    // ★変数名を confirmTotalAmount に変更
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
    <p class="text-center text-muted">まだ注文は確定していません。内容をご確認ください。</p>
    
    <div class="row g-4">
        <div class="col-md-12">
            <div class="card shadow-sm p-4 bg-white mb-4">
                <h5 class="fw-bold border-bottom pb-2 mb-3">👤 お届け先・お客様情報</h5>
                <table class="table table-borderless m-0">
                    <tr><th style="width: 20%;">お名前</th><td><%= name %> 様</td></tr>
                    <tr><th>メール</th><td><%= email %></td></tr>
                    <tr><th>郵便番号</th><td><%= (zip != null && !zip.isEmpty()) ? zip : "なし" %></td></tr>
                    <tr><th>ご住所</th><td><%= address %></td></tr>
                    <tr><th>電話番号</th><td><%= tel %></td></tr>
                    <tr><th>決済方法</th><td><span class="badge bg-info text-dark font-monospace fs-6"><%= paymentMethod %></span></td></tr>
                    
                    <%-- 🌟【追加】クレジットカードが選択されている場合のみ、名義と安全にマスクされた番号を表示 --%>
                    <% if ("credit".equals(paymentCode)) { %>
                        <tr>
                            <th>カード名義</th>
                            <td><%= (guestCardName != null) ? guestCardName : "" %></td>
                        </tr>
                        <tr>
                            <th>カード番号</th>
                            <td class="font-monospace"><%= displayCardNumber %></td>
                        </tr>
                    <% } %>
                </table>
            </div>
        </div>

        <div class="col-md-12">
            <div class="card shadow-sm p-4 bg-white">
                <h5 class="fw-bold border-bottom pb-2 mb-3">🛒 ご注文商品</h5>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr class="table-light">
                                <th>商品名</th>
                                <th class="text-center" style="width: 15%;">単価</th>
                                <th class="text-center" style="width: 15%;">数量</th>
                                <th class="text-end" style="width: 20%;">小計</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%-- ★新しく定義した変数 confirmCartMap をループに使用 --%>
                        <% if (confirmCartMap != null && !confirmCartMap.isEmpty()) { 
                            for (Map.Entry<Products, Integer> entry : confirmCartMap.entrySet()) { 
                                Products p = entry.getKey();
                                int qty = entry.getValue();
                                int subTotal = p.getPrice() * qty;
                                confirmTotalAmount += subTotal;
                        %>
                            <tr>
                                <td><span class="fw-bold"><%= p.getProductName() %></span></td>
                                <td class="text-center"><%= p.getPrice() %>円</td>
                                <td class="text-center"><%= qty %></td>
                                <td class="text-end fw-bold"><%= subTotal %>円</td>
                            </tr>
                        <% } } %>
                            <tr class="table-light fs-5">
                                <td colspan="3" class="text-end fw-bold text-danger">合計金額</td>
                                <td class="text-end fw-bold text-danger fs-4"><%= confirmTotalAmount %> 円</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <form action="OrderCompleteServlet" method="POST" class="mt-4">
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-danger btn-lg fw-bold">この内容で注文を確定する</button>
                        <a href="javascript:history.back()" class="btn btn-outline-secondary">入力画面に戻して修正する</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>

<%@ include file="template/footer.jsp" %>

</html>