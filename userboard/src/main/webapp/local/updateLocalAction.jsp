<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%
	final String RESET = "\u001B[0m" ;                           
	final String RED = "\u001B[31m";
	final String BG_RED = "\u001B[41m";
	final String GREEN = "\u001B[32m ";
	final String YELLOW = "\u001B[33m";
	
	request.setCharacterEncoding("UTF-8");
	//세선 유효성 검사가 최우선 --> 요청값 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		System.out.println(YELLOW +"세션유효성검사에서 튕긴다"+RESET);
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- insertLocalAcion loginMemberId" + RESET);
	String loginMemberId =(String)session.getAttribute("loginMemberId") ;

	//파라미터값 검사
	if(request.getParameter("newLocal") == null ||
		request.getParameter("localName") == null ||
		request.getParameter("password") == null ||
	request.getParameter("newLocal").equals("")||
	request.getParameter("password").equals("")||
	request.getParameter("localName").equals("")){
		System.out.println(YELLOW +"파라미터검사에서 튕긴다"+RESET);
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
		return;	
	}
	String newLocal = request.getParameter("newLocal");	
	String localName = request.getParameter("localName");
	String password = request.getParameter("password");
	System.out.println(GREEN + newLocal + "<--parm-- updateLocalAction newLocal " +RESET);
	System.out.println(GREEN + localName + "<--parm-- updateLocalAction localName " +RESET);
	System.out.println(GREEN + password + "<--parm-- updateLocalAction password " +RESET);
	
	/*
	수정, 삭제를 위해서는 board 테이블에 그 지역명이 없어야 한다.
	SELECT COUNT(local_name)
	FROM board
	WHERE local_name='광명'; 
	이 쿼리가 0인 경우에만 수정 삭제가 가능하다.
	0이 아니라면 msg를 보내주고 0이라면 수정하겠다.
	*/
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println( "updateLocalAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("updateLocalAction-->접속성공 "+conn);
	
	//board에 현재 local_name이 있는지 검사
	String ckSql = "SELECT COUNT(local_name) FROM board WHERE local_name=?";
	PreparedStatement ckStmt = conn.prepareStatement(ckSql);
	ckStmt.setString(1, localName);
	System.out.println(YELLOW + ckStmt + " <---stmt-- updateLocalAction ckStmt" + RESET);
	ResultSet ckRs = ckStmt.executeQuery();
	
	//몇개의 행이있는지 받아온다
	int boardCk = 0;
	if(ckRs.next()) {
		boardCk = ckRs.getInt("COUNT(local_name)");
	}
	System.out.println(GREEN + boardCk + " <---board 개수 검사 boardCk-- updateLocalAction boardCk" + RESET);
	
	//만약 boardCk가 0이 아니라면 에러 메시지를 보내고 리턴해주겠다.
	String msg = null;
	if(boardCk != 0){
		System.out.println(BG_RED +"board에 행이 있어 삭제 불가"+RESET);
		msg = "It's related";
	}
	if (msg != null) {
	    response.sendRedirect(request.getContextPath()+"/local/updateLocalForm.jsp?localName="+URLEncoder.encode(localName, "UTF-8")+"&msg="+msg);
	    return;
	}
	
	//입력받은 비밀번호가 db의 비밀번호와 일치하는지 검사-----------------------------------------------//
	String memberSql = "SELECT member_pw FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
	PreparedStatement memberStmt = conn.prepareStatement(memberSql);
	memberStmt.setString(1, loginMemberId);
	memberStmt.setString(2, password);
	ResultSet memberRs = memberStmt.executeQuery();
	if(memberRs.next()) {
	    // 비밀번호가 일치하는 경우
    	System.out.println(GREEN +"비밀번호 일치"+RESET);
	} else {
    	// 비밀번호가 일치하지 않는 경우
    	System.out.println("비밀번호 불일치");
		response.sendRedirect(request.getContextPath()+"/local/updateLocalForm.jsp?localName="+URLEncoder.encode(localName, "UTF-8")+"&msg=check your password");
		return;
	}

	
	
	//수정 sql------------------------------------------------------------------//
	String upSql = "update local set local_name=?, updatedate=NOW() where local_name=?";
	PreparedStatement upStmt = conn.prepareStatement(upSql);
	upStmt.setString(1, newLocal);
	upStmt.setString(2, localName);
	System.out.println(YELLOW + upStmt + " <---stmt-- updateLocalAction upStmt" + RESET);
	//똑바로 들어갔다면 한 행만 갱신됐다고 뜰 것이다.
	int row = upStmt.executeUpdate();
	System.out.println(BG_RED + row + " <--갱신-- updateLocalAction row" + RESET);
	
	//모두 입력 후 localList로 돌려보내기
	// row가 0이 아니면 sql이 제대로 실행됐을 것이니 리턴시킨다.
	if (row != 0){
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg=update Successful!");
		System.out.println(GREEN + " 성공 후 list로 리턴 updateLocalAction" +RESET);
		return;
	}
%>