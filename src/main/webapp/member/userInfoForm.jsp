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
	
	//유효성 검사
	request.setCharacterEncoding("utf-8");	
	
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("home.jsp로 리턴");
		return;
	}	
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	//System.out.println("userInfoForm-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	//System.out.println("userInfoForm-->접속성공 "+conn);
	
	
	//회원정보 불러오는 sql
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT member_id memberId, createdate, updatedate  FROM member WHERE member_id=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, (String)session.getAttribute("loginMemberId"));
//	System.out.println(YELLOW + stmt+ "<--- rs userInfoForm" + RESET);
	
	rs = stmt.executeQuery();
	//Member m을 null로 초기화
	Member m = null;
	if (rs.next()){
		//rs.next가 있는 경우에만 객체를 생성하고 값을 설정
	    m = new Member();
		m.setMemberId(rs.getString("memberId"));
		m.setCreatedate(rs.getString("createdate"));
		m.setUpdatedate(rs.getString("updatedate"));	
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


  <title>User Info &mdash;</title>
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
          <h1 class="heading text-white mb-3" >User Info</h1>
        </div>
      </div>
    </div>
  </div>

<!---------------------------------------------------------------------------------------------------- 본문 -->
<section class="section">
  <div class="container">
    <div class="row blog-entries element-animate">
  		<div>
	<%	//mgs 값이 오면
			if (request.getParameter("msg") != null){
	%>
				<div style="color: red">
					<h4>&nbsp;&nbsp;<%=request.getParameter("msg")%>&nbsp;</h4>
				</div>
	<%				
			}		
	%>
		</div>
		
		<div align="right">
			<a href="deleteMemberForm.jsp" >회원탈퇴</a>
		</div>
		
		<form action="<%=request.getContextPath()%>/member/memberUpdateAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<td>ID</td>
					<td>
						<input type="hidden" name="memberId" value="<%=m.getMemberId()%>">
						<%=m.getMemberId()%>
					</td>
				</tr>
				<tr>
					<td>기존 비밀번호</td>
					<td>
						<input type = "password" name = "memberPw">
					</td>
				</tr>
				<tr>
					<td>새로운 비밀번호</td>
					<td>
						<input type = "password" name = "newPw1">
					</td>
				</tr>
				<tr>
					<td>새로운 비밀번호 확인</td>
					<td>
						<input type = "password" name = "newPw2">
					</td>
				</tr>
				<tr>
					<td>creatdate</td>
					<td><%=m.getCreatedate() %></td>
				</tr>
				<tr>
					<td>updatedate</td>
					<td><%=m.getUpdatedate() %></td>
				</tr>
			</table>		
			<div align="center">
				<button type="submit" class="btn btn-primary">수정</button>
			</div>
		</form>
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