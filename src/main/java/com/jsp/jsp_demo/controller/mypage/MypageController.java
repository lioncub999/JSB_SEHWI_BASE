package com.jsp.jsp_demo.controller.mypage;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.mypage.Mypage;
import com.jsp.jsp_demo.service.mypage.MypageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class MypageController {

    @Autowired
    MypageService mypageService;

    @GetMapping("/mypage")
    public String mypage(
            HttpServletRequest request,
            Model model
    ) {
        HttpSession session = request.getSession(false);
        UserInput user = new UserInput();
        user.setUserId((Integer) session.getAttribute("userId"));

        List<Mypage> mychicken =  mypageService.getMyChicken(user);

        model.addAttribute("mychicken", mychicken);

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
