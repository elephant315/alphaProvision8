<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:if test="${! empty getExt.rows}">

<div class="widget-content">
	<table class="table table-bordered table-striped data-tablex">
	<thead>
		<tr>
			<th>Внутренний номер</th>
			<th>Имя</th>
			<th>Фамилия</th>
			<th>Статус</th>
			<th>Модель</th>
			<th>MAC / IP</th>
		</tr>
	</thead>
	<tbody>
	<c:forEach items="${getExt.rows}" var="exts">
		<tr class="odd">
			<td><a href="extension.jsp?id=${exts.id} ${getExt.rowCount > 10 ? '&enleftnav=yes' : ''}"><strong>${exts.extension}</strong></a></td>
			<td>${exts.name}</td>
			<td>${exts.secondname} </td>
			<c:choose>
				<c:when test="${!empty exts.deviceid}">
					<sql:query dataSource="${databas}" var="getDev">
					select * from devices where id=${exts.deviceid} LIMIT 1
					</sql:query>
					<td>
						${getDev.rows[0].statusflag == '0' ? '<span class="ticket">в коробке</span>':''} 
						${getDev.rows[0].statusflag == '1' ? '<span class="ticket ticket-warning">активация отправлена</span>':''} 
						${getDev.rows[0].statusflag == '2' ? '<span class="ticket ticket-warning">регистрируется но, не в сети</span>':''} 
						${getDev.rows[0].statusflag == '3' ? '<span class="ticket ticket-warning">включен и регистрируется</span>':''} 
						${getDev.rows[0].statusflag == '4' ? '<span class="ticket ticket-info">активирован</span>':''} 
						${getDev.rows[0].statusflag == '5' ? '<span class="ticket ticket-info">зарегистрирован</span>':''} 
						${getDev.rows[0].statusflag == '6' ? '<span class="ticket ticket-success">зарегистрирован но не в сети</span>':''} 
						${getDev.rows[0].statusflag == '7' ? '<span class="ticket ticket-success">зарегистрирован в сети</span>':''} 
						${getDev.rows[0].statusflag == '8' ? '<span class="ticket ticket-important">заблокирован</span>':''} 
						${getDev.rows[0].statusflag == '9' ? '<span class="ticket ticket-important">jailbreak</span>':''}
						<c:if test="${! empty getDev.rows[0].lasttime}">
						последняя активность <isoft:friendlytime time="${getDev.rows[0].lasttime}" var="hc"/>
						</c:if>
					</td>
					<td>${getDev.rows[0].model}</td>
					<td>${getDev.rows[0].macaddr} / ${! empty getDev.rows[0].lastip ? getDev.rows[0].lastip : 'нет данных'}</td>
				</c:when>
				<c:otherwise>
					<td><span class="ticket">не подключен</span></td>
					<td>-</td>
					<td>-</td>
				</c:otherwise>
			</c:choose>
		</tr>
	</c:forEach>
	</tbody>
     </table>	
</div> <!-- .widget-content -->
</c:if>
