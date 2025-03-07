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

    <title>모두솔루션 영상촬영 관리</title>
    
  <link rel="icon" href="/favicon.ico" type="image/x-icon">

    <style>
    /* 로딩 오버레이 스타일 */
    #loading-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9999;
    }

    #loading-spinner {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 50px;
        height: 50px;
        border: 5px solid #ccc;
        border-top: 5px solid #3498db;
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(360deg);
        }
    }
    </style>
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
        window.location.href = "/login"
      </script>
    </c:if>

    <%--TODO: 비밀번호 초기화 Y시 초기화 화면--%>
    <c:if test="${passReset == 'Y'}">
      <script>
        window.location.href = "/resetPass"
      </script>
    </c:if>

    <main>
      <!-- 로딩 오버레이 -->
      <div id="loading-overlay">
          <div id="loading-spinner"></div>
      </div>
      <%@ include file="/WEB-INF/views/cmm/template/mylayout/sidenav.jsp" %>
      <section class="content">
        <div class="main-content">
          <%@ include file="/WEB-INF/views/cmm/template/default/mainContents.jsp" %>
        </div>
      </section>
    </main>
  </body>
</html>
