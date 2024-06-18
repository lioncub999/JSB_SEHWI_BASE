package com.jsp.jsp_demo.service.mypage;

import com.jsp.jsp_demo.mapper.mypage.MypageMapper;
import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.mypage.Mypage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MypageService {

    @Autowired
    MypageMapper mypageMapper;

    public void resetPassword(UserInput userInput) {
        mypageMapper.resetPassword(userInput);
    }

    public List<Mypage> getMyChicken(UserInput user) {
        return mypageMapper.getMyChicken(user);
    }
}
