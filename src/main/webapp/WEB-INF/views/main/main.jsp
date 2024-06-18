<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<c:set var="chickenUrl" value="/chicken"/>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
<body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
<script>
    let AjaxFunc = {
        plusOneChicken : function(consumer, userNm, chickCd) {
            console.log(userNm);
            console.log('${userNm}');
            if(userNm == '${userNm}') {
                $.ajax({
                    url: "/plusOneChicken",
                    type : "post",
                    cache : false,
                    contentType: "application/json; charset=utf-8",
                    data : JSON.stringify({"consumer" : consumer, "chickCd" : chickCd}),
                    success: function(response) {
                        console.log(response);
                        alert("추가되었슴.")
                        window.location.href = "/main"
                    }
                })

            } else {
                alert("님 아이디에만 플러스 하셈;")
            }

        }
    }
</script>
<div class="active-calories" style="height: 600px; overflow-y: scroll; overflow-x:hidden; overscroll-behavior: none">
    <h1 style="align-self: flex-start">닭가슴살 근황 (총 75개중)</h1>
    <div>
        <canvas id="myChart"></canvas>
    </div>

    <div class="active-calories-container" style="flex-direction: column; text-align: center">
        <br>
        <c:forEach items="${chickenList}" var="chicken">
            <div class="calories-content" style="width: 220px">
                <span>${chicken.userNm} : </span> <span> ${chicken.eat}먹</span>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.plusOneChicken(${chicken.consumer}, '${chicken.userNm}', 'HT01')" type="button" class="btn btn-primary" style="margin : auto; background: ivory; width: 70px">갈릭</button>
                    <button onclick="AjaxFunc.plusOneChicken(${chicken.consumer}, '${chicken.userNm}', 'HT02')" type="button" class="btn btn-primary" style="margin : auto; background: darkred; color: white; width: 70px">핫양념</button>
                    <button onclick="AjaxFunc.plusOneChicken(${chicken.consumer}, '${chicken.userNm}', 'HT03')" type="button" class="btn btn-primary" style="margin : auto; background: yellow; width: 70px">허니소이</button>

                </div>
                <div style="display: flex;">
                    <button onclick="AjaxFunc.plusOneChicken(${chicken.consumer}, '${chicken.userNm}', 'HT04')" type="button" class="btn btn-primary" style="margin : auto; background: orangered; color: white; width: 70px">떡볶이</button>
                    <button onclick="AjaxFunc.plusOneChicken(${chicken.consumer}, '${chicken.userNm}', 'HT05')" type="button" class="btn btn-primary" style="margin : auto; background: black; color: red; width: 70px">핵붉닭</button>
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
            labels: ['남은 닭가슴살','${chickenList[0].userNm}', '${chickenList[1].userNm}', '${chickenList[2].userNm}'],
            datasets: [{
                label: 'EAT',
                data: [75-${chickenList[0].eat+chickenList[1].eat+chickenList[2].eat}, '${chickenList[0].eat}', '${chickenList[1].eat}', '${chickenList[2].eat}'],
                borderWidth: 1,
                hoverOffset: 4,
                backgroundColor: ['grey', 'rgb(255, 99, 132)', 'rgb(54, 162, 235)', 'rgb(255, 205, 86)']
            }],
        },
        options: {
            scales: {
            }
        }
    });
</script>
</body>
</html>
