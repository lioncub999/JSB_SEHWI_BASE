<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<c:set var="passResetUrl" value="/resetPass"/>
<c:set var="logoutUrl" value="/auth/logout"/>
<html>
<head>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
<body>
<script>
    let AjaxFunc = {
        resetPassword: function () {
            $.ajax({
                url: "${passResetUrl}",
                type: "post",
                cache: false,
                data: {"userId": "${userId}", "passReset": "${passReset}"},
            }).done(function (response) {
                if (response) {
                    $.ajax({
                        url: "${logoutUrl}",
                        type: "post",
                        cache: false,
                    }).done(function (response) {
                        if (response) {
                            Toast('top', 1000, 'success', '비밀번호가 초기화되었습니다.<br>다시 로그인해주세요. "1111"');

                            setTimeout(function () {
                                window.location.href = "/login"
                            }, 1000)
                        } else {
                            Toast('top', 1000, 'success', '레전드 에러 발생 관리자 문의');
                        }
                    })
                } else {
                    alert('에러 발생')
                }
            })
        }
    }
</script>
<div class="active-calories">
    <p>${userNm} 의 닭가슴살 처묵 STORY~</p>
    <div>
        <canvas id="myChart" height="200px"></canvas>
    </div>
    <p>${userNm} 의 닭가슴살 역사~</p>
    <div class="table-container" style="width: 100%; height: 200px; overflow : auto; border-radius: 15px">
        <table class="table table-dark" style="margin : 0px">
            <thead>
            <tr>
                <th scope="col" style="border-radius: 15px 0 0 0; position: sticky; top: 0; z-index: 1; background: darkcyan">#</th>
                <th scope="col" style="position: sticky; top: 0; z-index: 1;background: darkcyan">맛</th>
                <th scope="col" style="border-radius: 0 15px 0 0; position: sticky; top: 0; z-index: 1;background: darkcyan">시간</th>
            </tr>
            </thead>
            <tbody>

            <c:forEach var="item" items="${myHis}" varStatus="i">
                <tr>
                    <th scope="row">${i.count}</th>
                    <td>
                        ${item.tasteNm}
                    </td>
                    <td>
                        ${item.eatDtm}
                    </td>
                </tr>
            </c:forEach>
            <tr style="border : none;">
                <td style="border-radius: 0 0 0 15px"></td>
                <td></td>
                <td style="border-radius: 0 0 15px 0"></td>
            </tr>
            </tbody>
        </table>
    </div>
    <button onclick="AjaxFunc.resetPassword()"
            type="button" class="btn btn-primary"
            style="background: #6B92A4; color: white; margin-top : 20px">비밀번호 초기화~ "1111"
    </button>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('myChart');
    let chickenTastList = [];
    let myChickenEat = [];
    <c:forEach items="${mychicken}" var="list">
    chickenTastList.push(`${list.tasteNm}`)
    myChickenEat.push(${list.eatAmt})
    </c:forEach>

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: chickenTastList,
            datasets: [{
                label: '내가 먹은 닭가슴살~',
                data: myChickenEat,
                backgroundColor: [
                    'ivory',
                    'darkred',
                    'yellow',
                    'orangered',
                    'black',
                ],
                borderColor: [
                    'ivory',
                    'darkred',
                    'yellow',
                    'orangered',
                    'black',
                ],
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>
</body>
</html>
