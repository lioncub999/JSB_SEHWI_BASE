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

    private String stringCreDtm;
}
