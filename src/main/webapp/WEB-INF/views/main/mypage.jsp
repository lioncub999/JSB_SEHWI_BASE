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
        resetPassword : function() {
            $.ajax({
                url: "${passResetUrl}",
                type: "post",
                cache: false,
                data: {"userId":"${userId}", "passReset":"${passReset}"},
            }).done(function (response) {
                if (response) {
                    $.ajax({
                        url: "${logoutUrl}",
                        type: "post",
                        cache: false,
                    }).done(function (response) {
                        if (response) {
                            Toast('top', 1000, 'success', '비밀번호가 초기화되었습니다.<br>다시 로그인해주세요. "1111"');

                            setTimeout(function() {
                                window.location.href = "/login"
                            }, 1000)
                        } else {
                            alert('에러 발생')
                        }
                    })
                } else {
                    alert('에러 발생')
                }
            })
        }
    }
</script>
<div class="active-calories" style="height: 500px; overflow-y: scroll; overflow-x:hidden; overscroll-behavior: none">
    <p>${userNm} 의 닭가슴살 처묵 STORY~</p>
    <div>
        <canvas id="myChart" height="200px"></canvas>
    </div>
    <button onclick="AjaxFunc.resetPassword()">비밀번호 초기화~ "1111"</button>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('myChart');

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['갈릭', '핫양념', '허니소이', '떡볶이', '핵불닭'],
            datasets: [{
                label: '내가 먹은 닭가슴살~',
                data: [${mychicken[0].count}, ${mychicken[1].count}, ${mychicken[2].count} ,${mychicken[3].count}, ${mychicken[4].count}],
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
