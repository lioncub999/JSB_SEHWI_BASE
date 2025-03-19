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

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/common/normalize.css'/>">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/common/button.css'/>">

<%-- /video으로 시작하는 URL에서만 video.css 추가 --%>
<c:if test="${fn:startsWith(pageContext.request.requestURI, '/video')}">
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/view/video.css'/>">
</c:if>

<%-- /contract 시작하는 URL에서만 video.css 추가 --%>
<c:if test="${fn:startsWith(pageContext.request.requestURI, '/contract')}">
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/view/contract.css'/>">
</c:if>


<%-- /mypage 시작하는 URL에서만 mypage.css 추가 --%>
<c:if test="${fn:startsWith(pageContext.request.requestURI, '/mypage')}">
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/view/mypage.css'/>">
</c:if>