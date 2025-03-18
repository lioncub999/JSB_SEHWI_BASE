<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 공통 좌측 네비게이션바
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<html>
    <body>
        <c:if test="${fn:startsWith(url, '/main')}">
            <div class="container-fluid top-menu-container">
                <div class="row">
                    <div class="col">
                        <span class="material-icons">map</span>
                        <span class="top-nav-text">&nbsp;촬영지도</span>
                    </div>
                    <div class="col">
                        <span class="material-icons">add</span>
                        <span class="top-nav-text">&nbsp;촬영신청</span>
                    </div>
                    <div class="col">
                        <span class="material-icons">list</span>
                        <span class="top-nav-text">&nbsp;신청리스트</span>
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <c:if test='${userGrade == 0}'>
                            <span class="material-icons">analytics</span>
                            <span class="top-nav-text">&nbsp;통계&정산</span>
                        </c:if>
                    </div>
                    <div class="col">
                        <span class="material-icons">calendar_month</span>
                        <span class="top-nav-text">&nbsp;캘린더</span>
                    </div>
                    <div class="col">
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${fn:startsWith(url, '/videoReq')}">video</c:if>
    </body>
</html>
