<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>북플릭스</title>
  <script src="https://kit.fontawesome.com/cc13ae136b.js" crossorigin="anonymous"></script>
  <style>

    .container {
      width: 150px; /* 컨테이너 너비 설정 */
      font-family: Arial, sans-serif;
    }

    .header {
      color: rgb(73, 73, 73);
      margin-left: 10px;
      font-weight: bolder;
      font-size: 22px;
      margin-bottom: 20px;
    }

    .header-link {
      font-weight: bold;
      font-size: 14px;
      color: #2679ff;
      text-decoration: none;
      display: block;
      margin-bottom: 10px;
    }

    .header-link:hover{
      text-decoration: none;
      color: #0060ff;
    }
    .section {
      color: rgb(73, 73, 73);
    }

    .section-title {
      font-weight: bold;
      font-size: 16px;
      margin-bottom: 10px;
    }

    .section-item,
    .link-sidebar {
      color: rgb(73, 73, 73);
      padding-left: 10px;
      font-size: 14px;
      margin-left: 10px;
      margin-bottom: 5px;
      background: none;
      border: none;
      cursor: pointer;
      text-align: left;
      outline: none;
      text-decoration: none; /* 링크의 밑줄 제거 */
      display: block; /* 버튼과 동일한 레이아웃을 위해 */
    }
    .section-item:hover,
    .link-sidebar:hover {
      font-weight: bold;
      text-decoration: none; /* 호버 시 밑줄 제거 */
      color: #4f4f4f;
    }

    .line {
      border-bottom: 1px solid #ccc;
      margin-top: 20px;
      margin-bottom: 20px;
    }

    .active-link {
      font-weight: bold;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="header">마이페이지</div>
  <a href="/mypage/myPage" class="header-link" id="home-link">
    <i class="fa-solid fa-house-user"></i>
    마이페이지 홈
  </a>
  <div class="line"></div>

  <div class="section">
    <div class="section-title">
      <i class="fa-solid fa-user"> 개인</i>
    </div>
    <button class="section-item" onclick="clickItem('myInfo');" id="myInfoTab">내 정보 관리</button>
    <a href="/qna/qnaListMem?m_id=<%=user%> ">
      <button class="section-item">1:1 문의</button>
    </a>
    <button class="section-item" onclick="clickItem('myReview');">리뷰 관리</button>
  </div>
  <div class="line"></div>

  <div class="section">
    <div class="section-title">
      <i class="fa-solid fa-book"> 책</i>
    </div>
    <button class="section-item" onclick="clickItem('myLike');">선호 작품</button>
    <button class="section-item" onclick="clickItem('myBook');">내 서재</button>
  </div>
  <div class="line"></div>

  <div class="section">
    <div class="section-title">
      <i class="fa-solid fa-sack-dollar"> 구매혜택</i>
    </div>
    <button class="section-item" onclick="clickItem('myPay');">결제 내역</button>
    <a class="link-sidebar" href="/cart/cartList">장바구니</a>
  </div>
</div>
<script>
  const clickItem = (contentType) => {
    console.log('여기여기여기'+contentType);
    const url = "/mypage/"+contentType;
    console.log(url);
    fetch(url)
            .then(response => {
              if (!response.ok) {
                console.log('Error fetching:', response);
                return '';
              }
              return response.text();
            })
            .then(html => {
              console.log('Fetched HTML:', html);
              document.getElementById('main-content').innerHTML = html;
              // myInfo 탭에 대한 스크립트 실행
              if (contentType === 'myInfo') {
                activateMyInfoTab();
              }
            })

            .catch(error => {
              console.error('Error loading content:', error);
            });
  };

  window.onload = () => {
    // 모든 section-item 클래스를 가진 요소에 이벤트 리스너 추가
    document.querySelectorAll('.section-item').forEach(item => {
      item.addEventListener('click', event => {
        // 모든 section-item 클래스를 가진 요소의 두꺼운 글씨 스타일 제거
        document.querySelectorAll('.section-item').forEach(link => {
          link.classList.remove('active-link');
        });

        // 클릭된 요소에 두꺼운 글씨 스타일 적용
        event.currentTarget.classList.add('active-link');

        // 내용 변경 로직 (예: "내 정보 관리"를 클릭했을 때의 내용 변경)

      });
    });
  }
</script>
</body>
</html>
