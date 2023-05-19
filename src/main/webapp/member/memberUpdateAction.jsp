<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%
	//유효성 검사
	request.setCharacterEncoding("utf-8");	
	
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
	
	//리다이렉트를 위한 메시지 변수 선언 + 공백 처리
	String msg = null;
	String memberId = "";
	String memberPw = "";	
	String newPw1 = "";
	String newPw2 = "";

	//공백이거나 null이 넘어오면 확인 메시지를 form에 출력하겠다.
	if(request.getParameter("memberId") == null||
	request.getParameter("memberPw") == null||
	request.getParameter("newPw1") == null||
	request.getParameter("newPw2") == null||							
	request.getParameter("memberId").equals("")||
	request.getParameter("memberPw").equals("")||
	request.getParameter("newPw1").equals("")||
	request.getParameter("newPw2").equals("")){
		msg = "Please check the password";			
	}
	//새로운 비밀번호와 확인이 맞지 않으면 msg
	if(!request.getParameter("newPw1").equals(request.getParameter("newPw2"))){
		msg = "Password donesn't match";	
	}
	if(msg != null){
		//잘못 된 경로로 들어온 경우 메시지를 하나 보여주겠다.													
		response.sendRedirect(request.getContextPath()+"/member/userInfoForm.jsp?msg="+msg);
		return;	//코드진행 종료
	}

	// 파라미터 값 확인 후 String에 넣어주겠다
	System.out.println(GREEN + request.getParameter("memberPw")+"<--memberPw--memberUpdateAction parm "+RESET);
	System.out.println(GREEN + request.getParameter("newPw1")+"<--newPw1--memberUpdateAction parm "+RESET);
	System.out.println(GREEN + request.getParameter("newPw2")+"<--newPw2--memberUpdateAction parm "+RESET);
	System.out.println(GREEN + request.getParameter("memberId")+"<--memberId--memberUpdateAction parm "+RESET);
	memberId = request.getParameter("memberId");
	memberPw = request.getParameter("memberPw");	
	newPw1 = request.getParameter("newPw1");
	newPw2 = request.getParameter("newPw2");
	System.out.println(BG_RED+memberPw+RESET);
	
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("memberUpdateAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("memberUpdateAction-->접속성공 "+conn);	
	
	//멤버 id,pw가 맞는다면 비밀번호와 업데이트 날짜를 바꿔라 
	String upMember = "UPDATE member SET member_pw=PASSWORD(?), updatedate=NOW() WHERE member_id=? AND member_pw=PASSWORD(?)";
	PreparedStatement upMemberStmt = conn.prepareStatement(upMember);
	System.out.println(YELLOW + upMemberStmt + " <--changePwAction stmt" + RESET);
	upMemberStmt.setString(1, newPw1);
	upMemberStmt.setString(2, memberId);
	upMemberStmt.setString(3, memberPw);
	
	//만약 바뀐 행이 하나도 없다면 수정된게 아니다. 비밀번호가 틀렸을거다.
	int row = upMemberStmt.executeUpdate();
	System.out.println(BG_RED + "upMemberStmt memberUpdateAction.jsp-->" + row +RESET);
	
	if(row == 0){//비밀번호가 틀려서 삭제 못했을 거다 -> 삭제 행이 0행이다.
		//실패하면 다시 폼
		response.sendRedirect(request.getContextPath()+"/member/userInfoForm.jsp?msg=Incorrect Pw");
		System.out.println("수정불가");		
	}else if(row==1){//성공했으니 확인 페이지로 간다. 
		response.sendRedirect(request.getContextPath()+"/member/userInfoForm.jsp?msg=Password change successful");
		System.out.println("수정성공");
	}else{
		//update문 실행을 취소(rollback)해야한다. 아직 배우지 않았다.
		System.out.println("error row 값 " + row +"다");
	}
%>