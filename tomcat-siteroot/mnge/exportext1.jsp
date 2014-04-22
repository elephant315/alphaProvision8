<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Экспорт внутренних номеров</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-17">
					
				<div class="widget">
					
					<div class="widget-header">
						<span class="icon-cog-alt"></span>
						<h3 class="icon aperture">Экспорт</h3>
					</div> <!-- .widget-header -->
					
					<div class="widget-content">
						<div class="field-group">
							<label for="template">Результат:</label>
							<div class="field">
								<c:choose>
									<c:when test="${param.branch == 'all_offices'}">
										<sql:query dataSource="${databas}" var="getExt">
										select * from extensionsorg_${G_org}_${G_ver} order by extension ASC
										</sql:query>
									</c:when>
									<c:otherwise>
										<sql:query dataSource="${databas}" var="getExt">
										select * from extensionsorg_${G_org}_${G_ver} where branchid =? order by extension ASC
										<sql:param value="${param.branch}"/>
										</sql:query>
									</c:otherwise>
								</c:choose>
										<c:forEach items="${getExt.rows}" var="gex">
										<c:set var="res" value="${param.template}"/>
											<c:set var="res">${fn:replace(res, '*name*', gex.name)}</c:set>
											<c:set var="res">${fn:replace(res, '*secondname*', gex.secondname)}</c:set>
											<c:set var="res">${fn:replace(res, '*extension*', gex.extension)}</c:set>
												<sql:query dataSource="${databas}" var="getExtParam">
													select extensionparams_${G_org}_${G_ver}.paramvalue, params.param from extensionparams_${G_org}_${G_ver},params where
													extensionparams_${G_org}_${G_ver}.extenid =? and params.id = extensionparams_${G_org}_${G_ver}.paramid
												<sql:param value="${gex.id}"/>
												</sql:query>
													<c:forEach items="${getExtParam.rows}" var="gexp">
														<c:set var="tpr">*${gexp.param}*</c:set>
														<c:set var="res">${fn:replace(res, tpr, gexp.paramvalue)}</c:set>
													</c:forEach>
											<c:set var="eresult">${eresult}${newline}${res}</c:set>
										</c:forEach>
								<textarea name="template" id="template" rows="20" cols="80">${eresult}</textarea>
							</div>		
						</div> <!-- .field-group -->
					</div> <!-- .widget-content -->
					
				</div> <!-- .widget -->	
			</div> <!-- .grid -->
			
			<div class="grid-7">
				

				<div id="gettingStarted" class="box">
					<h3>Скачать шаблоны</h3>
					<ul class="bullet secondary">
						<li><a href="javascript:;">Пример -</a></li>
						<li><a href="javascript:;">Пример -</a></li>
					</ul>
				</div>
					
			</div> <!-- .grid -->
			
		</div> <!-- .container -->
		
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>