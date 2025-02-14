<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 촬영 신청 리스트 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/main.css'/>">
</head>
<body>
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
    <script>
        let PageControlFunc = {
            <%-- 촬영 신청 추가 페이지 이동 --%>
            moveToReqAddPage: function () {
                window.location.href = '/videoReq/reqCreate';
            }
        }
    </script>
    

    <input type="text" id="address" placeholder="주소 입력" style="width: 300px;">
    <button onclick="">검색</button>

    <button onclick="PageControlFunc.moveToReqAddPage()">추가</button>

    <table class="table table-striped">
        <thead>
            <tr>
                <th scope="col">촬영 신청일</th>
                <th scope="col">신청자</th>
                <th scope="col">계약일</th>
                <th scope="col">연락처</th>
                <th scope="col">주소</th>
                <th scope="col">촬영완료여부</th>
                <th scope="col">촬영담당자</th>
                <th scope="col">진행상태</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>홍길동</td>
                <td>30</td>
                <td>개발자</td>
            </tr>
            <tr>
                <td>2</td>
                <td>김철수</td>
                <td>25</td>
                <td>디자이너</td>
            </tr>
            <tr>
                <td>3</td>
                <td>이영희</td>
                <td>28</td>
                <td>마케터</td>
            </tr>
        </tbody>
    </table>
</body>
</html>