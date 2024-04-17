<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="passResetUrl" value="/resetPass"/>
<c:set var="logoutUrl" value="/auth/logout"/>
<html>
<head>
</head>
<body>
<script>
    let AjaxFunc = {
        resetPassword : function() {
            $.ajax({
                url: "${passResetUrl}",
                type: "post",
                cache: false,
                data: {"userId":"${userId}"},
            }).done(function (response) {
                if (response) {
                    $.ajax({
                        url: "${logoutUrl}",
                        type: "post",
                        cache: false,
                    }).done(function (response) {
                        if (response) {
                            Toast('top', 1000, 'success', '비밀번호가 초기화되었습니다.<br>다시 로그인해주세요.');

                            setTimeout(function() {
                                window.location.href = "/login"
                            }, 1000)
                        } else {
                            alert('에러 발생')
                        }
                    })
                } else {
                    alert('에러 발생')
                }
            })
        }
    }
</script>
<div>
    <span>${userId}</span>
</div>
<div>
    <span>${userNm}</span>
</div>
<div>
    <button onclick="AjaxFunc.resetPassword()">비밀번호 초기화</button>
</div>
</body>
</html>
