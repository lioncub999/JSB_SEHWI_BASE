package com.jsp.jsp_demo.mapper.mypage;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.chicken.ChickenOutput;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MypageMapper {

    void resetPassword(UserInput userInput);

    List<ChickenOutput> getMyChicken(UserInput user);

    List<ChickenOutput> getMyHis(UserInput user);
}
