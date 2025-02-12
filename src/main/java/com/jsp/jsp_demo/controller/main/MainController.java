package com.jsp.jsp_demo.controller.main;

import com.jsp.jsp_demo.service.main.MainService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;

/* TODO:
 *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 *  ┃
 *  ┃    ● MainController
 *  ┃
 *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
@Controller
public class MainController {
    // TODO: 디폴트 페이지
    @GetMapping("/")
    public String defaultPage() {
        return "index";
    }

    // TODO : MainService
    @Autowired
    MainService chickenService;

    // TODO: 메인 페이지
    @GetMapping("/main")
    public String getMainPage(
            HttpServletRequest request,
            Model model
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");

        try {
//            // TODO: 입고된 치킨 총 수량
//            List<StoreDetails> storeDetails = chickenService.getStoreAmt();
//            AtomicReference<Integer> totalStoreAmt = new AtomicReference<>(0);
//            storeDetails.stream().forEach(item -> totalStoreAmt.updateAndGet(v -> v + item.getTasteStoreAmt()));
//
//            StoreAmt storeAmt = new StoreAmt();
//            storeAmt.setTotalStoreAmt(totalStoreAmt.get());
//            storeAmt.setStoreDetail(storeDetails);
//
//            // TODO: 유저별 치킨 총 먹은 수
//            List<ChickenOutput> personalEatAmt = chickenService.getPersonalEatAmt();
//
//            model.addAttribute("storeAmt", storeAmt);
//            model.addAttribute("personalEatAmt", personalEatAmt);
//
//            traceWriter.add("totalStoreAmt: " + totalStoreAmt.get());
        } catch (Exception e) {
            traceWriter.add("Exception : " + e);
        }

        traceWriter.log(0);

        return "main/main";
    }
}
