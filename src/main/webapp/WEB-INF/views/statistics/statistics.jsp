<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 통계&정산 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>


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

        <script>
            <%-- Document Ready! --%>
            $(document).ready(function() {
                // URL 파라미터에서 selectedYear, selectedMonth 값을 가져옴
                const urlParams = new URLSearchParams(window.location.search);
                let selectedYear = urlParams.get('selectedYear');
                let selectedMonth = urlParams.get('selectedMonth');

                // selectedYear와 selectedMonth가 없으면 현재 연도와 월로 설정
                if (!selectedYear || !selectedMonth) {
                    const now = new Date();
                    selectedYear = now.getFullYear();  // 현재 연도
                    selectedMonth = String(now.getMonth() + 1).padStart(2, '0');  // 현재 월, 1월부터 시작하므로 +1, 두 자릿수로 포맷
                }

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
            });



            let PageFunc = {
                selectYearMonth : function() {
                    const selectedYear = $('#calendar').val().substring(0,4);
                    const selectedMonth = $('#calendar').val().substring(6,8);
                    
                    window.location.href = '/statistics?selectedYear='+ selectedYear + '&selectedMonth=' + selectedMonth;
                }
            };

            let AjaxFunc = {

            }
        </script>

        <div style="margin-top : 10px; margin-left : 10px;">
            <input id='calendar' /> 업로드 완료 갯수
        </div>
        <div class="statistics-container">
            <table class="table table-bordered" style="margin-top : 10px;">
                <tr>
                    <th style="width : 30%;border-top-left-radius:10px;">이름</td>
                    <th style="width : 40%">업로드 갯수</td>
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
    </body>
</html>
