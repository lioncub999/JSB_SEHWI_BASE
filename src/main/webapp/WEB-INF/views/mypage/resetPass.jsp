<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 로그인 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %> <%--한국어 깨짐 방지--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %> <%--한국어 깨짐 방지--%>


<c:set var="updatePasswordUrl" value="/auth/updatePass"/>

<html>
    <head>
        <meta name="viewport"z
            content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
        <link type="text/css" rel="stylesheet" href="<c:url value='/css/common/normalize.css'/>">
        <link type="text/css" rel="stylesheet" href="<c:url value='/css/view/login.css'/>">
    </head>

    <body>
        <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
        <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>

        <%--TODO: 로그인 세션 확인--%>
        <c:if test="${userId == null || userId == ''}">
        <script>
            window.location.href = "/login"
        </script>
        </c:if>

        <script>
            <%-- 로딩 오버레이 --%>
            const LoadingOverlay = {
                show: function () {
                    $('#loading-overlay').fadeIn();
                },
                hide: function () {
                    $('#loading-overlay').fadeOut();
                }
            };

    
            <%-- Document Ready! --%>
            $(document).ready(function() {
                // 로그인 세션 확인
                if ("${passReset}" == "N") {
                    window.location.href = "/contract/contractMap"
                }
            
            // 엔터키 감지 및 버튼 클릭 트리거
                document.addEventListener('keydown', function(event) {
                    if (event.key === 'Enter') {
                        // 로그인 버튼 클릭
                        document.getElementById('loginButton').click();
                    }
                });
            });

            let SubmitFunc = {
                // 로그인 값 valid 확인
                passwordCheck: function() {
                    var warningTxt = '';

                    // 비밀번호 입력 확인
                    if ($('#password').val() == '') {
                        warningTxt += "비밀번호를 입력해주세요!\n"
                    }
                    // 비밀번호확인 입력 확인
                    if ($('#passwordCheck').val() == '') {
                        warningTxt += "비밀번호 확인을 입력해주세요!\n"
                    }

                    // 비밀번호 일치확인
                    if ($('#password').val() != $('#passwordCheck').val()) {
                        warningTxt += "비밀번호가 일치하지 않습니다!\n"
                    }

                    // 워닝 표시
                    if (warningTxt != '') {
                        Toast('top', 1500, 'warning', warningTxt);
                        return;
                    }

                    AjaxFunc.updatePassword();
                }
            }

            let AjaxFunc = {
                // 로그인 ajax
                updatePassword: function () {
                    const formData = $('#login-frm').serializeArray();

                    LoadingOverlay.show();
                    $.ajax({
                        url: `${updatePasswordUrl}`,
                        type: 'POST',
                        cache: false,
                        data: formData,
                    })
                    .done((response) => {
                        if (response) {
                            Toast('top', 1000, 'success', '비밀번호가 저장되었습니다!');

                            setTimeout(() => {
                                window.location.href = '/contract/contractMap';
                            }, 1000);
                        } else {
                            Toast('top', 1000, 'error', '오류가 발생했습니다! 지속 현상 발생시 개발자에게 문의해주세요!');
                        }

                        LoadingOverlay.hide();
                    })
                    .fail((xhr, textStatus, thrownError) => {
                        console.error('AJAX error:', textStatus, thrownError);
                        Toast('top', 1000, 'error', `오류가 발생했습니다! 지속 현상 발생시 개발자에게 문의해주세요!\n${thrownError}`);
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
            <img class="logo-img" src="<c:url value='/images/logo/modusol_logo.png'/>" alt=""/>
            <div class="login-title" id="login">
                새 비밀번호 입력
            </div>

            <%-- 로그인 폼 --%>
            <div style="position : relative">
                <form class="login-frm", id="login-frm">
                    <div class="input-container">
                        <input type="password" class="input-field" placeholder="" name="userPw" id="userPw" />
                        <label for="userPw" class="input-label">비밀번호</label>
                    </div>
                    <div class="input-container">
                        <input type="password" class="input-field password" placeholder="" name="userPwCheck" id="userPwCheck" />
                        <label for="userPwCheck" class="input-label">비밀번호 확인</label>
                    </div>
                </form>
            </div>


            <%-- 저장 버튼 --%>
            <div class="login-btn-box">
                <button id="loginButton" class="login-btn" type="button" onclick=SubmitFunc.passwordCheck()>저장</button>
            </div>
        </main>
    </body>
</html>
