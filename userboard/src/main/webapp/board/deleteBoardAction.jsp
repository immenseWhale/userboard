<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%
	
	//세선 유효성 검사가 최우선 --> 요청값 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		System.out.println("세션유효성검사에서 튕긴다<---deleteBoardAction.jsp");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	request.setCharacterEncoding("UTF-8");
	final String RESET = "\u001B[0m" ;                           
	final String RED = "\u001B[31m";
	final String BG_RED = "\u001B[41m";
	final String GREEN = "\u001B[32m ";
	final String YELLOW = "\u001B[33m";
	
	//세션 아이디 String에
	String loginMemberId = (String)session.getAttribute("loginMemberId") ;
	System.out.println(GREEN + loginMemberId + "<-- deleteBoardAction loginMemberId" + RESET);

	
	//파라미터값 검사
	if(request.getParameter("boardNo") == null ||
	request.getParameter("memberId") == null ||
	request.getParameter("boardNo").equals("")||
	request.getParameter("memberId").equals("")){
		System.out.println(YELLOW +"deleteBoardAction 파라미터검사에서 튕긴다"+RESET);
		response.sendRedirect(request.getContextPath()+"/board/boarOne.jsp?boardNo="+request.getParameter("boardNo"));
		return;	
	}
	
	String boardNo = request.getParameter("boardNo");
	String memberId = request.getParameter("memberId");
	System.out.println(GREEN + boardNo + "<--parm-- deleteBoardAction boardNo " +RESET);
	System.out.println(GREEN + memberId + "<--parm-- deleteBoardAction memberId " +RESET);
	
	//memberId와 세션로그인값이 다르면 retrun
	String mainmsg = null;
	if(!loginMemberId.equals(memberId)){
		System.out.println(YELLOW +"두 아이디가 다릅니다 deleteBoardAction"+RESET);
		response.sendRedirect(request.getContextPath()+"/board/boarOne.jsp?boardNo="+request.getParameter("boardNo"));
		mainmsg = "The logged in user and wirter ard different";
	}
	
	//파라미터 검사에서 msg가 들어간다면 boardAdd로 msg를 포함해 돌려보내겠다
	if (mainmsg != null) {
	    response.sendRedirect(request.getContextPath()+"/board/boardAdd.jsp?&mainmsg="+mainmsg);
	    return;    
	}
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("deleteBoardAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("deleteBoardAction-->접속성공 "+conn);	
	
	//삭제 SQL
	
	String delSql = "DELETE FROM board where board_no =? AND member_id =?";
	PreparedStatement delStmt = conn.prepareStatement(delSql);
	delStmt.setString(1, boardNo);
	delStmt.setString(2, memberId);
	System.out.println(YELLOW + delStmt + " <---stmt-- deleteBoardAction delStmt" + RESET);
	//똑바로 들어갔다면 한 행만 갱신됐다고 뜰 것이다.
	int rowsDeleted = delStmt.executeUpdate();
	if (rowsDeleted > 0) {
	    response.sendRedirect(request.getContextPath() + "/home.jsp?msg=delete Successful!");
	    System.out.println(GREEN + " 성공 후 home으로 리턴 deleteBoardAction" + RESET);
	    return;
	} else {
	    System.out.println(YELLOW + "삭제된 row가 없습니다." + RESET);
	}
	
	
%>