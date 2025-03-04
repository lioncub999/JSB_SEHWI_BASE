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
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
    <body>
        <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
        <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
        <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}"></script>
        <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}&submodules=geocoder"></script>
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
            });

            // 지도 함수
            let MapFunc = {
                map : null,
                markers : [],
                openInfoWindow: null, // 현재 열린 InfoWindow를 저장

                // 지도 초기화
                initMap: function() {
                    var mapOptions = {
                        center: new naver.maps.LatLng(35.8, 127.5),
                        zoom: 7
                    };

                    this.map = new naver.maps.Map('map', mapOptions);
                    this.map.setCursor('pointer');

                    naver.maps.Event.addListener(this.map, 'click', function () {
                        if (MapFunc.openInfoWindow) {
                            MapFunc.openInfoWindow.close();
                            MapFunc.openInfoWindow = null; // 열린 InfoWindow 초기화
                        }
                    });
                },

                // 지도 핀 업데이트 (내용 수정시 핀 동적으로 업데이트용)
                updatePins: function(reqList) {
                    // 기존 핀 제거
                    this.markers.forEach(marker => marker.setMap(null));
                    this.markers = [];

                    // 새로운 핀 추가
                    reqList.forEach(videoReq => {
                        var marker = new naver.maps.Marker({
                            position: new naver.maps.LatLng(videoReq.latitude, videoReq.longitude),
                            map: this.map,
                            title: videoReq.storeNm,
                            animation: naver.maps.Animation.DROP,
                            icon: {
                                url: videoReq.isUrgentReq == "N" ? '/images/common/blue_marker.png' : '/images/common/red_marker.png',
                                size: new naver.maps.Size(15, 23),
                                origin: new naver.maps.Point(0, 0),
                                anchor: new naver.maps.Point(5, 23)
                            }
                        });

                        this.markers.push(marker);

                        // 핀 클릭 시 나오는 설명
                        var infoWindow = new naver.maps.InfoWindow({
                            content: 
                            '<div style="padding:10px;">' +
                                '<h6>상호명 : [' + videoReq.storeNm + ']</h6>' +
                                '<table class="table table-striped table-bordered" >' +
                                    '<tbody>'+
                                        '<tr>'+
                                            '<td class="text-center">계약일</td>'+
                                            '<td class="text-center">'+videoReq.stringContractDt+'</td>'+
                                        '</tr>'+
                                        '<tr>'+
                                            '<td class="text-center">휴대폰번호</td>'+
                                            '<td class="text-center">'+videoReq.phone.substring(0,3)+'-'+videoReq.phone.substring(3,7)+'-'+videoReq.phone.substring(7)+'</td>'+
                                        '</tr>'+
                                        '<tr>'+
                                            '<td class="text-center">주소</td>'+
                                            '<td class="text-center">'+videoReq.address+'</td>'+
                                        '</tr>'+
                                        '<tr>'+
                                            '<td class="text-center">특이사항</td>'+
                                            '<td class="text-center"><pre><span>'+videoReq.note.replace(/\\n/g, '\n')+'<span></pre></td>'+
                                        '</tr>'+
                                        '<tr>'+
                                            '<td class="text-center">촬영담당자<br>특이사항</td>'+
                                            '<td class="text-center"><pre><span>'+ videoReq.progressNote.replace(/\\n/g, '\n') +'<span></pre></td>'+
                                        '</tr>'+
                                    '</tbody>'+
                                '</table>'+
                                '<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#staticBackdrop" ' +
                                    'onclick="PageFunc.updateModal('+ 
                                    '\''+ videoReq.isUrgentReq + '\'' +','+ 
                                    '\''+ videoReq.reqId + '\'' +','+ 
                                    '\''+ videoReq.storeNm + '\'' +','+ 
                                    '\''+ videoReq.creId + '\'' +','+
                                    '\''+ videoReq.stringContractDt + '\'' +','+
                                    '\''+ videoReq.stringCreDt + '\'' +','+
                                    '\''+ videoReq.address + '\'' +','+
                                    '\''+ videoReq.phone.substring(0,3)+'-'+videoReq.phone.substring(3,7)+'-'+videoReq.phone.substring(7) + '\'' +','+ 
                                    '\''+ videoReq.managerNm + '\'' +','+ 
                                    '\''+ videoReq.managerJgNm + '\'' +','+ 
                                    '\''+ videoReq.note.replace(/\n/g, '\n') + '\'' +','+ 
                                    '\''+ videoReq.status + '\'' +','+ 
                                    '\''+ videoReq.progressNote + '\'' + ',' +
                                    '\''+ videoReq.stringShootReserveDtm + '\'' + ',' +
                                    '\''+ videoReq.stringShootCompleteDt + '\'' + ',' +
                                    '\''+ videoReq.stringUploadCompleteDt + '\'' + ',' +
                                    ')">'+'매장상세' +
                                '</button>'+
                            '</div>'
                        });

                        naver.maps.Event.addListener(marker, 'click', function () {
                            infoWindow.open(MapFunc.map, marker);
                            MapFunc.openInfoWindow = infoWindow; // 새 InfoWindow 저장
                        });
                    });
                },

                // 지도 및 핀 그리기
                drawMap: function(reqList) {
                    if (!this.map) {
                        this.initMap(); // 처음 한 번만 지도를 생성
                    }
                    this.updatePins(reqList); // 핀만 업데이트
                },

                // 주소 검색하고 해당 주소로 이동
                searchAddressToCoordinate: function() {
                    const address = $("#addressSearch").val(); // 사용자 입력 주소
                    naver.maps.Service.geocode({
                        query: address
                    }, (status, response) => { // 화살표 함수 사용
                        if (status === naver.maps.Service.Status.ERROR) {
                            Toast('top', 1000, 'error', '네이버 지도 오류 발생!');
                            return;
                        }

                        if (response.v2.meta.totalCount === 0) {
                            Toast('top', 1000, 'warning', '검색된 주소가 없습니다!');
                            return;
                        }

                        var item = response.v2.addresses[0],
                            point = new naver.maps.Point(item.x, item.y);

                        this.map.setCenter(point); // 화살표 함수로 this 유지
                        this.map.setZoom(15);
                    });
                }

            };

            let PageFunc = {
                // 모달창 정보 업데이트
                updateModal : function(isUrgentReq, reqId, storeName, creId, stringContractDt, stringCreDt, address, phone, managerNm, managerJgNm, note, status, progressNote, stringShootReserveDtm, stringShootCompleteDt, stringUploadCompleteDt) {
                    $('#modal-is-urgent-req').text(isUrgentReq == "Y" ? "긴급건" : "");
                    $('#reqId').val(reqId);
                    $('#exampleModalLabel').text('[' + storeName + ']');
                    $('#modal-cre-id').text(creId);
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
            };

            let AjaxFunc = {
                // 비디오 신청정보 업데이트
                updateVideoReq: function() {
                    var formData = $('#video-req-frm').serializeArray();

                    formData.find(field => field.name === "note").value = formData.find(field => field.name === "note").value.replace(/\r?\n/g, "\\n");

                    if (${userGrade} == 0) {
                        formData.find(field => field.name === "progressNote").value = formData.find(field => field.name === "progressNote").value.replace(/\r?\n/g, "\\n");
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
                        console.log('AJAX error:', textStatus, thrownError);
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
                        console.log('AJAX error while loading updated data:', textStatus, thrownError);
                        Toast('top', 1000, 'error', '데이터를 가져오는 중 문제가 발생했습니다.');
                    });
                }
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
                                    <td class="text-center" id ="modal-progress-note"></td>
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
                        <button type="button" class="btn btn-primary" onclick=AjaxFunc.updateVideoReq()>저장</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- 지도 -->
        <div class="map-search-container">
            <input type="text" class="map-search-field" id="addressSearch" />
            <button type="button" class="common-blue-btn" onclick=MapFunc.searchAddressToCoordinate() >주소 검색</button>
        </div>
        <div id="map" class="map"></div>
    </body>
</html>
