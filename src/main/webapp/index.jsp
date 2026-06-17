<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // プロジェクト名が変わっても自動追随できるようにコンテキストパスを取得
    String contextPath = request.getContextPath();
    
    // /C44_marmot/main へ強制的にリダイレクト（転送）する
    response.sendRedirect(contextPath + "/main");
%>