package com.jsp.jsp_demo.model.statistics;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_DEFAULT)
public class Statistics implements Serializable {

    private String userId;              // 유저 아이디

    private String userNm;              // 이름

    private String jobGradeNm;          // 직급

    private Integer uploadCompleteCnt;  // 업로드 갯수
}
