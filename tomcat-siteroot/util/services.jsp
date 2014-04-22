<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='__app.jsp'%>

		<c:set var="newline" value="<%= \"\n\" %>" />
		<c:set var="newliner" value="<%= \"\r\" %>" />
		
<c:if test="${param.service == 'aster_start'}">
<isoft:runcmd var="h" value="sudo /etc/init.d/asterisk start">${h}<br/></isoft:runcmd>
</c:if>
<c:if test="${param.service == 'aster_stop'}">
<isoft:runcmd var="h" value="sudo /etc/init.d/asterisk stop">${h}<br/></isoft:runcmd>
</c:if>

<c:if test="${param.service == 'proxy_start'}">
<isoft:runcmd var="h" value="sudo /etc/init.d/proxyman start">${h}<br/></isoft:runcmd>
</c:if>
<c:if test="${param.service == 'proxy_stop'}">
<isoft:runcmd var="h" value="sudo /etc/init.d/proxyman stop">${h}<br/></isoft:runcmd>
</c:if>

<c:if test="${param.service == 'ssh_start'}">
<isoft:runcmd var="h" value="sudo /etc/init.d/ssh start">${h}<br/></isoft:runcmd>
</c:if>
<c:if test="${param.service == 'ssh_stop'}">
<isoft:runcmd var="h" value="sudo /etc/init.d/ssh stop">${h}<br/></isoft:runcmd>
</c:if>

<isoft:runcmd var="r" value="ps -Af">
	<c:if test="${fn:contains(r,'asterisk')}">Asterisk running <a href="services.jsp?service=aster_stop">stop</a></c:if><br/>
	<c:if test="${fn:contains(r,'python')}">proxyman running <a href="services.jsp?service=proxy_stop">stop</a></c:if><br/>
	<c:if test="${fn:contains(r,'/usr/sbin/sshd')}">SSH running <a href="services.jsp?service=ssh_stop">stop</a></c:if><br/>
	
	<c:if test="${fn:contains(r,'asterisk') == 'false'}">Asterisk stopped <a href="services.jsp?service=aster_start">start</a></c:if><br/>
	<c:if test="${fn:contains(r,'python') == 'false'}">proxyman stopped <a href="services.jsp?service=proxy_start">start</a></c:if><br/>
	<c:if test="${fn:contains(r,'/usr/sbin/sshd') == 'false'}">SSH stopped <a href="services.jsp?service=ssh_start">start</a></c:if><br/>
</isoft:runcmd>

  </body>
</html>
