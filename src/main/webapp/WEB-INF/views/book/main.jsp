<%@ page import="java.util.Map, java.util.List" %>
<%@ page language="java"	contentType="text/html;charset=UTF-8"	pageEncoding="UTF-8"%>
<%
    String mainPage = (String)request.getParameter("page");
    int size = 0;//지변이니까 초기화를 생략하면 에러발생함.
    List<Map<String,Object>> bList = (List<Map<String,Object>>)request.getAttribute("bList");
    List<Map<String,Object>> bListDate = (List<Map<String,Object>>)request.getAttribute("bListDate");

//    if(bList !=null){
//        size = bList.size();
//    }
//    for (int i = 0; i < size; i++) {
//        out.print(bList.get(i));
//    }
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
    String user = null;
    String nickname = null;
    if (session.getAttribute("m_id") != null) {
        user = (String)session.getAttribute("m_id");
    }
    if (session.getAttribute("m_nickname") != null) {
        nickname = (String)session.getAttribute("m_nickname");
    }
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
            <!--보안상의 안전을 위해서 GET을 POST로 바꿔야함 -->

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
            <% if("novel".equals(mainPage)){ %>
            <li><a href="/book/main?page=novel">전체보기</a></li>
            <li><a href="/book/main?page=novel&b_genre=인문">인문</a></li>
            <li><a href="/book/main?page=novel&b_genre=스릴러">스릴러</a></li>
            <li><a href="/book/main?page=novel&b_genre=로맨스">로맨스</a></li>
<%--            <li><a href="#">일상</a></li>--%>
<%--            <li><a href="#">학원</a></li>--%>
<%--            <li><a href="#">판타지</a></li>--%>
            <% }else{ %>
            <li><a href="/book/main/">전체보기</a></li>
            <li><a href="/book/main?b_genre=로맨스">로맨스</a></li>
            <li><a href="/book/main?b_genre=드라마">드라마</a></li>
            <li><a href="/book/main?b_genre=일상">일상</a></li>
            <li><a href="/book/main?b_genre=학원">학원</a></li>
            <li><a href="/book/main?b_genre=스릴러">스릴러</a></li>
            <li><a href="/book/main?b_genre=판타지">판타지</a></li>
            <% } %>
        </ul>
    </div>
    <div style="height: 20px"><!--공간주기--></div>
<%-------------------------------------- 월간랭킹 login ----------------------------------%>
<% if (user != null) { %>
    <%@include file="monthlyRank.jsp"%>
    <div style="height: 20px"><!--공간주기--></div>
<% } %>
<%-------------------------------------- 월간랭킹 login 끝----------------------------------%>
<%--자바변수 mainPage에 들어있는 거 : request.getParameter("page")
            /book/main -> 디폴트(null)- 만화목록
            /book/main?page=novel일 때 소설목록 조회 됨--%>
    <%if(mainPage==null){%>
    <div class="row row-container">
        <h4 style="color: #606060; margin-left: 40px">최신 작품</h4>
<%------------------------- 장르버튼 눌렀을 때 조회 결과가 인덱스 4보다 짧아서 터져서 만든 구간--------------------%>
        <%
            if(bListDate.size()<4){
                for (int i = 0; i < bListDate.size(); i++) {
                    Map<String, Object> rmap = bListDate.get(i);
                    %>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem; height: 28rem;">
                <a href="/book/detail?b_no=<%=rmap.get("b_no")%>">
                    <img src=<%=rmap.get("b_thumbnail")%> class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                </a>
                <div class="card-body">
                    <h5 class="card-title"><a href="/book/detail?b_no=<%=rmap.get("b_no")%>"><%=rmap.get("b_title")%></a></h5>
                    <h6 class="card-subtitle"><%=rmap.get("b_author")%></h6>
                    <p class="card-text"><%=rmap.get("b_descript")%></p>
                </div>
            </div>
        </div>
<%------------------------- 장르버튼 눌렀을 때 조회 결과가 인덱스 4보다 짧아서 터져서 만든 구간 끝--------------------%>
              <%
            }}else{
            for (int i = 0; i < 4; i++) {
                Map<String, Object> rmap = bListDate.get(i);
        %><%--스크롤 길어져서 결과값 4개만 보려고 인덱스 상수 4로 고정 함--%>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem; height: 28rem;">
                    <a href="/book/detail?b_no=<%=rmap.get("b_no")%>"><img src=<%=rmap.get("b_thumbnail")%> class="card-img-top" alt="..." style="height: 250px; object-fit: cover;"></a>
                <div class="card-body">
                    <h5 class="card-title"><a href="/book/detail?b_no=<%=rmap.get("b_no")%>"><%=rmap.get("b_title")%></a></h5>
                    <h6 class="card-subtitle"><%=rmap.get("b_author")%></h6>
                    <p class="card-text"><%=rmap.get("b_descript")%></p>
                </div>
            </div>
        </div>
        <%}}%>
    </div>
    <div class="row row-container">
        <h4 style="color: #606060; margin-left: 40px;">전체 작품</h4>
        <% for (int i = 0; i < bList.size(); i++) {
            Map<String,Object> rmap = bList.get(i);
        %>
        <div class="col-md-3 mb-5">
            <div class="card" style="width: 15rem; height: 28rem;">
                <a href="/book/detail?b_no=<%=rmap.get("b_no")%>">
                    <img src=<%=rmap.get("b_thumbnail")%> class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
                </a>
                <div class="card-body">
                    <h5 class="card-title"><a href="/book/detail?b_no=<%=rmap.get("b_no")%>"><%=rmap.get("b_title")%></a></h5>
                    <h6 class="card-subtitle"><%=rmap.get("b_author")%></h6>
                    <p class="card-text"><%=rmap.get("b_descript")%></p>
                </div>
            </div>
        </div>
        <%}%>
        <%}else if("novel".equals(mainPage)){%>
        <%@include file="mainNovel.jsp"%>
        <%}%>
    </div>
</div>
<%@include file="../common/footer.jsp"%>
<script>
    // 페이지가 로드될 때 이전 스크롤 위치로 이동
window.onload = function() {
    if (sessionStorage.getItem('scrollPosition')) {
        window.scrollTo(0, sessionStorage.getItem('scrollPosition'));
    }
}

// 링크 클릭 시 현재 스크롤 위치를 저장
document.querySelectorAll('a').forEach(function(link) {
    link.addEventListener('click', function() {
        sessionStorage.setItem('scrollPosition', window.scrollY);
    });
});

// // 사용자가 페이지를 스크롤할 때마다 스크롤 위치를 저장 (옵션)
// window.onscroll = function() {
//     sessionStorage.setItem('scrollPosition', window.scrollY);
// }
</script>
<script src="/resources/js/scroll.js"></script>

<!-- Bootstrap core JavaScript -->
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>

<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
</body>
</html>