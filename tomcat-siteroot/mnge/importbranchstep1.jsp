<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>


<c:remove var="GT_importbranches" scope="session"/>
	<isoft:readupload var="extencsv" varform="extenformparams"/>
	<c:set var="i0" value="${fn:split(extencsv, newline)}"/>
	<c:set var="canimport" value="true"/>
		<c:if test="${fn:length(i0) <= 1}">
		<c:set var="canimport" value="false"/>
		<c:set var="fe2" value="<strong>Данные отсутствуют.</strong> <br/>"/>
		</c:if>
		
	<c:forEach items='${i0}' var="i1" begin="1">
		<c:set var="i1" value="${fn:replace(i1, newliner, '')}"/>
		<c:set var="i2" value="${fn:split(i1, ';')}"/>
			<c:choose>
				<c:when test="${fn:length(i2) != 5}">
					<c:set var="canimport" value="false"/>
					<c:set var="fe2" value="<strong>Количество полей не соответствует.</strong> <br/> Откройте файл, возможно в нем присутствуют пустные поля или CR в конце файла. <br/>"/>
				</c:when>
				<c:otherwise>
					<c:set var="fe" value=""/>
					<c:set value="${fn:trim(i2[0])}" var="importName"/>
					<c:set value="${fn:trim(i2[1])}" var="importCity"/>
					<c:set value="${fn:trim(i2[2])}" var="importAddr"/>
					<c:set value="${fn:trim(i2[3])}" var="importTechPer"/>
					<c:set value="${fn:trim(i2[4])}" var="importTechTel"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я .,-]{1,29}+$" value="${importName}" var="chkName1"/>
						<isoft:regexp pat="^[0-9]+$" value="${importName}" var="chkName2"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я .,-]{1,29}+$" value="${importCity}" var="chkCity"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я .,-]{1,29}+$" value="${importAddr}" var="chkAddr"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я ]{1,29}+$" value="${importTechPer}" var="chkTechPer"/>
						<isoft:regexp pat="^[1-9][0-9]{5,11}+$" value="${importTechTel}" var="chkTechTel"/>
						
						<c:if test="${chkName1 == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка в Названии офиса. "/>
						</c:if>
						<c:if test="${chkName2 == 'true'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} Название офиса не может содержать только цифры. "/>
						</c:if>
						<c:if test="${chkCity == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка в Городе. "/>
						</c:if>
						<c:if test="${chkAddr == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка Адреса. "/>
						</c:if>
						<c:if test="${chkTechPer == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка Имени. "/>
						</c:if>
						<c:if test="${chkTechTel == 'false'}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} ошибка в Телефоне. "/>
						</c:if>
						
						<c:set var="dcQty" value="0"/>
						<c:forEach items='${i0}' var="ii1" begin="1">
							<c:set var="ii1" value="${fn:replace(ii1, newliner, '')}"/>
							<c:set var="ii2" value="${fn:split(ii1, ';')}"/>
							<c:set value="${fn:trim(ii2[0])}" var="dcName"/>
							<c:if test="${dcName == importName}"><c:set var="dcQty" value="${dcQty+1}"/></c:if>
						</c:forEach>
						<c:if test="${dcQty > 1}">
							<c:set var="canimport" value="false"/>
							<c:set var="fe" value="${fe} повторения в файле. "/>
						</c:if>
						
						<c:if test="${chkName1 == 'true'}">
								<sql:query dataSource="${databas}" var="chk1">
								select id from branchesorg_${G_org}_${G_ver} where name = ?
								<sql:param value="${importName}"/>
								</sql:query>
									<c:if test="${chk1.rowCount != 0}">
										<c:set var="canimport" value="false"/>
										<c:set var="fe" value="${fe} повторение Имени офиса. "/>
									</c:if>
						</c:if>
							
						<c:set var="resulttable">
							${resulttable}
							<tr>	
								<td><c:choose>
										<c:when test="${empty fe}"><span class="ticket ticket-success">Удачно</span></c:when>
										<c:otherwise><span class="ticket ticket-important">${fe}</span></c:otherwise>
									</c:choose>
									</td>
								<td>${importName}</td>
								<td>${importCity}</td>
								<td>${importAddr}</td>
								<td>${importTechPer}</td>
								<td>${importTechTel}</td>
							</tr>
						</c:set>
				</c:otherwise>
			</c:choose>
	</c:forEach>	

	
	
	
	
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Импорт офисов</h1>
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
										<c:set var="GT_importbranches" value="${i0}" scope="session"/>
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
											<th>Офис</th>
											<th>Город</th>
											<th>Адрес</th>
											<th>Контакт</th>
											<th>Телефон</th>
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
					<h3>Формат данных</h3>
					<ul class="bullet secondary">
						<li>Наименование офиса</li>
						<li>Город</li>
						<li>Адрес (разрешены символы: точка, запятая и пробел)</li>
						<li>Ответственное лицо за телефонию (разрешены пробелы)</li>
						<li>Контактный телефон (только цифры)</li>
					</ul>
					<p>* Допустимые символы: A-Z, А-Я в любом регистре, и цифры. Длина полей 30 символов</p>
				</div>
				
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
					, callback: function () { window.location = "importbranchstep2.jsp"; }	
				});		
			});
			
			$('#goback').click(function () { window.location = "importbranch.jsp"; });
		});
	</script>
	</c:set>
<%@ include file='h_quicknav.jsp'%>
