<%@ page language="java"	contentType="text/html;charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOOKFLIX</title>
    <%@include file="/resources/cdn/common.html"%>
    <link rel="stylesheet" type="text/css" href="/resources/css/signUpSuccess.css">
</head>
<body>
<div class="outer-container py-4">
    <div class="container py-4">
        <div class="container-header">
            <a href="/book/main">
                <img src="/resources/img/headerLogo.png" alt="Logo" class="logo">
            </a>
        </div>
        <div class="container-body">
            <div class="content">
                <h1 class="title">회원가입 성공!</h1>
                <p class="description">환영합니다 <span class="user-name">${m_name}</span>님!<br><br> 회원가입이 성공적으로 완료되었습니다.</p>
            </div>
        </div>
        <div class="footer">
            <a href="/book/main" class="common-btn main-btn">메인화면</a>
            <a href="/member/login" class="common-btn login-btn">로그인</a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
</body>
</html>