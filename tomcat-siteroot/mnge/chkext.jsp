<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.branch}" var="chkbr1"/>	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Проверка внутренних номеров</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
			<c:choose>
				<c:when test="${(chkbr1 == 'true')}">
					<div class="widget">
							<div class="widget-header">
								<span class="icon-info"></span>
								<h3 class="icon aperture">Результат</h3>
							</div> <!-- .widget-header -->
							<div class="widget-content">
							<sql:query dataSource="${databas}" var="getBr">
								select id,name from branchesorg_${G_org}_${G_ver}
							</sql:query>
							<c:forEach items="${getBr.rows}" var="gb">		
								<sql:query dataSource="${databas}" var="getExt">
									select id,extension,name,secondname from extensionsorg_${G_org}_${G_ver} where branchid=?
								 <sql:param value="${gb.id}"/>
								</sql:query>
									<c:if test="${getExt.rowCount > 0}">
										<c:choose>
											<c:when test="${fn:substring(getExt.rows[0].extension,0,1) < 7}">
												<c:set var="ei" value="2"/>
											</c:when>
											<c:otherwise>
												<c:set var="ei" value="3"/>
											</c:otherwise>
										</c:choose>
										<c:set var="pref">${fn:substring(getExt.rows[0].extension,0,ei)}</c:set>
										<strong>${pref}&nbsp;${gb.name}</strong><br/>
										<c:forEach items="${getExt.rows}" var="che">
											<c:if test="${fn:substring(che.extension,0,ei) != pref}">
											<font color="red">
											${che.extension}&nbsp;${che.name}&nbsp;${che.secondname}<br/></font>
											</c:if>
										</c:forEach><hr/>
									</c:if>
								</c:forEach>
							</div> <!-- .widget-content -->
						</div> <!-- .widget -->
				</c:when>
				<c:otherwise>
				<form class="form uniformForm" action="chkext.jsp?branch=999" method="post">	
				<div class="widget">
					
					<div class="widget-header">
						<span class="icon-cog-alt"></span>
						<h3 class="icon aperture">Выполнить проверку номеров</h3>
					</div> <!-- .widget-header -->
					
					<div class="widget-content">
						<div class="field-group">
							
							
						</div> <!-- .field-group -->
						<div class="actions">
								<button type="submit" class="btn btn-primary">Проверка</button>
						</div>
					</div> <!-- .widget-content -->
					
				</div> <!-- .widget -->
				</form>
				</c:otherwise>
			</c:choose>	
			</div> <!-- .grid -->
			
			
			
		</div> <!-- .container -->
		
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>