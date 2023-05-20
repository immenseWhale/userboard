<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%

	request.setCharacterEncoding("utf-8");	
	//boardNo가 넘어오지 않으면 상세보기를 해줄 수 없으니 home으로 돌려보내주겠다.
	if(request.getParameter("boardNo") == null){
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
	//boardOne에 보여줄 내용 : 게시글 상세보기, 그 밑에 댓글 리스트. 로그인 하면 수정 삭제까지 가능하도록. 여유되면 댓글들 페이징
	
	
	
	//파라미터 값 확인
	//boradNo 파라미터값 확인
	System.out.println(YELLOW + request.getParameter("boardNo")+"<--boardNo--boardOne parm " + RESET);
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//세션 로그인 확인
	String loginMemberId = "guest";
	if(session.getAttribute("loginMemberId") != null) {
		//현재 로그인 사용자의 아이디
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}
	System.out.println(YELLOW + loginMemberId + "<--loginMemberId-- home.jsp");
	
	//댓글창 페이징을 위한 변수 선언
	int oneCurPg = 1;
	if(request.getParameter("oneCurPg")!=null){
		oneCurPg = Integer.parseInt(request.getParameter("oneCurPg"));
		System.out.println(oneCurPg+BG_RED+"<--새롭게 들어간 oneCurPg boardOne"+RESET);
	}
	int rowPerPage = 4;
	int lastPage = 0;
	int totalRow = 0;
	int startRow = (oneCurPg - 1 ) * rowPerPage;
	System.out.println("boardOne startRow --->" + startRow);
	
	
	
	//DB 호출에 필요한 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("boardOne-->드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println("boardOne-->접속성공 "+conn);
	
	
	
	//board 모든 내용을 불러오는 sql 구문
	String oneSQL = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberID,createdate, updatedate  FROM board WHERE board_no=?";
	PreparedStatement oneStmt = conn.prepareStatement(oneSQL);
	oneStmt.setInt(1, boardNo);
	ResultSet oneRs = oneStmt.executeQuery();
	
	//comment sql구문
	String commentSQL = "select comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate from comment where board_no = ? order by createdate DESC limit ?, ?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSQL);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, startRow);
	commentStmt.setInt(3, rowPerPage);
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();

	
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
		oneBoard.setUpdatedate(oneRs.getString("updatedate"));	
	}
	
	
	//댓글창 나타내기. vo Comment로 표현한다.
	while(commentRs.next()){
		Comment m = new Comment();
		m.setBoardNo(commentRs.getInt("boardNo"));
		m.setCommentNo(commentRs.getInt("commentNo"));
		m.setCommentContent(commentRs.getString("commentContent"));
		m.setMemberId(commentRs.getString("memberId"));
		m.setCreatedate(commentRs.getString("createdate"));
		m.setUpdatedate( commentRs.getString("updatedate"));
		commentList.add(m);
	}
	
	
	
	
	//댓글창 페이징을 위한 sql
	String CMPagingSQL = "select count(*) from comment where board_no=? order by createdate DESC";
	PreparedStatement pagingStmt = conn.prepareStatement(CMPagingSQL);
	pagingStmt.setInt(1, boardNo);
	ResultSet pagingRs = pagingStmt.executeQuery();
	if(pagingRs.next()) {
		totalRow = pagingRs.getInt("count(*)");
	}
	System.out.println( totalRow + GREEN+ "<---totalRow boardOne.jsp" +RESET);
	lastPage = totalRow / rowPerPage;
	//rowPerPage가 딱 나뉘어 떨어지지 않으면 그 여분을 보여주기 위해 +1
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	System.out.println( lastPage + GREEN+ "<---lastPage boardOne.jsp" +RESET);
	
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


  <title>board  &mdash;</title>
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
          <h1 class="heading text-white mb-3">board</h1>
        </div>
      </div>
    </div>
  </div>

<!---------------------------------------------------------------------------------------------------- 본문 -->
<section class="section">
	<div class="container">
		<!-- msg 받을 공간 -->
		<div>
	<%	//mgs 값이 오면
			if (request.getParameter("mainmsg") != null){
	%>
				<div class="mb-5" >
					<p class="mb-4"><%=request.getParameter("mainmsg") %></p>
				</div>
	<%				
			}		
	%>
		</div>
		<div class="row blog-entries element-animate">
			<table class="table table-bordered">
				<tr>
					<td style="width : 30%">boardNo</td>
					<td><%=oneBoard.getBoardNo()%></td>
				</tr>
				<tr>
					<td style="width : 30%">localName</td>
					<td><%=oneBoard.getLocalName() %></td>
				</tr>
				<tr>
					<td style="width : 30%">boardTitle</td>
					<td><%=oneBoard.getBoardTitle() %></td>
				</tr>
				<tr>
					<td style="width : 30%">boardContent</td>
					<td><%=oneBoard.getBoardContent() %></td>
				</tr>
				<tr>
					<td style="width : 30%">memberId</td>
					<td><%=oneBoard.getMemberId() %></td>
				</tr>
				<tr>
					<td style="width : 30%">creatdate</td>
					<td><%=oneBoard.getCreatedate() %></td>
				</tr>
				<tr>
					<td style="width : 30%">updatedate</td>
					<td><%=oneBoard.getUpdatedate() %></td>
				</tr>							
			</table>
		<% //memberId가 null이 아니고, board id와 같다면 수정 삭제를 보여주고, 가능하게 하겠다.
			if(loginMemberId != null && loginMemberId.equals(oneBoard.getMemberId())) {
		%>
				<div align="center">
					<div style="display: inline-block;">
						<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=oneBoard.getBoardNo()%>" class="btn btn-primary">
							수정
						</a>
					</div>
					<div style="display: inline-block;">
						<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp" method="post">
							<input type="hidden" name="boardNo" value="<%=oneBoard.getBoardNo()%>">
							<input type="hidden" name="memberId" value="<%=oneBoard.getMemberId()%>">
							<input type="submit" class="btn btn-primary" value="삭제">
						</form>
					</div>
				</div>
		<%
			}
		%>
		</div>
	<!-----------------------------------------------------------------/메인페이지 종료 -------------------------->	
	<!-----------------------------------------------------------------댓글페이지 시작 -------------------------->
	<div class="pt-5 comment-wrap ">
		<h3 class="mb-5 heading">Comments</h3>
			<ul class="comment-list">
				<!-- 댓글 입력 분기 필요 (로그인시) -->
				<%	//만일 로그인 값이 있으면 등록 창을 보여주겠다.
					if(loginMemberId != null &&
					!loginMemberId.equals("guest")) {
				%>
				
				<li class="comment">
					<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
						<!-- 히든으로 안보이게 처리하고 boardNo와 memberId를 보내준다 -->
						<input type="hidden" name="boardNo" value="<%=oneBoard.getBoardNo()%>">
						<input type="hidden" name="memberId" value="<%=loginMemberId%>">		
						<table>
							<tr>
								<td>
									<textarea rows="2" cols="80" class="form-control" placeholder="Leave a comment" onfocus="this.placeholder=''"  onblur="this.placeholder='Leave a comment'" name="commentContent" ></textarea>
								</td>
								<td>
									&nbsp;&nbsp;<button type="submit" class="btn btn-primary">댓글입력</button>
								</td>
							</tr>
						</table>
					</form>
				</li>
			</ul>
				<%
					}
				%>
		<!-- msg 받을 공간 -->
				<div>
			<%	//mgs 값이 오면
					if (request.getParameter("msg") != null){
			%>
						<div style="color: red">
							<p class="mb-4"><%=request.getParameter("msg") %></p>
						</div>
			<%				
					}		
			%>
				</div>
				
		<!-- 댓글 출력 -->
		<div class="pt-5 comment-wrap ">
			<ul class="comment-list">
    		<%
    			for (Comment m : commentList) { 
    		%>
					<li class="comment" >
						<div class="vcard">
							<h4><%= m.getMemberId() %></h4>
						</div>
						<div class="comment-body">          
							<div class="meta">
								작성일 : <%= m.getCreatedate() %> / 수정일 : <%= m.getUpdatedate()%>
							</div>
							<p>
								<%= m.getCommentContent() %>
							</p>
							<div class="comment-buttons">
	 						<% 
	 							if (loginMemberId.equals(m.getMemberId())) { 
	 						%>
									<a href="<%=request.getContextPath()%>/board/commentUpdate.jsp?commentNo=<%=m.getCommentNo()%>&boardNo=<%=m.getBoardNo()%>&memberId=<%=m.getMemberId()%>&commentContent=<%=m.getCommentContent()%>" class="reply rounded">
										 수정 
									</a>
									&nbsp;
									<a href="<%=request.getContextPath()%>/board/commentDelete.jsp?commentNo=<%=m.getCommentNo()%>&boardNo=<%=m.getBoardNo()%>&memberId=<%=m.getMemberId()%>" class="reply rounded">
										 삭제 
									</a>
							<% 
	            				} 
							%>
							</div>
						</div>
					</li>
   		 <%
			} 
    	%>
			</ul>
		</div>
	</div>
	<!------------------/댓글페이지 종료 -------------------------->
	<!-------------------댓글 페이징 시작 -------------------------->
		
		<div class="text" align="center">		
		<%
			if(oneCurPg > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=oneBoard.getBoardNo()%>&oneCurPg=<%=oneCurPg-1%>" class="btn btn-outline-primary py">이전</a>
		<%		
			}
		%>
			<a href="" class="btn btn-outline-primary py">&nbsp;<%=oneCurPg%>&nbsp;</a>
		<%	
			//현재 페이지가 마지막 페이지보다 작고, 총 행의 개수가 한 페이지당 보이는 개수보다 많을 때 다음을 보여주겠다.
			if(oneCurPg < lastPage &&
				totalRow>rowPerPage) {	
		%>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=oneBoard.getBoardNo()%>&oneCurPg=<%=oneCurPg+1%>" class="btn btn-outline-primary py" >다음</a>
		<%
			}
		%>
		</div>	
	</div>
</section>
	<!-----------------------------------------------------------------/댓글 페이징 종료 -------------------------->
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