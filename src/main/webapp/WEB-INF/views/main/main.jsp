<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 메인 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>


<c:set var="getVideoReqUrl" value="/videoReq/getRecentReqList"/>
<c:set var="updateVideoReqUrl" value="/videoReq/updateVideoReq"/>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
    <body>
        <%-- 네이버 지도 --%>
        <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}"></script>
        <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}&submodules=geocoder"></script>

        <%-- bootstrap 모달 --%>
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

        <%-- 지도 함수 --%>
        <script src="<c:url value='/js/util/mapUtils.js' />"></script>

        <script>
            <%-- Document Ready! --%>
            $(document).ready(function() {
                // 초기 지도 생성 및 핀 그리기
                MapFunc.drawMap(${reqList}); 

                // 엔터키 감지 및 버튼 클릭 트리거
                const searchInput = $('#addressSearch');

                searchInput.on('keypress', function (event) {
                    // 엔터키를 감지
                    if (event.key === 'Enter') {
                        MapFunc.searchAddressToCoordinate();
                    }
                });

                // 촬영 예정일
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
                    $('#modal-phone').text(phone);
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
                    }).attr('rows', 4);          // 최대 4줄 표시.

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
                }
            };

            let AjaxFunc = {
                // 비디오 신청정보 업데이트
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
                        url: `${updateVideoReqUrl}`,
                        type: 'POST',
                        cache: false,
                        data: formData,
                    })
                    .done((response) => {
                        // 모달 닫기
                        $('#staticBackdrop').modal('hide');
                        
                        Toast('top', 1000, 'success', '수정되었습니다!');

                        // 열린 InfoWindow 닫기
                        MapFunc.openInfoWindow.close();
                        
                        AjaxFunc.loadUpdatedData();
                        LoadingOverlay.hide();
                    })
                    .fail((xhr, textStatus, thrownError) => {
                        Toast('top', 1000, 'error', '업데이트 중 문제가 발생했습니다.');
                        LoadingOverlay.hide();
                    });
                },

                // 업데이트 후 핀 재생성을 위한 데이터 불러오기
                loadUpdatedData: function() {
                    $.ajax({
                        url: `${getVideoReqUrl}`,
                        type: 'POST',
                        dataType: 'json',
                    })
                    .done((updatedReqList) => {

                        // 지도를 다시 그림
                        MapFunc.drawMap(updatedReqList);
                    })
                    .fail((xhr, textStatus, thrownError) => {
                        Toast('top', 1000, 'error', '데이터를 가져오는 중 문제가 발생했습니다.');
                    });
                }
            }
        </script>

        <!-- 매장 상세 모달 -->
        <%@ include file="/WEB-INF/views/cmm/template/mylayout/modal/modal.jsp" %>

        <!-- 지도 -->
        <div class="map-search-container">
            <div>☉ 전국 촬영 신청 지도</div>
            <input type="text" class="map-search-field" id="addressSearch" />
            <button type="button" class="common-blue-btn search-btn" onclick=MapFunc.searchAddressToCoordinate() >
                <span class="map-search-btn-text">주소 검색</span>
            </button>
        </div>
        <div class="map-pin-explain-box">
            <div class="pin-box">
                <img src="/images/common/blue_marker.png" alt="">
                <div>: 일정조율필요</div>
            </div>
            <div class="pin-box">
                <img src="/images/common/red_marker.png" alt="">
                <div>: 긴급건</div>
            </div>
            <div class="pin-box">
                <img src="/images/common/green_marker.png" alt="">
                <div>: 촬영대기</div>
            </div>
        </div>
        <div id="map" class="map"></div>
    </body>
</html>
