<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="logoutUrl" value="/auth/logout"/>
<html>
<head>
</head>
<body>
<script>
    let AjaxFunc = {
        logout : function() {
            $.ajax({
                url: "${logoutUrl}",
                type: "post",
                cache: false,
            }).done(function (response) {
                if (response) {
                    Toast('top', 1000, 'success', '로그아웃이 완료되었습니다.');

                    setTimeout(function() {
                        window.location.href = "/login"
                    }, 1000)
                } else {
                    alert('에러 발생')
                }
            })
        }
    }
</script>
안녕하세요 ${userNm} 님
<button onclick="AjaxFunc.logout()">로그아웃</button>
</body>
</html>
