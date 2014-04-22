<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<isoft:regexp pat="^[0-9]{1,20}+$" value="${param.dept}" var="chkdept"/>


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

	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Вся организация</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">


			<div class="grid-24">
			
				<sql:query dataSource="${databas}" var="getDept">
				select * from branchesorg_${G_org}_${G_ver} order by city,name
				</sql:query>
			<div id="invoice" class="widget widget-plain">			

									<div class="widget-header">
										<h3>Активация</h3>
									</div>

									<div class="widget-content">
							<div class="clear"></div>

							<table class="table table-striped">

								<thead>
									<tr>
										<th>#</th>
										<th>Название офиса</th>
										<th>PWD</th>
										<th>Адрес</th>
										<th>alpha ip</th>
										<th>tel net ip</th>
										<th>key</th>
										<th>users</th>
									</tr>
								</thead>	

								<tbody>
									<c:forEach var="gc" items="${getDept.rows}" varStatus="status">
									
									<sql:query dataSource="${databas}" var="getCount">
									select id from extensionsorg_${G_org}_${G_ver} where branchid=${gc.id}
									</sql:query>
									
										<c:set var="bid" value="${gc.id}"/>
												<sql:query dataSource="${databas}" var="loadcrm1">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Сотовый телефон:%"
												</sql:query>
												<c:set var="crm1id" value="${loadcrm1.rows[0].id}"/><c:set var="crm1info" value="${fn:substringAfter(loadcrm1.rows[0].info,'Сотовый телефон: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm2">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Номер телефона для SIP iDphone:%"
												</sql:query>
												<c:set var="crm2id" value="${loadcrm2.rows[0].id}"/><c:set var="crm2info" value="${fn:substringAfter(loadcrm2.rows[0].info,'Номер телефона для SIP iDphone: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm3">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Наличие розетки Ethernet:%"
												</sql:query>
												<c:set var="crm3id" value="${loadcrm3.rows[0].id}"/><c:set var="crm3info" value="${fn:substringAfter(loadcrm3.rows[0].info,'Наличие розетки Ethernet: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm4">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Серверная стойка:%"
												</sql:query>
												<c:set var="crm4id" value="${loadcrm4.rows[0].id}"/><c:set var="crm4info" value="${fn:substringAfter(loadcrm4.rows[0].info,'Серверная стойка: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm5">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Доступ к Головному офису:%"
												</sql:query>
												<c:set var="crm5id" value="${loadcrm5.rows[0].id}"/><c:set var="crm5info" value="${fn:substringAfter(loadcrm5.rows[0].info,'Доступ к Головному офису: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm6">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Существуют VLAN:%"
												</sql:query>
												<c:set var="crm6id" value="${loadcrm6.rows[0].id}"/><c:set var="crm6info" value="${fn:substringAfter(loadcrm6.rows[0].info,'Существуют VLAN: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm7">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Настроен DHCP в сети:%"
												</sql:query>
												<c:set var="crm7id" value="${loadcrm7.rows[0].id}"/><c:set var="crm7info" value="${fn:substringAfter(loadcrm7.rows[0].info,'Настроен DHCP в сети: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm8">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Mail:%"
												</sql:query>
												<c:set var="crm8id" value="${loadcrm8.rows[0].id}"/><c:set var="crm8info" value="${fn:substringAfter(loadcrm8.rows[0].info,'Mail: ')}"/>			
												<sql:query dataSource="${databas}" var="loadcrm9">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "IP адрес ATC:%"
												</sql:query>
												<c:set var="crm9id" value="${loadcrm9.rows[0].id}"/><c:set var="crm9info" value="${fn:substringAfter(loadcrm9.rows[0].info,'IP адрес ATC: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm10">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "IP шлюз для АТС:%"
												</sql:query>
												<c:set var="crm10id" value="${loadcrm10.rows[0].id}"/><c:set var="crm10info" value="${fn:substringAfter(loadcrm10.rows[0].info,'IP шлюз для АТС: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm11">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "IP адреса начало:%"
												</sql:query>
												<c:set var="crm11id" value="${loadcrm11.rows[0].id}"/><c:set var="crm11info" value="${fn:substringAfter(loadcrm11.rows[0].info,'IP адреса начало: ')}"/>
												<sql:query dataSource="${databas}" var="loadcrm12">
													select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "IP адреса конец:%"
												</sql:query>
												<c:set var="crm12id" value="${loadcrm12.rows[0].id}"/><c:set var="crm12info" value="${fn:substringAfter(loadcrm12.rows[0].info,'IP адреса конец: ')}"/>
									<c:if test="${(param.show == 'all') or (! empty crm9info)}">
									<tr>
										<td>${gc.id}</td>
										<td>${gc.name}</td>
										<td><isoft:genpwd var="genPwd" type="strings" length="7" />${genPwd}</td>
										<td>${gc.city} - ${gc.addr}</td> 
										<td>${crm9info} gw ${crm10info}</td>
										<td>${crm11info} - ${crm12info}</td>
										<td>${gc.aeskey}</td>
										<td>${getCount.rowCount}</td>
									<c:set var="tota">${tota+1}</c:set>	
									</tr>
									</c:if>
									
									</c:forEach>
									<tr>
										<td class="sub_total" colspan="9"></td>
									</tr>
									<tr class="total_bar">
										<td class="grand_total" colspan="6"></td>
										<td class="grand_total">Всего офисов:</td>
										<td class="grand_total">${tota}</td>
									</tr>
								</tbody>
							</table>

							
						</div>
						</div>
						
			</div> <!-- .grid -->
			
		</div> <!-- .container -->
		
	</div> <!-- #content -->
</body></html>