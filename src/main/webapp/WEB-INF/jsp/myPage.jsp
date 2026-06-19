<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>マイページ</title>
<style>
    /* 画面が見やすくなるように簡単なスタイルをあてています */
    table { border-collapse: collapse; width: 80%; margin: 20px 0; }
    th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
    th { background-color: #f2f2f2; width: 25%; }
    td.edit { width: 10%; text-align: center; }
    .btn-container { margin-top: 20px; display: flex; gap: 10px; }
</style>
</head>
<body>

<h1>マイページ（会員情報）</h1>

<table>
    <tr>
        <th>ユーザーID</th>
        <td><c:out value="${loginUser.userId}" /></td>
        <td class="edit"></td>
    </tr>
    <tr>
        <th>パスワード</th>
        <td>******</td>
        <td class="edit"><a href="EditAccountServlet?field=password">編集</a></td>
    </tr>
    <tr>
        <th>氏名</th>
        <td><c:out value="${loginUser.userName}" /></td>
        <td class="edit"><a href="EditAccountServlet?field=user_name">編集</a></td>
    </tr>
    <tr>
        <th>郵便番号</th>
        <td><c:out value="${loginUser.postalCode}" /></td>
        <td class="edit"><a href="EditAccountServlet?field=postal_code">編集</a></td>
    </tr>
    <tr>
        <th>配送先住所</th>
        <td><c:out value="${loginUser.address}" /></td>
        <td class="edit"><a href="EditAccountServlet?field=address">編集</a></td>
    </tr>
    <tr>
        <th>メールアドレス</th>
        <td><c:out value="${loginUser.email}" /></td>
        <td class="edit"><a href="EditAccountServlet?field=email">編集</a></td>
    </tr>
    <tr>
        <th>電話番号</th>
        <td><c:out value="${loginUser.phoneNumber}" /></td>
        <td class="edit"><a href="EditAccountServlet?field=phone_number">編集</a></td>
    </tr>
    <tr>
        <th>クレジットカード番号</th>
        <td><c:out value="${loginUser.cardNumber}" /></td>
        <td class="edit"><a href="EditAccountServlet?field=card_number">編集</a></td>
    </tr>
    <tr>
        <th>クレジットカード名義</th>
        <td><c:out value="${loginUser.cardName}" /></td>
        <td class="edit"><a href="EditAccountServlet?field=card_name">編集</a></td>
    </tr>
    <tr>
        <th>カード有効期限</th>
        <td><c:out value="${loginUser.cardExpiration}" /></td>
        <td class="edit"><a href="EditAccountServlet?field=card_expiration">編集</a></td>
    </tr>
</table>
<%-- 💡 ページ上部にフォーマット用JSTLタグの宣言がなければ追加してください --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

</table>

<hr>

<h2>購入履歴</h2>
<c:choose>
    <%-- 履歴が一件も無い場合の判定 --%>
    <c:when test="${empty orderHistory}">
        <p>購入履歴はありません。</p>
    </c:when>
    <c:otherwise>
        <table border="1" style="width: 100%; border-collapse: collapse; margin-top: 10px;">
            <tr style="background-color: #e0e0e0;">
                <th>注文日時</th>
                <th>商品名</th>
                <th>単価</th>
                <th>数量</th>
                <th>合計金額</th>
                <th>決済方法</th>
            </tr>
            <%-- サーブレットから渡された注文リストをループ出力 --%>
            <c:forEach var="order" items="${orderHistory}">
                <tr>
                    <td>
                        <%-- LocalDateTime型を yyyy/MM/dd HH:mm 形式に整えて表示 --%>
                        <c:out value="${order.orderDate.toString().replace('T', ' ').substring(0, 16)}" />
                    </td>
                    <td><c:out value="${order.productName}" /></td>
                    <td><fmt:formatNumber value="${order.unitPrice}" type="currency" currencySymbol="¥" maxFractionDigits="0"/></td>
                    <td><c:out value="${order.quantity}" /></td>
                    <td style="font-weight: bold;">
                        <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="¥" maxFractionDigits="0"/>
                    </td>
                    <td><c:out value="${order.paymentMethod}" /></td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>

<div class="btn-container">

<div class="btn-container">
    <form action="Main" method="get">
        <input type="submit" value="メイン画面へ戻る">
    </form>

    <form action="DeleteFieldServlet" method="post" onsubmit="return confirm('クレジットカード情報を削除してもよろしいですか？');">
        <input type="submit" value="カード情報のみ削除" style="background-color: #ff9800; color: white; border: none; padding: 6px 12px; cursor: pointer;">
    </form>

    <form action="DeleteAccountServlet" method="post" onsubmit="return confirm('本当に退会（アカウント削除）しますか？この操作は取り消せません。');">
        <input type="submit" value="退会する" style="background-color: #f44336; color: white; border: none; padding: 6px 12px; cursor: pointer;">
    </form>
</div>

</body>
</html>