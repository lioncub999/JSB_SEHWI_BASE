package com.jsp.jsp_demo.mapper.mypage;

import com.jsp.jsp_demo.model.auth.UserInput;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MypageMapper {

    void resetPassword(UserInput userInput);
}
