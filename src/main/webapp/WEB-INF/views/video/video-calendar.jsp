<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 캘린더 페이지
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



        <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.15/index.global.min.js'></script>
        <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/daygrid@6.1.15/index.global.min.js'></script>

        <script>
            <%-- Document Ready! --%>
            $(document).ready(function() {
                const calendarData = ${calendarData};   

                var events = [];

                calendarData.map((data)=> {
                    event = {
                        "allDay" : false,
                        "color" : data.color,
                        "start" : data.stringShootReserveDtm,
                        "title" : data.storeNm,
                    }
                    events.push(event);
                })

                
                var calendarEl = document.getElementById('calendar');
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    locale : 'kr',
                    initialView: 'dayGridMonth',
                    events : events,
                    eventClick : function(info) {
                    },
                });
                calendar.render();
            });


            let PageFunc = {

            };

            let AjaxFunc = {
            }
        </script>
        <div class="who-color-container">
            <div class="mobile-text">☉모바일은 가로로봐주세요</div>
            <div class="who-color">
                <div style="width : 10px; height : 10px; background-color : red; border-radius : 5px"></div>
                <div>&nbsp;채근</div>
                <div style="width : 10px"></div>

                <div style="width : 10px; height : 10px; background-color : blue; border-radius : 5px"></div>
                <div>&nbsp;성우</div>
                <div style="width : 10px"></div>

                <div style="width : 10px; height : 10px; background-color : yellow; border-radius : 5px"></div>
                <div>&nbsp;세휘</div>
                <div style="width : 10px"></div>

                <div style="width : 10px; height : 10px; background-color : black; border-radius : 5px"></div>
                <div>&nbsp;미정</div>
            </div>
        </div>
        <div class="calendar" id='calendar'></div>
    </body>
</html>
