<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 전체 공통 적용 css
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>

<base href="/">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/normalize.css'/>">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/layout.css'/>">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<%-- /main으로 시작하는 URL에서만 main.css 추가 --%>
<c:if test="${fn:startsWith(pageContext.request.requestURI, '/main')}">
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/main.css'/>">
</c:if>

<%-- /videoReq 시작하는 URL에서만 video.css 추가 --%>
<c:if test="${fn:startsWith(pageContext.request.requestURI, '/videoReq')}">
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/video.css'/>">
</c:if>

<%-- /mypage 시작하는 URL에서만 video.css 추가 --%>
<c:if test="${fn:startsWith(pageContext.request.requestURI, '/mypage')}">
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/mypage.css'/>">
</c:if>

<%-- /statistics 시작하는 URL에서만 video.css 추가 --%>
<c:if test="${fn:startsWith(pageContext.request.requestURI, '/statistics')}">
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/statistics.css'/>">
</c:if>