package com.jsp.jsp_demo.controller.chicken;


import com.jsp.jsp_demo.model.chicken.Chicken;
import com.jsp.jsp_demo.service.chicken.ChickenService;
import com.jsp.jsp_demo.util.log.TraceWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class ChickenController {

    @Autowired
    ChickenService chickenService;

    // TODO: 먹은 치킨 추가
    @PostMapping("/chicken/plusOneChicken")
    public ResponseEntity<Boolean> plusOneChicken(
            HttpServletRequest request,
            @RequestBody Chicken chicken
    ) {
        TraceWriter traceWriter = new TraceWriter("", request.getMethod(), request.getServletPath());
        traceWriter.add("");


        boolean result = false;

        try {
            result = chickenService.plusOneChicken(chicken);
        } catch (Exception e) {
            traceWriter.add("Exception : " + e);
            return ResponseEntity.ok(false);
        }
        return ResponseEntity.ok(result);
    }
}
