package com.jsp.jsp_demo.controller.main;

import com.jsp.jsp_demo.model.chicken.ChickenOutput;
import com.jsp.jsp_demo.model.chicken.StoreAmt;
import com.jsp.jsp_demo.model.chicken.StoreDetails;
import com.jsp.jsp_demo.service.chicken.ChickenService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;

@Controller
public class MainController {
    @Autowired
    ChickenService chickenService;

    // TODO: 디폴트 페이지
    @GetMapping("/")
    public String defaultPage() {
        return "index";
    }

    // TODO: 메인 페이지
    @GetMapping("/main")
    public String getMainPage(
            HttpServletRequest request,
            Model model
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");

        try {
            // TODO: 입고된 치킨 총 수량
            List<StoreDetails> storeDetails = chickenService.getStoreAmt();
            AtomicReference<Integer> totalStoreAmt = new AtomicReference<>(0);
            storeDetails.stream().forEach(item -> totalStoreAmt.updateAndGet(v -> v + item.getTasteStoreAmt()));

            StoreAmt storeAmt = new StoreAmt();
            storeAmt.setTotalStoreAmt(totalStoreAmt.get());
            storeAmt.setStoreDetail(storeDetails);

            // TODO: 유저별 치킨 총 먹은 수
            List<ChickenOutput> personalEatAmt = chickenService.getPersonalEatAmt();
            // TODO: 맛별 총 먹은 수
            List<ChickenOutput> tasteEatAmt = chickenService.getTasteEatAmt();

            model.addAttribute("storeAmt", storeAmt);
            model.addAttribute("personalEatAmt", personalEatAmt);
            model.addAttribute("tasteEatAmt", tasteEatAmt);

            traceWriter.add("totalStoreAmt: " + totalStoreAmt.get());
        } catch (Exception e) {
            traceWriter.add("Exception : " + e);
        }

        traceWriter.log(0);

        return "main/main";
    }

    @GetMapping("/test")
    public String getTestPage(
            Model model
    ) {

        return "test/test";
    }
}
