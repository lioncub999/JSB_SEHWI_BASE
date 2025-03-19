<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 모두솔루션 계약 지도 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>


<c:set var="getVideoReqUrl" value="/video/getRecentVideoReqList"/>
<c:set var="videoReqUpdateUrl" value="/video/videoReqUpdate"/>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
    <body>
        <%-- 네이버 지도 --%>
        <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}"></script>
        <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverMapsClientId}&submodules=geocoder"></script>

        <%-- bootstrap 모달 --%>
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

        <%-- 지도 함수 --%>
        <script src="<c:url value='/js/util/mapUtils.js' />"></script>

        <script>
            <%-- Document Ready! --%>
            $(document).ready(function() {
                // 초기 지도 생성 및 핀 그리기
                MapFunc.drawContMap(${contList}); 

                // 엔터키 감지 및 버튼 클릭 트리거
                const searchInput = $('#addressSearch');

                searchInput.on('keypress', function (event) {
                    // 엔터키를 감지
                    if (event.key === 'Enter') {
                        MapFunc.searchAddressToCoordinate();
                    }
                });

                // 촬영 예정일
                $('#shootReserveDtm').datetimepicker({
                    format: 'Y-m-d H:i',       // 날짜와 시간 형식
                    step : 30,
                });
                $.datetimepicker.setLocale('kr');

                // 최종적으로 input 값 초기화
                $('#shootReserveDtm').on('input', function () {
                    $(this).val(''); // 값이 입력되더라도 초기화
                });

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

        </script>

        <!-- 지도 -->
        <div class="map-search-container">
            <div class="title">☉ 모두솔루션 계약 매장 지도</div>
            <input type="text" class="map-search-field" id="addressSearch" />
            <button type="button" class="common-blue-btn map-search-btn" onclick=MapFunc.searchAddressToCoordinate() >
                <span class="map-search-btn-text">주소 검색</span>
            </button>
        </div>
        <div class="map-pin-explain-box">
            <div class="pin-box">
                <img src="/images/common/blue_marker.png" alt="">
                <div class="pin-exp-title">&nbsp;: 계약중</div>
            </div>
            <div class="pin-box">
                <img src="/images/common/green_marker.png" alt="">
                <div class="pin-exp-title">&nbsp;: 만료임박</div>
            </div>
            <div class="pin-box">
                <img src="/images/common/red_marker.png" alt="">
                <div class="pin-exp-title">&nbsp;: 해지/만료</div>
            </div>
        </div>
        <div id="map" class="map"></div>
    </body>
</html>
