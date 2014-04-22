<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>
<c:choose>
	<c:when test="${! empty param.fullscreen}">
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Monitoring-MAP</title>
		<link href="stylesheets/mapdefault.css" rel="stylesheet" type="text/css" />
		<link href="stylesheets/mapfull.css" rel="stylesheet" type="text/css" />
		<script src="javascripts/jquery.js" type="text/javascript"></script>		
			<script type="text/javascript"> // this was added
				jQuery(document).ready(function(){
					$('.maploader').hide();	
					$('.demo2').show();
				$( "#editmap" ).click(function() {
					$("#chgload").load("mapedithelper.jsp?bid="+$("#branch").val()+"&mapx="+$('#xinput').val()+"&mapy="+ $('#yinput').val());
				});
				<c:if test="${! empty param.edit}">$('#posit').css("display","block");</c:if>
				})
			</script>
		<script src="javascripts/craftmap.js" type="text/javascript"></script>
		<script src="javascripts/mapinit.js" type="text/javascript"></script>	
	</c:when>
	<c:otherwise>
		<c:set var="pageheader"> 
			<link href="stylesheets/map.css" rel="stylesheet" type="text/css" />
			<script>
			jQuery(document).ready(function(){
			$('.maploader').hide();	
			$('.demo1').show();	
			});
			$('#filter_branch').fastLiveFilter('#list_branch', {
			    timeout: 200,
			    callback: function(total) { $('#filter_results').html(total); }
			});
			</script>
			<script src="javascripts/craftmap.js" type="text/javascript"></script>
			<script src="javascripts/mapinit.js" type="text/javascript"></script>
		</c:set>
	</c:otherwise>
</c:choose>
<c:if test="${empty param.fullscreen}"><%@ include file='h_menu.jsp'%></c:if> 

<sql:query dataSource="${databasp}" var="checkMAP1">
select id from branchesorg_${G_org}_${G_ver} where mapxy != ''
</sql:query>

	
	<div id="content">
		<c:if test="${empty param.fullscreen}">		
			<div id="contentHeader">
				<h1>Карта офисов</h1>
			</div> <!-- #contentHeader -->
		</c:if>
		<div class="container">
			
			<div class="grid-24">
				<c:if test="${empty param.fullscreen}">
					<div class="box box-plain">
						Перемещайте карту нажав левую кнопку мыши. 
						<a href="map.jsp?fullscreen=yes">Перейти в полноэкранный режим.</a>
					</div> 
				</c:if>
				<div class="widget widget-map">
				<c:if test="${empty param.fullscreen}">	<div class="widget-header">
						<h3>
							
					</div>
				</c:if>	
					<div class="widget-content">
							<c:if test="${!empty param.fullscreen}">
							<div class="menu"><a href="map.jsp">Телефонная книга</a>
								<c:if test="${! empty G_bookmanager}">
									<div id="posit" class="menuedit">
									<br/><br/><br/>Режим редактирования:<br/>
									x:<input type="text" id="xinput" size="6"/> 
									y:<input type="text" id="yinput" size="6"/> <br/>
									Кликните на карте и нажмите на ИЗМЕНИТЬ,<br/>
									для изменения расположения офиса на карте:<br/>
										<select id="branch" name="branch">	
											<sql:query dataSource="${databasp}" var="getD">
											select * from branchesorg_${G_org}_${G_ver} where id = ${G_bookmanager}
											</sql:query>
												<c:forEach items="${getD.rows}" var="d">
													<option value="${d.id}">${d.name} (${d.mapxy})</option>
												</c:forEach>
										</select>
										<button id="editmap">изменить</button>
										<div id="chgload"></div>
									</div>
								</c:if>
								</div>
							</c:if>
							<div class="maploader" style="height:150px; vertical-align: middle;"><center>
								<br/><br/><strong>Загрузка карты</strong><br/><img src="images/squares.gif"/>
							</center></div>
							<div class="relative">
								<div class="demo${empty param.fullscreen ? '1' : '2'}" style="display:none">
									<img src="images/world_map.jpg" class="imgMap" />
									<sql:query dataSource="${databasp}" var="getDepts">
									select * from branchesorg_${G_org}_${G_ver} where mapxy != '' order by name ASC
									</sql:query>
										<c:forEach items="${getDepts.rows}" var="dept">
										<!-- ##########################################################################################-->
											<sql:query dataSource="${databasp}" var="getExts">
											select id from extensionsorg_${G_org}_${G_ver} where branchid = ?
												<sql:param value="${dept.id}"/>
											</sql:query>
											<c:choose>
												<c:when test="${getExts.rowCount > 40}"><c:set var="kpisize" value="3"/></c:when>
												<c:when test="${getExts.rowCount > 9}"><c:set var="kpisize" value="2"/></c:when>
												<c:otherwise><c:set var="kpisize" value="2"/></c:otherwise>
											</c:choose>
											<c:choose>
											<c:when test="${! empty dept.lasttime}">
												<isoft:timediff time="${dept.lasttime}" var="kpi"/>
											</c:when>
											<c:otherwise>
												<c:set var="kpi" value="0"/>
											</c:otherwise>
											</c:choose>
											<c:choose>
												<c:when test="${(kpi <= 120) and (kpi > 1)}">
													<c:set var="flag" value="greenflag${kpisize}"/>
												</c:when>
												<c:when test="${(kpi <= 360) and (kpi > 120)}">
													<c:set var="flag" value="yellowflag${kpisize}"/>
												</c:when>
												<c:when test="${(kpi <= 2880) and (kpi > 360)}">
													<c:set var="flag" value="redflag${kpisize}"/>
												</c:when>
												<c:when test="${kpi == 0}">
													<c:set var="flag" value="blackflag${kpisize}"/>
												</c:when>
												<c:otherwise>
													<c:set var="flag" value="blackflag${kpisize}"/>
												</c:otherwise>
											</c:choose>
											<div class="marker ${flag}" id="branch${dept.id}" data-coords="${dept.mapxy}">
												<h3>${dept.name}</h3>
												<h4>${dept.city} ${fn:contains(dept.city,'обл') ? '' : 'область'}</h4>
												<h5>${dept.addr}</h5>
												</p>
												<a href="index.jsp?branch=${dept.id}">Подробно</a>
											</div>
										<!-- ##########################################################################################-->
										</c:forEach>
								</div>
							</div>
						
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
					
			</div> <!-- .grid -->
		</div> <!-- .container -->
		
	</div> <!-- #content -->
<c:if test="${empty param.fullscreen}">
		<c:set var="pagescript">
		<script>
		$('#filter_branch').fastLiveFilter('#list_branch', {
		    timeout: 200,
		    callback: function(total) { $('#filter_results').html(total); }
		});
		</script>
		</c:set>

	<%@ include file='foot.jsp'%>
</c:if>
