<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ユーザー登録</title>
<style>
    /* 画面を綺麗に整えるための簡単なスタイルシート */
    table { border-collapse: collapse; width: 60%; margin: 20px 0; }
    th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: left; }
    th { background-color: #f2f2f2; width: 35%; }
    .required { color: red; margin-left: 5px; font-size: 12px; }
    .optional { color: #666; margin-left: 5px; font-size: 12px; }
    .btn-container { margin-top: 15px; display: flex; gap: 10px; }
</style>
</head>
<body>

<h1>ユーザー新規登録</h1>

<c:choose>
    <%-- 💡 修正箇所：resume から test 属性に変更し、エラーを解消 --%>
    <c:when test="${isSuccess}">
        <p style="color: green; font-weight: bold;">新規登録が完了しました。</p>
        <form action="LoginServlet" method="get">
            <input type="submit" value="ログイン画面へ">
        </form>
    </c:when>
    
    <c:otherwise>
        <%-- エラーメッセージがある場合に赤字で表示 --%>
        <c:if test="${not empty msg}">
            <p style="color: red; font-weight: bold;"><c:out value="${msg}" /></p>
        </c:if>

        <form action="RegisterServlet" method="post">
            <table>
                <tr>
                    <th>ユーザーID<span class="required">(必須)</span></th>
                    <td><input type="text" name="userId" required style="width: 80%;"></td>
                </tr>
                <tr>
                    <th>パスワード<span class="required">(必須)</span></th>
                    <td><input type="password" name="pass" required style="width: 80%;"></td>
                </tr>
                <tr>
                    <th>氏名<span class="required">(必須)</span></th>
                    <td><input type="text" name="name" required style="width: 80%;"></td>
                </tr>
                <tr>
                    <th>郵便番号<span class="required">(必須)</span></th>
                    <td><input type="text" name="postalCode" placeholder="123-4567" required style="width: 50%;"></td>
                </tr>
                <tr>
                    <th>配送先住所<span class="required">(必須)</span></th>
                    <td><input type="text" name="address" required style="width: 90%;"></td>
                </tr>
                <tr>
                    <th>メールアドレス<span class="required">(必須)</span></th>
                    <td><input type="email" name="mail" required style="width: 80%;"></td>
                </tr>
                <tr>
                    <th>電話番号<span class="required">(必須)</span></th>
                    <td><input type="tel" name="tel" required style="width: 60%;"></td>
                </tr>
                <tr>
                    <th>クレジットカード番号<span class="optional">(任意)</span></th>
                    <td><input type="text" name="cardNum" placeholder="16桁の半角数字" style="width: 80%;"></td>
                </tr>
                <tr>
                    <th>クレジットカード名義<span class="optional">(任意)</span></th>
                    <td><input type="text" name="cardName" placeholder="TAROU SUZUKI" style="width: 80%;"></td>
                </tr>
                <tr>
                    <th>カード有効期限<span class="optional">(任意)</span></th>
                    <td><input type="text" name="cardExpiration" placeholder="MM/YY" style="width: 40%;"></td>
                </tr>
            </table>
            
            <div class="btn-container">
                <input type="submit" value="登録する" style="padding: 6px 20px; font-weight: bold;">
        </form>
        
        <%-- キャンセル時はWelcomeServletまたはメイン画面へ戻る --%>
        <form action="Main" method="get">
        <input type="submit" value="キャンセル" style="padding: 6px 20px;">
        </form>                
            </div>
    </c:otherwise>
</c:choose>

</body>
</html>