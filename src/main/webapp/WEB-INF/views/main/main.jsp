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
        confirm: function (consumerId, tasteCd, tasteNm) {
            if (consumerId == ${userId}) {
                Swal.fire({
                    title: "맛있게 먹음?",
                    text: `님이 먹은건 ` + tasteNm,
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "예쓰~!",
                    cancelButtonText: "아님~!"
                }).then((result) => {
                    if (result.isConfirmed) {
                        AjaxFunc.plusOneChicken(consumerId, tasteCd);
                    }
                });
            } else {
                Swal.fire({
                    icon: "error",
                    title: "알림!",
                    text: "님 아이디에만 플러스 하셈;",
                });
            }
        },
        plusOneChicken: function (consumerId, tasteCd) {
            $.ajax({
                url: "/chicken/plusOneChicken",
                type: "post",
                cache: false,
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({"consumerId": consumerId, "tasteCd": tasteCd}),
                success: function (response) {
                    if (response) {
                        Swal.fire({
                            title: "알림!",
                            text: "추가되었음.",
                            icon: "success"
                        });
                        setTimeout(function () {
                            window.location.href = "/main"
                        }, 1000)
                    } else {
                        Swal.fire({
                            icon: "error",
                            title: "오류 발생!",
                            text: "관리자 문의점",
                        });
                    }
                }
            })
        }
    }
</script>
<div class="active-calories">
    <h1 style="align-self: flex-start">닭가슴살 근황 (총 ${storeAmt.totalStoreAmt}개중)</h1>
    <div>
        <canvas id="myChart"></canvas>
    </div>
    <div>
        <canvas id="leftChicken" style="height: 200px; margin-top : 20px;"></canvas>
    </div>

    <div class="active-calories-container">
        <br>
        <c:forEach items="${personalEatAmt}" var="list">
            <div class="calories-content" style="width: 220px">
                <span>${list.consumerNm} : </span> <span> ${list.eatAmt}먹</span>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT01', '갈릭')"
                            type="button" class="btn btn-primary" style="background: ivory; color: black;">
                        갈릭
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT02', '핫양념')"
                            type="button" class="btn btn-primary"
                            style="background: darkred; color: white;">핫양념
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT03', '허니소이')"
                            type="button" class="btn btn-primary"
                            style="background: yellow; color: black">허니<br>소이
                    </button>
                </div>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT04', '떡볶이')"
                            type="button" class="btn btn-primary"
                            style="background: orangered; color: white;">떡볶이
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT05', '핵불닭')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">핵붉닭
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

    let userNameList = [];
    let userConsumeAmtList = [];
    let leftChickenAmt = ${storeAmt.totalStoreAmt};

    <c:forEach items="${personalEatAmt}" var="list">
    userNameList.push(`${list.consumerNm}`);
    userConsumeAmtList.push(`${list.eatAmt}`);
    leftChickenAmt -= ${list.eatAmt};
    </c:forEach>
    userNameList.push('남은 닭찌찌~')
    userConsumeAmtList.push(leftChickenAmt);

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: userNameList,
            datasets: [{
                label: 'EAT',
                data: userConsumeAmtList,
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
    const leftChickenGraph = document.getElementById('leftChicken');
    let chickenTasteNmList = [];
    let chickenLeftList = [];

    <c:forEach items="${storeAmt.storeDetail}" var="list">
    chickenTasteNmList.push(`${list.tasteNm}`);
    chickenLeftList.push(${list.tasteLeftAmt})
    </c:forEach>

    new Chart(leftChickenGraph, {
        type: 'bar',
        data: {
            labels: chickenTasteNmList,
            datasets: [{
                label: '남은 녀석들 상세',
                data: chickenLeftList,
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
