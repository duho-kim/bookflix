<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String user = (String) session.getAttribute("m_id");
    String nickname = (String) session.getAttribute("m_nickname");
    String name = (String) session.getAttribute("m_name");
    String email = (String) session.getAttribute("m_email");
    String admin = (String) session.getAttribute("m_admin");
    String phone = null;
    if (session.getAttribute("m_phone") != null){
        phone = (String) session.getAttribute("m_phone");
    } else {
        phone = "정보없음";
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>북플릭스</title>
    <style>
        h3{
            color: #606060;
            margin-bottom: 40px;
        }
        .myInfoSection {
            width: 700px;
        }
        .info-password-input-container {
            display: flex;
            align-items: center;
        }
        .info-input-password {
            padding-left: 5px;
            height: 40px;
            margin-right: 10px;
        }
        .info-forgot-pass {
            font-size: 12px;
            color: gray;
        }
        .info-forgot-pass:hover {
            text-decoration: none;
        }
        .hidden {
            display: none;
        }
        .info-input {
            padding-left: 5px;
            height: 30px;
            width: 150px;
        }
        .info-section-item {
            display: flex;
            border-top: 1px solid #ccc;
        }
        .info-left {
            padding: 15px;
            width: 20%;
            background-color: #def6ff;
            text-align: right;
            font-size: 14px;
            font-weight: bold;
        }
        .info-right {
            width: 80%;
            padding: 15px;
            font-size: 14px;
            font-weight: bold;
            display: flex;
            flex-direction: column;
            justify-content: center;
            color: rgb(73, 73, 73);
        }
        .info-btn-grey {
            border: 1px solid #626262;
            background-color: #898989;
            color: white;
            height: 30px;
            width: 150px;
        }
        .info-btn-grey:hover {
            background-color: #5b5b5b;
        }
        .info-btn-white {
            background-color: white;
            border: 1px solid #b2b2b2;
            color: #b2b2b2;
            height: 30px;
            width: 100px;
        }
        .info-btn-white:hover{
            border: 1px solid #787878;
            color:  #787878;
        }
        .info-right div,
        .info-right input,
        .info-right button {
            margin-bottom: 10px; /* 원하는 마진 값을 설정 */
        }
        .pw-section {
            align-items: flex-start; /* 수직 방향의 시작 부분을 기준으로 정렬 */
            background-color: #e6e6e6;
            padding: 10px;
        }
        .pw-title{
            font-size: 15px;
        }
        .pw-content {
            font-weight: normal;
        }
        .info-input-password::placeholder {
            padding-left: 5px;
            font-size: 14px;
        }
        .valid-feedback,
        .invalid-feedback {
            display: none;
        }
    </style>

</head>
<body>

<div class="password-confirm" id="password-confirm">
    <h3>비밀번호 재확인</h3>
    <p>보안을 위해 비밀번호를 한번 더 입력해 주세요.</p>
    <div class="info-password-input-container">
        <input type="password" class="info-input-password"  id="password" placeholder="비밀번호를 입력해주세요">
        <button class="btn btn-primary" onclick="checkPassword()">확인</button>
    </div>
    <a href="/member/findAccount" class="info-forgot-pass">비밀번호를 잊으셨나요?</a>
</div>
<div class="myInfoSection hidden" id="myInfoSection">
    <h3>내 정보 관리</h3>
    <div class="info-section-container">
        <!-- 이름 섹션 -->
        <div class="info-section-item">
            <div class="info-left">이름</div>
            <div class="info-right"><%= name %></div>
        </div>
        <!-- 이메일 섹션 -->
        <c:choose>
        <c:when test="${empty principal.user.oauth}">
        <div class="info-section-item">
            <div class="info-left">이메일</div>
            <div class="info-right"><%= email %></div>
        </div>
        </c:when>
            <c:otherwise>

                이메일? : ${principal.user.m_email}

            </c:otherwise>
        </c:choose>
        <!-- 닉네임 섹션 -->
        <div class="info-section-item">
            <div class="info-left">닉네임</div>
            <div class="info-right">
                <div id="nickname-display"><%= nickname %></div>
                <input type="text" class="info-input" id="m_nickname" name="m_nickname" placeholder="새 닉네임">
                <button class="info-btn-grey" data-field-type="m_nickname" onclick="updateMember('m_nickname')">닉네임 변경</button>
            </div>
        </div>
        <!-- 비밀번호 변경 섹션 -->
        <div class="info-section-item">
            <div class="info-left">비밀번호 변경</div>
            <div class="info-right">
                <input type="password" placeholder="새 비밀번호" class="info-input" id="m_pw" name="new_pw" >
                <div id="valid-password-message" class="valid-feedback">
                    사용 가능한 비밀번호입니다.
                </div>
                <div id="invalid-feedback-password" class="invalid-feedback">
                    <div id="length-warning">8자리 ~ 20자리 이내로 입력해주세요.</div>
                    <div id="korean-warning">비밀번호에 한글을 사용 할 수 없습니다.</div>
                    <div id="space-warning">비밀번호는 공백 없이 입력해주세요.</div>
                    <div id="mix-warning">영문, 숫자, 특수문자를 혼합하여 입력해주세요.</div>
                </div>
                <input type="password" placeholder="새 비밀번호 확인" class="info-input" id="checkNewPassword" name="check_pw" disabled>
                <div class="valid-feedback">비밀번호가 일치합니다.</div>
                <div class="invalid-feedback">비밀번호가 일치하지 않습니다.</div>
                <button class="info-btn-grey" data-field-type="m_pw" onclick="updatePassword()">비밀번호 변경</button>
                <div class="pw-section">
                    <p class="pw-title">비밀번호 변경 시 유의사항</p>
                    <div class="pw-content">
                        <p>* 8자리 ~ 20자리 이내로 입력해주세요.</p>
                        <p>* 공백 없이 입력해주세요.</p>
                        <p>* 영문/숫자/특수문자를 1개 이상 혼합하여 입력해주세요.</p>
                    </div>
                </div>
            </div>
        </div>
        <!-- 휴대폰 번호 섹션 -->
        <div class="info-section-item">
            <div class="info-left">휴대폰 번호</div>
            <div class="info-right">
                <div id="phone-display"><%= phone %></div>
                <input type="text" class="info-input" id="m_phone" name="m_phone" placeholder="010-1234-5678" maxlength="13">
                <button class="info-btn-grey" data-field-type="m_phone" onclick="updateMember('m_phone')" >휴대폰번호 변경</button>
            </div>
        </div>
        <!-- 회원 탈퇴 섹션 -->
        <div class="info-section-item">
            <div class="info-left"></div>
            <div class="info-right">
                <button class="info-btn-white" onclick="resign()">회원탈퇴</button>
            </div>
        </div>
    </div>

</div>
</body>
</html>
