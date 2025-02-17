package com.jsp.jsp_demo.controller.video_req;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.auth.UserOutput;
import com.jsp.jsp_demo.model.video.VideoReq;
import com.jsp.jsp_demo.service.main.MainService;
import com.jsp.jsp_demo.service.video.VideoReqService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/* TODO:
 *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 *  ┃
 *  ┃    ● VideoReqController
 *  ┃
 *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
@Controller
public class VideoReqController {

    @Value("${naver.maps.client.id}")
    private String naverMapsClientId;

    // TODO: VideoReqService
    @Autowired
    VideoReqService videoReqService;

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 비디오 신청 리스트 페이지
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/videoReq")
    public String getVideoReqPage(
            HttpServletRequest request,
            Model model
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");


        try {
        } catch (Exception e) {
            traceWriter.add("Exception : " + e);

        }

        traceWriter.log(0);

        return "video_req/video_req_main";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 비디오 신청 추가 페이지로 이동
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/videoReq/reqCreate")
    public String getVideoReqCreate(
            HttpServletRequest request,
            Model model
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");

        try {
            model.addAttribute("naverMapsClientId", naverMapsClientId);
        } catch (Exception e) {
            traceWriter.add("Exception : " + e);
        }

        traceWriter.log(0);

        return "video_req/video_req_create";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 촬영 신청 기능
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/videoReq/reqCreate")
    public String createVideoReq(
            HttpServletRequest request,
            VideoReq videoReq
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("< INPUT >");
        traceWriter.add("[userInput.getStoreNm() : " + videoReq.getStoreNm() + "]");
        traceWriter.add("[userInput.getContractDt() : " + videoReq.getContractDt() + "]");
        traceWriter.add("[userInput.getPhone() : " + videoReq.getPhone() + "]");
        traceWriter.add("[userInput.getAddress() : " + videoReq.getAddress() + "]");
        traceWriter.add("[userInput.getLongitude() : " + videoReq.getLongitude() + "]");
        traceWriter.add("[userInput.getLatitude() : " + videoReq.getLatitude() + "]");
        traceWriter.add("[userInput.getNote() : " + videoReq.getNote() + "]");
        traceWriter.add("");


        String result = "";

        try {
//            String userId = (String) request.getSession().getAttribute("userId");
            videoReq.setCreId(videoReq.getCreId());

            videoReqService.createVideoReq(videoReq);

            result = "success";

        } catch (Exception e) {
            result = "error";
            traceWriter.add("[Error] : " + e);
        } finally {
            traceWriter.log(0);
        }

        return result;
    }
}
