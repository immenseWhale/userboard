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
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- commentUpdate loginMemberId" + RESET);
	String loginMemberId =(String)session.getAttribute("loginMemberId") ;
	
	//파라미터값 검사
	if(request.getParameter("boardNo") == null ||
		request.getParameter("commentNo") == null ||
		request.getParameter("memberId") == null ||
		request.getParameter("commentContent") == null ||
	request.getParameter("boardNo").equals("")||
	request.getParameter("commentNo").equals("")||
	request.getParameter("memberId").equals("")||
	request.getParameter("commentContent").equals("")){
		System.out.println(YELLOW +"파라미터검사에서 튕긴다 commentUpdate "+RESET);
		response.sendRedirect(request.getContextPath()+"/board/boardone.jsp?boardNo="+request.getParameter("boardNo"));
		return;	
	}
	String boardNo=request.getParameter("boardNo");	
	String commentNo=request.getParameter("commentNo");
	String memberId=request.getParameter("memberId");
	String commentContent =request.getParameter("commentContent");
	System.out.println(GREEN+boardNo + "<--parm-- commentUpdate boardNo " +RESET);
	System.out.println(GREEN+commentNo + "<--parm-- commentUpdate commentNo " +RESET);
	System.out.println(GREEN+memberId + "<--parm-- commentUpdate memberId " +RESET);
	System.out.println(GREEN+commentContent + "<--parm-- commentUpdate commentContent " +RESET);
	
	//세션 아이디와 멤버 아이디가 다르면 리턴
	String msg = null;
	if (!memberId.equals(loginMemberId)) {
	    System.out.println(YELLOW + "작성자와 사용자가 다릅니다" + RESET);
	    msg = "Author and user are different";
	}
	if (msg!=null){
		response.sendRedirect(request.getContextPath()+"/board/boardone.jsp?boardNo="+request.getParameter("boardNo")+"&msg="+msg);
		return;
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


  <title>Comment Modify</title>
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
          <h1 class="heading text-white mb-3">Modify Comment</h1>
        </div>
      </div>
    </div>
  </div>
  <!---------------------------------------------------------------------------------------------------- 본문 VIEW -->
  <!--------------------------------------현재 localName을 보여주며 변경할 값을 받겠다. -->
<section class="section">
	<div class="container">
		<!-- 똑같은 이름으로 수정하려고 하거나 board에 글이 있을 경우 수정 불가 메시지를 받겠다. -->
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
				
		<div class="comment-form-wrap">
			<h3 class="mb-5" align="center">Edit Comment</h3>	
			<form action="<%=request.getContextPath()%>/board/commentUpdateAction.jsp" class="p-5 bg-light" method="post">
				<input type="hidden" name="boardNo" value="<%=boardNo.trim()%>">
				<input type="hidden" name="commentNo" value="<%=commentNo.trim()%>">
				<table style="width : 100%">
					<tr>
						<td style="width : 30%">User Id</td>
						<td>
							<input type="text" class="form-control" name="memberId" readonly="readonly" value="<%=memberId.trim()%>">
						</td>
					</tr>
					<tr>
						<td style="width : 30%">Password</td>
						<td>
							<input type="password" class="form-control" name="password">
						</td>
					</tr>
					<tr>
						<td style="width : 30%">Comment Content</td>
						<td>
							<textarea rows="3" cols="80" name="commentContent"  class="form-control"><%=commentContent.trim()%></textarea>
						</td>
					</tr>
				</table>
				<div align="center">
					<button type="submit"  class="btn btn-primary" >수정</button>
					<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>" class="btn btn-secondary">취소</a>			
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