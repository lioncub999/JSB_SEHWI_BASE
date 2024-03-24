<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<html>
<head>
  <%@ include file="/WEB-INF/views/cmm/template/default/stylesheets.jsp"%>
</head>
<body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
<c:if test="${userId == null || userId == ''}">
  <script>
    Toast('top', 1000, 'warning', '로그인을 해주세요.');
    setTimeout(function() {
      window.location.href = "/login"
    }, 2000)
  </script>
</c:if>
<%@ include file="/WEB-INF/views/cmm/template/layout/top.jsp" %>
<div>
  <div class="c-body">
    <main class="c-main">
      <div class="container-fluid">
        <decorator:body />
      </div>
    </main>
  </div>
</div>
</body>
</html>
