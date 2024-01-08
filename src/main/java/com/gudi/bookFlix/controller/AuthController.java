/**
 * 카카오 로그인을 관리하는 컨트롤러
 * 카카오 API를 통해 OAuth 인증을 수행하고 사용자 정보를 가져옴
 * 작성자 : 김두호
 * 최초 작성일 : 2023-08-12
 */

package com.gudi.bookFlix.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gudi.bookFlix.logic.AuthLogic;
import com.gudi.bookFlix.logic.MemberLogic;
import com.gudi.bookFlix.vo.AuthVO;
import com.gudi.bookFlix.vo.KakaoProfile;
import com.gudi.bookFlix.vo.MemberVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;


@Controller
@RequestMapping("/auth/*")
public class AuthController {
    Logger logger = LoggerFactory.getLogger(AuthController.class);
    @Autowired
    private AuthLogic authLogic = null;

    @Autowired
    private MemberLogic memberLogic = null;


    /**
     * 카카오 OAuth 인증 후 콜백 메소드
     * 카카오에서 제공한 코드를 사용하여 액세스 토큰을 요청하고,
     * 해당 토큰을 사용하여 사용자의 프로필 정보를 가져옴
     * @param code 카카오 인증 서버로부터 받은 인증 코드
     * @param session 현재 사용자의 세션
     * @param rab 리다이렉트 시 메시지를 전달하는 데 사용
     * @return 로그인 성공 또는 실패에 따라 적절한 페이지로 리다이렉트
     */
    @GetMapping("/kakao/callback")
    public String kakaoCallback(String code, HttpSession session, RedirectAttributes rab){
        //post방식으로 key=value 데이터 요청(카카오쪽으로)
        RestTemplate rt = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        // 카카오 토큰 요청에 필요한 파라미터 설정
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type","authorization_code");
        params.add("client_id","8918d4c80ecdff016de9769242b13044");
        params.add("redirect_uri", "http://localhost:8000/auth/kakao/callback");
        params.add("code", code);

        HttpEntity<MultiValueMap<String, String>> kakaoTokenRequest = new HttpEntity<>(params, headers);

        // 카카오 토큰 발급 API 호출
        ResponseEntity<String> response = rt.exchange(
                "https://kauth.kakao.com/oauth/token",
                HttpMethod.POST,
                kakaoTokenRequest,
                String.class
        );

        System.out.println("Kakao API Response: " + response.getBody());

        // ObjectMapper를 사용하여 응답 JSON을 AuthVO 객체로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        AuthVO authVO = null;
        try{
            authVO = objectMapper.readValue(response.getBody(), AuthVO.class);
        } catch (JsonMappingException e){
            e.printStackTrace();
        } catch (JsonProcessingException e){
            e.printStackTrace();
        }

        //객체로 저장한 토큰정보(access_token) 통해 사용자 프로필 요청
        // 사용자 프로필 정보를 요청하기 위한 RestTemplate
        RestTemplate rt_ = new RestTemplate();

        HttpHeaders headers_ = new HttpHeaders();
        headers_.add("Authorization","Bearer " + authVO.getAccess_token());
        headers_.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        // 프로필 요청을 위한 HttpEntity
        HttpEntity<MultiValueMap<String, String>> kakaoProfileRequest =
                new HttpEntity<>(headers_);

        // 카카오 사용자 프로필 API 호출
        ResponseEntity<String> response_ = rt_.exchange(
                "https://kapi.kakao.com/v2/user/me",
                HttpMethod.POST,
                kakaoProfileRequest,
                String.class
        );

        System.out.println(response_.getBody());

        // ObjectMapper를 사용하여 응답 JSON을 KakaoProfile 객체로 변환
        ObjectMapper objectMapper_ = new ObjectMapper();
        objectMapper_.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        KakaoProfile kakaoProfile = null;

        try{
            String responseBody = response_.getBody();
            System.out.println("응답 본문: " + responseBody);
            System.out.println("이건 어때 : "+ objectMapper_.readValue(response_.getBody(), KakaoProfile.class));
            kakaoProfile = objectMapper_.readValue(response_.getBody(), KakaoProfile.class);
            System.out.println("카카오프로필이다 : "+kakaoProfile);
        } catch (JsonMappingException e){
            e.printStackTrace();
        } catch (JsonProcessingException e){
            e.printStackTrace();
        }

        // 카카오 프로필 정보를 바탕으로 MemberVO 객체 생성
        MemberVO kakaoUser = MemberVO.builder()
                .m_name(kakaoProfile.getProperties().getNickname())
                .m_pw(cosKey)
                .m_email(kakaoProfile.getKakao_account().getEmail())
                .m_nickname(kakaoProfile.getProperties().getNickname())
                .oauth("kakao").build();

        // 카카오 프로필 정보를 바탕으로 사용자 DB에서 기존 회원 정보 확인
        // 없으면 새로운 회원으로 DB에 추가
        Map<String, Object> kmap = new HashMap<>();

        kmap.put("m_name", kakaoProfile.getProperties().getNickname());
        kmap.put("m_pw", cosKey);
        kmap.put("m_email", kakaoProfile.getKakao_account().getEmail());
        kmap.put("m_nickname", kakaoProfile.getProperties().getNickname());
        kmap.put("oauth", "kakao");

        // DB에서 회원 이름으로 회원 정보 조회
        MemberVO originUser = memberLogic.getName(kakaoUser.getM_name());

        // DB에 회원 정보가 없는 경우, 새 회원으로 등록
        if(originUser == null || originUser.getM_name() == null){
            memberLogic.memberInsert(kmap);
        }

        // 로그인 체크를 수행하고 결과를 Map 객체로 받음
        Map<String, Object> user =  null;
        user = memberLogic.loginCheck(kmap);

        // 로그인 성공 시, 세션에 사용자 정보 설정
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
            // 로그인 실패 시, 오류 메시지 설정 및 로그인 폼 페이지로 리다이렉트
            rab.addFlashAttribute("errorMessageLogin", "로그인 실패!");
            return "redirect:login";
        }
    }

    // 카카오 로그인을 수행할 때 사용되는 비밀번호 키
    @Value("${cos.key}")
    private String cosKey;
}
