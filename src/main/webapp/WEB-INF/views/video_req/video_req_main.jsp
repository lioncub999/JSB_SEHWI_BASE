<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 촬영 신청 리스트 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<c:set var="videoReqUrl" value="/videoReq"/>
<c:set var="updateVideoReqUrl" value="/videoReq/updateVideoReq"/>

<html>
<head>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
<body>
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
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
        $(document).ready(function () {
            // 현재 URL에서 searchStoreNm 값 가져오기
            const url = new URL(window.location.href);
            const searchStoreNm = url.searchParams.get('searchStoreNm');
            
            $("#searchStoreNm").val(searchStoreNm);

            // 촬영예정일
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

            // 엔터키 감지 및 버튼 클릭 트리거
            const searchInput = document.getElementById('searchStoreNm');

            searchInput.addEventListener('keypress', function (event) {
                // 엔터키를 감지
                if (event.key === 'Enter') {
                    AjaxFunc.searchStoreNm();
                }
            });
        });

        let PageControlFunc = {
            <%-- 촬영 신청 추가 페이지 이동 --%>
            moveToReqAddPage: function () {
                window.location.href = '/videoReq/reqCreate';
            }
        };

        let PageFunc = {
            resetSearch : function() {
                window.location.href = '/videoReq'
            },

            // 모달창 정보 업데이트
            updateModal : function(isUrgentReq, reqId, storeName, creId, creNm, creJgNm, stringContractDt, stringCreDt, address, phone, managerNm, managerJgNm, note, status, progressNote, stringShootReserveDtm, stringShootCompleteDt, stringUploadCompleteDt) {
                $('#modal-is-urgent-req').text(isUrgentReq == "Y" ? "긴급건" : "");
                $('#reqId').val(reqId);
                $('#exampleModalLabel').text('[' + storeName + ']');
                if (creNm == '' || creNm == null) {
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
            }
        }

        let AjaxFunc = {
            <%-- 상호명 검색 --%>
            searchStoreNm: function() {
                var searchStoreNm = $('#searchStoreNm').val();

                window.location.href = '/videoReq?curPage='+${1}+'&'+'searchStoreNm='+searchStoreNm;

            },

            <%-- 비디오 신청 정보 업데이트 --%>
            updateVideoReq: function() {
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
                    console.log('AJAX error:', textStatus, thrownError);
                    Toast('top', 1000, 'error', '업데이트 중 문제가 발생했습니다.');
                    LoadingOverlay.hide();
                });
            },
        }
    </script>

    <!-- 매장 상세 모달 -->
    <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="1" aria-labelledby="staticBackdropLabel" aria-hidden="false" >
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title fs-5" id="exampleModalLabel">[상호명]</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="video-req-frm", id="video-req-frm">
                        <input type="hidden" id="reqId" name="reqId"/>
                        
                        <table class="table table-striped table-bordered" >
                            <col>
                                <td style="width : 20%"></td>
                                <td style="width : 80%"></td>
                            </col>
                            <col>
                                <div style="color:red" id="modal-is-urgent-req">긴급건</div>
                            </col>
                            <tr>
                                <td class="text-center">신청자</td>
                                <td class="text-center" id ="modal-cre-id"></td>
                            </tr>
                            <tr>
                                <td class="text-center">계약일</td>
                                <td class="text-center" id ="modal-contract-dt"></td>
                            </tr>
                            <tr>
                                <td class="text-center">촬영 신청일</td>
                                <td class="text-center" id ="modal-cre-dt"></td>
                            </tr>
                            <tr>
                                <td class="text-center">휴대폰번호</td>
                                <td class="text-center" id ="modal-phone"></td>
                            </tr>
                            <tr>
                                <td class="text-center">주소</td>
                                <td class="text-center" id ="modal-address"></td>
                            </tr>
                            
                            <tr>
                                <td class="text-center">특이사항</td>
                                <td id ="modal-note"></td>
                            </tr>
                            <tr>
                                <td class="text-center">진행상태</td>
                                <td class="text-center" id ="modal-status"></td>
                            </tr>
                            <tr>
                                <td class="text-center">촬영담당자</td>
                                <td class="text-center" id ="modal-manager-nm"></td>
                            </tr>
                            <tr>
                                <td class="text-center">촬영담당자<br>특이사항</td>
                                <td id ="modal-progress-note" style="text-align:left"></td>
                            </tr>
                            <tr>
                                <td class="text-center">촬영<br>예정일</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${userGrade == 0}">
                                            <div>
                                                <input type="text" class="form-control" id="shootReserveDtm" name="shootReserveDtm" style="font-size:13px">
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="stringShootReserveDtm" style="font-size:13px"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">촬영<br>완료일</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${userGrade == 0}">
                                            <div>
                                                <input type="text" class="form-control" id="shootCompleteDt" name="shootCompleteDt" style="font-size:13px" readonly>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="stringShootCompleteDt" style="font-size:13px"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">영상<br>업로드일</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${userGrade == 0}">
                                            <div>
                                                <input type="text" class="form-control" id="uploadCompleteDt" name="uploadCompleteDt" style="font-size:13px" readonly>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="stringUploadCompleteDt" style="font-size:13px"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" >닫기</button>
                    <div class="save-btn-box" id="save-btn-box"></div>
                </div>
            </div>
        </div>
    </div>
    

    <div class="reqTopBox">
        <button onclick="PageControlFunc.moveToReqAddPage()" class="common-blue-btn">촬영 신청</button>

        <div style="display:flex">
            <input class="main-search-input" type="text" id="searchStoreNm" placeholder="상호명 검색" >
            <button onclick=AjaxFunc.searchStoreNm() class="common-blue-btn main-search-btn" >
                <div class="button-text">
                    검색
                </div>
            <button onclick=PageFunc.resetSearch() class="common-blue-btn main-search-btn" >
                <div class="button-text">
                    초기화
                </div>
            </button>
        </div>
    </div>

    <%-- 페이지네이션 --%>
    <nav aria-label="Page navigation example" style="justify-items : center">
        <ul class="pagination">
            <li class="page-item">
                <a class="page-link" href="/videoReq?curPage=1" aria-label="Previous">
                    <span aria-hidden="true">&lt;&lt;</span>
                </a>
            </li>

            <li class="page-item">
                <a class="page-link" href="/videoReq?curPage=${curPage - 1 > 0 ? curPage- 1 : 1}" aria-label="">
                    <span aria-hidden="true">&lt;</span>
                </a>
            </li>
                
            <!-- 현재 페이지 그룹에 맞는 페이지 버튼만 출력 -->
            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                <li class="page-item ${i == curPage ? 'active' : ''}">
                    <a class="page-link" href="/videoReq?curPage=${i}" aria-label="">
                        <span aria-hidden="true">${i}</span>
                    </a>
                </li>
            </c:forEach>
            
            <li class="page-item">
                <a class="page-link" href="/videoReq?curPage=${curPage + 1 <= maxPage ? curPage + 1 : maxPage}" aria-label="">
                    <span aria-hidden="true">&gt;</span>
                </a>
            </li>
            <a class="page-link" href="/videoReq?curPage=${maxPage}" aria-label="Next">
                <span aria-hidden="true">&gt;&gt;</span>
            </a>
            </li>
        </ul>
    </nav>

    <div class="video-req-table-container">
        <%-- 요청 리스트 테이블 --%>
        <table class="table table-striped table-bordered" >
            <thead class="text-center">
                <tr>
                    <th style="width: 3%; border-top-left-radius:10px;">신청<br>ID</th>
                    <th style="width: 8%;">신청일</th>
                    <th style="width: 6%;">신청자</th>
                    <th style="width: 8%;">사장님<br>연락처</th>
                    <th style="width: 10%;">상호명</th>
                    <th style="width: 15%;">주소</th>
                    <th style="width: 16%;">특이사항</th>
                    <th style="width: 16%;">촬영담당자<br>특이사항</th>
                    <th style="width: 5%;">촬영<br>담당자</th>
                    <th style="width: 8%; border-top-right-radius:10px;">진행상태</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="videoReq" items="${videoReqList}">
                    <tr onclick="PageFunc.updateModal('${videoReq.isUrgentReq}', '${videoReq.reqId}', '${videoReq.storeNm}', '${videoReq.creId}', '${videoReq.creNm}', '${videoReq.creJgNm}', '${videoReq.stringContractDt}', '${videoReq.stringCreDt}', '${videoReq.address}', '${videoReq.phone}', '${videoReq.managerNm}', '${videoReq.managerJgNm}', '${videoReq.note}', '${videoReq.status}', '${videoReq.progressNote}', '${videoReq.stringShootReserveDtm}', '${videoReq.stringShootCompleteDt}', '${videoReq.stringUploadCompleteDt}')" data-bs-toggle="modal" data-bs-target="#staticBackdrop">
                        <td class="text-center t-cell">${videoReq.reqId}</td>
                        <td class="text-center t-cell">${videoReq.stringCreDt}</td>
                        <td class="text-center t-cell">${videoReq.creNm == '' || videoReq.creNm == null  ? videoReq.creId : videoReq.creNm} ${videoReq.creJgNm}</td>
                        <td class="text-center t-cell">
                            ${videoReq.phone.substring(0,3)}-${videoReq.phone.substring(3,7)}-${videoReq.phone.substring(7)}
                        </td>
                        <td class="t-cell">${videoReq.isUrgentReq == "Y" ?"<div style='color:red'>(긴급건)</div>" : ""}${videoReq.storeNm}</td>
                        <td class="t-cell">${videoReq.address}</td>
                        <td class="t-cell" style="text-align:left">
                            ${videoReq.note.replace('\\n', '<br>')}
                        </td>
                        <td class="t-cell" style="text-align:left">
                            ${videoReq.progressNote.replace('\\n', '<br>')}
                        </td>
                        <td class="text-center t-cell">${videoReq.managerNm} ${videoReq.managerJgNm}</td>
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