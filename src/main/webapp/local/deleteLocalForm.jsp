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
	
	
	//세션 유효성 검사   
	if(session.getAttribute("loginMemberId") == null) {
		//로그인 한 상태가 아니라면 login 하라고 msg 보내겠다.
	   response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg=Please login");
	   return;
	}
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- updateLocalForm loginMemberId" + RESET);
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//요청값 유효성 검사
	if(request.getParameter("localName") == null ||
	request.getParameter("localName").equals("")){
		System.out.println(YELLOW +"파라미터검사에서 튕긴다"+RESET);
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
		return;	
	}
	String localName = request.getParameter("localName");
	System.out.println(localName + "<--parm- updateLocalForm newLocal");

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


  <title>update Local</title>
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
          <h1 class="heading text-white mb-3" data-aos="fade-up">local List</h1>
        </div>
      </div>
    </div>
  </div>
  <!---------------------------------------------------------------------------------------------------- 본문 VIEW -->
<section class="section">
	<div class="container">
		<div class="row blog-entries element-animate">
			<div class="post-content-body">
				<!--board에 글이 있을 경우 삭제 불가 메시지를 받을 예정 -->
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
				<div>
				<form action="<%=request.getContextPath()%>/local/deleteLocalAction.jsp" class="sidebar-search-form">
					<table class="table table-bordered ">
						<tr>
							<th style="width : 18%">Local Name</th>
							<th>
								<input type="hidden" class="form-control" name="localName" value="<%=localName %>">
								<%=localName %> 
							</th>
						</tr>
						<tr>
							<td colspan="2">
								<%=loginMemberId%>님. 정말 Local <%=localName %>을 삭제하시겠습니까?
							</td>
						</tr>
					</table>
					<div align="center">
						<button type="submit"  class="btn btn-primary" >삭제</button>
					</div>
				</form>	
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