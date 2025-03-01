package com.jsp.jsp_demo.controller.auth;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.auth.UserOutput;
import com.jsp.jsp_demo.service.auth.AuthService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Objects;


/* TODO:
 *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 *  ┃
 *  ┃    ● AuthController
 *  ┃
 *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
@Controller
public class AuthController {

    // TODO: AuthService
    @Autowired
    private AuthService authService;

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 로그인 화면
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/login")
    public String getLogin() {
        return "auth/login";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 로그인 기능
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/auth/login")
    public String login(
            HttpServletRequest request,
            UserInput userInput
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("< INPUT >");
        traceWriter.add("[userInput.getUserId() : " + userInput.getUserId() + "]");
        traceWriter.add("");


        String result = "";

        try {
            // 유저 존재하는지 확인 (리턴값이 1이면 존재, 0이면 존재하지 않음)
            Integer userExistCheck = authService.selectUserCount(userInput);

            if (userExistCheck != 0) {
                UserOutput loginUserInfo = authService.signIn(userInput);

                if (loginUserInfo != null) {
                    request.getSession().invalidate();
                    HttpSession session = request.getSession(true);
                    session.setAttribute("userId", loginUserInfo.getUserId());
                    session.setAttribute("userNm", loginUserInfo.getUserNm());
                    session.setAttribute("userGrade", loginUserInfo.getUserGrade());
                    session.setAttribute("passReset", loginUserInfo.getPassReset());
                    session.setMaxInactiveInterval(1800);

                    result = "success";
                } else {
                    result = "passError";
                }
            } else {
                result = "noExist";
            }
        } catch (Exception e) {
            result = "error";
            traceWriter.add("[Error] : " + e);
        } finally {
            traceWriter.log(0);
        }

        return result;
    }


    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 회원 가입 페이지
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/auth/signUp")
    public String getSignUp() {
        return "auth/signUp";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 회원 가입 기능
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/auth/signUp")
    public String signup(HttpServletRequest request,
                         UserInput userInput) {

        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("< INPUT >");
        traceWriter.add("[userInput.getSignUpCode() : " + userInput.getSignUpCode() + "]");
        traceWriter.add("[userInput.getUserId() : " + userInput.getUserId() + "]");
        traceWriter.add("[userInput.getUserNm() : " + userInput.getUserNm() + "]");
        traceWriter.add("[userInput.getJobGrade() : " + userInput.getJobGrade() + "]");
        traceWriter.add("[userInput.getPhone() : " + userInput.getPhone() + "]");
        traceWriter.add("");

        userInput.setUserGrade("3");

        try {
            if (!Objects.equals(userInput.getSignUpCode(), "modusol24")) {

                return "codeError";
            }

            authService.signup(userInput);

            return "success";

        } catch (Exception e) {
            traceWriter.add("[Error] : " + e);
            return "error";
        } finally {
            traceWriter.log(0);
        }
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 아이디 중복확인 기능
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/auth/dupCheck")
    public int dupCheck(
            @RequestBody UserInput userInput
    ) {
        return authService.selectUserCount(userInput);
    }

    /*
     * TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 로그아웃 기능
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     */
    @ResponseBody
    @PostMapping("/auth/logout")
    public Boolean logout(
            HttpServletRequest httpServletRequest
    ) {
        httpServletRequest.getSession().invalidate();
        return true;
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 비밀번호 초기화 화면
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/resetPass")
    public String resetPass() {
        return "/login/passReset";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 비밀번호 초기화 기능 (비밀번호 1111로 초기화)
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/auth/resetPass")
    public Boolean resetPassFunc(
            HttpServletRequest httpServletRequest,
            UserInput userInput
    ) {
        boolean result;

        String userId = (String) httpServletRequest.getSession().getAttribute("userId");

        userInput.setUserId(userId);

        authService.updatePassword(userInput);

        HttpSession session = httpServletRequest.getSession(true);
        session.setAttribute("passReset", "N");

        result = true;

        return result;
    }
}
