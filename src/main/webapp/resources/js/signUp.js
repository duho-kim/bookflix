let isPasswordValid = false;
let isConfirmPasswordValid = false;
let isNicknameValid = false;
let isNameInput = false;
let checkCodeBtn = false;
const checkEmail=()=> {
    const inputEmail = document.getElementById('inputEmail');
    const email = inputEmail.value;
    console.log(email);
    fetch('/member/checkEmail', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            m_email: email,
        }),
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'sendEmail') {
                alert("본인확인 인증 이메일이 전송되었습니다.");
                // 추가적인 처리 (버튼 비활성화, 피드백 메시지 표시 등)
                document.getElementById('checkEmailBtn').disabled = true;
                document.getElementById('inputEmail').readOnly = true;
                document.getElementById('input-code').hidden = false;
            }
            else if (data.status === 'exist'){
                alert("동일한 이메일이 존재합니다.\n\n다른 이메일을 사용해주세요.");
                // 실패 시 추가 처리
                document.getElementById('inputEmail').value = '';
            }
        })
        .catch((error) => {
            console.error('Error:', error);
            alert("서버와의 통신 중 오류가 발생했습니다.\n\n나중에 다시 시도해주세요.");
        });
}

const checkCode = () => {
    const inputCode = document.getElementById('inputCode').value;

    fetch('/member/checkCode', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            code: inputCode,
        }),
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert("본인확인이 성공적으로 완료되었습니다.\n\n회원가입을 계속 진행해주세요.");
                document.getElementById('input-code').hidden = true;
                checkCodeBtn = true;
                console.log(checkCodeBtn);
            } else {
                alert("입력한 코드가 올바르지 않습니다.");
            }
            updateSignupButton();
        })
        .catch((error) => {
            console.error('Error:', error);
            alert("서버와의 통신 중 오류가 발생했습니다.\n\n나중에 다시 시도해주세요.");
        });
};

const updateSignupButton = () => {
    const signupButton = document.getElementById('signup-button');
    console.log("updateSignupButton 동작");

    if (checkCodeBtn && isPasswordValid && isConfirmPasswordValid
        && yy.value && mm.value && dd.value && isNameInput && isNicknameValid) {
        signupButton.disabled = false;
        console.log("signUpBtn 활성화")
    } else {
        signupButton.disabled = true;
        console.log("signUpBtn 비활성화")
        console.log("비밀번호: ", isPasswordValid ,"비밀번호재확인: ", isConfirmPasswordValid
            ,"년: ", yy.value ,"월: ", mm.value ,"일: ", dd.value ,"코드체크: ", checkCodeBtn,"isNameInput:",isNameInput,"isNicknameValid", isNicknameValid)
    }
}
window.addEventListener('DOMContentLoaded', (event) => {
    const inputNickname = document.getElementById('inputNickname');
    const inputPassword = document.getElementById('inputPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    const inputEmail = document.getElementById('inputEmail');
    const checkEmailBtn = document.getElementById('checkEmailBtn');
    const invalidFeedbackPassword = document.getElementById('invalid-feedback-password');
    const invalidFeedbackEmail = document.getElementById('invalid-feedback-email');
    const invalidFeedbackNickname = document.getElementById('invalid-feedback-nickname');
    const validFeedbackNickname = document.getElementById('valid-feedback-nickname');
    const yy = document.getElementById('yy');
    const mm = document.getElementById('mm');
    const dd = document.getElementById('dd');
    const form = document.getElementById('signupForm');

    inputName.addEventListener('input', () => {
        if (inputName.value === '') {
            isNameInput = false;
        } else {
            isNameInput = true;
        }
        updateSignupButton();
    });
    const checkPasswordMatch =()=> {
        const pw = inputPassword.value;
        const confirmPw = confirmPassword.value;

        if (pw === '' || confirmPw === '') {
            confirmPassword.setCustomValidity('');
            confirmPassword.classList.remove('is-invalid');
            confirmPassword.classList.remove('is-valid');
            isConfirmPasswordValid = false;
        } else if (pw !== confirmPw) {
            confirmPassword.setCustomValidity('비밀번호를 다시 확인해주세요.');
            confirmPassword.classList.add('is-invalid');
            confirmPassword.classList.remove('is-valid');
            isConfirmPasswordValid = false;
        } else {
            confirmPassword.setCustomValidity('');
            confirmPassword.classList.remove('is-invalid');
            confirmPassword.classList.add('is-valid');
            isConfirmPasswordValid = true;
        }
        updateSignupButton();
    }
    inputPassword.addEventListener('input', (e) => {
        validatePassword(e);
        checkPasswordMatch(); // 비밀번호 변경 시 재확인 비밀번호도 검사
    });
    const debounce=(func, wait)=> {
        let timeout;
        return function(...args) {
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(this, args), wait);
        };
    }

    const validateEmail = (inputEmail) => {
        const pattern = /^([0-9a-zA-Z_.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
        const email = inputEmail.value;

        console.log("validateEmail 동작");
        if (email === "") {
            inputEmail.classList.remove('is-invalid');
            inputEmail.classList.remove('is-valid');
            invalidFeedbackEmail.style.display = 'none'; // 숨김
            checkEmailBtn.disabled = true;
        } else if (!pattern.test(email)) {
            inputEmail.setCustomValidity("이메일 형식이 잘못되었습니다.");
            inputEmail.classList.add('is-invalid');
            inputEmail.classList.remove('is-valid');
            invalidFeedbackEmail.style.display = 'block'; // 보여주기
            checkEmailBtn.disabled = true;
        } else {
            inputEmail.setCustomValidity('');
            inputEmail.classList.remove('is-invalid');
            inputEmail.classList.add('is-valid');
            invalidFeedbackEmail.style.display = 'none'; // 숨김
            checkEmailBtn.disabled = false;
        }
        updateSignupButton();
    };
    if (EmailValue != "null") {
        inputEmail.value = EmailValue;
    }
    validateEmail(inputEmail);


    inputNickname.addEventListener('input', debounce(() => {
        if (inputNickname.value === '') {
            document.getElementById('invalid-feedback-nickname').style.display = 'none';
            document.getElementById('valid-feedback-nickname').style.display = 'none';
            isNicknameValid = false;
            updateSignupButton();
            return;
        }
        else {
            // fetch 요청보내기
            fetch('/member/checkNickname', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    m_nickname: inputNickname.value,
                }),
            })
                .then(response => response.json())
                .then(data => {
                    if (data.check) {
                        isNicknameValid = false;
                        validFeedbackNickname.style.display = 'none'; // 숨기기
                        invalidFeedbackNickname.style.display = 'block'; // 보여주기
                        inputNickname.setCustomValidity("닉네임을 다시 입력해주세요.");
                    } else {
                        isNicknameValid = true;
                        validFeedbackNickname.style.display = 'block'; // 보여주기
                        invalidFeedbackNickname.style.display = 'none'; // 숨기기
                        inputNickname.setCustomValidity("");
                    }
                    updateSignupButton();
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        }
    },500));

    const inputs = Array.from(document.querySelectorAll('input, select'));
    inputs.forEach((input, i) => {
        input.addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                if (i + 1 < inputs.length) { // 다음 input이 있을 경우
                    inputs[i + 1].focus();
                } else { // 마지막 input에서 엔터를 누른 경우

                }
            }
        });
    });
    const handleFormSubmit = (e) => {
        const yy = document.getElementById('yy').value;
        const mm = document.getElementById('mm').value;
        const dd = document.getElementById('dd').value;
        if (yy && mm && dd) {
            const m_birth = yy + '-' + mm + '-' + dd;
            document.getElementById('m_birth').value = m_birth;
            console.log(m_birth);
        }
        const phone1 = document.getElementById('phone1').value;
        const phone2 = document.getElementById('phone2').value;
        const phone3 = document.getElementById('phone3').value;

        if(phone2 && phone3){
            const m_phone = phone1 + '-' + phone2 + '-' + phone3;
            document.getElementById('m_phone').value = m_phone;
            console.log(m_phone);
        }
        else if((!phone2 && phone3) || (phone2 && !phone3)){
            alert("휴대폰 번호를 모두 입력해주세요");
            e.preventDefault();
        }
    };
    const validatePassword = (e) => {
        console.log("Password validation triggered.");
        const pw = e.target.value;
        const num = pw.search(/[0-9]/g);
        const eng = pw.search(/[a-z]/gi);
        const spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
        const checkKorean = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
        if (pw === '') {
            document.getElementById('valid-password-message').style.display = 'none';
            document.getElementById('length-warning').style.display = 'none';
            document.getElementById('korean-warning').style.display = 'none';
            document.getElementById('space-warning').style.display = 'none';
            document.getElementById('mix-warning').style.display = 'none';
            document.getElementById('invalid-feedback-password').style.display = 'none';
            return; 
        }
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
            confirmPassword.disabled = true;
        } else {
            document.getElementById('invalid-feedback-password').style.display = 'none';
            document.getElementById('valid-password-message').style.display = 'block';
            isPasswordValid = true;
            confirmPassword.disabled = false;
        }
    };

    form.addEventListener('submit', (e) => {
        // 폼 제출 이벤트를 처리
        // 모든 입력이 유효한지 확인한 후 제출을 진행하거나 중지할 수 있다
        if (!checkCodeBtn || !isPasswordValid || !isConfirmPasswordValid
            && !yy.value && !mm.value && !dd.value || !isNameInput || !isNicknameValid) {
            e.preventDefault(); // 폼 제출 중지
            alert('모든 필드가 올바르게 입력되지 않았습니다.');
        }
    });
    
    inputEmail.addEventListener('input', () => validateEmail(inputEmail));
    inputPassword.addEventListener('input', validatePassword);
    confirmPassword.addEventListener('input', checkPasswordMatch);
    inputEmail.addEventListener('input', updateSignupButton);
    inputPassword.addEventListener('input', updateSignupButton);
    confirmPassword.addEventListener('input', updateSignupButton);
    yy.addEventListener('input', updateSignupButton);
    mm.addEventListener('change', updateSignupButton); 
    dd.addEventListener('input', updateSignupButton);
    document.getElementById('signupForm').addEventListener('submit', handleFormSubmit);
});
