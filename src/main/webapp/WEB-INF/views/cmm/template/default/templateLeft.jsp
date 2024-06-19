<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>

    <base href="/">
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/basic.css'/>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
<%--TODO: 로그인 세션 확인--%>
<c:if test="${userId == null || userId == ''}">
<%--    <script>--%>
<%--        Toast('top', 1000, 'warning', '로그인을 해주세요.');--%>
<%--        setTimeout(function() {--%>
<%--            window.location.href = "/login"--%>
<%--        }, 1000)--%>
<%--    </script>--%>
</c:if>
<%--TODO: 비밀번호 초기화 Y시 초기화 화면--%>
<c:if test="${passReset == 'Y'}">
    <script>
        window.location.href = "/resetPass"
    </script>
</c:if>
<decorator:body>

</decorator:body>
</body>
</html>
