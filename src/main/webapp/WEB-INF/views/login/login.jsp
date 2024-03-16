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

<c:set var="signupUrl" value="/auth/signup"/>
<c:set var="loginUrl" value="/auth/login"/>
<c:set var="dupcheckUrl" value="/auth/dupcheck"/>
<html>
<head>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/login.css'/>">
</head>
<body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script>
    $(document).ready(function () {
        $('#signup').on('click', function () {
            $('#signup-slide').removeClass('slide-up');
            $('#login-slide').addClass('slide-up');
        });
        $('#login').on('click', function () {
            $('#login-slide').removeClass('slide-up');
            $('#signup-slide').addClass('slide-up');
        });
    })

    let AjaxFunc = {
        signupDupcheck: function () {
            var formData = $('#signup-frm').serialize()
            if ($('#signupUserNm').val().trim() != null && $('#signupUserNm').val().trim() != '') {
                $.ajax({
                    url: "${dupcheckUrl}",
                    type: "post",
                    cache: false,
                    data: formData,
                    success: function (response) {
                        if (response) {
                            alert('이미 같은 이름 있음')
                        } else {
                            alert('회원 가입 가능')
                        }
                    },
                    beforeSend: function() {
                        $('.dupcheckBtn').css({"display":"none"});
                        $('.loading').css({"display":"block"});
                    },
                    complete: function() {
                        $('.loading').css({"display":"none"});
                        $('.dupcheckBtn').css({"display":"block"});
                    }
                })
            }else
                {
                    alert('이름을 입력하셈.')
                }
            }
        ,

            signupSubmit : function () {
                var formData = $('#signup-frm').serialize()
                if (
                    $('#signupUserNm').val().trim() != null && $('#signupUserNm').val().trim() != '' &&
                    $('#signupUserPw').val().trim() != null && $('#signupUserPw').val().trim() != '' &&
                    $('#userPwCheck').val().trim() != null && $('#userPwCheck').val().trim() != ''
                ) {
                    if ($('#signupUserPw').val() == $('#userPwCheck').val()) {
                        $.ajax({
                            url: "${signupUrl}",
                            type: "post",
                            cache: false,
                            data: formData,
                        }).done(function (response) {
                            if (response != null && response != '' && response == 1) {
                                alert('회원 가입이 완료되었습니다.')

                                $('#login-slide').removeClass('slide-up');
                                $('#signup-slide').addClass('slide-up');
                            } else {
                                alert('오류가 발생했습니다.')
                            }
                        })
                    } else {
                        alert('비밀번호가 일치하지 않음!')
                    }
                } else {
                    alert('회원 정보 모두 입력!')
                }
            }
        ,
            loginSubmit : function (xhr, textStatus, thrownError) {
                var formData = $('#login-frm').serialize()
                $.ajax({
                    url: "${loginUrl}",
                    type: "post",
                    cache: false,
                    data: formData,
                }).done(function (response) {
                    if (response != null && response != '') {
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
        margin-top: 8px;
        margin-bottom: 8px;
    }
</style>


<div class="form-structor">
    <div class="signup slide-up" id="signup-slide">
        <h2 class="form-title" id="signup"><span>or</span>Sign up</h2>
        <div class="form-holder">
            <form class="frm" id="signup-frm">
                <div style="display: flex"><input type="text" class="input" id="signupUserNm" placeholder="이름"
                                                  name="userNm" style="width : 160px"/>
                    <button type="button" class="dupcheckBtn" style="display: block;font-size : 12px;height: 25px;margin-top:2px" onclick="AjaxFunc.signupDupcheck()">
                        중복확인
                    </button>
                    <div class="loading" style="display:none;width: 50px;text-align: center">
                        <div>
                            <img src="<c:url value='/js/plugins/images/loading.gif'/>" alt="" style="width: 20px;margin-top:5px;">
                        </div>
                    </div>
                </div>
                <input type="password" class="input" id="signupUserPw" placeholder="비밀번호" name="userPw"/>
                <input type="password" class="input" id="userPwCheck" placeholder="비밀번호 확인"/>
            </form>
        </div>
        <button class="submit-btn" type="button" onclick="AjaxFunc.signupSubmit()">Sign up</button>
    </div>

    <div class="login" id="login-slide">
        <div class="center">
            <h2 class="form-title" id="login"><span>or</span>Log in</h2>
            <div class="form-holder">
                <form class="frm" id="login-frm">
                    <input type="email" class="input" id="loginUserNm" placeholder="이름" name="userNm"/>
                    <input type="password" class="input" id="loginUserPw" placeholder="비밀번호" name="userPw"/>
                </form>
            </div>
            <button class="submit-btn" type="button" onclick="AjaxFunc.loginSubmit()">Log in</button>
        </div>
    </div>
</div>

</div>
</body>
</html>
