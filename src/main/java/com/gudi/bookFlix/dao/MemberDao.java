/**
 * 회원 데이터 관리를 위한 DAO 클래스
 * 주요 기능: 회원 목록, 가입, 정보 수정, 탈퇴, 이메일/닉네임 체크, 로그인, 비밀번호 관리
 * MyBatis와 SqlSessionTemplate으로 데이터베이스 작업 수행
 *
 * 작성자: 김두호
 * 작성일: 2023-07-31
 */

package com.gudi.bookFlix.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.gudi.bookFlix.vo.MemberVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Repository
public class MemberDao {
    Logger logger = LoggerFactory.getLogger(MemberDao.class);
    @Autowired
    private SqlSessionTemplate sqlSessionTemplate = null;


    /**
     * 회원 목록을 데이터베이스에서 조회
     * @param pMap 조회에 필요한 매개변수
     * @return 회원 목록
     */
    public List<Map<String, Object>> memberList(Map<String, Object> pMap) {
        List<Map<String, Object>> mList = null;
        mList = sqlSessionTemplate.selectList("memberList", pMap);
        return mList;
    }

    /**
     * 회원 가입 처리
     * @param pMap 회원 가입에 필요한 사용자 정보
     * @return 처리 결과 (성공 시 1, 실패 시 -1)
     */
    public int memberInsert(Map<String, Object> pMap) {
        int result =-1;
        result = sqlSessionTemplate.insert("memberInsert", pMap);
        logger.info(String.valueOf(result));
        return result;
    }

    /**
     * 회원 정보 수정
     * @param pMap 수정할 회원 정보
     * @return 처리 결과 (성공 시 1, 실패 시 -1)
     */
    public int updateMember(Map<String, Object> pMap) {
        int result =-1;
        result = sqlSessionTemplate.update("updateMember", pMap);
        logger.info(String.valueOf(result));
        return result;
    }

    /**
     * 회원 탈퇴 처리
     * @param pMap 탈퇴할 회원의 정보
     * @return 처리 결과 (성공 시 1, 실패 시 -1)
     */
    public int memberDelete(Map<String, Object> pMap) {
        int result =-1;
        result = sqlSessionTemplate.delete("memberDelete", pMap);
        logger.info("Dao"+String.valueOf(result));
        return result;
    }

    /**
     * 이메일 중복 체크
     * @param pMap 체크할 이메일 정보
     * @return 중복 여부 (중복 시 1, 아니면 0)
     */
    public int checkEmail(Map<String, Object> pMap){
        int result = -1;
        result = sqlSessionTemplate.selectOne("checkEmail", pMap);
        return result;
    }

    /**
     * 닉네임 중복 체크
     * @param pMap 체크할 닉네임 정보
     * @return 중복 여부 (중복 시 1, 아니면 0)
     */
    public int checkNickname(Map<String, Object> pMap) {
        logger.info("checkNickname");
        logger.info("pMap!!!!!!!!!!!!!!!!!! : " + pMap);
        int result = -1;
        result = sqlSessionTemplate.selectOne("checkNickname", pMap);
        logger.info("result!!!!!!!! : " + result);
        return result;
    }

    /**
     * 로그인 시 이메일과 비밀번호 확인
     * @param pMap 사용자의 이메일과 비밀번호
     * @return 사용자 정보 (로그인 성공 시), 아니면 null (로그인 실패 시)
     */
    public Map<String, Object> loginCheck(Map<String, Object> pMap) {
        Map<String, Object> user = null;
        user = sqlSessionTemplate.selectOne("loginCheck", pMap);
        logger.info("userMap!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+user);
        return user;
    }

    /**
     * 가입된 이메일 계정 찾기
     * @param pMap 이메일 계정 찾기에 필요한 사용자 정보
     * @return 찾아진 이메일 정보
     */
    public Map<String, Object> findEmail(Map<String, Object> pMap) {
        Map<String, Object> email = null;
        email = sqlSessionTemplate.selectOne("findEmail", pMap);
        logger.info("emailMap!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+email);
        return email;
    }

    /**
     * 비밀번호 변경
     * @param pMap 변경할 비밀번호 정보를 담은 맵
     * @return 처리 결과 (성공 시 1, 실패 시 -1)
     */
    public int updatePassword(Map<String, Object> pMap){
        int result = -1;
        result = sqlSessionTemplate.update("updatePassword", pMap);
        return result;
    }

    /**
     * 회원 고유번호를 가져옴
     * @param pMap 회원 고유번호를 찾기 위한 정보
     * @return 회원 고유번호
     */
    public Map<String, Object> getId(Map<String, Object> pMap) {
        Map<String, Object> userId = null;
        userId = sqlSessionTemplate.selectOne("getId", pMap);
        logger.info("userIdMap!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+userId);
        return userId;
    }

    /**
     * 회원 이름을 조회
     * @param pMap 회원 이름 조회에 필요한 정보
     * @return 회원 이름
     */
    public String getName(Map<String, Object> pMap) {
        String userName = null;
        userName = sqlSessionTemplate.selectOne("getName", pMap);
        return userName;
    }

    /**
     * 회원 정보를 조회
     * @param pMap 회원 정보 조회에 필요한 정보
     * @return 회원 정보
     */
    public Map<String, Object> getInfo(Map<String, Object> pMap) {
        Map<String, Object> userInfo= new HashMap<>();
        userInfo = sqlSessionTemplate.selectOne("getInfo", pMap);
        return userInfo;
    }

    /**
     * 비밀번호 일치 여부를 확인
     * @param cPass 비밀번호 확인에 필요한 정보
     * @return 일치 여부 (일치 시 1, 불일치 시 0)
     */
    public int checkPassword(Map<String, Object> cPass) {
        int result = -1;
        result = sqlSessionTemplate.selectOne("checkPassword", cPass);
        return result;
    }

    /**
     * 회원 이름을 MemberVO 객체로 가져옴
     * @param m_name 조회할 회원 이름
     * @return 조회된 MemberVO 객체
     */
    public MemberVO getName(String m_name) {
        MemberVO mvo = new MemberVO();
        mvo = sqlSessionTemplate.selectOne("getUserName",m_name);
        return mvo;
    }
}
