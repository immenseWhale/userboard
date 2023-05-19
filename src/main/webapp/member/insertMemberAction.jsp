<%@ page language="java" contentType="text/html; chars2et=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import = "java.util.*"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%
	final String RESET = "\u001B[0m" ;                           
	final String RED = "\u001B[31m";
	final String BG_RED = "\u001B[41m";
	final String GREEN = "\u001B[32m ";
	final String YELLOW = "\u001B[33m";
	
	
	//세선 유효성 검사가 최우선 --> 요청값 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- insertMemberAcion loginMemberId" + RESET);

	//요청값 유효성 검사	
	if(request.getParameter("memberId") == null ||			//MemberId가 null이거나 공백이고
	request.getParameter("memberId").equals("") ||	
	request.getParameter("memberPw") == null||				//memberPw가 null이거나 공백이면
	request.getParameter("memberPw").equals("") ){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;												//home으로 돌려보낸다.
	}
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");	
	System.out.println(memberId + "<-- insertMemberAcion memberId");
	System.out.println(memberPw + "<-- insertMemberAcion memberPw");
		
	//vo타입 묶기
	Member insertMember = new Member();
	insertMember.setMemberId(memberId);
	insertMember.setMemberPw(memberPw);
	System.out.println(YELLOW + memberId + "<-- insertMemberAcion insertMember.memberId");
	System.out.println(memberPw + "<-- insertMemberAcion insertMember.memberPw" + RESET);
	
	
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println(GREEN + "loginAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("loginAction-->접속성공 "+conn+ RESET);
	
	//아이디 중복 검사
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT member_id FROM member WHERE member_id=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, insertMember.getMemberId());
	rs = stmt.executeQuery(); // executeQuery() 메소드 사용
	System.out.println(BG_RED + stmt + " <-- insertMemberAction stmt" + RESET);
	boolean ck = rs.next(); // 결과가 있는 경우 true, 없는 경우 false
	System.out.println(BG_RED + ck + " <-- insertMemberAction ck" + RESET);
	//만약 ck가 참이라면 msg 메시지를 주겠다
	String msg = null;
	if (ck) {
	    msg = "Duplicated ID";
	}
	//msg가 null값이 아니면 
	if (msg != null) {
	    response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
	    return;    
	}
	
	
	//회원정보 삽입을 위한 sql문
	PreparedStatement stmt2 = null;
	String sql2 = "insert into member(member_id, member_pw, createdate, updatedate)  values(?, PASSWORD(?), now(), now())";
	
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, insertMember.getMemberId());
	stmt2.setString(2, insertMember.getMemberPw());
	System.out.println(YELLOW + stmt2 + " <-- insertMemberAction sql" +RESET);
	
	//똑바로 들어갔다면 한 행만 갱신됐다고 뜰 것이다.
	int row = stmt2.executeUpdate();
	System.out.println(row + " <-- insertMemberAction row" + RESET);
	
	
	//모두 입력 후 home으로 돌려보내기
	if(memberId != null ||	memberPw != null ||						//memberId가 널이나 공백이아니면(= 입력됐다면)
	memberId.equals("") == false|| 	!memberPw.equals("") == false)	
	{																//home으로 돌려보낸다.
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
%>