package com.jsp.jsp_demo.service.chicken;

import com.jsp.jsp_demo.mapper.chicken.ChickenMapper;
import com.jsp.jsp_demo.model.chicken.Chicken;
import com.jsp.jsp_demo.model.chicken.ChickenOutput;
import com.jsp.jsp_demo.model.chicken.StoreDetails;
import com.jsp.jsp_demo.model.mypage.Mypage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChickenService {

    @Autowired
    ChickenMapper chickenMapper;

    // TODO: 입고된 치킨 총 수량
    public List<StoreDetails> getStoreAmt() {
        return chickenMapper.getStoreAmt();
    }
    // TODO: 유저별 치킨 총 먹은 수
    public List<ChickenOutput> getPersonalEatAmt() {
        return chickenMapper.getPersonalEatAmt();
    }

    // TODO: 맛별 총 먹은 수
    public List<ChickenOutput> getTasteEatAmt() {
        return chickenMapper.getTasteEatAmt();
    }

    public void plusOneChicken(Chicken chicken) {
        chickenMapper.plusOneChicken(chicken);
    }

    public List<Mypage> eatChickenClassify() {
        return chickenMapper.eatChickenClassify();
    }



}
