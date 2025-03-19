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
<c:set var="loginUrl" value="/auth/login"/>
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
                        window.location.href = "${loginUrl}"
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
        <li class="nav-item <c:if test="${fn:startsWith(url, '/contract/')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/contract/contractMap">
                <span class="material-icons">travel_explore</span>
                <span class="nav-text">&nbsp;계약매장</span>
            </a>
        </li>
        <%-- 홈 --%>
        <li class="nav-item <c:if test="${fn:startsWith(url, '/video/')}">active</c:if>">
            <b></b>
            <b></b>
            <a href="/video/videoMap">
                <span class="material-icons">videocam</span>
                <span class="nav-text">&nbsp;영상 촬영 관리</span>
            </a>
        </li>

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
