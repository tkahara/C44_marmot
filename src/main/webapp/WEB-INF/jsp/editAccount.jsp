<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String field = (String) request.getAttribute("field");
    String fieldLabel = (String) request.getAttribute("fieldLabel");
    String currentValue = (String) request.getAttribute("currentValue");
    
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
                
                <%-- 🌟【修正】サーブレット側の最新のカラム名と判定条件を一致させました --%>
                <% if (field.equals("password")) { %>
                    <input type="password" class="form-control" id="newValue" name="newValue" required placeholder="••••••••" minlength="8">
                    
                <% } else if (field.equals("postal_code")) { %>
                    <input type="text" class="form-control p-postal-code" id="newValue" name="newValue" 
                           placeholder="1234567（ハイフンなし）" maxlength="7" inputmode="numeric" required>
                    <div class="form-text small text-muted mt-2">※半角数字7桁で入力してください。ハイフンは自動削除されます。</div>
                    
                <% } else if (field.equals("address")) { %>
                    <input type="text" class="form-control p-region p-locality p-street-address" id="newValue" name="newValue" 
                           value="<%= currentValue %>" required placeholder="〇〇県〇〇市〇〇町1-2-3">
                    <div class="form-text small text-muted mt-2">※郵便番号と連動して自動入力されます。</div>

                <% } else { %>
                    <input type="text" class="form-control" id="newValue" name="newValue" 
                           value="<%= currentValue %>" <%= field.equals("card_number") ? "" : "required" %>>
                <% } %>
            </div>

            <hr class="my-4" style="border-color: rgba(111, 78, 55, 0.15);">

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-tea-submit btn-lg">変更を保存する ➔</button>
                <%-- 🌟【修正】キャンセルボタンの遷移先を正しくマイページに変更 --%>
                <a href="${pageContext.request.contextPath}/MyPageServlet" class="btn btn-tea-outline">キャンセルして戻る</a>
            </div>
        </form>
    </div>
</main>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const zipInput = document.getElementById("newValue");
    const form = document.querySelector("form");
    const fieldType = "<%= field %>";

    // 🌟【修正】判定文字を postal_code に同期
    if (zipInput && fieldType === "postal_code") {
        zipInput.addEventListener("input", function() {
            let value = zipInput.value;
            value = value.replace(/[０-９]/g, function(s) {
                return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
            });
            value = value.replace(/[^0-9]/g, '');
            zipInput.value = value;
        });
    }

    form.addEventListener("submit", function(event) {
        if (zipInput && fieldType === "postal_code") {
            const isZipValid = zipInput.value.length === 7;
            if (!isZipValid) {
                event.preventDefault();
                alert("郵便番号はハイフンなしの7桁で正しく入力してください。");
            }
        }
    });
});
</script>

</body>
</html>