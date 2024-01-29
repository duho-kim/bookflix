<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.Map, java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOOLFLIX</title>
    <%@include file="/resources/cdn/common.html"%>
    <link rel="stylesheet" href="/resources/css/logIn.css">
    <script src="/resources/js/logIn.js"></script>

    <script>
        window.onload = function() {
            const socialErrorMessage = "${socialErrorMessage}";
            if (socialErrorMessage) {
                alert(socialErrorMessage);
            }
        }
    </script>
</head>
<body>
<div>
<%@ include file="../common/introHeader.jsp" %>
</div>
<section class="container forms">
    <div class="form login">
        <div class="form-content">
            <header>Login</header>
            <form method="post" action="/member/loginCheck">
                <label for="m_email" class="form-label bold">이메일</label>
                <div class="field input-field mt-1">
                    <input type="text" placeholder="이메일을 입력해주세요" class="form-control input"
                           id="m_email" name="m_email">
                </div>
                <label for="m_pw" class="form-label mt-4 bold">비밀번호</label>
                <div class="field input-field mt-1">
                    <input type="password" placeholder="비밀번호를 입력해주세요" class="form-control password"
                           id="m_pw" name="m_pw">
                </div>
                <div id="error-message" >${errorMessageLogin}</div>
                <div class="form-link">
                    <a href="/member/findAccount" class="forgot-pass">비밀번호를 잊으셨나요?</a>
                </div>

                <div class="field button-field">
                    <button type="submit" id="login-btn">로그인</button>
                </div>
            </form>

            <div class="form-link">
                <span>처음 이신가요? <a href="/member/signUp" class="link signup-link">회원가입</a></span>
            </div>
        </div>

        <div class="line"></div>

        <div class="media-options">
            <div class="kakao-login-btn">
                <a href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=8918d4c80ecdff016de9769242b13044&redirect_uri=http://localhost:8000/auth/kakao/callback"
                   class="field kakao" id="kakao-login-btn">
                    <img src="/resources/img/kakao-login3.png" alt="Login with Kakao" class="kakao-img" style="margin-bottom: 42px;"/>
                </a>
            </div>
        </div>

        <div class="media-options">
            <a href="/auth/google/login" class="field google">
                <img src="/resources/img/google-logo.png" alt="Login with google" class="google-img">
                <span>Login with Google</span>
            </a>
        </div>
    </div>
</section>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
</body>
</html>