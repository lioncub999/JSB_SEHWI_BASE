package com.jsp.jsp_demo.model.statistics;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_DEFAULT)
public class Spend implements Serializable {

    private Integer id;

    private String creId;

    private String creNm;

    private String userNm;

    private String jobGradeNm;

    private String spendDt;

    private String stringSpendDt;

    private String whatFor;

    private Integer amt;

    private Integer totalAmt;

    private String note;

    private String managerCheck;

    private String checkId;

    private String selectedYear;

    private String selectedMonth;
}
