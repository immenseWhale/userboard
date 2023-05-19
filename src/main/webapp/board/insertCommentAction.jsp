<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//세션 유효성 검사가 가장 먼저
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("home.jsp로 리턴");
		return;
	}
	final String RESET = "\u001B[0m" ;                           
	final String RED = "\u001B[31m";
	final String BG_RED = "\u001B[41m";
	final String GREEN = "\u001B[32m ";
	final String YELLOW = "\u001B[33m";
	
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- insertCommentAction loginMemberId" + RESET);
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//요청값 유효성 검사 boardNo나 commentcontet가 널 혹은 공백이라면 boardOne으로 돌려보낸다.
	if(request.getParameter("boardNo") == null ||		
	request.getParameter("boardNo").equals("") ||
	request.getParameter("commentContent") == null||
	request.getParameter("commentContent").equals("") ){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("boardOne.jsp로 리턴");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	System.out.println(GREEN +boardNo + "<--boardNo--insertCommentAction " ); 
	System.out.println(commentContent + "<--commentContent--insertCommentAction "+ RESET); 
	
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("insertCommentAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("insertCommentAction-->접속성공 "+conn);	
	
	//comment 삽입을 위한 변수 선언
	String commentInsert = "INSERT INTO comment(board_no,comment_content,member_id,createdate,updatedate) VALUES (?,?,?,NOW(),NOW())";
	PreparedStatement comInsertStmt = conn.prepareStatement(commentInsert);
	comInsertStmt.setInt(1, boardNo);
	comInsertStmt.setString(2, commentContent);
	comInsertStmt.setString(3, loginMemberId);
	
	
	int row = comInsertStmt.executeUpdate(); 
	System.out.println(BG_RED + row + "행이 갱신되었습니다. insertCommentAction"+RESET);
	
	// redirection
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
%>