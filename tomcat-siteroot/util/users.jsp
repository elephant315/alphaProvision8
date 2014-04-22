<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='__app.jsp'%>
<c:set var="viewname" value="users"/>

<%-- List --%>
		<c:if test="${param.action=='view'}">
			<c:choose>
			<c:when test="${empty param.search}">
				<sql:query dataSource="${databas}" var="viewall">select * from serverusers</sql:query>
			</c:when>
			<c:otherwise>
				<sql:query dataSource="${databas}" var="viewall">select * from serverusers where name = ? 
				<sql:param value="${param.search}"/>
				</sql:query>
			</c:otherwise>
			</c:choose>
				<table class="table table-bordered table-striped data-table">
					<thead>
					<tr>
						<th>name</th>
						<th>pwd</th>
						<th>login</th>
						<th>level</th>
						<th>orgid</th>
						<th>actions</th>
					</tr>
					</thead>
					<tbody>
					<c:forEach items="${viewall.rows}" var="a">
						<tr class="gradeA">
							<td>${a.name}</td>
							<td>${a.pwd}</td>
							<td>${a.login}</td>
							<td>${a.level}</td>
							<td>${a.orgid}</td>
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
					<label for="required">pwd:</label>
					<div class="field">
						<input type="text" name="pwd" id="required" size="20" class="validate[pwd]" />
					</div>
					<label for="required">login:</label>
					<div class="field">
						<input type="text" name="login" id="required" size="20" class="validate[login]" />
					</div>
					<label for="required">level:</label>
					<div class="field">
						<input type="text" name="level" id="required" size="20" class="validate[level]" />
					</div>
					<label for="required">orgid:</label>
					<div class="field">
						<sql:query dataSource="${databas}" var="gor">select id,name from orgs</sql:query>
							<select name="orgid" id="required">
								<c:forEach items="${gor.rows}" var="gr">
									<option value="${gr.id}">${gr.name}</option>
								</c:forEach>
							</select>
					</div>
				</div> <!-- .field-group -->
				<div class="actions">
					<button type="submit" class="btn btn-error" name="action" value="newexec">Test Validation</button>
				</div> <!-- .actions -->
			</form>
		</c:if>
<%-- Update --%>
		<c:if test="${param.action=='update'}">
		<sql:query dataSource="${databas}" var="updateload">
			select * from serverusers where id=?
			<sql:param value="${param.id}"/>
		</sql:query>
			<form class="form uniformForm validateForm">
				<div class="field-group">
					<label for="required">Name:</label>
					<div class="field">
						<input type="text" name="name" id="required" size="20" class="validate[name]" value="${updateload.rows[0].name}" />
					</div>
					<label for="required">pwd:</label>
					<div class="field">
						<input type="text" name="pwd" id="required" size="20" class="validate[pwd]" value="${updateload.rows[0].pwd}" />
					</div>
					<label for="required">login:</label>
					<div class="field">
						<input type="text" name="login" id="required" size="20" class="validate[login]" value="${updateload.rows[0].login}" />
					</div>
					<label for="required">level:</label>
					<div class="field">
						<input type="text" name="level" id="required" size="20" class="validate[level]" value="${updateload.rows[0].level}" />
					</div>
					<label for="required">orgid:</label>
					<div class="field">
						<sql:query dataSource="${databas}" var="gor">select id,name from orgs</sql:query>
							<select name="orgid" id="required">
								<c:forEach items="${gor.rows}" var="gr">
									<c:if test="${gr.id == updateload.rows[0].orgid}"><c:set var="selected" value="selected"/></c:if>
									<option value="${gr.id}" ${selected}>${gr.name}</option>
									<c:set var="selected" value=""/>
								</c:forEach>
							</select>
					</div>
				</div> <!-- .field-group -->
				<div class="actions">
					<input type="hidden" name="id" value="${updateload.rows[0].id}"/>
					<button type="submit" class="btn btn-error" name="action" value="updateexec">Test Validation</button>
				</div> <!-- .actions -->
			</form>
		</c:if>
<%-- Delete --%>
		<c:if test="${param.action=='delete'}">
			<sql:update dataSource="${databas}">
			delete from serverusers where id=?
			<sql:param value="${param.id}"/>
			</sql:update>
			<c:redirect url="${viewname}.jsp?action=view"/>	
		</c:if>
<%-- NewExec --%>
		<c:if test="${param.action=='newexec'}">
		<sql:query dataSource="${databas}" var="check1">
		select id from serverusers where name=? or login=?
		<sql:param value="${param.name}"/>
		<sql:param value="${param.login}"/>
		</sql:query>			
			<c:choose>
				<c:when test="${check1.rowCount == 0}">	
					<sql:transaction dataSource="${databas}"> 
						<sql:update>
						insert into serverusers (name,pwd,login,level,orgid)
						values (?,?,?,?,?)
						<sql:param value="${param.name}"/>
						<sql:param value="${param.pwd}"/>
						<sql:param value="${param.login}"/>
						<sql:param value="${param.level}"/>
						<sql:param value="${param.orgid}"/>
						</sql:update>
					</sql:transaction>
					<c:redirect url="${viewname}.jsp?action=view"/>	
				</c:when>
				<c:otherwise>
					We have dublication error, users ${check1.rowCount}
				</c:otherwise>
			</c:choose>
		</c:if>
<%-- NewUpdate --%>
		<c:if test="${param.action=='updateexec'}">
			<sql:update dataSource="${databas}">
			update serverusers set name=?,pwd=?,login=?,level=?,orgid=?
			where id=?
			<sql:param value="${param.name}"/>
			<sql:param value="${param.pwd}"/>
			<sql:param value="${param.login}"/>
			<sql:param value="${param.level}"/>
			<sql:param value="${param.orgid}"/>
			<sql:param value="${param.id}"/>
			</sql:update>
			<c:redirect url="${viewname}.jsp?action=view"/>	
		</c:if>
	</body>
</html>
