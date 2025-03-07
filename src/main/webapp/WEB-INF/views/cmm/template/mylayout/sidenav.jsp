<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 공통 좌측 네비게이션바
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="logoutUrl" value="/auth/logout"/>
<%
    String url = request.getServletPath();
    request.setAttribute("url", url);
%>
<html>
<body>
<script>
    let SidebarFunc = {
        <%-- 로그아웃 --%>
        logout: function () {
            $.ajax({
                url: "${logoutUrl}",
                type: "post",
                cache: false,
            }).done(function (response) {
                if (response) {
                    Toast('top', 2000, 'success', '로그아웃이 완료되었습니다.');

                    setTimeout(function () {
                        window.location.href = "/login"
                    }, 1000)
                } else {
                    alert('에러 발생')
                }
            })
        }
    }
</script>
<nav class="side-nav-main">
    <%-- 타이틀 --%>
    <div style="height : 10px"></div>
    <h1>모두솔루션</h1>
    <h1>영상 편집 관리</h1>

    <%-- 로고 이미지 --%>
    <img class="logo" src="<c:url value='/images/logo/modusol_logo.png'/>" alt=""/>

    <%-- 메뉴 리스트 --%>
    <ul>
        <%-- 홈 --%>
        <li class="nav-item <c:if test="${fn:startsWith(url, '/main')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/main">
                <i class="fa fa-house nav-icon"></i>
                <span class="nav-text">홈</span>
            </a>
        </li>

        <%-- 촬영 신청 리스트 --%>
        <li class="nav-item <c:if test="${fn:startsWith(url, '/videoReq')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/videoReq">
                <i class="fa fa-list nav-icon"></i>
                <span class="nav-text">촬영 신청 리스트</span>
            </a>
        </li>

        <%-- 촬영 일정 캘린더 --%>
        <li class="nav-item <c:if test="${fn:startsWith(url, '/calendar')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/calendar">
                <i class="fa fa-calendar nav-icon"></i>
                <span class="nav-text">촬영 일정 캘린더</span>
            </a>
        </li>

        <%-- 촬영 통계&정산 --%>
        <c:if test='${userGrade == 0}'>
            <li class="nav-item <c:if test="${fn:startsWith(url, '/statistics')}">active</c:if>">
                <b></b>
                <b></b>
                <a href="/statistics">
                    <i class="fa fa-chart-pie nav-icon"></i>
                    <span class="nav-text">촬영 통계&정산</span>
                </a>
            </li>
        </c:if>

        <%-- 마이페이지 --%>
        <li class="nav-item <c:if test="${fn:startsWith(url, '/mypage')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/mypage">
                <i class="fa fa-user nav-icon"></i>
                <span class="nav-text">마이페이지</span>
            </a>
        </li>

        <%-- 로그아웃 --%>
        <li class="nav-item">
            <b></b>
            <b></b>
            <a onclick="SidebarFunc.logout()" style="color : white;">
                <i class="fa fa-arrow-right-from-bracket nav-icon"></i>
                <span class="nav-text">로그아웃</span>
            </a>
        </li>
        <div style="font-size : 15px;">[촬영기획팀]</div>
        <div style="font-size:14px">-  개발 및 촬영 -</div>
        <div style="font-size:12px"> 이세휘 과장 (010-7705-4839)</div>
        <div style="font-size:14px">- 촬영작가 --</div>
        <div style="font-size:12px"> 한채근 대리 (010-8907-7210)</div>
        <div style="font-size:12px"> 정성우 대리 010-4592-9145)</div>
    </ul>
</nav>
</body>
</html>
