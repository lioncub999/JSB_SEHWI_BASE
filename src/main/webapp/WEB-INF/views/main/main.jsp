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

        <!-- Modal -->
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="1" aria-labelledby="staticBackdropLabel" aria-hidden="false" >
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabel">Modal title</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="modal-store-name">Store Name: </p>
                        <p id="modal-phone">Phone: </p>
                        <p id="modal-note">Note: </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Save changes</button>
                    </div>
                </div>
            </div>
        </div>


        <div id="map" style="width:100%;height:100%;"></div>

        <script>
            let PageControlFunc ={
                <%-- 회원가입 화면으로 이동 --%>
                moveToReqDetailPage : function(id) {
                    window.location.href = '/videoReq/detail?id='+id;
                },
            }
        </script>


        <script>
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


                
            var infoWindow = new naver.maps.InfoWindow({
                content: '<div style="padding:10px;">' +
                            '<h5>[' + videoReq.storeNm + ']</h5>' +
                            '<h6>번호: ' + videoReq.phone + '</h6>' +
                            '<h7>특이사항: ' + videoReq.note + '</h7>' +
                            '<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#staticBackdrop" ' +
                                'data-bs-toggle="modal" ' +
                                'data-bs-target="#exampleModal" ' +
                                'onclick="updateModal(\'' + videoReq.storeNm + '\', \'' + videoReq.phone + '\', \'' + videoReq.note + '\')">' +
                                'Launch demo modal' +
                            '</button>' +
                        '</div>'
            });

            naver.maps.Event.addListener(marker, 'click', function () {
                    infoWindow.open(map, marker);
                });
            });

            function updateModal(storeName, phone, note) {
                document.getElementById('modal-store-name').textContent = 'Store Name: '+storeName;
                document.getElementById('modal-phone').textContent = 'Phone: '+phone;
                document.getElementById('modal-note').textContent = 'Note: '+note;
            }
        </script>

    </body>
</html>
