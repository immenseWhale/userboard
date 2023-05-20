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
	request.setCharacterEncoding("UTF-8");

	final String RESET = "\u001B[0m" ;                           
	final String RED = "\u001B[31m";
	final String BG_RED = "\u001B[41m";
	final String GREEN = "\u001B[32m ";
	final String YELLOW = "\u001B[33m";
	
	//세션값 String에 넣기
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- boardAdd loginMemberId" + RESET);
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println( "deleteLocalAction-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("deleteLocalAction-->접속성공 "+conn);
	
	//local 테이블의 local_name 소환
	String ckSql = "SELECT local_name localName FROM local ";
	PreparedStatement ckStmt = conn.prepareStatement(ckSql);
	System.out.println(YELLOW + ckStmt + " <---stmt-- boardAdd ckStmt" + RESET);
	ResultSet ckRs = ckStmt.executeQuery();
	ArrayList<Local> localList = new ArrayList<Local>();

	while(ckRs.next()){
		Local lo = new Local();	
		lo.setLocalName(ckRs.getString("localName"));
		localList.add(lo);
	}
	
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


  <title>Bulletin Board</title>
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
          <h1 class="heading text-white mb-3">Write Board</h1>
        </div>
      </div>
    </div>
  </div>

<!---------------------------------------------------------------------------------------------------- 본문 -->
<section class="section">
	<div class="container">
		<div>
	<%	//mgs 값이 오면
			if (request.getParameter("msg") != null){
	%>
				<div class="mb-5" >
					<h4><%=request.getParameter("msg")%></h4>
				</div>
	<%				
			}		
	%>
		</div>		
		<div class="comment-form-wrap pt-5">	
			<h3 class="mb-5" align="center">Add a board</h3>	
			<form action ="<%=request.getContextPath()%>/board/boardAddAction.jsp" class="p-5 bg-light" method="post">
				<div class="form-group">
					<label for="memberId">ID</label>
					<input type="text" class="form-control" id="memberId" name ="memberId" value="<%= loginMemberId%>" readonly="readonly">
				</div>
				<div class="form-group">
					<label for="localName">local Name</label>
					<select class="form-control" id="localName" name="localName">
						<option value="">Select Local</option>
					<% 
						for (Local local : localList) {
					%>
	           				<option value="<%= local.getLocalName() %>"><%= local.getLocalName() %></option>
					<%
						} 
					%>
					</select>
				</div>
				<div class="form-group">
					<label for="localName">board Title</label>
					<input type="text" class="form-control" id="boardTitle" name="boardTitle">
				</div>
				<div class="form-group">
					<label for="boardContent">board Content</label>
					<textarea rows="5" cols="80" class="form-control" placeholder="Write the board content" onfocus="this.placeholder=''"  onblur="this.placeholder='Write the board content'" id = "boardContent" name="boardContent"></textarea>
				</div>
				<div class="form-group" align="center">
					<input type="submit" value="Post" class="btn btn-primary">
				</div>
			</form>
		</div>
	</div>
</section>


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