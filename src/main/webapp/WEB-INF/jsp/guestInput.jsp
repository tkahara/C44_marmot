<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="template/header.jsp" %>
<%@ include file="template/dialogs.jsp" %>
<%@ include file="template/cartSideBar.jsp" %>
<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>ゲスト情報入力 - お買い物</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container my-5" style="max-width: 600px;">
    <div class="card shadow-sm p-4 bg-white">
        <h3 class="mb-4 fw-bold text-center">👤 ゲスト情報入力</h3>
        <p class="text-muted text-center small">ログインせずに購入手続きを進めます。お届け先情報を入力してください。</p>
        <hr class="mb-4">
        
        <form action="OrderConfirmServlet" method="POST">
            
            <div class="mb-3">
                <label for="userName" class="form-label fw-bold">お名前 <span class="badge bg-danger">必須</span></label>
                <input type="text" class="form-control" id="userName" name="guestName" placeholder="山田 太郎" autocomplete="name" required>
            </div>
            
            <div class="mb-3">
                <label for="email" class="form-label fw-bold">メールアドレス <span class="badge bg-danger">必須</span></label>
                <input type="email" class="form-control" id="email" name="email" placeholder="example@mail.com" required>
            </div>
            
            <div class="mb-3">
                <label for="zipCode" class="form-label fw-bold">郵便番号<span class="badge bg-danger">必須</span></label>
                <input type="text" class="form-control" id="zipCode" name="zipCode" placeholder="123-4567">
            </div>
            
            <div class="mb-3">
                <label for="address" class="form-label fw-bold">ご住所（お届け先） <span class="badge bg-danger">必須</span></label>
                <input type="text" class="form-control" id="address" name="address" placeholder="〇〇県〇〇市〇〇町1-2-3" required>
            </div>
            
            <div class="mb-3">
                <label for="tel" class="form-label fw-bold">電話番号 <span class="badge bg-danger">必須</span></label>
                <input type="tel" class="form-control" id="tel" name="tel" placeholder="090-1234-5678" required>
            </div>
            
            <div class="mb-4">
                <label for="payment" class="form-label fw-bold">決済方法 <span class="badge bg-danger">必須</span></label>
                <select class="form-select" id="payment" name="payment" required onchange="toggleCardForm()">
                    <option value="credit">クレジットカード</option>
                    <option value="bank">銀行振込（前払い）</option>
                    <option value="cod">代金引換</option>
                    <option value="convenience">コンビニ決済（前払い）</option>
                </select>
            </div>
            
            <div id="creditCardForm" class="p-3 mb-4 bg-light rounded border" style="display: block;">
                <h5 class="fw-bold mb-3 text-secondary" style="font-size: 1rem;">💳 クレジットカード情報</h5>
                
                <div class="mb-3">
                    <label for="guestCardName" class="form-label small fw-bold">カード名義人（半角大文字）</label>
                    <input type="text" class="form-control" id="guestCardName" name="guestCardName" placeholder="TARO YAMADA">
                </div>
                
                <div class="mb-3">
                    <label for="guestCardNumber" class="form-label small fw-bold">カード番号（半角数字16桁）</label>
                    <input type="text" class="form-control" id="guestCardNumber" name="guestCardNumber" placeholder="1234567812345678" maxlength="16" pattern="\d{16}">
                </div>
                
                <div class="row">
                    <div class="col-6">
                        <label for="guestCardExpiry" class="form-label small fw-bold">有効期限 (MM/YY)</label>
                        <input type="text" class="form-control" id="guestCardExpiry" name="guestCardExpiry" placeholder="12/29" maxlength="5">
                    </div>
                </div>
            </div>
            
            <hr class="my-4">
            
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary btn-lg">購入確認画面へ進む ➔</button>
                <a href="MainServlet" class="btn btn-outline-secondary">カートに戻る</a>
            </div>
            
        </form>
    </div>
</div>

<script>
function toggleCardForm() {
    const paymentSelect = document.getElementById('payment');
    const cardForm = document.getElementById('creditCardForm');
    const cardInputs = cardForm.querySelectorAll('input');

    if (paymentSelect.value === 'credit') {
        cardForm.style.display = 'block';
        cardInputs.forEach(input => input.required = true);
    } else {
        cardForm.style.display = 'none';
        cardInputs.forEach(input => {
            input.required = false;
            input.value = '';
        });
    }
}

window.onload = toggleCardForm;
</script>

</body>
</html>

<%@ include file="template/footer.jsp" %>