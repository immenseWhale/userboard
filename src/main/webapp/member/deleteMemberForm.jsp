<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	System.out.println(YELLOW + loginMemberId + " <-- loginMemeberId deleteMemberForm.jsp " +RESET);
	
	String msg = null;
	if (request.getParameter("msg") != null){
		msg = request.getParameter("msg");
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


  <title>Withdrawal &mdash;</title>
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
          <h1 class="heading text-white mb-3">Withdrawal</h1>
        </div>
      </div>
    </div>
  </div>

<!---------------------------------------------------------------------------------------------------- 본문 -->
<section class="section">
  <div class="container">
    <div class="row blog-entries element-animate">
			<h2>회원 탈퇴</h2>
			<p><%=loginMemberId %>님 정말로 탈퇴하시겠습니까?</p>
			<div>
		<%	
				if (request.getParameter("msg") != null){
		%>
					<div style="color: red">
						<h4>&nbsp;&nbsp;<%=request.getParameter("msg") %>&nbsp;</h4>
					</div>
		<%				
				}		
		%>
			</div>
			<form action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp" method="post" id="submit">
				<table class="table table-bordered">
					<tr>
						<td>ID</td>
						<td><input type="hidden" name="memberId" value="<%=loginMemberId%>">
							<%=loginMemberId%>
						</td>
					</tr>
					<tr>
						<td>비밀번호 입력</td>
						<td>
							<input type="password" name="memberPw">
						</td>				
					</tr>
				</table>
				<div align="center">
					<button type="submit" class="btn btn-primary">탈퇴</button>
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