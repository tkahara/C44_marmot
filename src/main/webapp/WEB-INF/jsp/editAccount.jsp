<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String field = (String) request.getAttribute("field");
    String fieldLabel = (String) request.getAttribute("fieldLabel");
    String currentValue = (String) request.getAttribute("currentValue");
    String errorMsg = (String) request.getAttribute("errorMsg"); // サーブレットからのエラー表示用
    
    if (currentValue == null) {
        currentValue = "";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= fieldLabel %>の編集 - Tea Salon</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://yubinbango.github.io/yubinbango/yubinbango.js" charset="UTF-8" defer></script>
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
            font-family: 'Helvetica Neue', Arial, 'Hiragino Kaku Gothic ProN', 'Segoe UI', sans-serif;
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
        .form-label { color: var(--tea-dark); font-size: 0.95rem; }
        .form-control {
            border: 1px solid rgba(111, 78, 55, 0.25);
            border-radius: 6px;
            padding: 10px 12px;
            background-color: #FFF;
            transition: all 0.2s ease-in-out;
        }
        .form-control:focus {
            border-color: var(--tea-primary);
            box-shadow: 0 0 0 0.25rem rgba(111, 78, 55, 0.15);
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
        .btn-tea-submit:hover { background-color: var(--tea-dark); border-color: var(--tea-dark); color: #FFF; }
        .btn-tea-outline {
            color: var(--tea-primary);
            border-color: rgba(111, 78, 55, 0.4);
            border-radius: 6px;
            font-weight: 500;
            padding: 12px;
            text-align: center;
            text-decoration: none;
            display: block;
        }
        .btn-tea-outline:hover {
            background-color: rgba(111, 78, 55, 0.05);
            color: var(--tea-dark);
            border-color: var(--tea-primary);
        }
        .current-value-box {
            background-color: #FAF6F3;
            border: 1px solid rgba(111, 78, 55, 0.1);
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 1.05rem;
        }
    </style>
</head>
<body class="tea-theme">

<main class="container my-5" style="max-width: 550px;">
    <div class="card p-4 tea-card">
        <div class="text-center mb-4">
            <div class="mb-2" style="font-size: 2.2rem; color: var(--tea-primary);">☕</div>
            <h3 class="fw-bold tea-title"><%= fieldLabel %>の変更</h3>
            <p class="text-muted small mt-2">アカウント情報を最新の内容に更新します。</p>
        </div>

        <%-- 🚨 サーバー側バリデーションエラーの表示領域 --%>
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="alert alert-danger small" role="alert">
                <%= errorMsg %>
            </div>
        <% } %>

        <form action="EditAccountServlet" method="post" class="h-adr">
            <span class="p-country-name" style="display:none;">Japan</span>
            
            <input type="hidden" name="field" value="<%= field %>">

            <div class="mb-4">
                <label class="form-label fw-bold text-muted small">現在の設定値</label>
                <div class="current-value-box fw-bold">
                    <%= field.equals("password") ? "********" : (currentValue.isEmpty() ? "（未登録）" : currentValue) %>
                </div>
            </div>

            <div class="mb-4">
                <label for="newValue" class="form-label fw-bold">新しい<%= fieldLabel %>を入力してください</label>
                
                <% if (field.equals("password")) { %>
                    <input type="password" class="form-control" id="newValue" name="newValue" required placeholder="••••••" minlength="6">
                    
                <% } else if (field.equals("postal_code")) { %>
                    <input type="text" class="form-control p-postal-code" id="newValue" name="newValue" 
                           placeholder="123-4567（ハイフンあり・なし可）" maxlength="10" inputmode="numeric" required>
                    <div class="form-text small text-muted mt-2">※ハイフンは自動で補完されます。</div>
                    
                <% } else if (field.equals("address")) { %>
                    <input type="text" class="form-control p-region p-locality p-street-address" id="newValue" name="newValue" 
                           value="<%= currentValue %>" required placeholder="〇〇県〇〇市〇〇町1-2-3">
                    <div class="form-text small text-muted mt-2">※郵便番号と連動して自動入力されます。</div>

                <%-- 💳 クレジットカード系の個別最適化フォーム --%>
                <% } else if (field.equals("card_number")) { %>
                    <input type="text" class="form-control" id="newValue" name="newValue" 
                           value="<%= currentValue %>" placeholder="1234567812345678" maxlength="16" inputmode="numeric">
                    <div class="form-text small text-muted mt-2">※半角数字16桁。空欄にして保存すると登録を削除できます。</div>

                <% } else if (field.equals("card_name")) { %>
                    <input type="text" class="form-control" id="newValue" name="newValue" 
                           value="<%= currentValue %>" placeholder="TARO KOUCHA" style="text-transform: uppercase;">
                    <div class="form-text small text-muted mt-2">※半角英大文字。空欄にして保存すると登録を削除できます。</div>

                <% } else if (field.equals("card_expiration")) { %>
                    <input type="text" class="form-control" id="newValue" name="newValue" 
                           value="<%= currentValue %>" placeholder="12/29" maxlength="5" inputmode="numeric">
                    <div class="form-text small text-muted mt-2">※「月月/年年」の形式（例: 12/29）。空欄にして保存すると削除できます。</div>

                <% } else if (field.equals("phone_number")) { %>
                    <input type="text" class="form-control" id="newValue" name="newValue" 
                           value="<%= currentValue %>" required placeholder="090-1234-5678（ハイフンあり・なし可）" maxlength="15" inputmode="numeric">
                    <div class="form-text small text-muted mt-2">※ハイフンは自動で補完されます。</div>

                <% } else { %>
                    <input type="text" class="form-control" id="newValue" name="newValue" value="<%= currentValue %>" required>
                <% } %>
            </div>

            <hr class="my-4" style="border-color: rgba(111, 78, 55, 0.15);">

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-tea-submit btn-lg">変更を保存する ➔</button>
                <a href="${pageContext.request.contextPath}/MyPageServlet" class="btn btn-tea-outline">キャンセルして戻る</a>
            </div>
        </form>
    </div>
</main>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const inputField = document.getElementById("newValue");
    const form = document.querySelector("form");
    const fieldType = "<%= field %>";

    if (!inputField) return;

    // 🌟 リアルタイムでの全角半角クレンジング＆入力制御
    inputField.addEventListener("input", function() {
        let value = inputField.value;

        // 全角数字 ➔ 半角数字
        value = value.replace(/[０-９]/g, function(s) {
            return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
        });

        // 🛠️ 郵便番号・電話番号はハイフン入力を許容するように修正（register.jspと完全同期）
        if (fieldType === "postal_code" || fieldType === "phone_number") {
            inputField.value = value.replace(/[^0-9-]/g, '');
        }
        
        if (fieldType === "card_number") {
            // 数字以外を完全削除
            inputField.value = value.replace(/[^0-9]/g, '');
        }
        
        if (fieldType === "card_name") {
            // 全角英字 ➔ 半角英字
            value = value.replace(/[ａ-ｚＡ-Ｚ]/g, function(s) {
                return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
            });
            inputField.value = value.toUpperCase(); // 小文字は自動で大文字へ
        }
    });

    // 🛠️ 郵便番号のフォーカスアウト（Blur）時自動ハイフン挿入を追加
    if (fieldType === "postal_code") {
        inputField.addEventListener("blur", function() {
            let val = this.value.replace(/\D/g, "");
            if (val.length === 7) {
                this.value = val.slice(0, 3) + "-" + val.slice(3);
            }
        });
    }

    // 🛠️ 電話番号のフォーカスアウト（Blur）時自動ハイフン挿入を追加
    if (fieldType === "phone_number") {
        inputField.addEventListener("blur", function() {
            let val = this.value.replace(/\D/g, "");
            if (val.length === 11) {
                this.value = val.slice(0, 3) + "-" + val.slice(3, 7) + "-" + val.slice(7);
            } else if (val.length === 10) {
                if (val.startsWith("03") || val.startsWith("06")) {
                    this.value = val.slice(0, 2) + "-" + val.slice(2, 6) + "-" + val.slice(6);
                } else {
                    this.value = val.slice(0, 3) + "-" + val.slice(3, 6) + "-" + val.slice(6);
                }
            }
        });
    }

    // 💳 有効期限のフォーカスアウト（Blur）時自動スラッシュ補完
    if (fieldType === "card_expiration") {
        inputField.addEventListener("blur", function() {
            let value = inputField.value.replace(/[０-９]/g, function(s) {
                return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
            });
            let digits = value.replace(/\D/g, "");
            if (digits.length === 4) {
                inputField.value = digits.slice(0, 2) + "/" + digits.slice(2);
            }
        });
    }

    // 🌟 送信前の最終フォーマットバリデーション
    form.addEventListener("submit", function(event) {
        // ハイフンやスペース等を除外した純粋な値を取得して検証
        const rawVal = inputField.value.trim();
        const cleanVal = rawVal.replace(/\D/g, "");

        if (fieldType === "postal_code") {
            if (cleanVal.length !== 7) {
                event.preventDefault();
                alert("郵便番号は7桁の数字（ハイフン除く）で正しく入力してください。");
            }
        } 
        else if (fieldType === "phone_number") {
            if (cleanVal.length < 10 || cleanVal.length > 11) {
                event.preventDefault();
                alert("電話番号は10桁または11桁の数字（ハイフン除く）で入力してください。");
            }
        }
        else if (fieldType === "card_number" && rawVal !== "") {
            if (cleanVal.length !== 16) {
                event.preventDefault();
                alert("カード番号は16桁の数字で正しく入力してください。");
            }
        }
        else if (fieldType === "card_expiration" && rawVal !== "") {
            if (!/^\d{2}\/\d{2}$/.test(rawVal)) {
                event.preventDefault();
                alert("有効期限は「月月/年年 (例: 12/29)」の形式で入力してください。");
            } else {
                const month = parseInt(rawVal.split("/")[0], 10);
                if (month < 1 || month > 12) {
                    event.preventDefault();
                    alert("有効期限の「月」は01〜12の間で指定してください。");
                }
            }
        }
    });
});
</script>

</body>
</html>