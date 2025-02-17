<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 로그인 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %> <%--한국어 깨짐 방지--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %> <%--한국어 깨짐 방지--%>


<c:set var="loginUrl" value="/auth/login"/>
<c:set var="signUpUrl" value="/auth/signUpUrl"/>

<html>
    <head>
        <meta name="viewport"z
            content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
        <link type="text/css" rel="stylesheet" href="<c:url value='/css/normalize.css'/>">
        <link type="text/css" rel="stylesheet" href="<c:url value='/css/login.css'/>">

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

    <body>
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

        <script>
            // 엔터키 감지 및 버튼 클릭 트리거
            document.addEventListener('keydown', function(event) {
            if (event.key === 'Enter') {
                // 로그인 버튼 클릭
                document.getElementById('loginButton').click();
            }
            });

            let PageControlFunc ={
                <%-- 회원가입 화면으로 이동 --%>
                moveToSignUpPage : function() {
                    window.location.href = '/auth/signUp';
                }
            }

            let AjaxFunc = {
                <%-- 로그인 --%>
                loginSubmit: function (xhr, textStatus, thrownError) {
                    var formData = $('#login-frm').serialize()
                    $.ajax({
                        url: "${loginUrl}",
                        type: "post",
                        cache: false,
                        data: formData,
                    }).done(function (response) {
                        // 존재하지 않는 계정
                        if (response == "noExist") {
                            Toast('top', 1000, 'error', "존재하지 않는 계정입니다");
                            return;
                        }

                        // 패스워드 오류
                        if (response == "passError") {
                            Toast('top', 2000, 'warning', '비밀번호를 확인해주세요.');
                            return;
                        }

                        // 로그인 완료
                        Toast('top', 1000, 'success', '로그인 되었습니다.');
                        setTimeout(function () {
                            window.location.href = '/main';
                        }, 1000);
                    })
                }
            }
        </script>

        <!-- 로딩 오버레이 -->
        <div id="loading-overlay">
            <div id="loading-spinner"></div>
        </div>
        <main>
            <div class="login-box">
                <%-- 로그인 타이틀 --%>
                <div class="login-title" id="login">
                    <img class="logo-img" src="<c:url value='/images/logo/modusol_logo.png'/>" alt=""/>
                    <h2>모두솔루션 영상촬영 관리 로그인</h2>
                </div>

                <%-- 로그인 폼 --%>
                <div>
                    <form class="login-frm", id="login-frm">
                        <div class="input-box">
                            <input type="text" class="input" placeholder="아이디" name="userId"/>
                        </div>
                        <div class="input-box">
                            <input type="password" class="input password" placeholder="비밀번호" name="userPw"/>
                        </div>
                    </form>
                </div>


                <%-- 로그인 버튼 --%>
                <div class="login-btn-box">
                    <button class="login-btn" id="loginButton" type="button" onclick="AjaxFunc.loginSubmit()">로그인</button>
                </div>

                <%-- 회원가입 버튼 --%>
                <div class="login-btn-box">
                    <button class="login-btn" type="button" onclick=PageControlFunc.moveToSignUpPage()>회원가입</button>
                </div>
            </div>
        </main>
    </body>
</html>
