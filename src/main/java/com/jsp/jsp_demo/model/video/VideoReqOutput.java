package com.jsp.jsp_demo.model.video;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.jsp.jsp_demo.model.auth.User;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_DEFAULT)
public class VideoReqOutput extends VideoReq {

    private String stringCreDt; // 신청일 String 변환

    private String stringContractDt; // 계약일 String 변환
}
