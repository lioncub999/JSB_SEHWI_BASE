package com.jsp.jsp_demo.model.auth;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_DEFAULT)
public class UserInput extends User {

    private String signUpCode;      // 가입 코드

    private String logType;         // 로그인 or 로그아웃

    private String ip;              // 접속 아이피

    private String userAgent;       // 접속 브라우저
}
