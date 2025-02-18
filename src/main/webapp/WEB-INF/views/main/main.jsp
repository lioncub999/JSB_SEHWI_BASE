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
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabel">[매장명]</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="modal-phone">휴대폰 번호: </p>
                        <p id="modal-note">특이사항 : </p>
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
                updateModal : function(storeName, phone, note) {
                    document.getElementById('exampleModalLabel').textContent = '['+storeName+']';
                    document.getElementById('modal-phone').textContent = '휴대폰 번호 : '+phone;
                    document.getElementById('modal-note').textContent = '특이사항: '+note;
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
                    content: '<div style="padding:10px;">' +
                                '<h5>[' + videoReq.storeNm + ']</h5>' +
                                '<h6>번호: ' + videoReq.phone + '</h6>' +
                                '<h6>주소: ' + videoReq.address + '</h6>' +
                                '<h7>특이사항: ' + videoReq.note + '</h7>' +
                                '<div><button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#staticBackdrop" ' +
                                    'data-bs-toggle="modal" ' +
                                    'data-bs-target="#exampleModal" ' +
                                    'onclick="PageFunc.updateModal(\'' + videoReq.storeNm + '\', \'' + videoReq.phone + '\', \'' + videoReq.note + '\')">' +
                                    '매장상세' +
                                '</button></div>' +
                            '</div>'
                });

                naver.maps.Event.addListener(marker, 'click', function () {
                    infoWindow.open(map, marker);
                });
            });
        </script>
    </body>
</html>
