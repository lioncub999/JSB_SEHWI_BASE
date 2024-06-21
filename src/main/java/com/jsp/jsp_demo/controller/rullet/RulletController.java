package com.jsp.jsp_demo.controller.rullet;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RulletController {

    @GetMapping("/rullet")
    public String rullet() {

        return "/main/rullet";
    }
}
