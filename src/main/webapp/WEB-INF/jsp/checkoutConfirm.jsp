<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="model.Products"%>
<%@ page import="model.User"%>
<%@ page import="java.text.NumberFormat"%>
<%
// 🌟【追加】インクルードされる側(cartSideBar.jspなど)のエラーを防ぐため、ここで型宣言をして準備
java.text.NumberFormat nf = (java.text.NumberFormat) pageContext.getAttribute("nf");
if (nf == null) {
	nf = java.text.NumberFormat.getNumberInstance();
	pageContext.setAttribute("nf", nf);
}

// 🌟【追加】ログインユーザー情報を取得（クレジットカードチェック用）
User loginUser = (User) session.getAttribute("loginUser");

// 1. カート情報の取得
Map<Products, Integer> confirmCartMap = (Map<Products, Integer>) session.getAttribute("cartMap");

String name = (String) session.getAttribute("orderName");
String email = (String) session.getAttribute("orderEmail");
String zip = (String) session.getAttribute("orderZip");
String address = (String) session.getAttribute("orderAddress");
String tel = (String) session.getAttribute("orderTel");

// 🌟【修正】サーブレットがセットした名前 "payment" で正しくセッションから取得する
String currentPayment = (String) session.getAttribute("payment");
if (currentPayment == null) {
	// 🌟ログインしていてカードがあれば「credit」、なければ「bank」をデフォルトにする
	if (loginUser != null && loginUser.getCardNumber() != null && !loginUser.getCardNumber().isEmpty()) {
		currentPayment = "credit";
	} else {
		currentPayment = "bank";
	}
}

int confirmTotalAmount = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>注文内容の確認</title>
<style>
/* テーブル全体の基本設定（nowrapを外す） */
.table {
	table-layout: fixed; /* テーブル幅を固定する指定 */
	width: 100%;
}

/* 特定の列（金額・数量）の改行を禁止 */
.text-center, .text-end {
	white-space: nowrap;
}

/* 商品名（1列目）は改行を許可し、はみ出しを防ぐ */
.table td:first-child {
	word-break: break-all;
	white-space: normal;
}

/* 合計金額表示セルの幅を確保 */
.total-amount-cell {
	min-width: 120px;
	text-align: right !important;
}
</style>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body class="bg-light">

	<%@ include file="template/header.jsp"%>
	<%@ include file="template/dialogs.jsp"%>
	<%@ include file="template/cartSideBar.jsp"%>

	<div class="container my-5" style="max-width: 850px;">
		<h2 class="mb-4 fw-bold text-center">📋 注文内容の確認</h2>

		<div class="card shadow-sm p-4 bg-white mb-4">
			<h5 class="fw-bold border-bottom pb-2 mb-3">👤 お届け先・お客様情報</h5>
			<table class="table table-borderless m-0">
				<tr>
					<th style="width: 20%;">お名前</th>
					<td><%=name%> 様</td>
				</tr>
				<tr>
					<th>メール</th>
					<td><%=email%></td>
				</tr>
				<tr>
					<th>郵便番号</th>
					<td><%=(zip != null && !zip.isEmpty()) ? "〒" + zip : "なし"%></td>
				</tr>
				<tr>
					<th>ご住所</th>
					<td><%=address%></td>
				</tr>
				<tr>
					<th>電話番号</th>
					<td><%=tel%></td>
				</tr>
			</table>
		</div>

		<form action="OrderCompleteServlet" method="POST">
			<div class="card shadow-sm p-4 bg-white mb-4">
				<h5 class="fw-bold border-bottom pb-2 mb-3">💳 決済方法の確認・変更</h5>
				<p class="text-muted small">前の画面で選択した決済方法が選択されています。必要に応じて変更も可能です。</p>
				
				<div class="row">
					<div class="col-md-6">
						<%-- 🌟 ログインユーザーで、かつDBにカード番号がある場合 --%>
						<%
						if (loginUser != null && loginUser.getCardNumber() != null && !loginUser.getCardNumber().isEmpty()) {
						%>
						<div class="form-check mb-2">
							<input class="form-check-input" type="radio" name="payment"
								id="pay1" value="credit"
								<%="credit".equals(currentPayment) ? "checked" : ""%>> <label
								class="form-check-label" for="pay1"> クレジットカード (末尾: <%=loginUser.getCardNumber().substring(loginUser.getCardNumber().length() - 4)%>)
							</label>
						</div>
						<%
						} else if ("credit".equals(currentPayment)) { 
							// 🌟【新規対応】ゲストが前の画面でクレジットカードを入力して進んできた場合
							String guestCardNum = (String) session.getAttribute("guestCardNumber");
							String maskedNum = (guestCardNum != null && guestCardNum.length() == 16) 
								? guestCardNum.substring(12) : "****";
						%>
						<div class="form-check mb-2">
							<input class="form-check-input" type="radio" name="payment"
								id="pay1_guest" value="credit" checked> <label
								class="form-check-label" for="pay1_guest"> クレジットカード (末尾: <%=maskedNum%>)
							</label>
						</div>
						<%
						} else {
						%>
						<%-- カード情報がない場合は「未登録」である旨を表示（非活性） --%>
						<div class="form-check mb-2 text-muted">
							<input class="form-check-input" type="radio" id="pay1_disabled"
								disabled> <label class="form-check-label"
								for="pay1_disabled"> クレジットカード（未登録） </label>
						</div>
						<%
						}
						%>

						<div class="form-check mb-2">
							<input class="form-check-input" type="radio" name="payment"
								id="pay2" value="bank"
								<%="bank".equals(currentPayment) ? "checked" : ""%>> <label
								class="form-check-label" for="pay2">銀行振込（前払い）</label>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-check mb-2">
							<input class="form-check-input" type="radio" name="payment"
								id="pay3" value="convenience"
								<%="convenience".equals(currentPayment) ? "checked" : ""%>>
							<label class="form-check-label" for="pay3">コンビニ決済（前払い）</label>
						</div>
						<div class="form-check mb-2">
							<input class="form-check-input" type="radio" name="payment"
								id="pay4" value="cod"
								<%="cod".equals(currentPayment) ? "checked" : ""%>> <label
								class="form-check-label" for="pay4">代金引換</label>
						</div>
					</div>
				</div>
			</div>

			<div class="card shadow-sm p-4 bg-white">
				<h5 class="fw-bold border-bottom pb-2 mb-3">🛒 ご注文商品</h5>
				<table class="table align-middle">
					<thead>
						<tr class="table-light">
							<th>商品名</th>
							<th class="text-center">単価</th>
							<th class="text-center">数量</th>
							<th class="text-end">小計</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (confirmCartMap != null) {
							for (Map.Entry<Products, Integer> entry : confirmCartMap.entrySet()) {
								Products p = entry.getKey();
								int qty = entry.getValue();
								int subTotal = p.getPrice() * qty;
								confirmTotalAmount += subTotal;
						%>
						<tr>
							<td><%=p.getProductName()%></td>
							<td class="text-center"><%=nf.format(p.getPrice())%>円</td>
							<td class="text-center"><%=qty%></td>
							<td class="text-end"><%=nf.format(subTotal)%>円</td>
						</tr>
						<%
						}
						}
						%>
						<tr class="table-light fs-5">
							<td colspan="3" class="text-end fw-bold text-danger">合計金額</td>
							<td class="text-end fw-bold text-danger total-amount-cell">
								<%=nf.format(confirmTotalAmount)%> 円
							</td>
						</tr>
					</tbody>
				</table>

				<div class="d-grid gap-2 mt-4">
					<button type="submit" class="btn btn-danger btn-lg fw-bold">この内容で注文を確定する</button>
					<a href="javascript:history.back()"
						class="btn btn-outline-secondary">修正する</a>
				</div>
			</div>
		</form>
	</div>
</body>
</html>