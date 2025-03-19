<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 마이페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>


<c:set var="videoReqUpdateUrl" value="/video/videoReqUpdate"/>
<c:set var="changeJobGradeUrl" value="/mypage/changeJobGrade"/>
<c:set var="passResetUrl" value="/auth/resetPass"/>
<c:set var="logoutUrl" value="/auth/logout"/>
<c:set var="loginUrl" value="/auth/login"/>

<html>
    <head>
        <meta name="viewport"
            content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    </head>
    <body>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Datepicker 스타일시트 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/css/bootstrap-datepicker.min.css" rel="stylesheet">

        <!-- datepicker JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/js/bootstrap-datepicker.min.js"></script>


        <!-- dateTimePicker JS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-datetimepicker/2.5.4/jquery.datetimepicker.min.css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-datetimepicker/2.5.4/build/jquery.datetimepicker.full.min.js"></script>

        <!-- 한국어 로케일 파일 추가 -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/locales/bootstrap-datepicker.kr.min.js"></script>

        <script>
            <%-- Document Ready! --%>
            $(document).ready(function() {
                $('#jobGrade').val(`${currentUserInfo.jobGrade}`);

                $('#shootReserveDtm').datetimepicker({
                    format: 'Y-m-d H:i',       // 날짜와 시간 형식
                    step : 30,
                });
                $.datetimepicker.setLocale('kr');

                // 최종적으로 input 값 초기화
                $('#shootReserveDtm').on('input', function () {
                    $(this).val(''); // 값이 입력되더라도 초기화
                });


                // 촬영 완료일
                $('#shootCompleteDt').datepicker({
                    format: 'yyyy-mm-dd', // 날짜 형식
                    autoclose: true, // 날짜 선택 후 자동으로 닫기
                    todayHighlight: true, // 오늘 날짜 하이라이트
                    language: "kr",
                });
                // 업로드 일
                $('#uploadCompleteDt').datepicker({
                    format: 'yyyy-mm-dd', // 날짜 형식
                    autoclose: true, // 날짜 선택 후 자동으로 닫기
                    todayHighlight: true, // 오늘 날짜 하이라이트
                    language: "kr",
                });
            });

            let PageFunc = {
                // 모달창 정보 업데이트
                updateModal : function(isUrgentReq, reqId, storeName, creId, creNm, creJgNm, stringContractDt, stringCreDt, address, phone, managerNm, managerJgNm, note, status, progressNote, stringShootReserveDtm, stringShootCompleteDt, stringUploadCompleteDt) {
                    $('#modal-is-urgent-req').text(isUrgentReq == "Y" ? "긴급건" : "");
                    $('#reqId').val(reqId);
                    $('#exampleModalLabel').text('[' + storeName + ']');

                    if (creNm == '' || creNm == null || creNm == "null") {
                        $('#modal-cre-id').text(creId);
                    } else {
                        var creNm = creNm + ' ' + creJgNm;
                        $('#modal-cre-id').text(creNm);
                    }
                    $('#modal-contract-dt').text(stringContractDt);
                    $('#modal-cre-dt').text(stringCreDt);
                    $('#modal-address').text(address);
                    $('#modal-phone').text(phone.substring(0,3)+'-'+phone.substring(3,7)+'-'+phone.substring(7));
                    $('#modal-manager-nm').text(managerNm + ' ' + managerJgNm);

                    $('#shootReserveDtm').val(stringShootReserveDtm);
                    $('#shootCompleteDt').val(stringShootCompleteDt);
                    $('#uploadCompleteDt').val(stringUploadCompleteDt);

                    $('#stringShootReserveDtm').text(stringShootReserveDtm);
                    $('#stringShootCompleteDt').text(stringShootCompleteDt);
                    $('#stringUploadCompleteDt').text(stringUploadCompleteDt);

                    <%-- 업로드 완료된 요청은 저장버튼 안보이게 처리 --%>
                    const buttonCell = $("#save-btn-box");

                    buttonCell.html('');

                    if (status != "COMPLETEUPLOAD") {
                        const saveBtn = $("<button>", {
                            type: "button",
                            class: "btn btn-primary",
                            onclick: "AjaxFunc.updateVideoReq()", // 문자열로 전달
                            text: "저장" // 버튼 텍스트
                        });

                        buttonCell.append(saveBtn);
                    }


                    // 특이사항 (전체 수정 가능)
                    const modalNoteCell = $('#modal-note');
                    modalNoteCell.html('');

                    // 특이사항 <textarea> 생성
                    const textArea = $('<textarea>', {
                        name: 'note',
                        text: note, // note 값을 디폴트로 설정
                    }).css({
                        resize: 'none',          // 크기 조절 불가
                        overflowY: 'auto',       // 세로 스크롤 활성화
                        width: '100%',           // 부모 요소 크기에 맞게 설정
                    }).attr('rows', 4);          // 최대 4줄 표시

                    // 작은따옴표와 큰따옴표 입력 제한
                    textArea.on('input', function () {
                        const restrictedChars = /['"]/g; // 작은따옴표('), 큰따옴표(")
                        const value = $(this).val();
                        if (restrictedChars.test(value)) {
                            $(this).val(value.replace(restrictedChars, ''));
                            Toast('top', 1000, 'warning', '작은따옴표와 큰따옴표는 입력할 수 없습니다!');
                        }
                    });

                    // 특이사항 <textarea>를 td에 추가
                    modalNoteCell.append(textArea);

                    // 진행 상태 수정
                    const modalStatusCell = $('#modal-status');

                    modalStatusCell.html('');

                    // <div> 생성
                    const inputBoxDiv = $('<div>', {
                        class: 'input-box'
                    });

                    // <select> 생성
                    const selectElement = $('<select>', {
                        class: 'form-select',
                        id: 'status',
                        name: 'status'
                    });

                    var options;
                    // <option> 요소 추가
                    if (${userGrade} == 0) {
                        options = [
                            { value: 'COORDINATION', text: '일정조율중' },
                            { value: 'STANDBY', text: '촬영대기' },
                            { value: 'COMPLETEFILM', text: '촬영완료' },
                            { value: 'COMPLETEUPLOAD', text: '촬영&업로드 완료' },
                            { value: 'NONEEDFILM', text: '촬영 불필요' },
                        ];
                    } else {
                        options = [
                            { value: 'COORDINATION', text: '일정조율중' },
                            { value: 'NONEEDFILM', text: '촬영 불필요' },
                        ];
                    }

                    options.forEach(optionData => {
                        $('<option>', {
                            value: optionData.value,
                            text: optionData.text,
                            selected: optionData.value === status // status 값에 따라 기본 선택 설정
                        }).appendTo(selectElement); // <select>에 추가
                    });


                    // <select>를 <div> 안에 추가
                    inputBoxDiv.append(selectElement);

                    // <div>를 모달의 상태 셀에 추가
                    modalStatusCell.append(inputBoxDiv);

                    if (${userGrade} === 0) {
                        // 촬영 담당자 작성 특이사항(촬영자만 수정가능)
                        const modalProgressNoteCell = $('#modal-progress-note');
                        modalProgressNoteCell.html('');

                        // 촬영 담당자 특이사항 <textarea> 생성
                        const progressNoteTextArea = $('<textarea>', {
                            name: 'progressNote',
                            text: progressNote !== 'null' ? progressNote : '' // note 값을 디폴트로 설정
                        }).css({
                            resize: 'none',          // 크기 조절 불가
                            overflowY: 'auto',       // 세로 스크롤 활성화
                            width: '100%',           // 부모 요소 크기에 맞게 설정
                            boxSizing: 'border-box'  // 패딩 포함 크기 계산
                        }).attr('rows', 4); // 최대 4줄 표시

                        // 작은따옴표와 큰따옴표 입력 제한
                        progressNoteTextArea.on('input', function () {
                            const restrictedChars = /['"]/g; // 작은따옴표('), 큰따옴표(")
                            const value = $(this).val();
                            if (restrictedChars.test(value)) {
                                $(this).val(value.replace(restrictedChars, ''));
                                Toast('top', 1000, 'warning', '작은따옴표와 큰따옴표는 입력할 수 없습니다!');
                            }
                        });

                        // 촬영 담당자 특이사항 <textarea>를 td에 추가
                        $(modalProgressNoteCell).append(progressNoteTextArea);
                    } else {
                        $('#modal-progress-note').text(progressNote);
                    }
                },

                passResetConfirmAlert : function() {
                    Swal.fire({
                        icon: 'warning',
                        title: '비밀번호를 초기화하시겠습니까?',
                        text : '초기화시 로그아웃되며 비밀번호가 "1111"로 초기화 됩니다. 재로그인시 비밀번호 설정이 가능합니다!',
                        allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                        confirmButtonText : "초기화!",
                        showCancelButton : true,
                        cancelButtonColor: "#d33",
                        cancelButtonText: "취소",
                    }).then((result) => {
                        if (result.isConfirmed) {
                            AjaxFunc.resetPassword();
                        }
                    });
                },

                changeJobGradeConfirm : function() {
                    Swal.fire({
                        icon: 'warning',
                        title: '직급을 변경하시겠습니까?',
                        text : '변경시 적용을 위해 자동으로 로그아웃됩니다!',
                        allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                        confirmButtonText : "변경!",
                        showCancelButton : true,
                        cancelButtonColor: "#d33",
                        cancelButtonText: "취소",
                    }).then((result) => {
                        if (result.isConfirmed) {
                            AjaxFunc.chageJobGrade();
                        } else {
                            $('#jobGrade').val(`${currentUserInfo.jobGrade}`);
                        }
                    });
                }

            };

            let AjaxFunc = {
                <%-- 비밀번호 초기화 --%>
                resetPassword: function () {
                    $.ajax({
                        url: "${passResetUrl}",
                        type: "post",
                        cache: false,
                        data: {},
                    }).done(function (response) {
                        if (response) {
                            Toast('top', 2000, 'success', '비밀번호가 초기화되었습니다(1111)');

                            AjaxFunc.logout();
                        } else {
                            alert('에러 발생')
                        }
                    })
                },

                <%-- 로그아웃 --%>
                logout: function () {
                    $.ajax({
                        url: "${logoutUrl}",
                        type: "post",
                        cache: false,
                    }).done(function (response) {
                        if (response) {
                            setTimeout(function () {
                                window.location.href = "/auth/login"
                            }, 1000)
                        } else {
                            alert('에러 발생')
                        }

                        LoadingOverlay.hide();
                    })
                },

                <%-- 비디오 신청 정보 업데이트 --%>
                updateVideoReq: function() {
                    if ($('#status').val() == 'STANDBY') {
                        if ($('#shootReserveDtm').val() == '') {
                            Toast('top', 1000, 'warning', '촬영 예정일을 선택해주세요!!');

                            return;
                        }
                    }

                    if ($('#status').val() == 'COMPLETEFILM') {
                        if ($('#shootReserveDtm').val() == '') {
                            Toast('top', 1000, 'warning', '촬영 예정일을 선택해주세요!!');

                            return;
                        }
                        if ($('#shootCompleteDt').val() == '') {
                            Toast('top', 1000, 'warning', '촬영 완료일을 선택해주세요!!');

                            return;
                        }
                    }
                    
                    if ($('#status').val() == 'COMPLETEUPLOAD') {
                        if ($('#shootReserveDtm').val() == '') {
                            Toast('top', 1000, 'warning', '촬영 예정일을 선택해주세요!!');

                            return;
                        }
                        if ($('#shootCompleteDt').val() == '') {
                            Toast('top', 1000, 'warning', '촬영 완료일을 선택해주세요!!');

                            return;
                        }
                        if ($('#uploadCompleteDt').val() == '') {
                            Toast('top', 1000, 'warning', '업로드일을 선택해주세요!!');

                            return;
                        }
                    }
                    
                    var formData = $('#video-req-frm').serializeArray();

                    formData.find(field => field.name === "note").value = formData.find(field => field.name === "note").value.replace(/\r?\n/g, "\\n");
                    formData.find(field => field.name === "note").value = formData.find(field => field.name === "note").value.replace(/['"]/g, "");

                    if (${userGrade} == 0) {
                        formData.find(field => field.name === "progressNote").value = formData.find(field => field.name === "progressNote").value.replace(/\r?\n/g, "\\n");
                        formData.find(field => field.name === "progressNote").value = formData.find(field => field.name === "progressNote").value.replace(/['"]/g, "");
                    }

                    $.ajax({
                        url: "${videoReqUpdateUrl}",
                        type: 'POST',
                        cache: false,
                        data: formData,
                    })
                    .done((response) => {
                        // 모달 닫기
                        if (response == "success") {
                            $('#staticBackdrop').modal('hide');
                        
                            Toast('top', 1000, 'success', '수정되었습니다!');

                            setTimeout(() => {
                                location.reload();

                                LoadingOverlay.hide();
                            }, 1100); 
                        } else {
                            Toast('top', 1000, 'error', '오류가 발생했습니다!');
                        }
                        
                    })
                    .fail((xhr, textStatus, thrownError) => {
                        Toast('top', 1000, 'error', '업데이트 중 문제가 발생했습니다.');
                        LoadingOverlay.hide();
                    });
                },

                chageJobGrade : function() {
                    LoadingOverlay.show();

                    var formData = $('#mypage-frm').serializeArray();

                    $.ajax({
                        url: `${changeJobGradeUrl}`,
                        type: 'POST',
                        cache: false,
                        data: formData,
                    })
                    .done((response) => {
                        // 모달 닫기
                        if (response == true) {
                            $('#staticBackdrop').modal('hide');
                        
                            Toast('top', 1000, 'success', '수정되었습니다!');

                            AjaxFunc.logout();
                        } else {
                            Toast('top', 1000, 'error', '오류가 발생했습니다!');

                            LoadingOverlay.hide();
                        }
                        
                    })
                    .fail((xhr, textStatus, thrownError) => {
                        Toast('top', 1000, 'error', '업데이트 중 문제가 발생했습니다.');
                        LoadingOverlay.hide();
                    });
                }
            };
        </script>

        <!-- 매장 상세 모달 -->
        <%@ include file="/WEB-INF/views/cmm/template/mylayout/modal/modal.jsp" %>

                
        <div class="table-title">
            ☉ 내 정보
        </div>
        <form class="mypage-frm", id="mypage-frm">
            <div class="table-container">
                <table class="table table-bordered" >
                    <tbody>
                        <tr>
                            <th style="width: 20%;">
                                아이디
                            </th>
                            <td>
                                ${currentUserInfo.userId}
                            </td>
                        </tr>
                        <tr>
                            <th>
                                이름
                            </th>
                            <td>
                                ${currentUserInfo.userNm}
                            </td>
                        </tr>
                        <tr>
                            <th>
                                직급
                            </th>
                            <td>
                                <%-- 직급 --%>
                                <div class="input-container">
                                    <select class="form-select" style="text-align : center" id="jobGrade", name="jobGrade"  onchange=PageFunc.changeJobGradeConfirm()>
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
                            </td>
                        </tr>
                        <tr>
                            <th>
                                전화번호
                            </th>
                            <td>
                                ${currentUserInfo.phone.substring(0,3)}-${currentUserInfo.phone.substring(3,7)}-${currentUserInfo.phone.substring(7)}
                            </td>
                        </tr>
                        <tr>
                            <th>
                                비밀번호 초기화
                            </th>
                            <td>
                                <button type="button" class="common-blue-btn pass-reset-btn" onclick=PageFunc.passResetConfirmAlert()>비밀번호 초기화</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </form>

        <div class="table-title">
            ☉ 내 촬영신청 리스트
        </div>
        <%-- 페이지네이션 --%>
        <nav class="paging" aria-label="Page navigation example">
            <ul class="pagination">
                <li class="page-item">
                    <a class="page-link" href="/mypage?curPage=1" aria-label="Previous">
                        <span aria-hidden="true">&lt;&lt;</span>
                    </a>
                </li>

                <li class="page-item">
                    <a class="page-link" href="/mypage?curPage=${curPage - 1 > 0 ? curPage- 1 : 1}" aria-label="">
                        <span aria-hidden="true">&lt;</span>
                    </a>
                </li>
                    
                <!-- 현재 페이지 그룹에 맞는 페이지 버튼만 출력 -->
                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                    <li class="page-item page-num ${i == curPage ? 'active' : ''}">
                        <a class="page-link" href="/mypage?curPage=${i}" aria-label="">
                            <span aria-hidden="true">${i}</span>
                        </a>
                    </li>
                </c:forEach>
                
                <li class="page-item">
                    <a class="page-link" href="/mypage?curPage=${curPage + 1 <= maxPage ? curPage + 1 : maxPage}" aria-label="">
                        <span aria-hidden="true">&gt;</span>
                    </a>
                </li>
                <li class="page-item">
                    <a class="page-link" href="/mypage?curPage=${maxPage}" aria-label="Next">
                        <span aria-hidden="true">&gt;&gt;</span>
                    </a>
                </li>
            </ul>
        </nav>
        <%-- 요청 리스트 테이블 --%>
        <div class="table-container">
            <table class="table table-bordered" >
                <thead class="text-center">
                    <tr>
                        <th style="width: 3%;" class="cell-req-id">신청<br>ID</th>
                        <th style="width: 8%;" class="cell-phone">사장님<br>연락처</th>
                        <th style="width: 10%;" class="cell-store-nm head">상호명</th>
                        <th style="width: 15%;" class="cell-address">주소</th>
                        <th style="width: 16%;" class="cell-note">특이사항</th>
                        <th style="width: 16%;" class="cell-progress-note">촬영담당자<br>특이사항</th>
                        <th style="width: 5%;" class="cell-manager-nm">촬영<br>담당자</th>
                        <th style="width: 10%;" class="cell-shoot-reserve-dtm">촬영<br>예정일</th>
                        <th style="width: 8%;">진행상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="videoReq" items="${videoReqList}">
                        <tr onclick="PageFunc.updateModal('${videoReq.isUrgentReq}', '${videoReq.reqId}', '${videoReq.storeNm}', '${videoReq.creId}', '${videoReq.creNm}', '${videoReq.creJgNm}', '${videoReq.stringContractDt}', '${videoReq.stringCreDt}', '${videoReq.address}', '${videoReq.phone}', '${videoReq.managerNm}', '${videoReq.managerJgNm}', '${videoReq.note}', '${videoReq.status}', '${videoReq.progressNote}', '${videoReq.stringShootReserveDtm}', '${videoReq.stringShootCompleteDt}', '${videoReq.stringUploadCompleteDt}')" data-bs-toggle="modal" data-bs-target="#staticBackdrop">
                            <td class="text-center t-cell cell-req-id">${videoReq.reqId}</td>
                            <td class="text-center t-cell cell-phone">
                                ${videoReq.phone.substring(0,3)}-${videoReq.phone.substring(3,7)}-${videoReq.phone.substring(7)}
                            </td>
                            <td class="t-cell cell-store-nm">${videoReq.isUrgentReq == "Y" ?"<div style='color:red'>(긴급건)</div>" : ""}${videoReq.storeNm}</td>
                            <td class="t-cell cell-address">${videoReq.address}</td>
                            <td class="t-cell cell-note" style="text-align:left">
                                ${videoReq.note.replace('\\n', '<br>')}
                            </td>
                            <td class="t-cell cell-progress-note" style="text-align:left">
                                ${videoReq.progressNote.replace('\\n', '<br>')}
                            </td>
                            <td class="text-center t-cell cell-manager-nm">${videoReq.managerNm} ${videoReq.managerJgNm}</td>
                            <td class="text-center t-cell cell-shoot-reserve-dtm">${videoReq.stringShootReserveDtm}</td>
                            <td class="text-center t-cell">
                                <c:choose>
                                    <c:when test="${videoReq.status == 'COORDINATION'}">
                                        일정조율중
                                    </c:when>
                                    <c:when test="${videoReq.status == 'STANDBY'}">
                                        촬영대기
                                    </c:when>
                                    <c:when test="${videoReq.status == 'COMPLETEFILM'}">
                                        촬영완료
                                    </c:when>
                                    <c:when test="${videoReq.status == 'COMPLETEUPLOAD'}">
                                        촬영&업로드 완료
                                    </c:when>
                                    <c:otherwise>
                                        촬영 불필요
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
