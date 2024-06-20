package com.jsp.jsp_demo.controller.auth;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.auth.UserOutput;
import com.jsp.jsp_demo.service.auth.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    @GetMapping("/login")
    public String getLogin() {
        return "login/login";
    }

    @ResponseBody
    @PostMapping("/auth/signup")
    public int signup(HttpServletRequest request,
                         UserInput userInput) {

        int result = 0;

        try {
            authService.signup(userInput);
            result = 1;
        }catch (Exception e) {
            System.out.println(e);
        }

        return result;
    }

    @ResponseBody
    @PostMapping("/auth/login")
    public Boolean login(
            HttpServletRequest httpServletRequest,
            UserInput userInput
    ) {
        boolean result = false;

        Integer userExistCheck = authService.selectUserCount(userInput);

        if (userExistCheck != 0 ) {
            UserOutput loginUserInfo = authService.selectUserByNm(userInput);

            if (loginUserInfo != null) {
                httpServletRequest.getSession().invalidate();
                HttpSession session = httpServletRequest.getSession(true);
                session.setAttribute("userId", loginUserInfo.getUserId());
                session.setAttribute("userNm", loginUserInfo.getUserNm());
                session.setAttribute("passReset", loginUserInfo.getPassReset());
                session.setMaxInactiveInterval(1800);

                result = true;
            }
        }

        return result;
    }

    @ResponseBody
    @PostMapping("/auth/dupcheck")
    public int dupcheck(
            UserInput userInput
    ) {
        int result = 0;

        result = authService.selectUserCount(userInput);

        return result;
    }

    @ResponseBody
    @PostMapping("/auth/logout")
    public Boolean logout(
            HttpServletRequest httpServletRequest
    ) {
        httpServletRequest.getSession().invalidate();
        return true;
    }

    @GetMapping("/resetPass")
    public String resetPass() {
        return "/login/passReset";
    }

    @ResponseBody
    @PostMapping("/auth/resetPass")
    public Boolean resetPassFunc(
            HttpServletRequest httpServletRequest,
            UserInput userInput
    ) {
        boolean result;

        int userId = (int) httpServletRequest.getSession().getAttribute("userId");

        userInput.setUserId(userId);

        authService.updatePassword(userInput);

        HttpSession session = httpServletRequest.getSession(true);
        session.setAttribute("passReset", "N");

        result = true;

        return result;
    }
}
