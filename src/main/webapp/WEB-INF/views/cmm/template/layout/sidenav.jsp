<%--
:TODO
  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃      ◉ sitemesh Side-Nav
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="logoutUrl" value="/auth/logout"/>
<%
    String url = request.getServletPath();
    request.setAttribute("url", url);
%>
<html>
<body>
<script>
    let SidebarFunc = {
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
<nav class="main-menu">
    <h1>RulletMan</h1>
    <img class="logo" src="<c:url value='/js/plugins/images/logo.png'/>" alt="" style="width : 100%" />
    <ul>
        <li class="nav-item <c:if test="${url == '/main'}">active</c:if>">
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
            <a onclick="SidebarFunc.logout()" style="color : white;">
                <i class="fa fa-arrow-right-from-bracket nav-icon"></i>
                <span class="nav-text">로그아웃</span>
            </a>
        </li>
    </ul>
</nav>
</body>
</html>
