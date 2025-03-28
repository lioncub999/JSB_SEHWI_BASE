<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● Template JSP (기본 템플릿)
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>

<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <%@ include file="/WEB-INF/views/cmm/template/default/stylesheets.jsp"%>

    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">

    <title>모두솔루션 통합 관리 플랫폼</title>


  </head>
  <body class="bdy">
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
    <script>
        const LoadingOverlay = {
            show: function () {
                $('#loading-overlay').fadeIn();
            },
            hide: function () {
                $('#loading-overlay').fadeOut();
            }
        };
    </script>

    <%--TODO: 로그인 세션 확인--%>
    <c:if test="${userId == null || userId == ''}">
      <script>
        window.location.href = "/auth/login"
      </script>
    </c:if>

    <%--TODO: 비밀번호 초기화 Y시 초기화 화면--%>
    <c:if test="${passReset == 'Y'}">
      <script>
        window.location.href = "/auth/resetPass"
      </script>
    </c:if>

    <main>
      <!-- 로딩 오버레이 -->
      <div id="loading-overlay">
          <div id="loading-spinner"></div>
      </div>
      <%@ include file="/WEB-INF/views/cmm/template/mylayout/sidenav.jsp" %>
      <section class="content">
          <%@ include file="/WEB-INF/views/cmm/template/mylayout/topnav.jsp" %>
          <div class="main-container">
            <%@ include file="/WEB-INF/views/cmm/template/default/mainContents.jsp" %>
          </div>
        </div>
      </section>
    </main>
  </body>
</html>
