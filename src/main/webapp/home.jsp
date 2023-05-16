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
	int rowPerPage = 15;	
	//페이징 마지막을 위한 변수 선언
	int totalRow = 0;
	int lastPage = 0;
	
	if(request.getParameter("localName")!=null){
		localName = request.getParameter("localName");
		//System.out.println(GREEN+localName+"<--새롭게 들어간 localName home"+RESET);
	}	
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		//System.out.println(GREEN+currentPage+"<--새롭게 들어간 currentPage home"+RESET);
	}
	//페이징에 필요한 페이지 별 시작 행 startRow
	int startRow = (currentPage - 1 ) * rowPerPage;
	//System.out.println("empListBySerch strtRow --->" + startRow);

	
	

	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	//System.out.println("home-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	//System.out.println("home-->접속성공 "+conn);
	
	
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
		mainSql = "SELECT  board_no boardNo, local_name localName, board_title boardTitle, member_id memberId, createdate createdate FROM board ORDER BY board_no DESC LIMIT ?, ?";
		mainStmt = conn.prepareStatement(mainSql);
		mainStmt.setInt(1, startRow);
		mainStmt.setInt(2, rowPerPage);
		//System.out.println(YELLOW + "localName이 기본값(=전체)이거나 전체를 눌렀습니다." +RESET);		
					
	}else{
		//localName에 파라미터값 넣기-------------------------------------->이 두줄은 위에서 파라미터 값을 받은 후 이미 처리했다
		//localName = request.getParameter("localName");
		//local_name이 해당되는 열의 local_name과 board_title을 보여주겠다.
		mainSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, member_id memberId, createdate createdate FROM board where local_name=? ORDER BY createdate DESC LIMIT ?, ?";
		mainStmt = conn.prepareStatement(mainSql);
		mainStmt.setString(1, localName);
		mainStmt.setInt(2, startRow);
		mainStmt.setInt(3, rowPerPage);
		//System.out.println(YELLOW + localName + "<--home localName값이 있습니다" +RESET);				
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
		m.setMemberId(mainRs.getString("memberId"));
		m.setCreatedate(mainRs.getString("createdate"));
		boardList.add(m);
	}
	
	
	//페이징을 위한 DB 호출과 계산
	String pagingSql = "select count(*) from board";
	PreparedStatement pagingStmt= null;
	
	if(localName.equals("전체")){
		pagingStmt = conn.prepareStatement(pagingSql);
	}else{
		pagingStmt = conn.prepareStatement(pagingSql+" where local_name=? ");
		pagingStmt.setString(1, localName);
	}
	ResultSet pagingRs = pagingStmt.executeQuery();
	if(pagingRs.next()) {
		totalRow = pagingRs.getInt("count(*)");
	}
	//System.out.println( totalRow + BG_RED+ "<---totalRow home.jsp" +RESET);
	lastPage = totalRow / rowPerPage;
	//rowPerPage가 딱 나뉘어 떨어지지 않으면 그 여분을 보여주기 위해 +1
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	//System.out.println( lastPage + BG_RED+ "<---lastPage home.jsp" +RESET);
	
	//페이징을 리스트 형태로 변환하기 위한 변수 선언
 	int pageRange = 4; // 현재 페이지 주변에 보여줄 페이지의 수
 	//Math.max --> 값들 중 가장 큰 값 반환  Math.min --> 값들 중 가장 작은 값 반환
    int startPage = Math.max(1, currentPage - pageRange); // 현재 페이지 주변의 첫 페이지 번호 계산
    int endPage = Math.min(lastPage, currentPage + pageRange); // 현재 페이지 주변의 마지막 페이지 번호 계산
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="author" content="Untree.co">
  <link rel="shortcut icon" href="favicon.png">
  <meta name="description" content="" />
  <meta name="keywords" content="bootstrap, bootstrap5" />
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Work+Sans:wght@400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="fonts/icomoon/style.css">
  <link rel="stylesheet" href="fonts/flaticon/font/flaticon.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
  <link rel="stylesheet" href="css/tiny-slider.css">
  <link rel="stylesheet" href="css/aos.css">
  <link rel="stylesheet" href="css/glightbox.min.css">
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="css/flatpickr.min.css">

  <title>Home</title>
</head>
<body>
  <div class="site-mobile-menu site-navbar-target">
    <div class="site-mobile-menu-header">
      <div class="site-mobile-menu-close">
        <span class="icofont-close js-menu-toggle"></span>
      </div>
    </div>
    <div class="site-mobile-menu-body"></div>
  </div>
<!--------------------------------------- 최상단 메인메뉴 -->
  <nav class="site-nav">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
  </nav>



  <div class="hero overlay inner-page bg-primary py-5">
    <div class="container">
      <div class="row align-items-center justify-content-center text-center pt-5">
        <div class="col-lg-6">
          <h1 class="heading text-white mb-3" >Home</h1>
        </div>
      </div>
    </div>
  </div>

<!---------------------------------------------------------------------------------------------------- 본문 -->
<section class="section">
  <div class="container">
    <div class="row blog-entries element-animate">
  
		<!------------------------------------------------------------ 카테고리 -->
		<div class="col-md-12 col-lg-4 sidebar">
			<div class="sidebar-box">			
				<h3 class="heading">Categories</h3>
				<ul class="categories">
					<% for(HashMap<String, Object> m : subMenuList) { %>
						<li>
							<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
								<%=(String)m.get("localName")%><span>(<%=(Integer)m.get("cnt")%>)</span>
              				</a>
						</li>
					<% } %>
				</ul>
				<br><br>
				<!------- board 글쓰기 Write-->
				<div>
				<%	//만일 로그인 값이 있으면 등록 창을 보여주겠다.
					if(session.getAttribute("loginMemberId") != null) {
				%>
						<a href="<%=request.getContextPath()%>/board/boardAdd.jsp" class="btn btn-sm btn-outline-primary">write</a>
				<%
					}
				%>
				</div>
        </div>
      </div>
      
		<!------------------------------------------ END sidebar-box ----------------->
	      
		<!------------------------------------------ 본문 ------------------------------>
      <div class="col-md-12 col-lg-8 main-content">
      	<!-- msg 받을 공간 -->
		<div>
	<%	//mgs 값이 오면
			if (request.getParameter("msg") != null){
	%>
				<div class="mb-5" >
					<p class="mb-4"><%=request.getParameter("msg") %></p>
				</div>
	<%				
			}		
	%>
	
		<!-- board 테이블 -->
        <div class="post-content-body">
			<h3 class="heading" style="margin: 0;">Board</h3>			
			<table class="table table-bordered ">
	            <tr style="text-align: center;">
	              <th>ID</th>
	              <th>LocalName</th>
	              <th>Title</th>
	              <th>CreateDate</th>
	            </tr>
	            <% for(Board m : boardList) { %>
	            <tr>
	              <td style="text-align: center;"><%=m.getMemberId() %></td>
	              <td style="text-align: center;"><%=m.getLocalName() %></td>
	              <td>
	                <a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=m.getBoardNo()%>">
	                  <%=m.getBoardTitle() %>
	                </a>
	              </td>
	              <td style="text-align: center;"><%=m.getCreatedate() %></td>
	            </tr>
            <% } %>
			</table>			
          
<!------------------------------------------- boardList 페이징 ---------------------------------------->

			<div align="center">		
					<div class="col-md-12">
						<div class="custom-pagination">
						<% 	//페이지가 1이 상이면 이전 페이지 보여주기
							if (startPage > 1) {
						%>
								<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=1%>&localName=<%=localName%>">1</a>
								<span>...</span>
						<%
						      } 
						      
							for (int i = startPage; i <= endPage; i+=1) { 
								if (i == currentPage) {
						%>
									<span class="active"><%=i%></span>
						<%
								} else {
						%>
									<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&localName=<%=localName%>"><%=i%></a>
						<% 
								} 
							} 	
							
						      if (endPage < lastPage) {
						%>
									<span>...</span>
									<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=lastPage%>&localName=<%=localName%>"><%=lastPage%></a>
						<% 
							}
						%>
				    </div>
				  </div>
				</div>
			</div>
        </div>
      </div> 
    </div>
  </div>
</section>
<!-------------------------------------------------------------------------------------------- 본문 종료 ------------------------>
  <footer class="site-footer">
    <div class="container">
      <div class="row">  

      <div class="row mt-5">
        <div class="col-12 text-center">
          <!-- 
              **==========
              NOTE: 
              Please don't remove this copyright link unless you buy the license here https://untree.co/license/  
              **==========
            -->
			<p>
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
            </p>
          </div>
        </div>
      </div> <!-- /.container -->
      </div>
    </footer> <!-- /.site-footer -->


</body>
</html>