package com.jsp.jsp_demo.mapper.chicken;

import com.jsp.jsp_demo.model.chicken.Chicken;
import com.jsp.jsp_demo.model.chicken.ChickenOutput;
import com.jsp.jsp_demo.model.chicken.StoreDetails;
import com.jsp.jsp_demo.model.mypage.Mypage;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ChickenMapper {

    // TODO: 입고된 치킨 총 수량
    List<StoreDetails> getStoreAmt();
    // TODO: 유저별 치킨 총 먹은 수
    List<ChickenOutput> getPersonalEatAmt();
    // TODO: 맛별 먹은 수
    List<ChickenOutput> getTasteEatAmt();

    void plusOneChicken(Chicken chicken);

    List<Mypage> eatChickenClassify();

}
