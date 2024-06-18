package com.jsp.jsp_demo.mapper.chicken;

import com.jsp.jsp_demo.model.chicken.Chicken;
import com.jsp.jsp_demo.model.mypage.Mypage;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ChickenMapper {

    List<Chicken> getChicken();

    void plusOneChicken(Chicken chicken);

    List<Mypage> eatChickenClassify();
}
