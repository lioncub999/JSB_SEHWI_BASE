<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<c:set var="passResetUrl" value="/auth/resetPass"/>
<html>
<head>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/view/login.css'/>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>

<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>

<title>모두솔루션 영상촬영 관리</title>

<c:if test="${passReset == 'N'}">
    <script>
        window.location.href = "/main"
    </script>
</c:if>
<script>
    let AjaxFunc = {
        passResetSubmit : function () {
            var formData = $('#passReset-frm').serialize()

            $.ajax({
                url: "${passResetUrl}",
                type: "post",
                cache: false,
                data: formData,
            }).done(function (response) {
                if (response) {
                    Toast('top', 1000, 'success', '비밀번호 변경이 완료되었습니다.');

                    setTimeout(function() {
                        window.location.href = "/main"
                    }, 1000)
                } else {
                    alert('에러 발생')
                }
            })
        },
        test : function() {
            var formData = $('#testForm').serialize();
        }
    }
</script>
<body>
    <h2>페스워드 리셋하는곳</h2>

    <p>이름 : ${userNm}</p>
    <div>
        <form class="frm" id="passReset-frm">
            <p>바꿀 비밀번호 : <input type="password" class="input" name="userPw" id="userPw" placeholder="비밀번호 확인"/></p>
            <p>비밀번호 확인 : <input type="password" class="input" name="userPwCheck" id="userPwCheck" placeholder="비밀번호 확인"/></p>
        </form>
    </div>
    <button type="button" onclick="AjaxFunc.passResetSubmit()">저장</button>
</body>
</html>
