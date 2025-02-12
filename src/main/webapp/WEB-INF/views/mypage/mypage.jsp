<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 마이페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<c:set var="passResetUrl" value="/mypage/resetPass"/>
<c:set var="logoutUrl" value="/auth/logout"/>

<html>
    <head>
        <meta name="viewport"
            content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    </head>
    <body>
        <script>
            let AjaxFunc = {
                <%-- 비밀번호 초기화 --%>
                resetPassword: function () {
                    $.ajax({
                        url: "${passResetUrl}",
                        type: "post",
                        cache: false,
                        data: {"userId": "${userId}", "passReset": "${passReset}"},
                    }).done(function (response) {
                        if (response) {
                            $.ajax({
                                url: "${logoutUrl}",
                                type: "post",
                                cache: false,
                            }).done(function (response) {
                                if (response) {
                                    Toast('top', 1000, 'success', '비밀번호가 초기화되었습니다.<br>다시 로그인해주세요. "1111"');

                                    setTimeout(function () {
                                        window.location.href = "/login"
                                    }, 1000)
                                } else {
                                    Toast('top', 1000, 'success', '레전드 에러 발생 관리자 문의');
                                }
                            })
                        } else {
                            alert('에러 발생')
                        }
                    })
                }
            }
        </script>
        <p>${currentUserInfo.userNm}</p>
    </body>
</html>
