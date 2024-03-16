package com.jsp.jsp_demo.service.auth;

import com.jsp.jsp_demo.mapper.auth.AuthMapper;
import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.auth.UserOutput;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthService {

    @Autowired
    private AuthMapper authMapper;


    public void signup(UserInput userInput) {
        authMapper.signup(userInput);
    }

    public UserOutput selectUserByNm(UserInput userInput) {


        return authMapper.selectUserByNm(userInput);
    }
}
