<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%	
	request.setCharacterEncoding("utf-8");	
	//세션 유효성 검사가 가장 먼저
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("home.jsp로 리턴");
		return;
	}
	//boardNo가 넘어오지 않으면 상세보기를 해줄 수 없으니 home으로 돌려보내주겠다.
	if(request.getParameter("boardNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");	
		System.out.println("home.jsp로 리턴");
		return;	
	}
	
	final String RESET = "\u001B[0m" ;                           
	final String RED = "\u001B[31m";
	final String BG_RED = "\u001B[41m";
	final String GREEN = "\u001B[32m ";
	final String YELLOW = "\u001B[33m";	
	
	//리다이렉트를 위한 메시지 변수 선언
	String msg = null;
	
	//요청 값 확인
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- updateBoardAction loginMemberId");
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	System.out.println(request.getParameter("boardNo")+"<--boardNo--updateBoardAction parm " );
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	System.out.println(request.getParameter("memberPw")+"<--memberPw--updateBoardAction parm " );
	String memberPw = request.getParameter("memberPw");
	
	System.out.println(request.getParameter("localName")+"<--localName--updateBoardAction parm " );
	String localName = request.getParameter("localName");
	
	System.out.println(request.getParameter("boardTitle")+"<--boardTitle--updateBoardAction parm " );
	String boardTitle = request.getParameter("boardTitle");
	
	System.out.println(request.getParameter("boardContent")+"<--boardContent--updateBoardAction parm " + RESET);
	String boardContent = request.getParameter("boardContent");
	
	//공백이거나 null이 넘어오면 확인 메시지를 form에 출력하겠다.
	if(request.getParameter("memberPw")==null ||
	request.getParameter("memberPw").equals("")||
	request.getParameter("localName")==null ||
	request.getParameter("localName").equals("")||
	request.getParameter("boardTitle")==null ||
	request.getParameter("boardTitle").equals("")||
	request.getParameter("boardContent")==null ||
	request.getParameter("boardContent").equals("")){
		msg = "Error! Do not allow spaces";			
	}
	
	//위 if else문 유효성 검사에 뭔가 걸렸다면 msg에 값이 들어가 있을거다. 그렇다면 폼으로보내버리겠다. 
	if(msg != null){
		//잘못 된 경로로 들어온 경우 메시지를 하나 보여주겠다.													
		response.sendRedirect("./updateBoardForm.jsp?boardNo="+request.getParameter("boardNo")+"&msg="+msg);
		return;	//코드진행 종료
	}
		
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("updateBoardAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("updateBoardAction-->접속성공 "+conn);	
	
	//업데이트 쿼리 구해라
	String upBoard = "UPDATE board b join member m ON b.member_id = m.member_id SET b.local_name = ?,b.board_title = ?, b.board_content = ?, b.updatedate = NOW() WHERE b.board_no = ? AND m.member_pw = password(?);";
	PreparedStatement upBoardStmt = conn.prepareStatement(upBoard);
	upBoardStmt.setString(1, localName);
	upBoardStmt.setString(2, boardTitle);
	upBoardStmt.setString(3, boardContent);
	upBoardStmt.setInt(4, boardNo);
	upBoardStmt.setString(5, memberPw);
	
	//만약 바뀐 행이 하나도 없다면 수정된게 아니다. 비밀번호가 틀렸을거다.
	int row = upBoardStmt.executeUpdate();
	System.out.println("upBoardStmt-updateBoardAction.jsp-->" + row);
	
	if(row == 0){//비밀번호가 틀려서 삭제 못했을 거다 -> 삭제 행이 0행이다.
		//실패하면 다시 폼
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?boardNo="+boardNo+"&msg=Incorrect boardPw");
		System.out.println("수정불가");		
	}else if(row==1){//성공했으니 확인 페이지로 간다. 몇번째 페이지인지 필요하니까 boardNo 붙여준다.
		response.sendRedirect(request.getContextPath() +"/board/boardOne.jsp?boardNo="+boardNo);
		System.out.println("수정성공");
	}else{
		//update문 실행을 취소(rollback)해야한다. 아직 배우지 않았다.
		System.out.println("error row 값 " + row +"다");
	}
	
%>