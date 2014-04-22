<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>

<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я .+,-]{3,1000}+$" value="${param.search}" var="chksh1"/>


<c:set var="pageheader">
					<style>
					#searchb {
						background: #FFFFFF;
						width: 80%;
						min-height: 28px;
					}
					h2 { font-size: 18px; color: #F90; border-bottom: 1px dotted #CCC; padding-bottom: 4px; margin-bottom: 1em; }
					</style>
</c:set>
<%@ include file='h_menu.jsp'%>


	<div id="content">
		
		<div id="contentHeader">
			<h1>Поиск</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
				
				<div class="widget widget-plain">
					<div class="widget-header">
					<span class="icon-layers"></span>
					<h3>поиск</h3>
					</div>
					
					<div class="widget-content">
						<p>Поиск осуществляется по mac, IP, серийному #, номерам преднастройки (A-1234567), имени и фамилии, а также внутреннему номеру.</p>
						<label for="searchb"> </label>
						<form method="post" action="search.jsp">
							<input id="searchb" value="${param.search}" name="search"/>
							<button class="btn btn-primary" id="gosearch">искать</button>
						</form>
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
		<c:choose>
		<c:when test="${chksh1 == 'true'}">
				<div class="widget widget-plain">
					<div class="widget-content">
						<sql:query dataSource="${databas}" var="ds">
							select * from devices where shiporder = ? and 
							(macaddr like '%${param.search}%' or provisionextension like '%${param.search}%' or lastip like '%${param.search}%'  or serial like '%${param.search}%')
							<sql:param value="${G_org}" />
						</sql:query>
								<c:choose>
									<c:when test="${ds.rowCount > 0}">
									<h2> Результаты, найдено в устройствах: ${ds.rowCount}</h2>
										<div class="widget widget-table">
											<div class="widget-header">
												<span class="icon-list"></span>
												<h3 class="icon aperture">Найдено</h3>
											</div> <!-- .widget-header -->
											<%@ include file='devicelisthelper.jsp'%>
										</div>
									</c:when>
									<c:otherwise>

									</c:otherwise>
								</c:choose>
						<sql:query dataSource="${databas}" var="getExt">
						select extensionsorg_${G_org}_${G_ver}.*, activation.deviceid, activation.code
								from extensionsorg_${G_org}_${G_ver},activation
								 where extensionsorg_${G_org}_${G_ver}.id = activation.extid
								and activation.orgid = ${G_org}
								 and (extensionsorg_${G_org}_${G_ver}.name like '%${param.search}%' or 
									extensionsorg_${G_org}_${G_ver}.secondname like '%${param.search}%' or
									extensionsorg_${G_org}_${G_ver}.extension like '%${param.search}%'
									)
						</sql:query>
							<c:choose>
								<c:when test="${getExt.rowCount > 0}">
									<h2> Результаты, найдено в  организации: ${getExt.rowCount}</h2>
									<div class="widget widget-table">
										<div class="widget-header">
											<span class="icon-list"></span>
											<h3 class="icon aperture">Найдено</h3>
										</div> <!-- .widget-header -->
										<%@ include file='orglisthelper.jsp'%>
									</div>
								</c:when>
								<c:otherwise>
								
								</c:otherwise>
							</c:choose>
							
							<c:if test="${(getExt.rowCount == 0) and (ds.rowCount ==0)}">
							<div class="notify notify-info">
													<a href="javascript:;" class="close">&times;</a>
													<h3>Ничего не найдено</h3>
													<p>Попробуйте упростить поиск.</p>
												</div> <!-- .notify -->
							</c:if>
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
</c:when>
<c:otherwise>
	<div class="notify notify-warning">
							<a href="javascript:;" class="close">&times;</a>
							<h3>Ошибка поиска</h3>
							<p>Введена не корректная фраза для поиска. Недопустимые символы или длина меньше трех символов.</p>
						</div> <!-- .notify -->	
</c:otherwise>
</c:choose>
				
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->

		
<%@ include file='h_quicknav.jsp'%>