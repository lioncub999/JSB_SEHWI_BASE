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

<c:set var="videoReqListUrl" value="/video/videoReqList"/>
<c:set var="videoReqCreateUrl" value="/video/videoReqCreate"/>

<html>
    <head>
        <meta name="viewport"
            content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
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

        <!-- jQuery와 부트스트랩-datepicker JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/js/bootstrap-datepicker.min.js"></script>
        <!-- 한국어 로케일 파일 추가 -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/locales/bootstrap-datepicker.kr.min.js"></script>

        <%-- 지도 함수 --%>
        <script src="<c:url value='/js/util/mapUtils.js' />"></script>

        <script>
            <%-- Document Ready! --%>
            $(document).ready(function() {
                MapFunc.drawMap(${reqList}); 

                $('#datepicker').datepicker({
                    format: 'yyyy-mm-dd', // 날짜 형식
                    autoclose: true, // 날짜 선택 후 자동으로 닫기
                    todayHighlight: true, // 오늘 날짜 하이라이트
                    language: "kr",
                });
            })

            let isAddressConfirmed = false;

            let ActiveFunc = {
                confirmAddress: function() {
                    $("#addressSearchBtn").prop("disabled", true);

                    // 주소 확인 버튼 숨김
                    $("#addressSearch").prop("disabled", true);

                    $("#confirmAddressBtn").css("display", "none");

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
                    var formData = $('#video-req-frm').serializeArray();

                    formData.find(field => field.name === "note").value = formData.find(field => field.name === "note").value.replace(/\r?\n/g, "\\n");

                    var warningTxt = '';
                    <%-- 매장명 입력 확인 --%>
                    if ($("#storeNm").val() == '') {
                        warningTxt += "매장명을 입력해주세요!\n"
                    }
                    <%-- 연락처 입력 확인 --%>
                    if ($('#phone').val() == '') {
                        warningTxt += "대표님 연락처를 입력해주세요!\n"
                    }
                    <%-- 연락처 형식 확인 --%>
                    if (!IsPhoneValid($('#phone').val())) {
                        warningTxt += "휴대폰 번호 형식을 확인해주세요\n"
                    }
                    <%-- 계약일 입력 확인 --%>
                    if ($('#datepicker').val() == '') {
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
                        url: "${videoReqCreateUrl}",
                        type: "post",
                        cache: false,
                        data: formData,
                    }).done(function (response) {
                        if (response == "success") {
                            Swal.fire({
                                icon: 'success',
                                title: '촬영 신청이 완료되었습니다!',
                                allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.location.href = "${videoReqListUrl}";
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
        
        <div style="display : flex; justify-content: flex-end">
            <button class="common-blue-btn" type="button" onclick="AjaxFunc.reqCreate()" style="margin-top:10px;margin-right:10px;">촬영 신청</button>
        </div>

        <%-- 신청 폼 --%>
        <form class="video-req-frm", id="video-req-frm">
            <input type="hidden" id="longitude" name="longitude"/>
            <input type="hidden" id="latitude" name="latitude"/>
            <input type="hidden" id="address" name="address"/>

            <div class="table-container">
                <table class="table table-bordered">
                    <tr>
                        <th style="width:20%">긴급건<br>여부</th>
                        <td class="checkbox-td">
                            <input type="checkbox" id="checkbox" class="checkbox" value="Y" name="isUrgentReq">
                            <div>&nbsp;긴급건</div>
                        </td>
                    </tr>
                    <tr>
                        <th>신청자</th>
                        <td>
                            <div>${userNm} ${userJobGradeNm}</div>
                        </td>
                    </tr>
                    <tr>
                        <th>매장명</th>
                        <td>
                            <input type="text" class="main-search-field create-frm" placeholder="매장명" id="storeNm" name="storeNm"/>
                        </td>
                    </tr>
                    <tr>
                        <th>대표님<br>연락처 <br>('-' 제외)</th>
                        <td>
                            <input type="text" class="main-search-field create-frm" placeholder="대표님 연락처 ('-' 제외)" id="phone" name="phone"/>
                        </td>
                    </tr>
                    <tr>
                        <th>특이사항</th>
                        <td>
                            <textarea class="main-search-field create-frm" placeholder="특이사항" name="note" id="note" rows=4></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>계약일</th>
                        <td>
                            <input class="main-search-field create-frm" type="text" class="form-control" id="datepicker" name="contractDt" readonly>
                        </td>
                    </tr>
                    <tr class="create-address-search-tr">
                        <th>매장주소</th>
                        <td>
                            <div class="create-address-search-cont">
                                <input class="main-search-field address" type="text" id="addressSearch" placeholder="주소 입력" />
                                <div class="button-container">
                                    <button class="common-blue-btn address-btn" type="button" id="addressSearchBtn" onclick="MapFunc.searchAddressAndShowPin()">
                                        <div class="button-text">검색</div>
                                    </button>
                                </div>
                                <div class="button-container">
                                    <button class="common-blue-btn address-btn" type="button" id="confirmAddressBtn" onclick="ActiveFunc.confirmAddress()" style="display : none;">
                                        <div class="button-text">확인</div>
                                    </button>
                                </div>
                            </div>
                            <div id="map" style="width: 100%;height: 350px;border-radius:10px"></div>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </body>
</html>