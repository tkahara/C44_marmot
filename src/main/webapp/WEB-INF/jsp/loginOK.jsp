<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>スッキリ商店</title>
</head>
<body>

<p>ログインに成功しました</p>

<p>ようこそ<c:out value="${loginUser.userName}" />さん</p>
<a href="Main">トップへ</a>
</body>
</html>