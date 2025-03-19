package com.jsp.jsp_demo.controller.error;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class CustomErrorController implements ErrorController {

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 404 에러시 "/main" 으로 이동
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, HttpServletResponse response) {
        int status = response.getStatus();
        if (status == 404) {
            return "redirect:/video/videoMap"; // 404 에러 발생 시 "/main"으로 리다이렉션
        }
        return "/main"; // 기타 에러는 기본 에러 페이지로 이동
    }
}
