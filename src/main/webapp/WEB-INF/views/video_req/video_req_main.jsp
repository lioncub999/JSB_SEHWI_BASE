<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 촬영 신청 리스트 페이지
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ include file="/WEB-INF/views/cmm/include/taglibs.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/main.css'/>">
</head>
<body>
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <script src="<c:url value='/js/alert/SweetAlert2.js' />"></script>
    <script>
        let PageControlFunc = {
            <%-- 촬영 신청 추가 페이지 이동 --%>
            moveToReqAddPage: function () {
                window.location.href = '/videoReq/reqCreate';
            }
        }
    </script>
    

    <div class="reqTopBox" style="display:flex;justify-content: space-between;">
        <button onclick="PageControlFunc.moveToReqAddPage()" class="common-blue-btn" style="margin-top:15px;margin-left:15px; margin-bottom:15px">촬영 신청</button>

        <div style="margin-top:15px;margin-right:15px">
            <input type="text" id="searchTxt" placeholder="" style="width: 300px; height:50px">
            <button onclick="" class="common-blue-btn">검색</button>
        </div>
    </div>

    

    <div style="margin-left:10px;margin-right:10px">
        <%-- 요청 리스트 테이블 --%>
        <table class="table table-striped table-bordered" >
            <thead class="text-center" style="height:50px">
                <tr>
                    <th style="width: 3%; border-top-left-radius:10px;">신청ID</th>
                    <th style="width: 8%;">신청일</th>
                    <th style="width: 8%;">신청자</th>
                    <th style="width: 10%;">연락처</th>
                    <th style="width: 25%;">주소</th>
                    <th style="width: 25%;">특이사항</th>
                    <th style="width: 5%;">촬영완료여부</th>
                    <th style="width: 5%;">촬영담당자</th>
                    <th style="width: 5%; border-top-right-radius:10px;">진행상태</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="videoReq" items="${videoReqList}">
                    <tr>
                        <td class="text-center">${videoReq.reqId}</td>
                        <td class="text-center">${videoReq.stringCreDtm}</td>
                        <td class="text-center">${videoReq.creId}</td>
                        <td class="text-center">
                            ${videoReq.phone.substring(0,3)}-${videoReq.phone.substring(3,7)}-${videoReq.phone.substring(7)}
                        </td>
                        <td>${videoReq.address}</td>
                        <td><pre style="margin:0px"><span>${videoReq.note}</span></pre></td>
                        <td class="text-center"></td>
                        <td class="text-center"></td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${videoReq.status == 'COORDINATION'}">
                                    일정조율중
                                </c:when>
                                <c:otherwise>
                                    ${videoReq.status}
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <%-- 페이지네이션 --%>
    <nav aria-label="Page navigation example" style="justify-items : center">
        <ul class="pagination">
            <li class="page-item">
                <a class="page-link" href="/videoReq?curPage=1" aria-label="Previous">
                    <span aria-hidden="true">&lt;&lt;</span>
                </a>
            </li>

            <li class="page-item">
                <a class="page-link" href="/videoReq?curPage=${curPage - 1 > 0 ? curPage- 1 : 1}" aria-label="">
                    <span aria-hidden="true">&lt;</span>
                </a>
            </li>
                
            <!-- 현재 페이지 그룹에 맞는 페이지 버튼만 출력 -->
            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                <li class="page-item ${i == curPage ? 'active' : ''}">
                    <a class="page-link" href="/videoReq?curPage=${i}" aria-label="">
                        <span aria-hidden="true">${i}</span>
                    </a>
                </li>
            </c:forEach>
            
            <li class="page-item">
                <a class="page-link" href="/videoReq?curPage=${curPage + 1 <= maxPage ? curPage + 1 : maxPage}" aria-label="">
                    <span aria-hidden="true">&gt;</span>
                </a>
            </li>
            <a class="page-link" href="/videoReq?curPage=${maxPage}" aria-label="Next">
                <span aria-hidden="true">&gt;&gt;</span>
            </a>
            </li>
        </ul>
    </nav>
</body>
</html>