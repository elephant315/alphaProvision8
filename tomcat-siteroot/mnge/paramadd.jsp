<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:set var="pageheader"><link rel="stylesheet" href="stylesheets/sample_pages/people.css" type="text/css" /></c:set>
<%@ include file='h_menu.jsp'%>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Добавление параметра ${param.action == 'branch' ? 'для офиса' :'для пользователя'}</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			<div class="grid-24">
				
				<div class="box plain">
					<button class="${param.nice == '1' ? ' btn btn-primary' : 'btn btn-tertiary'}" onClick = "location.href='paramadd.jsp?nice=1&id=${param.id}&action=${param.action}'">Основные параметры</button>
					<button class="${param.nice == '2' ? ' btn btn-primary' : 'btn btn-tertiary'}" onClick = "location.href='paramadd.jsp?nice=2&id=${param.id}&action=${param.action}'">Дополнительные функции</button>
					<button class="${param.nice == '3' ? ' btn btn-primary' : 'btn btn-tertiary'}" onClick = "location.href='paramadd.jsp?nice=3&id=${param.id}&action=${param.action}'">Сложные настройки</button>
					<button class="${param.nice == '4' ? ' btn btn-primary' : 'btn btn-tertiary'}" onClick = "location.href='paramadd.jsp?nice=4&id=${param.id}&action=${param.action}'">Лучше не настраивать</button>
				</div>
				

					
					<div class="box plain">
							<div id="accordion">
								<sql:query dataSource="${databas}" var="getType">
								select id,type,typedescr from params where nice = ? GROUP BY type order by id asc
									<sql:param value="${param.nice}"/>
								</sql:query>
								<c:forEach items="${getType.rows}" var="a">
									<h3><a href="#"><strong>${fn:length(a.typedescr) == 0 ? a.type : a.typedescr}</strong></a></h3>
									<div>
											<sql:query dataSource="${databas}" var="getParam">
											select * from params where type=? and nice = ?
											<sql:param value="${a.type}"/>
											<sql:param value="${param.nice}"/>
											</sql:query>
													<table class="table table-striped">
														<thead>
															<tr>
																<th>Параметр</th>
																<th>Описание</th>
																<th>Производитель / Модель</th>
																<th>Зависимости</th>	
															</tr>
														</thead>
														<tbody>
														
													<c:forEach items="${getParam.rows}" var="b">
													<tr>
														<td>
														<c:choose>	
															<c:when test="${fn:contains(b.type,'readonly') == false}">
															<a href="paraminsert.jsp?action=${param.action}&id=${param.id}&newparam=${b.id}">
															<span class="ticket ticket-success">${b.param}</span></a>
															</c:when>
															<c:otherwise>
															<span class="ticket ticket-warning">${b.param}</span>
															</c:otherwise>
														</c:choose>
														</td>
														<td>${b.paramdescr}</td>
														<td>${b.device}</td>
														<td>
															<c:if test="${fn:length(b.dependency) != 0}">
																<c:remove var="desql"/>
																<c:forEach items="${fn:split(b.dependency,';')}" var="de" varStatus="status">
																	<c:set var="desql">${desql} id = ${de} ${not status.last ? ' or ' : ''}</c:set>
																</c:forEach>
																<sql:query dataSource="${databas}" var="der">
																	select param from params where ${desql}
																</sql:query>
																<c:forEach items="${der.rows}" var="deo" varStatus="status">
																	${deo.param} ${not status.last ? ' , ' : ''}
																</c:forEach>
															</c:if>
														</td>
													</tr>
													</c:forEach>
													</tbody>
													</table>
									</div>
								</c:forEach>
							</div>
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->
<c:set var="pagescript">
<script>
	$(function() {
		$( "#accordion" ).accordion({ autoHeight: false });
	});
	</script>
</c:set>	
<%@ include file='h_quicknav.jsp'%>