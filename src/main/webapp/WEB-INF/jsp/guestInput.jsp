<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="template/header.jsp" %>
<%@ include file="template/dialogs.jsp" %>
<%@ include file="template/cartSideBar.jsp" %>
<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>お届け先情報の入力 - Tea Salon</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <script src="https://yubinbango.github.io/yubinbango/yubinbango.js" charset="UTF-8" defer></script>

    <style>
        /* ☕ 紅茶ブランドをイメージしたカスタムカラーテーマ */
        :root {
            --tea-primary: #6F4E37;      /* 深みのあるプレーンな紅茶・ブラウン */
            --tea-dark: #4A3325;         /* アッサムのような濃厚なダークブラウン */
            --tea-accent: #C5A059;       /* 贅沢なゴールド・プレミアムベージュ */
            --tea-bg-page: #F5EFEB;      /* ほんのり甘いミルクティーをイメージした温かみのある背景色 */
            --tea-badge-required: #A94442; /* 落ち着いたアンティークレッド（必須用・エラー用） */
        }

        body.tea-theme {
            background-color: var(--tea-bg-page) !important; /* 画面全体の背景 */
            color: var(--tea-dark);
            font-family: 'Helvetica Neue', Arial, 'Hiragino Kaku Gothic ProN', 'Segoe UI', sans-serif;
        }

        /* エレガントなカードデザイン */
        .tea-card {
            border: 1px solid rgba(111, 78, 55, 0.12);
            border-radius: 14px;
            box-shadow: 0 6px 25px rgba(74, 51, 37, 0.07) !important;
            background-color: #FFFFFF !important; /* 入力エリアは白にして清潔感と見やすさを確保 */
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

        /* 入力フォームの美装化 */
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

        /* 必須バッジ */
        .badge-tea-req {
            background-color: var(--tea-badge-required) !important;
            font-weight: 500;
            font-size: 0.75rem;
            padding: 3px 6px;
            vertical-align: middle;
        }

        /* ボタン */
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
        }
        .btn-tea-outline:hover {
            background-color: rgba(111, 78, 55, 0.05);
            color: var(--tea-dark);
            border-color: var(--tea-primary);
        }

        /* クレジットカードエリア */
        .credit-card-section {
            background-color: #FAF6F3 !important; /* カードエリアを少し濃いめのストレートティー色に */
            border: 1px dashed rgba(111, 78, 55, 0.3) !important;
            border-radius: 8px;
        }
    </style>
</head>
<body class="tea-theme">

<div class="container my-5" style="max-width: 600px;">
    <div class="card p-4 tea-card">
        <div class="text-center mb-4">
            <div class="mb-2" style="font-size: 2.2rem; color: var(--tea-primary);">☕</div>
            <h3 class="fw-bold tea-title">お届け先・お支払い情報の入力</h3>
            <p class="text-muted small mt-2">ログインせずにゲストとして購入手続きを進めます。</p>
        </div>
        
        <form action="OrderConfirmServlet" method="POST" class="h-adr">
            <span class="p-country-name" style="display:none;">Japan</span>
            
            <div class="mb-3">
                <label for="userName" class="form-label fw-bold">お名前 <span class="badge badge-tea-req">必須</span></label>
                <input type="text" class="form-control" id="userName" name="guestName" placeholder="山田 太郎" autocomplete="name" required>
            </div>
            
            <div class="mb-3">
                <label for="email" class="form-label fw-bold">メールアドレス <span class="badge badge-tea-req">必須</span></label>
                <input type="email" class="form-control" id="email" name="email" placeholder="example@mail.com" required>
                <div id="emailError" class="small mt-1 d-none" style="color: var(--tea-badge-required); font-weight: 500;"></div>
            </div>
            
            <div class="mb-3">
                <label for="emailConfirm" class="form-label fw-bold">メールアドレス（確認用） <span class="badge badge-tea-req">必須</span></label>
                <input type="email" class="form-control" id="emailConfirm" placeholder="うっかり入力を防ぐため、もう一度ご入力ください" required>
                <div id="emailConfirmError" class="small mt-1 d-none" style="color: var(--tea-badge-required); font-weight: 500;"></div>
            </div>
            
            <div class="mb-3">
                <label for="zipCode" class="form-label fw-bold">郵便番号 <span class="badge badge-tea-req">必須</span></label>
                <input type="text" class="form-control p-postal-code" id="zipCode" name="zipCode" placeholder="1234567（ハイフンなし）" maxlength="7" inputmode="numeric" required>
                <div class="form-text small text-muted">※半角数字7桁でご入力ください。</div>
            </div>
            
            <div class="mb-3">
                <label for="address" class="form-label fw-bold">ご住所（お届け先） <span class="badge badge-tea-req">必須</span></label>
                <input type="text" class="form-control p-region p-locality p-street-address" id="address" name="address" placeholder="〇〇県〇〇市〇〇町1-2-3" required>
                <div class="form-text small text-muted">※郵便番号を入力すると自動補完されます。以降の番地や建物名を手動で追記してください。</div>
            </div>
            
            <div class="mb-3">
                <label for="tel" class="form-label fw-bold">電話番号 <span class="badge badge-tea-req">必須</span></label>
                <input type="tel" class="form-control" id="tel" name="tel" placeholder="09012345678（ハイフンなし）" required>
            </div>
            
            <div class="mb-4">
                <label for="payment" class="form-label fw-bold">決済方法 <span class="badge badge-tea-req">必須</span></label>
                <select class="form-select" id="payment" name="payment" required onchange="toggleCardForm()">
                    <option value="credit">クレジットカード</option>
                    <option value="bank">銀行振込（前払い）</option>
                    <option value="cod">代金引換</option>
                    <option value="convenience">コンビニ決済（前払い）</option>
                </select>
            </div>
            
            <div id="creditCardForm" class="p-3 mb-4 credit-card-section" style="display: block;">
                <h5 class="fw-bold mb-3" style="font-size: 0.95rem; color: var(--tea-primary); letter-spacing: 0.03em;">💳 クレジットカード情報</h5>
                
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
            
            <hr class="my-4" style="border-color: rgba(111, 78, 55, 0.15);">
            
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-tea-submit btn-lg">購入確認画面へ進む ➔</button>
                <a href="productDetail" class="btn btn-tea-outline">カートに戻る</a>
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

// 各種バリデーション＆入力制御処理
document.addEventListener("DOMContentLoaded", function() {
    const emailInput = document.getElementById("email");
    const emailConfirmInput = document.getElementById("emailConfirm");
    const emailError = document.getElementById("emailError");
    const emailConfirmError = document.getElementById("emailConfirmError");
    const zipInput = document.getElementById("zipCode"); // 郵便番号欄
    const form = document.querySelector("form");

    // ⚡ 郵便番号のハイフン・記号をリアルタイムで自動消去するスクリプト
    zipInput.addEventListener("input", function() {
        let value = zipInput.value;
        
        // 全角数字が入力された場合は半角に変換
        value = value.replace(/[０-９]/g, function(s) {
            return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
        });
        
        // ハイフンや記号など「数字以外」の文字をすべて空文字に置き換えて即時消去
        value = value.replace(/[^0-9]/g, '');
        
        // 整形後の綺麗な数字データを入力欄に差し戻す
        zipInput.value = value;
    });

    // メールアドレスの簡易形式チェック（正規表現）
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

    // フォーム送信時の最終防衛ライン
    form.addEventListener("submit", function(event) {
        const isEmailValid = validateEmail();
        const isConfirmValid = validateConfirmEmail();
        
        // 郵便番号がちゃんと7桁になっているかも最終チェック
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

window.onload = toggleCardForm;
</script>

</body>
</html>

<%@ include file="template/footer.jsp" %>