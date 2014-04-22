<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='__app.jsp'%>
<c:set var="viewname" value="import_dev_pre"/>
<%-- List --%>
		<c:if test="${param.action=='view'}">
			<c:choose>
			<c:when test="${empty param.search}">
				<sql:query dataSource="${databas}" var="viewall">select * from predevices order by id asc</sql:query>
			</c:when>
			<c:otherwise>
				<sql:query dataSource="${databas}" var="viewall">select * from predevices where macaddr = ? order by id asc
				<sql:param value="${param.search}"/>
				</sql:query>
			</c:otherwise>
			</c:choose>
			<sql:query dataSource="${databas}" var="getfields">
				show fields from predevices
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
								<td>${a[xc]}</td>
							</c:forEach>
						</tr>
					</c:forEach>
					</tbody>
				</table>

		</c:if>

<c:if test="${! empty param.startadd}">
pre-provision devices importer

<c:set var="newline" value="<%= \"\n\" %>" />
<c:set var="newliner" value="<%= \"\r\" %>" />

		<form action="import_dev_pre.jsp?startadd=1" method="post" enctype="multipart/form-data">
		<input type="file" name="file0" size="50" />
		<br />
		<input type="submit" value="Upload File" />
		</form>

		<isoft:readupload var="devicecsv" varform="temp_"/>
		<c:set var="g0" value="${fn:split(devicecsv, newline)}" scope="session" />
		<strong>Found: ${fn:length(g0)-1} device in CSV</strong> <br/>
			<c:forEach items='${g0}' var="g1" begin="1">
				<table>
					<tr>
						<td><c:set var="cc" value="${cc+1}"/>${cc}</td>
						<td>${g1}</td>
					</tr>
				</table>
			</c:forEach>
								<c:if test="${fn:length(g0) > 1}">
								<a href="import_dev_pre.jsp?doadd=yes">Continue...</a>
								</c:if>
		</c:if>	
		
		<c:if test="${! empty param.doadd}">
			<c:forEach items='${g0}' var="g1" begin="1">
					<c:if test="${g1 != newliner}">
					<c:set var="g1" value="${fn:replace(g1, newliner, '')}"/>
					<c:if test="${fn:replace(g1, ' ', '') != ''}">
					<c:if test="${fn:startsWith(g1, ';') == false}">
					<c:if test="${fn:startsWith(g1, '#') == false}">
					<c:set var="g2" value="${fn:split(g1, ';')}"/>
					<c:if test="${fn:length(g2) == 2}">
							<c:set var="importMAC"		 value="${fn:trim(g2[0])}"/>
							<c:set var="importPROSERVER"	 value="${fn:trim(g2[1])}"/>
							<isoft:regexp pat="^[0-9-a-zA-Z]{1,29}+$" value="${importMAC}" var="chkmac1"/>
							<isoft:regexp pat="^[0-9-a-zA-Z .:/]{1,29}+$" value="${importPROSERVER}" var="chksrv1"/>
							<c:if test="${(chkmac1 == 'true') and (chksrv1 == 'true')}">
								<sql:query dataSource="${databas}" var="checkAvail">
									select id from predevices where macaddr=?
									<sql:param value="${importMAC}"/>
								</sql:query>
									<c:choose>
										<c:when test="${checkAvail.rowCount == 0}">
											<sql:update dataSource="${databas}">
												insert into predevices(macaddr,proserver)
												values (?,?)
												<sql:param value="${importMAC}"/>
												<sql:param value="${importPROSERVER}"/>
											</sql:update>
												<c:set var="macinserted" value="${macinserted+1}"/>
										</c:when>
										<c:otherwise>
											<c:set var="macdoubled" value="${macdoubled}${importMAC};"/>
											<sql:update dataSource="${databas}">
												update predevices set  proserver = ?
												where macaddr = ?
												<sql:param value="${importPROSERVER}"/>
												<sql:param value="${importMAC}"/>
											</sql:update>
										</c:otherwise>
									</c:choose>
							</c:if>
					</c:if>
					</c:if>
					</c:if>
					</c:if>
					</c:if>
			</c:forEach>
			Inserted: ${macinserted} <br/>
			Updated: ${macdoubled} <c:if test="${empty macdoubled}">everything unique</c:if><br/>
	
			
			<c:remove var="g0" scope="session"/>
</c:if>
	
  </body>
</html>
