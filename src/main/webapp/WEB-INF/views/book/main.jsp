<%@ page language="java"	contentType="text/html;charset=UTF-8"	pageEncoding="UTF-8"%>
<%
    String user = null;
    String nickname = null;
    String name = null;
    String email = null;
    String admin = null;
    if (session.getAttribute("m_id") != null) {
        user = (String)session.getAttribute("m_id");
    }
    if (session.getAttribute("m_nickname") != null) {
        nickname = (String)session.getAttribute("m_nickname");
    }
    if (session.getAttribute("m_name") != null) {
        name = (String)session.getAttribute("m_name");
    }
    if (session.getAttribute("m_email") != null) {
        email = (String)session.getAttribute("m_email");
    }
    if (session.getAttribute("m_admin") != null) {
        admin = (String)session.getAttribute("m_admin");
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <%@include file="/resources/cdn/common.html"%>
    <%-- 캐러셀에 필요한 부트스트랩 버전   --%>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="/resources/css/main.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <!--위 코드는 html파일에서 외부 css파일을 연결하는 역할을 함
    만약 위의 코드가 없으면 연결이 안되서 css적용이 안됨.
    -->

    <title>BOOKFLIX</title>
</head>
<body>
<%
    if (user != null) { // 로그인 한 경우
%>
    <%@include file="../common/mainHeader.jsp"%>
<%
    } else {
%>
<section class="main-section">
    <%@include file="../common/indexHeader.jsp"%>
</section>

<div class="caption">
    <h1 style="color:#ffffff; font-size: 4em; -webkit-text-stroke: 1px #000000;">See You What's Next Book?!</h1>
    <h2 style="color:#464646;">모바일에서도 편하게 작품들을 관람하세요.</h2>
    <h3 style="color:#464646;">독서할 준비가 되셨나요? 이메일 주소 하나면 충분합니다.</h3>
    <div class="email">
        <form action="/member/signUp" method="GET">
            <input type="email" id="email" name="m_email" placeholder="이메일 주소" style="padding: 10px; width: 300px;">
            <button type="submit" style="display: inline-block; padding: 10px 20px; background-color: #2679ff; color: #ffffff; text-decoration: none; border-radius: 4px; border: none; cursor: pointer;">시작하기</button>
        </form>
    </div>
</div>
<%
    }
%>
<%-------------------------------------- 월간랭킹 logout ----------------------------------%>
<% if (user == null) { %>
    <%@include file="monthlyRank.jsp"%>
    <div style="height: 50px"><!--공간주기--></div>
<% } %>
<%-------------------------------------- 월간랭킹 logout ----------------------------------%>

<%-------------------------------------- 배너 캐러셀 ----------------------------------%>
<div class="container">
<%@include file="mainCarousel.jsp"%>
</div>
<%-------------------------------------- 배너 캐러셀 ----------------------------------%>
<div style="height: 20px"><!--공간주기--></div>
<div class="container">
    <div style="padding-top: 15px;">
        <ul class="a-hover">
            <li><a href="#">전체보기</a></li>
            <li><a href="#">로맨스</a></li>
            <li><a href="#">액션</a></li>
            <li><a href="#">드라마</a></li>
            <li><a href="#">판타지</a></li>
            <li><a href="#">학원</a></li>
            <li><a href="#">무협</a></li>
        </ul>
    </div>
    <div style="height: 20px"><!--공간주기--></div>
<%-------------------------------------- 월간랭킹 login ----------------------------------%>
<% if (user != null) { %>
    <%@include file="monthlyRank.jsp"%>
    <div style="height: 20px"><!--공간주기--></div>
<% } %>
<%-------------------------------------- 월간랭킹 login ----------------------------------%>
    <div class="row row-container">
        <h4 style="color: #606060;">최신 작품</h4>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem;">
                <img src="/resources/img/thumbnail_test1.png" class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                <div class="card-body">
                    <h5 class="card-title">호두</h5>
                    <h6 class="card-subtitle">작가</h6>
                    <p class="card-text">나이 5살, 개껌을 좋아하는 강아지 매우 건방지다.</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem;">
                <img src="/resources/img/thumbnail_test2.jpg" class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                <div class="card-body">
                    <h5 class="card-title">호두</h5>
                    <h6 class="card-subtitle">작가</h6>
                    <p class="card-text">나이 5살, 개껌을 좋아하는 강아지 매우 건방지다.</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem;">
                <img src="/resources/img/thumbnail_test1.png" class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                <div class="card-body">
                    <h5 class="card-title">호두</h5>
                    <h6 class="card-subtitle">작가</h6>
                    <p class="card-text">나이 5살, 개껌을 좋아하는 강아지 매우 건방지다.</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem;">
                <img src="/resources/img/thumbnail_test1.png" class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                <div class="card-body">
                    <h5 class="card-title">호두</h5>
                    <h6 class="card-subtitle">작가</h6>
                    <p class="card-text">나이 5살, 개껌을 좋아하는 강아지 매우 건방지다.</p>
                </div>
            </div>
        </div>
    </div>
    <div class="row row-container">
        <h4 style="color: #606060;">전체 작품</h4>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem;">
                <img src="/resources/img/thumbnail_test1.png" class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                <div class="card-body">
                    <h5 class="card-title">호두</h5>
                    <h6 class="card-subtitle">작가</h6>
                    <p class="card-text">나이 5살, 개껌을 좋아하는 강아지 매우 건방지다.</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem;">
                <img src="/resources/img/thumbnail_test1.png" class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                <div class="card-body">
                    <h5 class="card-title">호두</h5>
                    <h6 class="card-subtitle">작가</h6>
                    <p class="card-text">나이 5살, 개껌을 좋아하는 강아지 매우 건방지다.</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem;">
                <img src="/resources/img/thumbnail_test1.png" class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                <div class="card-body">
                    <h5 class="card-title">호두</h5>
                    <h6 class="card-subtitle">작가</h6>
                    <p class="card-text">나이 5살, 개껌을 좋아하는 강아지 매우 건방지다.</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem;">
                <img src="/resources/img/thumbnail_test1.png" class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                <div class="card-body">
                    <h5 class="card-title">호두</h5>
                    <h6 class="card-subtitle">작가</h6>
                    <p class="card-text">나이 5살, 개껌을 좋아하는 강아지 매우 건방지다.</p>
                </div>
            </div>
        </div>
    </div>
</div>
<a href="/notice/noticeMain">고객센터</a><br>
<a href="/qna/qnaList">QnA게시판</a>


<script src="/resources/js/scroll.js"></script>
<!-- Bootstrap core JavaScript -->
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
</body>
</html>