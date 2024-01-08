<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map, java.util.List" %>
<%
    Map<String, Object> data = (Map<String, Object>) request.getAttribute("data");
    List<Map<String, Object>> likeList = (List<Map<String, Object>>) data.get("likeList");
    List<Map<String, Object>> qList = (List<Map<String, Object>>) data.get("qList");
    int likeListSize = likeList.size();
    int qListSize = qList.size();
%>
<div class="mypage-container">
    <div class="left-section">
        <div class="user-info">
            <h3><%= nickname %> ></h3>
            <p class="user-email"><%= email%></p>
        </div>
    </div>
    <div class="right-section">
        <div class="icons-container">
            <a href="#" class="link">
                <div class="icon-box">
                    <i class="fas fa-book icon"></i>
                    <p class="title">내 서재</p>
                    <p class="count">XX권</p>
                </div>
            </a>
            <a href="#" class="link">
                <div class="icon-box">
                    <i class="fas fa-shopping-cart icon"></i>
                    <p class="title">카트</p>
                    <p class="count">XX권</p>
                </div>
            </a>
            <a href="#" class="link">
                <div class="icon-box">
                    <i class="fa-regular fa-heart icon"></i>
                    <p class="title">좋아요</p>
                    <p class="count"><%= likeListSize %>권</p>
                </div>
            </a>
        </div>
        <div class="icons-container">
            <a href="#" class="link">
                <div class="icon-box">
                    <i class="fas fa-receipt icon"></i>
                    <p class="title">결제내역</p>
                    <p class="count">XX건</p>
                </div>
            </a>
            <a href="#" class="link">
                <div class="icon-box">
                    <i class="fas fa-comments icon"></i>
                    <p class="title">리뷰관리</p>
                    <p class="count">XX건</p>
                </div>
            </a>
            <a href="#" class="link">
                <div class="icon-box">
                    <i class="fas fa-comment-dots icon"></i>
                    <p class="title">1:1문의</p>
                    <p class="count"><%= qListSize %>건</p>
                </div>
            </a>
        </div>
    </div>
</div>