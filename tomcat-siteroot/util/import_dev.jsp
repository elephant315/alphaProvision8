<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='__app.jsp'%>


<c:set var="newline" value="<%= \"\n\" %>" />
<c:set var="newliner" value="<%= \"\r\" %>" />

	<c:if test="${! empty param.startadd}">
		<form action="import_dev.jsp?startadd=1" method="post" enctype="multipart/form-data">
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
								<a href="import_dev.jsp?doadd=yes">Continue...</a>
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
					<c:if test="${fn:length(g2) != 5}"><c:set var="canimport" value="false"/><c:set var="err" value="${err}line ${g1[0]} less than 5 columns!"/></c:if>
					<c:if test="${fn:length(g2) == 5}">
						<c:set var="importMAC"		 value="${fn:trim(g2[0])}"/>
						<c:set var="importSERIAL"	 value="${fn:trim(g2[1])}"/>
						<c:set var="importMANUF"	 value="${fn:trim(g2[2])}"/>
						<c:set var="importMODEL"	 value="${fn:trim(g2[3])}"/>
						<c:set var="importSHIPORDER" value="${fn:trim(g2[4])}"/>
						<c:set var="canimport" value="true"/>
						<isoft:regexp pat="^[0-9-a-zA-Z]{1,29}+$" value="${importMAC}" var="chkmac1"/>
						<isoft:regexp pat="^[0-9-a-zA-Z -_]{1,29}+$" value="${importSERIAL}" var="chkser1"/>
						<isoft:regexp pat="^[0-9-a-zA-Z -_]{1,29}+$" value="${importMANUF}" var="chkmanuf1"/>
						<isoft:regexp pat="^[0-9-a-zA-Z -_]{1,29}+$" value="${importMODEL}" var="chkmodel1"/>
						<isoft:regexp pat="^[0-9]{1,29}+$" value="${importSHIPORDER}" var="chkship1"/>
							<c:if test="${chkmac1 == 'false'}"><c:set var="canimport" value="false"/><c:set var="err" value="${err}line ${importMAC} error in: mac;"/></c:if>
							<c:if test="${chkser1 == 'false'}"><c:set var="canimport" value="false"/><c:set var="err" value="${err}line ${importMAC} error in: serial;"/></c:if>
							<c:if test="${chkmanuf1 == 'false'}"><c:set var="canimport" value="false"/><c:set var="err" value="${err}line ${importMAC} error in: manuf.;"/></c:if>
							<c:if test="${chkmodel1 == 'false'}"><c:set var="canimport" value="false"/><c:set var="err" value="${err}line ${importMAC} error in: model;"/></c:if>
							<c:if test="${chkship1 == 'false'}"><c:set var="canimport" value="false"/><c:set var="err" value="${err}line ${importMAC} error in: ship(org);"/></c:if>
							
							<c:choose>
							<c:when test="${chkship1 == 'true'}">
								<sql:query dataSource="${databas}" var="checkOrg">
									select id from orgs where id=?
									<sql:param value="${importSHIPORDER}"/>
								</sql:query>
								<c:if test="${checkOrg.rowCount != 1}"><c:set var="canimport" value="false"/><c:set var="err" value="${err}line ${importMAC} error org not found;"/></c:if>
							</c:when>
							<c:otherwise><c:set var="canimport" value="false"/></c:otherwise>
							</c:choose>
							
							<c:if test="${canimport == 'true'}">
								<sql:query dataSource="${databas}" var="checkAvail">
									select id from devices where macaddr=?
									<sql:param value="${importMAC}"/>
								</sql:query>
									<c:choose>
										<c:when test="${checkAvail.rowCount == 0}">
											<isoft:genpwd var="genExtension" type="numbers" length="8" />
											<isoft:genpwd var="genPWD" type="strings" length="16" />
											<isoft:genpwd var="genAES" type="strings" length="16" />
											<sql:update dataSource="${databas}">
												insert into devices(macaddr,provisionextension,provisionpassword,aeskey,statusflag,serial,shiporder,manufacturer,model)
												values (?,?,?,?,0,?,?,?,?)
												<sql:param value="${importMAC}"/>
												<sql:param value="${genExtension}"/>
												<sql:param value="${genPWD}"/>
												<sql:param value="${genAES}"/>
												<sql:param value="${importSERIAL}"/>
												<sql:param value="${importSHIPORDER}"/>
												<sql:param value="${importMANUF}"/>
												<sql:param value="${importMODEL}"/>
											</sql:update>
												<c:set var="macinserted" value="${macinserted+1}"/>
										</c:when>
										<c:otherwise><c:set var="macdoubled" value="${macdoubled+1}"/>
												<sql:update dataSource="${databas}">
													update devices set serial=?,shiporder=?,manufacturer=?,model=?
													where macaddr=?
													<sql:param value="${importSERIAL}"/>
													<sql:param value="${importSHIPORDER}"/>
													<sql:param value="${importMANUF}"/>
													<sql:param value="${importMODEL}"/>
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
	
			<c:choose>
			<c:when test="${macinserted >= 1}">
				<c:set var="newline" value="<%= \"\n\" %>" />
				<c:set var="newliner" value="<%= \"\r\" %>" />
				<isoft:filereadcr read="/siteroot/templates/default/templateSipDefault.txt" var="templ"/>
					<sql:query dataSource="${databas}" var="getall">select * from devices</sql:query>
					<c:set var="sipconf" value="" />
						<c:forEach items="${getall.rows}" var="q">
							<c:set var="a">${fn:replace(templ, '*extension*', q.provisionextension)}</c:set>
							<c:set var="a">${fn:replace(a, '*secret*', q.provisionpassword)}</c:set>
							<c:set var="sipconf" value="${sipconf}${a}${newline}${newline}"/>
						</c:forEach>
	
	
			<isoft:filesave write="/etc/asterisk/sip_isoft.conf" content="${sipconf}"/>
			File writed <br/>
			<isoft:runcmd var="h" value="sudo /etc/init.d/asterisk restart">${h}<br/></isoft:runcmd>	
			</c:when>
			<c:otherwise>Nothing to do <br/></c:otherwise>
			</c:choose>
			
			<c:remove var="g0" scope="session"/>
		</c:if>
	
	
  </body>
</html>
