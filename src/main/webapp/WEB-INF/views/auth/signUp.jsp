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
<c:set var="signUpUrl" value="/auth/signUp"/>

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
        <script src="<c:url value='/js/util/textUtils.js' />"></script>

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
                <%-- 로그인 화면으로 이동 --%>
                moveToLoginPage : function() {
                    location.href = '/login';
                }
            }

            let AjaxFunc = {
                <%-- 아이디 중복 확인 --%>
                idDupCheck: function() {
                    var userId = $('#userId').val();

                    $.ajax({
                        url: "/auth/dupCheck",
                        type: "post",
                        cache: false,
                        contentType: "application/json", // JSON 전송
                        data: JSON.stringify({ userId: userId }), // JSON 형식으로 변환
                    }).done(function (response) {
                        console.log(response);
                    });
                },

                <%-- 회원가입 신청 --%>
                signUp: function (xhr, textStatus, thrownError) {
                    var formData = $('#login-frm').serialize()

                    var warningTxt = '';
                    <%-- 가입코드 입력 확인 --%>
                    if (document.getElementById("signUpCode").value == '') {
                        warningTxt += "가입 코드를 입력해주세요!\n"
                    }
                    <%-- 아이디 입력 확인 --%>
                    if (document.getElementById('userId').value == '') {
                        warningTxt += "아이디를 입력해주세요!\n"
                    }
                    <%-- 아이디 중복 확인 --%>
                    if (document.getElementById('idDupCheck').value == 'N') {
                        warningTxt += "아이디 중복확인을 완료해주세요!\n"
                    }
                    <%-- 비밀번호 입력 확인 --%>
                    if (document.getElementById('userPw').value == '' || document.getElementById('userPwCheck').value == '') {
                        warningTxt += "비밀번호를 입력해 주세요!\n"
                    }
                    <%-- 비밀번호 일치 확인 --%>
                    if (document.getElementById('userPw').value != document.getElementById('userPwCheck').value) {
                        warningTxt += "비밀번호가 일치하지 않습니다!\n"
                    }
                    <%-- 이름 입력 확인 --%>
                    if (document.getElementById('userNm').value == '') {
                        warningTxt += "이름을 입력해주세요!\n"
                    }
                    <%-- 직급 입력 확인 --%>
                    if (document.getElementById('jobGrade').value == '') {
                        warningTxt += "직급을 선택해주세요!\n"
                    }
                    <%-- 연락처 입력 확인 --%>
                    if (document.getElementById('phone').value == '') {
                        warningTxt += "핸드폰 번호를 입력해주세요!\n"
                    }
                    <%-- 연락처 형식 확인 --%>
                    if (!IsPhoneValid(document.getElementById('phone').value)) {
                        warningTxt += "휴대폰 번호 형식을 확인해주세요"
                    }
                    <%-- 워닝 표시 --%>
                    if (warningTxt != '') {
                        Toast('top', 1500, 'warning', warningTxt);
                        LoadingOverlay.hide();
                        return;
                    }

                    LoadingOverlay.show();
                    <%-- $.ajax({
                        url: "${reqCreateUrl}",
                        type: "post",
                        cache: false,
                        data: formData,
                    }).done(function (response) {
                        console.log(response);
                        if (response == "success") {
                            Swal.fire({
                                icon: 'success',
                                title: '촬영 신청이 완료되었습니다!',
                                allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.location.href = "${reqMainUrl}";
                                }
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: '오류가 발생했습니다. 지속 현상 발생시 관리자에게 문의해주세요.',
                                allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                            });
                        }
                    }); --%>
                    LoadingOverlay.hide();
                }
            }
        </script>

        <!-- 로딩 오버레이 -->
        <div id="loading-overlay">
            <div id="loading-spinner"></div>
        </div>
        <main>
            <div class="login-box">
                <%-- 로그인 버튼 --%>
                <div class="login-btn-box">
                    <button class="login-btn" id="loginButton" type="button" onclick=PageControlFunc.moveToLoginPage()>로그인 페이지로 이동</button>
                </div>

                <%-- 로그인 타이틀 --%>
                <div class="login-title" id="login">
                    <img class="logo-img" src="<c:url value='/images/logo/modusol_logo.png'/>" alt=""/>
                    <h2>모두솔루션 영상촬영 관리 회원가입</h2>
                </div>

                <%-- 로그인 폼 --%>
                <div>
                    <form class="login-frm", id="login-frm">
                        <input type="hidden" name="idDupcheck", value="N" id="idDupCheck">
                        <div class="input-box">
                            <input type="text" class="input" placeholder="가입코드" name="signUpCode" id="signUpCode"/>
                        </div>
                        <div class="input-box" style="display:flex;">
                            <input type="text" class="input" placeholder="아이디" name="userId" style="width:200px;" id="userId"/>
                            <button type="button" style="width:50px" onclick=AjaxFunc.idDupCheck()>중복확인</button>
                        </div>
                        <div class="input-box">
                            <input type="password" class="input password" placeholder="비밀번호" name="userPw" id="userPw"/>
                        </div>
                        <div class="input-box">
                            <input type="password" class="input password" placeholder="비밀번호 확인" name="userPwCheck" id="userPwCheck"/>
                        </div>
                        <div class="input-box">
                            <input type="text" class="input" placeholder="이름" name="userNm" id="userNm"/>
                        </div>
                        <div class="input-box">
                            <input type="text" class="input" placeholder="직급" name="jobGrade" id="jobGrade"/>
                        </div>
                        <div class="input-box">
                            <input type="text" class="input" placeholder="핸드폰 번호 ('-' 제외)" name="phone" id="phone"/>
                        </div>
                    </form>
                </div>




                <%-- 회원가입 버튼 --%>
                <div class="login-btn-box">
                    <button class="login-btn" type="button" onclick=AjaxFunc.signUp()>회원가입</button>
                </div>
            </div>
        </main>
    </body>
</html>
