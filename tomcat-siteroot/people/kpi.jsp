<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>

<c:if test="${! empty G_bookmanager}">

<sql:query dataSource="${databasp}" var="getCityCode">
	select dialplan2 from branchesorg_${G_org}_${G_ver} where id = ?
 <sql:param value="${G_bookmanager}"/>
</sql:query>
<sql:query dataSource="${databasp}" var="getExt">
	select id,extension,name,secondname from extensionsorg_${G_org}_${G_ver} where branchid=?
 <sql:param value="${G_bookmanager}"/>
</sql:query>

<c:set var="pageheader"> 
<script src="javascripts/raphael.2.1.0.min.js"></script>
<script src="javascripts/justgage.1.0.1.min.js"></script>
<script src="javascripts/jquery.peity.min.js"></script>
<style>
#g0 {
  width:220px; height:180px;
  display: inline-block;
  margin: 1em;
}

#gq {
  margin: 1em;
  font-size:90px;
  color:#9d9d9d;
  width:100px;
  font-weight:bold;
}

#gq h6{
	font-size:12px;
	color:#000000;
}

#g1, #g2, #g3, #g4, #g5, #g6 {
  width:180px; height:90px;
  display: inline-block;
  margin: 0em;
}

#g7 {
  width:220px; height:120px;
  display: inline-block;
  margin: 1em;
}

</style>
</c:set>
<c:set var="pagescript">

</c:set>

<%@ include file='h_menu.jsp'%>
	
	<div id="content">
		<div id="contentHeader">
			<h1>Статистика
				</h1>
		</div> <!-- #contentHeader -->
		<div class="container">			
			<div class="grid-24">





				<isoft:regexp pat="^[0-9]{1,10}+$" value="${G_bookmanager}" var="chkid1"/>
				<c:if test="${chkid1 == 'true'}">	
					<c:set var="okpi" value="10"/>
					<sql:query dataSource="${databasp}" var="branch">
					select * from branchesorg_${G_org}_${G_ver} where id=?
						<sql:param value="${G_bookmanager}"/>
					</sql:query>
						<c:set var="bid" value="${branch.rows[0].id}"/>
						<c:set var="bname" value="${branch.rows[0].name}"/>
						<c:set var="bcity" value="${branch.rows[0].city}"/>
						<c:set var="baddr" value="${branch.rows[0].addr}"/>
						<c:set var="bhwstatus" value="${branch.rows[0].hwstatus}"/>
						<c:set var="btechperson" value="${branch.rows[0].techperson}"/>
						<c:set var="btechtel" value="${branch.rows[0].techtel}"/>
						<c:set var="bupdtime" value="${branch.rows[0].updinterval}"/>
						<c:set var="btime" value="${branch.rows[0].lasttime}"/>
						<c:set var="blastip" value="${branch.rows[0].lastip}"/>
						<c:if test="${! empty bhwstatus}">
						<sql:query dataSource="${databasp}" var="getWanOldest">
						select TIMESTAMPDIFF(DAY,logtime,TIMESTAMP(NOW())) AS daypast,logtime from logs where org=? and username=? and message like 'FRAM:%' order by logtime LIMIT 1
							<sql:param value="${G_org}"/><sql:param value="pbx${bid}"/>
						</sql:query>
						<c:set var="pram">${fn:substringAfter(bhwstatus,'FRAM:')}</c:set>
						<c:set var="pram">${fn:substringBefore(pram,'kb;')}</c:set>
						<c:set var="proot">${fn:substringAfter(bhwstatus,'FROOT:')}</c:set>
						<c:set var="proot">${fn:substringBefore(proot,'M;')}</c:set>	
						<c:set var="proot">${fn:substringBefore(proot,'.')}</c:set>
						<c:set var="pcpu">${fn:substringAfter(bhwstatus,'load average: ')}</c:set>
						<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>
						<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>	
						<c:set var="pcpu">${fn:substringBefore(pcpu,';')}</c:set>

						<c:set var="puptime">${fn:substringAfter(bhwstatus,'up ')}</c:set>
						<c:set var="puptime">${fn:substringBefore(puptime,' days')}</c:set>

						<c:if test="${empty pcpu}"><c:set var="pcpu" value="0"/></c:if>
							<fmt:formatNumber value="${pcpu * 100}" pattern="0" var="pcpuok"/>
							<c:if test="${pram < 500}"><c:set var="actionerror2">${actionerror2}<div class="notify notify-error"><a href="javascript:;" class="close">&times;</a>
							<strong>недостаточно памяти</strong></div></c:set><c:set var="okpi" value="${okpi-5}"/></c:if>
							<c:if test="${proot < 200}"><c:set var="actionerror2">${actionerror2}<div class="notify notify-error"><a href="javascript:;" class="close">&times;</a>
							<strong>нет места на диске</strong></div></c:set><c:set var="okpi" value="${okpi-5}"/></c:if>
							<c:if test="${pcpu > 0.7}"><c:set var="actionerror2">${actionerror2}<div class="notify notify-error"><a href="javascript:;" class="close">&times;</a>
							<strong>процессор перегружен</strong></div></c:set><c:set var="okpi" value="${okpi-5}"/></c:if>
						</c:if>

						<c:if test="${fn:contains(bhwstatus,'PEER')}">
							<c:set var="PEERSTOT">${fn:substringAfter(bhwstatus,'PEERSTOT:')}</c:set>
							<c:set var="PEERSTOT">${fn:substringBefore(PEERSTOT,';PEERSREG')}</c:set>
							<c:set var="PEERSREG">${fn:substringAfter(bhwstatus,'PEERSREG:')}</c:set>
							<c:set var="PEERSREG">${fn:substringBefore(PEERSREG,';SIPPINGLOSS')}</c:set>
							<c:set var="SIPPINGLOSS">${fn:substringAfter(bhwstatus,'SIPPINGLOSS:')}</c:set>
							<c:set var="SIPPINGLOSS">${fn:substringBefore(SIPPINGLOSS,';SIPTRUNKS')}</c:set>
							<c:set var="SIPTRUNKS">${fn:substringAfter(bhwstatus,'SIPTRUNKS:')}</c:set>
							<c:set var="SIPTRUNKS">${fn:substringBefore(SIPTRUNKS,';SIPREGISTRY')}</c:set>
							<c:set var="SIPREGISTRY">${fn:substringAfter(bhwstatus,'SIPREGISTRY:')}</c:set>
							<c:set var="SIPREGISTRY">${fn:substringBefore(SIPREGISTRY,';')}</c:set>
							
							<c:if test="${(SIPREGISTRY == '0') and (SIPTRUNKS == '0')}">
								<c:set var="SIPTRUNKS">1</c:set>
								<c:set var="SIPREGISTRY">1</c:set>
								<c:set var="KTELTRUNK">true</c:set>
							</c:if>
							
							<c:set var="SIPPINGQTY" value="${100 - SIPPINGLOSS}"/>
							<fmt:formatNumber value="${(PEERSREG div PEERSTOT) * 10}" pattern="0" var="PEERRATE"/>
							<c:if test="${SIPPINGLOSS > 90}">
								<c:set var="actionerror2">
								${actionerror2}<div class="notify notify-error"><a href="javascript:;" class="close">&times;</a>
								<strong>нет связи с SIP шлюзом</strong></div></c:set><c:set var="okpi" value="${okpi-5}"/>
							</c:if>
							<c:if test="${(SIPTRUNKS != SIPREGISTRY) and (SIPPINGLOSS < 90)}">
								<c:set var="actionerror2">${actionerror2}<div class="notify notify-error"><a href="javascript:;" class="close">&times;</a>
								<strong>нет SIP регистрации</strong></div></c:set><c:set var="okpi" value="${okpi-5}"/>
							</c:if>
							<c:if test="${SIPTRUNKS == '-1'}">
								<c:set var="actionerror2">${actionerror2}<div class="notify notify-error"><a href="javascript:;" class="close">&times;</a>
								<strong>остановлен Asterisk</strong></div></c:set><c:set var="okpi" value="${okpi-10}"/>
							</c:if>
							<c:if test="${PEERSREG == 0}">
								<c:set var="actionerror2">${actionerror2}<div class="notify notify-error"><a href="javascript:;" class="close">&times;</a>
									<strong>все аппараты оффлайн</strong></div></c:set>
							</c:if>
							<isoft:regexp pat="^[0-9]{1,10}+$" value="${PEERRATE}" var="chPER"/>
							<c:if test="${chPER != 'true'}"><c:set var="PEERRATE" value="0"/></c:if>
							<c:set var="okpi" value="${okpi-(10-PEERRATE)}"/>
						</c:if>

						<c:choose>
							<c:when test="${! empty bhwstatus}">
							</c:when>
							<c:otherwise><c:set var="actionerror2">${actionerror2}<div class="notify notify-info"><a href="javascript:;" class="close">&times;</a>
									<i>нет технических данных</i></div></c:set><c:set var="okpi" value="${okpi-1}"/>
							</c:otherwise>
						</c:choose>

						<c:if test="${! fn:contains(bhwstatus,'SIP')}">
						<c:set var="actionerror2">${actionerror2}<div class="notify notify-info"><a href="javascript:;" class="close">&times;</a>
							<i>нет данных внешних линий</i></div><c:set var="okpi" value="${okpi-1}"/></c:set>
						</c:if>




					<div class="grid-8">
						<div class="box">
									Область: ${bcity}<br/>
								Адрес: ${baddr}<br/>
								<c:if test="${! empty btime}">
								<isoft:friendlytime time="${btime}" var="hc"/> с IP адресом ${blastip} &nbsp;</c:if>

								<br/>
								Контакт: ${btechperson} <br/>
								Тел. поддержки: ${btechtel}
						</div>
					</div>
					<div class="grid-16">
						<div class="widget">
							<div class="widget-header">
								<span class="icon-cog-alt"></span>
								<h3>Общее состояние</h3>
							</div>
							<div class="widget-content">
								<center>
									<c:choose>
										<c:when test="${hc <= 240}">
											${actionerror2}<div id="g0"></div>
										</c:when>
										<c:when test="${empty bhwstatus}">
											<div id="gq">!<br/><br/><br/><h6>сервер в коробке.</h6></div>
										</c:when>
										<c:otherwise>
											<div id="gq">?<br/><br/><br/><h6>сервер не доступен более <fmt:formatNumber value="${hc div 60}" pattern="0"/> часов.</h6></div>
										</c:otherwise>
									</c:choose>
								</center>
							</div>
							</div>
					</div>

					<c:if test="${(! empty bhwstatus) and (hc <= 240)}">
					<script>
					$(document).ready( function(){ 
						var g0;
							var g0 = new JustGage({
					          id: "g0", 
					          value: ${okpi}, 
					          min: 0,
					          max: 10,
					          title: "состояние офиса",
					          label: "KPI",
					          levelColors: new Array("ff0321","70cf23")
					        });
					});
					</script>
					</c:if>
					<div class="widget">
						<div class="widget-header">
							<span class="icon-cog-alt"></span>
							<h3>Производительность</h3>
					</div>
					<div class="widget-content">
					<c:choose>
					<c:when test="${! empty bhwstatus}">
						<script>
						$(document).ready( function(){ 
							var g1,g2,g3;
								var g1 = new JustGage({
						          id: "g1", 
						          value: ${pcpuok}, 
						          min: 0,
						          max: 100,
						          title: "Загрузка CPU ${pcpuok}%",
						          label: "за 15 мин"
						        });

						        var g2 = new JustGage({
						          id: "g2", 
						          value: ${pram}, 
						          min: 0,
						          max: 1800,
						          title: "RAM ${pram}kb",
						          label: "kb",
								  levelColors: new Array("ff0321","70cf23")
						        });

						        var g3 = new JustGage({
						          id: "g3", 
						          value: ${512-proot}, 
						          min: 0,
						          max: 512,
						          title: "SDA ${proot}mb",
						          label: "mb"
						        });

								$("span.graph1").peity("line",{
								  colour: "#c6d9fd",
								  strokeColour: "#4d89f9",
								  strokeWidth: 2,
								  delimeter: ",",
								  height: 50,
								  max: null,
								  min: 0,
								  width: 150
								});
								$("span.graph2").peity("line",{
								  colour: "#c6d9fd",
								  strokeColour: "#4d89f9",
								  strokeWidth: 2,
								  delimeter: ",",
								  height: 50,
								  max: 1800,
								  min: 0,
								  width: 150
								});
								$("span.graph3").peity("line",{
								  colour: "#c6d9fd",
								  strokeColour: "#4d89f9",
								  strokeWidth: 2,
								  delimeter: ",",
								  height: 50,
								  max: 512,
								  min: 0,
								  width: 150
								});
						});
						</script>

							<sql:query dataSource="${databasp}" var="getPerf">
							select * from logs where org=? and username=? and message like 'FRAM:%'  order by logtime DESC LIMIT 36
								<sql:param value="${G_org}"/><sql:param value="pbx${bid}"/>
							</sql:query>
							<c:forEach items="${getPerf.rows}" var="po" varStatus="status">
								<c:set var="pram">${fn:substringAfter(po.message,'FRAM:')}</c:set>
								<c:set var="pram">${fn:substringBefore(pram,'kb;')}</c:set>
								<c:set var="proot">${fn:substringAfter(po.message,'FROOT:')}</c:set>
								<c:set var="proot">${fn:substringBefore(proot,'M;')}</c:set>	
								<c:set var="proot">${fn:substringBefore(proot,'.')}</c:set>
								<c:set var="pcpu">${fn:substringAfter(po.message,'load average: ')}</c:set>
								<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>
								<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>	
								<c:set var="pcpu">${fn:substringBefore(pcpu,';')}</c:set>

								<c:set var="rpram">${pram}${! status.first ? ',' : ''}${rpram}</c:set>
								<c:set var="rproot">${proot}${! status.first ? ',' : ''}${rproot}</c:set>
								<c:set var="rpcpu">${pcpu}${! status.first ? ',' : ''}${rpcpu}</c:set>
							</c:forEach>
							<center>
							<table>
								<tr>
									<td><div id="g1"></div></td>
									<td><div id="g2"></div></td>
									<td><div id="g3"></div></td>
								</tr>
								<tr>
									<td><span class="graph1" style="margin: 1em;">${rpcpu}</span></td>
									<td><span class="graph2" style="margin: 1em;">${rpram}</span></td>
									<td><span class="graph3" style="margin: 1em;">${rproot}</span></td>
								</tr>
							</table><br/>
							<div class="box">
							На графике отображены данные за последние 3 дня.
								Сервер активирован ${getWanOldest.rows[0].daypast} дней назад. 
								<c:if test="${! empty puptime}">Сервер не выключался более ${puptime} дней.</c:if>
							</div>
							</center>
					</c:when>
					<c:otherwise>Нет данных, сервер в коробке!</c:otherwise></c:choose>
					</div>
					</div>

					<c:if test="${fn:contains(bhwstatus,'PEER')}">
						<c:set var="dayInterval" value="${getWanOldest.rows[0].daypast}"/>
						<c:if test="${dayInterval > 30}"><c:set var="dayInterval" value="30"/></c:if>
						<sql:query dataSource="${databasp}" var="getWanStat">
						select id from logs where org=? and username=? and message like 'FRAM:%' and logtime >= TIMESTAMP(DATE_SUB(NOW(), INTERVAL ${dayInterval} day))
							<sql:param value="${G_org}"/><sql:param value="pbx${bid}"/>
						</sql:query>
						<fmt:formatNumber value="${((getWanStat.rowCount div 2) div (dayInterval*12)) * 100}" pattern="0" var="wanstat"/>
						<script>
						$(document).ready( function(){
							var g4,g5,g6,g7;
							var g4 = new JustGage({
						          id: "g4", 
						          value: ${PEERSREG}, 
						          min: 0,
						          max: ${PEERSTOT},
						          title: "Пиры ${PEERSREG} из ${PEERSTOT}",
						          label: "asterisk",
								levelColors: new Array("ff0321","70cf23")
						        });
							 var g5 = new JustGage({
						          id: "g5", 
						          value: ${SIPREGISTRY}, 
						          min: 0,
						          max: ${SIPTRUNKS},
						          title: "Транки ${SIPREGISTRY} из ${SIPTRUNKS} ${KTELTRUNK == 'true' ? '(vpn транк)' : ''}",
						          label: "asterisk",
									levelColors: new Array("ff0321","70cf23")
						        });
							 var g6 = new JustGage({
						          id: "g6", 
						          value: ${100-SIPPINGLOSS}, 
						          min: 0,
						          max: 100,
						          title: "Качество SIP канала ${100-SIPPINGLOSS}%",
						          label: "ping",
							      	levelColors: new Array("ff0321","70cf23"),

						        });			
							 var g7 = new JustGage({
						          id: "g7", 
							        value: ${wanstat}, 
							        min: 0,
							        max: 100,
							        title: "Качество тех канала ${wanstat}%",
							        label: "каждые 2часа",
								    levelColors: new Array("ff0321","70cf23"),
						        });
								$("span.graph4").peity("line",{
								  colour: "#c6d9fd",
								  strokeColour: "#4d89f9",
								  strokeWidth: 2,
								  delimeter: ",",
								  height: 50,
								  max: ${PEERSTOT},
								  min: 0,
								  width: 150
								});
								$("span.graph5").peity("line",{
								  colour: "#c6d9fd",
								  strokeColour: "#4d89f9",
								  strokeWidth: 2,
								  delimeter: ",",
								  height: 50,
								  max: ${SIPTRUNKS},
								  min: 0,
								  width: 150
								});
								$("span.graph6").peity("line",{
								  colour: "#c6d9fd",
								  strokeColour: "#4d89f9",
								  strokeWidth: 2,
								  delimeter: ",",
								  height: 50,
								  max: 100,
								  min: 0,
								  width: 150
								});

								$("span.graph7").peity("line",{
								  colour: "#c6d9fd",
								  strokeColour: "#4d89f9",
								  strokeWidth: 2,
								  delimeter: ",",
								  height: 50,
								  max: null,
								  min: 0,
								  width: 250
								});
								$("span.graph8").peity("line",{
								  colour: "#c6d9fd",
								  strokeColour: "#4d89f9",
								  strokeWidth: 2,
								  delimeter: ",",
								  height: 50,
								  max: null,
								  min: 0,
								  width: 150
								});
						});
						</script>
							<sql:query dataSource="${databasp}" var="getPerf">
							select * from logs where org=? and username=? and message like '%PEER%'  order by logtime DESC LIMIT 36
								<sql:param value="${G_org}"/><sql:param value="pbx${bid}"/>
							</sql:query>
							<c:forEach items="${getPerf.rows}" var="po" varStatus="status">
								<c:set var="PEERSREG">${fn:substringAfter(po.message,'PEERSREG:')}</c:set>
								<c:set var="PEERSREG">${fn:substringBefore(PEERSREG,';SIPPINGLOSS')}</c:set>
								<c:set var="SIPPINGLOSS">${fn:substringAfter(po.message,'SIPPINGLOSS:')}</c:set>
								<c:set var="SIPPINGLOSS">${fn:substringBefore(SIPPINGLOSS,';SIPTRUNKS')}</c:set>
								<c:set var="SIPREGISTRY">${fn:substringAfter(po.message,'SIPREGISTRY:')}</c:set>
								<c:set var="SIPREGISTRY">${fn:substringBefore(SIPREGISTRY,';')}</c:set>

								<c:set var="rpeer">${PEERSREG}${! status.first ? ',' : ''}${rpeer}</c:set>
								<c:set var="rloss">${100-SIPPINGLOSS}${! status.first ? ',' : ''}${rloss}</c:set>
								<c:set var="rregs">${SIPREGISTRY}${! status.first ? ',' : ''}${rregs}</c:set>
							</c:forEach>
							<div class="widget">
								<div class="widget-header">
									<span class="icon-cog-alt"></span>
									<h3>Внешние линии</h3>
							</div>
							<div class="widget-content">
								<center>
								<table>
									<tr>
										<td><div id="g4"></div></td>
										<td><div id="g5"></div></td>
										<td><div id="g6"></div></td>
									</tr>
									<tr>
										<td><span class="graph4" style="margin: 1em;">${rpeer}</span></td>
										<td><span class="graph5" style="margin: 1em;">${rregs}</span></td>
										<td><span class="graph6" style="margin: 1em;">${rloss}</span></td>
									</tr>	
								</table>
								<br/>
								<div class="box">На графике отображены данные за последние 3 дня.
									Сервер активирован <strong>${getWanOldest.rows[0].daypast}</strong> дней назад. 
									<c:if test="${! empty puptime}">Сервер не выключался более <strong>${puptime}</strong> дней.</c:if>
								</div>
							</center></div></div>
							
							<sql:query dataSource="${databasp}" var="getRep1">
							select sum(billsec) as bill,count(start) as tot from cdr_${G_org}_b${G_bookmanager} where start <> ''
							and length(dst) > 4 and disposition = 'ANSWERED' and
							start BETWEEN CURDATE() - INTERVAL 10 DAY AND CURDATE()			
							group by DAY(start)
							order by DAY(start) ASC
							</sql:query>
							<c:forEach items="${getRep1.rows}" var="po" varStatus="status">
							<c:set var="daycalls">${po.tot}${! status.first ? ',' : ''}${daycalls}</c:set>
							<c:set var="totcolls" value="${totcolls+po.tot}"/>
							<c:set var="totsecs" value="${totsecs+po.bill}"/>
							</c:forEach>
							
							<div class="widget">
								<div class="widget-header">
									<span class="icon-cog-alt"></span>
									<h3>Синхронизация и звонки</h3>
							</div>
							<div class="widget-content">
								<center>
								<table>
									<tr valign="top">
										<td><div id="g7"></div></td>
										<td></td>
										<td><center><span class="graph7" style="margin: 1em;">${daycalls}</span></center></td>
									</tr>
									<tr>
										<td><div class="box">Качество технического канала за 30 дней. </div></td>
										<td>&nbsp;&nbsp;&nbsp;</td>
										<td><div class="box">Статистика звонков за 10 дней, 
											в направлении города и между филиалами было сделано <b>${totcolls}</b> удачных звонков на <b>${totsecs div 60}</b> минут. 
											</div></td>
									</tr>
								</table>	
								</center>
							</div></div>
					</c:if>
					<c:if test="${! fn:contains(bhwstatus,'PEER')}">
					нет данных!
					</c:if>
				</c:if>





			
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->
</c:if>

<%@ include file='foot.jsp'%>