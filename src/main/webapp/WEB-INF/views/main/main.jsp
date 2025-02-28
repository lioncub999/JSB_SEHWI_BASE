<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 메인 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

        <script>
            $(document).ready(function() {
                MapFunc.drawMap(${reqList}); // 초기 지도 생성 및 핀 그리기

                // 엔터키 감지 및 버튼 클릭 트리거
                document.addEventListener('keydown', function(event) {
                    if (event.key === 'Enter') {
                        // 로그인 버튼 클릭
                        MapFunc.searchAddressToCoordinate();
                    }
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
                                url: '/images/common/blue_marker.png',
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
                                    '</tbody>'+
                                '</table>'+
                                '<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#staticBackdrop" ' +
                                    'onclick="PageFunc.updateModal('+ 
                                    '\''+ videoReq.reqId + '\'' +','+ 
                                    '\''+ videoReq.storeNm + '\'' +','+ 
                                    '\''+ videoReq.creId + '\'' +','+
                                    '\''+ videoReq.stringContractDt + '\'' +','+
                                    '\''+ videoReq.stringCreDt + '\'' +','+
                                    '\''+ videoReq.address + '\'' +','+
                                    '\''+ videoReq.phone.substring(0,3)+'-'+videoReq.phone.substring(3,7)+'-'+videoReq.phone.substring(7) + '\'' +','+ 
                                    '\''+ videoReq.note.replace(/\n/g, '\n') + '\'' +','+ 
                                    '\''+ videoReq.status + '\'' +','+ 
                                    '\''+ videoReq.progressNote + '\'' +')">'+
                                    '매장상세' +
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
                    const address = document.getElementById("addressSearch").value; // 사용자 입력 주소
                    naver.maps.Service.geocode({
                        query: address
                    }, (status, response) => { // 화살표 함수 사용
                        if (status === naver.maps.Service.Status.ERROR) {
                            return alert('Something Wrong!');
                        }

                        if (response.v2.meta.totalCount === 0) {
                            return alert('주소를 찾을 수 없습니다.');
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
                updateModal : function(reqId, storeName, creId, stringContractDt, stringCreDt, address, phone, note, status, progressNote) {
                    document.getElementById('reqId').value = reqId;
                    document.getElementById('exampleModalLabel').textContent = '['+storeName+']';
                    document.getElementById('modal-cre-id').textContent = creId;
                    document.getElementById('modal-contract-dt').textContent = stringContractDt;
                    document.getElementById('modal-cre-dt').textContent = stringCreDt;
                    document.getElementById('modal-address').textContent = address;
                    document.getElementById('modal-phone').textContent = phone;


                    // 특이사항 (전체 수정 가능)
                    const modalNoteCell = document.getElementById('modal-note');
                    modalNoteCell.innerHTML = '';

                    // 특이사항 <textarea> 생성
                    const textArea = document.createElement('textarea');

                    textArea.value = note;// note 값을 디폴트로 설정
                    textArea.style.resize = 'none'; // 크기 조절 불가
                    textArea.style.overflowY = 'auto'; // 세로 스크롤 활성화
                    textArea.rows = 4; // 최대 4줄 표시
                    textArea.style.width = '100%'; // 부모 요소 크기에 맞게 설정
                    textArea.style.boxSizing = 'border-box'; // 패딩 포함 크기 계산
                    textArea.name = "note";

                    // 특이사항 <textarea>를 td에 추가
                    modalNoteCell.appendChild(textArea);

                    // 진행 상태 수정
                    const modalStatusCell = document.getElementById('modal-status');

                    modalStatusCell.innerHTML = '';

                    // <div> 생성
                    const inputBoxDiv = document.createElement('div');
                    inputBoxDiv.className = 'input-box';

                    // <select> 생성
                    const selectElement = document.createElement('select');
                    selectElement.className = 'form-select';
                    selectElement.id = 'status';
                    selectElement.name = 'status';

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
                    const option = document.createElement('option');
                    option.value = optionData.value;
                    option.textContent = optionData.text;
                    if (optionData.value === status) {
                        option.selected = true; // status 값에 따라 기본 선택 설정
                    }
                    selectElement.appendChild(option);
                    });

                    // <select>를 <div> 안에 추가
                    inputBoxDiv.appendChild(selectElement);

                    // <div>를 모달의 상태 셀에 추가
                    modalStatusCell.appendChild(inputBoxDiv);

                    if (${userGrade} === 0) {
                        // 촬영 담당자 작성 특이사항(촬영자만 수정가능)
                        const modalProgressNoteCell = document.getElementById('modal-progress-note');
                        modalProgressNoteCell.innerHTML = '';

                        // 촬영 담당자 특이사항 <textarea> 생성
                        const progressNoteTextArea = document.createElement('textarea');

                        if (progressNote != 'null') {
                            progressNoteTextArea.value = progressNote;// note 값을 디폴트로 설정
                        }
                        progressNoteTextArea.style.resize = 'none'; // 크기 조절 불가
                        progressNoteTextArea.style.overflowY = 'auto'; // 세로 스크롤 활성화
                        progressNoteTextArea.rows = 4; // 최대 4줄 표시
                        progressNoteTextArea.style.width = '100%'; // 부모 요소 크기에 맞게 설정
                        progressNoteTextArea.style.boxSizing = 'border-box'; // 패딩 포함 크기 계산
                        progressNoteTextArea.name = "progressNote";

                        // 촬영 담당자 특이사항 <textarea>를 td에 추가
                        modalProgressNoteCell.appendChild(progressNoteTextArea);
                    } else {
                        document.getElementById('modal-progress-note').textContent = progressNote;
                    }
                }
            };

            let AjaxFunc = {
                // 비디오 신청정보 업데이트
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
        <div style="position:absolute; z-index : 10; background-color : white; margin : 10px; padding : 10px; border-radius : 10px; border : 3px solid black">
            <input type="text" style="height : 100%" id="addressSearch" />
            <button type="button" class="common-blue-btn" onclick=MapFunc.searchAddressToCoordinate() >주소 검색</button>
        </div>
        <div id="map" style="width:100%;height:100%; border-radius: 10px;"></div>
    </body>
</html>
