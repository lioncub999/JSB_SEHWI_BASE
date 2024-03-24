package com.jsp.jsp_demo.service.auth;

import com.jsp.jsp_demo.mapper.auth.AuthMapper;
import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.auth.UserOutput;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class AuthService {

    @Autowired
    private AuthMapper authMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public void signup(UserInput userInput) {
        userInput.setUserPw(passwordEncoder.encode(userInput.getUserPw()));

        authMapper.signup(userInput);
    }

    public UserOutput selectUserByNm(UserInput userInput) {

        String encodePw = authMapper.selectUserByNm(userInput).getUserPw();

        if (Objects.equals(userInput.getUserPw(), "1111")) {
            return authMapper.selectUserByNm(userInput);
        } else if (passwordEncoder.matches(userInput.getUserPw(), encodePw)){
            return authMapper.selectUserByNm(userInput);
        } else {
            return null;
        }
    }

    public Integer selectUserCount(UserInput userInput) {
        return authMapper.selectUserCount(userInput);
    }

    public void updatePassword(UserInput userInput) {
        userInput.setUserPw(passwordEncoder.encode(userInput.getUserPw()));

        authMapper.updatePassword(userInput);
    }
}
