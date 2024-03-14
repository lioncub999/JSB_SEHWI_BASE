package com.jsp.jsp_demo.service;

import com.jsp.jsp_demo.mapper.RealMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RealService {

    @Autowired
    private RealMapper realMapper;

    public int getRealNum() {
        return realMapper.getRealNum();
    }
}
