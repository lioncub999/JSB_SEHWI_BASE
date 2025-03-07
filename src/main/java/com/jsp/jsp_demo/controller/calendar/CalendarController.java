package com.jsp.jsp_demo.controller.calendar;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jsp.jsp_demo.model.search.SearchModel;
import com.jsp.jsp_demo.model.statistics.Statistics;
import com.jsp.jsp_demo.model.video.VideoReqOutput;
import com.jsp.jsp_demo.service.statistics.StatisticsService;
import com.jsp.jsp_demo.service.video.VideoReqService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/* TODO:
 *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 *  ┃
 *  ┃    ● CalendarController
 *  ┃
 *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
@Controller
public class CalendarController {

    @Autowired
    VideoReqService videoReqService;

    @GetMapping("/calendar")
    public String statistics(
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
        return "calendar/calendar";
    }
}
