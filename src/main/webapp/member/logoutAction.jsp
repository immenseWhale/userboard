<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%
	//로그인 했든 안했든 로그인 폼으로 가면 되니까 분기를 나눌 필요 없다.
	session.invalidate();
	response.sendRedirect(request.getContextPath()+"/home.jsp");	
%>