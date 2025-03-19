<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 로그인 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>

<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %> <%--한국어 깨짐 방지--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %> <%--한국어 깨짐 방지--%>


<c:set var="mainUrl" value="/contract/contractMap"/>
<c:set var="loginUrl" value="/auth/login"/>
<c:set var="signUpUrl" value="/auth/signUp"/>

<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <link type="text/css" rel="stylesheet" href="<c:url value='/css/common/normalize.css'/>">
        <link type="text/css" rel="stylesheet" href="<c:url value='/css/view/login.css'/>">
        <link type="text/css" rel="stylesheet" href="<c:url value='/css/common/button.css'/>">

        <title>모두솔루션 통합 관리 플랫폼</title>
    </head>

    <body>
        <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
        <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>


        <script>
            // 로그인 세션 확인
            if ("${userId}" != '') {
                window.location.href = "${mainUrl}";
            }

            <%-- Document Ready! --%>
            $(document).ready(function() {
            // 엔터키 감지 및 버튼 클릭 트리거
                document.addEventListener('keydown', function(event) {
                    if (event.key === 'Enter') {
                        // 로그인 버튼 클릭
                        document.getElementById('loginButton').click();
                    }
                });
            });

            <%-- 로딩 오버레이 --%>
            const LoadingOverlay = {
                show: function () {
                    $('#loading-overlay').fadeIn();
                },
                hide: function () {
                    $('#loading-overlay').fadeOut();
                }
            };

            let PageControlFunc ={
                // 회원가입 화면으로 이동
                moveToSignUpPage : function() {
                    window.location.href = "${signUpUrl}";
                }
            };

            let SubmitFunc = {
                // 로그인 값 valid 확인
                loginSubmit: function() {
                    var warningTxt = '';

                    // 아이디 입력 확인
                    if ($('#userId').val() == '') {
                        warningTxt += "아이디를 입력해주세요!\n"
                    }
                    // 비밀번호 입력 확인
                    if ($('#userPw').val() == '') {
                        warningTxt += "비밀번호 입력해주세요!\n"
                    }

                    // 워닝 표시
                    if (warningTxt != '') {
                        Toast('top', 1500, 'warning', warningTxt);
                        return;
                    }

                    AjaxFunc.login();
                }
            }

            let AjaxFunc = {
                // 로그인 ajax
                login: function () {
                    const formData = $('#login-frm').serializeArray();
                    
                    const messages = {
                        noExist: { type: 'error', message: '존재하지 않는 계정입니다', duration: 1000 },
                        passError: { type: 'warning', message: '비밀번호를 확인해주세요.', duration: 1000 },
                        success: { type: 'success', message: '로그인 되었습니다.', duration: 1000 },
                    };

                    LoadingOverlay.show();
                    $.ajax({
                        url: "${loginUrl}",
                        type: 'POST',
                        cache: false,
                        data: formData,
                    })
                    .done((response) => {
                        const toast = messages[response];

                        if (toast) {
                            Toast('top', toast.duration, toast.type, toast.message);

                            if (response === 'success') {
                                setTimeout(() => {
                                    window.location.href = "${mainUrl}";
                                }, toast.duration);
                            }
                        } else {
                            console.error('Unhandled response:', response);
                        }

                        LoadingOverlay.hide();
                    })
                    .fail((xhr, textStatus, thrownError) => {
                        console.error('AJAX error:', textStatus, thrownError);
                        Toast('top', 1000, 'error', `로그인 중 문제가 발생했습니다.\n${thrownError}`);
                        LoadingOverlay.hide();
                    });
                },
            };
        </script>

        <!-- 로딩 오버레이 -->
        <div id="loading-overlay">
            <div id="loading-spinner"></div>
        </div>

        <main>
            <%-- 로그인 타이틀 --%>
            <img class="logo-img login-logo" src="<c:url value='/images/logo/modusol_logo.png'/>" alt="" />
            <div class="login-title" id="login">
                모두솔루션 통합 관리 플랫폼
            </div>

            <%-- 로그인 폼 --%>
            <div>
                <form class="login-frm", id="login-frm">
                    <div class="input-container">
                        <input type="text" class="input-field" placeholder="" name="userId" id="userId" />
                        <label for="username" class="input-label">아이디</label>
                    </div>
                    <div class="input-container">
                        <input type="password" class="input-field password" placeholder="" name="userPw" id="userPw" />
                        <label for="username" class="input-label">비밀번호</label>
                    </div>
                </form>

                <%-- 로그인 버튼 --%>
                <div class="login-btn-box">
                    <button class="login-btn" id="loginButton" type="button" onclick="SubmitFunc.loginSubmit()">로그인</button>
                </div>

                <%-- 회원가입 버튼 --%>
                <div class="login-btn-box">
                    <button class="login-btn" type="button" onclick=PageControlFunc.moveToSignUpPage()>회원가입</button>
                </div>
            </div>
        </main>
    </body>
</html>
