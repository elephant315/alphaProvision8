<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
<c:if test="${! empty GT_importbranches}">
<c:set var="new_G_ver" value="yes" scope="session"/>
<c:import url="subver.jsp"/>
	<c:catch var="catch1">
		<c:forEach items='${GT_importbranches}' var="i1" begin="1">
			<c:set var="i1" value="${fn:replace(i1, newliner, '')}"/>
			<c:set var="i2" value="${fn:split(i1, ';')}"/>
				<c:set value="${fn:trim(i2[0])}" var="importName"/>
				<c:set value="${fn:trim(i2[1])}" var="importCity"/>
				<c:set value="${fn:trim(i2[2])}" var="importAddr"/>
				<c:set value="${fn:trim(i2[3])}" var="importTechPer"/>
				<c:set value="${fn:trim(i2[4])}" var="importTechTel"/>
				<isoft:genpwd var="newae" type="strings" length="16" />
					<sql:transaction dataSource="${databas}">
						<sql:update>
						insert into branchesorg_${G_org}_${G_ver} (name,city,addr,techperson,techtel,aeskey)
						values (?,?,?,?,?,?)
							<sql:param value="${importName}" />
							<sql:param value="${importCity}" />
							<sql:param value="${importAddr}" />
							<sql:param value="${importTechPer}" />
							<sql:param value="${importTechTel}" />
							<sql:param value="${newae}" />
						</sql:update>
					</sql:transaction>
		</c:forEach>	
	</c:catch>
</c:if>
		
	<div id="content">
		
		<div id="contentHeader">
			<h1>Импорт офисов</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
				<div class="widget">
						<div class="widget-header">
							<span class="icon-info"></span>
							<h3 class="icon aperture">Результат импорта</h3>
						</div> <!-- .widget-header -->

						<div class="widget-content">
							<p>
								<c:choose>
									<c:when test="${(! empty catch1) or (empty GT_importbranches)}">
										<p><strong>Произошла ошибка записи в БД:</strong> <br/> ${catch1} <c:if test="${empty GT_importbranches}"> Нечего записывать </c:if></p>
									</c:when>
									<c:otherwise>
										<p><strong>Данные импортированны удачно!</strong></p>
									</c:otherwise>
								</c:choose>
								<c:remove var="GT_importbranches" scope="session"/>	
							</p>
						</div> <!-- .widget-content -->
					</div> <!-- .widget -->	
			</div> <!-- .grid -->
		</div> <!-- .container -->
		
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>