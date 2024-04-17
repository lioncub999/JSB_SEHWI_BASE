package com.jsp.jsp_demo.controller.mypage;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.service.mypage.MypageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller
public class MypageController {

    @Autowired
    MypageService mypageService;

    @GetMapping("/mypage")
    public String mypage() {
        return "main/mypage";
    }

    @ResponseBody
    @PostMapping("/resetPass")
    public Boolean resetPassword(HttpServletRequest httpServletRequest,
                                 UserInput userInput) {

        try {
            mypageService.resetPassword(userInput);
        } catch (Exception e) {
            System.out.println(e);
        }
        return true;
    }
}
