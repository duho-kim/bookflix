<%@ page language="java"	contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<% String errorMessage = (String) session.getAttribute("errorMessage"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOOKFLIX</title>
    <%@include file="/resources/cdn/common.html"%>
    <link rel="stylesheet" href="/resources/css/findAccount.css">
</head>
<body>
<%@ include file="../common/introHeader.jsp" %>
<div class="container full-height d-flex justify-content-center align-items-center">
    <div class="card my-card">
        <cardHeader>Find Account</cardHeader>
        <ul class="nav nav-pills nav-fill mb-3" id="accountTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <a class="nav-link active" id="email-tab" data-bs-toggle="pill" href="#email" role="tab" aria-controls="email" aria-selected="true">이메일 찾기</a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" id="reset-password-tab" data-bs-toggle="pill" href="#reset-password" role="tab" aria-controls="reset-password" aria-selected="false">비밀번호 초기화</a>
            </li>
        </ul>
        <div class="card-body">
            <div class="tab-content" id="accountTabsContent">
                <!-- 이메일 찾기 탭 -->
                <% if (request.getAttribute("m_email") != null) { %>
                <div class="tab-pane fade show active" id="email-result" role="tabpanel" aria-labelledby="email-result-tab">
                    <div class="form-group">
                        <label for="result-email" class="form-label mt-4 bold">회원님의 이메일</label>
                        <div id="result-email" class="result-email">${m_email}</div>
                    </div>
                    <a href="/member/login" class="btn btn-outline-dark mt-5" id="login-btn2">로그인</a>
                </div>
                <% } else { %>
                <div class="tab-pane fade show active" id="email" role="tabpanel" aria-labelledby="email-tab">
                    <form method="post" action="/member/findEmail">
                    <div class="form-group">
                        <label for="name" class="form-label mt-4 bold">이름</label>
                        <input type="text" class="form-control" id="name" name="m_name" placeholder="이름을 입력하세요">
                    </div>
                    <div class="form-group">
                        <label for="nickname" class="form-label mt-4 bold">닉네임</label>
                        <input type="text" class="form-control" id="nickname" name="m_nickname" placeholder="닉네임을 입력하세요">
                    </div>
                    <div class="form-group">
                        <label for="birthdate" class="form-label mt-4 bold">생년월일</label>
                        <input type="date" class="form-control" id="birthdate" name="m_birth">
                    </div>
                        <div class="button-group">
                            <button type="submit" class="btn btn-primary mt-5" id="email-btn">찾기</button>
                            <div class="login-button-container">
                                <a href="/member/login" class="btn btn-outline-dark mt-5" id="login-btn">로그인</a>
                            </div>
                        </div>
                    </form>
                </div>
                <% } %>
                <!-- 비밀번호 초기화 탭 -->
                <div class="tab-pane fade" id="reset-password" role="tabpanel" aria-labelledby="reset-password-tab">
                    <form method="post" action="/member/sendEmail">
                    <div class="form-group">
                        <label for="reset-email" class="form-label mt-4 bold">이메일</label>
                        <input type="email" class="form-control" id="reset-email" name="m_email" placeholder="이메일을 입력하세요" value="${m_email}">
                    </div>
                    <div class="form-group">
                        <label for="reset-nickname" class="form-label mt-4 bold">닉네임</label>
                        <input type="text" class="form-control" id="reset-nickname" name="m_nickname" placeholder="닉네임을 입력하세요">
                    </div>
                    <div class="form-group">
                        <label for="reset-birthdate" class="form-label mt-4 bold">생년월일</label>
                        <input type="date" class="form-control" id="reset-birthdate" name="m_birth">
                    </div>
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary mt-5" id="password-btn">메일전송</button>
                        <div class="login-button-container">
                            <a href="/member/login" class="btn btn-outline-dark mt-5" id="login-btn3">로그인</a>
                        </div>
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<% String successMessage = (String) session.getAttribute("successMessage"); %>
<script>
    window.onload = function() {
        const serverSuccessMessage = "<%= successMessage != null ? successMessage : "" %>";
        if (serverSuccessMessage) {
            alert(serverSuccessMessage);
            location.href="login";
        }
        <% session.removeAttribute("successMessage"); %>

        const serverErrorMessage = "<%= errorMessage != null ? errorMessage : "" %>";
        if (serverErrorMessage) {
            alert(serverErrorMessage);
        }
        <% session.removeAttribute("errorMessage"); %>
    };
</script>
<script src="/resources/js/findAccount.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
</body>
</html>