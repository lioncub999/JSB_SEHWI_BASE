<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 로그인 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %> <%--한국어 깨짐 방지--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %> <%--한국어 깨짐 방지--%>


<c:set var="loginUrl" value="/login"/>
<c:set var="idDubCheckUrl" value="/auth/dupCheck"/>
<c:set var="signUpUrl" value="/auth/signUp"/>

<html>
    <head>
        <meta name="viewport"z
            content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link type="text/css" rel="stylesheet" href="<c:url value='/css/normalize.css'/>">
        <link type="text/css" rel="stylesheet" href="<c:url value='/css/login.css'/>">
        
    </head>

    <body>
        <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
        <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
        <script src="<c:url value='/js/util/textUtils.js' />"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>

        <script>
            function validateEnglishAndNumberInput(input) {
                // 영어 알파벳과 숫자만 허용
                input.value = input.value.replace(/[^a-zA-Z0-9]/g, '');
            }
        </script>

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
            let PageControlFunc ={
                // 로그인 화면으로 이동
                moveToLoginPage : function() {
                    location.href = '/login';
                }
            };


            let SubmitFunc = {
                // 아이디 중복확인 값 valid 확인
                dubCheckSubmit: function() {
                    var warningTxt = '';

                    LoadingOverlay.show();
                    <%-- userId 빈값 확인 --%>
                    if ($('#userId').val() == '') {
                        warningTxt += '아이디를 입력해주세요!';
                    }

                    <%-- 워닝 표시 --%>
                    if (warningTxt != '') {
                        Toast('top', 2000, 'warning', warningTxt);
                        LoadingOverlay.hide();
                        return;
                    }

                    AjaxFunc.idDupCheck();
                },

                // 회원가입 값 valid 확인
                signUpSubmit: function() {
                    var warningTxt = '';

                    LoadingOverlay.show();

                    <%-- 가입코드 입력 확인 --%>
                    if ($("#signUpCode").val() == '') {
                        warningTxt += "가입 코드를 입력해주세요!\n"
                    }
                    <%-- 아이디 입력 확인 --%>
                    if ($('#userId').val() == '') {
                        warningTxt += "아이디를 입력해주세요!\n"
                    }
                    <%-- 아이디 중복 확인 여부 --%>
                    if ($('#idDupCheck').val() == 'N') {
                        warningTxt += "아이디 중복확인을 완료해주세요!\n"
                    }
                    <%-- 비밀번호 입력 확인 --%>
                    if ($('#userPw').val() == '' || $('#userPwCheck').val() == '') {
                        warningTxt += "비밀번호를 입력해 주세요!\n"
                    }
                    <%-- 비밀번호 일치 확인 --%>
                    if ($('#userPw').val() != $('#userPwCheck').val()) {
                        warningTxt += "비밀번호가 일치하지 않습니다!\n"
                    }
                    <%-- 이름 입력 확인 --%>
                    if ($('#userNm').val() == '') {
                        warningTxt += "이름을 입력해주세요!\n"
                    }
                    <%-- 직급 입력 확인 --%>
                    if ($('#jobGrade').val() == '직급을 선택해주세요') {
                        warningTxt += "직급을 선택해주세요!\n"
                    }
                    <%-- 연락처 입력 확인 --%>
                    if ($('#phone').val() == '') {
                        warningTxt += "핸드폰 번호를 입력해주세요!\n"
                    }
                    <%-- 연락처 형식 확인 --%>
                    if (!IsPhoneValid($('#phone').val())) {
                        warningTxt += "휴대폰 번호 형식을 확인해주세요"
                    }
                    <%-- 워닝 표시 --%>
                    if (warningTxt != '') {
                        Toast('top', 2000, 'warning', warningTxt);
                        LoadingOverlay.hide();
                        return;
                    }

                    AjaxFunc.signUp();
                }
            };

            let AjaxFunc = {
                // 아이디 중복 확인
                idDupCheck: function() {
                    var userId = $('#userId').val();

                    $.ajax({
                        url: "${idDubCheckUrl}",
                        type: "post",
                        cache: false,
                        contentType: "application/json", // JSON 전송
                        data: JSON.stringify({ userId: userId }), // JSON 형식으로 변환
                    }).done(function (response) {
                        if (response == 0) {
                            $('#userId').prop('readonly', true);
                            $('#dubCheckBtn').prop('disabled', true);
                            $('#idDupCheck').val("Y");

                            Toast('top', 2000, 'success', "사용 가능한 아이디 입니다!");
                        } else {
                            Toast('top', 2000, 'warning', "중복 아이디가 존재합니다!");
                        }
                    });
                    LoadingOverlay.hide();
                },

                // 회원가입
                signUp: function (xhr, textStatus, thrownError) {
                    var formData = $('#login-frm').serialize()

                    $.ajax({
                        url: "${signUpUrl}",
                        type: "post",
                        cache: false,
                        data: formData,
                    }).done(function (response) {
                        console.log(response);  
                        if (response == "codeError") {
                            Toast('top', 2000, 'warning', "가입 코드가 일치하지 않습니다!");
                            return;
                        }
                        if (response == "success") {
                            Swal.fire({
                                icon: 'success',
                                title: '회원가입이 완료되었습니다!',
                                allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.location.href = "${loginUrl}";
                                }
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: '오류가 발생했습니다. 지속 현상 발생시 관리자에게 문의해주세요.',
                                allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                            });
                        }
                    }); 
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
                <%-- 로그인 페이지로 이동 버튼 --%>
                <div class="login-btn-box">
                    <button class="login-btn" id="loginButton" type="button" onclick=PageControlFunc.moveToLoginPage()>로그인 페이지로 이동</button>
                </div>

                <%-- 회원가입 타이틀 --%>
                <div class="login-title" id="login">
                    <img class="logo-img" src="<c:url value='/images/logo/modusol_logo.png'/>" alt=""/>
                    <h2>모두솔루션 영상촬영 관리 회원가입</h2>
                </div>

                <%-- 회원가입 폼 --%>
                <div>
                    <form class="login-frm", id="login-frm">

                        <%-- 아이디 중복확인 완료여부 --%>
                        <input type="hidden" name="idDupcheck", value="N" id="idDupCheck">

                        <%-- 가입코드 --%>
                        <div class="input-box">
                            <input type="text" class="input" placeholder="가입코드" name="signUpCode" id="signUpCode"/>
                        </div>

                        <%-- 아이디 --%>
                        <div class="input-box" style="display:flex;">
                            <input type="text" class="input" placeholder="아이디" name="userId" style="width:220px;" id="userId" oninput="validateEnglishAndNumberInput(this)" />
                            <button class="common-blue-btn" type="button" onclick="SubmitFunc.dubCheckSubmit()" id="dubCheckBtn">중복확인</button>
                        </div>

                        <%-- 비밀번호 --%>
                        <div class="input-box">
                            <input type="password" class="input password" placeholder="비밀번호" name="userPw" id="userPw"/>
                        </div>

                        <%-- 비밀번호 확인 --%>
                        <div class="input-box">
                            <input type="password" class="input password" placeholder="비밀번호 확인" name="userPwCheck" id="userPwCheck"/>
                        </div>

                        <%-- 이름 --%>
                        <div class="input-box">
                            <input type="text" class="input" placeholder="이름" name="userNm" id="userNm"/>
                        </div>

                        <%-- 직급 --%>
                        <div class="input-box">
                            <select class="form-select" style="width:300px" id="jobGrade", name="jobGrade">
                            <option selected>직급을 선택해주세요</option>
                            <option value="JG1">이사</option>
                            <option value="JG2">본부장</option>
                            <option value="JG3">팀장</option>
                            <option value="JG4">차장</option>
                            <option value="JG5">과장</option>
                            <option value="JG6">총무</option>
                            <option value="JG7">대리</option>
                            <option value="JG8">사원</option>
                            </select>
                        </div>


                        <%-- 핸드폰번호 --%>
                        <div class="input-box">
                            <input type="text" class="input" placeholder="핸드폰 번호 ('-' 제외)" name="phone" id="phone"/>
                        </div>
                    </form>
                </div>

                <%-- 회원가입 버튼 --%>
                <div class="login-btn-box">
                    <button class="login-btn" type="button" onclick=SubmitFunc.signUpSubmit()>회원가입</button>
                </div>
            </div>
        </main>
    </body>
</html>
