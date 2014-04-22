<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:if test="${empty verbose}"><c:set var="verbose" value="all" scope="session"/></c:if>
<c:if test="${param.verbose == 'all'}"><c:set var="verbose" value="all" scope="session"/></c:if>
<c:if test="${param.verbose == 'error'}"><c:set var="verbose" value="error" scope="session"/></c:if>

<c:if test="${empty viewdata}"><c:set var="viewdata" value="onlinepbx" scope="session"/></c:if>
<c:if test="${param.viewdata == 'onlinepbx'}"><c:set var="viewdata" value="onlinepbx" scope="session"/></c:if>
<c:if test="${param.viewdata == 'connectedphones'}"><c:set var="viewdata" value="connectedphones" scope="session"/></c:if>
<c:if test="${param.viewdata == 'hwstatus'}"><c:set var="viewdata" value="hwstatus" scope="session"/></c:if>
<c:if test="${param.viewdata == 'trstatus'}"><c:set var="viewdata" value="trstatus" scope="session"/></c:if>

<c:if test="${param.tableform == 'false'}"><c:remove var="tableform" scope="session"/></c:if>
<c:if test="${(param.tableform == 'true') or (! empty tableform)}">
<c:set var="tableform" value="true" scope="session"/>
<c:set var="tableformBegin">
	<c:choose>
		<c:when test="${viewdata == 'connectedphones'}">
			<table class="table table-striped"><thead><tr>
				<th>Установлено %</th>
				<th>Установлено #</th>
				<th>название</th>
				<th>адрес</th>
			</tr></thead><tbody>
		</c:when>
		<c:when test="${viewdata == 'hwstatus'}">
			<table class="table table-striped"><thead><tr>
				<th>память</th>
				<th>диски</th>
				<th>загрузка CPU</th>
				<th>название</th>
				<th>адрес</th>
			</tr></thead><tbody>
		</c:when>
		<c:when test="${viewdata == 'trstatus'}">
			<table class="table table-striped"><thead><tr>
				<th><c:if test="${param.viewfilter != 'trunksonly'}">пиры</c:if></th>
				<th>транки</th>
				<th>sip связь</th>
				<th>название</th>
				<th>адрес</th>
			</tr></thead><tbody>
		</c:when>
		<c:otherwise>
			<table class="table table-striped"><thead><tr>
				<th>последнее обновление</th>
				<th>название</th>
				<th>адрес</th>
			</tr></thead><tbody>
		</c:otherwise>
	</c:choose>
</c:set>
<c:set var="tableformEND"></tbody></table></c:set>
</c:if>


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
				var key=[];
				  key["c"]=67;
				  key["space"]=32;
				  key["enter"]=13;
				$(document).keyup(function(evt)
				{ if (evt.keyCode==key["c"])
				    {
				       if ($('#posit').css('display') == 'none')
						{
						$('#posit').css("display","block");
						} else {
						$('#posit').css("display","none");	
						}
				        return false;
				    }
				if (evt.keyCode==key["space"])
					{
					if ($('#posit').css('display') == 'block')
						{
					   alert($('#xinput').val() + "<>" + $('#yinput').val());
						}
					return false;
					}
				});	
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
		<c:if test="${empty tableform}"><link href="stylesheets/map.css" rel="stylesheet" type="text/css" /></c:if>
		<style>
		.controls {
		position:relative;
		z-index:20;
		overflow-y:scroll;overflow:-moz-scrollbars-vertical; 
		height:300px; 
		width : 100%;
		word-wrap:break-word
		}

		.controls::-webkit-scrollbar {
		    width: 14px;
		}

		.controls::-webkit-scrollbar-track {
		    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
		    border-radius: 10px;
		}

		.controls::-webkit-scrollbar-thumb {
		    border-radius: 10px;
		    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.5);
		}
		</style>
			<c:set var="pagescript">
			<script src="javascripts/jquery.fastLiveFilter.js"></script>
			<script>
			jQuery(document).ready(function(){
			$('.maploader').hide();	
			$('.demo1').show();	
			});
			$('#filter_branch').fastLiveFilter('#list_branch', {
			    timeout: 200,
			    callback: function(total) { $('#filter_results').html(total); }
			});
			$(function() {
				$('#filter_branch').val("${filter_val_temp}").change();
			});
			$( "#filter_pin" ).click(function() {
				$('#filter_pin').load('filter_helper.jsp?new_filter='+$('#filter_branch').val());
				$('#filter_pin').hide();
			});
			</script>
			</c:set>
		</c:set>
	</c:otherwise>
</c:choose>




<c:if test="${empty param.fullscreen}"><%@ include file='h_menu.jsp'%></c:if>
	
	<div id="content">
		<c:if test="${empty param.fullscreen}">		
			<div id="contentHeader">
				<h1>
					<c:if test="${viewdata == 'onlinepbx'}">Мониторинг доступности офисов</c:if>
					<c:if test="${viewdata == 'connectedphones'}">Мониторинг установленных телефонов</c:if>
					<c:if test="${viewdata == 'hwstatus'}">Мониторинг состояния серверов</c:if>
					<c:if test="${viewdata == 'trstatus'}">Мониторинг транков и пиров</c:if>
				</h1>
			</div> <!-- #contentHeader -->
		</c:if>
		<div class="container">
			
			<div class="grid-18">
				
				<div class="widget widget-map">
				<c:if test="${empty param.fullscreen}">	<div class="widget-header">
						<h3>Показываем ${verbose == 'all' ? 'все ' : 'проблемные'} офисы
							<c:if test="${viewdata == 'onlinepbx'}">по синхронизации с главным сервером</c:if>
							<c:if test="${viewdata == 'connectedphones'}">по установленным телефонам</c:if>
							<c:if test="${viewdata == 'hwstatus'}">по статусу RAM, HDD, CPU</c:if>
						</h3>
					</div>
				</c:if>	
					<div class="widget-content">
							<c:if test="${!empty param.fullscreen}">
							<div class="menu"><a href="monitoringmap1.jsp">Панель управления</a>
								<div id="posit" style="display:none;" class="menuedit">
								<br/><br/><br/>Режим редактирования:<br/>
								x:<input type="text" id="xinput" size="6"/> 
								y:<input type="text" id="yinput" size="6"/> <br/>
								Кликните на карте и выберите офис<br/>
								для которого следует установить <br/>координаты на карте:<br/>
									<select id="branch" name="branch">
										<option value="noneofoffice">не выбрано</option>
										<sql:query dataSource="${databas}" var="getD">
										select * from branchesorg_${G_org}_${G_ver} order by city,name ASC
										</sql:query>
											<c:forEach items="${getD.rows}" var="d">
												<option value="${d.id}" ${param.selbranch == d.id ? 'selected="selected"' : ''}>${d.city} - ${d.name} (${d.mapxy})</option>
											</c:forEach>
									</select>
									<button id="editmap">изменить</button>
									<div id="chgload"></div>
								</div>
								</div>
							</c:if>
							<div class="maploader" style="height:150px; vertical-align: middle;"><center>
								<br/><br/><strong>Загрузка карты</strong><br/><img src="images/loaders/squares.gif"/>
							</center></div>
							<div class="relative">
								<div class="demo${empty param.fullscreen ? '1' : '2'}" style="display:none">
									<c:if test="${empty tableform}"><img src="images/world_map.jpg" class="imgMap" /></c:if>
									<sql:query dataSource="${databas}" var="getDepts">
									select * from branchesorg_${G_org}_${G_ver} where mapxy != '' order by city,name ASC
									</sql:query>
									${tableformBegin}
									<c:forEach items="${getDepts.rows}" var="dept">
										<c:remove var="verbosest"/>
										<c:choose>
										<c:when test="${viewdata == 'connectedphones'}">
										<!-- ##########################################################################################-->
											<sql:query dataSource="${databas}" var="getExts">
											select id from extensionsorg_${G_org}_${G_ver} where branchid = ?
												<sql:param value="${dept.id}"/>
											</sql:query>
											<sql:query dataSource="${databas}" var="getExtsReg">
											select id from extensionsorg_${G_org}_${G_ver} where branchid = ? and EXISTS
											 (select extid from activation 
											where extensionsorg_${G_org}_${G_ver}.id = activation.extid and deviceid != '' and orgid = ${G_org})
												<sql:param value="${dept.id}"/>
											</sql:query>
												<c:choose>
													<c:when test="${getExts.rowCount > 40}"><c:set var="kpisize" value="3"/></c:when>
													<c:when test="${getExts.rowCount > 9}"><c:set var="kpisize" value="2"/></c:when>
													<c:otherwise><c:set var="kpisize" value="2"/></c:otherwise>
												</c:choose>
											<c:set value="${getExtsReg.rowCount div getExts.rowCount}" var="kpi"/>
											<c:if test="${getExts.rowCount == 0}"> <c:set var="kpi" value="0"/></c:if>
											<c:remove var="ticket"/>
											<c:choose>
												<c:when test="${kpi == 1}">
													<c:set var="flag" value="greenflag${kpisize}"/>
													<c:set var="ticket" value="success"/>
												</c:when>
												<c:when test="${kpi > 0.9}">
													<c:set var="flag" value="blueflag${kpisize}"/>
													<c:set var="verbosest" value="yes"/>
													<c:set var="ticket" value="info"/>
												</c:when>
												<c:when test="${kpi > 0.6}">
													<c:set var="flag" value="yellowflag${kpisize}"/>
													<c:set var="ticket" value="warning"/>
													<c:set var="verbosest" value="yes"/>
												</c:when>
												<c:when test="${kpi > 0.1}">
													<c:set var="flag" value="redflag${kpisize}"/>
													<c:set var="ticket" value="important"/>
													<c:set var="verbosest" value="yes"/>
												</c:when>
												<c:otherwise>
													<c:set var="flag" value="blackflag${kpisize}"/>
												</c:otherwise>
											</c:choose>
											<c:if test="${(verbose == 'all') or ((verbose == 'error') and (verbosest == 'yes'))}">
												<c:choose>
													<c:when test="${empty tableform}">
														<div class="marker ${flag}" id="branch${dept.id}" data-coords="${dept.mapxy}">
															<h3>${dept.name}</h3>
															<h4>Завершено на <fmt:formatNumber value="${(getExtsReg.rowCount div getExts.rowCount) * 100}" pattern="0"/> %</h4>
															<h5>Количество абонентов: ${getExts.rowCount}<br/>
															   Активированно телефонов : ${getExtsReg.rowCount} <br/></h5>
															<a href="branch.jsp?id=${dept.id}">Подробно</a>
														</div>
													</c:when>
													<c:otherwise>
														<tr class="odd gradeX">
															<c:if test="${dept.city != citysplit}"><td colspan="4"><b>${dept.city}</b><br/>${dept.techperson}&nbsp;(${dept.techtel})</td></tr><tr class="odd gradeX"></c:if>
															<c:set var="citysplit">${dept.city}</c:set>
															<td><span class="ticket ticket-${ticket}">
																<fmt:formatNumber value="${(getExtsReg.rowCount div getExts.rowCount) * 100}" pattern="0"/> %
															</span></td>
															<td>${getExtsReg.rowCount} из ${getExts.rowCount}</td>
															<td><a href="branch.jsp?id=${dept.id}">${dept.id}.</a> ${dept.name}</td>
															<td>${dept.addr}</td>
														</tr>
													</c:otherwise>
												</c:choose>
											<c:set var="filterdeptlist">${filterdeptlist}<li><a href="#" rel="branch${dept.id}">${dept.name}</a></li></c:set>
											<c:set var="statcount" value="${statcount+1}"/>
											</c:if>
										<!-- ##########################################################################################-->
										</c:when>
										<c:when test="${(viewdata == 'hwstatus') and (! empty dept.hwstatus)}">
										<!-- ##########################################################################################-->
											<sql:query dataSource="${databas}" var="getExts">
											select id from extensionsorg_${G_org}_${G_ver} where branchid = ?
												<sql:param value="${dept.id}"/>
											</sql:query>
											<c:choose>
												<c:when test="${getExts.rowCount > 40}"><c:set var="kpisize" value="3"/></c:when>
												<c:when test="${getExts.rowCount > 9}"><c:set var="kpisize" value="2"/></c:when>
												<c:otherwise><c:set var="kpisize" value="2"/></c:otherwise>
											</c:choose>
											<c:remove var="ticket"/>	
												<c:set var="pram">${fn:substringAfter(dept.hwstatus,'FRAM:')}</c:set>
												<c:set var="pram">${fn:substringBefore(pram,'kb;')}</c:set>
												<c:set var="proot">${fn:substringAfter(dept.hwstatus,'FROOT:')}</c:set>
												<c:set var="proot">${fn:substringBefore(proot,'M;')}</c:set>	
												<c:set var="proot">${fn:substringBefore(proot,'.')}</c:set>
												<c:set var="pcpu">${fn:substringAfter(dept.hwstatus,'load average: ')}</c:set>
												<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>
												<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>	
												<c:set var="pcpu">${fn:substringBefore(pcpu,';')}</c:set>
												<c:if test="${empty pcpu}"><c:set var="pcpu" value="0"/></c:if>
												
											<c:choose>
												<c:when test="${(pram > 500) and (proot > 200) and (pcpu < 0.7)}">
													<c:set var="flag" value="greenflag${kpisize}"/><c:set var="ticket" value="success"/>
												</c:when>
												<c:when test="${empty dept.hwstatus}">
													<c:set var="flag" value="blackflag${kpisize}"/>
												</c:when>
												<c:otherwise>
													<c:set var="flag" value="redflag${kpisize}"/><c:set var="ticket" value="important"/>
													<c:set var="verbosest" value="yes"/>
												</c:otherwise>
											</c:choose>
											<c:if test="${(verbose == 'all') or ((verbose == 'error') and (verbosest == 'yes'))}">
												<c:choose>
													<c:when test="${empty tableform}">
														<div class="marker ${flag}" id="branch${dept.id}" data-coords="${dept.mapxy}">
															<h3>${dept.name}</h3>
															<h4><span class="icon-bolt" style="background-color:${pram > 500 ? '#ffffff' : '#ff0000'};border: 1px solid white;"></span>&nbsp;RAM = ${pram}&nbsp; <font size="1">KB свободно</font><br/>
																<span class="icon-battery-empty" style="background-color:${proot > 200 ? '#ffffff' : '#ff0000'};border: 1px solid white;"></span>&nbsp;SDA = ${proot}&nbsp; <font size="1">MB свободно</font><br/>
																<span class="icon-cog-alt" style="background-color:${pcpu < 0.7 ? '#ffffff' : '#ff0000'};border: 1px solid white;"></span>&nbsp;CPU = <fmt:formatNumber value="${pcpu * 100}" pattern="0" var="pcpuok"/> ${pcpuok} % &nbsp; <font size="1">за 15 мин</font><br/>
															</h4>
															<a href="branch.jsp?id=${dept.id}">Подробно</a>
														</div>
													</c:when>
													<c:otherwise>
														<tr class="odd gradeX">
															<c:if test="${dept.city != citysplit}"><td colspan="5"><b>${dept.city}</b><br/>${dept.techperson}&nbsp;(${dept.techtel})</td></tr><tr class="odd gradeX"></c:if>
															<c:set var="citysplit">${dept.city}</c:set>
																<td><span class="ticket ticket-${pram > 500 ? 'success' : 'important'}">
																RAM = ${pram}</span></td>
																<td><span class="ticket ticket-${proot > 200 ? 'success' : 'important'}">
																SDA = ${proot}</span></td>
																<td><span class="ticket ticket-${pcpu < 0.7 ? 'success' : 'important'}">
																CPU = <fmt:formatNumber value="${pcpu * 100}" pattern="0" var="pcpuok"/> ${pcpuok} % </span></td>
															<td><a href="branch.jsp?id=${dept.id}">${dept.id}.</a> ${dept.name}</td>
															<td>${dept.addr}</td>
														</tr>
													</c:otherwise>
												</c:choose>
											<c:set var="filterdeptlist">${filterdeptlist}<li><a href="#" rel="branch${dept.id}">${dept.name}</a></li></c:set>
											<c:set var="statcount" value="${statcount+1}"/>
											</c:if>
										<!-- ##########################################################################################-->	
										</c:when>
										<c:when test="${(viewdata == 'trstatus') and (fn:contains(dept.hwstatus,'PEER'))}">
										<!-- ##########################################################################################-->
											<sql:query dataSource="${databas}" var="getExts">
											select id from extensionsorg_${G_org}_${G_ver} where branchid = ?
											<sql:param value="${dept.id}"/>
											</sql:query>
											<c:choose>
												<c:when test="${getExts.rowCount > 40}"><c:set var="kpisize" value="3"/></c:when>
												<c:when test="${getExts.rowCount > 9}"><c:set var="kpisize" value="2"/></c:when>
												<c:otherwise><c:set var="kpisize" value="2"/></c:otherwise>
											</c:choose>
												<c:remove var="ticket"/>
												<c:set var="PEERSTOT">${fn:substringAfter(dept.hwstatus,'PEERSTOT:')}</c:set>
												<c:set var="PEERSTOT">${fn:substringBefore(PEERSTOT,';PEERSREG')}</c:set>
												
												<c:set var="PEERSREG">${fn:substringAfter(dept.hwstatus,'PEERSREG:')}</c:set>
												<c:set var="PEERSREG">${fn:substringBefore(PEERSREG,';SIPPINGLOSS')}</c:set>
												
												<c:set var="SIPPINGLOSS">${fn:substringAfter(dept.hwstatus,'SIPPINGLOSS:')}</c:set>
												<c:set var="SIPPINGLOSS">${fn:substringBefore(SIPPINGLOSS,';SIPTRUNKS')}</c:set>
												
												<c:set var="SIPTRUNKS">${fn:substringAfter(dept.hwstatus,'SIPTRUNKS:')}</c:set>
												<c:set var="SIPTRUNKS">${fn:substringBefore(SIPTRUNKS,';SIPREGISTRY')}</c:set>
												
												<c:set var="SIPREGISTRY">${fn:substringAfter(dept.hwstatus,'SIPREGISTRY:')}</c:set>
												<c:set var="SIPREGISTRY">${fn:substringBefore(SIPREGISTRY,';')}</c:set>
												
												<c:set var="SIPPINGQTY" value="${100 - SIPPINGLOSS}"/>
													<c:if test="${empty PEERSREG}"><c:set var="PEERSREG" value="0"/></c:if>
													<c:if test="${empty PEERSTOT}"><c:set var="PEERSTOT" value="0"/></c:if>
													
												<c:set var="flag" value="greenflag${kpisize}"/><c:set var="ticket" value="success"/>
												<fmt:formatNumber value="${(PEERSREG div PEERSTOT) * 100}" pattern="0" var="PEERRATE"/>
												<isoft:regexp pat="^[0-9]{1,10}+$" value="${PEERRATE}" var="chPER"/>
												<c:if test="${chPER != 'true'}"><c:set var="PEERRATE" value="0"/></c:if>
												<c:remove var="SIPMSG"/>
												<c:if test="${empty PEERRATE}"><c:set var="PEERSREG" value="0"/></c:if>
												<c:if test="${param.viewfilter != 'trunksonly'}">
													<c:if test="${(PEERRATE < 50) and (PEERSREG != 0) }">
														<c:set var="flag" value="yellowflag${kpisize}"/><c:set var="ticket" value="warning"/>
														<c:set var="verbosest" value="yes"/>
													</c:if>
												</c:if>
												
												<c:if test="${(SIPPINGLOSS > 0) and (SIPPINGLOSS <= 90)}">
													<c:set var="flag" value="yellowflag${kpisize}"/><c:set var="ticket" value="warning"/>
													<c:set var="verbosest" value="yes"/>
												</c:if>
												
												<c:if test="${(SIPTRUNKS != SIPREGISTRY) and (SIPPINGLOSS < 90)}">
													<c:set var="SIPMSG"><strong><font color="red">нет SIP регистрации</font></strong><br/></c:set>
													<c:set var="flag" value="redflag${kpisize}"/><c:set var="ticket" value="important"/>
													<c:set var="verbosest" value="yes"/>
												</c:if>
												<c:if test="${SIPTRUNKS == '-1'}">
													<c:set var="SIPMSG"><strong><font color="red">остановлен Asterisk</font></strong><br/></c:set>
													<c:set var="flag" value="redflag${kpisize}"/><c:set var="ticket" value="important"/>
													<c:set var="verbosest" value="yes"/>
												</c:if>
												<c:if test="${param.viewfilter != 'trunksonly'}"><c:if test="${PEERSREG == 0}">
													<c:set var="SIPMSG"><strong><font color="red">все аппараты оффлайн</font></strong><br/></c:set>
													<c:set var="flag" value="redflag${kpisize}"/><c:set var="ticket" value="important"/>
													<c:set var="verbosest" value="yes"/>
												</c:if></c:if>
												<c:if test="${SIPPINGLOSS > 90}">
													<c:set var="SIPMSG"><strong><font color="red">нет связи с SIP шлюзом</font></strong><br/></c:set>
													<c:set var="flag" value="redflag${kpisize}"/><c:set var="ticket" value="important"/>
													<c:set var="verbosest" value="yes"/>
												</c:if>
												<c:if test="${! fn:contains(dept.hwstatus,'PEER')}">
													<c:set var="flag" value="blackflag${kpisize}"/><c:set var="ticket" value=""/>
												</c:if>
												
											<c:if test="${(verbose == 'all') or ((verbose == 'error') and (verbosest == 'yes'))}">
											<c:choose>
												<c:when test="${empty tableform}">
													<div class="marker ${flag}" id="branch${dept.id}" data-coords="${dept.mapxy}">
														<h3>${dept.name}</h3>
														<span class="ticket ${PEERSREG == 0 ? 'ticket-important' : ''} ${(PEERRATE < 50) and (PEERSREG != 0) ? 'ticket-warning' : ''} ${(PEERRATE > 90) ? 'ticket-success' : ''}">пиры ${PEERSREG} из ${PEERSTOT}</span>&nbsp;
														<span class="ticket ${SIPTRUNKS != SIPREGISTRY ? 'ticket-important' : ''} ${SIPTRUNKS == SIPREGISTRY ? 'ticket-success' : ''}" > транки ${SIPREGISTRY} из ${SIPTRUNKS}</span>
														<span class="ticket ${SIPPINGLOSS > 90 ? 'ticket-important' : ''} ${(SIPPINGLOSS > 0) and (SIPPINGLOSS <= 90) ? 'ticket-warning' : ''} ${SIPPINGQTY > 90 ? 'ticket-success' : ''}">sip связь ${SIPPINGQTY}%</span>&nbsp;
														<a href="branch.jsp?id=${dept.id}">Подробно</a>
													</div>
												</c:when>
												<c:otherwise>
													<tr class="odd gradeX">
														<c:if test="${dept.city != citysplit}"><td colspan="5"><b>${dept.city}</b><br/>${dept.techperson}&nbsp;(${dept.techtel})</td></tr><tr class="odd gradeX"></c:if>
														<c:set var="citysplit">${dept.city}</c:set>
															<c:if test="${param.viewfilter != 'trunksonly'}"><td><span class="ticket ${PEERSREG == 0 ? 'ticket-important' : ''} ${(PEERRATE < 50) and (PEERSREG != 0) ? 'ticket-warning' : ''} ${(PEERRATE > 90) ? 'ticket-success' : ''}">${PEERSREG} из ${PEERSTOT}</span></td>
															</c:if><c:if test="${param.viewfilter == 'trunksonly'}"><td></td></c:if>
															<td><span class="ticket ${SIPTRUNKS != SIPREGISTRY ? 'ticket-important' : ''} ${SIPTRUNKS == SIPREGISTRY ? 'ticket-success' : ''}" >${SIPREGISTRY} из ${SIPTRUNKS}</span></td>
															<td><span class="ticket ${SIPPINGLOSS > 90 ? 'ticket-important' : ''} ${(SIPPINGLOSS > 0) and (SIPPINGLOSS <= 90) ? 'ticket-warning' : ''} ${SIPPINGQTY > 90 ? 'ticket-success' : ''}">${SIPPINGQTY}%</span></td>
														<td><a href="branch.jsp?id=${dept.id}">${dept.id}.</a> ${dept.name}</td>
														<td>${dept.addr}</td>
													</tr>
												</c:otherwise>
											</c:choose>
											<c:set var="filterdeptlist">${filterdeptlist}<li><a href="#" rel="branch${dept.id}">${dept.name}</a></li></c:set>
											<c:set var="statcount" value="${statcount+1}"/>
											</c:if>
										<!-- ##########################################################################################-->	
										</c:when>
										<c:otherwise>
										<!-- ##########################################################################################-->
											<sql:query dataSource="${databas}" var="getExts">
											select id from extensionsorg_${G_org}_${G_ver} where branchid = ?
												<sql:param value="${dept.id}"/>
											</sql:query>
											<c:remove var="ticket"/>
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
												<c:set var="kpi" value="-1"/>
											</c:otherwise>
											</c:choose>
											<c:choose>
												<c:when test="${(kpi <= 120) and (kpi >= 0)}">
													<c:set var="flag" value="greenflag${kpisize}"/>
													<c:set var="ticket" value="success"/>
														<c:if test="${(empty dept.dialplan1) or (empty dept.dialplan2) or (empty dept.customsip)}">
															<c:set var="flag" value="blueflag${kpisize}"/>
															<c:set var="ticket" value="info"/>
															<c:set var="verbosest" value="yes"/>
														</c:if>
												</c:when>
												<c:when test="${(kpi <= 360) and (kpi > 120)}">
													<c:set var="flag" value="yellowflag${kpisize}"/>
													<c:set var="ticket" value="warning"/>
													<c:set var="verbosest" value="yes"/>
												</c:when>
												<c:when test="${(kpi <= 3000) and (kpi > 360)}">
													<c:set var="flag" value="redflag${kpisize}"/>
													<c:set var="ticket" value="important"/>
													<c:set var="verbosest" value="yes"/>
												</c:when>
												<c:when test="${kpi == 0}">
													<c:set var="flag" value="blackflag${kpisize}"/>
												</c:when>
												<c:otherwise>
													<c:set var="flag" value="blackflag${kpisize}"/>
												</c:otherwise>
											</c:choose>
											<c:if test="${(verbose == 'all') or ((verbose == 'error') and (verbosest == 'yes'))}">
											<c:choose>
												<c:when test="${empty tableform}">
													<div class="marker ${flag}" id="branch${dept.id}" data-coords="${dept.mapxy}">
														<h3>${dept.name}</h3>
														<h5>
															<c:choose>
																<c:when test="${kpi >= 0}">
																Последнее обновление было ${kpi} минут назад
																</c:when>
																<c:otherwise>
																Сервер в коробке
																</c:otherwise>
															</c:choose>
														</h5>
														<c:if test="${(empty dept.dialplan1) or (empty dept.dialplan2) or (empty dept.customsip)}">
														<h4><span class="icon-chat" style="background-color:#ff0000;border: 1px solid white;"></span>&nbsp;Нет диалпланов</h4>
														</c:if>
														</p>
														<a href="branch.jsp?id=${dept.id}">Подробно</a>
													</div>
												</c:when>
												<c:otherwise>
													<tr class="odd gradeX">
														<c:if test="${dept.city != citysplit}"><td ${(viewdata == 'hwstatus') or (viewdata == 'trstatus') ? 'colspan="6"' : 'colspan="3"'}><b>${dept.city}</b><br/>${dept.techperson}&nbsp;(${dept.techtel})</td></tr><tr class="odd gradeX"></c:if>
														<c:set var="citysplit">${dept.city}</c:set>
														<td ${(viewdata == 'hwstatus') or (viewdata == 'trstatus') ? 'colspan="3"' : ''}><span class="ticket ticket-${ticket}"><c:choose>
															<c:when test="${kpi >= 0}">
															${viewdata != 'onlinepbx' ? 'сервер оффлайн&nbsp;' : ''} ${kpi} мин
															</c:when>
															<c:otherwise>
															Сервер в коробке
															<c:if test="${(empty dept.dialplan1) or (empty dept.dialplan2) or (empty dept.customsip)}">
															<span class="icon-chat" style="background-color:#ff0000;border: 1px solid white;"></span>&nbsp;Нет диалпланов
															</c:if>
															</c:otherwise>
															</c:choose></span></td>
														<td><a href="branch.jsp?id=${dept.id}">${dept.id}.</a> ${dept.name}</td>
														<td>${dept.addr}</td>
													</tr>
												</c:otherwise>
											</c:choose>
											
											<c:set var="filterdeptlist">${filterdeptlist}<li><a href="#" rel="branch${dept.id}">${dept.name}</a></li></c:set>
											<c:set var="statcount" value="${statcount+1}"/>
											</c:if>
										<!-- ##########################################################################################-->
										</c:otherwise>
										</c:choose>
										</c:forEach>${tableformEND}
								</div>
							</div>
						
						
					</div> <!-- .widget-content -->
					
				</div> <!-- .widget -->
					
			</div> <!-- .grid -->
			<c:if test="${empty param.fullscreen}">
				<div class="grid-6">
							<div id="gettingStarted" class="box">
								<h3>Настройка мониторинга</h3>
								<c:if test="${empty statcount}"><c:set var="statcount" value="0"/></c:if>
								Сейчас  
								<a href="monitoringmap1.jsp?tableform=false">${empty tableform ? '<b><u>' : ''} на карте${empty tableform ? '</b></u>' : ''}</a>
									или 
								<a href="monitoringmap1.jsp?tableform=true">${! empty tableform ? '<b><u>' : ''} в таблице${! empty tableform ? '</b></u>' : ''}</a> 
								отображено ${statcount} офисов, показывать
								<a href="monitoringmap1.jsp?verbose=all">${verbose == 'all' ? '<b><u>' : ''}все${verbose == 'all' ? '</u></b>' : ''}</a> 
								или только <a href="monitoringmap1.jsp?verbose=error">${verbose == 'error' ? '<b><u>' : ''}важную${verbose == 'error' ? '</u></b>' : ''}</a> информацию.
								
								<fmt:formatNumber value="${(statcount div getDepts.rowCount) * 100}" pattern="0" var="statmap"/>
								<div class="progress-bar secondary">
									<div class="bar" style="width: ${statmap}%;">${statmap}%</div>
								</div>

								<ul class="bullet secondary">
									<li><a href="monitoringmap1.jsp?viewdata=onlinepbx">${viewdata == 'onlinepbx' ? '<b>' : ''}Доступность офисов${viewdata == 'onlinepbx' ? '</b>' : ''}</a></li>
									<li><a href="monitoringmap1.jsp?viewdata=connectedphones">${viewdata == 'connectedphones' ? '<b>' : ''}Установленные телефоны${viewdata == 'connectedphones' ? '</b>' : ''}</a></li>
									<li><a href="monitoringmap1.jsp?viewdata=hwstatus">${viewdata == 'hwstatus' ? '<b>' : ''}Состояние серверов${viewdata == 'hwstatus' ? '</b>' : ''}</a></li>
									<li><a href="monitoringmap1.jsp?viewdata=trstatus">${viewdata == 'trstatus' ? '<b>' : ''}Пиры и транки${viewdata == 'trstatus' ? '</b> (<a href="monitoringmap1.jsp?viewfilter=trunksonly">только транки</a>)' : ''}</a></li>
								</ul>
								<a href="monitoringmap1.jsp?fullscreen=yes" class="btn btn-primary btn-large dashboard_add">На весь экран</a>
								<!--<a href="importext.jsp" class="btn btn-tertiary btn-large dashboard_add">Показать все</a>-->
							<br/><h3>Выбрать офис</h3>
								<a class="icon-pin" href="Javascript:;" id="filter_pin"></a><input id="filter_branch" placeholder="фильтр..." size="18"><em id="filter_results"></em><p>
							<div class="controls">	
								<ul id="list_branch">
									${filterdeptlist}
								</ul>
							</div></p>
							</div>
				</div> <!-- .grid -->
			</c:if>
		</div> <!-- .container -->
		
	</div> <!-- #content -->

	<c:set var="pagescript">${pagescript}
	<c:if test="${empty tableform}">
		<script src="javascripts/craftmap.js" type="text/javascript"></script>
		<script src="javascripts/mapinit.js" type="text/javascript"></script>
	</c:if>
		<c:if test="${statcount == '0'}"><script>
		jQuery(document).ready(function(){
			$.alertinf ({ 
					type: 'confirm'
					, title: 'Сообщение'
					, text: '<p>Хьюстон, у нас проблемы. <br/>Нет данных для отображения на карте!</p>'
					, callback: function () { //foo
						 }	
				});});
		</script></c:if>
	</c:set>
	
<c:if test="${empty param.fullscreen}"><%@ include file='h_quicknav.jsp'%></c:if>
