// 지도 함수
let MapFunc = {
    map : null,
    markers : [],
    openInfoWindow: null, // 현재 열린 InfoWindow를 저장

    // 지도 초기화
    initMap: function() {
        var mapOptions = {
            center: new naver.maps.LatLng(35.8, 127.5),
            zoom: 7
        };

        this.map = new naver.maps.Map('map', mapOptions);
        this.map.setCursor('pointer');

        infoWindow = new naver.maps.InfoWindow({
            anchorSkew: true
        });

        naver.maps.Event.addListener(this.map, 'click', function () {
            if (MapFunc.openInfoWindow) {
                MapFunc.openInfoWindow.close();
                MapFunc.openInfoWindow = null; // 열린 InfoWindow 초기화
            }
        });
    },

    // 지도 핀 업데이트 (내용 수정시 핀 동적으로 업데이트용)
    updatePins: function(reqList) {
        // 기존 핀 제거
        this.markers.forEach(marker => marker.setMap(null));
        this.markers = [];

        // 새로운 핀 추가
        reqList.forEach(videoReq => {
            var marker = new naver.maps.Marker({
                position: new naver.maps.LatLng(videoReq.latitude, videoReq.longitude),
                map: this.map,
                title: videoReq.storeNm,
                animation: naver.maps.Animation.DROP,
                icon: {
                    url: videoReq.status == "STANDBY" ? '/images/common/green_marker.png' : videoReq.isUrgentReq == "N" ? '/images/common/blue_marker.png' : '/images/common/red_marker.png',
                    size: new naver.maps.Size(15, 23),
                    origin: new naver.maps.Point(0, 0),
                    anchor: new naver.maps.Point(5, 23)
                }
            });

            this.markers.push(marker);

            // 핀 클릭 시 나오는 설명
            var infoWindow = new naver.maps.InfoWindow({
                content: 
                '<div style="padding:10px;">' +
                    '<h6>상호명 : [' + videoReq.storeNm + ']</h6>' +
                    '<table class="table table-bordered">' +
                        '<tbody>'+
                            '<tr style="border-top-left-radius:10px">'+
                                '<th class="text-center" style="border-top-left-radius:10px">계약일</th>'+
                                '<td class="text-center">'+videoReq.stringContractDt+'</td>'+
                            '</tr>'+
                            '<tr>'+
                                '<th class="text-center">휴대폰번호</th>'+
                                '<td class="text-center">'+videoReq.phone.substring(0,3)+'-'+videoReq.phone.substring(3,7)+'-'+videoReq.phone.substring(7)+'</td>'+
                            '</tr>'+
                            '<tr>'+
                                '<th class="text-center">주소</th>'+
                                '<td class="text-center">'+videoReq.address+'</td>'+
                            '</tr>'+
                            '<tr>'+
                                '<th class="text-center">특이사항</th>'+
                                '<td class="text-center"><pre><span>'+videoReq.note.replace(/\\n/g, '\n')+'<span></pre></td>'+
                            '</tr>'+
                            '<tr>'+
                                '<th class="text-center" style="border-bottom-left-radius:10px">촬영담당자<br>특이사항</th>'+
                                '<td class="text-center" style="border-bottom-right-radius:10px"><pre><span>'+ videoReq.progressNote.replace(/\\n/g, '\n') +'<span></pre></td>'+
                            '</tr>'+
                        '</tbody>'+
                    '</table>'+
                    '<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#staticBackdrop" ' +
                        'onclick="PageFunc.updateModal('+ 
                        '\''+ videoReq.isUrgentReq + '\'' +','+ 
                        '\''+ videoReq.reqId + '\'' +','+ 
                        '\''+ videoReq.storeNm + '\'' +','+ 
                        '\''+ videoReq.creId + '\'' +','+
                        '\''+ videoReq.creNm + '\'' +','+
                        '\''+ videoReq.creJgNm + '\'' +','+
                        '\''+ videoReq.stringContractDt + '\'' +','+
                        '\''+ videoReq.stringCreDt + '\'' +','+
                        '\''+ videoReq.address + '\'' +','+
                        '\''+ videoReq.phone.substring(0,3)+'-'+videoReq.phone.substring(3,7)+'-'+videoReq.phone.substring(7) + '\'' +','+ 
                        '\''+ videoReq.managerNm + '\'' +','+ 
                        '\''+ videoReq.managerJgNm + '\'' +','+ 
                        '\''+ videoReq.note.replace(/\n/g, '\n') + '\'' +','+ 
                        '\''+ videoReq.status + '\'' +','+ 
                        '\''+ videoReq.progressNote + '\'' + ',' +
                        '\''+ videoReq.stringShootReserveDtm + '\'' + ',' +
                        '\''+ videoReq.stringShootCompleteDt + '\'' + ',' +
                        '\''+ videoReq.stringUploadCompleteDt + '\'' + ',' +
                        ')">'+'매장상세' +
                    '</button>'+
                '</div>'
            });

            naver.maps.Event.addListener(marker, 'click', function () {
                infoWindow.open(MapFunc.map, marker);
                MapFunc.openInfoWindow = infoWindow; // 새 InfoWindow 저장
            });
        });
    },

    // 지도 및 핀 그리기
    drawMap: function(reqList) {
        if (!this.map) {
            this.initMap(); // 처음 한 번만 지도를 생성
        }

        // reqList가 유효한 경우에만 updatePins 실행
        if (reqList && Array.isArray(reqList) && reqList.length > 0) {
            this.updatePins(reqList);
        } else {
            console.warn("reqList가 비어 있거나 유효하지 않습니다.");
        }
    },

    // 주소 검색하고 해당 주소로 이동
    searchAddressToCoordinate: function() {
        const address = $("#addressSearch").val(); // 사용자 입력 주소
        naver.maps.Service.geocode({
            query: address
        }, (status, response) => { // 화살표 함수 사용
            if (status === naver.maps.Service.Status.ERROR) {
                Toast('top', 1000, 'error', '네이버 지도 오류 발생!');
                return;
            }

            if (response.v2.meta.totalCount === 0) {
                Toast('top', 1000, 'warning', '검색된 주소가 없습니다!');
                return;
            }

            var item = response.v2.addresses[0],
                point = new naver.maps.Point(item.x, item.y);

            this.map.setCenter(point); // 화살표 함수로 this 유지
            this.map.setZoom(15);
        });
    },

    searchAddressAndShowPin: function() {
        const address = $("#addressSearch").val(); // 사용자 입력 주소
        naver.maps.Service.geocode({
            query: address
        }, (status, response) => {
            if (status === naver.maps.Service.Status.ERROR) {
                Toast('top', 1000, 'error', '네이버 지도 오류 발생!');
                return;
            }

            if (response.v2.meta.totalCount === 0) {
                Toast('top', 1000, 'warning', '검색된 주소가 없습니다!');
                return;
            }

            item = response.v2.addresses[0],
            point = new naver.maps.Point(item.x, item.y);

            infoWindow.setContent([
                '<table class="table table-striped table-bordered" style="margin : 0px">' +
                    '<tr>' +
                        '<td class="text-center"> 검색 주소 </td>' +
                        '<td class="text-center">' + address + '</td>' +
                    '<tr>' +
                    '<tr>' +
                        '<td class="text-center"> 도로명 주소 </td>' +
                        '<td class="text-center">' + item.roadAddress + '</td>' +
                    '<tr>' +
                    '<tr>' +
                        '<td class="text-center"> 지번 주소 </td>' +
                        '<td class="text-center">' + item.jibunAddress + '</td>' +
                    '<tr>' +
                '</table>' 
            ].join('\n'));

            // 위도, 경도 설정
            $("#address").val($("#addressSearch").val());
            const longitude = $("#longitude");
            const latitude = $("#latitude");

            // 주소 확인 버튼 활성화
            const confirmButton = $("#confirmAddressBtn");

            // 값 설정
            longitude.val(item.x);
            latitude.val(item.y)

            confirmButton.css("display", "inline-block");

            this.map.setCenter(point); // 화살표 함수로 this 유지
            this.map.setZoom(15);

            infoWindow.open(this.map, point);
        });
    }

};