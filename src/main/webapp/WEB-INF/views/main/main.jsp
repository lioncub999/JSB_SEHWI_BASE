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

        <script>
                let map;
                const markers = [];

                function initMap() {
                    const center = { lat: 37.5665, lng: 126.9780 }; // 서울 중심 좌표
                    map = new google.maps.Map(document.getElementById("map"), {
                        zoom: 12,
                        center: center,
                    });

                    // 마커 추가
                    const marker = new google.maps.Marker({
                        position: center, // 마커 위치
                        map: map,         // 마커를 표시할 지도
                        title: "서울 중심부", // 마커 위에 표시할 텍스트
                    });

                    // 텍스트 표시를 위한 InfoWindow 생성
                    const infoWindow = new google.maps.InfoWindow({
                        content: "<div style='font-size:14px;'>서울 중심부</div>", // 말풍선에 표시할 텍스트
                    });

                    // 마커 클릭 이벤트 추가
                    marker.addListener("click", () => {
                        infoWindow.open(map, marker); // 말풍선 열기
                    });

                    // 지도 클릭 시 말풍선 닫기
                    map.addListener("click", () => {
                        infoWindow.close(); // 말풍선 닫기
                    });
                }

                async function geocodeAddress() {
                    const address = document.getElementById("address").value; // 사용자 입력 주소
                    const geocoder = new google.maps.Geocoder();

                    geocoder.geocode({ address: address }, async (results, status) => {
                        if (status === "OK") {
                            const location = results[0].geometry.location; // 변환된 좌표값
                            const lat = location.lat();
                            const lng = location.lng();

                            console.log(address);
                            console.log("gd" + address + "assda" + lat);

                            // 지도에 마커 표시
                            new google.maps.Marker({
                                position: location,
                                map: map,
                                title: address,
                            });

                            // 지도 중심 이동
                            map.setCenter(location);

                            // DB에 저장 요청
                        } else {
                            alert("Geocoding 실패: " + status);
                        }
                    });
                }


                // Google Maps 스크립트를 동적으로 로드
                function loadGoogleMapsAPI() {
                    const script = document.createElement('script');
                    script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyARyAg9r0V6DQn_flMx9UyKZRQjf4Ha5P0&callback=initMap";
                    script.async = true;
                    script.defer = true;
                    document.head.appendChild(script);
                }

                // DOM이 준비되면 Google Maps API 로드
                document.addEventListener('DOMContentLoaded', loadGoogleMapsAPI);
            </script>
        
        <h1>Google Maps with Database Markers</h1>
        <div id="map" style="width: 100%; height: 500px;"></div>
        <input type="text" id="address" placeholder="주소 입력" style="width: 300px;">
        <button onclick="geocodeAddress()">주소 변환 및 저장</button>
    </body>
</html>
