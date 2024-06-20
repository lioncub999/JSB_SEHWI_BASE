package com.jsp.jsp_demo.controller.mypage;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.chicken.ChickenOutput;
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

@Controller
public class MypageController {

    @Autowired
    MypageService mypageService;

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
            UserInput user = new UserInput();
            user.setUserId((Integer) session.getAttribute("userId"));

            // TODO: 내가 먹은 치킨 리스트 가져오기
            List<ChickenOutput> myChicken = mypageService.getMyChicken(user);
            List<ChickenOutput> myHis = mypageService.getMyHis(user);

            model.addAttribute("myChicken", myChicken);
            model.addAttribute("myHis", myHis);
            traceWriter.log(0);
        } catch (Exception e) {
            return "main/main";
        }
        return "main/mypage";
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
