package com.jsp.jsp_demo.controller.mypage;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.auth.UserOutput;
import com.jsp.jsp_demo.service.auth.AuthService;
import com.jsp.jsp_demo.service.mypage.MypageService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/* TODO:
 *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 *  ┃
 *  ┃    ● MyPageController
 *  ┃
 *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
@Controller
public class MypageController {

    // TODO : AuthService
    @Autowired
    AuthService authService;

    // TODO : MypageService
    @Autowired
    MypageService mypageService;

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 마이페이지 화면
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/mypage")
    public String mypage(
            HttpServletRequest request,
            Model model
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");

        try {
            // TODO: 세션에서 userId 가져오기
            HttpSession session = request.getSession(false);
            UserInput userInput = new UserInput();

            userInput.setUserId((String) session.getAttribute("userId"));

            UserOutput currentUserInfo = authService.selectUserById(userInput);

            System.out.println(currentUserInfo.getPhone());

            model.addAttribute("currentUserInfo", currentUserInfo);

        } catch (Exception e) {
            traceWriter.add("[Error] : " + e);
            return "main/main";
        } finally {
            traceWriter.log(0);
        }
        return "mypage/mypage";
    }

    @ResponseBody
    @PostMapping("/mypage/resetPass")
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
