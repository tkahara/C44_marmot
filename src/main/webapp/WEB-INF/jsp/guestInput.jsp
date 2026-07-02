<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%
java.text.NumberFormat nf = (java.text.NumberFormat) pageContext.getAttribute("nf");
if (nf == null) {
	nf = java.text.NumberFormat.getNumberInstance();
	pageContext.setAttribute("nf", nf);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>お届け先情報の入力 - Tea Salon</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<%-- 🌟 住所自動補完ライブラリ --%>
<script src="https://yubinbango.github.io/yubinbango/yubinbango.js"
	charset="UTF-8" defer></script>
<style>
:root {
	--tea-primary: #6F4E37;
	--tea-dark: #4A3325;
	--tea-accent: #C5A059;
	--tea-bg-page: #F5EFEB;
	--tea-badge-required: #A94442;
}

body.tea-theme {
	background-color: var(--tea-bg-page) !important;
	color: var(--tea-dark);
	font-family: 'Helvetica Neue', Arial, sans-serif;
}

.tea-card {
	border: 1px solid rgba(111, 78, 55, 0.12);
	border-radius: 14px;
	box-shadow: 0 6px 25px rgba(74, 51, 37, 0.07) !important;
	background-color: #FFFFFF !important;
}

.tea-card-req-span {
	font-size: 0.8rem;
	color: var(--tea-badge-required);
}

.tea-title {
	color: var(--tea-dark);
	letter-spacing: 0.05em;
	position: relative;
	display: inline-block;
	padding-bottom: 10px;
}

.tea-title::after {
	content: '';
	position: absolute;
	left: 50%;
	bottom: 0;
	transform: translateX(-50%);
	width: 45px;
	height: 2px;
	background-color: var(--tea-accent);
}

.form-control, .form-select {
	border: 1px solid rgba(111, 78, 55, 0.25);
	border-radius: 6px;
	padding: 10px 12px;
}

.form-control:focus, .form-select:focus {
	border-color: var(--tea-primary);
	box-shadow: 0 0 0 0.25rem rgba(111, 78, 55, 0.15);
}

.badge-tea-req {
	background-color: var(--tea-badge-required) !important;
	font-weight: 500;
	font-size: 0.75rem;
	padding: 3px 6px;
}

.btn-tea-submit {
	background-color: var(--tea-primary);
	border-color: var(--tea-primary);
	color: #FFF;
	padding: 12px;
	font-weight: bold;
}

.btn-tea-submit:hover {
	background-color: var(--tea-dark);
	border-color: var(--tea-dark);
	color: #FFF;
}

.btn-tea-outline {
	color: var(--tea-primary);
	border-color: rgba(111, 78, 55, 0.4);
	border-radius: 6px;
	text-decoration: none;
	text-align: center;
}

.btn-tea-outline:hover {
	background-color: rgba(111, 78, 55, 0.05);
	color: var(--tea-dark);
}

.credit-card-section {
	background-color: #FAF6F3 !important;
	border: 1px dashed rgba(111, 78, 55, 0.3) !important;
	border-radius: 8px;
}
</style>
</head>
<body class="tea-theme">

	<%@ include file="template/header.jsp"%>
	<%@ include file="template/dialogs.jsp"%>
	<%@ include file="template/cartSideBar.jsp"%>

	<div class="container my-5" style="max-width: 600px;">
		<div class="card p-4 tea-card">
			<div class="text-center mb-4">
				<div class="mb-2"
					style="font-size: 2.2rem; color: var(--tea-primary);">☕</div>
				<h3 class="fw-bold tea-title">お届け先・お支払い情報の入力</h3>
				<p class="text-muted small mt-2">ログインせずにゲストとして購入手続きを進めます。</p>
			</div>

			<%
			if (request.getAttribute("errorMessage") != null) {
			%>
			<div class="alert alert-danger fw-bold small">
				⚠️
				<%=request.getAttribute("errorMessage")%></div>
			<%
			}
			%>

			<form action="OrderConfirmServlet" method="POST" class="h-adr"
				id="guestOrderForm">
				<span class="p-country-name" style="display: none;">Japan</span>

				<div class="mb-3">
					<label for="userName" class="form-label fw-bold">お名前 <span
						class="badge badge-tea-req">必須</span></label> <input type="text"
						class="form-control" id="userName" name="guestName"
						placeholder="山田 太郎" autocomplete="name" value="${param.guestName}"
						pattern="[^\d０-９!\-/:\-@\[-`\{\-~、\-〜]*"
						title="お名前に数字や記号は使用できません。" required>
					<div id="nameError" class="small mt-1 d-none"
						style="color: var(--tea-badge-required); font-weight: 500;">⚠️
						お名前に数字や記号は入力できません。</div>
				</div>

				<div class="mb-3">
					<label for="email" class="form-label fw-bold">メールアドレス <span
						class="badge badge-tea-req">必須</span></label> <input type="email"
						class="form-control" id="email" name="email"
						placeholder="example@mail.com" value="${param.email}" required>
					<div id="emailError" class="small mt-1 d-none"
						style="color: var(--tea-badge-required); font-weight: 500;"></div>
				</div>

				<div class="mb-3">
					<label for="emailConfirm" class="form-label fw-bold">メールアドレス（確認用）
						<span class="badge badge-tea-req">必須</span>
					</label> <input type="email" class="form-control" id="emailConfirm"
						placeholder="うっかり入力を防ぐため、もう一度ご入力ください" value="${param.email}"
						required>
					<div id="emailConfirmError" class="small mt-1 d-none"
						style="color: var(--tea-badge-required); font-weight: 500;"></div>
				</div>

				<div class="mb-3">
					<label for="zipCode" class="form-label fw-bold">郵便番号 <span
						class="badge badge-tea-req">必須</span></label> <input type="text"
						class="form-control p-postal-code" id="zipCode" name="zipCode"
						placeholder="1234567（ハイフンなし）" value="${param.zipCode}"
						maxlength="7" inputmode="numeric" required>
					<div class="form-text small text-muted">※半角数字7桁でご入力ください。</div>
				</div>

				<div class="mb-3">
					<label for="address" class="form-label fw-bold">ご住所（お届け先） <span
						class="badge badge-tea-req">必須</span></label> <input type="text"
						class="form-control p-region p-locality p-street-address"
						id="address" name="address" value="${param.address}"
						placeholder="〇〇県〇〇市〇〇町1-2-3"
						pattern="^[^\d０-９!\-/:\-@\[-`\{\-~、\-〜（）\(\)\s].*$"
						title="ご住所は都道府県名や市区町村名（文字）から入力してください。数字だけの入力はできません。" required>
					<div class="form-text small text-muted">※郵便番号を入力すると自動補完されます。以降の番地や建物名を手動で追記してください。</div>
				</div>

				<div class="mb-3">
					<label for="tel" class="form-label fw-bold">電話番号 <span
						class="badge badge-tea-req">必須</span></label> <input type="tel"
						class="form-control" id="tel" name="tel"
						placeholder="09012345678（ハイフンなし）" value="${param.tel}"
						maxlength="11" inputmode="numeric" required>
					<div class="form-text small text-muted">※半角数字10桁または11桁でご入力ください。</div>
				</div>

				<div class="mb-4">
					<label for="payment" class="form-label fw-bold">決済方法 <span
						class="badge badge-tea-req">必須</span></label> <select class="form-select"
						id="payment" name="payment" required onchange="toggleCardForm()">
						<option value="credit"
							${param.payment == 'credit' ? 'selected' : ''}>クレジットカード</option>
						<option value="bank" ${param.payment == 'bank' ? 'selected' : ''}>銀行振込（前払い）</option>
						<option value="cod" ${param.payment == 'cod' ? 'selected' : ''}>代金引換</option>
						<option value="convenience"
							${param.payment == 'convenience' ? 'selected' : ''}>コンビニ決済（前払い）</option>
					</select>
				</div>

				<div id="creditCardForm" class="p-3 mb-4 credit-card-section"
					style="display: block;">
					<h5 class="fw-bold mb-3"
						style="font-size: 0.95rem; color: var(--tea-primary); letter-spacing: 0.03em;">
						💳 クレジットカード情報 <span id="cardReqLabel" class="tea-card-req-span">（クレジットカード選択時、入力必須）</span>
					</h5>

					<div class="mb-3">
						<label for="guestCardName" class="form-label small fw-bold">カード名義人（半角大文字）</label>
						<input type="text" class="form-control" id="guestCardName"
							name="guestCardName" placeholder="TARO YAMADA"
							value="${param.guestCardName}" pattern="[A-Z\s]*"
							title="カード名義人は半角英大文字のみで入力してください。">
					</div>

					<div class="mb-3">
						<label for="guestCardNumber" class="form-label small fw-bold">カード番号（半角数字16桁）</label>
						<input type="text" class="form-control" id="guestCardNumber"
							name="guestCardNumber" placeholder="1234567812345678"
							value="${param.guestCardNumber}" maxlength="16" pattern="\d{16}">
					</div>

					<div class="row">
						<div class="col-6">
							<label for="guestCardExpiry" class="form-label small fw-bold">有効期限
								(MM/YY)</label> <input type="text" class="form-control"
								id="guestCardExpiry" name="guestCardExpiry" placeholder="12/29"
								value="${param.guestCardExpiry}" maxlength="5"
								inputmode="numeric">
						</div>
					</div>
				</div>

				<hr class="my-4" style="border-color: rgba(111, 78, 55, 0.15);">

				<div class="d-grid gap-2 mt-4">
					<button type="submit" class="btn btn-danger btn-lg fw-bold">購入確認画面へ進む
						➔</button>
					<a href="javascript:history.back();"
						class="btn btn-outline-secondary">戻る</a>
				</div>
			</form>
		</div>
	</div>

	<%@ include file="template/footer.jsp"%>

	<%-- 🌟 JavaScriptの配置と起動ロジックを最適化 --%>
	<script>
// フォーム切り替え関数（グローバルに配置して直下の呼び出しに対応）
function toggleCardForm() {
    const paymentSelect = document.getElementById('payment');
    const cardForm = document.getElementById('creditCardForm');
    const cardInputs = cardForm.querySelectorAll('input');
    const cardReqLabel = document.getElementById('cardReqLabel');

    if (!paymentSelect || !cardForm) return;

    if (paymentSelect.value === 'credit') {
        cardForm.style.display = 'block';
        if (cardReqLabel) cardReqLabel.style.display = 'inline';
        cardInputs.forEach(input => input.required = true);
    } else {
        cardForm.style.display = 'none';
        if (cardReqLabel) cardReqLabel.style.display = 'none';
        cardInputs.forEach(input => {
            input.required = false;
            input.value = '';
        });
    }
}

document.addEventListener("DOMContentLoaded", function() {
    // 🌟 初期表示時のカードフォーム状態チェック
    toggleCardForm();

    const nameInput = document.getElementById("userName"); 
    const nameError = document.getElementById("nameError"); 
    const emailInput = document.getElementById("email");
    const emailConfirmInput = document.getElementById("emailConfirm");
    const emailError = document.getElementById("emailError");
    const emailConfirmError = document.getElementById("emailConfirmError");
    const zipInput = document.getElementById("zipCode"); 
    const addressInput = document.getElementById("address"); 
    const telInput = document.getElementById("tel"); 
    const paymentSelect = document.getElementById('payment');
    const cardNameInput = document.getElementById("guestCardName"); 
    const cardNumberInput = document.getElementById("guestCardNumber"); 
    const cardExpiryInput = document.getElementById("guestCardExpiry"); 
    const form = document.getElementById("guestOrderForm");

    const invalidNamePattern = /[0-9０-９!\-/:\-@\[-`\{\-~、\-〜]/g;
    const invalidNameCheck = /[0-9０-９!\-/:\-@\[-`\{\-~、\-〜]/;

    if (nameInput) {
        nameInput.addEventListener("input", function() {
            let value = nameInput.value;
            if (invalidNamePattern.test(value)) {
                nameInput.value = value.replace(invalidNamePattern, '');
                if (nameError) nameError.classList.remove("d-none");
            } else {
                if (nameError) nameError.classList.add("d-none");
            }
        });
    }

    if (cardNameInput) {
        cardNameInput.addEventListener("input", function() {
            let value = cardNameInput.value.toUpperCase(); 
            value = value.replace(/[ａ-ｚＡ-Ｚ]/g, function(s) { return String.fromCharCode(s.charCodeAt(0) - 0xFEE0); });
            cardNameInput.value = value.replace(/[^A-Z\s]/g, '').replace(/ +/g, ' '); 
        });
    }

    if (zipInput) {
        zipInput.addEventListener("input", function() {
            let value = zipInput.value;
            value = value.replace(/[０-９]/g, function(s) { return String.fromCharCode(s.charCodeAt(0) - 0xFEE0); });
            zipInput.value = value.replace(/[^0-9]/g, '');
        });
    }

    if (telInput) {
        telInput.addEventListener("input", function() {
            let value = telInput.value;
            value = value.replace(/[０-９]/g, function(s) { return String.fromCharCode(s.charCodeAt(0) - 0xFEE0); });
            telInput.value = value.replace(/[^0-9]/g, '');
        });
    }

    if (cardNumberInput) {
        cardNumberInput.addEventListener("input", function() {
            let value = cardNumberInput.value;
            // 9を全角の「９」に修正
            value = value.replace(/[０-９]/g, function(s) { return String.fromCharCode(s.charCodeAt(0) - 0xFEE0); });
            cardNumberInput.value = value.replace(/[^0-9]/g, '');
        });
    }

    if (cardExpiryInput) {
        cardExpiryInput.addEventListener("blur", function() {
            let value = cardExpiryInput.value.replace(/[０-９]/g, function(s) { return String.fromCharCode(s.charCodeAt(0) - 0xFEE0); });
            let digits = value.replace(/\D/g, "");
            if (digits.length === 4) {
                cardExpiryInput.value = digits.slice(0, 2) + "/" + digits.slice(2);
            }
        });
    }

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    function validateEmail() {
        if (!emailInput || emailInput.value === "") { if (emailError) emailError.classList.add("d-none"); return true; }
        if (!emailRegex.test(emailInput.value)) {
            if (emailError) {
                emailError.textContent = "⚠️ メールの形式が正しくありません。";
                emailError.classList.remove("d-none");
            }
            return false;
        } else { if (emailError) emailError.classList.add("d-none"); return true; }
    }

    function validateConfirmEmail() {
        if (!emailConfirmInput || !emailInput || emailConfirmInput.value === "") { if (emailConfirmError) emailConfirmError.classList.add("d-none"); return true; }
        if (emailInput.value !== emailConfirmInput.value) {
            if (emailConfirmError) {
                emailConfirmError.textContent = "⚠️ 入力されたメールアドレスと一致しません。";
                emailConfirmError.classList.remove("d-none");
            }
            return false;
        } else { if (emailConfirmError) emailConfirmError.classList.add("d-none"); return true; }
    }

    if (emailInput) emailInput.addEventListener("blur", () => { validateEmail(); validateConfirmEmail(); });
    if (emailConfirmInput) emailConfirmInput.addEventListener("blur", validateConfirmEmail);

    if (form) {
        form.addEventListener("submit", function(event) {
            const isEmailValid = validateEmail();
            const isConfirmValid = validateConfirmEmail();
            const isZipValid = zipInput ? zipInput.value.length === 7 : false;
            const isTelValid = telInput ? (telInput.value.length === 10 || telInput.value.length === 11) : false;
            const isNameValid = nameInput ? (!invalidNameCheck.test(nameInput.value) && nameInput.value.trim() !== "") : false;
            const invalidAddressStart = /^[0-9０-９!\-/:\-@\[-`\{\-~、\-〜（）\(\)\s]/;
            const isAddressValid = addressInput ? (!invalidAddressStart.test(addressInput.value.trim()) && addressInput.value.trim() !== "") : false;

            if (!isNameValid || !isEmailValid || !isConfirmValid || !isZipValid || !isTelValid || !isAddressValid) {
                event.preventDefault(); 
                if (!isNameValid) alert("お名前に数字や記号が含まれているか、入力されていません。");
                else if (!isAddressValid) alert("ご住所は文字から正しく入力してください。");
                else if (!isZipValid) alert("郵便番号は7桁の数字で入力してください。");
                else if (!isTelValid) alert("電話番号は10桁または11桁の数字で入力してください。");
                else alert("メールアドレスの入力内容に不備があります。");
                return;
            }

            if (paymentSelect && paymentSelect.value === 'credit') {
                const cardNum = (cardNumberInput ? cardNumberInput.value : "").trim();
                const cardName = (cardNameInput ? cardNameInput.value : "").trim();
                const cardExpiry = (cardExpiryInput ? cardExpiryInput.value : "").trim();

                if (cardNum === "" || cardName === "" || cardExpiry === "") {
                    event.preventDefault();
                    alert("クレジットカード情報（名義・番号・有効期限）をすべて入力してください。");
                    return;
                }
                if (cardNum.length !== 16) {
                    event.preventDefault();
                    alert("カード番号は16桁の数字で正しく入力してください。");
                    return;
                }
                if (cardName.replace(/ /g, "") === "" || cardName.length < 2 || cardName.length > 26) {
                    event.preventDefault();
                    alert("カード名義は半角英字2文字以上26文字以内で正しく入力してください。");
                    return;
                }
                if (!/^\d{2}\/\d{2}$/.test(cardExpiry)) {
                    event.preventDefault();
                    alert("有効期限は「月月/年年 (例: 12/29)」の形式で入力してください。");
                    return;
                } else {
                    const month = parseInt(cardExpiry.split("/")[0], 10);
                    if (month < 1 || month > 12) {
                        event.preventDefault();
                        alert("有効期限の「月」は01〜12の間で指定してください。");
                        return;
                    }
                }
            }
        });
    }

    // 🌟【最重要】サイドカート（added=true）の自動展開ロジックの安全性強化
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('added') === 'true') {
        const sideCartElement = document.getElementById('sideCart');
        if (sideCartElement) {
            // BootstrapのJSインスタンスが作成可能か厳格にチェック
            if (typeof bootstrap !== 'undefined' && bootstrap.Offcanvas) {
                // 既存のインスタンスがあるか取得、なければ新規生成
                let bsOffcanvas = bootstrap.Offcanvas.getInstance(sideCartElement);
                if (!bsOffcanvas) {
                    bsOffcanvas = new bootstrap.Offcanvas(sideCartElement);
                }
                bsOffcanvas.show();
            } else {
                // 万が一のフォールバック
                sideCartElement.classList.add('show');
                sideCartElement.style.visibility = 'visible';
            }
            // 表示が完了したらURLのパラメータをクリアして多重起動を防止
            history.replaceState(null, '', window.location.pathname);
        }
    }
});
</script>
</body>
</html>