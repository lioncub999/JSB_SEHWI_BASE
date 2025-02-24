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


<html>
<head>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/main.css'/>">
</head>
    <body>
        <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
        <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
        <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}"></script>
        <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}&submodules=geocoder"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- 매장 상세 모달 -->
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="1" aria-labelledby="staticBackdropLabel" aria-hidden="false" >
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabel">[상호명]</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
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
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                        <button type="button" class="btn btn-primary">저장</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- 지도 -->
        <div id="map" style="width:100%;height:100%; border-radius: 10px;"></div>

        <script>
            let PageControlFunc ={
                <%-- 회원가입 화면으로 이동 --%>
                moveToReqDetailPage : function(id) {
                    window.location.href = '/videoReq/detail?id='+id;
                },
            };

            let PageFunc = {
                <%-- 모달창 정보 업데이트 --%>
                updateModal : function(storeName, creId, stringContractDt, stringCreDt, address, phone, note, status) {
                    document.getElementById('exampleModalLabel').textContent = '['+storeName+']';
                    document.getElementById('modal-cre-id').textContent = creId;
                    document.getElementById('modal-contract-dt').textContent = stringContractDt;
                    document.getElementById('modal-cre-dt').textContent = stringCreDt;
                    document.getElementById('modal-address').textContent = address;
                    document.getElementById('modal-phone').textContent = phone;
                    document.getElementById('modal-note').textContent = note;

                    convertedStatus = '';

                    if (${userGrade} === 0) {
                            const modalStatusCell = document.getElementById('modal-status');

                            // <div> 생성
                            const inputBoxDiv = document.createElement('div');
                            inputBoxDiv.className = 'input-box';

                            // <select> 생성
                            const selectElement = document.createElement('select');
                            selectElement.className = 'form-select';
                            selectElement.style.width = '300px';
                            selectElement.id = 'jobGrade';
                            selectElement.name = 'jobGrade';

                            // <option> 요소 추가
                            const options = [
                                { value: 'COORDINATION', text: '일정조율중' },
                                { value: 'TEST', text: '테스트' },
                            ];

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
                    } else {
                        if (status == 'COORDINATION') {
                            convertedStatus = "일정조율중"
                            document.getElementById('modal-status').textContent = convertedStatus;
                        }
                    }
                }
            }
        </script>


        <script>
            <!-- 지도 그리기 -->
            var mapOptions = {
                center: new naver.maps.LatLng(35.8, 127.5),
                zoom: 7
            };

            var map = new naver.maps.Map('map', mapOptions);

            map.setCursor('pointer');

            const videoReqList = ${reqList};

            videoReqList.forEach(function (videoReq) {
                var marker = new naver.maps.Marker({
                    position: new naver.maps.LatLng(videoReq.latitude, videoReq.longitude),
                    map: map,
                    title : videoReq.storeNm
                });


                
                <!-- 핀 클릭 나오는 설명 -->
                var infoWindow = new naver.maps.InfoWindow({
                    content: 
                    '<div style="padding:10px;">' +
                        '<h5>상호명 : [' + videoReq.storeNm + ']</h5>' +
                        '<table class="table table-striped table-bordered" >' +
                            '<tbody>'+
                                // 계약일
                                '<tr>'+
                                    '<td class="text-center">계약일</td>'+
                                    '<td class="text-center">'+videoReq.stringContractDt+'</td>'+
                                '</tr>'+
                                // 휴대폰 번호
                                '<tr>'+
                                    '<td class="text-center">휴대폰번호</td>'+
                                    '<td class="text-center">'+videoReq.phone.substring(0,3)+'-'+videoReq.phone.substring(3,7)+'-'+videoReq.phone.substring(7)+'</td>'+
                                '</tr>'+
                                // 주소
                                '<tr>'+
                                    '<td class="text-center">주소</td>'+
                                    '<td class="text-center">'+videoReq.address+'</td>'+
                                '</tr>'+
                                // 특이사항
                                '<tr>'+
                                    '<td class="text-center">특이사항</td>'+
                                    '<td class="text-center">'+videoReq.note+'</td>'+
                                '</tr>'+
                            '</tbody>'+
                        '</table>'+
                        '<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#staticBackdrop" ' +
                            'data-bs-toggle="modal" ' +
                            'data-bs-target="#exampleModal" ' +
                            'onclick="PageFunc.updateModal(\'' + videoReq.storeNm + '\', \'' + videoReq.creId + '\', \'' + videoReq.stringContractDt + '\', \'' + videoReq.stringCreDt + '\', \'' + videoReq.address + '\', \'' +videoReq.phone.substring(0,3)+'-'+videoReq.phone.substring(3,7)+'-'+videoReq.phone.substring(7)+ '\', \'' + videoReq.note + '\', \'' + videoReq.status + '\')">' +
                            '매장상세' +
                        '</button>'+
                    '</div>'
                });

                naver.maps.Event.addListener(marker, 'click', function () {
                    infoWindow.open(map, marker);
                });
            });
        </script>
    </body>
</html>
