<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="logoutUrl" value="/auth/logout"/>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
</head>
<body>
<script>
    let AjaxFunc = {
        logout : function() {
            $.ajax({
                url: "${logoutUrl}",
                type: "post",
                cache: false,
            }).done(function (response) {
                if (response) {
                    Toast('top', 1000, 'success', '로그아웃이 완료되었습니다.');

                    setTimeout(function() {
                        window.location.href = "/login"
                    }, 900)
                } else {
                    alert('에러 발생')
                }
            })
        }
    }
</script>
<div class="activities">
    <h1>게임</h1>
    <div class="activity-container">
        <div class="image-container img-one">
            <img src="<c:url value='/images/home/rullet.png'/>" alt="RULLET" />
            <div class="overlay">
                <h3>RULLET</h3>
            </div>
        </div>

        <div class="image-container img-two">
            <img src="<c:url value='/images/common/preparing.jpeg'/>" alt="preparing" />
            <div class="overlay">
                <h3>준비중..</h3>
            </div>
        </div>

        <div class="image-container img-three">
            <img src="<c:url value='/images/common/preparing.jpeg'/>" alt="preparing" />
            <div class="overlay">
                <h3>준비중..</h3>
            </div>
        </div>

        <div class="image-container img-four">
            <img src="<c:url value='/images/common/preparing.jpeg'/>" alt="preparing" />
            <div class="overlay">
                <h3>준비중..</h3>
            </div>
        </div>

        <div class="image-container img-five">
            <img src="<c:url value='/images/common/preparing.jpeg'/>" alt="preparing" />
            <div class="overlay">
                <h3>준비중..</h3>
            </div>
        </div>

        <div class="image-container img-six">
            <img src="<c:url value='/images/common/preparing.jpeg'/>" alt="preparing" />
            <div class="overlay">
                <h3>준비중..</h3>
            </div>
        </div>
    </div>
</div>

<div class="left-bottom">
    <div class="weekly-schedule">
        <h1>주간 베팅왕 - TOP3</h1>
        <div class="calendar">
            <div class="day-and-activity activity-one">
                <div class="day">
                    <h1>13</h1>
                    <p>mon</p>
                </div>
                <div class="activity">
                    <h2>Swimming</h2>
                    <div class="participants">
                        <img src="https://github.com/ecemgo/mini-samples-great-tricks/assets/13468728/c61daa1c-5881-43f8-a50f-62be3d235daf" style="--i: 1" alt="" />
                        <img src="https://github.com/ecemgo/mini-samples-great-tricks/assets/13468728/90affa88-8da0-40c8-abe7-f77ea355a9de" style="--i: 2" alt="" />
                        <img src="https://github.com/ecemgo/mini-samples-great-tricks/assets/13468728/07d4fa6f-6559-4874-b912-3968fdfe4e5e" style="--i: 3" alt="" />
                        <img src="https://github.com/ecemgo/mini-samples-great-tricks/assets/13468728/e082b965-bb88-4192-bce6-0eb8b0bf8e68" style="--i: 4" alt="" />
                    </div>
                </div>
                <button class="btn">Join</button>
            </div>

            <div class="day-and-activity activity-two">
                <div class="day">
                    <h1>15</h1>
                    <p>wed</p>
                </div>
                <div class="activity">
                    <h2>Yoga</h2>
                    <div class="participants">
                        <img src="https://github.com/ecemgo/mini-samples-great-tricks/assets/13468728/c61daa1c-5881-43f8-a50f-62be3d235daf" style="--i: 1" alt="" />
                        <img src="https://github.com/ecemgo/mini-samples-great-tricks/assets/13468728/32037044-f076-433a-8a6e-9b80842f29c9" style="--i: 2" alt="" />
                    </div>
                </div>
                <button class="btn">Join</button>
            </div>

            <div class="day-and-activity activity-three">
                <div class="day">
                    <h1>17</h1>
                    <p>fri</p>
                </div>
                <div class="activity">
                    <h2>Tennis</h2>
                    <div class="participants">
                        <img src="https://github.com/ecemgo/mini-samples-great-tricks/assets/13468728/32037044-f076-433a-8a6e-9b80842f29c9" style="--i: 1" alt="" />
                        <img src="https://github.com/ecemgo/mini-samples-great-tricks/assets/13468728/e082b965-bb88-4192-bce6-0eb8b0bf8e68" style="--i: 2" alt="" />
                        <img src="https://github.com/ecemgo/mini-samples-great-tricks/assets/13468728/c61daa1c-5881-43f8-a50f-62be3d235daf" style="--i: 3" alt="" />
                    </div>
                </div>
                <button class="btn">Join</button>
            </div>
        </div>
    </div>

    <div class="personal-bests">
        <h1>보유게임머니 - TOP3</h1>
        <div class="personal-bests-container">
            <div class="best-item box-one">
                <p>Fastest 5K Run: 22min</p>
            </div>
            <div class="best-item box-two">
                <p>Longest Distance Cycling: 4 miles</p>
            </div>
            <div class="best-item box-three">
                <p>Longest Roller-Skating: 2 hours</p>
            </div>
        </div>
    </div>
</div>
</body>
</html>
