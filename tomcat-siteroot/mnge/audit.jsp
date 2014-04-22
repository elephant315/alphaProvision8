<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
<c:set var="pagescript">
<script>
	$(function() {
		$( "#dates" ).datepicker({ dateFormat: 'yy-mm-dd' });
		$( "#datee" ).datepicker({ dateFormat: 'yy-mm-dd' });
	});
	</script>
</c:set>
<isoft:regexp pat="^[0-9\-]{1,10}+$" value="${param.dates}" var="chdates"/>
<isoft:regexp pat="^[0-9\-]{1,10}+$" value="${param.datee}" var="chdatee"/>
<isoft:regexp pat="^[0-9A-Za-z]{1,20}+$" value="${param.mac}" var="chmac"/>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.num}" var="chnum"/>
<isoft:regexp pat="^[0-9A-Za-z]{1,10}+$" value="${param.user}" var="chuser"/>
<c:if test="${chdates == 'true'}"><c:set var="sqdates"> and logtime >= '${param.dates}' </c:set></c:if>
<c:if test="${chdatee == 'true'}"><c:set var="sqdatee"> and logtime <= '${param.datee}' </c:set></c:if>
<c:if test="${chmac == 'true'}"><c:set var="sqmac"> and macaddr like '%${param.mac}%' </c:set></c:if>
<c:if test="${chnum == 'true'}"><c:set var="sqnum"> and ext like '%${param.num}%' </c:set></c:if>
<c:if test="${chuser == 'true'}"><c:set var="squser"> and username like '%${param.user}%' </c:set></c:if>
		
	<div id="content">
		
		<div id="contentHeader">
			<h1>Аудит работы</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
			<form class="form uniformForm" method="post" action="audit.jsp">	
				<div class="widget widget-plain">
					<div class="widget-content">
						<div class="field-group">
							<label>Фильтр:</label>

							<div class="field">
								<input type="text" name="dates" id="dates" size="12" class="" value="${param.dates}" />
								<label for="dates">Дата начала (yy-mm-d)</label>
							</div>
							<div class="field">
								<input type="text" name="datee" id="datee" size="12" value="${param.datee}"/>
								<label for="datee">Дата конца (yy-mm-d)</label>
							</div>
							<div class="field">
								<input type="text" name="mac" id="mac" size="12" class="" value="${param.mac}"/>
								<label for="mac">MAC адрес</label>
							</div>
							<div class="field">
								<input type="text" name="num" id="num" size="12" class="" value="${param.num}"/>
								<label for="num">Номер телефона</label>
							</div>
							<div class="field">
								<input type="text" name="user" id="user" size="12" class="" value="${param.user}"/>
								<label for="user">Пользователь</label>
							</div>
							<div class="field">
								<button class="btn btn-success">Показать</button>
								<label for="lname">максимум 300 записей</label>
							</div>
							
						</div> <!-- .field-group -->
						
					</div>
				</div>
			</form>
					
				<div class="widget widget-table">
					
					<div class="widget-header">
						<span class="icon-list"></span>
						<h3 class="icon aperture">весь лог</h3>
					</div> <!-- .widget-header -->
					<div class="widget-content">
						<table class="table table-bordered table-striped data-table">
							<sql:query dataSource="${databas}" var="getLog">
							select * from logs where org=? ${sqdates} ${sqdatee} ${sqmac} ${sqnum} ${squser}
									order by logtime DESC LIMIT 300
								<sql:param value="${G_org}"/>
							</sql:query>	
						<thead>
							<tr>
								<th>#</th>
								<th>Время</th>
								<th>MAC-адрес</th>
								<th>Номер телефона</th>
								<th>Пользователь</th>
								<th>Что было сделано</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${getLog.rows}" var="vo">
							<tr class="odd">
								<td>${vo.id}</td>
								<td>${vo.logtime}</td>
								<td>${vo.macaddr}</td>
								<td>${vo.ext}</td>
								<td>${vo.username}</td>
								<td>${vo.message}</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>	

					</div> <!-- .widget-content -->
				</div> <!-- .widget -->	
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>