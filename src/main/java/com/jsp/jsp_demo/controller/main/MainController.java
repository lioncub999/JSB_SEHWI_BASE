package com.jsp.jsp_demo.controller.main;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class MainController {

    @GetMapping("/main")
    public String getMainPage(
            Model model
    ) {

        return "main/main";
    }
}
