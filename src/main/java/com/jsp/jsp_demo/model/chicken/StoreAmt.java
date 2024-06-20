package com.jsp.jsp_demo.model.chicken;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_DEFAULT)
public class StoreAmt implements Serializable {
    private Integer totalStoreAmt;              // 입고 총 갯수
    private List<StoreDetails> storeDetail;     // 입고 상세
}

