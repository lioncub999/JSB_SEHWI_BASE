package com.jsp.jsp_demo.controller.contract;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jsp.jsp_demo.model.contract.ContractModel;
import com.jsp.jsp_demo.model.paging.PagingModel;
import com.jsp.jsp_demo.model.search.SearchModel;
import com.jsp.jsp_demo.model.statistics.Spend;
import com.jsp.jsp_demo.model.statistics.Statistics;
import com.jsp.jsp_demo.model.video.VideoReq;
import com.jsp.jsp_demo.model.video.VideoReqInput;
import com.jsp.jsp_demo.model.video.VideoReqOutput;
import com.jsp.jsp_demo.service.contract.ContractService;
import com.jsp.jsp_demo.service.statistics.StatisticsService;
import com.jsp.jsp_demo.service.video.VideoReqService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import java.util.Objects;

/* TODO:
 *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 *  ┃
 *  ┃    ● Contract Controller
 *  ┃
 *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
@Controller
public class ContractController {

    @Autowired
    ContractService contractService;

    @Value("${naver.maps.client.id}")
    private String naverMapsClientId;

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    <GET>
     *  ┃    ● 모두솔루션 계약 지도 페이지
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @GetMapping("/contract/contractMap")
    public String getContractMap(
            HttpServletRequest request,
            Model model
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");

        ObjectMapper objectMapper = new ObjectMapper();
        try {

            List<ContractModel> contractList = contractService.getAllContractList();

            String contList = objectMapper.writeValueAsString(contractList);

            model.addAttribute("contList", contList);
            model.addAttribute("naverMapsClientId", naverMapsClientId);
        } catch (Exception e) {
            traceWriter.add("Exception : " + e);
        }

        traceWriter.log(0);

        return "contract/contract-map";
    }
}
