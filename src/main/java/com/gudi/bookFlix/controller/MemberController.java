/**
 * 회원 관리 기능을 수행하는 컨트롤러.
 * 주요 기능: 회원 가입, 탈퇴, 로그인, 로그아웃, 계정 찾기, 중복 체크, 메일 전송.
 * MemberLogic을 사용하여 데이터베이스 작업을 처리하고, 적절한 뷰를 반환
 *
 * 작성자: 김두호
 * 작성일: 2023-07-31
 */

package com.gudi.bookFlix.controller;

import com.gudi.bookFlix.vo.MailVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.gudi.bookFlix.logic.MemberLogic;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/member/*")
public class MemberController {
    Logger logger = LoggerFactory.getLogger(MemberController.class);
    @Autowired
    private MemberLogic memberLogic = null;

    /**
     * 회원 목록을 조회하여 반환
     * @param pMap 페이지네이션 및 필터링에 사용되는 매개변수
     * @param model 뷰에 데이터를 전달하는 데 사용
     * @return 회원 목록 페이지 경로
     */
    @GetMapping("memberList")
    public String memberList(@RequestParam Map<String, Object> pMap, Model model){
        List<Map<String,Object>> mList = null;
        mList = memberLogic.memberList(pMap);
        model.addAttribute("mList", mList);
        return "member/memberList";
    }

    /**
     * 신규 회원 가입을 처리
     * @param pMap 회원 가입에 필요한 정보를 담고 있는 맵
     * @param model 뷰에 데이터를 전달하는 데 사용
     * @return 회원 가입 성공 페이지 경로
     */
    @PostMapping("memberInsert")
    public String memberInsert(@RequestParam Map<String, Object> pMap, Model model){
        logger.info("입력된 값 : " + pMap);
        String userName = null;
        userName = memberLogic.memberInsert(pMap);
        logger.info(userName);
        model.addAttribute("m_name", userName);
        return "member/signUpSuccess";
    }

    /**
     * 회원 탈퇴 기능을 수행합니다.
     * 세션에 저장된 회원 ID를 사용하여 회원 탈퇴를 진행
     * @param session 현재 사용자 세션
     * @return 탈퇴 결과를 담은 Map 객체
     */
    @PostMapping("memberDelete")
    @ResponseBody
    public Map<String, Object> memberDelete(HttpSession session){
        String userId = (String) session.getAttribute("m_id");
        Map<String, Object> cInfo = new HashMap<>();
        cInfo.put("m_id", userId);

        int result = -1;
        result = memberLogic.memberDelete(cInfo);

        cInfo = new HashMap<>();
        if (result == 1 ){
            cInfo.put("status", "deleted");
            session.invalidate();
        }

        return cInfo;
    }

    /**
     * 이메일 중복 체크 및 인증 이메일 전송 기능을 수행
     * @param pMap 클라이언트로부터 받은 요청 매개변수
     * @param session 현재 사용자 세션
     * @return 이메일 중복 체크 및 전송 결과를 담은 Map 객체
     */
    @PostMapping("checkEmail")
    @ResponseBody
    public Map<String, Object> checkEmail(@RequestBody Map<String, Object> pMap, HttpSession session) {
        logger.info("이메일 체크 호출!");
        logger.info("입력값!!! : " + pMap);

        int result = -1;
        result = memberLogic.checkEmail(pMap);

        Map<String, Object> response = new HashMap<>();

        logger.info("result!!!!!!!! : " + result);
        if (result > 0) {
            response.put("status", "exist"); // 1이상이란 말, 이미 아이디가 존재한다는 말이라서 사용이 안된다
        } else {
            response.put("status", "sendEmail");
            String str = memberLogic.getTempPassword();
            MailVO mvo = memberLogic.createAuthEmail(pMap, str);
            if (mvo != null) {
                session.setAttribute("code", str);
                memberLogic.sendEmail(mvo);
                response.put("status", "sendEmail");
            }
        }
        return response;
    }

    /**
     * 랜덤으로 발송된 코드 입력시 유효성을 검사
     * @param pMap 클라이언트로부터 받은 요청 매개변수 (인증 코드)
     * @param session 현재 사용자의 세션
     * @return 인증 코드 검사 결과를 담은 Map 객체
     */
    @PostMapping("checkCode")
    @ResponseBody
    public Map<String, Object> checkCode(@RequestBody Map<String, String> pMap, HttpSession session) {
        String inputCode = pMap.get("code");
        String sessionCode = (String) session.getAttribute("code");

        Map<String, Object> response = new HashMap<>();

        if (inputCode != null && inputCode.equals(sessionCode)) {
            response.put("success", true);
            session.invalidate();
        } else {
            response.put("success", false);
        }
        return response;
    }

    /**
     * 사용자 닉네임 중복을 체크
     * @param pMap 클라이언트로부터 받은 요청 매개변수 (닉네임)
     * @return 닉네임 중복 체크 결과를 담은 Map 객체
     */
    @PostMapping("checkNickname")
    @ResponseBody
    public Map<String, Object> checkNickname(@RequestBody Map<String, Object> pMap) {
        logger.info("checkNickname 호출!");
        int result = -1;
        Map<String, Object> response = new HashMap<>();
        result = memberLogic.checkNickname(pMap);
        logger.info("result!!!!!!!! : " + result);
        if (result > 0) {
            response.put("check", true); // 1이상이란 말, 이미 아이디가 존재한다는 말이라서 사용이 안된다
        } else {
            response.put("check", false);
        }
        return response;
    }

    /**
     * 사용자의 비밀번호 일치 여부 검사
     * @param pMap 클라이언트로부터 받은 요청 매개변수 (비밀번호)
     * @param session 현재 사용자의 세션
     * @return 비밀번호 일치 검사 결과를 담은 Map 객체
     * (보안상 문제가 있을것으로 예상..개선필요)
     */
    @PostMapping("checkPassword")
    @ResponseBody
    public Map<String, Object> checkPassword(@RequestBody Map<String, Object> pMap, HttpSession session) {
        logger.info("checkPassword 호출!");
        String userId = (String) session.getAttribute("m_id");
        String inputPw = (String)pMap.get("password"); // 클라이언트에서 보낸 비밀번호

        int result = -1;
        Map<String, Object> cPass = new HashMap<>();
        cPass.put("m_id", userId);
        cPass.put("m_pw", inputPw);
        result = memberLogic.checkPassword(cPass);

        cPass = new HashMap<>();
        cPass.put("check", result);
        logger.info("결과!!!!!" + cPass);
        return cPass;
    }

//////////////////////////////////////여기 뭔가 어지러움 리팩토링 필요///////////////////////////////////
    /**
     * 회원 정보 업데이트
     * @param pMap 클라이언트로부터 받은 요청 매개변수
     * @param session 현재 사용자의 세션
     * @return 회원 정보 업데이트 결과를 담은 Map 객체
     */
    @PostMapping("updateMember")
    @ResponseBody
    public Map<String, Object> updateMember (@RequestBody Map<String, Object> pMap, HttpSession session){
        logger.info("회원정보변경 컨트롤러 호출!");
        String userId = (String) session.getAttribute("m_id");
        //String userId = (String)pMap.get("m_id"); 포스트맨 테스트용
        String fieldType = (String)pMap.get("type");
        String inputValue = null;
        if (fieldType != null) {
            inputValue = (String) pMap.get(fieldType);
        }
        int result = -1;
        Map<String, Object> cInfo = new HashMap<>();
        cInfo.put("m_id", userId);
        cInfo.put(fieldType, inputValue);
        result = memberLogic.updateMember(cInfo);
        Map<String, Object> userInfo = memberLogic.getInfo(cInfo);

        cInfo = new HashMap<>();
        if (result == 1 ){
            if (fieldType.equals("m_pw")) {
                cInfo.put("status", "updatedPw");
            } else {
                String newInfo = userInfo.get(fieldType).toString();
                session.setAttribute(fieldType, newInfo);
                logger.info("여기 확인 필요!!!:" +fieldType+", "+ newInfo);
                cInfo.put("status", "updated");
                cInfo.put("newInfo", newInfo);
            }
        } else {
            cInfo.put("status", "exist");
        }
        return cInfo;
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * 사용자 로그인 처리
     * @param pMap 로그인에 필요한 정보를 담은 맵
     * @param session 현재 사용자 세션
     * @param rab 리다이렉트 시 메시지 전달에 사용
     * @return 로그인 결과에 따른 페이지 경로
     */
    @PostMapping("loginCheck")
    public String loginCheck(@RequestParam Map<String, Object> pMap , HttpSession session, RedirectAttributes rab) {
        Map<String, Object> user =  null;
        user = memberLogic.loginCheck(pMap);
        if (user != null && !user.isEmpty()) {
            // 로그인 성공
            session.setAttribute("member", user.toString());
            session.setAttribute("m_name", user.get("m_name").toString());
            session.setAttribute("m_id", user.get("m_id").toString());
            session.setAttribute("m_email", user.get("m_email").toString());
            session.setAttribute("m_admin", user.get("m_admin").toString());
            session.setAttribute("m_nickname", user.get("m_nickname").toString());
            if(user.get("m_phone") != null) {
                session.setAttribute("m_phone", user.get("m_phone").toString());
            }
            return "redirect:/book/main"; // 로그인 성공 페이지로 리다이렉트
        } else {
            // 로그인 실패
            rab.addFlashAttribute("errorMessageLogin", "이메일 또는 비밀번호가 일치하지 않습니다.");
            return "redirect:login"; // 로그인 폼 페이지로 다시 돌아감
        }
    }

    /**
     * 사용자 로그아웃을 처리하고 세션을 무효화
     * @param session 현재 사용자의 세션
     * @return 메인 페이지로 리다이렉트
     */
    @PostMapping("logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/book/main";
    }

    /**
     * 가입된 이메일 계정 찾기
     * @param pMap 이메일 찾기에 필요한 정보를 담은 맵
     * @param model 뷰에 데이터를 전달하는 데 사용
     * @param session 현재 사용자의 세션
     * @return 계정 찾기 결과에 따른 페이지 경로
     */
    @PostMapping("findEmail")
    public String findEmail(@RequestParam Map<String, Object> pMap, Model model, HttpSession session) {
        logger.info("이메일찾기 호출");
        Map<String, Object> email = null;
        email = memberLogic.findEmail(pMap);
        if (email != null && !email.isEmpty()) {
            model.addAttribute("m_email", email.get("m_email").toString());
            return "member/findAccount";
        } else {
            session.setAttribute("errorMessage", "입력하신 정보와 일치하는 이메일이 없습니다.");
            return "redirect:findAccount";
        }
    }

    /**
     * 이메일 전송
     * @param pMap 이메일 전송에 필요한 정보를 담은 맵
     * @param session 현재 사용자의 세션
     * @return 이메일 전송 결과에 따른 페이지 경로
     */
    @PostMapping("sendEmail")
    public String sendEmail(@RequestParam Map<String, Object> pMap, HttpSession session) {
        MailVO mvo = memberLogic.createMailAndChangePassword(pMap);
        if (mvo != null) {
            memberLogic.sendEmail(mvo);
            session.setAttribute("successMessage", "비밀번호가 초기화 되었습니다.\\n임시 비밀번호가 메일로 전송 되었습니다.");
            return "member/findAccount";
        } else {
            session.setAttribute("errorMessage", "올바른 정보를 입력해주세요.");
            return "member/findAccount";
        }
    }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //WEB-INF/views/ 아래 jsp들 호출하는 메소드

    /**
     * 회원 가입 페이지를 반환
     * @param pMap 회원 가입에 필요한 초기 데이터를 담은 맵
     * @param model 뷰에 데이터를 전달하는 데 사용
     * @return 회원 가입 페이지 경로
     */
    @GetMapping(value = "signUp")
    public String test(@RequestParam Map<String, Object> pMap, Model model) {
        String insertEmail = (String) pMap.get("m_email");
        model.addAttribute("m_email", insertEmail);
        return "member/signUp";
    }

    /**
     * 로그인 페이지를 반환
     * @return 로그인 페이지 경로
     */
    @GetMapping("login")
    public String test2() {
        return "member/login";
    }

    /**
     * 계정 찾기 페이지를 반환
     * @return 계정 찾기 페이지 경로
     */
    @GetMapping("findAccount")
    public String test3() {
        return "member/findAccount";
    }
}
