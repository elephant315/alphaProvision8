<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='__app.jsp'%>
<c:set var="viewname" value="orgs"/>

<%-- List --%>
		<c:if test="${param.action=='view'}">
			<c:choose>
			<c:when test="${empty param.search}">
				<sql:query dataSource="${databas}" var="viewall">select * from orgs</sql:query>
			</c:when>
			<c:otherwise>
				<sql:query dataSource="${databas}" var="viewall">select * from orgs where name = ?
				<sql:param value="${param.search}"/>
				</sql:query>
			</c:otherwise>
			</c:choose>
				<table class="table table-bordered table-striped data-table">
					<thead>
					<tr>
						<th>id</th>
						<th>name</th>
						<th>location</th>
						<th>licenses</th>
						<th>lic</th>
					</tr>
					</thead>
					<tbody>
					<c:forEach items="${viewall.rows}" var="a">
						<tr class="gradeA">
							<td>${a.id}</td>
							<td>${a.name}</td>
							<td>${a.location}</td>
							<td>${a.licenses}</td>
							<td><a href="${viewname}.jsp?action=update&id=${a.id}">update</a>
								<a href="${viewname}.jsp?action=delete&id=${a.id}">delete</a>
								</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			<hr/><a href="${viewname}.jsp?action=new">new item</a>
		</c:if>
<%-- New --%>
		<c:if test="${param.action=='new'}">
			<form class="form uniformForm validateForm">
				<div class="field-group">
					<label for="required">Name:</label>
					<div class="field">
						<input type="text" name="name" id="required" size="20" class="validate[name]" />
					</div>
					<label for="required">Location:</label>
					<div class="field">
						<input type="text" name="location" id="required" size="20" class="validate[location]" />
					</div>
					<label for="required">Licenses:</label>
					<div class="field">
						<input type="text" name="licenses" id="required" size="20" class="validate[licenses]" />
					</div
				</div> <!-- .field-group -->
				<div class="actions">
					<button type="submit" class="btn btn-error" name="action" value="newexec">Test Validation</button>
				</div> <!-- .actions -->
			</form>
		</c:if>
<%-- Update --%>
		<c:if test="${param.action=='update'}">
		<sql:query dataSource="${databas}" var="updateload">
			select * from orgs where id=?
			<sql:param value="${param.id}"/>
		</sql:query>
			<form class="form uniformForm validateForm">
				<div class="field-group">
					<label for="required">Name:</label>
					<div class="field">
						<input type="text" name="name" id="required" size="20" class="validate[name]" value="${updateload.rows[0].name}" />
					</div>
					<label for="required">Location:</label>
					<div class="field">
						<input type="text" name="location" id="required" size="20" class="validate[location]" value="${updateload.rows[0].location}"/>
					</div>
					<label for="required">Licenses:</label>
					<div class="field">
						<input type="text" name="licenses" id="required" size="20" class="validate[licenses]" value="${updateload.rows[0].licenses}"/>
					</div
				</div> <!-- .field-group -->
				<div class="actions">
					<input type="hidden" name="id" value="${updateload.rows[0].id}"/>
					<button type="submit" class="btn btn-error" name="action" value="updateexec">Test Validation</button>
				</div> <!-- .actions -->
			</form>
		</c:if>
<%-- Delete --%>
		<c:if test="${param.action=='delete'}">
			<sql:query var="getver" dataSource="${databas}">
			select id from subversion where orgid=?
			<sql:param value="${param.id}"/>
			</sql:query>
				<c:forEach items="${getver.rows}" var="a">
				<sql:update dataSource="${databas}">drop table branchesorg_${param.id}_${a.id}</sql:update>
				</c:forEach>
				<c:forEach items="${getver.rows}" var="a">
				<sql:update dataSource="${databas}">drop table branchparams_${param.id}_${a.id}</sql:update>
				</c:forEach>
				<c:forEach items="${getver.rows}" var="a">
				<sql:update dataSource="${databas}">drop table extensionparams_${param.id}_${a.id}</sql:update>
				</c:forEach>
				<c:forEach items="${getver.rows}" var="a">
				<sql:update dataSource="${databas}">drop table extensionsorg_${param.id}_${a.id}</sql:update>
				</c:forEach>
			<sql:update dataSource="${databas}">
			delete from orgs where id=?
			<sql:param value="${param.id}"/>
			</sql:update>
			
			<sql:update dataSource="${databas}">
			delete from serverusers where orgid=?
			<sql:param value="${param.id}"/>
			</sql:update>
			
			<sql:update dataSource="${databas}">
			delete from acivation where orgid=?
			<sql:param value="${param.id}"/>
			</sql:update>
			
			<sql:update dataSource="${databas}">
			delete from subversion where orgid=?
			<sql:param value="${param.id}"/>
			</sql:update>
			<c:redirect url="${viewname}.jsp?action=view"/>	
		</c:if>
<%-- NewExec --%>
<c:if test="${param.action=='newexec'}">
	<sql:query dataSource="${databas}" var="check1">
	select id from orgs where name=? 
	<sql:param value="${param.name}"/>
	</sql:query>			
	<c:choose>
		<c:when test="${check1.rowCount == 0}">	
			<sql:transaction dataSource="${databas}"> 
				<sql:update>
				insert into orgs (name,location,licenses)
				values (?,?,?)
				<sql:param value="${param.name}"/>
				<sql:param value="${param.location}"/>
				<sql:param value="${param.licenses}"/>
				</sql:update>
					
					<sql:query var="getorg">select id from orgs where name=?
					<sql:param value="${param.name}"/>
					</sql:query>
					
					<sql:update>
					insert into subversion (orgid,vdate)
					values (?,now())
					<sql:param value="${getorg.rows[0].id}"/>
					</sql:update>
					
					<sql:query var="getver">select id from subversion where orgid=?
					<sql:param value="${getorg.rows[0].id}"/>
					</sql:query>
					
					<c:set var="versub" value="${getorg.rows[0].id}_${getver.rows[0].id}"/>
					
						<isoft:filereadcr read="/siteroot/templates/default/sql_dynamic_branchesorg.txt" var="sqltempl1"/>
						<isoft:filereadcr read="/siteroot/templates/default/sql_dynamic_branchparams.txt" var="sqltempl2"/>
						<isoft:filereadcr read="/siteroot/templates/default/sql_dynamic_extensionparams.txt" var="sqltempl3"/>
						<isoft:filereadcr read="/siteroot/templates/default/sql_dynamic_extensionsorg.txt" var="sqltempl4"/>
							<c:set var="preparedynamic1">${fn:replace(sqltempl1, '*orgid*', versub)}</c:set>
						    <sql:update>${preparedynamic1}</sql:update>
							<c:set var="preparedynamic2">${fn:replace(sqltempl2, '*orgid*', versub)}</c:set>
						    <sql:update>${preparedynamic2}</sql:update>
							<c:set var="preparedynamic3">${fn:replace(sqltempl3, '*orgid*', versub)}</c:set>
						    <sql:update>${preparedynamic3}</sql:update>
							<c:set var="preparedynamic4">${fn:replace(sqltempl4, '*orgid*',versub)}</c:set>
						    <sql:update>${preparedynamic4}</sql:update>
			</sql:transaction>
			<c:redirect url="${viewname}.jsp?action=view"/>
		</c:when>
		<c:otherwise>
			We have dublication error, orgs ${check1.rowCount}
		</c:otherwise>
	</c:choose>
</c:if>
<%-- NewUpdate --%>
		<c:if test="${param.action=='updateexec'}">
			<sql:update dataSource="${databas}">
			update orgs set name=?,location=?,licenses=?
			where id=?
			<sql:param value="${param.name}"/>
			<sql:param value="${param.location}"/>
			<sql:param value="${param.licenses}"/>
			<sql:param value="${param.id}"/>
			</sql:update>
			<c:redirect url="${viewname}.jsp?action=view"/>	
		</c:if>
	</body>
</html>
