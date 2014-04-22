<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='__app.jsp'%>

		<c:set var="newline" value="<%= \"\n\" %>" />
		<c:set var="newliner" value="<%= \"\r\" %>" />
		
		
	<c:if test="${! empty param.startadd}">
		<form action="import_params_y.jsp?startadd=1" method="post" enctype="multipart/form-data">
		<input type="file" name="file0" size="50" />
		<br />
		<input type="submit" value="Upload File" />
		</form>
		<isoft:readupload var="paramscsv"/>
		<c:set var="g0" value="${fn:split(paramscsv, newline)}" scope="session" />
		<strong>Found: ${fn:length(g0)-1} device in CSV</strong> <br/>
			<c:forEach items='${g0}' var="g1" begin="0">
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
				<c:forEach items='${g0}' var="c">
						<c:if test="${c != newliner}">
						<c:set var="c" value="${fn:replace(c, newliner, '')}"/>
						<c:if test="${fn:replace(c, ' ', '') != ''}">
						<c:if test="${fn:startsWith(c, ';') == false}">
						<c:if test="${fn:startsWith(c, '#') == false}">
						 <c:if test="${fn:containsIgnoreCase(c, '[')}"><c:set var="pcat" value="${c}"/></c:if>
							<c:if test="${(! empty pcat) and (fn:containsIgnoreCase(c, '[') == false) }">
								<c:set var="parname" value="${fn:substringBefore(c, ' =')}"/>
								<c:choose>
								<c:when test="${parname == 'path'}"><c:set var="partype" value="${fn:substringAfter(c, '= ')}"/></c:when>
								<c:otherwise>
									<c:set var="defvalue" value="${fn:substringAfter(c, '= ')}"/>
									*${partype}*${pcat}*${parname}*${defvalue}*<br/>
									<sql:update dataSource="${databas}">
										insert into params (manufacturer,path,type,param,defval)
										values ('Yealink',?,?,?,?)
									<sql:param value="${fn:trim(partype)}"/>
									<sql:param value="${fn:trim(pcat)}"/>
									<sql:param value="${fn:trim(parname)}"/>
									<sql:param value="${fn:trim(defvalue)}"/>
									</sql:update>
								</c:otherwise>
								</c:choose>
							</c:if>

						</c:if>
						</c:if>
						</c:if>
						</c:if>
				</c:forEach>
			<c:remove var="g0" scope="session"/>
		</c:if>
	
	
<%--- 
	<sql:update dataSource="${databas}">
	truncate table devices
	</sql:update>---%>
	
  </body>
</html>
