<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<isoft:regexp pat="^[0-9]{1,20}+$" value="${param.dept}" var="chkdept"/>

<c:choose>
	<c:when test="${chkdept == 'false'}">
		<c:set var="pageheader"><link rel="stylesheet" href="stylesheets/sample_pages/invoice.css" type="text/css" /></c:set>
		<%@ include file='h_menu.jsp'%>
	</c:when>
	<c:otherwise>
			<title>provision manager - PRINT</title>
			<head>
			<meta charset="utf-8" />
			<meta name="description" content="" />
			<meta name="author" content="" />		
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<link rel="stylesheet" href="stylesheets/allnoui.css" type="text/css" />
			<link rel="stylesheet" href="stylesheets/sample_pages/invoice.css" type="text/css" />
			</head>

		<body>
	</c:otherwise>
</c:choose>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Активационные коды для настройки телефонов</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			<c:choose>
				<c:when test="${chkdept == 'false'}">

			<div class="grid-17">
				<form class="form uniformForm" action="newtask.jsp" method="post" target="_blank">	

					
				<div class="widget">
					
					<div class="widget-header">
						<span class="icon-cog-alt"></span>
						<h3 class="icon aperture">Распечатать активационные номера</h3>
					</div> <!-- .widget-header -->
					
					<div class="widget-content">
						
							
						<div class="field-group inlineField">
						
							<label for="branch">Выберите офис:</label>
							<div class="field">
								<select id="branch" name="dept">
									<option value="infile_office">Все</option>
									<sql:query dataSource="${databas}" var="getDept">
									select * from branchesorg_${G_org}_${G_ver} order by name ASC
									</sql:query>
										<c:forEach items="${getDept.rows}" var="dept">
											<option value="${dept.id}">${dept.name}</option>
										</c:forEach>
								</select>
							</div>
						</div>

							<div class="actions">
								<button type="submit" class="btn btn-primary">Отчет</button>
							</div>
						
					</div> <!-- .widget-content -->
					
				</div> <!-- .widget -->	

			</form>
			
			</div> <!-- .grid -->
			
			<div class="grid-7">
				

				<div id="gettingStarted" class="box">
					<h3>О модуле</h3>
					<ul class="bullet secondary">
					бла-бла-бла
					</ul>
				</div>
					
			</div> <!-- .grid -->
			
			
			</c:when>
			<c:otherwise>

			<div class="grid-24">
			
				<sql:query dataSource="${databas}" var="getDept">
				select * from branchesorg_${G_org}_${G_ver} where id=? 
				<sql:param value="${param.dept}"/>
				</sql:query>
				<sql:query dataSource="${databas}" var="getOrg">
				select * from orgs where id=? 
				<sql:param value="${G_org}"/>
				</sql:query>
				<sql:query dataSource="${databas}" var="getCodes">
				select extensionsorg_${G_org}_${G_ver}.*,activation.code from extensionsorg_${G_org}_${G_ver},activation where branchid=? 
				and activation.extid=extensionsorg_${G_org}_${G_ver}.id
				and activation.orgid = ${G_org}
				<sql:param value="${param.dept}"/>
				</sql:query>
			<div id="invoice" class="widget widget-plain">			

									<div class="widget-header">
										<h3>Активация</h3>
									</div>

									<div class="widget-content">

							<ul class="client_details">
								<li>Организация: ${getOrg.rows[0].name} (${getOrg.rows[0].location})</li>
								<li>Офис или подразделение: ${getDept.rows[0].name}</li>
								<li>Тех. поддержка: ${getDept.rows[0].techname}</li>
								<li>Телефон: ${getDept.rows[0].techtel}</li>
							</ul>

							<ul class="invoice_details">
								<li>Статус: <span class="ticket ticket-info">Открыт</span></li>
								<li>Номер заявки: 001</li>
								<li>Дата: 10/25/2010</li>
								<li>Исполнитель: ______________________</li>
							</ul>


							<div class="clear"></div>

							<table class="table table-striped">

								<thead>
									<tr>
										<th>Номер</th>
										<th>Имя и Фамилия</th>
										<th>Внутренний номер</th>
										<th class="total">Код активации</th>
									</tr>
								</thead>	

								<tbody>
									<c:forEach var="gc" items="${getCodes.rows}" varStatus="status">
									<tr>
										<td>${status.count}</td>			
										<td>${gc.name} ${gc.secondname}</td>
										<td>${gc.extension}</td>
										<td class="total">${gc.code}</td>
									</tr>
									<c:set var="tot">${status.count}</c:set>
									</c:forEach>
									<tr>
										<td class="sub_total" colspan="4"></td>
									</tr>
									<tr class="total_bar">
										<td class="grand_total" colspan="2"></td>
										<td class="grand_total">Всего нужно настроить телефонов:</td>
										<td class="grand_total">${tot}</td>
									</tr>
								</tbody>
							</table>

							<hr>

							<h3>Заметки для настройки</h3>

							<p>Распакуйте коробку с телефоном, подключите все необходимые шнуры, подключите к питанию и локальной сети. 
								При первой загрузке телефона произойдет автоматическая настройка для активации телефона.
								После того как телефон войдет в режим активации на экране отобразится номер внутреннего телефона A-12345678 (пример)
								Наберите внутренний номер 200 и следуйте инструкциям. После того как телефон активирован, необходимо перегрузить телефон: выключите и включите 
								через 5-10 секунд питание адаптера. После того как телефон загрузится, на экране появится имя и внутренний телефон владельца.
								</p>
							<p>
								Для возврата в заводские настройки, зажмите кнопку OK на 15-20 секунд, после того как на экране появиться запрос на возврат к заводским 
								настройкам еще раз нажмите OK. Пройдет некоторое время и телефон снова будет готов к активации. Внимание: согласуйте с администратором
								системы данное действие, телефон должен быть переведен в соответствующий статус для повтора активации.
							</p>
							<p>
								В случае если на экране сообщение НЕТ регистрации (и вы не прошли процедуру активации) это означает что нет сети или порт TCP 80 закрыт.
								Если телефон в режиме активации (на экране надпись A-12345678) но номер 200 не отвечает то скорее всего у вас нет доступа к серверу
								активации, сообщите вашему системному администратору.
								
							</p>
						</div>
									</div>
			
			
			</div> <!-- .grid -->
			
			</c:otherwise>
			</c:choose>
		</div> <!-- .container -->
		
	</div> <!-- #content -->

<c:choose>
	<c:when test="${chkdept == 'false'}">
	<%@ include file='h_quicknav.jsp'%>
	</c:when>
	<c:otherwise>

	</c:otherwise>
</c:choose>