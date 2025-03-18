<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 통계&정산 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<c:set var="insertSpendUrl" value="/statistics/insertSpend"/>
<c:set var="getSpendHistUrl" value="/statistics/getSpendHist"/>
<c:set var="getGroupedSpendAmtUrl" value="/statistics/getGroupedSpendAmt"/>


<html>
<head>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
    <body>
        <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
        <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
        <script src="https://jsuites.net/v4/jsuites.js"></script>
        <link rel="stylesheet" href="https://jsuites.net/v4/jsuites.css" type="text/css" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Datepicker 스타일시트 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/css/bootstrap-datepicker.min.css" rel="stylesheet">

        <!-- datepicker JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/js/bootstrap-datepicker.min.js"></script>

        <!-- 한국어 로케일 파일 추가 -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/locales/bootstrap-datepicker.kr.min.js"></script>

        <script>
            <%-- Document Ready! --%>
            $(document).ready(function() {
                // 지출일
                $('#spendDt').datepicker({
                    format: 'yyyy-mm-dd', // 날짜 형식
                    autoclose: true, // 날짜 선택 후 자동으로 닫기
                    todayHighlight: true, // 오늘 날짜 하이라이트
                    language: "kr",
                });
                
                // URL 파라미터에서 selectedYear, selectedMonth 값을 가져옴
                const urlParams = new URLSearchParams(window.location.search);
                let selectedYear = urlParams.get('selectedYear');
                let selectedMonth = urlParams.get('selectedMonth');

                // selectedYear와 selectedMonth가 없으면 현재 연도와 월로 설정
                if (!selectedYear || !selectedMonth) {
                    const now = new Date();
                    selectedYear = now.getFullYear();  // 현재 연도
                    selectedMonth = String(now.getMonth() + 1).padStart(2, '0');  // 현재 월, 1월부터 시작하므로 +1, 두 자릿수로 포맷
                };

                // Enable the year and month picker
                jSuites.calendar(document.getElementById('calendar'), {
                    months : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],

                    type: 'year-month-picker',
                    format: 'YYYY년 MM월',
                    resetButton : false,
                    textDone : "",
                    textUpdate : "",
                    value : selectedYear+ '-' + selectedMonth,
                    onclose: function() {
                        PageFunc.selectYearMonth();
                    },

                });

                AjaxFunc.getSpendHist();
                AjaxFunc.getGroupedSpendAmt();
            });



            let PageFunc = {
                selectYearMonth : function() {
                    const selectedYear = $('#calendar').val().substring(0,4);
                    const selectedMonth = $('#calendar').val().substring(6,8);
                    
                    window.location.href = '/statistics?selectedYear='+ selectedYear + '&selectedMonth=' + selectedMonth;
                },

                validateNumberInput : function() {
                    const input = document.getElementById('amt');
                    input.value = input.value.replace(/[^0-9]/g, ''); // 숫자가 아닌 값을 제거
                },

                updateModal : function() {
                    $('#spendDt').val('');
                    $('#whatFor').val('');
                    $('#amt').val('');
                    $('#note').val('');
                },

                checkSubmitValid : function() {
                    var warningTxt = '';

                    <%-- 날짜 --%>
                    if ($("#spendDt").val() == '') {
                        warningTxt += "지출일을 입력해주세요!\n"
                    }
                    <%-- 지출내용 입력 확인 --%>
                    if ($('#whatFor').val() == '') {
                        warningTxt += "지출 내용을 입력해주세요!\n"
                    }
                    <%-- 지출금액 입력 확인 --%>
                    if ($('#amt').val() == '') {
                        warningTxt += "지출 금액을 입력해주세요!\n"
                    }
                    <%-- 워닝 표시 --%>
                    if (warningTxt != '') {
                        Toast('top', 1500, 'warning', warningTxt);
                        LoadingOverlay.hide();
                        return;
                    }

                    AjaxFunc.insertSpend();
                }
            };

            let AjaxFunc = {
                insertSpend : function() {
                    var formData = $('#spend-frm').serializeArray();

                    LoadingOverlay.show();
                    $.ajax({
                        url: "${insertSpendUrl}",
                        type: "post",
                        cache: false,
                        data: formData,
                    }).done(function (response) {
                        if (response == "success") {
                            Toast('top', 1000, 'success', '지출 내역이 추가되었습니다!');

                            $('#staticBackdrop').modal('hide');

                            AjaxFunc.getSpendHist();
                            AjaxFunc.getGroupedSpendAmt();

                            LoadingOverlay.hide();
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: '오류가 발생했습니다. 지속 현상 발생시 관리자에게 문의해주세요.',
                                allowOutsideClick: false, // 팝업 외부 클릭 비활성화
                            });
                            LoadingOverlay.hide();
                        }
                    }).fail((xhr, textStatus, thrownError) => {
                        Toast('top', 1000, 'error', '데이터를 가져오는 중 문제가 발생했습니다.');
                        LoadingOverlay.hide();
                    });
                },

                getSpendHist : function() {
                    const selectedYear = $('#calendar').val().substring(0,4);
                    const selectedMonth = $('#calendar').val().substring(6,8);

                    $.ajax({
                        url: "${getSpendHistUrl}",
                        type: "post",
                        cache: false,
                        data: {'selectedYear' : selectedYear, 'selectedMonth' : selectedMonth},
                    }).done(function (response) {
                        if (response.length > 0) {
                            const tableBody = $('.spendHist');

                            tableBody.empty(); // 기존 데이터를 초기화
                            response.forEach(item => {
                                const formattedAmt = item.amt.toLocaleString(); // 세 자리마다 콤마 추가

                                const note = item.note || '';

                                const row = '<tr>' +
                                        '<td>' + item.stringSpendDt + '</td>' +
                                        '<td>' + item.creNm + ' ' + item.jobGradeNm + '</td>' +
                                        '<td>' + item.whatFor + '</td>' +
                                        '<td>' + formattedAmt + '</td>' +
                                        '<td>' + note + '</td>' +
                                        '<td>' + item.managerCheck + '</td>' +
                                    '</tr>';
                                tableBody.append(row);
                            });
                        }
                    }).fail((xhr, textStatus, thrownError) => { 
                        Toast('top', 1000, 'error', '데이터를 가져오는 중 문제가 발생했습니다.');
                        LoadingOverlay.hide();
                    });
                },

                getGroupedSpendAmt : function() {
                    const selectedYear = $('#calendar').val().substring(0,4);
                    const selectedMonth = $('#calendar').val().substring(6,8);

                    $.ajax({
                        url: "${getGroupedSpendAmtUrl}",
                        type: "post",
                        cache: false,
                        data: {'selectedYear' : selectedYear, 'selectedMonth' : selectedMonth},
                    }).done(function (response) {
                        if (response.length > 0) {
                            const tableBody = $('.totalAmt');

                            tableBody.empty(); // 기존 데이터를 초기화

                            let totalSpend = 0;

                            response.forEach(item => {

                                 const formattedTotalAmt = item.totalAmt.toLocaleString(); // 세 자리마다 콤마 추가

                                 totalSpend += item.totalAmt;

                                const row = '<tr>' +
                                        '<td>' + item.userNm + ' ' + item.jobGradeNm+ '</td>' +
                                        '<td>₩&nbsp;' + formattedTotalAmt +'</td>' +
                                    '</tr>';
                                tableBody.append(row);
                            });

                            const formattedTotalSpend = totalSpend.toLocaleString();

                            const sumRow = '<tr>' +
                                        '<th style="border-bottom-left-radius:10px;">' + "합계" + '</th>' +
                                        '<td>₩&nbsp;' + formattedTotalSpend + '</td>' +
                                    '</tr>';

                            tableBody.append(sumRow);
                                        
                        }
                    }).fail((xhr, textStatus, thrownError) => { 
                        Toast('top', 1000, 'error', '데이터를 가져오는 중 문제가 발생했습니다.');
                        LoadingOverlay.hide();
                    });
                }
                
            }
        </script>

        <!-- 지출 내역 추가 모달 -->
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="1" aria-labelledby="staticBackdropLabel" aria-hidden="false" >
            <div class="modal-dialog modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h6 class="modal-title fs-5" id="exampleModalLabel">[지출 경비 추가]</h6>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form class="spend-frm", id="spend-frm">
                            <table class="table table-bordered" >
                                <tr>
                                    <th class="text-center" style="width : 20%; border-top-left-radius:10px">날짜</th>
                                    <td class="text-center"  style="width : 80%;" id ="modal-spend-dt">
                                        <div>
                                            <input type="text" class="form-control" id="spendDt" name="spendDt" style="font-size:13px" readonly placeholder="지출 날짜를 입력하세요">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-center" style="width : 20%;">지출 내용</th>
                                    <td class="text-center"  style="width : 80%;" id ="modal-spend-what-for">
                                        <input type="text" name="whatFor" id="whatFor" placeholder="지출 내용을 입력하세요" style="width:95%" />
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-center" style="width : 20%;">지출 금액</th>
                                    <td class="text-center"  style="width : 80%;" id ="modal-spend-amount">
                                        <input type="text" id="amt" name="amt" oninput="PageFunc.validateNumberInput()" placeholder="숫자만 입력하세요" style="width : 95%">
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-center" style="width : 20%; border-bottom-left-radius:10px">비고</th>
                                    <td class="text-center"  style="width : 80%;" id ="modal-spend-note">
                                        <input type="text" name="note" id="note" placeholder="비고" style="width:95%" />
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" >닫기</button>
                        <button type="button" class="btn btn-primary" onclick="PageFunc.checkSubmitValid()" >저장</button>
                        <div class="save-btn-box" id="save-btn-box"></div>
                    </div>
                </div>
            </div>
        </div>

        <div style="margin-top : 10px; margin-left : 10px;">
            <input id='calendar' /> 
            <div>☉ 업로드 완료 갯수</div>
        </div>
        <div class="statistics-container">
            <table class="table table-bordered" style="margin-top : 10px;">
                <tr>
                    <th style="width : 30%;border-top-left-radius:10px;">이름</td>
                    <th style="width : 20%">업로드 갯수</td>
                    <th style="width : 30%;border-top-right-radius:10px;">급여</td>
                </tr>

                <!-- 합계를 계산하기 위한 변수 선언 -->
                <c:set var="totalUploadCount" value="0" />
                <c:set var="totalPay" value="0" />

                <c:forEach var="statistics" items="${statisticsList}">
                    <c:set var="totalUploadCount" value="${totalUploadCount + statistics.uploadCompleteCnt}" />
                    <c:set var="totalPay" value="${totalPay + statistics.uploadCompleteCnt*50000}" />

                    <tr>
                        <td class = "t-cell">${statistics.userNm}</td>
                        <td class = "t-cell">
                            ${statistics.uploadCompleteCnt == null ? "0" : statistics.uploadCompleteCnt}개
                        </td>
                        <td class = "t-cell">
                            ₩ <fmt:formatNumber value="${statistics.uploadCompleteCnt * 50000}" pattern="#,###" />
                        </td>
                    </tr>
                </c:forEach>

                <tr>
                    <td>합계</td>
                    <td>${totalUploadCount}개</td>
                    <td>₩ <fmt:formatNumber value="${totalPay}" pattern="#,###" /></td>
                </tr>
            </table>
        </div>

        <div style="margin-top:10px;margin-left:10px;margin-right :10px;">
            ☉ 지출 경비 
            <button onclick=PageFunc.updateModal() class="common-blue-btn main-search-btn" type="button" data-bs-toggle="modal" data-bs-target="#staticBackdrop">
                <div class="button-text">
                    추가
                </div>
            </button>
        </div>

        <div class="statistics-container">
            <table class="table table-bordered" style="margin-top : 10px;">
                <tr>
                    <th style="width : 10%; border-top-left-radius : 10px">
                        이름
                    </th>
                    <th style="width : 10%; border-top-right-radius : 10px">
                        총 지출액
                    </th>
                </tr>
                <tbody class="totalAmt" id="totalAmt"></tbody>
            </table>
        </div>


        <div class="statistics-container expense-details">
            <table class="table table-bordered" style="margin-top : 10px;">
                <tr>
                    <th style="width : 10%; border-top-left-radius : 10px">
                        날짜
                    </th>
                    <th style="width : 10%;">
                        이름
                    </th>
                    <th style="width : 30%;">
                        지출내용
                    </th>
                    <th style="width : 10%;">
                        지출금액
                    </th>
                    <th style="width : 30%;">
                        비고
                    </th>
                    <th style="width : 10%; border-top-right-radius : 10px">
                        관리자확인
                    </th>
                </tr>
                <tbody class="spendHist" id="spendHist"></tbody>
            </table>
        </div>
    </body>
</html>
