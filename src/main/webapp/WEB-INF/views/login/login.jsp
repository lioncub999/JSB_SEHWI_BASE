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
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<c:set var="signupUrl" value="/auth/signup"/>
<c:set var="loginUrl" value="/auth/login"/>
<c:set var="dupcheckUrl" value="/auth/dupcheck"/>
<html>
<head>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/login.css'/>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
<body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>

<c:if test="${userId != null && userId != ''}">
    <script>
        window.location.href = "/main"
    </script>
</c:if>

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
            console.log(formData)
            if ($('#signupUserNm').val().trim() != null && $('#signupUserNm').val().trim() != '') {
                $.ajax({
                    url: "${dupcheckUrl}",
                    type: "post",
                    cache: false,
                    data: formData,
                    success: function (response) {
                        if (response) {
                            Toast('top', 2000, 'warning', '이미 동일한 이름이 있습니다.');
                            $('.dupcheckBtn').css({"display": "block"});
                        } else {

                            Toast('top', 2000, 'success', '가입 가능한 아이디 입니다.');

                            $('#dupcheck').val('1');
                            $('.dupcheckBtn').css({"display": "none"});
                            $('.dupcheckComp').css({"display": "block"});
                            $('#signupUserNm').attr("readonly", true);
                        }
                    },
                    beforeSend: function () {
                        $('.dupcheckBtn').css({"display": "none"});
                        $('.loading').css({"display": "block"});
                    },
                    complete: function () {
                        $('.loading').css({"display": "none"});
                    }
                })
            } else {
                Toast('top', 2000, 'warning', '이름을 입력하세요.');
            }
        }
        ,

        signupSubmit: function () {
            var formData = $('#signup-frm').serialize()

            if (
                $('#dupcheck').val() != null && $('#dupcheck').val() != '' && $('#dupcheck').val() == 1
            ) {
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

                                Toast('top', 2000, 'success', '회원 가입이 완료되었습니다.');

                                $('#login-slide').removeClass('slide-up');
                                $('#signup-slide').addClass('slide-up');

                                $('#signupUserPw').attr("disabled", true);
                                $('#userPwCheck').attr("disabled", true);
                                $('#submit-btn').html("COMPLETE!")
                                $('#submit-btn').attr("disabled", true)
                            } else {
                                Toast('top', 2000, 'error', '오류가 발생했습니다.');
                            }
                        })
                    } else {
                        Toast('top', 2000, 'warning', '비밀번호가 일치하지 않습니다.');
                    }
                } else {
                    Toast('top', 2000, 'warning', '회원 정보를 모두 입력해주세요.');
                }
            } else {
                Toast('top', 2000, 'warning', '중복 확인을 먼저 해주세요.');
            }
        }
        ,
        loginSubmit: function (xhr, textStatus, thrownError) {
            var formData = $('#login-frm').serialize()
            $.ajax({
                url: "${loginUrl}",
                type: "post",
                cache: false,
                data: formData,
            }).done(function (response) {
                if (response) {
                    Toast('top', 1000, 'success', '로그인 되었습니다.');
                    setTimeout(function() {
                        window.location.href = '/main';
                    }, 1000)
                } else {
                    Toast('top', 2000, 'warning', '회원 정보를 확인해주세요.');
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
        <h2 class="form-title" id="signup" disabled><span>or</span>Sign Up</h2>
        <div class="form-holder">
            <form class="frm" id="signup-frm">
                <div style="display: flex"><input type="text" class="input" id="signupUserNm" placeholder="이름"
                                                  name="userNm" style="width : 160px"/>
                    <button type="button" class="dupcheckBtn"
                            style="display: block;font-size : 12px;height: 30px;margin-top:2px"
                            onclick="AjaxFunc.signupDupcheck()">
                        중복확인
                    </button>
                    <input type="text" id="dupcheck" name="dupcheck" value="" hidden>
                    <div class="loading" style="display:none;width: 65px;text-align: center">
                        <div>
                            <img src="<c:url value='/js/plugins/images/loading.gif'/>" alt=""
                                 style="width: 20px;margin-top:5px;">
                        </div>
                    </div>
                    <div class="dupcheckComp" style="display:none;width: 65px;text-align: center">
                        <div>
                            <img src="<c:url value='/js/plugins/images/check.png'/>" alt=""
                                 style="width: 20px;margin-top:5px;">
                        </div>
                    </div>
                </div>
                <input type="password" class="input" id="signupUserPw" placeholder="비밀번호" name="userPw"/>
                <input type="password" class="input" id="userPwCheck" placeholder="비밀번호 확인"/>
            </form>
        </div>
        <button class="submit-btn" id="submit-btn" type="button" onclick="AjaxFunc.signupSubmit()">Sign Up</button>
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
