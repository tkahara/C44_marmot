<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<h2>つぶやきを編集</h2>

<form action="EditMutterServlet" method="post">
  <input type="hidden" name="id" value="${mutter.id}" />

  <p>名前：${mutter.userName}</p>

  <input type="text" name="text" value="${mutter.text}" size="40" />
  <br>
  <br>
  <input type="submit" value="更新" />
</form>
