package com.jsp.jsp_demo.model.video;

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
public class VideoReq implements Serializable {

    private String reqId;                   // 신청 고유 아이디

    private String creId;                   // 신청자 아이디

    private String storeNm;                 // 매장 이름

    private String address;                 // 매장 주소

    private String contractDt;              // 계약일

    private String shootSchedule;           // 촬영 예정일

    private String phone;                   // 대표 핸드폰 번호

    private Double longitude;               // 매장위치 경도

    private Double latitude;                // 매장위치 위도

    private String shootReserveDtm;         // 촬영 예정일

    private String shootCompleteDt;         // 촬영 완료일

    private String uploadCompleteDt;        // 업로드 완료일

    private String note;                    // 특이사항

    private String progressNote = "";       // 촬영자 작성 특이사항

    private String managerId;               // 촬영 담당자 아이디

    private String status;                  // 촬영 진행상황

    private String updId;                   // 수정자 아이디
}
