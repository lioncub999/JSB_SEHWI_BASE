package com.jsp.jsp_demo.service.statistics;

import com.jsp.jsp_demo.mapper.mypage.MypageMapper;
import com.jsp.jsp_demo.mapper.statistics.StatisticsMapper;
import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.search.SearchModel;
import com.jsp.jsp_demo.model.statistics.Statistics;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;

@Service
public class StatisticsService {

    @Autowired
    StatisticsMapper statisticsMapper;

    @Transactional(
            propagation = Propagation.REQUIRED,
            rollbackFor = IOException.class)
    public List<Statistics> getSearchedDurationCompleteReq(SearchModel searchModel) {
        return statisticsMapper.getSearchedDurationCompleteReq(searchModel);
    }
}
