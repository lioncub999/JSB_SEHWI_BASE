package com.jsp.jsp_demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class main {

    @GetMapping("/main")
    public String getMainPage() {
        return "main/main";
    }
}
