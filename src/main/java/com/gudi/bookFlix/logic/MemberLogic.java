/**
 * 회원 관리 로직 클래스
 * 주요 기능: 회원 목록 관리, 회원 가입/탈퇴, 이메일/닉네임 중복 확인, 로그인 처리, 이메일 찾기,
 * 비밀번호 확인, 회원 정보 업데이트, 메일 전송 등
 * Member Dao를 사용하여 데이터베이스와의 상호작용을 처리
 *
 * 작성자 : 김두호
 * 최초 작성일 : 2023-07-31
 */

package com.gudi.bookFlix.logic;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.gudi.bookFlix.vo.MemberVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gudi.bookFlix.dao.MemberDao;
import com.gudi.bookFlix.vo.MailVO;

import javax.activation.FileDataSource;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;

@Service
@Transactional
public class MemberLogic {
    Logger logger = LoggerFactory.getLogger(MemberLogic.class);

    @Autowired
    ServletContext servletContext;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private MemberDao memberDao = null;


    /**
     * 사용자 목록을 데이터베이스에서 불러옴
     * @param pMap 페이지네이션 및 필터링에 사용되는 매개변수
     * @return 사용자 목록
     */
    public List<Map<String, Object>> memberList(Map<String, Object> pMap) {
        logger.info("memberList");
        List<Map<String, Object>> mList = null;
        mList = memberDao.memberList(pMap);
        return mList;
    }

    /**
     * 회원 가입 처리
     * @param pMap 회원 가입에 필요한 사용자 정보
     * @return 생성된 사용자의 이름
     */
    public String memberInsert(Map<String, Object> pMap) {
        logger.info("memberInsert");
        int result = -1;
        result = memberDao.memberInsert(pMap);
        logger.info(String.valueOf(result));

        String userName = null;
        if (result >0 ){
            userName = getName(pMap);
        }
        return userName;
    }

    //아래 메소드와 합칠 수 있을 듯
    /**
     * 사용자 이름을 불러옴
     * @param pMap 사용자 이름 조회에 필요한 매개변수
     * @return 조회된 사용자 이름
     */
    public String getName(Map<String, Object> pMap){
        String userName = null;
        userName = memberDao.getName(pMap);
        return userName;
    }

    //사용자 정보 불러오기.. 리팩토링 필요(다른것과 합쳐서 단순화 가능할듯)
    /**
     * 사용자 정보를 불러옴
     * @param pMap 사용자 정보 조회에 필요한 매개변수
     * @return 조회된 사용자 정보
     */
    public Map<String, Object> getInfo(Map<String, Object> pMap){
        Map<String, Object> userInfo = new HashMap<>();
        userInfo = memberDao.getInfo(pMap);
        return userInfo;
    }

/*    public int memberUpdate(Map<String, Object> pMap) {
        logger.info("memberUpdate");
        int result = -1;
        result = memberDao.updateMember(pMap);
        logger.info(String.valueOf(result));
        return result;
    }*/

    /**
     * 회원 탈퇴 처리
     * @param pMap 회원 탈퇴에 필요한 사용자 정보
     * @return 처리 결과
     */
    public int memberDelete(Map<String, Object> pMap) {
        logger.info("memberDelete");
        int result = -1;
        result = memberDao.memberDelete(pMap);
        logger.info("Logic"+String.valueOf(result));
        return result;
    }

    /**
     * 이메일 중복 체크
     * @param pMap 이메일 중복 체크에 필요한 매개변수
     * @return 중복 여부 결과
     */
    public int checkEmail(Map<String, Object> pMap) {
        logger.info("checkEmail");
        int result = -1;
        result = memberDao.checkEmail(pMap);
        return result;
    }

    /**
     * 닉네임 중복 체크
     * @param pMap 닉네임 중복 체크에 필요한 매개변수
     * @return 중복 여부 결과
     */
    public int checkNickname(Map<String, Object> pMap) {
        logger.info("checkNickname");
        int result = -1;
        result = memberDao.checkNickname(pMap);
        logger.info("result!!!!!!!! : " + result);
        return result;
    }

    //로그인시 이메일 비밀번호 체크
    public Map<String, Object> loginCheck(Map<String, Object> pMap) {
		logger.info("login");
		Map<String, Object> user = null;
		user = memberDao.loginCheck(pMap);
		
		return user;
	}

    /**
     * 가입된 이메일 계정을 찾기
     * @param pMap 이메일 찾기에 필요한 정보
     * @return 찾아진 이메일 주소
     */
    public Map<String, Object> findEmail(Map<String, Object> pMap) {
        logger.info("이메일찾기 호출");
        Map<String, Object> email = null;
        email = memberDao.findEmail(pMap);
        return email;
    }

    /**
     * 사용자의 비밀번호 일치 여부를 확인
     * @param cPass 비밀번호 확인에 필요한 사용자 정보와 비밀번호
     * @return 일치하면 1, 불일치하면 0
     */
    public int checkPassword(Map<String, Object> cPass) {
        logger.info("비밀번호 체크 로직 호출!");
        int result = -1;
        result = memberDao.checkPassword(cPass);
        logger.info("result!!!!!!!! : " + result);
        return result;
    }
////////////////////////////////////////////////////////////////////////////////////
    /**
     * 사용자 정보를 업데이트, 닉네임 중복 체크 후 업데이트를 진행
     * @param cInfo 업데이트할 회원 정보
     * @return 업데이트 성공 시 1, 실패 시 0
     */
    public int updateMember(Map<String, Object> cInfo) {
        logger.info("회원정보 변경 로직 호출!");
        int result = -1;
        result = checkNickname(cInfo);

        if (result == 0){
            logger.info("동일한 정보 없음!!!!");
            result = memberDao.updateMember(cInfo);
        } else {
            logger.info("동일한 정보 존재!!!!");
            result = 0;
        }
        return result;
    }


//////////////////////////////메일링 서비스//////////////////////////////////////////
    /**
     * 인증 이메일 내용을 생성
     * @param pMap 이메일 주소를 포함하는 매개변수
     * @param str 인증 코드
     * @return 생성된 메일 내용
     */
    public MailVO createAuthEmail(Map<String, Object> pMap, String str) {
        String userEmail = (String) pMap.get("m_email");
        // 메일 VO 생성
        MailVO mvo = new MailVO();
        mvo.setAddress(userEmail);
        mvo.setTitle("BOOKFLIX 본인인증 안내 이메일");

        String htmlContent = "<div style='text-align:center;'>"
                + "<h1><img src='cid:logo' alt='BOOKFLIX_Logo'></h1>"
                + "<h3>인증 코드</h3>"
                + "<h1>[ <strong style='color:#ff5c5c;'>" + str + "</strong> ]</h1>"
                + "<h3>해당 인증번호를 인증번호 확인란에 기입해주세요.</h3>"
                + "</div>";

        mvo.setMessage(htmlContent);
        return mvo;
    }

    /**
     * 임시 비밀번호를 생성, 메일 내용을 구성하여 메일을 전송
     * @param pMap 사용자 이메일을 포함하는 매개변수
     * @return 메일 전송에 필요한 정보를 담은 객체
     */
    public MailVO createMailAndChangePassword(Map<String, Object> pMap) {
        int result = 0;
        String str = getTempPassword(); // 임시 비밀번호 생성
        pMap.put("m_pw", str); // 임시 비밀번호를 Map에 설정
        result = updatePassword(pMap);

        if(result > 0) {
            String userEmail = (String) pMap.get("m_email");
            // 메일 VO 생성
            MailVO mvo = new MailVO();
            mvo.setAddress(userEmail);
            mvo.setTitle("BOOKFLIX 임시비밀번호 안내 이메일");

            String htmlContent = "<div style='text-align:center;'>"
                    + "<h1><img src='cid:logo' alt='BOOKFLIX_Logo'></h1>"
                    + "<h3>임시 비밀번호 발급</h3>"
                    + "<h1>[ <strong style='color:#ff5c5c;'>" + str + "</strong> ]</h1>"
                    + "<h3>로그인 후에 비밀번호를 "+"<span style='color:red;'>변경</span>"+"해주세요.</h3>"
                    + "</div>";

            mvo.setMessage(htmlContent);
            return mvo;
        }
        return null;
    }

    /**
     * 임시 비밀번호로 사용자 비밀번호를 업데이트
     * @param pMap 업데이트할 사용자의 정보와 임시 비밀번호를 포함하는 매개변수
     * @return 업데이트 성공 시 1, 실패 시 0
     */
    public int updatePassword(Map<String, Object> pMap) {
        int result = -1;
        result = memberDao.updatePassword(pMap);
        logger.info("result!!!!!!!!!!!!!"+result);
        return result;
    }

    /**
     * 랜덤 문자열로 구성된 임시 비밀번호 생성
     * @return 생성된 임시 비밀번호
     */
    public String getTempPassword(){
        char[] charSet = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
                'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
        String str = "";

        // 문자 배열 길이의 값을 랜덤으로 10개를 뽑아 구문을 작성함
        int idx = 0;
        for (int i = 0; i < 10; i++) {
            idx = (int) (charSet.length * Math.random());
            str += charSet[idx];
        }
        return str;
    }

    /**
     * 메일 전송
     * @param mvo 전송할 메일의 정보를 담은 객체
     */
    public void sendEmail(MailVO mvo) {
        try {
            String LOGO_PATH = servletContext.getRealPath("/resources/img/headerLogo.png");
            FileDataSource fds = new FileDataSource(LOGO_PATH);
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "utf-8");
            helper.setTo(mvo.getAddress());
            helper.setSubject(mvo.getTitle());
            helper.setText(mvo.getMessage(), true);
            helper.setFrom("bookflix65@gmail.com", "북플릭스");
            helper.setReplyTo("bookflix65@gmail.com","북플릭스");
            System.out.println("message: " + mimeMessage);
            helper.addInline("logo", fds);
            mailSender.send(mimeMessage);
            logger.info("전송 완료!!!!!!!!!");
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("메일 전송 실패!!!!!!!!!!");
        }
    }

    //VO에서 이름 가져오기
    public MemberVO getName(String m_name) {
        MemberVO mvo = new MemberVO();
        mvo = memberDao.getName(m_name);
        return mvo;
    }
}
