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
	
	//파라미터 값 확인
	request.setCharacterEncoding("utf-8");	
	//System.out.println(BG_RED + request.getParameter("localName")+"<--home parm localName" + RESET);
	
	//localName에 전체를 초기값으로 주고 localName이 널이 아닌 경우 값을 바꿔줘서 분기문을 간단하게 하겠다
	String localName = "전체";
	// currntPage는 페이징을 위한 현재 페이지 넘버
	int currentPage = 1;
	//rowPerPage 는 한 페이지당 보여주고 싶은 행의 수
	int rowPerPage = 10;	
	//페이징 마지막을 위한 변수 선언
	int totalRow = 0;
	int lastPage = 0;
	
	if(request.getParameter("localName")!=null){
		localName = request.getParameter("localName");
		System.out.println(GREEN+localName+"<--새롭게 들어간 localName home"+RESET);
	}	
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		System.out.println(GREEN+currentPage+"<--새롭게 들어간 currentPage home"+RESET);
	}
	//페이징에 필요한 페이지 별 시작 행 startRow
	int startRow = (currentPage - 1 ) * rowPerPage;
	System.out.println("empListBySerch strtRow --->" + startRow);

	
	

	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("home-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("home-->접속성공 "+conn);
	
	
	//submenuSql 쿼리를 위한 변수 선언
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name ";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	
	//mainSql쿼리를 위한 변수 선언
	String mainSql = null;
	PreparedStatement mainStmt = null;
	ResultSet mainRs = null;	
	ArrayList<Board> boardList = new ArrayList<Board>();	//사이즈가 0인 ArrayList 선언
	
	//localName 파라미터값을 이용해 동적 쿼리 분기 나누기
	//만약 localName값이 null이거나 공백이라면 (null을 우선 검사해야 null일 경우 에러나지 않는다.) + 전체일 경우
	/*
	if(request.getParameter("localName")==null ||
		request.getParameter("localName").equals("") ||
		request.getParameter("localName").equals("전체"))
	*/
	//위에서 localName에 이미 request.getParameter("localName")를 변수 localName에 넣어줬기 때문에 위 if문을 짧게 표기한다.
	if(localName.equals("전체")){
		//where절(동적쿼리:?)가 없는 sql문 출력
		mainSql = "SELECT  board_no boardNo, local_name localName, board_title boardTitle, createdate createdate FROM board ORDER BY board_no DESC LIMIT ?, ?";
		mainStmt = conn.prepareStatement(mainSql);
		mainStmt.setInt(1, startRow);
		mainStmt.setInt(2, rowPerPage);
		System.out.println(YELLOW + "localName이 기본값(=전체)이거나 전체를 눌렀습니다." +RESET);		
					
	}else{
		//localName에 파라미터값 넣기-------------------------------------->이 두줄은 위에서 파라미터 값을 받은 후 이미 처리했다
		//localName = request.getParameter("localName");
		//local_name이 해당되는 열의 local_name과 board_title을 보여주겠다.
		mainSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate createdate FROM board where local_name=? ORDER BY createdate DESC LIMIT ?, ?";
		mainStmt = conn.prepareStatement(mainSql);
		mainStmt.setString(1, localName);
		mainStmt.setInt(2, startRow);
		mainStmt.setInt(3, rowPerPage);
		System.out.println(YELLOW + localName + "<--home localName값이 있습니다" +RESET);				
	}
	mainRs = mainStmt.executeQuery();
	
	//서브메뉴에 해시맵으로 값 넣기
	while(subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	//메인메뉴 ArrayList vo로 값 넣기
	while(mainRs.next()){
		Board m = new Board();
		m.setBoardNo(mainRs.getInt("boardNo"));
		m.setLocalName(mainRs.getString("localName"));
		m.setBoardTitle(mainRs.getString("boardTitle"));
		m.setCreatedate(mainRs.getString("createdate"));
		boardList.add(m);
	}
	
	
	//페이징을 위한 DB 호출과 계산
	PreparedStatement pagingStmt = conn.prepareStatement("select count(*) from board");
	ResultSet pagingRs = pagingStmt.executeQuery();
	if(pagingRs.next()) {
		totalRow = pagingRs.getInt("count(*)");
	}
	System.out.println( totalRow + BG_RED+ "<---totalRow home.jsp" +RESET);
	lastPage = totalRow / rowPerPage;
	//rowPerPage가 딱 나뉘어 떨어지지 않으면 그 여분을 보여주기 위해 +1
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	System.out.println( lastPage + BG_RED+ "<---lastPage home.jsp" +RESET);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a{
		/* 링크의 라인 없애기  */
		text-decoration: none;
	}
	a:link { 	/* 방문한 적 없는 글자색  */
		color:#4C4C4C; 
	}
	a:visited { /* 방문한 글자색  */
		color:#747474;
	}
</style>
</head>
<body>
<%	
	
		// request.getRequestDispatcher("/inc/mainmenu.jsp").include(request, response);
		// 이코드 액션태그로 변경하면 아래와 같다
%>	
	<!-- 매 페이지마다 있는 내용(ex:카피라이트)한 번에 나타내기 : include 페이지 -->
	<!-- 폴더를 실제 DB테이블과 같이 나눠놨기 때문에 상대주소를 쓰지 않고 다음과 같이 절대 주소를 쓴다. -->
	
	<!-----------------------------------------------------------------메인메뉴 시작 -------------------------->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<!-----------------------------------------------------------------메인메뉴 종료 -------------------------->	
	<!----------------------------------------------- 서버 메뉴(세로)  boardList모델을 출력------------------------>
	<div>
		<ul>
		<%
			for(HashMap<String, Object> m : subMenuList) {
		%>
			<li>
				<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
					<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
				</a>
			</li>
		<%		
			}
		%>
		</ul>
	</div>
	<!----------------------------------------------- 서버 메뉴(세로)  종료-------------------------------------->
		
	
	<div>
		<!-- home 내용 : 로그인폼 / 카테고리별 게시글 5개씩 로그인 안해도 읽기O 작성X->	
		<!-- 로그인 폼 -->
		<%
			if(session.getAttribute("loginMemberId") == null) { // 로그인전이면 로그인폼출력
		%>
				<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
					<table>
						<tr>
							<td>아이디</td>
							<td><input type="text" name="memberId"></td>
						</tr>
						<tr>
							<td>패스워드</td>
							<td><input type="password" name="memberPw"></td>
						</tr>
					</table>
					<button type="submit">로그인</button>
				</form>
		<%	
			}
		%>		
	</div>
	
	
	<!------------------------------------------------------  메인 페이지 시작 boardList ----------------------------------->
	<div>
			<table class="table table-bordered ">
				<tr>
					<th>No</th>
					<th>LocalName</th>
					<th>Title</th>
					<th>CreateDate</th>
				</tr>		
		<%
				for(Board m : boardList) {
		%>
					<tr>
						<td><%=m.getBoardNo() %></td>
						<td><%=m.getLocalName() %></td>
						<td>
							<a href = "<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=m.getBoardNo()%>">
								<%=m.getBoardTitle() %>
							</a>
						</td>
						<td><%=m.getCreatedate() %></td>
					</tr>
		<%
				}
		%>
			</table>
	</div>
	<!-- boardList 페이징 -->
	<div align="center">		
	<%
		if(currentPage > 1) {
	%>
			<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage-1%>&localName=<%=localName%>">이전</a>
	<%		
		}
	%>
		<%=currentPage%>
	<%	
		if(currentPage < lastPage) {	
	%>
			<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage+1%>&localName=<%=localName%>">다음</a>
	<%
		}
	%>
	</div>
	
	<!----------------------------------------------------------메인 페이지 끝  boardList ---------------------------------->

	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>