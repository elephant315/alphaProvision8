<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>


<c:remove var="GT_importext" scope="session"/>
	<isoft:readupload var="extencsv" varform="extenformparams"/>
	

	<c:choose>
		<c:when test="${fn:contains(extenformparams,'fradio=freepbx29') == true}">
		<c:set var="modf" value="${fn:split(extencsv, newline)}"/>
			<c:forEach items='${modf}' var="modf1" begin="0" varStatus="status">
				<c:set var="modf1" value="${fn:replace(modf1, newliner, '')}"/>
				<c:set var="modf2" value="${fn:split(modf1, ',')}"/>
					<c:set value="${fn:trim(modf2[1])}" var="importName_t"/>
					<c:set value="." var="importSecondname_t"/>
						<c:if test="${fn:contains(fn:trim(modf2[1]), ' ')}">
						<c:set value="${fn:substringBefore(fn:trim(modf2[1]),' ')}" var="importName_t"/>
						<c:set value="${fn:substringAfter(fn:trim(modf2[1]),' ')}" var="importSecondname_t"/>
						</c:if>
					<c:set value="${fn:trim(modf2[0])}" var="importExtension_t"/>
					<c:set value="!EMPTY" var="importBranchID_t"/>
					<c:set value="${fn:trim(modf2[18])}" var="importPwd_t"/>
					<c:set value="none" var="importCabin"/>
					<c:set var="modf3">${modf3} ${newline} ${importName_t};${importSecondname_t};${importExtension_t};${importBranchID_t};${importPwd_t};${importCabin}</c:set>
			</c:forEach>
			<c:set var="i0" value="${fn:split(modf3, newline)}"/>
		</c:when>
		<c:otherwise><c:set var="i0" value="${fn:split(extencsv, newline)}"/></c:otherwise>
	</c:choose>
	
	<c:set var="canimport" value="true"/>
		<c:if test="${fn:length(i0) <= 1}">
		<c:set var="canimport" value="false"/>
		<c:set var="fe2" value="<strong>Данные отсутствуют. ${modf3}</strong> <br/>"/>
		</c:if>
		
	<c:forEach items='${i0}' var="i1" begin="1">
		<c:set var="i1" value="${fn:replace(i1, newliner, '')}"/>
		<c:set var="i2" value="${fn:split(i1, ';')}"/>
			<c:choose>
				<c:when test="${(fn:length(i2) != 6)}">
					<c:set var="canimport" value="false"/>
					<c:set var="fe2" value="<strong>Количество полей не соответствует.</strong> <br/> Откройте файл, возможно в нем присутствуют пустные поля или CR в конце файла. <br/>"/>
				</c:when>
				<c:otherwise>
					<c:set var="fe" value=""/>
					<c:set value="${fn:trim(i2[0])}" var="importName"/>
					<c:set value="${fn:trim(i2[1])}" var="importSecondname"/>
					<c:set value="${fn:trim(i2[2])}" var="importExtension"/>
					<c:set value="${fn:trim(i2[3])}" var="importBranchID"/>
						<c:if test="${fn:contains(extenformparams,'branch=infile_office') == false}">
							<c:set value="${fn:substringAfter(extenformparams,'branch=')}" var="importBranchID"/>
						</c:if>
						<c:choose>
							<c:when test="${fn:length(i2) == 6}"><c:set value="${fn:trim(i2[4])}" var="importPwd"/></c:when>
							<c:otherwise><c:set value="generated" var="importPwd"/></c:otherwise>
						</c:choose>
					<c:set value="${fn:trim(i2[5])}" var="importCabin"/>
					<c:if test="${empty importCabin}"><c:set value="none" var="importCabin"/></c:if>
						
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я]{1,29}+$" value="${importName}" var="chkName"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я.]{1,29}+$" value="${importSecondname}" var="chkSecondname"/>
						<isoft:regexp pat="^[1-9][0-9]{1,29}+$" value="${importExtension}" var="chkExtension"/>
						<isoft:regexp pat="^[1-9][0-9]{0,10}+$" value="${importBranchID}" var="chkBranchID1"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я ]{1,29}+$" value="${importBranchID}" var="chkBranchID2"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я ]{1,29}+$" value="${importPwd}" var="chkPwd"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я .,]{1,29}+$" value="${importCabin}" var="chkCabin"/>
						
						<c:if test="${chkName == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка в Имени. "/>
						</c:if>
						<c:if test="${chkSecondname == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка в Фамилии. "/>
						</c:if>
						<c:if test="${chkExtension == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка в Номере телефона. "/>
						</c:if>
						<c:if test="${(chkBranchID1 == 'false') and (chkBranchID2 == 'false')}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка в названии Офиса. "/>
						</c:if>
						<c:if test="${chkPwd == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка в пароле. "/>
						</c:if>
						<c:if test="${chkCabin == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка в названии кабинета. "/>
						</c:if>
						
						<c:set var="dcQty" value="0"/>
						<c:forEach items='${i0}' var="ii1" begin="1">
							<c:set var="ii1" value="${fn:replace(ii1, newliner, '')}"/>
							<c:set var="ii2" value="${fn:split(ii1, ';')}"/>
							<c:set value="${fn:trim(ii2[2])}" var="dcExtension"/>
							<c:if test="${dcExtension == importExtension}"><c:set var="dcQty" value="${dcQty+1}"/></c:if>
						</c:forEach>
						<c:if test="${dcQty > 1}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} повторения в файле. "/>
						</c:if>
						
						<c:set var="dwQty" value="0"/>
						<c:forEach items='${i0}' var="ii1" begin="1">
							<c:set var="ii1" value="${fn:replace(ii1, newliner, '')}"/>
							<c:set var="ii2" value="${fn:split(ii1, ';')}"/>
							<c:set value="${fn:trim(ii2[0])}" var="dcName"/>
							<c:set value="${fn:trim(ii2[1])}" var="dcSecondname"/>
							<c:if test="${(dcName == importName) and (dcSecondname == importSecondname)}"><c:set var="dwQty" value="${dwQty+1}"/></c:if>
						</c:forEach>
						
						<c:if test="${(chkExtension == 'true') and ((chkBranchID1 == 'true') or (chkBranchID2 == 'true'))}">
							<c:choose>
								<c:when test="${chkBranchID1 == 'true'}">
									<sql:query dataSource="${databas}" var="chk2">
									select id,name from branchesorg_${G_org}_${G_ver} where id = ?
									<sql:param value="${importBranchID}"/>
									</sql:query>
								</c:when>
								<c:otherwise>
									<sql:query dataSource="${databas}" var="chk2">
									select id,name from branchesorg_${G_org}_${G_ver} where name = ?
									<sql:param value="${importBranchID}"/>
									</sql:query>
								</c:otherwise>
							</c:choose>
								<c:if test="${chk2.rowCount != 1}">
									<c:set var="canimport" value="false"/>
									<c:set var="fe" value="${fe} не найден офис."/>
								</c:if>

							<c:if test="${chk2.rowCount == 1}">
								<c:set value="${chk2.rows[0].name}" var="importBranchID"/>
									<c:if test="${fn:contains(extenformparams,'branch=infile_office') == false}">
										<c:set value="${chk2.rows[0].name}" var="GT_importBranchID" scope="session"/>
									</c:if>
									<c:choose>
										<c:when test="${fn:contains(extenformparams,'chkglobal=1') == false}">
											<sql:query dataSource="${databas}" var="chk1">
											select id from extensionsorg_${G_org}_${G_ver} where extension = ?
											<sql:param value="${importExtension}"/>
											</sql:query>
										</c:when>
										<c:otherwise>
											<sql:query dataSource="${databas}" var="chk1">
											select id from extensionsorg_${G_org}_${G_ver} where extension = ? and branchid = ?
											<sql:param value="${importExtension}"/>
											<sql:param value="${chk2.rows[0].id}"/>
											</sql:query>
										</c:otherwise>
									</c:choose>
									<c:set var="dqUpdt" value="0"/>	
									<c:if test="${chk1.rowCount != 0}">
										<c:choose>
											<c:when test="${fn:contains(extenformparams,'unique=update') == true}">
												<c:set var="GT_update" value="true" scope="session"/>
												<c:set var="dqUpdt" value="1"/>
											</c:when>
											<c:otherwise>
												<c:set var="canimport" value="false"/>
												<c:set var="fe" value="${fe} номер существует. "/>
											</c:otherwise>
										</c:choose>
									</c:if>
							</c:if>
						</c:if>
							
						<c:set var="resulttable">
							${resulttable}
							<tr>	
								<td>
									<c:choose>
										<c:when test="${empty fe}">
											<c:choose>
												<c:when test="${dwQty > 1}"><span class="ticket ticket-warning">Повтор Имени</span></c:when>
												<c:when test="${dqUpdt == '1'}"><span class="ticket ticket-warning">Будет обновлен</span></c:when>
												<c:otherwise><span class="ticket ticket-success">Удачно</span></c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise><span class="ticket ticket-important">${fe}</span></c:otherwise>
									</c:choose>
									
								</td>
								<td>${importExtension}</td>
								<td>${importName}</td>
								<td>${importSecondname}</td>
								<td>${importBranchID}</td>
								<td>${importCabin}</td>
								<td>${importPwd}</td>
							</tr>
						</c:set>
				</c:otherwise>
			</c:choose>
	</c:forEach>	

	
	
	
	
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Импорт внутренних номеров</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-17">
				<div class="widget">
						<div class="widget-header">
							<span class="icon-info"></span>
							<h3 class="icon aperture">Проверка импортируемых данных</h3>
						</div> <!-- .widget-header -->
						<div class="widget-content">
								<c:choose>
									<c:when test="${canimport == 'true'}">
									<c:set var="GT_importext" value="${i0}" scope="session"/>
										<p>Данные в порядке</p>
										<br/><button id="goforward" class="btn btn-green">Записать в базу</button>
										<button id="goback" class="btn btn-tertiary">Отменить импорт</button>
									</c:when>
									<c:otherwise>
										<p>Обнаружены ошибки, продолжение операции не возможно. <br/> ${fe2}</p>
										<button id="goback" class="btn btn-tertiary">Вернуться назад</button>
									</c:otherwise>
								</c:choose>
						</div> <!-- .widget-content -->
					</div> <!-- .widget -->	
			<c:if test="${! empty resulttable}">
			<div class="widget widget-table">
								<div class="widget-header">
									<span class="icon-list"></span>
									<h3 class="icon aperture">Просмотр импортируемых данных</h3>
								</div> <!-- .widget-header -->
								<div class="widget-content">
									<table class="table table-bordered table-striped data-table">
									<thead>
										<tr>
											<th>Статус</th>
											<th>Номер телефона</th>
											<th>Имя</th>
											<th>Фамилия</th>
											<th>Название/ID офиса</th>
											<th>Кабинет</th>
											<th>Пароль</th>
										</tr>
									</thead>
									<tbody>
										${resulttable}
									</tbody>
									</table>
								</div> <!-- .widget-content -->
							</div> <!-- .widget -->	
			</c:if>	
			</div> <!-- .grid -->
			
			<div class="grid-7">
				

				<div id="gettingStarted" class="box">
					<h3>Скачать шаблоны</h3>
					<ul class="bullet secondary">
						<li><a href="javascript:;">Пример MS Excel</a></li>
						<li><a href="javascript:;">Пример файла CSV</a></li>
					</ul>
				</div>
					
			</div> <!-- .grid -->
			
		</div> <!-- .container -->
		
	</div> <!-- #content -->

	<c:set var="pagescript">
	<script>
		$(function () {
			$('#goforward').live ('click', function (e) {
				e.preventDefault ();
				$.alert ({ 
					type: 'confirm'
					, title: 'Подтверждение'
					, text: '<p>Вы уверены что хотите записать данные? Будет создана новая копия БД, старые данные можно будет просмотреть, но не вернуться к ним!</p>'
					, callback: function () { window.location = "importextstep2.jsp"; }	
				});		
			});
			
			$('#goback').click(function () { window.location = "importext.jsp"; });
		});
	</script>
	</c:set>
<%@ include file='h_quicknav.jsp'%>
