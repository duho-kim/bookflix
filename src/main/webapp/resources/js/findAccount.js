window.addEventListener('DOMContentLoaded', (event) => {
    const emailTab = document.getElementById('email-tab');
    const resetPasswordTab = document.getElementById('reset-password-tab');
    const loginButton2 = document.getElementById('login-btn2');
    const emailButton = document.getElementById('email-btn');

    // 이메일 찾기 탭 클릭 이벤트
    emailTab.addEventListener('click', function() {
        if (loginButton2) {
            loginButton2.style.display = 'block'; // 로그인 버튼2 표시
        }
    });

    // 비밀번호 초기화 탭 클릭 이벤트
    resetPasswordTab.addEventListener('click', function() {
        if (loginButton2) {
            loginButton2.style.display = 'none'; // 로그인 버튼2 숨기기
        }
    });

    if (emailButton) {
        emailButton.addEventListener('click', function(event) {
            const nameInput = document.getElementById('name').value.trim();
            const nicknameInput = document.getElementById('nickname').value.trim();
            const birthInput = document.getElementById('birthdate').value.trim();

            if (nameInput === '' || nicknameInput === '' || birthInput === '') {
                alert("정보를 모두 입력해주세요.");
                event.preventDefault(); // 폼 전송 중지
            }
        });
    }

    document.getElementById('password-btn').addEventListener('click', function(event) {
        const emailInput = document.getElementById('reset-email').value.trim();
        const nicknameInput = document.getElementById('reset-nickname').value.trim();
        const birthInput = document.getElementById('reset-birthdate').value.trim();

        if (emailInput === '' || nicknameInput === '' || birthInput === '') {
            alert("정보를 모두 입력해주세요.");
            event.preventDefault(); // 폼 전송 중지
        }
    });

});
