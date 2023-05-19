<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
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
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- commentUpdateAction loginMemberId" + RESET);
	String loginMemberId =(String)session.getAttribute("loginMemberId") ;

	//파라미터값 검사
	
	String boardNo =request.getParameter("boardNo");	
	int commentNo =Integer.parseInt(request.getParameter("commentNo"));
	String memberId =request.getParameter("memberId");
	String password =request.getParameter("password");
	String commentContent =request.getParameter("commentContent");
	System.out.println(GREEN + boardNo + "<--parm-- commentUpdateAction boardNo " +RESET);
	System.out.println(GREEN + commentNo + "<--parm-- commentUpdateAction commentNo " +RESET);
	System.out.println(GREEN + memberId + "<--parm-- commentUpdateAction memberId " +RESET);
	System.out.println(GREEN + password + "<--parm-- commentUpdateAction password " +RESET);
	System.out.println(GREEN + commentContent + "<--parm-- commentUpdateAction commentContent " +RESET);
	
	if(request.getParameter("boardNo") == null ||
		request.getParameter("commentNo") == null ||
		request.getParameter("memberId") == null ||
		request.getParameter("password") == null ||
		request.getParameter("commentContent") == null ||
	request.getParameter("boardNo").equals("")||
	request.getParameter("commentNo").equals("")||
	request.getParameter("memberId").equals("")||
	request.getParameter("password").equals("")||
	request.getParameter("commentContent").equals("")){
		System.out.println(YELLOW +"파라미터검사에서 튕긴다 commentUpdateAction "+RESET);
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+request.getParameter("boardNo"));
		return;	
	}
	

	
	//세션 아이디와 멤버 아이디가 다르면 리턴
	String msg = null;
	if (!memberId.equals(loginMemberId)) {
	    System.out.println(YELLOW + "작성자와 사용자가 다릅니다" + RESET);
	    msg = "The logged in user and wirter ard different";
	}
	if (msg!=null){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	}
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("commentUpdateAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("commentUpdateAction-->접속성공 "+conn);	
	
	//업데이트 쿼리 구해라
	String upComment = "UPDATE comment c JOIN member m ON c.member_id = m.member_id SET c.comment_content = ?, c.updatedate = NOW() WHERE c.comment_no = ? AND m.member_pw = PASSWORD(?);";
	PreparedStatement upComStmt = conn.prepareStatement(upComment);
	upComStmt.setString(1, commentContent);
	upComStmt.setInt(2, commentNo);
	upComStmt.setString(3, password);
	System.out.println(BG_RED + upComStmt + "<----upComStmt-commentUpdateAction.jsp" +RESET);

	//만약 바뀐 행이 하나도 없다면 수정된게 아니다. 비밀번호가 틀렸을거다.
	int row = upComStmt.executeUpdate();
	System.out.println("commentUpdateAction.jsp-->" + row + "행 갱신됐습니다.");
	
	if(row == 0){//비밀번호가 틀려서 삭제 못했을 거다 -> 삭제 행이 0행이다.
		//실패하면 다시 폼
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo+"&msg=Incorrect PW");
		System.out.println("수정불가");		
	}else if(row==1){//성공했으니 확인 페이지로 간다. 몇번째 페이지인지 필요하니까 boardNo 붙여준다.
		response.sendRedirect(request.getContextPath() +"/board/boardOne.jsp?boardNo="+boardNo);
		System.out.println("수정성공");
		return;
	}
	
	
%>