<%--
TODO
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃  <currentPage>
 ┃     ● 로그인 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:set var="signupUrl" value="/auth/signup" />
<c:set var="loginUrl" value="/auth/login" />
<html>
<head>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/login.css'/>">
</head>
<body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script>
    $(document).ready(function() {
        $('#signup').on('click', function() {
            $('#signup-slide').removeClass('slide-up');
            $('#login-slide').addClass('slide-up');
        });
        $('#login').on('click', function() {
            $('#login-slide').removeClass('slide-up');
            $('#signup-slide').addClass('slide-up');
        });
    })

    let AjaxFunc = {
        signupSubmit : function (){
            var formData = $('#signup-frm').serialize()
            $.ajax({
                url : "${signupUrl}",
                type:"post",
                cache : false,
                data : formData,
            }).done(function(response) {
                if(response != null && response != '' && response == 1) {
                    alert('회원 가입이 완료되었습니다.')

                    $('#login-slide').removeClass('slide-up');
                    $('#signup-slide').addClass('slide-up');
                } else {
                    alert('오류가 발생했습니다.')
                }
            })

        },
        loginSubmit : function(xhr, textStatus, thrownError) {
            var formData = $('#login-frm').serialize()
            $.ajax({
                url : "${loginUrl}",
                type:"post",
                cache : false,
                data : formData,
            }).done(function(response) {
                if(response != null && response != '') {
                    console.log(response)
                } else {
                    alert('로그인 정보 확인!')
                }
            })
        }
    }
</script>

<style>
.frm {
    margin-top : 8px;
    margin-bottom : 8px;
}
</style>
<div class="form-structor">
    <div class="signup slide-up" id="signup-slide">
        <h2 class="form-title" id="signup"><span>or</span>Sign up</h2>
        <div class="form-holder">
            <form class="frm" id="signup-frm">
                <input type="text" class="input" id="userNm" placeholder="이름" name="userNm"/>
                <input type="password" class="input" id="userPw" placeholder="비밀번호" name="userPw"/>
                <input type="password" class="input" id="userPwCheck" placeholder="비밀번호 확인" />
            </form>
        </div>
        <button class="submit-btn" type="button" onclick="AjaxFunc.signupSubmit()">Sign up</button>
    </div>

    <div class="login" id="login-slide">
        <div class="center">
            <h2 class="form-title" id="login"><span>or</span>Log in</h2>
            <div class="form-holder">
                <form class="frm" id="login-frm">
                    <input type="email" class="input" placeholder="이름" name="userNm"/>
                    <input type="password" class="input" placeholder="비밀번호" name="userPw"/>
                </form>
            </div>
            <button class="submit-btn" type="button" onclick="AjaxFunc.loginSubmit()">Log in</button>
        </div>
    </div>
</div>

</div>
</body>
</html>
