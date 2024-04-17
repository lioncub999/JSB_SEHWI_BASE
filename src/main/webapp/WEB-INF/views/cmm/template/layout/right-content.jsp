
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
</head>
<body>
<div class="user-info">
    <div class="icon-container">
        <i class="fas fa-bell nav-icon fa-2x" data-count="25"></i>
    </div>
    <h4>${userNm}</h4>
</div>

<div class="active-calories">
    <h1 style="align-self: flex-start">내 베팅 정보</h1>
    <div class="active-calories-container">
        <div class="box" style="--i: 57%">
            <div class="circle">
                <h2>57<small>%</small></h2>
            </div>
        </div>
        <div class="calories-content" style="text-align: right">
            <p><span>내 게임머니 </span></p>
            <p><span>총 배팅 횟수 </span></p>
            <p><span>적중 횟수 </span></p>
        </div>
        <div class="calories-content">
            <p>1000000</p>
            <p>1000000</p>
            <p>350000</p>
        </div>
    </div>
</div>

<div class="friends-activity">
    <h1>알림</h1>
    <div class="card-container">
        <div class="card">
            <div class="card-user-info">
                <h2>Jane</h2>
            </div>
            <p>We completed the 30-Day Running Streak Challenge!🏃‍♀️🎉</p>
        </div>

        <div class="card">
            <div class="card-user-info">
                <h2>Mike</h2>
            </div>
            <p>I just set a new record in cycling: 30 miles!💪</p>
        </div>

        <div class="card">
            <div class="card-user-info">
                <h2>Mike</h2>
            </div>
            <p>I just set a new record in cycling: 30 miles!💪</p>
        </div>
    </div>
</div>
</body>
</html>
