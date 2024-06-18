package com.jsp.jsp_demo.controller;

import com.jsp.jsp_demo.model.chicken.Chicken;
import com.jsp.jsp_demo.model.mypage.Mypage;
import com.jsp.jsp_demo.service.chicken.ChickenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class main {
    @Autowired
    ChickenService chickenService;

    @GetMapping("/main")
    public String getMainPage(
            Model model
    ) {

        List<Chicken> chickenList = chickenService.getChicken();
        List<Mypage> eatChickenClassify = chickenService.eatChickenClassify();

        model.addAttribute("chickenList",chickenList);
        model.addAttribute("eatChickenClassify", eatChickenClassify);

        return "main/main";
    }

    @GetMapping("/test")
    public String getTestPage(
            Model model
    ) {

        return "test/test";
    }
}
