package com.jsp.jsp_demo.service.contract;

import com.jsp.jsp_demo.mapper.contract.ContractMapper;
import com.jsp.jsp_demo.mapper.statistics.StatisticsMapper;
import com.jsp.jsp_demo.model.contract.ContractModel;
import com.jsp.jsp_demo.model.video.VideoReqOutput;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ContractService {

    @Autowired
    ContractMapper contractMapper;

    /* TODO:
     *  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     *  ┃    ● 모든 계약 가져오기
     *  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public List<ContractModel> getAllContractList() {
        return contractMapper.getAllContractList();
    }
}
