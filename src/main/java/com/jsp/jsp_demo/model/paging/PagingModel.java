package com.jsp.jsp_demo.model.paging;

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
public class PagingModel implements Serializable{

    private int startRow;

    private int pageSize;

    private String searchStoreNm;

    private String searchPhone;

    private String searchUserId;
}
