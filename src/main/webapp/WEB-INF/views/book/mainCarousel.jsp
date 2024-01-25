<%--
  Created by IntelliJ IDEA.
  User: mkchocho
  Date: 2023/08/09
  Time: 2:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div id="carouselExampleIndicators" class="carousel slide my-4" data-ride="carousel">
<ol class="carousel-indicators">
    <!-- 이 부분은 슬라이더의 목록을 표시합니다 -->
    <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
</ol>
<div class="carousel-inner" role="listbox">
    <!-- 각 슬라이더 아이템은 하나의 배너를 표현합니다 -->
    <div class="carousel-item active" style="background-image: url('https://via.placeholder.com/800')">
        <div class="carousel-caption d-none d-md-block">
            <h3>첫 번째 슬라이드</h3>
            <p>첫 번째 슬라이드 내용</p>
        </div>
    </div>
    <div class="carousel-item" style="background-image: url('https://via.placeholder.com/800')">
        <div class="carousel-caption d-none d-md-block">
            <h3>두 번째 슬라이드</h3>
            <p>두 번째 슬라이드 내용</p>
        </div>
    </div>
    <div class="carousel-item" style="background-image: url('https://via.placeholder.com/800')">
        <div class="carousel-caption d-none d-md-block">
            <h3>세 번째 슬라이드</h3>
            <p>세 번째 슬라이드 내용</p>
        </div>
    </div>
</div>


<!-- 이전/다음 버튼 -->
<a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="sr-only">이전</span>
</a>
<a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="sr-only">다음</span>
</a>
</div>
