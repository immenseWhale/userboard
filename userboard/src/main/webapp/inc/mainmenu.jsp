<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="author" content="Untree.co">
	<link rel="shortcut icon" href="favicon.png">
	
	<meta name="description" content="" />
	<meta name="keywords" content="bootstrap, bootstrap5" />
	
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Work+Sans:wght@400;600;700&display=swap" rel="stylesheet">
	
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/fonts/icomoon/style.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/fonts/flaticon/font/flaticon.css">
	
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
	
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/tiny-slider.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/aos.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/glightbox.min.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/style.css">
	
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/flatpickr.min.css">
	
	
	<title>testHome &mdash; </title>
</head>
<body>
  <div class="container">
    <div class="menu-bg-wrap">
      <div class="site-navigation">
        <div class="row g-0 align-items-center">
          <div class="col-1">
            <a href="<%=request.getContextPath()%>/home.jsp" class="logo m-0 float-start">userboard<span class="text-primary">.</span></a>
          </div>
          <div class="col-4 text-center">
            <ul class="js-clone-nav d-none d-lg-inline-block text-start site-menu mx-auto">
              <li>
                <a href="<%=request.getContextPath()%>/home.jsp">Home</a>
              </li>
              <li>
                <a href="<%=request.getContextPath()%>/local/localList.jsp">Local</a>
              </li>               
              <!-- 
                로그인전 : 회원가입
                로그인후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemberId 
              -->   
              <%
                if(session.getAttribute("loginMemberId") == null) { // 로그인전
              %>
                    <li><a href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">join</a></li>
              <%  
                }
              %>
             </ul>
          </div>
          <div class="col-6 text-center">
          <!------------------------------------------------------ 로그인 페이지 -->
         	 <ul class="js-clone-nav d-none d-lg-inline-block text-start site-menu mx-auto">
              <%
                if(session.getAttribute("loginMemberId") == null) { // 로그인전이면 로그인폼출력
              %>
                    <form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post"  >
                      <table style="width: 580px">
                        <tr>
                          <td>ID &nbsp;</td>
                          <td><input type="text" name="memberId">&nbsp;</td>
                          <td class="text-start">Password&nbsp;</td>
                          <td class="text-start"><input type="password" name="memberPw"></td>
                          <td>
							<button type="submit" style="width: 70px;" class="btn-outline-primary">login</button>
                          </td>
                        </tr>
                      </table>              
                    </form>
              <%  
                } else { //로그인후
              %>			
	                    <li><a href="<%=request.getContextPath()%>/member/userInfoForm.jsp"><%=session.getAttribute("loginMemberId") %>님</a></li>
	                    <li><a href="<%=request.getContextPath()%>/member/logoutAction.jsp">logout</a></li>
              <%    
                }
              %> 
              </ul> 
          </div>
        </div>
      </div>
    </div>
  </div>
</body>