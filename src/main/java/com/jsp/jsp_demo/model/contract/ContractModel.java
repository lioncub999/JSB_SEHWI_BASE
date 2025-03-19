package com.jsp.jsp_demo.model.contract;

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
public class ContractModel implements Serializable {

    private String contId;                  // 계약 고유 아이디

    private String creId;                   // 계약한 사람 아이디

    private String storeNm;                 // 상호명

    private String address;                 // 주소

    private Double longitude;               // 매장위치 경도

    private Double latitude;                // 매장위치 위도

    private String note;                    // 특이사항

    private String contStatus;              // 계약상태 (CONTRACT : 계약중 , EXP : 해지)

    private String contDt;                  // 계약일

    private String contEndDt;               // 계약 종료일 // 계약상태 CONTRACT 인데 현재일 기준 계약 만료면 만료로 처리

    private String phone;                   // 가게 사장 핸드폰
}
