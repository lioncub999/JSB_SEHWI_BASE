package com.jsp.jsp_demo.controller.statistics;

import com.jsp.jsp_demo.model.paging.PagingModel;
import com.jsp.jsp_demo.model.search.SearchModel;
import com.jsp.jsp_demo.model.statistics.Spend;
import com.jsp.jsp_demo.model.statistics.Statistics;
import com.jsp.jsp_demo.model.video.VideoReq;
import com.jsp.jsp_demo.service.statistics.StatisticsService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/* TODO:
 *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 *  ┃
 *  ┃    ● StatisticsController
 *  ┃
 *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
@Controller
public class StatisticsController {

    @Autowired
    StatisticsService statisticsService;

    @GetMapping("/statistics")
    public String statistics(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestParam(value = "selectedYear", defaultValue = "") String selectedYear,
            @RequestParam(value = "selectedMonth", defaultValue = "") String selectedMonth,
            Model model
    ) throws IOException {
        if (!"0".equals(request.getSession().getAttribute("userGrade"))) {
            // 권한이 없으면 /main으로 리다이렉트
            response.sendRedirect("/main");
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

        return "statistics/statistics";
    }

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <POST>
     *  ┃    ● 지출 경비 추가
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @ResponseBody
    @PostMapping("/statistics/insertSpend")
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
    @PostMapping("/statistics/getSpendHist")
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
    @PostMapping("/statistics/getGroupedSpendAmt")
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
}
