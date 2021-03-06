<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<jsp:include page="/WEB-INF/jsp/etc/top.jsp" />
	<section class="main-content post-single" >
		<div class="container">
			<div class="row" >
				<div class="col-md-12 col-sm-12" >
					<div class="cat-detail-form">
						<div class="row">
							<div class="detail">
								<div class="row" >
									<div class="col-sm-3" >
										<div class="cat-image">
											<img id="image_preview" src="${pageContext.request.contextPath}/photo/cat/${ cat.no }" alt="고양이 사진"/>
										</div>
									</div>
									<div class="col-sm-9" >
										<div class="row" >
											<div class="col-sm-3">
												<div class="cat-desc">이름 : ${ cat.name }</div>
												<div class="cat-desc">성별 : 
													<c:choose>
														<c:when test="${ cat.gender eq 'M' }" ><i class='fa fa-mars' ></i></c:when>
														<c:otherwise><i class='fa fa-venus' ></i></c:otherwise>
													</c:choose>
												</div>
												<div class="cat-desc">종 : ${ cat.spices }</div>
											</div>
											<div class="col-sm-6">
												<c:choose>
													<c:when test="${ cat.birthDate != null }">
														<div class="cat-desc">출생 연월 : ${ cat.birthDate }</div>
													</c:when>
													<c:otherwise>
														<div class="cat-desc">출생 연월 : 알수 없음</div>
													</c:otherwise>
												</c:choose>
												<div class="cat-desc">중성화 여부 : 
													<c:choose>
														<c:when test="${ cat.tnrStatus eq 'Y' }" >예</i></c:when>
														<c:otherwise>아니오</c:otherwise>
													</c:choose>
												</div>
												<div class="cat-desc">특징 : ${ cat.feature }</div>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6"></div>
									<div class="col-sm-6">
										<div class="btn-container">
											<div class="row" align="right">
												<div class="col-sm-8"></div>
													<button class="common-btn" id="button_obs" type="button" hidden="hidden" >관찰일지</button>
											</div>
											
											<div class="row" align="right">
												<form action="${pageContext.request.contextPath}/cat/${ cat.no }" method="POST" >
													<button class="common-btn" id="button_edit" type="button" onClick="location.href='${pageContext.request.contextPath}/cat/${ cat.no }/form'" hidden="hidden" >수정</button>
													<input type="hidden" name="_method" value="DELETE" />
													<button class="common-btn" id="button_delete" type="submit" hidden="hidden">삭제</button>
													<button class="common-btn" id="button_accessList" type="button" >모든 기록 보기</button>
													<button class="common-btn" id='button_accessMap' type='button' hidden="true" >최근 접근 장소</button>
												</form>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="row" >
							<div class="resource">
								<div id="resource" align="center"></div>
							</div>
						</div>
						
					</div>
				</div>
			</div>
			
		</div>
	</section>
	
	<jsp:include page="/WEB-INF/jsp/etc/footer.jsp" />
	
	<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ptdxeli5jv&callback=drawAccessMap"></script>
</body>

<script>
	$(document).ready(function() {
		var sessionId = "${sessionScope.id}";
		if (sessionId) {
			$("#button_obs").show();
			
			var isAdmin = "${sessionScope.isAdmin}";
			if (isAdmin) {
				$("#button_edit").show();
				$("#button_delete").show();
			}
		}
		
		drawAccessMap();
		
		$("#button_accessMap").click(function() {
			drawAccessMap();
			$("#button_accessMap").hide();
			$("#button_accessList").show();
		});
		
		$("#button_accessList").click(function() {
			drawAccessList();
			$("#button_accessList").hide();
			$("#button_accessMap").show();
		});
		
		$("#button_edit").click(function() {
			$(location).attr("href", "${pageContext.request.contextPath}/cat/${cat.no}/form");
		});
		
		$("#button_obs").click(function() {
			drawObsLogList();
		});
	});
	
	function drawAccessMap() {
		$.ajax({
	        url: "${pageContext.request.contextPath}/cat/data/map/${cat.no}",
	        type: "get",
	        data: { },
	        headers: { "Content-Type" : "application/json;charset=UTF-8" },
	        success: function(rows) {
	        	var script = "";
	        	var accessList = rows.access;
				var facilityList = rows.facilityList;
	        	
				if (accessList != null && accessList.length > 0) {
					
					script += "<div class='map' id='map' style='width:100%;height:500px;'></div>";
					
		           $("#resource").html(script);
		           
		           var position;
		           
				   var map;
				   
				   var markers = [],
				    infoWindows = [];
				   
			       for (var i = 0; i < accessList.length; i++) {
						var time =  accessList[i].accessTime;
						
						for (var j = 0; j < facilityList.length; j++) {
							
							if (accessList[i].facilityNo == facilityList[j].no) {
								if (i == 0) {
									position = new naver.maps.LatLng(facilityList[j].latitude, facilityList[j].longitude);
								
									var mapOptions = {
								       		//지도 좌표
								           	center: position,
								           	zoom: 17
								       	};
								       	
								   map = new naver.maps.Map(document.getElementById('map'), mapOptions);
								}
								
								var contentString = [
						       	    '   <h4>"' + facilityList[j].name + '"에 접근</h4>',
						       	    '   <h5>접근 시간: ' + accessList[i].accessTime + '</h5>'
						       	].join('');
								
								var marker = new naver.maps.Marker({
									title: facilityList[j].name,
						       	    position: new naver.maps.LatLng(facilityList[j].latitude, facilityList[j].longitude),
						       	    map: map,
							       	content: '<div>asdsad</div>'
						       	});
						       	
						       	var infowindow = new naver.maps.InfoWindow({
						       	    content: contentString,
						       	});
						       //	infowindow.open(map, marker);
								
						       	markers.push(marker);
						        infoWindows.push(infowindow);
							}
						}
						
					}
			       	
			       naver.maps.Event.addListener(map, 'idle', function() {
			    	    updateMarkers(map, markers);
			    	});
			       
			       for (var i=0, ii=markers.length; i<ii; i++) {
			   	    	naver.maps.Event.addListener(markers[i], 'click', getClickHandler(i));
			   		}
			       
			       function updateMarkers(map, markers) {

			   	    var mapBounds = map.getBounds();
			   	    var marker, position;

			   	    for (var i = 0; i < markers.length; i++) {

			   	        marker = markers[i]
			   	        position = marker.getPosition();

			   	        if (mapBounds.hasLatLng(position)) {
			   	            showMarker(map, marker);
			   	        } else {
			   	            hideMarker(map, marker);
			   	        }
			   	    }
			   	}

			   	function showMarker(map, marker) {

			   	    if (marker.setMap()) return;
			   	    marker.setMap(map);
			   	}

			   	function hideMarker(map, marker) {

			   	    if (!marker.setMap()) return;
			   	    marker.setMap(null);
			   	}

			   	// 해당 마커의 인덱스를 seq라는 클로저 변수로 저장하는 이벤트 핸들러를 반환합니다.
			   	function getClickHandler(seq) {
			   	    return function(e) {
			   	        var marker = markers[seq],
			   	            infoWindow = infoWindows[seq];

			   	        if (infoWindow.getMap()) {
			   	            infoWindow.close();
			   	        } else {
			   	            infoWindow.open(map, marker);
			   	        }
			   	    }
			   	}
			   	
			   	infoWindows[0].open(map, markers[0]);

				} else {
					script += "<h3>해당 고양이의 접근 정보가 존재하지 않습니다!</h3>";
					
					$("#resource").html(script);
				}
	        }
	    })
	};

	function drawAccessList() {
		$.ajax({
	        url: "${pageContext.request.contextPath}/cat/data/list/${cat.no}",
	        type: "get",
	        data: { },
	        headers: { "Content-Type" : "application/json;charset=UTF-8" },
	        success: function(rows) {
	        	var accessList = rows.accessList;
				var facilityList = rows.facilityList;
				
				var script = "<table class='table table-hover' border='1' >";
					script += "<tr style='background-color: #DEDEDE'>";
					script += "<th>번호</th>";
					script += "<th>접근 시간</th>";
					script += "<th>접근 시설물</th>";
					script += "</tr>";
				
				if (accessList.length > 0) {
					for (var i = 0; i < accessList.length; i++) {
						script += "<tr>";
						script += "<td>" + (i + 1) + "</td>";
						script += "<td>" + accessList[i].accessTime + "</td>";
						
						for (var j = 0; j < facilityList.length; j++) {
							if (accessList[i].facilityNo == facilityList[j].no) {
								script += "<td><a href='${pageContext.request.contextPath}/facility/"+ facilityList[j].no + "'>" + facilityList[j].name + "</a></td>";
								break;
							}
						}
						
						script += "</tr>";
					}
				} else {
					script += "<tr>";
					script += "<td colspan='3'>접근 정보가 존재하지 않습니다!</td>";
					script += "</tr>";
				}
					
				$("#resource").html(script);
	        }
	    })
	};
	
	function drawObsLogList() {
		$.ajax({
	        url: "${pageContext.request.contextPath}/obslog",
	        type: "get",
	        data: { catNo : ${cat.no} },
	        headers: { "Content-Type" : "application/json;charset=UTF-8" },
	        success: function(rows) {
	        	var obsLogList = rows.obsLogList;
				
				var script = "<table class='table table-hover' border='1' >";
					script += "<tr style='background-color: #DEDEDE'>";
					script += "<th >번호</th>";
					script += "<th>고양이</th>";
					script += "<th>작성 일자</th>";
					script += "<th>수정 일자</th>";
					script += "<th>작성자</th>";
					script += "</tr>";
				
				if (obsLogList.length > 0) {
					for (var i = 0; i < obsLogList.length; i++) {
						script += "<tr onclick=\"location.href='${pageContext.request.contextPath}/obslog/"+obsLogList[i].no+"'\" style='cursor:pointer;'>";
						script += "<td>" + (i + 1) + "</td>";
						script += "<td>${ cat.name }</td>";
						script += "<td>" + obsLogList[i].registrateDate + "</td>";
						script += "<td>" + obsLogList[i].modifiedDate + "</td>";
						
						var memberList = rows.memberList;
						for (var j = 0; j < memberList.length; j++) {
							if (obsLogList[i].memberNo == memberList[j].no) {
								script += "<td>" + memberList[j].id + "(" + memberList[j].name + ")</td>";
								break;
							}
						}
						
						script += "</tr>";
					}
				} else {
					script += "<tr>";
					script += "<td colspan='3'>관찰일지가 존재하지 않습니다!</td>";
					script += "</tr>";
				}
					
				$("#resource").html(script);
	        }
	    })
	};
</script>
</html>