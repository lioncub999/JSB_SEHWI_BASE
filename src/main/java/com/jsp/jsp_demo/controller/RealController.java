package com.jsp.jsp_demo.controller;

import com.jsp.jsp_demo.service.RealService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class RealController {

    @Autowired
    private RealService realService;

    @GetMapping(value = "/hh")
    public String index(Model model) {
        int realNum = realService.getRealNum();

        System.out.println(realNum);


        model.addAttribute("realNum", realNum);
        return "index";
    }
}
