package com.jsp.jsp_demo.controller.chicken;


import com.jsp.jsp_demo.model.chicken.Chicken;
import com.jsp.jsp_demo.service.chicken.ChickenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

@Controller
public class ChickenController {

    @Autowired
    ChickenService chickenService;

    @PostMapping("/plusOneChicken")
    public ResponseEntity<Boolean> plusOneChicken(
            @RequestBody Chicken chicken
    ) {
        chickenService.plusOneChicken(chicken);

        return ResponseEntity.ok(true);
    }
}
