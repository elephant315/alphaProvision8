<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>
<%@ include file='h_menu.jsp'%>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.branch}" var="chkbranch1"/>
<isoft:regexp pat="^[0-9A-Za-zА-Яа-я ,.:]{1,40}+$" value="${param.search}" var="chksrch1"/>

<c:choose>
	<c:when test="${chkbranch1 == 'true'}">
		<sql:query dataSource="${databasp}" var="branch">
		select * from branchesorg_${G_org}_${G_ver} where id=?
			<sql:param value="${param.branch}"/>
		</sql:query>
			<c:set var="bid" value="${branch.rows[0].id}"/>
			<c:set var="bname" value="${branch.rows[0].name}"/>
			<c:set var="bcity" value="${branch.rows[0].city}"/>
			<c:set var="baddr" value="${branch.rows[0].addr}"/>
			<c:set var="btechperson" value="${branch.rows[0].techperson}"/>
			<c:set var="btechtel" value="${branch.rows[0].techtel}"/>
			<c:set var="btime" value="${branch.rows[0].lasttime}"/>
			<c:set var="blastip" value="${branch.rows[0].lastip}"/>
			<c:set var="bdialplan2" value="${branch.rows[0].dialplan2}"/>
			<c:set var="bhwstatus" value="${branch.rows[0].hwstatus}"/>
		<sql:query dataSource="${databasp}" var="getPhones">
			select extensionsorg_${G_org}_${G_ver}.name AS ename, 
				   extensionsorg_${G_org}_${G_ver}.secondname,
				   extensionsorg_${G_org}_${G_ver}.extension,
				   extensionsorg_${G_org}_${G_ver}.cabin,
				   extensionsorg_${G_org}_${G_ver}.id,
				   extensionsorg_${G_org}_${G_ver}.groups,
				   branchesorg_${G_org}_${G_ver}.name AS bname, 
				   branchesorg_${G_org}_${G_ver}.addr, 
				   branchesorg_${G_org}_${G_ver}.city
				
			 from extensionsorg_${G_org}_${G_ver},branchesorg_${G_org}_${G_ver} where 
			
					extensionsorg_${G_org}_${G_ver}.branchid = branchesorg_${G_org}_${G_ver}.id and
					extensionsorg_${G_org}_${G_ver}.branchid = ?
					
					order by extensionsorg_${G_org}_${G_ver}.cabin,extensionsorg_${G_org}_${G_ver}.name
		 <sql:param value="${param.branch}"/>
		</sql:query>
	</c:when>
	
	<c:when test="${chksrch1 == 'true'}">
		<sql:query dataSource="${databasp}" var="getPhones">
			select extensionsorg_${G_org}_${G_ver}.name AS ename, 
				   extensionsorg_${G_org}_${G_ver}.secondname,
				   extensionsorg_${G_org}_${G_ver}.extension,
				   extensionsorg_${G_org}_${G_ver}.cabin,
				   extensionsorg_${G_org}_${G_ver}.id,
				   extensionsorg_${G_org}_${G_ver}.groups,
				   branchesorg_${G_org}_${G_ver}.name AS bname, 
				   branchesorg_${G_org}_${G_ver}.addr, 
				   branchesorg_${G_org}_${G_ver}.city
				
			 from extensionsorg_${G_org}_${G_ver},branchesorg_${G_org}_${G_ver} where 
			
					extensionsorg_${G_org}_${G_ver}.branchid = branchesorg_${G_org}_${G_ver}.id and
						(extensionsorg_${G_org}_${G_ver}.name like '%${param.search}%' or 
						extensionsorg_${G_org}_${G_ver}.secondname like '%${param.search}%' or
						extensionsorg_${G_org}_${G_ver}.extension like '%${param.search}%') 
						order by extensionsorg_${G_org}_${G_ver}.cabin,extensionsorg_${G_org}_${G_ver}.name
		</sql:query>
	</c:when>
	
	<c:otherwise>
		<c:catch>
			<c:set var="browserip" value="<%= request.getRemoteAddr() %>"/>
			<c:set var="browserip" value="${fn:split(browserip, '.')}"/>
			<c:set var="browserip" value="${browserip[0]}.${browserip[1]}.${browserip[2]}"/>
			<sql:query dataSource="${databasp}" var="getDept">
			select * from branchesorg_${G_org}_${G_ver} where lastip like '${browserip}%' LIMIT 1
			</sql:query>
			<c:set var="showinfo" value="a"/>
		</c:catch>
			<c:if test="${getDept.rowCount > 0}"><c:set var="fakeparambranch">${getDept.rows[0].id}</c:set></c:if>
			<c:if test="${getDept.rowCount < 1}">
			<sql:query dataSource="${databasp}" var="getDept">
			select * from branchesorg_${G_org}_${G_ver} where name like '%Главный%' or name like '%Центральный%' or name like '%Головной%' LIMIT 1
			</sql:query>
			<c:set var="showinfo" value="a"/>
			</c:if>
			<c:set var="bid" value="${getDept.rows[0].id}"/>
			<c:set var="bname" value="${getDept.rows[0].name}"/>
			<c:set var="bcity" value="${getDept.rows[0].city}"/>
			<c:set var="baddr" value="${getDept.rows[0].addr}"/>
			<c:set var="btechperson" value="${getDept.rows[0].techperson}"/>
			<c:set var="btechtel" value="${getDept.rows[0].techtel}"/>
		<sql:query dataSource="${databasp}" var="getPhones">
			select extensionsorg_${G_org}_${G_ver}.name AS ename, 
				   extensionsorg_${G_org}_${G_ver}.secondname,
				   extensionsorg_${G_org}_${G_ver}.extension,
				   extensionsorg_${G_org}_${G_ver}.cabin,
				   extensionsorg_${G_org}_${G_ver}.id,
				   extensionsorg_${G_org}_${G_ver}.groups,
				   branchesorg_${G_org}_${G_ver}.name AS bname, 
				   branchesorg_${G_org}_${G_ver}.addr, 
				   branchesorg_${G_org}_${G_ver}.city
				
			 from extensionsorg_${G_org}_${G_ver},branchesorg_${G_org}_${G_ver} where 
			
					extensionsorg_${G_org}_${G_ver}.branchid = branchesorg_${G_org}_${G_ver}.id and
					branchid = ?
					
					order by extensionsorg_${G_org}_${G_ver}.cabin,extensionsorg_${G_org}_${G_ver}.name
		 <sql:param value="${getDept.rows[0].id}"/>
		</sql:query>
	</c:otherwise>
</c:choose>

<div id="content">

	<div id="contentHeader">
		<c:if test="${! empty param.search}"><h1>Поиск: ${param.search}</h1>
		</c:if>
		<c:if test="${chkbranch1 == 'true'}">
		<h1>${bname}</h1>
		</c:if>
		<c:if test="${(chkbranch1 == 'false') and (empty param.search) and  (fn:length(getPhones.rows[0].bname) gt 0)}">
		<h1>${getPhones.rows[0].bname}</h1>
		</c:if>
	</div> <!-- #contentHeader -->	

	<div class="container">
		<c:if test="${(! empty param.search) and (fn:contains(param.search,'mac:') == false)}">
		<div class="grid-24">			
				<div class="widget widget-plain">
					<div class="widget-header">
					<span class="icon-layers"></span>
					<h3>поиск</h3>
					</div>

					<div class="widget-content">
						<p>Поиск осуществляется по имени и фамилии, а также внутреннему номеру.</p>
						<label for="searchb"> </label>
						<form method="post" action="index.jsp">
							<input id="searchb" value="${param.search}" name="search"/>
							<button class="btn btn-primary" id="gosearch">искать</button>
						</form>
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
		</div></c:if>
		<div class="grid-${! empty G_bookmanager ? '12' : '24'}">
			<div class="widget"><div class="widget-header">
				<span class="icon-info"></span>
				<h3>Общая информация</h3>
			</div><div class="widget-content">
				<c:if test="${(chkbranch1 == 'true') or (showinfo =='a')}">
				Область: ${bcity}<br/>
				Адрес: ${baddr}<br/>
				Тех. поддержка: ${btechperson} (${btechtel})<br/>				
				<c:if test="${! empty bdialplan2}"><a href="#" class="show_hide"><h5>городские телефоны</h5></a></c:if>
				
				
				
				<c:if test="${(G_bookmanager == param.branch) and (! empty G_bookmanager)}">
					<a href="editbranch.jsp?branch=${param.branch}" class="btn btn-primary">Детальная информация</a> 
					<a href="printcodes.jsp" class="btn btn-tertiary">Коды активации</a>
					<a href="dialplanedit2.jsp" class="btn btn-tertiary">Диалплан</a>
				</c:if>
				</c:if>
			</div>
		</div></div>
		<c:if test="${! empty G_bookmanager}"><div class="grid-12">
			<div class="widget">
				<div class="widget-header">
					<span class="icon-cog-alt"></span>
					<h3>Статус АТС</h3>
				</div>
				<div class="widget-content">
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
					
					<fmt:formatNumber value="${(PEERSREG div PEERSTOT) * 100}" pattern="0" var="PEERRATE"/>
					<isoft:regexp pat="^[0-9]{1,10}+$" value="${PEERRATE}" var="chPER"/>
					<c:if test="${chPER != 'true'}"><c:set var="PEERRATE" value="0"/></c:if>
					<c:if test="${SIPPINGLOSS > 90}">
					<strong><font color="red">Внимание, не доступен Казахтелеком. </br> Проблема с каналом или нет связи с маршрутизатором</font></strong><br/><br/>
					</c:if>
					<c:if test="${(SIPTRUNKS != SIPREGISTRY) and (SIPPINGLOSS < 90)}">
					<strong><font color="red">Внимание, нет связи Казахтелеком, нет регистрации внешних линий SIP</font></strong><br/><br/>
					</c:if>
					<c:if test="${SIPTRUNKS == '-1'}">
					<strong><font color="red">Внимание, остановлен голосовой сервер: перезагрузите АТС</font></strong><br/><br/>
					</c:if>
					<c:if test="${PEERSREG == 0}">
					<strong><font color="red">Внимание, все телефоны оффлайн: проверьте локальную сеть</font></strong><br/><br/>
					</c:if>
					
					<span class="ticket ${PEERSREG == 0 ? 'ticket-important' : ''} ${(PEERRATE < 50) and (PEERSREG != 0) ? 'ticket-warning' : ''} ${(PEERRATE > 80) ? 'ticket-success' : ''}">телефоны ${PEERSREG} из ${PEERSTOT}</span>&nbsp;
					<span class="ticket ${SIPTRUNKS != SIPREGISTRY ? 'ticket-important' : ''} ${SIPTRUNKS == SIPREGISTRY ? 'ticket-success' : ''}" > 
						<c:choose><c:when test="${(SIPREGISTRY == '0') and (SIPREGISTRY == SIPTRUNKS)}"> VPN-SIP</c:when>
						<c:otherwise>iDphone линии ${SIPREGISTRY} из ${SIPTRUNKS}</c:otherwise></c:choose>
						</span>&nbsp;
					<span class="ticket ${SIPPINGLOSS > 90 ? 'ticket-important' : ''} ${(SIPPINGLOSS > 0) and (SIPPINGLOSS <= 90) ? 'ticket-warning' : ''} ${SIPPINGQTY > 90 ? 'ticket-success' : ''}">Казахтелеком ${SIPPINGQTY}%</span>&nbsp;
			
				</c:if>
				<c:if test="${! fn:contains(bhwstatus,'SIP')}">
				<i>нет данных внешних линий</i><br/>
				</c:if>
				
				<c:choose>
					<c:when test="${! empty bhwstatus}">
					<c:set var="pram">${fn:substringAfter(bhwstatus,'FRAM:')}</c:set>
					<c:set var="pram">${fn:substringBefore(pram,'kb;')}</c:set>
					<c:set var="proot">${fn:substringAfter(bhwstatus,'FROOT:')}</c:set>
					<c:set var="proot">${fn:substringBefore(proot,'M;')}</c:set>	
					<c:set var="proot">${fn:substringBefore(proot,'.')}</c:set>
					<c:set var="pcpu">${fn:substringAfter(bhwstatus,'load average: ')}</c:set>
					<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>
					<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>	
					<c:set var="pcpu">${fn:substringBefore(pcpu,';')}</c:set>
					<c:if test="${empty pcpu}"><c:set var="pcpu" value="0"/></c:if>
							<br/>
							<span class="ticket ${pram > 500 ? '' : 'ticket-important'}">RAM = ${pram}</span>&nbsp;
							<span class="ticket ${proot > 200 ? '' : 'ticket-important'}">SDA = ${proot} </span>&nbsp;
							<span class="ticket ${pcpu < 0.7 ? '' : 'ticket-important'}">CPU = <fmt:formatNumber value="${pcpu * 100}" pattern="0" var="pcpuok"/> ${pcpuok}%&nbsp;за 15 мин</span>&nbsp;
						</c:when>
						<c:otherwise><i>нет тех. данных</i></c:otherwise>
				</c:choose> 
				<br/><br/><c:if test="${! empty btime}">Данные обновлены <isoft:friendlytime time="${btime}" var="hc"/>  с IP адресом ${blastip} <a href="#" onclick="pingpbx(${bid})">ping</a>
				<c:if test="${param.branch == G_bookmanager}"><br/>Открыть <a href="kpi.jsp">статистику</a></c:if>
				</c:if>
				<c:if test="${empty btime}"><b>Сервер к коробке</b></c:if>
			</div></div>
		</div></c:if>
		<div class="grid-24">	
			<c:if test="${! empty bdialplan2}">
			<div class="slidingDiv">
			
				<c:set var="bdialplan2">${fn:substringAfter(bdialplan2, ";LocalTrunk")}</c:set>
				<c:set var="bdialplan2">${fn:substringBefore(bdialplan2, "exten => h,1,Hangup()")}</c:set>
					<div class="box plain">
						<table class="table table-striped table-bordered">
						<thead>
							<tr>
								<th>#</th>
								<th>городской номер телефона</th>
								<th>внутренний номер телефона</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${fn:split(bdialplan2, 'exten')}" var="bcitynum" varStatus="status">
							<c:set var="blocnum">${fn:substringAfter(bcitynum, "Dial(SIP/")}</c:set>
							<c:set var="blocnum">${fn:substringBefore(blocnum, ",")}</c:set>
							<c:set var="blocnum">${fn:replace(blocnum, "&SIP/", ",")}</c:set>

							<c:set var="bcitynum">${fn:substringAfter(bcitynum, "=> ")}</c:set>
							<c:set var="bcitynum">${fn:substringBefore(bcitynum, ",1,Dial")}</c:set>
							
							<c:set var="tscount" value="${tscount+1}"/>
							<c:if test="${(! empty bcitynum) or (! empty blocnum)}">
							<c:if test="${empty bcitynum}"><c:set var="bcitynum">&nbsp;&nbsp;&nbsp;---></c:set></c:if>
							<tr class="odd gradeX">
								<td>${tscount}</td>
								<td>${bcitynum}</td>
								<td>${blocnum}</td>
							</tr>
							</c:if>
							</c:forEach>
							</tbody>
						</table>
					</div></div>
			</c:if>
<!--
			<div class="box box-plain">
				<sql:query dataSource="${databasp}" var="getldep">
				select * from branchesorg_${G_org}_${G_ver} group by city
				</sql:query>
				<c:forEach items="${getldep.rows}" var="getlde">
				   <a href="organization.jsp?city=${getlde.city}">${getlde.city}</a> &nbsp;
				</c:forEach>
			</div>-->

<c:choose>
	<c:when test="${(chksrch1 == 'true') and (fn:contains(param.search,'mac:') == true)}">
			<div class="widget widget-plain">
				<div class="widget-header">
				<span class="icon-layers"></span>
				<h3>поиск</h3>
				</div>
				
				<div class="widget-content">
					<p>Поиск осуществляется по mac, IP, серийному #, номерам преднастройки (A-1234567).</p>
					<label for="searchb"> </label>
					<form method="post" action="index.jsp">
						<input id="searchb" value="${param.search}" name="search"/>
						<button class="btn btn-primary" id="gosearch">искать</button>
					</form>
				</div> <!-- .widget-content -->
			</div> <!-- .widget -->
		<c:set var="macsrch" value="${fn:substringAfter(param.search,'mac:')}"/>
		<sql:query dataSource="${databasp}" var="ds">
			select * from devices where shiporder = ? and 
			(macaddr like '%${macsrch}%' or provisionextension like '%${macsrch}%' or lastip like '%${macsrch}%'  or serial like '%${macsrch}%')
			<sql:param value="${G_org}" />
		</sql:query>
				<c:choose>
					<c:when test="${ds.rowCount > 0}">
					<h2> Результаты, найдено в устройствах: ${ds.rowCount}</h2>
						<div class="widget widget-table">
							<div class="widget-header">
								<span class="icon-list"></span>
								<h3 class="icon aperture">Найдено</h3>
							</div> <!-- .widget-header -->
							<%@ include file='devicelist.jsp'%>
						</div>
					</c:when>
					<c:otherwise>

					</c:otherwise>
				</c:choose>
	</c:when>
	<c:when test="${(getPhones.rowCount < 2) or (! empty param.search)}">
		<table class="table table-striped">

			<thead>
				<tr>
					<th>Номер телефона</th>
					<th>Имя и Фамилия</th>
					<th>Адрес</th>
				</tr>
			</thead>	

			<tbody>
				<c:forEach var="gc" items="${getPhones.rows}" varStatus="status">
				<tr>
					<td><h3>${gc.extension}</h3></td>
					<td>${gc.ename} ${gc.secondname}</td>
					<td>${gc.bname} <br/>  <i>${gc.addr} ${gc.city} </i></td>
				</tr>
				<c:set var="tot">${status.count}</c:set>
				</c:forEach>
				<c:if test="${getPhones.rowCount == 0}">
					<tr>
						<td colspan="3"><span class="ticket ticket-warning">Ничего не найдено</span></td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</c:when>
	<c:otherwise>
		<div class="widget-content">
			<c:forEach var="gc" items="${getPhones.rows}" varStatus="status">
				<c:if test="${empty gc.cabin}"><c:set var="ccabid" value="1"/></c:if>
				<c:if test="${!empty gc.cabin}"><c:set var="ccabid" value="${gc.cabin}"/></c:if>
				<c:if test="${cabid != ccabid}">	
					${not status.first ? '</div>' : ''}
					<div class="department">
					<h2><c:if test="${! empty gc.cabin}">
						${gc.groups} (callgroup #${gc.cabin})
						<c:if test="${(G_bookmanager == param.branch) and (! empty G_bookmanager)}">
							<a href="edit.jsp?action=editgroup&branch=${param.branch}&group=${gc.cabin}">
								<font size="1">переименовать</font></a>
						</c:if></c:if>
					</h2> 
				</c:if>
							<div class="user-card">
								<div class="avatar">
										<sql:query dataSource="${databasp}" var="activ">
										select * from activation where extid=? 
											<sql:param value="${gc.id}"/>
										</sql:query>	
										<sql:query dataSource="${databasp}" var="device">
										select * from devices where id=? 
											<sql:param value="${activ.rows[0].deviceid}"/>
										</sql:query>
									<c:set var="avatar">defaultavatar_small</c:set>
									<c:if test="${! empty device.rows[0].lasttime}"><isoft:timediff time="${device.rows[0].lasttime}" var="hc"/>
										<c:if test="${hc < 2880}"><c:set var="avatar">person-blue</c:set></c:if>
									</c:if>
									<img src="images/${avatar}.png" title="User" alt="">
								</div> <!-- .user-card-avatar -->
								<div class="details">
									<p><strong>
										<c:if test="${(G_bookmanager == param.branch) and (! empty G_bookmanager)}">
										<a href="edit.jsp?action=editext&branch=${param.branch}&ext=${gc.id}"></c:if>
											${gc.ename} ${gc.secondname} ${G_bookmanager == param.branch ? '</a>' : ''}
										</strong><br>
										<font size="2">${gc.extension}</font><br>
										${gc.bname} <i>${gc.addr} ${gc.city}</i></p>
								</div> <!-- .user-card-content -->
							</div> <!-- .user-card -->
						
					 ${status.last ? '</div>' : ''} <!-- .department -->
				<c:set var="cabid" value="${ccabid}"/>
			</c:forEach>
		</div> <!-- .widget-content -->
	</c:otherwise>
</c:choose>

</div></div></div></div>
	<c:set var="pagescript">
	<script>
	<c:if test="${! empty G_bookmanager}">
	(function($) {

	$.modal = function (config) {

		var defaults, options, container, header, close, content, title, overlay;

		defaults = {
			 title: ''
			, html: ''
			, ajax: ''
			, width: null
			, overlay: true
			, overlayClose: false
			, escClose: true
		};

		options = $.extend (defaults, config);

		container = $('<div>', { id: 'modal' });
		header = $('<div>',  { id: 'modalHeader' });
		content = $('<div>', { id: 'modalContent' });
		overlay = $('<div>', { id: 'overlay' });
		title = $('<h2>', { text: options.title });
		close = $('<a>', { 'class': 'close', href: 'javascript:;', html: '&times' });

		container.appendTo ('body');
		header.appendTo (container);
		content.appendTo (container);
		if (options.overlay) {
			overlay.appendTo ('body');
		}
		title.prependTo (header);
		close.appendTo (header);

		if (options.ajax == '' && options.html == '') {
			title.text ('No Content');
		}

		if (options.ajax !== '') {
			content.html ('<div id="modalLoader"><img src="./images/loaders/squares.gif" /></div>');
			$.modal.reposition ();
			$.get (options.ajax, function (response) {
				content.html (response);
				$.modal.reposition ();
			});
		}

		if (options.html !== '') {
			content.html (options.html);
		}

		close.bind ('click', function (e) { 
			e.preventDefault (); 
			$.modal.close (); 		
		});

		if (options.overlayClose) {
			overlay.bind ('click', function (e) { $.modal.close (); });
		}

		if (options.escClose) {
			$(document).bind ('keyup.modal', function (e) {
				var key = e.which || e.keyCode;

				if (key == 27) {
					$.modal.close ();
				}			
			});
		}

		$.modal.reposition ();
	}

	$.modal.reposition = function () {
		var width = $('#modal').outerWidth ();		
		var centerOffset = width / 2;	
		$('#modal').css ({ 'left': '50%', 'top': $(window).scrollTop () + 75, 'margin-left': '-' + centerOffset + 'px' });
	};

	$.modal.close = function () {
		$('#modal').remove ();
		$('#overlay').remove ();
		$(document).unbind ('keyup.modal');
	}

	function getPageScroll() {
		var xScroll, yScroll;

		if (self.pageYOffset) {
			yScroll = self.pageYOffset;
			xScroll = self.pageXOffset;
		} else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
			yScroll = document.documentElement.scrollTop;
			xScroll = document.documentElement.scrollLeft;
		} else if (document.body) {// all other Explorers
			yScroll = document.body.scrollTop;
			xScroll = document.body.scrollLeft;
		}

		return new Array(xScroll,yScroll);
	}

	})(jQuery);
	</c:if>
	$(document).ready(function(){
	    $(".slidingDiv").hide();
	    $(".show_hide").show();

	    $('.show_hide').click(function(){
	    $(".slidingDiv").slideToggle();
	    });
	});
	function pingpbx(brid) {
		$.modal ({ 
			title: 'Ping PBX'
			, ajax: 'branchupdater.jsp?action=ping&id='+brid
		});	
	}
	$('#filter_branch').fastLiveFilter('#list_branch', {
	    timeout: 200,
	    callback: function(total) { $('#filter_results').html(total); }
	});
	
	</script>
	</c:set>
	
<%@ include file='foot.jsp'%>
