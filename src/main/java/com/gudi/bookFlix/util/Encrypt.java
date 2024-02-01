package com.gudi.bookFlix.util;

import org.springframework.stereotype.Component;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

@Component
public class Encrypt {
    //솔트값 생성 메서드
    public String getSalt(){
        SecureRandom random = new SecureRandom();
        byte[] saltBytes = new byte[16];
        random.nextBytes(saltBytes);
        // 바이트 배열을 Base64 인코딩
        String salt = Base64.getEncoder().encodeToString(saltBytes);

        return salt;
    }

    // 비밀번호+솔트값 -> 해시 생성
    public String getEncrypt(String pw, String salt){
        String sha = "";
        MessageDigest md;
        {
            try {
                md = MessageDigest.getInstance("SHA-256");
                md.update((pw+salt).getBytes());
                byte[] byte_pw = md.digest();
                StringBuffer sb = new StringBuffer();

                // 바이트 배열 16진수 문자열로 변환
                for (int i=0 ; i<byte_pw.length ; i++){
                    sb.append(String.format("%02x",byte_pw[i]));
                }
                sha = sb.toString();
            } catch (NoSuchAlgorithmException e) {
                throw new RuntimeException(e);
            }
        }
        return sha;
    }
}
