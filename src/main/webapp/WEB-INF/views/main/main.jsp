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

        <input type="text" id="address" placeholder="주소 입력" style="width: 300px;">
        <button onclick="searchAddressToCoordinate()">주소 변환 및 저장</button>
        <div id="map" style="width:100%;height:95%;"></div>


        <script>
            var mapOptions = {
                center: new naver.maps.LatLng(35.8, 127.5),
                zoom: 7
            };

            var map = new naver.maps.Map('map', mapOptions);

            map.setCursor('pointer');

            const videoReqList = ${testList};

            videoReqList.forEach(function (videoReq) {
                var marker = new naver.maps.Marker({
                    position: new naver.maps.LatLng(videoReq.latitude, videoReq.longitude),
                    map: map,
                    title : videoReq.storeNm
                });

                var infoWindow = new naver.maps.InfoWindow({
                    content: '<div style="padding:10px;"><h4>[' +videoReq.storeNm + ']</h1></div>'
                });

                naver.maps.Event.addListener(marker, 'click', function () {
                    infoWindow.open(map, marker);
                });
            });
        </script>
    </body>
</html>
