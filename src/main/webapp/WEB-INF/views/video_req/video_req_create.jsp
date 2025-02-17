<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 촬영 신청 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<c:set var="reqMainUrl" value="/videoReq"/>
<c:set var="reqCreateUrl" value="/videoReq/reqCreate"/>

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

    <script src="<c:url value='/js/util/textUtils.js' />"></script>

    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}"></script>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}&submodules=geocoder"></script>
     <!-- Datepicker 스타일시트 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/css/bootstrap-datepicker.min.css" rel="stylesheet">

    <script>
        let isAddressConfirmed = false;

        let ActiveFunc = {
            confirmAddress: function() {
                document.querySelector("button[onclick='searchAddressToCoordinate()']").disabled = true;

                // 주소 확인 버튼 숨김
                document.getElementById("addressSearch").disabled = true;
                document.getElementById("confirmAddressBtn").style.display = "none";

                isAddressConfirmed = true;
                
                Toast('top', 1500, 'success', "주소가 확인되었습니다\n" + document.getElementById("address").value);
            }
        }

        let PageControlFunc = {
            <%-- 촬영 신청 추가 페이지 이동 --%>
            moveToReqListPage: function () {
                window.location.href = '/videoReq';
            }
        }

        let AjaxFunc = {
            <%-- 촬영 신청 --%>
            reqCreate: function (xhr, textStatus, thrownError) {
                LoadingOverlay.show();
                var formData = $('#video-req-frm').serialize()

                var warningTxt = '';
                <%-- 매장명 입력 확인 --%>
                if (document.getElementById("storeNm").value == '') {
                    warningTxt += "매장명을 입력해주세요!\n"
                }
                <%-- 연락처 입력 확인 --%>
                if (document.getElementById('phone').value == '') {
                    warningTxt += "대표님 연락처를 입력해주세요!\n"
                }
                <%-- 연락처 형식 확인 --%>
                if (!IsPhoneValid(document.getElementById('phone').value)) {
                    warningTxt += "휴대폰 번호 형식을 확인해주세요"
                }
                <%-- 계약일 입력 확인 --%>
                if (document.getElementById('datepicker').value == '') {
                    warningTxt += "계약일을 입력해주세요!\n"
                }
                <%-- 주소 확인 --%>
                if (!isAddressConfirmed) {
                    warningTxt += "주소를 검색하고 확인해주세요!\n"
                }

                <%-- 워닝 표시 --%>
                if (warningTxt != '') {
                    Toast('top', 1500, 'warning', warningTxt);
                    LoadingOverlay.hide();
                    return;
                }

                $.ajax({
                    url: "${reqCreateUrl}",
                    type: "post",
                    cache: false,
                    data: formData,
                }).done(function (response) {
                    console.log(response);
                    if (response == "success") {
                        Swal.fire({
                            icon: 'success',
                            title: '촬영 신청이 완료되었습니다!',
                            allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                        }).then((result) => {
                            if (result.isConfirmed) {
                                window.location.href = "${reqMainUrl}";
                            }
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: '오류가 발생했습니다. 지속 현상 발생시 관리자에게 문의해주세요.',
                            allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                        });
                    }
                });
                LoadingOverlay.hide();
            }
        }
    </script>
    
    <button class="common-blue-btn" type="button" onclick="PageControlFunc.moveToReqListPage()">목록으로 이동</button>

    <%-- 신청 폼 --%>
    <div>
        <form class="video-req-frm", id="video-req-frm">
            <input type="hidden" id="longitude" name="longitude"/>
            <input type="hidden" id="latitude" name="latitude"/>
            <input type="hidden" id="address" name="address"/>
            <div class="input-box">
                <input type="text" class="input" placeholder="신청자 (임시))" id="storeNm" name="creId"/>
            </div>
            <div class="input-box">
                <input type="text" class="input" placeholder="매장명" id="storeNm" name="storeNm"/>
            </div>
            <div class="input-box">
                <input type="text" class="input" placeholder="대표님 연락처 ('-' 제외)" id="phone" name="phone"/>
            </div>
            <div class="input-box">
                <input type="text" class="input" placeholder="특이사항" id="note" name="note"/>
            </div>
            <div class="mb-3">
                <label for="datepicker" class="form-label">계약일</label>
                <input type="text" class="form-control" id="datepicker" name="contractDt" readonly>
            </div>
            <input type="text" id="addressSearch" placeholder="주소 입력" style="width: 300px;" />
            <button type="button" id="addressSearchBtn" onclick="searchAddressToCoordinate()">검색</button>
            <button type="button" id="confirmAddressBtn" onclick="ActiveFunc.confirmAddress()" style="display : none;">주소확인!</button>
            <h4>주소</h4>
            <div id="map" style="width: 500px;height: 400px;"></div>
            <button type="button" onclick="AjaxFunc.reqCreate()">촬영 신청!!</button>
        </form>
    </div>


    <!-- jQuery와 부트스트랩-datepicker JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/js/bootstrap-datepicker.min.js"></script>
    <!-- 한국어 로케일 파일 추가 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/locales/bootstrap-datepicker.kr.min.js"></script>

    <script>
        // 데이트피커 초기화
        $(document).ready(function() {
            $('#datepicker').datepicker({
                format: 'yyyy-mm-dd', // 날짜 형식
                autoclose: true, // 날짜 선택 후 자동으로 닫기
                todayHighlight: true, // 오늘 날짜 하이라이트
                language: "kr",
            });
        });
    </script>

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
            const address = document.getElementById("addressSearch").value; // 사용자 입력 주소
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


                infoWindow.setContent([
                    '<div style="padding:10px;min-width:200px;line-height:150%;">',
                    '<div style="margin-top:5px; font-size:14px">검색 주소 : '+ address +'</h4><br />',
                    htmlAddresses.join('<br />'),
                    '</div>'
                ].join('\n'));

                // 위도, 경도 설정
                document.getElementById("address").value = document.getElementById("addressSearch").value;
                const longitude = document.getElementById("longitude");
                const latitude = document.getElementById("latitude");

                // 주소 확인 버튼 활성화
                const confirmButton = document.getElementById("confirmAddressBtn");

                // 값 설정
                longitude.value = item.x;
                latitude.value = item.y;

                confirmButton.style.display = "inline-block";
            

                map.setCenter(point);
                map.setZoom(20);

                infoWindow.open(map, point);
            });
        }
    </script>
</body>
</html>