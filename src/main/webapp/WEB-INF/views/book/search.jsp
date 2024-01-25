<%@ page language="java"	contentType="text/html;charset=UTF-8"	pageEncoding="UTF-8"%>
<%
    String user = (String)session.getAttribute("m_id");
    String nickname = (String)session.getAttribute("m_nickname");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@include file="/resources/cdn/common.html"%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
    <link rel="stylesheet" href="/resources/css/bookSearch.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <title>검색 페이지</title>
</head>
<body>
<%@include file="../common/mainHeader.jsp"%>
<!-- 저자 검색결과 목록 추가 -->
<div class="container">
    <h5 class="mb-3">저자 검색결과</h5>
    <ul class="author-list">
        <li><img src="/resources/img/icon_autorList.png">저자1</li>
        <li><img src="/resources/img/icon_autorList.png">저자2</li>
        <!-- ... 기타 저자 데이터 추가 ... -->
    </ul>


    <hr class="mb-4">

    <div class="container">
        <h5 class="mb-4">검색결과</h5>

        <div class="genre-container">
            <button class="scroll-btn" onclick="scrollGenre('left')">&#10094;</button>
            <div class="genre-wrapper">
                <a href="#" class="btn btn-primary">전체</a>
                <a href="#" class="btn btn-secondary">인문</a>
                <a href="#" class="btn btn-secondary">추리/미스터리/스릴러</a>
                <a href="#" class="btn btn-secondary">에세이</a>
                <a href="#" class="btn btn-secondary">청소년</a>
                <a href="#" class="btn btn-secondary">현대 판타지</a>
                <a href="#" class="btn btn-secondary">현대물</a>
                <a href="#" class="btn btn-secondary">서양풍 로판</a>
                <a href="#" class="btn btn-secondary">기독교(개신교)</a>
                <a href="#" class="btn btn-secondary">일반영어</a>
                <a href="#" class="btn btn-secondary">영미소설</a>
                <a href="#" class="btn btn-secondary">해외 순정</a>
                <a href="#" class="btn btn-secondary">드라마</a>
                <a href="#" class="btn btn-secondary">로판</a>
                <a href="#" class="btn btn-secondary">해외 만화</a>
                <a href="#" class="btn btn-secondary">육아/자녀교육</a>
                <a href="#" class="btn btn-secondary">종교일반</a>
                <a href="#" class="btn btn-secondary">해외여행</a>
            </div>
            <button class="scroll-btn" onclick="scrollGenre('right')">&#10095;</button>
        </div>

        <select class="form-select mb-4" style="width:auto; font-size: small; margin-left: 20px;">
            <option selected>정렬 방식 선택</option>
            <option value="1">정확도순</option>
            <option value="2">최신순</option>
            <option value="3">별점순</option>
            <option value="4">리뷰 많은 순</option>
            <option value="5">가격 낮은 순</option>
        </select>

        <!-- 책 목록 예시 -->
        <div id="bookList">
            <div class="book-item">
                <img src="/resources/img/thumbnail_test1.png" alt="책 이미지">
                <div>
                    <strong>책제목</strong>
                </div>
            </div>
            <hr>
        </div>
    </div>
</div>

<!-- <script>
    const books = [
        { title: "책 제목1", description: "책 설명1", price: 15000, reviews: 50, rating: 4 },
        { title: "책 제목2", description: "책 설명2", price: 10000, reviews: 30, rating: 4.5 },
        // ... 기타 책 데이터 추가
    ];

    const bookListContainer = document.getElementById('bookList');

    books.forEach(book => {
        const bookElement = `
                <div class="book-item">
                    <img src="book-image-url.jpg" alt="책 이미지">
                    <div>
                        <strong>${book.title}</strong><br>
                        ${book.description}
                    </div>
                </div>
                <hr>
            `;

        bookListContainer.innerHTML += bookElement;
    });

    function scrollGenre(direction) {
        const container = document.querySelector('.genre-wrapper');
        let scrollAmount = 0;
        const slideTimer = setInterval(function() {
            if (direction == 'left') {
                container.scrollLeft -= 10;
            } else {
                container.scrollLeft += 10;
            }
            scrollAmount += 10;
            if (scrollAmount >= 100) {
                window.clearInterval(slideTimer);
            }
        }, 25);
    }
</script> -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>