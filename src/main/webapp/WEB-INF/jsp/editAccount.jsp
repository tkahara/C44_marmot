<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 💡 全角のダブルクォーテーションを半角にし、コメントをJSPの形式に修正 --%>
<%
    String field = (String) request.getAttribute("field");
    String fieldLabel = (String) request.getAttribute("fieldLabel");
    String currentValue = (String) request.getAttribute("currentValue");
    
    // 💡 クレジットカード情報がNULLの場合のヌルポインタ対策
    if (currentValue == null) {
        currentValue = "";
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= fieldLabel %>の編集</title>
</head>
<body>
<main> <%-- 💡 グループ指示にあった <main> タグを開始 --%>

<h1><%= fieldLabel %>の変更</h1>

<form action="EditAccountServlet" method="post">
    <input type="hidden" name="field" value="<%= field %>">

    <p>現在の値: 
        <strong>
            <%= field.equals("pass") ? "********" : (currentValue.isEmpty() ? "（未登録）" : currentValue) %>
        </strong>
    </p>

    <p>新しい<%= fieldLabel %>を入力してください：<br>
        <% if (field.equals("pass")) { %>
            <input type="password" name="newValue" required style="padding: 5px; width: 250px;">
        <% } else { %>
            <%-- 💡 クレジットカードは任意入力(空にできる)にするため、fieldがcardNumのときは required を外すのが妥当です --%>
            <input type="text" name="newValue" value="<%= currentValue %>" <%= field.equals("cardNum") ? "" : "required" %> style="padding: 5px; width: 250px;">
        <% } %>
    </p>

    <input type="submit" value="変更を保存する" style="padding: 8px 15px;">
    <%-- 💡 キャンセル時の戻り先がMyPageServletまたはMainなど環境に合わせて調整してください --%>
    <input type="button" value="キャンセル" onclick="location.href='Main'" style="padding: 8px 15px;">
</form>

</main> <%-- 💡 グループ指示にあった </main> で閉じる --%>
</body>
</html>