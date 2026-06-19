<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="model.Products" %>
<%
    // 🌟【重要】ブラウザのキャッシュを無効化（「戻る」ボタン対策）
    // これにより、戻るボタンを押した際もブラウザキャッシュを使わず、必ずこのJSPのチェックが走ります
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // プロキシ用

    // 🌟 注文完了フラグのチェック（サーブレットでセットしたフラグを確認）
    Boolean isCompleted = (Boolean) session.getAttribute("isOrderCompleted");
    if (isCompleted == null || !isCompleted) {
        // ★修正：URLパラメータではなく、セッションにエラーコードを保存してメインへリダイレクト
        session.setAttribute("errorMessage", "invalid_access");
        response.sendRedirect(request.getContextPath() + "/main");
        return;
    }
    // 表示が終わったらフラグを消去（リロードによる二重表示・再アクセス対策）
    session.removeAttribute("isOrderCompleted");

    // データの取得
    Map<Products, Integer> completeCartMap = (Map<Products, Integer>) session.getAttribute("confirmedCart");
    String name = (String) session.getAttribute("confirmedName");
    String address = (String) session.getAttribute("confirmedAddress");
    String paymentCode = (String) session.getAttribute("confirmedPayment");
    
    // カード番号のマスク処理
    String rawCardNumber = (String) session.getAttribute("confirmedCardNumber");
    String displayCardNumber = "";
    if ("credit".equals(paymentCode) && rawCardNumber != null && rawCardNumber.length() >= 4) {
        displayCardNumber = "************" + rawCardNumber.substring(rawCardNumber.length() - 4);
    }
    
    // 決済コードを日本語変換
    String paymentMethod = "";
    if ("credit".equals(paymentCode)) paymentMethod = "クレジットカード";
    else if ("bank".equals(paymentCode)) paymentMethod = "銀行振込（前払い）";
    else if ("convenience".equals(paymentCode)) paymentMethod = "コンビニ決済（前払い）";
    else if ("cod".equals(paymentCode)) paymentMethod = "代金引換";

    int completeTotalAmount = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ご注文完了</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<%@ include file="WEB-INF/jsp/template/header.jsp" %>
<%@ include file="WEB-INF/jsp/template/dialogs.jsp" %>
<%@ include file="WEB-INF/jsp/template/cartSideBar.jsp" %>

<div class="container my-5" style="max-width: 700px;">
    <div class="card shadow-sm p-5 bg-white text-center mb-4">
        <div class="mb-3 text-success" style="font-size: 4rem;">🎉</div>
        <h2 class="fw-bold text-dark">ご注文ありがとうございました！</h2>
        <p class="text-muted">ご注文手続きが正常に完了いたしました。</p>
    </div>

    <div class="card shadow-sm p-4 bg-white mb-4">
        <h5 class="fw-bold border-bottom pb-2 mb-3">📦 ご注文内容の控え</h5>
        <table class="table align-middle">
            <thead>
                <tr class="table-light">
                    <th>商品名</th>
                    <th class="text-center" style="width: 20%;">数量</th>
                    <th class="text-end" style="width: 25%;">小計</th>
                </tr>
            </thead>
            <tbody>
            <% if (completeCartMap != null) { 
                for (Map.Entry<Products, Integer> entry : completeCartMap.entrySet()) { 
                    Products p = entry.getKey();
                    int qty = entry.getValue();
                    int subTotal = p.getPrice() * qty;
                    completeTotalAmount += subTotal;
            %>
                <tr>
                    <td><span class="fw-bold"><%= p.getProductName() %></span></td>
                    <td class="text-center"><%= qty %></td>
                    <td class="text-end"><%= subTotal %> 円</td>
                </tr>
            <% } } %>
                <tr class="table-light">
                    <td colspan="2" class="text-end fw-bold text-danger">合計金額</td>
                    <td class="text-end fw-bold text-danger fs-5"><%= completeTotalAmount %> 円</td>
                </tr>
            </tbody>
        </table>

        <div class="bg-light p-3 rounded mt-3 text-start">
            <p class="mb-1"><strong>お名前：</strong> <%= name %> 様</p>
            <p class="mb-1"><strong>お届け先：</strong> <%= address %></p>
            <p class="mb-0"><strong>お支払い方法：</strong> <%= paymentMethod %></p>
            <% if ("credit".equals(paymentCode) && !displayCardNumber.isEmpty()) { %>
                <p class="mb-0 text-muted mt-1" style="font-size: 0.9rem;">（カード：<span class="font-monospace"><%= displayCardNumber %></span>）</p>
            <% } %>
        </div>
    </div>

    <div class="d-grid gap-2">
        <a href="${pageContext.request.contextPath}/main" class="btn btn-primary btn-lg fw-bold">メインページへ戻る</a>
    </div>
</div>

</body>
<%@ include file="WEB-INF/jsp/template/footer.jsp" %>
</html>