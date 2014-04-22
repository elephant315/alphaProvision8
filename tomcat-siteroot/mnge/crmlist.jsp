<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:set var="pageheader"> </c:set>
<c:set var="pagescript"> </c:set>
<%@ include file='h_menu.jsp'%>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.id}" var="chkid1"/>
<c:if test="${chkid1 == 'true'}">
	<sql:query dataSource="${databas}" var="branch">
	select * from branchesorg_${G_org}_${G_ver} where id=?
		<sql:param value="${param.id}"/>
	</sql:query>
		<c:set var="bid" value="${branch.rows[0].id}"/>
		<c:set var="bname" value="${branch.rows[0].name}"/>
		<c:set var="bcity" value="${branch.rows[0].city}"/>
		<c:set var="baddr" value="${branch.rows[0].addr}"/>
		<c:set var="btechperson" value="${branch.rows[0].techperson}"/>
		<c:set var="btechtel" value="${branch.rows[0].techtel}"/>
		<c:set var="btime" value="${branch.rows[0].lasttime}"/>
		<c:set var="blastip" value="${branch.rows[0].lastip}"/>
	</c:if>
	<c:choose>
		<c:when test="${!empty bid}">
<!--
	1. Контактная информация телефоны и прочее
	2. Проектная информация (оборудование и прочее)
	3. Описание инфраструктуры
	4. Настройки по интеграции voip
	5. Особые заметки
	6. Задание
		Обследование
		Первичная настройка сети
		Отгрузка оборудования
		Настройка АТС и телефонов
		Интеграция с PSTN
		Обучение
	20  helpdesk - tel or pbx problem
	21	helpesk - trunk problems
	22	helpdesk - request data change
	23	helpdesk - others
	29  helpdesk answers
-->
	<c:if test="${param.action == 'edit'}">
		<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я .,-=@'%#:;_\n\r\t]{1,2000}+$" value="${param.info}" var="chkinfo"/>
		<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.type}" var="chktype"/>
		<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.crmid}" var="chkcrmid"/>
			<c:choose>
				<c:when test="${(chkinfo == 'true') and (chktype == 'true') and (chkcrmid == 'true')}">
					<sql:query dataSource="${databas}" var="chkdouble1">
						select id from crm where idorg = ? and idbr = ? and id = ?
						<sql:param value="${G_org}"/>
						<sql:param value="${bid}"/>
						<sql:param value="${param.crmid}"/>
					</sql:query>
					<c:choose>
						<c:when test="${chkdouble1.rowCount == 1}">
							<sql:update dataSource="${databas}">
							 update crm set info = ?, type = ?, who = ?, cdata = Now() where id = ?
								<sql:param value="${param.info}"/>
								<sql:param value="${param.type}"/>
								<sql:param value="${G_username}"/>
								<sql:param value="${param.crmid}"/>
							</sql:update>
						</c:when>
						<c:otherwise>
							<c:set var="actionerror">
								<div class="notify notify-error">
									<a href="javascript:;" class="close">&times;</a>
									<h3>Ошибка редактирования</h3>
									<p>Не существует</p>
								</div> <!-- .notify -->
							</c:set>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:set var="actionerror">
						<div class="notify notify-error">
							<a href="javascript:;" class="close">&times;</a>
							<h3>Ошибка редактирования</h3>
							<p>Введены недопустимые символы или некоторые поля пустые. <hr/>${param.info}</p>
						</div> <!-- .notify -->
					</c:set>
				</c:otherwise>
			</c:choose>
	</c:if>
	
	<c:if test="${param.action == 'new'}">
		<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я .,-=@'%#:;_\n\r\t]{1,2000}+$" value="${param.info}" var="chkinfo"/>
		<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.type}" var="chktype"/>
			<c:choose>
				<c:when test="${(chkinfo == 'true') and (chktype == 'true')}">
					<sql:update dataSource="${databas}">
						insert into crm (idorg,idbr,type,cdata,who,info) values (?,?,?,Now(),?,?)
					 <sql:param value="${G_org}"/>
					 <sql:param value="${bid}"/>
					 <sql:param value="${param.type}"/>
					 <sql:param value="${G_username}"/>
					 <sql:param value="${param.info}"/>
					</sql:update>
				</c:when>
				<c:otherwise>
					<c:set var="actionerror">
						<div class="notify notify-error">
							<a href="javascript:;" class="close">&times;</a>
							<h3>Ошибка редактирования</h3>
							<p>Введены недопустимые символы или некоторые поля пустые.</p>
						</div> <!-- .notify -->
					</c:set>
				</c:otherwise>
			</c:choose>
	</c:if>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Заметки - ${bname}</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
				
				<div class="widget widget-plain">
					
					<div class="widget-content">
						${actionerror}
						
						<button class="btn btn-primary" onClick="addbrinfo()"><span class="con-document-alt-stroke"></span>Новая заметка</button>
						
					</div> <!-- .widget-content -->
					
				</div> <!-- .widget -->
				<div class="box plain">
					
					
					
					<table class="table table-striped table-bordered">
					<thead>
						<tr>
							<th colspan="2">Все заметки</th>
						</tr>
					</thead>
					<tbody>
						<sql:query dataSource="${databas}" var="branchinfo">
						select * from crm where idorg = ? and idbr = ? order by type desc
							<sql:param value="${G_org}"/>
							<sql:param value="${bid}"/>
						</sql:query>
							<c:forEach items="${branchinfo.rows}" var="bx">
								<c:if test="${ttyp != bx.type}">
									<tr class="odd gradeX">
										<td colspan="2"><h3>
											${bx.type == '1' ? 'Контактная информация телефоны и прочее' : ''}
											${bx.type == '2' ? 'Проектная информация (оборудование и прочее)' : ''}
											${bx.type == '3' ? 'Описание инфраструктуры' : ''}
											${bx.type == '4' ? 'Настройки по интеграции voip' : ''}
											${bx.type == '5' ? 'Особые заметки' : ''}
											${bx.type == '6' ? 'Выполненные работы' : ''}</h3>
										</td>
									</tr>
								</c:if>
								<c:set var="ttyp" value="${bx.type}"/>
								<tr>
									<td><button class="btn btn-small" onClick="editbrinfo('${bx.id}')">&nbsp;&nbsp;<span class="icon-pen-alt2"></span></button>
										<c:choose>
											<c:when test="${bx.type == '3'}">
													<c:set var="bxinfo">${fn:replace(bx.info, "Наличие розетки Ethernet: 1", "Наличие розетки Ethernet: ДА")}</c:set>
													<c:set var="bxinfo">${fn:replace(bxinfo, "Наличие розетки Ethernet: 0", "Наличие розетки Ethernet: НЕТ")}</c:set>
													<c:set var="bxinfo">${fn:replace(bxinfo, "Серверная стойка: 1", "Серверная стойка: ДА")}</c:set>
													<c:set var="bxinfo">${fn:replace(bxinfo, "Серверная стойка: 0", "Серверная стойка: НЕТ")}</c:set>
													<c:set var="bxinfo">${fn:replace(bxinfo, "Доступ к Головному офису: 1", "Доступ к Головному офису: ДА")}</c:set>
													<c:set var="bxinfo">${fn:replace(bxinfo, "Доступ к Головному офису: 0", "Доступ к Головному офису: НЕТ")}</c:set>
													<c:set var="bxinfo">${fn:replace(bxinfo, "Существуют VLAN: 1", "Существуют VLAN: ДА")}</c:set>
													<c:set var="bxinfo">${fn:replace(bxinfo, "Существуют VLAN: 0", "Существуют VLAN: НЕТ")}</c:set>
													<c:set var="bxinfo">${fn:replace(bxinfo, "Настроен DHCP в сети: 1", "Настроен DHCP в сети: ДА")}</c:set>
													<c:set var="bxinfo">${fn:replace(bxinfo, "Настроен DHCP в сети: 0", "Настроен DHCP в сети: НЕТ")}</c:set>
													${bxinfo}
											</c:when>
											<c:otherwise>${bx.info}</c:otherwise>
										</c:choose></td>
									<td>${bx.who} <br/> ${bx.cdata}</td>
								</tr>	
							</c:forEach>
							<c:if test="${branchinfo.rowCount ==  0}">
								<tr><td colspan="3"><i>нет заметок!</i></td></tr>
							</c:if>
						</tbody>
					</table>
				</div> <!-- .box -->	
			</div> <!-- .grid -->
			
		</div> <!-- .container -->
		
	</div> <!-- #content -->
	<div id="modalwin"></div>
	<c:set var="pagescript">
		<script>
			function addbrinfo() {
				$.modal ({ 
					title: 'Новая заметка'
					, ajax: 'crmedit.jsp?action=new&brid=${param.id}'
				});	
			}
			function editbrinfo(crmid) {
				$.modal ({ 
					title: 'Новая заметка'
					, ajax: 'crmedit.jsp?action=edit&brid=${param.id}&crmid='+crmid
				});	
			}
		</script>
	</c:set>
	
</c:when>
<c:otherwise>
<div id="content">
	<div id="contentHeader">
		<h1>Просмотр офиса</h1>
	</div> <!-- #contentHeader -->
	<div class="container">
		<div class="grid-24">
			<div class="notify notify-error">
			<a href="javascript:;" class="close">&times;</a>
			<h3>Ошибка</h3>
			<p>Офис не найден.</p>
			</div> <!-- .notify -->
		</div>
	</div>
</div>
</c:otherwise>
</c:choose>
<%@ include file='h_quicknav.jsp'%>