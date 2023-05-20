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

	request.setCharacterEncoding("utf-8");
	
	//select로 loacl테이블의 모든걸 불러와서 뷰에 뿌려준다.
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("localList-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("localList-->접속성공 "+conn);
	
	
	//local을 위한 sql 선언
	//local은 테이블과 모양이 똑같으니 vo를 만들어서 넣어주겠다.
	String localSql = "select local_name localName, createdate, updatedate from local";
	PreparedStatement localStmt = conn.prepareStatement(localSql);
	System.out.println(YELLOW + localStmt + "<--localList stmt localStmt" +RESET);				
	ResultSet localRs = localStmt.executeQuery();	
	ArrayList<Local> localList = new ArrayList<Local>();	//사이즈가 0인 ArrayList 선언
	
	//resultSet 결과물을 AllayList에 넣어준다.
	while(localRs.next()){
		Local local = new Local();
		local.setLocalName(localRs.getString("localName"));
		local.setCreatedate(localRs.getString("createdate"));
		local.setUpdatedate(localRs.getString("updatedate"));
		localList.add(local);
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


  <title>Local List</title>
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
          <h1 class="heading text-white mb-3" >local List</h1>
          <!-- data-aos="fade-up" 속성 적용 안된다----------------------------------------------------------------->
        </div>
      </div>
    </div>
  </div>
  <!---------------------------------------------------------------------------------------------------- 본문 VIEW -->
<section class="section">
	<div class="container">
		<div class="row blog-entries element-animate">
			<div class="post-content-body">
				<!-- 회원만 Local 추가가 가능하기 때문에 msg가 올 수 있다. -->
				<div>
			<%	//mgs 값이 오면
					if (request.getParameter("msg") != null){
			%>
						<div style="color: red">
							<h4><%=request.getParameter("msg") %>.</h4>
						</div>
			<%				
					}		
			%>
				</div>
				
				
				
				<table style="width : 100%">
					<tr>
						<td>							
							<h3 class="heading"> Local</h3>
						</td>
						<td align="right">
							<a href="<%=request.getContextPath()%>/local/insertLocalForm.jsp">Local 추가</a>							
						</td>
					</tr>			
				</table>
				<!-- 입력 수정 삭제 하고 싶은 localName을 받아서   -->
				
				
				<!-- local 테이블의 모든걸 보여준다. -->
				<table class="table table-bordered " style="text-align: center;">
					<tr>
						<th>localName</th>
						<th>createdate</th>
						<th>updatedate</th>
						<th colspan="2">edit</th>
					</tr>
					<% 
					for(Local local : localList){ 
					%>
						<tr>
							<td><%=local.getLocalName()%></td>
							<td><%=local.getCreatedate()%></td>
							<td><%=local.getUpdatedate()%></td>
							<td>
								<form action="<%=request.getContextPath()%>/local/updateLocalForm.jsp">
									<input type="hidden" name="localName" value="<%=local.getLocalName()%>">
									<button type="submit" class="btn btn-primary">수정</button>
								</form>
							</td>
							<td>
								<form action="<%=request.getContextPath()%>/local/deleteLocalForm.jsp">
									<input type="hidden" name="localName" value="<%=local.getLocalName()%>">
									<button type="submit" class="btn btn-primary">삭제</button>
								</form>
							</td>
						</tr>
					<%
					} 
					%>
				</table>
  		<!-- 입력 수정 삭제 폼으로 간다. -->
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