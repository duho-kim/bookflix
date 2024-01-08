<%@ page language="java"	contentType="text/html;charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List" %>
<%
    Map<String, Object> data = (Map<String, Object>) request.getAttribute("data");
    List<Map<String, Object>> likeList = (List<Map<String, Object>>) data.get("likeList");
    int likeListSize = likeList.size();
 /*   out.print("data :::: "+data);
    out.print("likeList :::: "+ likeList);
    out.print(likeListSize);*/
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOOKFLIX</title>
    <%-- 캐러셀에 필요한 부트스트랩 버전   --%>
    <link rel="stylesheet" href="/resources/css/common.css">
</head>
<body>
<div class="row row-container" >
    <h3 style="color: #606060; margin-bottom: 40px;">선호 작품</h3>
    <% for (Map<String, Object> item : likeList) { %>
    <div class="col-md-3 mb-5">
        <div class="card" style=" margin-right: 30px; height: 29rem; width: 12rem; opacity: 1; transform: translateY(0px);">
            <a href="/book/detail?b_no=<%=item.get("B_NO")%>">
                <img src=<%=item.get("B_THUMBNAIL")%> class="card-img-top" alt="..." style="height: 250px; object-fit: cover;">
            </a>
            <div class="card-body">
                <h5 class="card-title"><a href="/book/detail?b_no=<%=item.get("B_NO")%>"><%=item.get("B_TITLE")%></a></h5>
                <h6 class="card-subtitle"><%=item.get("B_AUTHOR")%></h6>
                <p class="card-text"><%=item.get("B_DESCRIPT")%></p>
            </div>
        </div>
    </div>
    <%}%>
</div>
</body>
</html>