<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:set var="pageheader"><link rel="stylesheet" href="stylesheets/sample_pages/people.css" type="text/css" /></c:set>
<%@ include file='h_menu.jsp'%>
<isoft:regexp pat="^[0-9]+$" value="${param.connect}" var="chkv1"/>

<c:if test="${chkv1 == 'true'}">
	<sql:query dataSource="${databas}" var="chkv2">
	select id from subversion where orgid = ? and id=?
	<sql:param value="${G_org}"/>
	<sql:param value="${param.connect}"/>
	</sql:query>
		<c:if test="${chkv2.rowCount == 1}">
			<c:set var="G_ver" value="${chkv2.rows[0].id}" scope="session"/>
			<c:set var="G_menumsg" scope="session">${G_menumsg}${newline}Переключена версия базы на ${G_ver} ## Вернитесь на версию</c:set>
			<c:redirect url="subvermng.jsp"/>
		</c:if>
</c:if>	

<c:if test="${param.rollback=='true'}">
	<c:set var="new_G_ver" value="yes" scope="session"/>
	<c:import url="subver.jsp"/>
	<c:redirect url="subvermng.jsp"/>
</c:if>

<isoft:regexp pat="^[0-9]+$" value="${param.deletedb}" var="chkvdel"/>
<c:if test="${(chkvdel == 'true') and (param.deletedb != G_ver)}">
	<sql:query dataSource="${databas}" var="chkvdel2">
	select id from subversion where orgid = ? and id=?
	<sql:param value="${G_org}"/>
	<sql:param value="${param.deletedb}"/>
	</sql:query>
		<c:if test="${chkvdel2.rowCount == 1}">
			<sql:transaction dataSource="${databas}">
			<sql:query var="ged">
			select id from extensionsorg_${G_org}_? where id NOT IN (select id from extensionsorg_${G_org}_${G_ver})
			<sql:param value="${chkvdel2.rows[0].id}"/>
			</sql:query>
			<c:forEach items="${ged.rows}" var="gedq">
				<sql:update>
					delete from activation where extid=? and orgid = ${G_org}
					<sql:param value="${gedq.id}"/>
				</sql:update>
			</c:forEach>	
				<sql:update>
					drop table extensionsorg_${G_org}_?
					<sql:param value="${chkvdel2.rows[0].id}"/>
				</sql:update>
				<sql:update>
					drop table extensionparams_${G_org}_?
					<sql:param value="${chkvdel2.rows[0].id}"/>
				</sql:update>
				<sql:update>
					drop table branchesorg_${G_org}_?
					<sql:param value="${chkvdel2.rows[0].id}"/>
				</sql:update>
				<sql:update>
					drop table branchparams_${G_org}_?
					<sql:param value="${chkvdel2.rows[0].id}"/>
				</sql:update>
				<sql:update>
					delete from subversion where orgid = ${G_org} and id=?
					<sql:param value="${chkvdel2.rows[0].id}"/>
				</sql:update>
			</sql:transaction>
		</c:if>
</c:if>

	<div id="content">
		
		<div id="contentHeader">
			<h1>Версии базы данных</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-16">
				<div class="widget widget-plain">
					<div class="widget-header">
					<span class="icon-layers"></span>
					<h3>версии</h3>
					</div>
					
					<div class="widget-content">
										<div class="department">
											<h2>Текущая версия базы данных</h2>
											
													<div class="user-card-long">
														<div class="avatar">
															<sql:query dataSource="${databas}" var="getlastver">
															select id from subversion where orgid = ? order by id desc LIMIT 0,1
															<sql:param value="${G_org}"/>
															</sql:query>
															<c:set var="lastv" value="${getlastver.rows[0].id}"/>
															<img src="images/stream/${lastv == G_ver ? 'dbok' : 'dbw'}.png" title="User" alt="">
														</div> <!-- .user-card-avatar -->
														<div class="details">
															<p><strong>Вы работаете с версией: ${G_ver}</strong><br/>
																Последняя версия: ${lastv}
														</div> <!-- .user-card-content -->
													</div> <!-- .user-card -->
										</div> <!-- .department -->
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
			</div>	
			<div class="grid-8">

				<div class="box">
					<h3>Управление версиями</h3>
					
						<c:if test="${lastv != G_ver}">
						<p>
							<button class="btn btn-primary " onClick = "location.href='subvermng.jsp?connect=${lastv}'">
							<span class="icon-loop"></span>вернутся на последнюю версию</button>
						</p>
						<p>	
							<button class="btn btn-success" onClick = "location.href='subvermng.jsp?rollback=true'">
							<span></span>сделать выбранную версию ${G_ver} активной</button>
						</p>
						</c:if>
				</div>
			</div> <!-- .grid -->
			<div class="grid-24">	
				<div class="widget widget-table">
					
					<div class="widget-header">
						<span class="icon-list"></span>
						<h3 class="icon aperture">Предыдущие версии</h3>
					</div> <!-- .widget-header -->
					
					<div class="widget-content">
						<table class="table table-bordered table-striped data-table">
							<sql:query dataSource="${databas}" var="getVer">
							select * from subversion where orgid=? order by id DESC
								<sql:param value="${G_org}"/>
							</sql:query>
						<thead>
							<tr>
								<th>Номер версии</th>
								<th>Переход</th>
								<th>Дата</th>
								<th>Количество офисов и номеров</th>
								<th>Удаление версии</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${getVer.rows}" var="vv">
							<tr class="odd">
								<td><h3>${vv.id}</h2></td>
								<td><c:if test="${vv.id != G_ver}"><a href="subvermng.jsp?connect=${vv.id}">подключить</a></c:if></td>
								<td>${vv.vdate}</td>
								<td>
									<sql:query dataSource="${databas}" var="getVeq">
									select id from extensionsorg_${G_org}_?
										<sql:param value="${vv.id}"/>
									</sql:query>
									<sql:query dataSource="${databas}" var="getVbq">
									select id from branchesorg_${G_org}_?
										<sql:param value="${vv.id}"/>
									</sql:query>
									${getVbq.rowCount} / ${getVeq.rowCount}
								</td>
								<td><c:if test="${vv.id != G_ver}"><span class="ticket ticket-error" id="deldb${vv.id}" name="${vv.id}">удалить</span></c:if>
								</td>
							</tr>
							<c:set var="deldbconfirmscript">
								${deldbconfirmscript}
									$(function () {	
									$('#deldb${vv.id}').live ('click', function (e) {
										e.preventDefault ();
										$.alert ({ 
											type: 'confirm'
											, title: 'Удаление версии ${vv.id}'
											, text: '<p>Вы уверены что хотите удалить базу ? Возврата данной операции нет! Будут удалены все данные справочников не входящих в версию ${G_ver} и состояние настройки оборудования.</p>'
											, callback: function () {window.location = "subvermng.jsp?deletedb=${vv.id}";}
										});		
									});
									});
								</c:set>
						</c:forEach>
						</tbody>
					</table>	

					</div> <!-- .widget-content -->
				</div> <!-- .widget -->	
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content  window.location = "subvermng.jsp?deletedb=${vv.id}"; -->
	
	
	<c:set var="pagescript">
	<script>
		${deldbconfirmscript}
	</script>
	</c:set>

<%@ include file='h_quicknav.jsp'%>