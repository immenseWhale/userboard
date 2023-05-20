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
	
	
	//세선 유효성 검사가 최우선 --> 요청값 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		System.out.println(YELLOW +"세션유효성검사에서 튕긴다"+RESET);
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- insertLocalAcion loginMemberId" + RESET);

	//요청값 유효성 검사
	if(request.getParameter("newLocal") == null ||
	request.getParameter("newLocal").equals("")){
		response.sendRedirect(request.getContextPath()+"/local/insertLocalForm.jsp");
		return;	
	}
	
	String newLocal = request.getParameter("newLocal");
	System.out.println(newLocal + "<-- insertLocalAcion newLocal");

	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println(GREEN + "insertLocalAcion-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("insertLocalAcion-->접속성공 "+conn+ RESET);
	
	//아이디 중복 검사
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT * FROM local WHERE local_name=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, newLocal);
	System.out.println(BG_RED + stmt + " <-아이디중복검사-- insertLocalAcion stmt" + RESET);
	
	rs = stmt.executeQuery(); // executeQuery() 메소드 사용
	boolean ck = rs.next(); // 결과가 있는 경우 true, 없는 경우 false
	System.out.println(BG_RED + ck + " <--ck-- insertLocalAcion ck" + RESET);
	//만약 ck가 참이라면 msg 메시지를 주겠다
	String msg = null;
	if (ck) {
	    msg = "Duplicated LocalName";
		System.out.println(msg + "<--에러메시지삽입-- insertLocalAcion");
	}
	//msg가 null값이 아니면 msg를 보내주면서 종료하겠다.
	if (msg != null) {
	    response.sendRedirect(request.getContextPath()+"/local/insertLocalForm.jsp?msg="+msg);
	    return;    
	}
	
	
	//local 삽입을 위한 sql문
	PreparedStatement stmt2 = null;
	String sql2 = "insert into local(local_name,  createdate, updatedate)  values(?, now(), now())";
	
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, newLocal);
	System.out.println(YELLOW + stmt2 + " <--삽입sql-- insertLocalAcion " +RESET);
	
	//똑바로 들어갔다면 한 행만 갱신됐다고 뜰 것이다.
	int row = stmt2.executeUpdate();
	System.out.println(row + " <-- insertLocalAcion row" + RESET);
	
	//모두 입력 후 localList로 돌려보내기
	// row가 0이 아니면 sql이 제대로 실행됐을 것이니 리턴시킨다.
	if (row != 0){
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg=Insert Successful!");
		System.out.println(GREEN + " 성공 후 list로 리턴 " +RESET);
		return;
	}

%>