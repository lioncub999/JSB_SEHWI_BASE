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

            var infoWindow = new naver.maps.InfoWindow({
                anchorSkew: true
            });

            map.setCursor('pointer');

            function searchAddressToCoordinate() {
                const address = document.getElementById("address").value; // 사용자 입력 주소
                naver.maps.Service.geocode({
                    query: address
                }, function(status, response) {
                    if (status === naver.maps.Service.Status.ERROR) {
                        return alert('Something Wrong!');
                    }

                    if (response.v2.meta.totalCount === 0) {
                        return alert('totalCount' + response.v2.meta.totalCount);
                    }

                    var htmlAddresses = [],
                    item = response.v2.addresses[0],
                    point = new naver.maps.Point(item.x, item.y);


                    if (item.roadAddress) {
                        htmlAddresses.push('[도로명 주소] ' + item.roadAddress);
                    }

                    if (item.jibunAddress) {
                        htmlAddresses.push('[지번 주소] ' + item.jibunAddress);
                    }

                    if (item.englishAddress) {
                        htmlAddresses.push('[영문명 주소] ' + item.englishAddress);
                    }


                    infoWindow.setContent([
                        '<div style="padding:10px;min-width:200px;line-height:150%;">',
                        '<h4 style="margin-top:5px;">검색 주소 : '+ address +'</h4><br />',
                        htmlAddresses.join('<br />'),
                        '</div>'
                    ].join('\n'));

                

                    map.setCenter(point);
                    map.setZoom(15);

                    infoWindow.open(map, point);
                });
            }
        </script>
    </body>
</html>
