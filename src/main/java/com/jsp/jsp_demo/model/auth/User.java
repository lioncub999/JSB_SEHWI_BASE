package com.jsp.jsp_demo.model.auth;

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
public class User implements Serializable{
    // 유저 ID (핸드폰 번호)
    private String userId;

    // 유저 이름
    private String userNm;

    // 유저 비밀번호
    private String userPw;

    //비밀번호 초기화 여부
    private String passReset;
}
