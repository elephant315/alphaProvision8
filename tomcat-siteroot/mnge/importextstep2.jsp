<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
<c:if test="${! empty GT_importext}">
<c:set var="new_G_ver" value="yes" scope="session"/>
<c:import url="subver.jsp"/>
	<c:catch var="catch1">
		<c:forEach items='${GT_importext}' var="i1" begin="1">
			<c:set var="i1" value="${fn:replace(i1, newliner, '')}"/>
			<c:set var="i2" value="${fn:split(i1, ';')}"/>
			<c:set value="${fn:trim(i2[0])}" var="importName"/>
			<c:set value="${fn:trim(i2[1])}" var="importSecondname"/>
			<c:set value="${fn:trim(i2[2])}" var="importExtension"/>
			<c:set value="${fn:trim(i2[3])}" var="importBranchID"/>
				<c:if test="${! empty GT_importBranchID}"><c:set value="${GT_importBranchID}" var="importBranchID"/></c:if>
				
				<c:choose>
					<c:when test="${fn:trim(i2[4]) != 'generated'}"><c:set value="${fn:trim(i2[4])}" var="importPwd"/></c:when>
					<c:otherwise><isoft:genpwd var="genPwd" type="strings" length="10" /><c:set value="${genPwd}" var="importPwd"/></c:otherwise>
				</c:choose>
			<c:set value="${fn:trim(i2[5])}" var="importCabin"/>
			<c:if test="${empty importCabin}"><c:set value="none" var="importCabin"/></c:if>
				
			<isoft:regexp pat="^[1-9][0-9]{0,10}+$" value="${importBranchID}" var="chkBranchID1"/>
			<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я ]{1,29}+$" value="${importBranchID}" var="chkBranchID2"/>	
			<c:choose>
				<c:when test="${chkBranchID1 == 'true'}">
					<sql:query dataSource="${databas}" var="chk2">
					select id from branchesorg_${G_org}_${G_ver} where id = ?
					<sql:param value="${importBranchID}"/>
					</sql:query>
				</c:when>
				<c:otherwise>
					<sql:query dataSource="${databas}" var="chk2">
					select id from branchesorg_${G_org}_${G_ver} where name = ?
					<sql:param value="${importBranchID}"/>
					</sql:query>
				</c:otherwise>
			</c:choose>
			
			<sql:query dataSource="${databas}" var="chkUpd">
			select id from extensionsorg_${G_org}_${G_ver} where extension = ? and branchid = ? limit 1
			<sql:param value="${importExtension}"/>
			<sql:param value="${chk2.rows[0].id}"/>
			</sql:query>
			
			<c:choose>
				<c:when test="${GT_update == 'true' and chkUpd.rowCount == 1}">
					<sql:update dataSource="${databas}">
					update extensionsorg_${G_org}_${G_ver} set name=?,secondname=?,extension =?,branchid = ?, cabin = ?
					where id = ?
						<sql:param value="${importName}" />
						<sql:param value="${importSecondname}" />
						<sql:param value="${importExtension}" />
						<sql:param value="${chk2.rows[0].id}" />
						<sql:param value="${importCabin}" />
						<sql:param value="${chkUpd.rows[0].id}" />
					</sql:update>
							<sql:transaction dataSource="${databas}">
									<sql:update>
										update extensionparams_${G_org}_${G_ver} set paramvalue=? where paramid=? and extenid=?
										<sql:param value="${importName} ${importSecondname}"/>
										<sql:param value="2"/>
										<sql:param value="${chkUpd.rows[0].id}"/>
									</sql:update>
									<sql:update>
										update extensionparams_${G_org}_${G_ver} set paramvalue=? where paramid=? and extenid=?
										<sql:param value="${importExtension}"/>
										<sql:param value="3"/>
										<sql:param value="${chkUpd.rows[0].id}"/>
									</sql:update>
									<sql:update>
										update extensionparams_${G_org}_${G_ver} set paramvalue=? where paramid=? and extenid=?
										<sql:param value="${importPwd}"/>
										<sql:param value="4"/>
										<sql:param value="${chkUpd.rows[0].id}"/>
									</sql:update>
							</sql:transaction>
				</c:when>
				<c:when test="${chkUpd.rowCount == 0}">
					<sql:transaction dataSource="${databas}">
						<sql:update>
						insert into extensionsorg_${G_org}_${G_ver} (name,secondname,extension,branchid,cabin)
						values (?,?,?,?,?)
							<sql:param value="${importName}" />
							<sql:param value="${importSecondname}" />
							<sql:param value="${importExtension}" />
							<sql:param value="${chk2.rows[0].id}" />
							<sql:param value="${importCabin}" />
						</sql:update>
						<sql:query var="geteid">
							select id from extensionsorg_${G_org}_${G_ver} where extension=? and branchid=?
							<sql:param value="${importExtension}" />
							<sql:param value="${chk2.rows[0].id}" />
						</sql:query>
						
						<c:set var="whileEMU" value="0"/>
						<c:forEach var="iia" begin="1" end="100">
							<c:choose>
								<c:when test="${whileEMU == 0}">
									<isoft:genpwd var="genActivation" type="numbers" length="5" />
										<sql:query var="chkAcode1">
										select id from activation where code = ?
										<sql:param value="${genActivation}"/>
										</sql:query>
										<c:if test="${chkAcode1.rowCount == 0}"><c:set var="whileEMU" value="1"/></c:if>
								</c:when>
								<c:otherwise>
									
								</c:otherwise>
							</c:choose>
						</c:forEach>
						
						<sql:update>
							insert into activation (code,orgid,extid)
							values (?,?,?)
							<sql:param value="${genActivation}" />
							<sql:param value="${G_org}" />
							<sql:param value="${geteid.rows[0].id}" />
						</sql:update>
									<sql:update>
										insert into extensionparams_${G_org}_${G_ver} (paramid,paramvalue,extenid)
										values (?,?,?)
										<sql:param value="1"/>
										<sql:param value="1"/>
										<sql:param value="${geteid.rows[0].id}"/>
									</sql:update>
									<sql:update>
										insert into extensionparams_${G_org}_${G_ver} (paramid,paramvalue,extenid)
										values (?,?,?)
										<sql:param value="2"/>
										<sql:param value="${importName} ${importSecondname}"/>
										<sql:param value="${geteid.rows[0].id}"/>
									</sql:update>
									<sql:update>
										insert into extensionparams_${G_org}_${G_ver} (paramid,paramvalue,extenid)
										values (?,?,?)
										<sql:param value="3"/>
										<sql:param value="${importExtension}"/>
										<sql:param value="${geteid.rows[0].id}"/>
									</sql:update>
									<sql:update>
										insert into extensionparams_${G_org}_${G_ver} (paramid,paramvalue,extenid)
										values (?,?,?)
										<sql:param value="4"/>
										<sql:param value="${importPwd}"/>
										<sql:param value="${geteid.rows[0].id}"/>
									</sql:update>
					</sql:transaction>
				</c:when>
				<c:otherwise><c:set var="import_error">${import_error} ${importExtension}</c:set></c:otherwise>
				</c:choose>
		</c:forEach>	
	</c:catch>
</c:if>
		
	<div id="content">
		
		<div id="contentHeader">
			<h1>Импорт внутренних номеров</h1>
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
									<c:when test="${(! empty catch1) or (empty GT_importext) or (!empty import_error)}">
										<p><strong>Произошла ошибка записи в БД:</strong> <br/> ${catch1} <c:if test="${empty GT_importext}"> Нечего записывать </c:if>
										<c:if test="${!empty import_error}"> Произошла ошибка добавления номеров: ${import_error} </c:if>	
										</p>
									</c:when>
									<c:otherwise>
										<p><strong>Данные импортированны удачно!</strong></p>
									</c:otherwise>
								</c:choose>
								<c:remove var="GT_importext" scope="session"/>
								<c:remove var="GT_update" scope="session"/>	
								<c:remove var="GT_importBranchID" scope="session"/>	
							</p>
						</div> <!-- .widget-content -->
					</div> <!-- .widget -->	
			</div> <!-- .grid -->
		</div> <!-- .container -->
		
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>