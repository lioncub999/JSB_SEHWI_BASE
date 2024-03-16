package com.jsp.jsp_demo.service;

import com.jsp.jsp_demo.mapper.LoginMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LoginService {

    @Autowired
    private LoginMapper realMapper;


}
