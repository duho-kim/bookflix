window.addEventListener('DOMContentLoaded', (event) => {
    document.getElementById('login-btn').addEventListener('click', function(event) {
        const emailInput = document.getElementById('m_email').value.trim();
        const passwordInput = document.getElementById('m_pw').value.trim();

        if (emailInput === '' || passwordInput === '') {
            alert("아이디와 비밀번호를 입력해주세요.");
            event.preventDefault(); // 폼 전송 중지
        }
    });
});
