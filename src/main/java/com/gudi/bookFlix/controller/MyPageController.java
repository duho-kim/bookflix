/**
 * 사용자 마이페이지 관련 기능을 관리하는 컨트롤러
 * 사용자가 좋아하는 콘텐츠 목록과 Q&A 목록을 제공
 * 작성자 : 김두호
 * 최초 작성일 : 2023-08-16
 */

package com.gudi.bookFlix.controller;

import com.gudi.bookFlix.dao.QnaDao;
import com.gudi.bookFlix.logic.LikeLogic;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mypage/*")
public class MyPageController {

    @Autowired
    private LikeLogic likeLogic = null; // 사용자가 좋아하는 콘텐츠 관련 로직을 처리하기 위한 객체

    @Autowired
    private QnaDao qnaDao = null; // 사용자 Q&A 관련 데이터 접근 객체

    /**
     * 사용자 마이페이지에서 특정 타입의 콘텐츠를 가져옴
     * contentType에 따라 좋아하는 콘텐츠 목록이나 Q&A 목록을 반환
     * @param contentType 가져올 콘텐츠의 타입 ('likeList' 또는 'qList')
     * @param model 뷰에 데이터를 전달하는 데 사용
     * @param session 현재 사용자의 세션 정보
     * @return 지정된 타입의 마이페이지 뷰 경로
     */
    @GetMapping("{contentType}")
    public String getContent(@PathVariable String contentType, Model model, HttpSession session) {
        String userId = (String)session.getAttribute("m_id");
        Map<String, Object> sessionMap = new HashMap<>();
        sessionMap.put("m_id", userId);
        List<Map<String, Object>> likeList = null;
        List<Map<String, Object>> qList = null;
        Map<String, Object> data = new HashMap<>();

        likeList = likeLogic.myLikeList(sessionMap);
        qList = qnaDao.qnaListMem(Integer.parseInt(userId));
        data.put("likeList", likeList);
        data.put("qList", qList);

        model.addAttribute("data", data);

        return "mypage/"+contentType; // 해당하는 JSP 파일의 경로를 반환
    }
}