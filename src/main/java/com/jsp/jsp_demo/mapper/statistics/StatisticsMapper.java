package com.jsp.jsp_demo.mapper.statistics;

import com.jsp.jsp_demo.model.auth.UserInput;
import com.jsp.jsp_demo.model.search.SearchModel;
import com.jsp.jsp_demo.model.statistics.Spend;
import com.jsp.jsp_demo.model.statistics.Statistics;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface StatisticsMapper {
    List<Statistics> getSearchedDurationCompleteReq(SearchModel searchModel);

    void insertSpend(Spend spend);

    List<Spend> getSpendHist(Spend spend);

    List<Spend> getGroupedSpendAmt(Spend spend);
}
