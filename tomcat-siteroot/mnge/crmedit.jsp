<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.brid}" var="chkbr1"/>
<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.crmid}" var="chkcrm1"/>

<c:if test="${((param.action == 'new') or (param.action == 'edit')) and (chkbr1 == 'true')}">
<sql:query dataSource="${databas}" var="getBr">
	select * from branchesorg_${G_org}_${G_ver} where id = ?
	<sql:param value="${param.brid}"/>
</sql:query>
	<c:if test="${getBr.rowCount == 1}">
		<c:if test="${(param.action == 'edit') and (chkcrm1 == 'true')}">
			<sql:query dataSource="${databas}" var="loadcrm">
				select type,info from crm where id = ?
			 <sql:param value="${param.crmid}"/>
			</sql:query>
		</c:if>
		<div class="box plain">
			<form class="form uniformForm validateForm" method="post" action="crmlist.jsp?id=${param.brid}&action=${param.action}&crmid=${param.crmid}">
				<div class="field-group">
					<label for="type">Тема:</label>
						<div class="field">
							<select id="type" name="type">
								<option value="1" ${loadcrm.rows[0].type == '1' ? 'selected' : ''}>Контактная информация телефоны и прочее</option>
								<option value="2" ${loadcrm.rows[0].type == '2' ? 'selected' : ''}>Проектная информация (оборудование и прочее)</option>
								<option value="3" ${loadcrm.rows[0].type == '3' ? 'selected' : ''}>Описание инфраструктуры</option>
								<option value="4" ${loadcrm.rows[0].type == '4' ? 'selected' : ''}>Настройки по интеграции voip</option>
								<option value="5" ${loadcrm.rows[0].type == '5' ? 'selected' : ''}>Особые заметки</option>
								<option value="6" ${loadcrm.rows[0].type == '6' ? 'selected' : ''}>Выполненные работы</option>
							</select>
						</div>
				</div> <!-- .field-group -->
			
				<div class="field-group">
					<label for="newcity">Текст:</label>
					<div class="field">
						<textarea name="info" id="info" rows="10" cols="50">${loadcrm.rows[0].info}</textarea><br/>
						* Пароли и подобную информацию сюда не записывать.
					</div>
				</div> <!-- .field-group -->
				
				<div class="actions">
					<button type="submit" class="btn btn-success">Применить</button>
				</div> <!-- .actions -->
			
			</form>
		</div> <!-- .widget-content -->
	</c:if>
</c:if>
