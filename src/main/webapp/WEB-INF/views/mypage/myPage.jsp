<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <%@include file="/resources/cdn/common.html" %>
    <link rel="stylesheet" href="/resources/css/myHome.css">
    <link rel="stylesheet" href="/resources/css/main.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <style>
        .layout-container {
            padding: 50px;
            display: flex;
            flex-direction: column;
            align-items: center; /* 가로 방향 중앙 정렬 */
        }

        .content-container {
            width: 1200px;
            display: flex;
        }

        .sidebar-container {
            width: 30%; /* 사이드바 넓이 설정 */
        }

        .main-content-container {
            width: 70%;
            padding-left: 20px;
            flex-grow: 1; /* 남은 공간을 메인 콘텐츠가 차지하도록 설정 */
        }
        .valid-feedback,
        .invalid-feedback {
            display: none;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<%@include file="../common/mainHeader.jsp" %>
<div class="layout-container">
    <div class="content-container">
        <div class="sidebar-container">
            <%@include file="sidebar.jsp" %>
        </div>
        <div class="main-content-container" id="main-content">
            <%@include file="myHome.jsp" %>
        </div>
    </div>
</div>
<%@include file="../common/footer.jsp"%>
<script>
    //////////////////////////////////////////////////////////////////////////
    const checkPassword = () => {
        const passwordInput = document.getElementById('password').value;
        console.log("checkPassword 함수가 호출되었습니다.");
        if (passwordInput === '') {
            alert('비밀번호를 입력해주세요.');
            return;
        }

        const data = {
            password: passwordInput
        };

        fetch('/member/checkPassword', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        })
            .then(response => response.json())
            .then(result => {
                console.log("Server response:", result);
                if (result.check === 1) {
                    // 비밀번호 검증 성공 시 내 정보 관리 페이지로 이동
                    document.getElementById('password-confirm').classList.add('hidden');
                    document.getElementById('myInfoSection').classList.remove('hidden');
                } else {
                    // 비밀번호 검증 실패 시 에러 메시지 표시
                    alert('비밀번호가 틀렸습니다.\n다시 시도해주세요.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버에서 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.');
            });
    }

    const updateMember = (fieldType) => {
        const valueInput = document.getElementById(fieldType).value.trim();
        const fieldNames = {
            m_nickname: '닉네임',
            m_phone: '휴대폰 번호'
        };
        const displays = {
            m_nickname_info: '#nickname-display',
            m_nickname_header: '#header-nickname-display',
            m_phone: '#phone-display'
        };
        const display = displays[fieldType];

        if (valueInput === '') {
            alert(fieldNames[fieldType] + "을(를) 입력해주세요.");
            return;
        }

        if (fieldType === 'm_phone' && !/^010-\d{4}-\d{4}$/.test(valueInput)) {
            alert('올바른 휴대폰 번호 형식을 입력해주세요. (예: 010-1234-5678)');
            return;
        }

        const data = {
            type: fieldType,
            [fieldType]: valueInput
        };
        // 서버로 전송
        fetch('/member/updateMember', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        })
            .then(response => response.json())
            .then(result => {
                if (result.status === 'exist') {
                    alert('중복된 '+fieldNames[fieldType]+'입니다. ');
                } else if (result.status === 'updated') {
                    //location.reload(); // 페이지 새로고침
                    if (fieldType === 'm_nickname') {
                        document.querySelector(displays.m_nickname_info).textContent = result.newInfo;
                        document.querySelector(displays.m_nickname_header).textContent = result.newInfo;
                    } else if (display != null) {
                        document.querySelector(display).textContent = result.newInfo;
                    }
                    document.getElementById(fieldType).value = '';
                    alert(fieldNames[fieldType] + "이(가) 변경되었습니다.");
                } else if (result.status === 'updatedPw') {
                    location.reload();
                    alert("비밀번호가 변경되었습니다.");
                }
            })
            .catch(error => {
                console.error('업데이트 중 오류 발생:', error);
            });
    }

    let isPasswordValid = false;
    let isConfirmPasswordValid = false;
    const activateMyInfoTab =()=> {
        const newPassword = document.getElementById('m_pw');
        const checkNewPassword = document.getElementById('checkNewPassword');
        console.log("new1 : " + newPassword);

        const validatePassword = (e) => {
            console.log("유효성검사 호출");
            const pw = e.target.value;
            const num = pw.search(/[0-9]/g);
            const eng = pw.search(/[a-z]/gi);
            const spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
            const checkKorean = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;

            // 각 경고 문구 선택
            const lengthWarning = document.getElementById('length-warning');
            const koreanWarning = document.getElementById('korean-warning');
            const spaceWarning = document.getElementById('space-warning');
            const mixWarning = document.getElementById('mix-warning');

            // 조건에 따라 문구 보이기/숨기기
            lengthWarning.style.display = (pw.length < 8 || pw.length > 20) ? 'block' : 'none';
            koreanWarning.style.display = checkKorean.test(pw) ? 'block' : 'none';
            spaceWarning.style.display = pw.search(/\s/) !== -1 ? 'block' : 'none';
            mixWarning.style.display = (num < 0 || eng < 0 || spe < 0) ? 'block' : 'none';

            // 어떤 문구가 보이면 invalid-feedback-password를 보이게 함
            if (pw.length < 8 || pw.length > 20 || checkKorean.test(pw) || pw.search(/\s/) !== -1 || (num < 0 || eng < 0 || spe < 0)) {
                document.getElementById('invalid-feedback-password').style.display = 'block';
                document.getElementById('valid-password-message').style.display = 'none';
                isPasswordValid = false;
                checkNewPassword.disabled = true;
            } else {
                document.getElementById('invalid-feedback-password').style.display = 'none';
                document.getElementById('valid-password-message').style.display = 'block';
                isPasswordValid = true;
                checkNewPassword.disabled = false;
            }
        };

        const checkNewPasswordMatch = () => {
            const pw = newPassword.value;
            const checkPw = checkNewPassword.value;

            if (pw === '' || checkPw === '') {
                checkNewPassword.setCustomValidity('');
                checkNewPassword.classList.remove('is-invalid');
                checkNewPassword.classList.remove('is-valid');
                isConfirmPasswordValid = false;
            } else if (pw !== checkPw) {
                checkNewPassword.setCustomValidity('비밀번호를 다시 확인해주세요.');
                checkNewPassword.classList.add('is-invalid');
                checkNewPassword.classList.remove('is-valid');
                isConfirmPasswordValid = false;
            } else {
                checkNewPassword.setCustomValidity('');
                checkNewPassword.classList.remove('is-invalid');
                checkNewPassword.classList.add('is-valid');
                isConfirmPasswordValid = true;
            }
        }

        if (newPassword) {
            console.log("new2 : " + newPassword);
            newPassword.addEventListener('input', (e) => {
                validatePassword(e);
                checkNewPasswordMatch(); // 비밀번호 변경 시 재확인 비밀번호도 검사
            });
        }

        if (checkNewPassword) {
            checkNewPassword.addEventListener('input', checkNewPasswordMatch);
        }
    }
    const updatePassword = () => {
        console.log(isPasswordValid);
        console.log(isConfirmPasswordValid);

        if (!isPasswordValid || !isConfirmPasswordValid) {
            alert('비밀번호가 유효하지 않습니다. 다시 확인해주세요.');
            return;
        }else {
            updateMember('m_pw');
        }
    };
    const resign = () => {
        const isConfirm = window.confirm("정말로 탈퇴 하시겠습니까? ㅠ^ㅠ");

        // 3. '예'를 누르면 서버로 요청을 보냅니다.
        if (isConfirm) {
            fetch('/member/memberDelete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => response.json())
                .then(result => {
                    if (result.status === 'deleted') {
                        alert('탈퇴가 성공적으로 처리되었습니다.\n\n다시 돌아와요..ㅠ^ㅠ');
                        // 필요한 경우 로그인 페이지 등으로 리다이렉션
                        window.location.href = '/book/main';
                    } else {
                        alert('탈퇴 처리 중 문제가 발생했습니다. 다시 시도해주세요.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('서버에서 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.');
                });
        }
    };
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
</body>
</html>
