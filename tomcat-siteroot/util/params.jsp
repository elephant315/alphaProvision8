<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='__app.jsp'%>


<c:set var="viewname" value="params"/>

<%-- List --%>
		<c:if test="${param.action=='view'}">
			<c:choose>
			<c:when test="${empty param.search}">
				<sql:query dataSource="${databas}" var="viewall">select * from params order by id asc</sql:query>
			</c:when>
			<c:otherwise>
				<sql:query dataSource="${databas}" var="viewall">select * from params where name = ? order by id asc
				<sql:param value="${param.search}"/>
				</sql:query>
			</c:otherwise>
			</c:choose>
			<sql:query dataSource="${databas}" var="getfields">
				show fields from params
			</sql:query>
			
				<table class="table">
					<thead>
					<tr>	
						<c:forEach items="${getfields.rows}" var="gf">
						<c:set var="xc">${gf.COLUMN_NAME}</c:set>
							<c:if test="${! fn:endsWith(xc, 'descr')}"><th>${xc}</th></c:if>
						</c:forEach>
					</tr>
					</thead>
					<tbody>
					<c:forEach items="${viewall.rows}" var="a">
						<tr class="gradeA">
							<c:forEach items="${getfields.rows}" var="gf">
							<c:set var="xc">${gf.COLUMN_NAME}</c:set>
								${fn:endsWith(xc, "descr") ? '<br/>' : '<td><b>'}
									${a[xc]}
										<c:if test="${xc == 'id'}">
											<a name="${a[xc]}">.</a>
											<a href="${viewname}.jsp?action=update&id=${a.id}">update</a>
											<a href="${viewname}.jsp?action=custom&id=${a.id}">custom</a>
										</c:if> 
								${(xc == 'path') or (xc == 'type') or (xc == 'param') ? '</b>' : '</td>'}
							</c:forEach>
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
					<label for="required">type:</label>
					<div class="field">
						<input type="text" name="type" id="required" size="20" class="validate[type]" />
					</div>
				</div> <!-- .field-group -->
				<div class="actions">
					<button type="submit" class="btn btn-error" name="action" value="newexec">Test Validation</button>
				</div> <!-- .actions -->
			</form>
		</c:if>
<%-- Update --%>
		<c:if test="${param.action=='update'}">
		
		<sql:query dataSource="${databas}" var="getfields">
			show fields from params
		</sql:query>
		
		<sql:query dataSource="${databas}" var="updateload">
			select * from params where id=?
			<sql:param value="${param.id}"/>
		</sql:query>
			<form class="form uniformForm validateForm">
				<div class="field-group">
					<c:forEach items="${getfields.rows}" var="gf">
						<c:set var="xc">${gf.COLUMN_NAME}</c:set>
							<c:choose>
								<c:when test="${(xc == 'id') or (xc == 'path') or (xc == 'type') or (xc == 'param')}">
								<br><strong>${xc}</strong> = ${updateload.rows[0][xc]}<br/>
								</c:when>
								<c:otherwise>
									<label for="required">${xc}:</label>
									<div class="field">
										<input type="text" name="dyn_${xc}" id="required" size="20" class="validate[${xc}]" value="${updateload.rows[0][xc]}" />
									</div>
								</c:otherwise>
							</c:choose>
					</c:forEach>
				</div> <!-- .field-group -->
				<div class="actions">
					<input type="hidden" name="id" value="${updateload.rows[0].id}"/>
					<button type="submit" class="btn btn-error" name="action" value="updateexec">Test Validation</button>
				</div> <!-- .actions -->
			</form>
			nice vars = 0 - disabled, 1 - required basic, 2 - extra features, 3 - diffucult, 4 - hardcore configs, 5 - unknown
		</c:if>
<%-- Delete --%>
		<c:if test="${param.action=='delete'}">
			<sql:update dataSource="${databas}">
			delete from [table] where id=?
			<sql:param value="${param.id}"/>
			</sql:update>
			<c:redirect url="${viewname}.jsp?action=view"/>	
		</c:if>
<%-- NewExec --%>
		<c:if test="${(param.action=='newexec') and (param.name != '') and (param.type != '')}">
		 	<sql:query dataSource="${databas}" var="chkupd1">
				select id from params where param = ?
			 <sql:param value="${param.name}"/>
			</sql:query>
				<c:choose>
					<c:when test="${chkupd1.rowCount == 0}">
						<sql:update dataSource="${databas}">
						insert into params (param,type)
						values (?,?)
						<sql:param value="${param.name}"/>
						<sql:param value="${param.type}"/>
						</sql:update>
						<c:redirect url="${viewname}.jsp?action=view"/>
					</c:when>
					<c:otherwise>
						param already exist!
					</c:otherwise>
				</c:choose>
		</c:if>
<%-- NewUpdate --%>
		<c:if test="${param.action=='updateexec'}">
			<sql:update dataSource="${databas}">
			update params set 
				<c:forEach var="stest" items="<%=request.getParameterNames()%>" varStatus="status">
				 	<c:if test="${fn:startsWith(stest,'dyn_')}">
						<c:set var="dynf">${fn:substringAfter(stest, "dyn_")}</c:set>
						${dynf}='${fn:trim(param[stest])}' ${not status.last ? ',' : ''}
					</c:if>
				</c:forEach>
			where id=?
			<sql:param value="${param.id}"/>
			</sql:update>		
			<c:redirect url="${viewname}.jsp?action=view#${param.id}"/>	
		</c:if>
<%-- CUSTOM --%>
		<c:if test="${param.action=='custom'}">
			<sql:query dataSource="${databas}" var="getPD">
				select dependency from params where id=?
				<sql:param value="${param.id}"/>
			</sql:query>
			<c:set var="pd">${getPD.rows[0].dependency}</c:set>
			<sql:query dataSource="${databas}" var="getAllPD">
				select id,type,param from params
			</sql:query>
				<c:forEach items="${getAllPD.rows}" var="apd">
					${apd.type} - ${apd.param} 
					<c:if test="${(fn:contains(pd,apd.id) == 'false') and (apd.id != param.id)}"><a href="${viewname}.jsp?action=customadd&id=${param.id}&dep=${apd.id}">add</a></c:if><br/>
				</c:forEach>
		</c:if>
		
		<c:if test="${param.action=='customadd'}">
			<sql:query dataSource="${databas}" var="getPD">
				select dependency from params where id=?
				<sql:param value="${param.id}"/>
			</sql:query>
			<c:set var="pd">${getPD.rows[0].dependency}</c:set>
			<c:if test="${fn:length(pd) >0 }"><c:set var="pdelm">;</c:set></c:if>
			<sql:update dataSource="${databas}" var="getAllPD">
				update params set dependency = ?
				where id = ?
				<sql:param value="${pd}${pdelm}${param.dep}"/>
				<sql:param value="${param.id}"/>
			</sql:update>
			<c:redirect url="${viewname}.jsp?action=custom&id=${param.id}"/>
		</c:if>
<%-- CUSTOM --%>
	</body>
</html>
