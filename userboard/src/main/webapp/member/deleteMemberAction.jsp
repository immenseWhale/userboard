<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%	
	//유효성 검사
	request.setCharacterEncoding("utf-8");	
	
	//세션 검사
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
	
	//msg를 보내주기 위한 변수 선언
	String msg = null;	
	//memberPw가 null이거나 ""이면 msg를 보내겠다
	if(request.getParameter("memberPw") == null||
	request.getParameter("memberPw").equals("")){
		msg = "Please check the password";			
	}
	if(msg != null){												
		response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp?msg="+msg);
		return;
	}
	// 파라미터 값 확인 후 String에 넣어주겠다
	System.out.println(GREEN + request.getParameter("memberPw")+"<--memberPw--memberUpdateAction parm "+RESET);
	System.out.println(GREEN + request.getParameter("memberId")+"<--memberId--memberUpdateAction parm "+RESET);
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");	
	
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("deleteMemberAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("deleteMemberAction-->접속성공 "+conn);
	
	
	
	PreparedStatement deleteMemberStmt = null;
	int deleteMemberRow = 0;
	//삭제 sql
	String deleteMemberSql = "DELETE FROM member WHERE member_id = ? AND member_Pw = PASSWORD(?)";
	deleteMemberStmt = conn.prepareStatement(deleteMemberSql);
	deleteMemberStmt.setString(1, memberId);
	deleteMemberStmt.setString(2, memberPw);
	System.out.println(BG_RED + deleteMemberStmt + " <-  deleteMemberStmt deleteMemberAction");
	deleteMemberRow = deleteMemberStmt.executeUpdate();
	System.out.println(deleteMemberRow + " <- deleteMemberRow deleteMemberAction" +RESET);
	
	if (deleteMemberRow != 0){
		System.out.println("삭제 성공");
		//삭제를 성공했으니 세션을 invalidate 해준다.
		session.invalidate();
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		
	}else{
		msg = "PW Error!";
		System.out.println("삭제 실패");
		response.sendRedirect(request.getContextPath() + "/member/deleteMemberForm.jsp?msg=" + msg);
	}
	
%>