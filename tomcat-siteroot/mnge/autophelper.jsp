<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:choose>
	<c:when test="${fn:contains(param.model,'-T3')}">
		<isoft:importauth url="http://${param.clientip}/cgi-bin/cgiServer.exx?msgSendMessage(%22autoServer%22,%220xA0000%22,%220%22,%220%22)" server="${param.clientip}" login="admin" pwd="2030" var="iru"/>
			<c:choose>
				<c:when test="${iru == 'org.apache.http.client.ClientProtocolException'}">
					запрос отправлен, устройство обновляется!
				</c:when>
				<c:otherwise>
					${iru}
				</c:otherwise>
			</c:choose>
	</c:when>
	<c:when test="${fn:contains(param.model,'-T2')}">
		<isoft:importauthpost url="http://${param.clientip}/cgi-bin/ConfigManApp.com" server="${param.clientip}" login="admin" pwd="2030" var="iru"/>
			<c:choose>
				<c:when test="${iru == 'reboot'}">
					запрос отправлен, устройство обновляется!
				</c:when>
				<c:otherwise>
					${iru}
				</c:otherwise>
			</c:choose>
	</c:when>
	<c:otherwise>
		данное оборудование не поддерживается!
	</c:otherwise>
</c:choose>
