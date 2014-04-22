<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<script src="javascripts/raphael.2.1.0.min.js"></script>
<script src="javascripts/justgage.1.0.1.min.js"></script>
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

<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.id}" var="chkid1"/>
<c:if test="${chkid1 == 'true'}">	
	<c:set var="okpi" value="10"/>
	<sql:query dataSource="${databas}" var="branch">
	select * from branchesorg_${G_org}_${G_ver} where id=?
		<sql:param value="${param.id}"/>
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
		<sql:query dataSource="${databas}" var="getWanOldest">
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
	
	
	
	
<c:if test="${param.show == 'tab-1'}">
	<div class="grid-15">
			<div class="department">
						<div class="user-cardtrue">
							
							<div class="avatar">
								<c:choose>
									<c:when test="${bupdtime < 119}"><c:set var="avat" value="maint"/></c:when>
									<c:when test="${! empty btime}">
										<isoft:timediff time="${btime}" var="hc"/>
										<c:set var="avat" value="cloudblue"/>
											<c:if test="${hc > 240}"><c:set var="avat" value="warning"/></c:if>
									</c:when>
									<c:otherwise><c:set var="avat" value="cloudgrey"/></c:otherwise>
								</c:choose>
								<img src="images/${avat}.png" title="User" alt="branch status">
								<!--
								<br/><br/><br/>
								<img src="images/stream/help1.png" title="User" alt="">-->

							</div> <!-- .user-card-avatar -->
							<div class="details">
								<p>
									Область: ${bcity}<br/>
									Адрес: ${baddr}<br/>
									<c:if test="${! empty btime}">
									<isoft:friendlytime time="${btime}" var="hc"/> с IP адресом ${blastip} &nbsp;</c:if>
									<a href="#" onclick="pingpbx('${bid}')">ping</a><br/>

									<br/>
									<br/>
									Контакт: ${btechperson} <br/>
									Тел. поддержки: ${btechtel}<br/>
									<a href="#" onclick="editbranch('${bid}')" class="btn btn-small">редактировать</a>
									<a href="#" onclick="updbranch('${bid}')" class="btn btn-small">обновление (${empty bupdtime ? '120' : bupdtime} m)</a>

							</div> <!-- .user-card-content -->
						</div> <!-- .user-card -->
			</div> <!-- .department -->
	</div>
	<div class="grid-9">
	<center>
		<c:choose>
			<c:when test="${hc <= 240}">
				${actionerror2}<div id="g0"></div>
			</c:when>
			<c:when test="${empty bhwstatus}">
				<div id="gq">!<br/><br/><br/><h6>сервер в коробке.</h6></div>
			</c:when>
			<c:otherwise>
				<div id="gq">?<br/><br/><br/><h6>сервер не доступен более <fmt:formatNumber value="${hc div 60}" pattern="0"/>  часов.</h6></div>
			</c:otherwise>
		</c:choose>
	</center></div>
	
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

</c:if>

<c:if test="${param.show == 'tab-2'}">
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
		<h5><c:if test="${! empty btime}">
		Последний раз получали данные <isoft:friendlytime time="${btime}" var="hc"/> с IP адресом ${blastip}</c:if></h5>

			<sql:query dataSource="${databas}" var="getPerf">
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
			</table>
			<div class="box">На графике отображены данные за последние 3 дня.
				Сервер активирован ${getWanOldest.rows[0].daypast} дней назад. 
				<c:if test="${! empty puptime}">Сервер не выключался более ${puptime} дней.</c:if>
				</div>
			</center>
	</c:when>
	<c:otherwise>Нет данных, сервер в коробке!</c:otherwise></c:choose>

</c:if>

<c:if test="${param.show == 'tab-3'}">
	<h5><c:if test="${! empty btime}">
	Последний раз получали данные <isoft:friendlytime time="${btime}" var="hc"/> с IP адресом ${blastip}</c:if></h5>
	<c:if test="${fn:contains(bhwstatus,'PEER')}">
		<c:set var="dayInterval" value="${getWanOldest.rows[0].daypast}"/>
		<c:if test="${dayInterval > 30}"><c:set var="dayInterval" value="30"/></c:if>
		<sql:query dataSource="${databas}" var="getWanStat">
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
		          title: "Транки ${SIPREGISTRY} из ${SIPTRUNKS}",
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
			<sql:query dataSource="${databas}" var="getPerf">
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
		<div class="box">На графике отображены данные за последние 3 дня.
			Сервер активирован <strong>${getWanOldest.rows[0].daypast}</strong> дней назад. 
			<c:if test="${! empty puptime}">Сервер не выключался более <strong>${puptime}</strong> дней.</c:if>
		</div>
			<sql:query dataSource="${databas}" var="getRep1">
			select sum(billsec) as bill,count(start) as tot from cdr_${G_org}_b${param.id} where start <> ''
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
	</c:if>
	<c:if test="${! fn:contains(bhwstatus,'PEER')}">
	нет данных!
	</c:if>
</c:if>

<c:if test="${param.show == 'tab-4'}">
tab4
</c:if>


</c:if><!--	ending c:if-->