<%@ page language="java"	contentType="text/html;charset=UTF-8"	pageEncoding="UTF-8"%>
<%    String user = (String)session.getAttribute("m_id");
    String nickname = (String)session.getAttribute("m_nickname");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@include file="/resources/cdn/common.html"%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
    <link rel="stylesheet" href="/resources/css/bookDetail.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <title>책 상세조회 페이지</title>
</head>
<body>
<%@include file="../common/mainHeader.jsp"%>
<div class="container mt-4 mb-4">
    <!-- 검색 목록 -->

    <div class="row mb-4" >
        <div class="col-md-9" >
            <!-- 이미지 및 상세 정보 -->
            <div class="detail-container">
                <div class="img-container">
                    <img src="/resources/img/thumbnail_test1.png" alt="thumbnail">
                    <div class="my-book-button" > 하트버튼자리</div>
                </div>
                <div class="book-info-container">
                    <h2>댕강 컴퍼니</h2>
                    <p>생강</p>
                    <p>출판사</p>
                    <p>총 **화 | 미완결</p>
                </div>
            </div>
            <!-- 전체선택, 소장하기 및 체크박스와 보기 소장 버튼들 -->
            <div class="detail-tab">
                <div style="background-color: white;">
                    <a href="#">대여하기</a>
                    <input type="hidden" name="C_TYPE" value="RENTAL" >
                </div>
                <div style="background-color: rgb(216, 216, 216); border: 1px solid rgb(170, 170, 170); border-top: none; border-right: none;">
                    <a href="#">소장하기</a>
                </div>
            </div>
            <div class="detail-table" style="margin-bottom: 50px;">
                <table class="table" style="text-align: start;">
                    <thead>
                    <tr>
                        <th scope="col" style="width: 20%;">
                            <div class="form-check cart-check check-all">
                                <input class="form-check-input" type="checkbox" id="selectAll">
                                <label class="form-check-label" for="selectAll">전체 선택</label>
                            </div>
                        </th>
                        <th colspan="2" style="text-align: right;"><button class="white-button">선택 삭제</button></th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th scope="row">
                            <div class="form-check cart-check check-option">
                                <input class="form-check-input" type="checkbox" name="option[]" value="1">
                                <label class="form-check-label"><img class="detail-thumbnail" src="/resources/img/thumbnail_test1.png"></label>
                            </div>
                        </th>
                        <td>
                            <div class="table-info">
                                <p>댕강컴퍼니 2화</p>
                                <p style="color: gray; font-size: 14px;">2023.08.15</p>
                                <p style="color: #2679ff;">500원</p>
                            </div>
                        </td>
                        <td>
                            <div class="cart-cost">
                                <button class="white-button">삭제</button>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <hr>
            <div class="white-box p-4">
                <!-- 작품 소개 섹션 -->
                <h4>작품소개</h4>
                <p>여기에 작품에 대한 소개 내용을 넣어주세요.</p>
                <hr>
                <!-- 저자 섹션 -->
                <h4>저자</h4>
                <p>저자에 대한 정보나 소개를 여기에 넣어주세요.</p>
                <hr>
                <!-- 리뷰 섹션 -->
                <h4>리뷰</h4>
                <label for="rating"></label>
                <link href="/assets/css/star.css" rel="stylesheet"/>

                <form class="mb-3" name="myform" id="myform" method="post">
                    <fieldset>
                        <span class="text-bold">별점을 선택해주세요</span>
                        <input type="radio" name="reviewStar" value="5" id="rate1"><label
                            for="rate1">★</label>
                        <input type="radio" name="reviewStar" value="4" id="rate2"><label
                            for="rate2">★</label>
                        <input type="radio" name="reviewStar" value="3" id="rate3"><label
                            for="rate3">★</label>
                        <input type="radio" name="reviewStar" value="2" id="rate4"><label
                            for="rate4">★</label>
                        <input type="radio" name="reviewStar" value="1" id="rate5"><label
                            for="rate5">★</label>
                    </fieldset>
                    <div>
		<textarea class="col-auto form-control" type="text" id="reviewContents"
                  placeholder="리뷰를 남겨주세요"></textarea>
                    </div>
                </form>
            </div>
        </div>

        <!-- 여기에 구분선을 추가합니다. -->
        <!-- 베스트 목록 -->
        <div class="col-md-3 detail-right">
            <h5 style="font-size: 15px;">베스트<a href="#"
                                               style="padding-left: 5px; text-decoration: none; color: inherit;">></a>
            </h5>
            <ul class="book-list">
                <li><span class="ranking">1</span> 명문고 ex급 조연의 이야기</li>
                <li><span class="ranking">2</span> 백작가의 망나니가 되었다</li>
                <li><span class="ranking">3</span> 서브 남주가 파업하맨 생기는 일</li>
                <li><span class="ranking">4</span> 블랙 기업 조선</li>
                <li><span class="ranking">5</span> 환생 했더니 단종의 보모!?</li>
                <li><span class="ranking">6</span> 흑막이지만 세계 평화가 좋다</li>
                <li><span class="ranking">7</span> 저승의 왕위를 계승했다</li>
                <li><span class="ranking">8</span> 히든 피스로 전설 기사</li>
                <li><span class="ranking">9</span> 회귀자 사용설명서</li>
                <li><span class="ranking">10</span> 반려 쉘터 키우기</li>

            </ul>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="scripts.js"></script>
</body>
</html>
