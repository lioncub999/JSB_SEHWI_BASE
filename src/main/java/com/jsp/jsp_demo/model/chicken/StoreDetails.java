package com.jsp.jsp_demo.model.chicken;

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
public class StoreDetails implements Serializable {
    private String tasteCd;              // 맛 코드
    private String tasteNm;              // 맛 이름
    private Integer tasteStoreAmt;       // 입고 수
}
