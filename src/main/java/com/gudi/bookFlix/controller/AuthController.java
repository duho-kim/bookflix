/**
 * 카카오, 구글 소셜 로그인을 관리하는 컨트롤러
 * 카카오, 구글 API를 통해 OAuth 인증을 수행하고 사용자 정보를 가져옴
 * 작성자 : 김두호
 * 최초 작성일 : 2023-08-12
 * 최종 수정일 : 2024-01-09
 */

package com.gudi.bookFlix.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gudi.bookFlix.logic.AuthLogic;
import com.gudi.bookFlix.logic.MemberLogic;
import com.gudi.bookFlix.vo.*;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;


@Controller
@RequiredArgsConstructor
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
     *
     * @param code    카카오 인증 서버로부터 받은 인증 코드
     * @param session 현재 사용자의 세션
     * @param rab     리다이렉트 시 메시지를 전달하는 데 사용
     * @return 로그인 성공 또는 실패에 따라 적절한 페이지로 리다이렉트
     */
    @GetMapping("/kakao/callback")
    public String kakaoCallback(String code, HttpSession session, RedirectAttributes rab) {
        RestTemplate rt = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        // 카카오 토큰 요청에 필요한 파라미터 설정
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", "8918d4c80ecdff016de9769242b13044");
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
        try {
            authVO = objectMapper.readValue(response.getBody(), AuthVO.class);
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        //객체로 저장한 토큰정보(access_token) 통해 사용자 프로필 요청
        // 사용자 프로필 정보를 요청하기 위한 RestTemplate
        RestTemplate rt_ = new RestTemplate();

        HttpHeaders headers_ = new HttpHeaders();
        headers_.add("Authorization", "Bearer " + authVO.getAccess_token());
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

        try {
            String responseBody = response_.getBody();
            //System.out.println("응답 본문: " + responseBody);
            //System.out.println("이건 어때 : " + objectMapper_.readValue(response_.getBody(), KakaoProfile.class));
            kakaoProfile = objectMapper_.readValue(response_.getBody(), KakaoProfile.class);
            //System.out.println("카카오프로필이다 : " + kakaoProfile);
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (JsonProcessingException e) {
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

        // DB에서 회원 이메일로 회원 정보 조회
        Map<String, Object> userInfo = memberLogic.getInfo(kmap);

        if (userInfo != null && !userInfo.isEmpty()) {
            Object oauth = userInfo.get("oauth");
            // 기존 회원 정보가 있는 경우
            if (oauth != null && oauth.equals(kmap.get("oauth"))) {
                // 동일한 소셜 로그인 방식일때
                // 로그인 처리 로직
                return processLogin(kmap, session, rab);
            } else {
                // 다른 소셜 로그인 방식이거나, 홈페이지 로그인일때 오류 메세지 출력
                rab.addFlashAttribute("socialErrorMessage", "이미 등록되어 있는 이메일입니다.");
                return "redirect:/member/login";
            }
        } else {
            // 새 회원으로 DB에 등록
            memberLogic.memberInsert(kmap);
            // 로그인 처리 로직
            return processLogin(kmap, session, rab);
        }
    }
/*        if (userInfo != null && !userInfo.isEmpty()) {
            // 이메일이 기존 회원과 중복됨
            // 사용자에게 이미 등록된 이메일임을 알리고, 계정 연동 또는 다른 이메일 사용을 선택하게 함
            rab.addFlashAttribute("socialErrorMessage", "이미 등록되어 있는 이메일입니다.");
            return "redirect:/member/login"; // 로그인 페이지 또는 적절한 페이지로 리다이렉트
        } else {
            // 새 회원으로 DB에 등록
            memberLogic.memberInsert(kmap);
        }*/



    @Value("${google.client.id}")
    private String googleClientId;
    @Value("${google.client.pw}")
    private String googleClientPw;

    // Google 로그인을 위한 URL을 생성하고, 사용자를 Google 로그인 페이지로 리다이렉트하는 메서드
    @GetMapping(value = "/google/login")
    public void loginUrlGoogle(HttpServletResponse response) {
        String reqUrl = "https://accounts.google.com/o/oauth2/v2/auth?client_id=" + googleClientId
                + "&redirect_uri=http://localhost:8000/auth/google/callback&response_type=code&scope=email%20profile%20openid&access_type=offline";
        try {
            // 구글 로그인 페이지로 리다이렉트
            response.sendRedirect(reqUrl);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Google OAuth 인증 후 콜백 메소드
     * Google에서 제공한 코드를 사용하여 액세스 토큰을 요청하고 해당 토큰을 사용하여 사용자의 프로필 정보를 가져옴
     * 사용자가 새로운 사용자일 경우 회원 정보를 등록하고, 기존 사용자일 경우 로그인 처리를 수행
     * 로그인 성공 시 사용자 정보를 세션에 저장하고 메인 페이지로 리다이렉트
     *
     * @param authCode Google 인증 서버로부터 받은 인증 코드
     * @param session 현재 사용자의 세션
     * @param rab 리다이렉트 시 메시지를 전달하는 데 사용
     * @return 로그인 성공 또는 실패에 따라 적절한 페이지로 리다이렉트
     */
    @GetMapping(value="/google/callback")
    public String loginGoogle(@RequestParam(value = "code") String authCode, HttpSession session, RedirectAttributes rab){
        RestTemplate restTemplate = new RestTemplate();

        // Google OAuth 인증을 위한 요청 파라미터 설정
        GoogleRequest googleOAuthRequestParam = GoogleRequest
                .builder()
                .clientId(googleClientId)
                .clientSecret(googleClientPw)
                .code(authCode)
                .redirectUri("http://localhost:8000/auth/google/callback")
                .grantType("authorization_code").build();

        // Google OAuth 서버에 토큰 요청을 보내고 응답받기
        ResponseEntity<GoogleResponse> resultEntity = restTemplate.postForEntity("https://oauth2.googleapis.com/token",
                googleOAuthRequestParam, GoogleResponse.class);
        String jwtToken=resultEntity.getBody().getId_token();

        Map<String, String> map=new HashMap<>();
        map.put("id_token",jwtToken);

        // 사용자 정보를 조회
        ResponseEntity<GoogleInfResponse> resultEntity2 = restTemplate.postForEntity("https://oauth2.googleapis.com/tokeninfo",
                map, GoogleInfResponse.class);
        String email = resultEntity2.getBody().getEmail();
        String name = resultEntity2.getBody().getName();

        // DB에서 회원 정보 조회
        Map<String, Object> googleEmail = new HashMap<>();
        googleEmail.put("m_email", email);

        Map<String, Object> userInfo = memberLogic.getInfo(googleEmail);

        Map<String, Object> gmap = new HashMap<>();
        gmap.put("m_name", name);
        gmap.put("m_pw", cosKey);
        gmap.put("m_email", email);
        gmap.put("m_nickname", name);
        gmap.put("oauth", "google");

        if (userInfo != null && !userInfo.isEmpty()) {
            Object oauth = userInfo.get("oauth");
            // 기존 회원 정보가 있는 경우
            if (oauth != null && oauth.equals(gmap.get("oauth"))) {
                // 동일한 소셜 로그인 방식일때
                // 로그인 처리 로직
                return processLogin(gmap, session, rab);
            } else {
                // 다른 소셜 로그인 방식이거나, 홈페이지 로그인일때 오류 메세지 출력
                rab.addFlashAttribute("socialErrorMessage", "이미 등록되어 있는 이메일입니다.");
                return "redirect:/member/login";
            }
        } else {
            // 새 회원으로 DB에 등록
            memberLogic.memberInsert(gmap);
            // 로그인 처리 로직
            return processLogin(gmap, session, rab);
        }
    }

    // 로그인 처리 메소드
    private String processLogin(Map<String, Object> uMap, HttpSession session, RedirectAttributes rab) {
        Map<String, Object> user = memberLogic.loginCheck(uMap);

        // 로그인 성공 시, 세션에 사용자 정보 설정
        if (user != null && !user.isEmpty()) {
            // 로그인 성공
            session.setAttribute("member", user.toString());
            session.setAttribute("m_name", user.get("m_name").toString());
            session.setAttribute("m_id", user.get("m_id").toString());
            session.setAttribute("m_email", user.get("m_email").toString());
            session.setAttribute("m_admin", user.get("m_admin").toString());
            session.setAttribute("m_nickname", user.get("m_nickname").toString());
            if (user.get("m_phone") != null) {
                session.setAttribute("m_phone", user.get("m_phone").toString());
            }
            return "redirect:/book/main"; // 로그인 성공 페이지로 리다이렉트
        } else {
            // 로그인 실패 시, 오류 메시지 설정 및 로그인 폼 페이지로 리다이렉트
            rab.addFlashAttribute("errorMessageLogin", "로그인 실패!");
            return "redirect:/member/login";
        }
    }

    // 자동 로그인 시 사용되는 키
    // 개인정보 수정할 경우 비밀번호 재입력을 해야해서 필요하지만,
    // 사용자는 알수가 없으므로 개선이 필요한 부분
    @Value("${cos.key}")
    private String cosKey;
}
