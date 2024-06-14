<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<c:set var="chickenUrl" value="/chicken"/>
<html>
<head>
</head>
<body>
        <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
        <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
        <script>
            let AjaxFunc = {
                plusOneChicken : function(consumer, userNm) {
                    console.log(userNm);
                    console.log('${userNm}');
                    if(userNm == '${userNm}') {
                    $.ajax({
                    url: "/plusOneChicken",
                    type : "post",
                    cache : false,
                    contentType: "application/json; charset=utf-8",
                    data : JSON.stringify({"consumer" : consumer}),
                    success: function(response) {
                    console.log(response);
                    alert("추가되었슴.")
                    window.location.href = "/main"
                    }
                    })

                    } else {
                        alert("님 아이디에만 플러스 하셈;")
                    }

                            }
                }
        </script>
        <div class="user-info">
            <h4 style="width:100%">${userNm}</h4>
        </div>

        <div class="active-calories" style="height: 500px">
            <h1 style="align-self: flex-start">닭가슴살 근황 (총 25개중)</h1>
            <div class="active-calories-container" style="flex-direction: column">
                <c:forEach items="${chickenList}" var="chicken">
                    <div class="calories-content" style="width: 100px"><p><span>${chicken.userNm} : </span> <span> ${chicken.eat}먹</span></p></div>
                    <div class="calories-content" style="width: 100px"><p><button onclick="AjaxFunc.plusOneChicken(${chicken.consumer}, '${chicken.userNm}')">${chicken.userNm} + 1</button></div>
                    <div><br></div>
                </c:forEach>
            </div>
        </div>
</body>
</html>
