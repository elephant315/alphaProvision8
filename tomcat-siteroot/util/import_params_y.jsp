<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='__app.jsp'%>


<c:set var="newline" value="<%= \"\n\" %>" />
<c:set var="newliner" value="<%= \"\r\" %>" />
<c:set var="tabulator" value="<%= \"\t\" %>" />

	<c:if test="${! empty param.startadd}">
		<form action="import_params_y.jsp?startadd=1" method="post" enctype="multipart/form-data">
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
								<a href="import_params_y.jsp?doadd=yes">Continue...</a>
								</c:if>
	</c:if>	
		
		<c:if test="${! empty param.doadd}">
		
		<c:choose>
			<c:when test="${fn:contains(g0[0],tabulator)}">
				<c:set var="sdelm" value="${tabulator}"/>
				Tab delmitter found, switch to tab<br/>
			</c:when>
			<c:otherwise>
				<c:set var="sdelm" value=";"/>
			</c:otherwise>
		</c:choose>
		
			<c:forEach items='${g0}' var="g1" begin="1">
					<c:if test="${g1 != newliner}">
					<c:set var="g1" value="${fn:replace(g1, newliner, '')}"/>
					<c:if test="${fn:replace(g1, ' ', '') != ''}">
					<c:if test="${fn:startsWith(g1, ';') == false}">
					<c:if test="${fn:startsWith(g1, '#') == false}">
					<c:set var="g2" value="${fn:split(g1, sdelm)}"/>
					<c:if test="${fn:length(g2) == 8}">
							<c:set var="importDEVICE" value="${fn:trim(g2[0])}"/>
							<c:set var="importNICE"	 value="${fn:trim(g2[1])}"/>
							<c:set var="importTYPE"	 value="${fn:trim(g2[2])}"/>
							<c:set var="importPARAM"	 value="${fn:trim(g2[3])}"/>
							<c:set var="importDEFVALUE" value="${fn:trim(g2[4])}"/>
								<c:if test="${importDEFVALUE == 'empty'}"><c:set var="importDEFVALUE" value=""/></c:if>
							<c:set var="importDEPENDENCY" value="${fn:trim(g2[5])}"/>
								<c:if test="${importDEPENDENCY == 'empty'}"><c:set var="importDEPENDENCY" value=""/></c:if>
							<c:set var="importRGEXP" value="${fn:trim(g2[6])}"/>
							<c:set var="importPARAMDESCR" value="${fn:trim(g2[7])}"/>
								<sql:query dataSource="${databas}" var="checkAvail">
									select id from params where param=?
									<sql:param value="${importPARAM}"/>
								</sql:query>
									<c:choose>
										<c:when test="${checkAvail.rowCount == 0}">
											<sql:update dataSource="${databas}">
												INSERT INTO 
												  params
												(device,nice,type,param,defval,dependency,rgexp,paramdescr)
												
												VALUES (?,?,?,?,?,?,?,?);

												<sql:param value="${importDEVICE}"/>
												<sql:param value="${importNICE}"/>
												<sql:param value="${importTYPE}"/>
												<sql:param value="${importPARAM}"/>
												<sql:param value="${importDEFVALUE}"/>
												<sql:param value="${importDEPENDENCY}"/>
												<sql:param value="${importRGEXP}"/>
												<sql:param value="${importPARAMDESCR}"/>
											</sql:update>
												<c:set var="macinserted" value="${macinserted+1}"/>
										</c:when>
										<c:otherwise><c:set var="macdoubled" value="${macdoubled}${importMAC};"/></c:otherwise>
									</c:choose>
					</c:if>
					</c:if>
					</c:if>
					</c:if>
					</c:if>
			</c:forEach>
			Inserted: ${macinserted} <br/>
			Params doubled: ${macdoubled} <c:if test="${empty macdoubled}">everything unique</c:if><br/>
	

			<c:remove var="g0" scope="session"/>
		</c:if>
	
	
	
  </body>
</html>
