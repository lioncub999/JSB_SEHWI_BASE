package com.jsp.jsp_demo.service.mypage;

import com.jsp.jsp_demo.mapper.mypage.MypageMapper;
import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.chicken.ChickenOutput;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;

@Service
public class MypageService {

    @Autowired
    MypageMapper mypageMapper;

    @Transactional(
            propagation = Propagation.REQUIRED,
            rollbackFor = IOException.class)
    public void resetPassword(UserInput userInput) {
        mypageMapper.resetPassword(userInput);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public List<ChickenOutput> getMyChicken(UserInput user) {
        return mypageMapper.getMyChicken(user);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public List<ChickenOutput> getMyHis(UserInput user) {
        return mypageMapper.getMyHis(user);
    }
}
