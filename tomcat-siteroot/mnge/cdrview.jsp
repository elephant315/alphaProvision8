<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:set var="pageheader"><link rel="stylesheet" href="stylesheets/sample_pages/reports.css" type="text/css" /></c:set>

<%@ include file='h_menu.jsp'%>
<c:set var="pagescript">
<script>
	$(function() {
		$( "#dates" ).datepicker({ dateFormat: 'yy-mm-dd' });
		$( "#datee" ).datepicker({ dateFormat: 'yy-mm-dd' });
	});
	</script>
</c:set>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.id}" var="chbid"/>
<isoft:regexp pat="^[0-9\-]{1,10}+$" value="${param.dates}" var="chdates"/>
<isoft:regexp pat="^[0-9\-]{1,10}+$" value="${param.datee}" var="chdatee"/>
<isoft:regexp pat="^[0-9A-Za-z]{1,20}+$" value="${param.mac}" var="chmac"/>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.num}" var="chnum"/>
<isoft:regexp pat="^[0-9A-Za-z]{1,10}+$" value="${param.user}" var="chuser"/>
<c:if test="${chdates == 'true'}"><c:set var="sqdates"> and start >= '${param.dates}' </c:set></c:if>
<c:if test="${chdates == 'false'}"><c:set var="sqdates"> and start >= CAST(DATE_FORMAT(NOW() ,'%Y-%m-01') as DATE) </c:set></c:if>
<c:if test="${chdatee == 'true'}"><c:set var="sqdatee"> and start <= '${param.datee}' </c:set></c:if>
<c:if test="${chdatee == 'false'}"><c:set var="sqdatee"> and start <= CAST(DATE_FORMAT(NOW() ,'%Y-%m-%d') as DATE) </c:set></c:if>
<c:if test="${chmac == 'true'}"><c:set var="sqmac"> and accountcode like '%${param.mac}%' </c:set></c:if>
<c:if test="${chnum == 'true'}"><c:set var="sqnum"> and dst = '${param.num}' </c:set></c:if>
<c:if test="${chuser == 'true'}"><c:set var="squser"> and src = '${param.user}' </c:set></c:if>
<c:if test="${chbid == 'true'}">		
	<div id="content">
		
		<div id="contentHeader">
			<h1>Просмотр звонков</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
				<sql:query dataSource="${databas}" var="getRep1">
				select sum(billsec) as bill,count(start) as tot from cdr_${G_org}_b${param.id} where start <> ''
					${sqdates} ${sqdatee} ${sqmac} ${sqnum} ${squser}
				</sql:query>
				<sql:query dataSource="${databas}" var="getRep2">
				select sum(billsec) as bill,count(start) as tot from cdr_${G_org}_b${param.id} where length(dst) = 5
					${sqdates} ${sqdatee} ${sqmac} ${sqnum} ${squser}
				</sql:query>
				<sql:query dataSource="${databas}" var="getRep3">
				select sum(billsec) as bill,count(start) as tot from cdr_${G_org}_b${param.id} where length(dst) <> 5
					${sqdates} ${sqdatee} ${sqmac} ${sqnum} ${squser}
				</sql:query>
				
				<form class="form uniformForm" method="post" action="cdrview.jsp?id=${param.id}&filter=yes">	
					<div class="widget">
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
									<label for="mac">accountcode</label>
								</div>
								<div class="field">
									<input type="text" name="user" id="user" size="12" class="" value="${param.user}"/>
									<label for="user">Внутренний номер</label>
								</div>
								<div class="field">
									<input type="text" name="num" id="num" size="12" class="" value="${param.num}"/>
									<label for="num">Набранный номер</label>
								</div>
								<div class="field">
									<button class="btn btn-success">Показать</button>
									<c:if test="${! empty param.filter}">
									<a href="cdrview.jsp?id=${param.id}" class="btn btn-terrtiarry"><span class="icon-x"></span> убрать</a>
									</c:if>
									<label for="lname">максимум 300 записей</label>
								</div>

							</div> <!-- .field-group -->

						</div>
					</div>
				</form>
				
				<div class="widget widget-plain">
					<div class="widget-content">
						<div id="big_stats" class="cf">
							<div class="stat">
								<h4>Количество звонков</h4>
								<span class="value">${getRep1.rows[0].tot}</span>
							</div> <!-- .stat -->
							<div class="stat">
								<h4>Внутри офиса</h4>
								<span class="value">${getRep2.rows[0].tot}</span>
							</div> <!-- .stat -->
							<div class="stat">
								<h4>Внешние звонки</h4>
								<span class="value">${getRep3.rows[0].tot}</span>
							</div> <!-- .stat -->
							<div class="stat">
								<h4>Длительность мин</h4>
								<span class="value">${getRep1.rows[0].bill/60}</span>
							</div> <!-- .stat -->
						</div>
											<c:if test="${chdates == 'false'}"><h6>* выбранный период: 1е число текущего месяца</h6></c:if>
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
			
			
				<div class="widget widget-table">
					
					<div class="widget-header">
						<span class="icon-list"></span>
						<h3 class="icon aperture">весь лог</h3>
					</div> <!-- .widget-header -->
					<div class="widget-content">
						<table class="table table-bordered table-striped data-table">
							<sql:query dataSource="${databas}" var="getLog">
							select * from cdr_${G_org}_b${param.id} where start <> ''
								${sqdates} ${sqdatee} ${sqmac} ${sqnum} ${squser}
								order by start DESC LIMIT 300
							</sql:query>	
						<thead>
							<tr>
								<th>Время</th>
								<th>#</th>
								<th>Внутренний номер</th>
								<th>Набранный номер</th>
								<th>Длительность</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${getLog.rows}" var="vo">
							<tr class="odd">
								<td>${vo.start}</td>
								<td>
									<c:choose>
										<c:when test="${vo.disposition == 'ANSWERED'}"><span class="ticket ticket-success">Успех</span></c:when>
										<c:when test="${vo.disposition == 'FAILED'}"><span class="ticket ticket-important">Сбой</span></c:when>
										<c:otherwise><span class="ticket">${vo.disposition == 'BUSY' ? 'Занято' : 'Нет ответа'}</span></c:otherwise>
									</c:choose>
								</td>
								<td>${vo.src}&nbsp;${vo.clid}</td>
								<td>${vo.dst}</td>
								<td>${vo.billsec}</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>	

					</div> <!-- .widget-content -->
				</div> <!-- .widget -->	
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->
</c:if>
<%@ include file='h_quicknav.jsp'%>