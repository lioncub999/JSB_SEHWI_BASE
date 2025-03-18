<%--
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ┃
 ┃     ● 모달
 ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="1" aria-labelledby="staticBackdropLabel" aria-hidden="false" > 
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title fs-5" id="exampleModalLabel">[상호명]</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="video-req-frm", id="video-req-frm">
                        <input type="hidden" id="reqId" name="reqId"/>
                        
                        <table class="table table-bordered" >
                            <col>
                                <div style="color:red" id="modal-is-urgent-req">긴급건</div>
                            </col>
                            <tr>
                                <th class="text-center" style="width : 20%; border-top-left-radius:10px">신청자</th>
                                <td class="text-center"  style="width : 80%;" id ="modal-cre-id"></td>
                            </tr>
                            <tr>
                                <th class="text-center">계약일</th>
                                <td class="text-center" id ="modal-contract-dt"></td>
                            </tr>
                            <tr>
                                <th class="text-center">촬영 신청일</th>
                                <td class="text-center" id ="modal-cre-dt"></td>
                            </tr>
                            <tr>
                                <th class="text-center">휴대폰번호</th>
                                <td class="text-center" id ="modal-phone"></td>
                            </tr>
                            <tr>
                                <th class="text-center">주소</th>
                                <td class="text-center" id ="modal-address"></td>
                            </tr>
                            
                            <tr>
                                <th class="text-center">특이사항</th>
                                <td id ="modal-note"></td>
                            </tr>
                            <tr>
                                <th class="text-center">진행상태</th>
                                <td class="text-center" id ="modal-status"></td>
                            </tr>
                            <tr>
                                <th class="text-center">촬영담당자</th>
                                <td class="text-center" id ="modal-manager-nm"></td>
                            </tr>
                            <tr>
                                <th class="text-center">촬영담당자<br>특이사항</th>
                                <td class="text-center" id ="modal-progress-note"></td>
                            </tr>
                            <tr>
                                <th class="text-center">촬영<br>예정일</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${userGrade == 0}">
                                            <div>
                                                <input type="text" class="form-control" id="shootReserveDtm" name="shootReserveDtm" style="font-size:13px">
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="stringShootReserveDtm" style="font-size:13px"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th class="text-center">촬영<br>완료일</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${userGrade == 0}">
                                            <div>
                                                <input type="text" class="form-control" id="shootCompleteDt" name="shootCompleteDt" style="font-size:13px" readonly>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="stringShootCompleteDt" style="font-size:13px"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th class="text-center" style="border-bottom-left-radius:10px">영상<br>업로드일</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${userGrade == 0}">
                                            <div>
                                                <input type="text" class="form-control" id="uploadCompleteDt" name="uploadCompleteDt" style="font-size:13px" readonly>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="stringUploadCompleteDt" style="font-size:13px"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" >닫기</button>
                    <div class="save-btn-box" id="save-btn-box"></div>
                </div>
            </div>
        </div>
    </div>