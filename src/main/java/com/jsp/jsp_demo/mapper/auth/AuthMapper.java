package com.jsp.jsp_demo.mapper.auth;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.auth.UserOutput;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AuthMapper {

    void signup(UserInput userInput);

    UserOutput selectUserById(UserInput userInput);

    Integer selectUserCount(UserInput userInput);

    void updatePassword(UserInput userInput);
}
