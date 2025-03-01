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

            $('#shootReserveDtm').datetimepicker({
                format: 'Y-m-d H:i',       // 날짜와 시간 형식
                step : 30,
            });
             $.datetimepicker.setLocale('kr');

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
            updateModal : function(reqId, storeName, creId, stringContractDt, stringCreDt, address, phone, note, status, progressNote, stringShootReserveDtm, stringShootCompleteDt, stringUploadCompleteDt) {
                $('#reqId').val(reqId);
                $('#exampleModalLabel').text('[' + storeName + ']');
                $('#modal-cre-id').text(creId);
                $('#modal-contract-dt').text(stringContractDt);
                $('#modal-cre-dt').text(stringCreDt);
                $('#modal-address').text(address);
                $('#modal-phone').text(phone);

                $('#shootReserveDtm').val(stringShootReserveDtm);
                $('#shootCompleteDt').val(stringShootCompleteDt);
                $('#uploadCompleteDt').val(stringUploadCompleteDt);


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
                formData.find(field => field.name === "progressNote").value = formData.find(field => field.name === "progressNote").value.replace(/\r?\n/g, "\\n");

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
                                <td class="text-center">촬영담당자<br>특이사항</td>
                                <td class="text-center" id ="modal-progress-note"></td>
                            </tr>
                            <tr>
                                <td class="text-center">촬영<br>예정일</td>
                                <td>
                                    <div>
                                        <input type="text" class="form-control" id="shootReserveDtm" name="shootReserveDtm">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">촬영<br>완료일</td>
                                <td>
                                    <div>
                                        <input type="text" class="form-control" id="shootCompleteDt" name="shootCompleteDt" readonly>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">영상<br>업로드일</td>
                                <td>
                                    <div >
                                        <input type="text" class="form-control" id="uploadCompleteDt" name="uploadCompleteDt" readonly>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" >닫기</button>
                    <button type="button" class="btn btn-primary" onclick=AjaxFunc.updateVideoReq()>저장</button>
                </div>
            </div>
        </div>
    </div>
    

    <div class="reqTopBox">
        <button onclick="PageControlFunc.moveToReqAddPage()" class="common-blue-btn">촬영 신청</button>

        <div>
            <span>상호명 검색 : </span>
            <input type="text" id="searchStoreNm" placeholder="" style="width: 300px; font-size : 14px">
            <button onclick=AjaxFunc.searchStoreNm() class="common-blue-btn" >검색</button>
            <button onclick=PageFunc.resetSearch() class="common-blue-btn" >초기화</button>
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
                    <th style="width: 8%;">연락처</th>
                    <th style="width: 10%;">상호명</th>
                    <th style="width: 15%;">주소</th>
                    <th style="width: 16%;">특이사항</th>
                    <th style="width: 16%;">촬영담당자<br>특이사항</th>
                    <th style="width: 5%;">촬영완료<br>여부</th>
                    <th style="width: 5%;">촬영<br>담당자</th>
                    <th style="width: 8%; border-top-right-radius:10px;">진행상태</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="videoReq" items="${videoReqList}">
                    <tr onclick="PageFunc.updateModal('${videoReq.reqId}', '${videoReq.storeNm}', '${videoReq.creId}', '${videoReq.stringContractDt}', '${videoReq.stringCreDt}', '${videoReq.address}', '${videoReq.phone}', '${videoReq.note}', '${videoReq.status}', '${videoReq.progressNote}', '${videoReq.stringShootReserveDtm}', '${videoReq.stringShootCompleteDt}', '${videoReq.stringUploadCompleteDt}')" data-bs-toggle="modal" data-bs-target="#staticBackdrop">
                        <td class="text-center t-cell">${videoReq.reqId}</td>
                        <td class="text-center t-cell">${videoReq.stringCreDt}</td>
                        <td class="text-center t-cell">${videoReq.creId}</td>
                        <td class="text-center t-cell">
                            ${videoReq.phone.substring(0,3)}-${videoReq.phone.substring(3,7)}-${videoReq.phone.substring(7)}
                        </td>
                        <td class="t-cell">${videoReq.storeNm}</td>
                        <td class="t-cell">${videoReq.address}</td>
                        <td class="t-cell">
                            ${videoReq.note.replace('\\n', '<br>')}
                        </td>
                        <td class="t-cell">
                            ${videoReq.progressNote.replace('\\n', '<br>')}
                        </td>
                        <td class="text-center t-cell"></td>
                        <td class="text-center t-cell"></td>
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