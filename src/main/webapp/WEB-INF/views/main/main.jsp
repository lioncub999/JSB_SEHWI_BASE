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
            <div class="calories-content" style="width: 230px">
                <span>${list.consumerNm} : </span> <span> ${list.eatAmt}먹</span>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT01', '매콤깐풍기')"
                            type="button" class="btn btn-primary" style="background: ivory; color: black;">
                        매콤<br>깐풍기
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT02', '스모크바베큐')"
                            type="button" class="btn btn-primary"
                            style="background: darkred; color: white;">스모크<br>바베큐
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT03', '스위트콘마요')"
                            type="button" class="btn btn-primary"
                            style="background: yellow; color: black">스위트콘<br>마요
                    </button>
                </div>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT04', '트러플스노우')"
                            type="button" class="btn btn-primary"
                            style="background: orangered; color: white;">트러플<br>스노우
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT05', '고추마요')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">고추마요
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT06', '간장찜닭')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">간장찜닭
                    </button>
                </div>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT07', '왕갈비')"
                            type="button" class="btn btn-primary"
                            style="background: orangered; color: white;">왕갈비
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT08', '치폴레마요')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">치폴레<br>마요
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT09', '버터치킨커리')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">버터치킨<br>커리
                    </button>
                </div>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT10', '스위트어니언')"
                            type="button" class="btn btn-primary"
                            style="background: orangered; color: white;">스위트<br>어니언
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT11', '떡볶이')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">떡볶이
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT12', '핫양념')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">핫양념
                    </button>
                </div>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT13', '허니소이')"
                            type="button" class="btn btn-primary"
                            style="background: orangered; color: white;">허니소이
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT14', '핵불닭')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">핵불닭
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT15', '갈릭')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">갈릭
                    </button>
                </div>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT16', '데리야끼')"
                            type="button" class="btn btn-primary"
                            style="background: orangered; color: white;">데리야끼
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT17', '화이트머쉬룸')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">화이트<br>머쉬룸
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT18', '블랙갈릭')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">블랙갈릭
                    </button>
                </div>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT19', '스리라차마요')"
                            type="button" class="btn btn-primary"
                            style="background: orangered; color: white;">스리라차<br>마요
                    </button>
                    <button onclick="AjaxFunc.confirm(${list.consumerId}, 'HT20', '허니페퍼머스터드')"
                            type="button" class="btn btn-primary"
                            style="background: black; color: red;">허니페퍼<br>머스터드
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
                    'rgb(151,105,230)',
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

                ],
                borderColor: [

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
