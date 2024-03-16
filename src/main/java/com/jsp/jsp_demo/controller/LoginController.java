package com.jsp.jsp_demo.controller;

import com.jsp.jsp_demo.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

    @Autowired
    private LoginService realService;

    @GetMapping("/")
    public String getLogin() {
        return "login/login";
    }
}
