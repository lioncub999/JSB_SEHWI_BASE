package com.jsp.jsp_demo.service.chicken;

import com.jsp.jsp_demo.mapper.chicken.ChickenMapper;
import com.jsp.jsp_demo.model.chicken.Chicken;
import com.jsp.jsp_demo.model.chicken.ChickenOutput;
import com.jsp.jsp_demo.model.chicken.StoreDetails;
import com.jsp.jsp_demo.model.mypage.Mypage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;

@Service
public class ChickenService {

    @Autowired
    ChickenMapper chickenMapper;

    // TODO: 입고된 치킨 총 수량
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public List<StoreDetails> getStoreAmt() {
        return chickenMapper.getStoreAmt();
    }

    // TODO: 유저별 치킨 총 먹은 수
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public List<ChickenOutput> getPersonalEatAmt() {
        return chickenMapper.getPersonalEatAmt();
    }

    // TODO: 치킨 + 1
    @Transactional(
            propagation = Propagation.REQUIRED,
            rollbackFor = IOException.class)
    public boolean plusOneChicken(Chicken chicken) {
        chickenMapper.plusOneChicken(chicken);
        return true;
    }
}
