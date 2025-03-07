package com.jsp.jsp_demo.controller.mypage;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.auth.UserOutput;
import com.jsp.jsp_demo.model.paging.PagingModel;
import com.jsp.jsp_demo.model.video.VideoReqOutput;
import com.jsp.jsp_demo.service.auth.AuthService;
import com.jsp.jsp_demo.service.video.VideoReqService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

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

    // TODO : VideoReqService
    @Autowired
    VideoReqService videoReqService;

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 마이페이지 화면
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/mypage")
    public String mypage(
            HttpServletRequest request,
            @RequestParam(value = "curPage", defaultValue = "1") int curPage,
            Model model
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");

        // 1페이지당 글 개수
        int pageSize = 10;
        // 한 화면에 보여줄 페이지 번호
        int pageBlock = 10;

        try {
            // TODO: 세션에서 userId 가져오기
            HttpSession session = request.getSession(false);
            UserInput userInput = new UserInput();

            PagingModel pagingModel = new PagingModel();
            pagingModel.setSearchUserId((String) session.getAttribute("userId"));

            Integer totalMyReqCount = 0;

            if (session.getAttribute("userGrade").equals("0")) {
                totalMyReqCount = videoReqService.getMyReqCountForPhotographer(pagingModel);
            } else {
                totalMyReqCount = videoReqService.getMyReqCountForSales(pagingModel);
            }

            // 전체 게시글 수 가져오기 (DB에서)
            int maxPage = (totalMyReqCount / pageSize) + (totalMyReqCount % pageSize == 0 ? 0 : 1);
            int startPage = ((curPage - 1) / pageBlock) * pageBlock + 1;
            int endPage = Math.min(startPage + pageBlock - 1, maxPage);

            pagingModel.setStartRow((curPage - 1) * pageSize);
            pagingModel.setPageSize((pageSize));

            List<VideoReqOutput> videoReqList;

            if (session.getAttribute("userGrade").equals("0")) {
                videoReqList = videoReqService.getMyReqListForPhotographer(pagingModel);
            } else {
                videoReqList = videoReqService.getMyReqListForSales(pagingModel);
            }


            userInput.setUserId((String) session.getAttribute("userId"));
            UserOutput currentUserInfo = authService.selectUserById(userInput);

            model.addAttribute("currentUserInfo", currentUserInfo);
            model.addAttribute("curPage", curPage);
            model.addAttribute("videoReqList", videoReqList);
            model.addAttribute("totalMyReqCount", totalMyReqCount);
            model.addAttribute("maxPage", maxPage);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);


        } catch (Exception e) {
            traceWriter.add("[Error] : " + e);
            return "main/main";
        } finally {
            traceWriter.log(0);
        }
        return "mypage/mypage";
    }
}
