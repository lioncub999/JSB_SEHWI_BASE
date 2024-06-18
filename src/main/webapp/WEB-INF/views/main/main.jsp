<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<c:set var="chickenUrl" value="/chicken"/>
<html>
<head>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
<body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
<script>
    let AjaxFunc = {
        confirm: function (consumer, userNm, chickCd, chickNm) {
            if (userNm == '${userNm}') {
                Swal.fire({
                    title: "ㄹㅇ 먹음?",
                    text: `님이 먹은건 ` + chickNm,
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "예쓰~!",
                    cancelButtonText: "아님~!"
                }).then((result) => {
                    if (result.isConfirmed) {
                        AjaxFunc.plusOneChicken(consumer, userNm, chickCd);
                        Swal.fire({
                            title: "알림!",
                            text: "추가되었음.",
                            icon: "success"
                        });
                    }
                });
            } else {
                alert("님 아이디에만 플러스 하셈;")
            }
        },
        plusOneChicken: function(consumer, userNm, chickCd) {
            $.ajax({
                url: "/plusOneChicken",
                type: "post",
                cache: false,
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({"consumer": consumer, "chickCd": chickCd}),
                success: function (response) {
                    setTimeout(function () {
                        window.location.href = "/main"
                    }, 1000)
                }
            })
        }
    }
</script>
<div class="active-calories" style="height: 500px; overflow-y: scroll; overflow-x:hidden; overscroll-behavior: none">
    <h1 style="align-self: flex-start">닭가슴살 근황 (총 75개중)</h1>
    <div>
        <canvas id="myChart"></canvas>
    </div>
    <div>
        <canvas id="leftChicken" style="height: 200px; margin-top : 20px;"></canvas>
    </div>

    <div class="active-calories-container" style="flex-direction: column; text-align: center">
        <br>
        <c:forEach items="${chickenList}" var="chicken">
            <div class="calories-content" style="width: 220px">
                <span>${chicken.userNm} : </span> <span> ${chicken.eat}먹</span>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${chicken.consumer}, '${chicken.userNm}', 'HT01', '갈릭')"
                            type="button" class="btn btn-primary" style="margin : auto; background: ivory; width: 70px">
                        갈릭
                    </button>
                    <button onclick="AjaxFunc.confirm(${chicken.consumer}, '${chicken.userNm}', 'HT02', '핫양념')"
                            type="button" class="btn btn-primary"
                            style="margin : auto; background: darkred; color: white; width: 70px">핫양념
                    </button>
                    <button onclick="AjaxFunc.confirm(${chicken.consumer}, '${chicken.userNm}', 'HT03', '허니소이')"
                            type="button" class="btn btn-primary"
                            style="margin : auto; background: yellow; width: 70px">허니소이
                    </button>

                </div>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${chicken.consumer}, '${chicken.userNm}', 'HT04', '떡볶이')"
                            type="button" class="btn btn-primary"
                            style="margin : auto; background: orangered; color: white; width: 70px">떡볶이
                    </button>
                    <button onclick="AjaxFunc.confirm(${chicken.consumer}, '${chicken.userNm}', 'HT05', '핵불닭')"
                            type="button" class="btn btn-primary"
                            style="margin : auto; background: black; color: red; width: 70px">핵붉닭
                    </button>
                </div>
                <br>
            </div>
        </c:forEach>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    const ctx = document.getElementById('myChart');

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: [
                '${chickenList[0].userNm}',
                '${chickenList[1].userNm}',
                '${chickenList[2].userNm}',
                '남은 녀석들',
            ],
            datasets: [{
                label: 'EAT',
                data: [
                    '${chickenList[0].eat}',
                    '${chickenList[1].eat}',
                    '${chickenList[2].eat}',
                    75-'${chickenList[0].eat}'-'${chickenList[1].eat}'-'${chickenList[2].eat}'
                ],
                borderWidth: 1,
                hoverOffset: 4,
                backgroundColor: [
                    'rgb(255,0,55)',
                    'rgb(0,152,255)',
                    'rgb(255,179,0)',
                    'grey',
                ]
            }],
        },
        options: {
            scales: {}
        }
    });
</script>

<script>
    const lftChick = document.getElementById('leftChicken');

    new Chart(lftChick, {
        type: 'bar',
        data: {
            labels: ['갈릭', '핫양념', '허니소이', '떡볶이', '핵불닭'],
            datasets: [{
                label: '남은 녀석들 상세',
                data: [
                    15 - ${eatChickenClassify[0].count},
                    15 - ${eatChickenClassify[1].count},
                    15 - ${eatChickenClassify[2].count},
                    15 - ${eatChickenClassify[3].count},
                    15 - ${eatChickenClassify[4].count},
                ],
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
