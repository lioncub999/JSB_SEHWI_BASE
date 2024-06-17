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
    private Integer id;
    private String consumer;
    private Integer eat;
    private String userNm;
    private String chickCd;

}
