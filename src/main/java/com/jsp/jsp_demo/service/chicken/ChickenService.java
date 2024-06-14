package com.jsp.jsp_demo.service.chicken;

import com.jsp.jsp_demo.mapper.chicken.ChickenMapper;
import com.jsp.jsp_demo.model.chicken.Chicken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChickenService {

    @Autowired
    ChickenMapper chickenMapper;

    public List<Chicken> getChicken() {
        return chickenMapper.getChicken();
    }

    public void plusOneChicken(Chicken chicken) {
        chickenMapper.plusOneChicken(chicken);
    }
}
