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
	
	
	//요청 값 확인
	System.out.println(YELLOW + session.getAttribute("loginMemberId") + "<-- updateBoardForm loginMemberId" + RESET);
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	System.out.println(request.getParameter("boardNo")+"<--boardNo--updateBoardForm parm " + RESET);
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("updateBoardForm-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("updateBoardForm-->접속성공 "+conn);	
	
	//board 모든 내용을 불러오는 sql 구문
	String oneSQL = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberID,createdate, updatedate  FROM board WHERE board_no=?";
	PreparedStatement oneStmt = conn.prepareStatement(oneSQL);
	oneStmt.setInt(1, boardNo);
	ResultSet oneRs = oneStmt.executeQuery();
	
	//어차피 한개의 결과만 나오기 때문에 배열이 아닌 단일 값으로 가져오겠다.
	Board oneBoard = new Board();
	if (oneRs.next()){
		oneBoard = new Board();	
		oneBoard.setBoardNo(oneRs.getInt("boardNo"));
		oneBoard.setLocalName(oneRs.getString("localName"));
		oneBoard.setBoardTitle( oneRs.getString("boardTitle"));
		oneBoard.setBoardContent(oneRs.getString("boardContent"));
		oneBoard.setMemberId(oneRs.getString("memberId"));		
		oneBoard.setCreatedate(oneRs.getString("createdate"));
		oneBoard.setUpdatedate(oneRs.getString("updatedate"));		}


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

  <title>Home &mdash;</title>
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
		<h4><%=oneBoard.getMemberId() %>님 게시글을 수정하시겠습니까?</h4>
			<div>
		<%	//mgs 값이 오면
				if (request.getParameter("msg") != null){
		%>
					<div style="color: red">
						<h4>&nbsp;&nbsp;<%=request.getParameter("msg") %>.</h4>
					</div>
		<%				
				}		
		%>
			</div>
	
			<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" method="post">		
				<table class="table table-bordered">
					<tr>
						<td>boardNo</td>
						<td>
							<input type="hidden" name="boardNo" value="<%=oneBoard.getBoardNo()%>">
							<%=oneBoard.getBoardNo() %>
						</td>
					</tr>
					<tr>
						<td>localName</td>
						<td>
							<input type="text" name="localName" value="<%=oneBoard.getLocalName() %>">
						</td>
					</tr>
					<tr>
						<td>boardTitle</td>
						<td>
							<input type="text" name="boardTitle" value="<%=oneBoard.getBoardTitle() %>">
						</td>
					</tr>
					<tr>
						<td>boardContent</td>
						<td>
							<textarea rows="3" cols="80" name="boardContent">
								<%=oneBoard.getBoardContent() %>
							</textarea>
						</td>
					</tr>
					<tr>
						<td>memberId</td>
						<td><%=oneBoard.getMemberId() %></td>
					</tr>
					<tr>
						<td>creatdate</td>
						<td><%=oneBoard.getCreatedate() %></td>
					</tr>
					<tr>
						<td>updatedate</td>
						<td><%=oneBoard.getUpdatedate() %></td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><!-- 이 비밀번호는 멤버 테이블의 비밀번호다.  -->
							<input type="password" name="memberPw">
						</td>
					</tr>
				</table>
				<div align="center">
					<button type="submit" class="btn btn-primary">수정 확인</button>
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