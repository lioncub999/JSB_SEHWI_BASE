package com.jsp.jsp_demo.mapper.mypage;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.mypage.ConsumeHis;
import com.jsp.jsp_demo.model.mypage.Mypage;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MypageMapper {

    void resetPassword(UserInput userInput);

    List<Mypage> getMyChicken(UserInput user);

    List<ConsumeHis> getMyHis(UserInput user);
}
