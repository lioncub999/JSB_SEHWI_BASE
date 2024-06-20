package com.jsp.jsp_demo.model.chicken;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_DEFAULT)
public class ChickenOutput extends Chicken implements Serializable {

    private String tasteNm;                 // 치킨 맛 이름
    private Integer eatAmt;                 // 치킨 먹은 총 갯수
    private Integer tasteStoreAmt;          // 맛별 총 입고량
    private String eatDtm;                  // 치킨 먹은날
}
