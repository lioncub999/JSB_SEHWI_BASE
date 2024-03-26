<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
  <%@ include file="/WEB-INF/views/cmm/template/default/stylesheets.jsp"%>
</head>
<body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
<%--TODO: 로그인 세션 확인--%>
<c:if test="${userId == null || userId == ''}">
  <script>
    Toast('top', 1000, 'warning', '로그인을 해주세요.');
    setTimeout(function() {
      window.location.href = "/login"
    }, 1000)
  </script>
</c:if>
<%--TODO: 비밀번호 초기화 Y시 초기화 화면--%>
<c:if test="${passReset == 'Y'}">
  <script>
    window.location.href = "/resetPass"
  </script>
</c:if>
  <main>
    <%@ include file="/WEB-INF/views/cmm/template/layout/sidenav.jsp" %>

    <section class="content">
      <div class="left-content">
        <decorator:body />
      </div>
      <div class="right-content">
        <%@ include file="/WEB-INF/views/cmm/template/layout/right-content.jsp" %>
      </div>
    </section>
  </main>
  </body>
</html>
