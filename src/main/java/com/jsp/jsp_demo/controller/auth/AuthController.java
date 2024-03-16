package com.jsp.jsp_demo.controller.auth;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.auth.UserOutput;
import com.jsp.jsp_demo.service.auth.AuthService;
import oracle.jrockit.jfr.jdkevents.throwabletransform.ConstructorTracerWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    @GetMapping("/")
    public String defaultPage() {
        return "index";
    }

    @GetMapping("/login")
    public String getLogin() {
        return "login/login";
    }

    @ResponseBody
    @PostMapping("/auth/signup")
    public int signup(HttpServletRequest request,
                         UserInput userInput) {

        int result = 0;

        ConstructorTracerWriter constructorTracerWriter;

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
    public UserOutput login(
            UserInput userInput
    ) {
        UserOutput loginUserInfo = authService.selectUserByNm(userInput);

        return  loginUserInfo;
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
}
