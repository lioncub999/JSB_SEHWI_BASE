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
    <div class="nav-title-container">
        <span class="nav-title">
            모두솔루션<br>
            통합 관리 플랫폼
        </span>
    </div>

    <%-- 로고 이미지 --%>
    <img class="logo" src="<c:url value='/images/logo/modusol_logo.png'/>" alt=""/>

    <div style="height:10px"></div>

    <%-- 메뉴 리스트 --%>
    <ul>
        <%-- 홈 --%>
        <li class="nav-item <c:if test="${fn:startsWith(url, '/main')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/main">
                <span class="material-icons">videocam</span>
                <span class="nav-text">&nbsp;영상 촬영 지도</span>
            </a>
        </li>

        <%-- 촬영 신청 리스트 --%>
        <li class="nav-item <c:if test="${fn:startsWith(url, '/videoReq')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/videoReq">
                <span class="material-icons">list</span>
                <span class="nav-text">&nbsp;촬영 신청 리스트</span>
            </a>
        </li>

        <%-- 촬영 일정 캘린더 --%>
        <li class="nav-item calendar <c:if test="${fn:startsWith(url, '/calendar')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/calendar">
                <span class="material-icons">calendar_month</span>
                <span class="nav-text">&nbsp;촬영 일정 캘린더</span>
            </a>
        </li>

        <%-- 촬영 통계&정산 --%>
        <c:if test='${userGrade == 0}'>
            <li class="nav-item statistics <c:if test="${fn:startsWith(url, '/statistics')}">active</c:if>">
                <b></b>
                <b></b>
                <a href="/statistics">
                    <span class="material-icons">analytics</span>
                    <span class="nav-text">&nbsp;촬영 통계&정산</span>
                </a>
            </li>
        </c:if>

        <%-- 마이페이지 --%>
        <li class="nav-item <c:if test="${fn:startsWith(url, '/mypage')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/mypage">
                <span class="material-icons">person</span>
                <span class="nav-text">&nbsp;마이페이지</span>
            </a>
        </li>

        <%-- 로그아웃 --%>
        <li class="nav-item">
            <b></b>
            <b></b>
            <a onclick="SidebarFunc.logout()" style="color : white;">
                <span class="material-icons">logout</span>
                <span class="nav-text">&nbsp;로그아웃</span>
            </a>
        </li>
        <div class="manager-phone-container">
            <div style="font-size : 15px;">[촬영기획팀]</div>
            <div style="font-size:14px">-  개발 및 촬영 -</div>
            <div style="font-size:12px"> 이세휘 과장 (010-7705-4839)</div>
            <div style="font-size:14px">- 촬영작가 -</div>
            <div style="font-size:12px"> 정성우 대리 (010-8907-7210)</div>
            <div style="font-size:12px"> 한채근 대리 (010-4592-9145)</div>
        </div>
    </ul>
</nav>
</body>
</html>
