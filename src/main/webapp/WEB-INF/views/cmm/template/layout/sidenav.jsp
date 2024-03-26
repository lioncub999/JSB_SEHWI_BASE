<%--
:TODO
  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃      ◉ sitemesh Side-Nav
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<nav class="main-menu">
    <h1>RulletMan</h1>
    <img class="logo" src="<c:url value='/js/plugins/images/logo.png'/>" alt="" style="width : 100%" />
    <ul>
        <li class="nav-item active">
            <b></b>
            <b></b>
            <a href="/main">
                <i class="fa fa-house nav-icon"></i>
                <span class="nav-text">홈</span>
            </a>
        </li>

        <li class="nav-item">
            <b></b>
            <b></b>
            <a href="#">
                <i class="fa fa-user nav-icon"></i>
                <span class="nav-text">내정보</span>
            </a>
        </li>

        <li class="nav-item">
            <b></b>
            <b></b>
            <a href="#">
                <i class="fa fa-calendar-check nav-icon"></i>
                <span class="nav-text">게시판</span>
            </a>
        </li>

        <li class="nav-item">
            <b></b>
            <b></b>
            <a href="#">
                <i class="fa fa-sliders nav-icon"></i>
                <span class="nav-text">설정</span>
            </a>
        </li>
    </ul>
</nav>
</body>
</html>
