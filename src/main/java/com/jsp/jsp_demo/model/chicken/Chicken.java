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
public class Chicken implements Serializable {
    private Integer id;                     // 치킨 섭취 ID
    private Integer consumerId;                // 먹은사람 ID
    private String consumerNm;                // 먹은사람 이름
    private String tasteCd;                 // 치킨 맛 코드
}
