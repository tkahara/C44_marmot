<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%
// サーブレットからエラーメッセージと再入力用ユーザー情報を取得
String msg = (String) request.getAttribute("msg");
User regUser = (User) request.getAttribute("registeredUser");

// 登録失敗時に入力値を復元するための変数
String userId = (regUser != null) ? regUser.getUserId() : "";
String name = (regUser != null) ? regUser.getUserName() : "";
String pass = (regUser != null) ? regUser.getPassword() : "";
String postalCode = (regUser != null) ? regUser.getPostalCode() : "";
String address = (regUser != null) ? regUser.getAddress() : "";
String mail = (regUser != null) ? regUser.getEmail() : "";
String tel = (regUser != null) ? regUser.getPhoneNumber() : "";
String cardNum = (regUser != null) ? regUser.getCardNumber() : "";
String cardName = (regUser != null) ? regUser.getCardName() : "";
String cardExpiration = (regUser != null) ? regUser.getCardExpiration() : "";
%>

<%@ include file="template/header.jsp"%>
<%@ include file="template/dialogs.jsp"%>
<%@ include file="template/cartSideBar.jsp"%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>新規会員登録 - Tea Salon</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<script src="https://yubinbango.github.io/yubinbango/yubinbango.js"
	charset="UTF-8" defer></script>

<style>
/* ☕ 紅茶ブランドをイメージしたカスタムカラーテーマ（完全に統一） */
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
	font-family: 'Helvetica Neue', Arial, 'Hiragino Kaku Gothic ProN',
		'Segoe UI', sans-serif;
}

.tea-card {
	border: 1px solid rgba(111, 78, 55, 0.12);
	border-radius: 14px;
	box-shadow: 0 6px 25px rgba(74, 51, 37, 0.07) !important;
	background-color: #FFFFFF !important;
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

.form-label {
	color: var(--tea-dark);
	font-size: 0.95rem;
}

.form-control, .form-select {
	border: 1px solid rgba(111, 78, 55, 0.25);
	border-radius: 6px;
	padding: 10px 12px;
	background-color: #FFF;
	transition: all 0.2s ease-in-out;
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
	vertical-align: middle;
}

.btn-tea-submit {
	background-color: var(--tea-primary);
	border-color: var(--tea-primary);
	color: #FFF;
	padding: 12px;
	font-weight: bold;
	letter-spacing: 0.05em;
	border-radius: 6px;
	transition: all 0.2s;
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
	font-weight: 500;
	text-align: center;
	text-decoration: none;
	padding: 12px;
}

.btn-tea-outline:hover {
	background-color: rgba(111, 78, 55, 0.05);
	color: var(--tea-dark);
	border-color: var(--tea-primary);
}

.credit-card-section {
	background-color: #FAF6F3 !important;
	border: 1px dashed rgba(111, 78, 55, 0.3) !important;
	border-radius: 8px;
}

.section-divider {
	color: var(--tea-primary);
	font-size: 1.05rem;
	font-weight: bold;
	border-bottom: 1px solid rgba(111, 78, 55, 0.15);
	padding-bottom: 6px;
	margin-top: 24px;
	margin-bottom: 16px;
}
</style>
</head>
<body class="tea-theme">

	<div class="container my-5" style="max-width: 600px;">
		<div class="card p-4 tea-card">
			<div class="text-center mb-4">
				<div class="mb-2"
					style="font-size: 2.2rem; color: var(--tea-primary);">✨</div>
				<h3 class="fw-bold tea-title">新規会員登録</h3>
				<p class="text-muted small mt-2">当サロンの会員サービスをご利用いただくため、必要事項のご入力をお願いいたします。</p>
			</div>

			<%-- ❌ 登録エラーメッセージ表示（DB重複時など） --%>
			<%
			if (msg != null && !msg.isEmpty()) {
			%>
			<div class="alert alert-danger alert-dismissible fade show mb-4"
				role="alert"
				style="border-radius: 8px; background-color: #FDF2F2; color: var(--tea-badge-required); border-color: rgba(169, 68, 66, 0.15);">
				<strong>⚠️ <%=msg%></strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
			<%
			}
			%>

			<form action="RegisterServlet" method="POST" class="h-adr">
				<span class="p-country-name" style="display: none;">Japan</span>

				<div class="section-divider">👤 アカウント情報</div>

				<div class="mb-3">
					<label for="userId" class="form-label fw-bold">ユーザーID <span
						class="badge badge-tea-req">必須</span></label> <input type="text"
						class="form-control" id="userId" name="userId"
						value="<%=userId%>" placeholder="例: salon_tea_lover" required
						autocomplete="off">
				</div>

				<div class="mb-3">
					<label for="pass" class="form-label fw-bold">パスワード <span
						class="badge badge-tea-req">必須</span></label> <input type="password"
						class="form-control" id="pass" name="pass" value="<%=pass%>"
						placeholder="英数字6文字以上を推奨" required autocomplete="new-password">
				</div>

				<div class="mb-3">
					<label for="userName" class="form-label fw-bold">お名前 <span
						class="badge badge-tea-req">必須</span></label> <input type="text"
						class="form-control" id="userName" name="name" value="<%=name%>"
						placeholder="紅茶 太郎" required autocomplete="off">
				</div>

				<div class="section-divider">📍 ご連絡先・お届け先</div>

				<div class="mb-3">
					<label for="email" class="form-label fw-bold">メールアドレス <span
						class="badge badge-tea-req">必須</span></label> <input type="email"
						class="form-control" id="email" name="mail" value="<%=mail%>"
						placeholder="example@mail.com" required>
					<div id="emailError" class="small mt-1 d-none"
						style="color: var(--tea-badge-required); font-weight: 500;"></div>
				</div>

				<div class="mb-3">
					<label for="emailConfirm" class="form-label fw-bold">メールアドレス（確認用）
						<span class="badge badge-tea-req">必須</span>
					</label> <input type="email" class="form-control" id="emailConfirm"
						value="<%=mail%>" placeholder="もう一度ご入力ください" required>
					<div id="emailConfirmError" class="small mt-1 d-none"
						style="color: var(--tea-badge-required); font-weight: 500;"></div>
				</div>

				<div class="mb-3">
					<label for="zipCode" class="form-label fw-bold">郵便番号 <span
						class="badge badge-tea-req">必須</span></label> <input type="text"
						class="form-control p-postal-code" id="zipCode" name="postalCode"
						value="<%=postalCode%>" placeholder="1234567（ハイフンなし）"
						maxlength="7" inputmode="numeric" required>
					<div class="form-text small text-muted">※半角数字7桁でご入力ください。</div>
				</div>

				<div class="mb-3">
					<label for="address" class="form-label fw-bold">ご住所 <span
						class="badge badge-tea-req">必須</span></label> <input type="text"
						class="form-control p-region p-locality p-street-address"
						id="address" name="address" value="<%=address%>"
						placeholder="〇〇県〇〇市〇〇町1-2-3" required>
					<div class="form-text small text-muted">※郵便番号からの自動補完後、番地や建物名を追記してください。</div>
				</div>

				<div class="mb-3">
					<label for="tel" class="form-label fw-bold">電話番号 <span
						class="badge badge-tea-req">必須</span></label> <input type="tel"
						class="form-control" id="tel" name="tel" value="<%=tel%>"
						placeholder="090-1234-5678" required>
				</div>

				<div class="section-divider">
					💳 お支払い情報 <span class="badge bg-secondary ms-1 fw-normal"
						style="font-size: 0.7rem; vertical-align: middle;">任意</span>
				</div>
				<p class="text-muted small mb-3">クレジットカード情報は後からマイページで登録・変更することも可能です。</p>

				<div id="creditCardForm" class="p-3 mb-4 credit-card-section">
					<div class="mb-3">
						<label for="guestCardName" class="form-label small fw-bold">カード名義人（半角大文字）</label>
						<input type="text" class="form-control" id="guestCardName"
							name="cardName" value="<%=cardName%>" placeholder="TARO KOUCHA">
					</div>

					<div class="mb-3">
						<label for="guestCardNumber" class="form-label small fw-bold">カード番号（半角数字16桁）</label>
						<input type="text" class="form-control" id="guestCardNumber"
							name="cardNum" value="<%=cardNum%>"
							placeholder="1234567812345678" maxlength="16" pattern="\d{16}">
					</div>

					<div class="row">
						<div class="col-6">
							<label for="guestCardExpiry" class="form-label small fw-bold">有効期限
								(MM/YY)</label> <input type="text" class="form-control"
								id="guestCardExpiry" name="cardExpiration"
								value="<%=cardExpiration%>" placeholder="12/29" maxlength="5">
						</div>
					</div>
				</div>

				<hr class="my-4" style="border-color: rgba(111, 78, 55, 0.15);">

				<div class="d-grid gap-2">
					<button type="submit" class="btn btn-tea-submit btn-lg">✨
						同意して会員登録する</button>
					<a href="main" class="btn btn-tea-outline">戻る</a>
				</div>

			</form>
		</div>
	</div>

	<script>
// 各種バリデーション＆入力制御処理（完全に統一連動）
document.addEventListener("DOMContentLoaded", function() {
    const emailInput = document.getElementById("email");
    const emailConfirmInput = document.getElementById("emailConfirm");
    const emailError = document.getElementById("emailError");
    const emailConfirmError = document.getElementById("emailConfirmError");
    const zipInput = document.getElementById("zipCode"); 
    const form = document.querySelector("form");

    // ⚡ 郵便番号のリアルタイム整形スクリプト
    zipInput.addEventListener("input", function() {
        let value = zipInput.value;
        
        // 全角を半角に変換
        value = value.replace(/[０-９]/g, function(s) {
            return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
        });
        
        // 数字以外の記号（ハイフンなど）を除去
        value = value.replace(/[^0-9]/g, '');
        zipInput.value = value;
    });

    // メールアドレスの形式チェック
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    function validateEmail() {
        if (emailInput.value === "") {
            emailError.classList.add("d-none");
            return true;
        }
        if (!emailRegex.test(emailInput.value)) {
            emailError.textContent = "⚠️ メールの形式（@やドメインなど）が正しくありません。";
            emailError.classList.remove("d-none");
            return false;
        } else {
            emailError.classList.add("d-none");
            return true;
        }
    }

    function validateConfirmEmail() {
        if (emailConfirmInput.value === "") {
            emailConfirmError.classList.add("d-none");
            return true;
        }
        if (emailInput.value !== emailConfirmInput.value) {
            emailConfirmError.textContent = "⚠️ 入力されたメールアドレスと一致しません。";
            emailConfirmError.classList.remove("d-none");
            return false;
        } else {
            emailConfirmError.classList.add("d-none");
            return true;
        }
    }

    emailInput.addEventListener("blur", () => { validateEmail(); validateConfirmEmail(); });
    emailConfirmInput.addEventListener("blur", validateConfirmEmail);

    // 送信時の最終防衛ライン
    form.addEventListener("submit", function(event) {
        const isEmailValid = validateEmail();
        const isConfirmValid = validateConfirmEmail();
        const isZipValid = zipInput.value.length === 7;

        if (!isEmailValid || !isConfirmValid || !isZipValid) {
            event.preventDefault(); 
            if (!isZipValid) {
                alert("郵便番号はハイフンなしの7桁で入力してください。");
            } else {
                alert("メールアドレスの入力内容に不備があります。修正してください。");
            }
        }
    });
});
</script>

</body>
</html>
<%@ include file="template/footer.jsp"%>