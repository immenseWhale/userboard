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
	
	//세션 로그인값 String에 배정
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- boardAddAction loginMemberId" + RESET);
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//요청값 유효성 검사 null과 공백 허용하지 않는다
	String msg = null;
	if(request.getParameter("memberId") == null ||
	request.getParameter("localName") == null||
	request.getParameter("boardTitle") == null||
	request.getParameter("boardContent") == null||	
	request.getParameter("memberId").equals("") ||
	request.getParameter("localName").equals("") ||
	request.getParameter("boardTitle").equals("") ||	
	request.getParameter("boardContent").equals("") ){
		System.out.println("null이거나 공백입니다 <-----boardAddAction ");
		msg = "Please check the space";

	}
	//파라미터 검사에서 msg가 들어간다면 boardAdd로 msg를 포함해 돌려보내겠다
	if (msg != null) {
	    response.sendRedirect(request.getContextPath()+"/board/boardAdd.jsp?&msg="+msg);
	    return;    
	}
	
	String memberId = request.getParameter("memberId");
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	System.out.println(GREEN +memberId + "<--memberId--boardAddAction " ); 
	System.out.println(localName + "<--localName--boardAddAction "); 
	System.out.println(boardTitle + "<--boardTitle--boardAddAction "); 
	System.out.println(boardContent + "<--boardContent--boardAddAction "+ RESET); 
	
	//memberID와 세션로그인ID가 틀리면 home으로 돌려보내겠다
	if(!loginMemberId.equals(memberId)){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("memberID와 세션로그인ID 불일치 ----------> home.jsp로 리턴");
		return;
	}
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("insertCommentAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("insertCommentAction-->접속성공 "+conn);	
	
	//board 삽입을 위한 sql
	String sql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate,updatedate) VALUES (?,?,?,?,NOW(),NOW())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, memberId);

	//insert가 잘 되었는지 확인
	int row = stmt.executeUpdate(); 
	System.out.println(BG_RED + row + "행이 갱신되었습니다 <--- boardAddAction"+RESET);
	
	if (row>0){
		// home으로 되돌아 간다 redirection
		System.out.println(row+"행이 잘 들어갔으니 홈으로 리턴<---------boardAddAction");
		response.sendRedirect(request.getContextPath()+"/home.jsp");	
		return;
	}else{
		System.out.println("제대로 삽입되지 않았습니다. boardAdd로 리턴 <----------boardAddAction ");
		response.sendRedirect(request.getContextPath()+"/board/boardAdd.jsp");
		return;
	}
	


%>