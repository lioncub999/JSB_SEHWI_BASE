package com.jsp.jsp_demo.controller.video;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jsp.jsp_demo.model.paging.PagingModel;
import com.jsp.jsp_demo.model.search.SearchModel;
import com.jsp.jsp_demo.model.statistics.Spend;
import com.jsp.jsp_demo.model.statistics.Statistics;
import com.jsp.jsp_demo.model.video.VideoReq;
import com.jsp.jsp_demo.model.video.VideoReqInput;
import com.jsp.jsp_demo.model.video.VideoReqOutput;
import com.jsp.jsp_demo.service.statistics.StatisticsService;
import com.jsp.jsp_demo.service.video.VideoReqService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Objects;

/* TODO:
 *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 *  ┃
 *  ┃    ● VideoController
 *  ┃
 *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
@Controller
public class VideoController {
    // TODO : MainService
    @Autowired
    VideoReqService videoReqService;

    @Autowired
    StatisticsService statisticsService;

    @Value("${naver.maps.client.id}")
    private String naverMapsClientId;

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 영상촬영관리 지도 페이지
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/video/videoMap")
    public String getVideoMap(
            HttpServletRequest request,
            Model model
    ) {
        ObjectMapper objectMapper = new ObjectMapper();

        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");

        try {

            List<VideoReqOutput> videoReqList = videoReqService.getUnStartedVideoReq();

            String reqList = objectMapper.writeValueAsString(videoReqList);

            model.addAttribute("reqList", reqList);
            model.addAttribute("naverMapsClientId", naverMapsClientId);
        } catch (Exception e) {
            traceWriter.add("Exception : " + e);
        }

        traceWriter.log(0);

        return "video/video-map";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 비디오 신청 리스트 페이지
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/video/videoReqList")
    public String getVideoReqListPage(
            @RequestParam(value = "curPage", defaultValue = "1") int curPage,
            @RequestParam(value = "searchStoreNm", defaultValue = "") String searchStoreNm,
            @RequestParam(value = "searchPhone", defaultValue = "") String searchPhone,
            HttpServletRequest request,
            Model model
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");

        // 1페이지당 글 개수
        int pageSize = 10;
        // 한 화면에 보여줄 페이지 번호
        int pageBlock = 10;

        try {
            PagingModel pagingModel = new PagingModel();
            pagingModel.setSearchStoreNm(searchStoreNm);
            pagingModel.setSearchPhone(searchPhone);

            Integer totalReqCount = videoReqService.getAllReqCount(pagingModel);

            // 전체 게시글 수 가져오기 (DB에서)
            int maxPage = (totalReqCount / pageSize) + (totalReqCount % pageSize == 0 ? 0 : 1);
            int startPage = ((curPage - 1) / pageBlock) * pageBlock + 1;
            int endPage = Math.min(startPage + pageBlock - 1, maxPage);

            pagingModel.setStartRow((curPage - 1) * pageSize);
            pagingModel.setPageSize((pageSize));


            List<VideoReqOutput> videoReqList = videoReqService.getReqList(pagingModel);


            model.addAttribute("curPage", curPage);
            model.addAttribute("totalReqCount", totalReqCount);
            model.addAttribute("maxPage", maxPage);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);
            model.addAttribute("videoReqList", videoReqList);
        } catch (Exception e) {
            traceWriter.add("Exception : " + e);

        }

        traceWriter.log(0);

        return "video/video-req-list";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 비디오 신청 페이지
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/video/videoReqCreate")
    public String getVideoReqCreatePage(
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

        return "video/video-req-create";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 비디오 통계&정산 페이지
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("video/videoStatistics")
    public String getVideoStatisticsPage(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestParam(value = "selectedYear", defaultValue = "") String selectedYear,
            @RequestParam(value = "selectedMonth", defaultValue = "") String selectedMonth,
            Model model
    ) throws IOException {
        if (!"0".equals(request.getSession().getAttribute("userGrade"))) {
            // 권한이 없으면 /contract/contractMap 리다이렉트
            response.sendRedirect("/contract/contractMap");
            return null; // 리다이렉트 후에 더 이상 처리할 필요 없음
        }

        SearchModel searchModel = new SearchModel();

        // selectedYear가 빈 값이면 현재 연도로 설정
        if (selectedYear.isEmpty()) {
            selectedYear = String.valueOf(java.time.Year.now().getValue()); // 현재 연도 가져오기
        }
        // selectedMonth가 빈 값이면 현재 연도로 설정
        if (selectedMonth.isEmpty()) {
            selectedMonth = String.valueOf(java.time.LocalDate.now().getMonthValue()); // 현재 연도 가져오기
        }

        searchModel.setSelectedYear(selectedYear);
        searchModel.setSelectedMonth(selectedMonth);

        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");
        traceWriter.add("[selectedYear : " + selectedYear + "]");
        traceWriter.add("[selectedMonth : " + selectedMonth + "]");

        List<Statistics> statisticsList = statisticsService.getSearchedDurationCompleteReq(searchModel);

        model.addAttribute("statisticsList", statisticsList);

        traceWriter.log(0);

        return "video/video-statistics";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 비디오 캘린더 페이지
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/video/videoCalendar")
    public String getVideoCalendarPage(
            HttpServletRequest request,
            HttpServletResponse response,
            Model model
    ) throws IOException {
        SearchModel searchModel = new SearchModel();

        List<VideoReqOutput> calendarData = videoReqService.getCalendarData();

        ObjectMapper objectMapper = new ObjectMapper();
        String objectCalendarData = objectMapper.writeValueAsString(calendarData);

        model.addAttribute("calendarData", objectCalendarData);

        // selectedYear가 빈 값이면 현재 연도로 설정
        return "video/video-calendar";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 최신 리스트 가져오기
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/video/getRecentVideoReqList")
    public List<VideoReqOutput> getRecentVideoReqList(
            HttpServletRequest request
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");

        try {
            return videoReqService.getUnStartedVideoReq();
        } catch (Exception e) {
            traceWriter.add("Exception : " + e);

            return null;
        } finally {
            traceWriter.log(0);
        }
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 촬영 신청 기능
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/video/videoReqCreate")
    public String videoReqCreate(
            HttpServletRequest request,
            VideoReq videoReq
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("< INPUT >");
        traceWriter.add("[userInput.getIsUrgentReq() : " + videoReq.getIsUrgentReq() + "]");
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
            String userId = (String) request.getSession().getAttribute("userId");
            videoReq.setCreId(userId);

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

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 신청 촬영 내용 업데이트
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/video/videoReqUpdate")
    public String videoReqUpdate(
            HttpServletRequest request,
            VideoReqInput videoReqInput
    ) {
        String userId = (String) request.getSession().getAttribute("userId");
        String userGrade = (String) request.getSession().getAttribute("userGrade");
        videoReqInput.setUpdId(userId);

        if (Objects.equals(userGrade, "0")) {
            videoReqInput.setManagerId(userId);
        }

        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("< INPUT >");
        traceWriter.add("[userInput.getReqId() : " + videoReqInput.getReqId() + "]");
        traceWriter.add("[userInput.getNote() : " + videoReqInput.getNote() + "]");
        traceWriter.add("[userInput.getProgressNote() : " + videoReqInput.getProgressNote() + "]");
        traceWriter.add("[userInput.getStatus() : " + videoReqInput.getStatus() + "]");
        traceWriter.add("[userInput.getShootReserveDtm() : " + videoReqInput.getShootReserveDtm() + "]");
        traceWriter.add("[userInput.getShootCompleteDt() : " + videoReqInput.getShootCompleteDt() + "]");
        traceWriter.add("[userInput.getUploadCompleteDt() : " + videoReqInput.getUploadCompleteDt() + "]");
        traceWriter.add("[userInput.getUpdId() : " + videoReqInput.getUpdId() + "]");
        traceWriter.add("");

        String result = "";

        try {
            videoReqService.updateVideoReq(videoReqInput);

            result = "success";
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
     *  ┃    ● 지출 경비 추가
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/video/statistics/insertSpend")
    public String insertSpend(
            HttpServletRequest request,
            Spend spend
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("< INPUT >");

        String userId = (String) request.getSession().getAttribute("userId");
        spend.setCreId(userId);

        traceWriter.add("[userInput.getCreId() : " + spend.getCreId() + "]");
        traceWriter.add("[userInput.getSpendDt() : " + spend.getSpendDt() + "]");
        traceWriter.add("[userInput.getWhatFor() : " + spend.getWhatFor() + "]");
        traceWriter.add("[userInput.getAmt() : " + spend.getAmt() + "]");
        traceWriter.add("[userInput.getNote() : " + spend.getNote() + "]");
        traceWriter.add("");

        try {
            statisticsService.insertSpend(spend);

            return "success";
        } catch (Exception e) {
            traceWriter.add("Error : " + e);

            return "error";
        } finally {
            traceWriter.log(0);
        }
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 지출 경비 가져오기
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/video/statistics/getSpendHist")
    public List<Spend> getSpendHist(
            HttpServletRequest request,
            Spend spend
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("[userInput.getSelectedYear() : " + spend.getSelectedYear() + "]");
        traceWriter.add("[userInput.getSelectedMonth() : " + spend.getSelectedMonth() + "]");
        traceWriter.add("");

        try {
            return statisticsService.getSpendHist(spend);
        } catch (Exception e) {
            traceWriter.add("Error : " + e);
            return null;
        } finally {
            traceWriter.log(0);
        }
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 촬영자 별 토탈 달 지출 금액
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/video/statistics/getGroupedSpendAmt")
    public List<Spend> getGroupedSpendAmt(
            HttpServletRequest request,
            Spend spend
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("[userInput.getSelectedYear() : " + spend.getSelectedYear() + "]");
        traceWriter.add("[userInput.getSelectedMonth() : " + spend.getSelectedMonth() + "]");
        traceWriter.add("");

        try {
            return statisticsService.getGroupedSpendAmt(spend);
        } catch (Exception e) {
            traceWriter.add("Error : " + e);
            return null;
        } finally {
            traceWriter.log(0);
        }
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 지출 내역 관리자 확인
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/video/statistics/spendCheck")
    public boolean spendCheck(
            HttpServletRequest request,
            Spend spend
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("[userInput.getId() : " + spend.getId() + "]");
        traceWriter.add("");

        traceWriter.add("");

        HttpSession session = request.getSession(false);
        String checkId = (String) session.getAttribute("userId");
        traceWriter.add("[userInput.getCheckId() : " + spend.getCheckId() + "]");

        spend.setCheckId(checkId);
        try {
            statisticsService.spendCheck(spend);
            return true;
        } catch (Exception e) {
            traceWriter.add("Error : " + e);
            return false;
        } finally {
            traceWriter.log(0);
        }
    }
}
