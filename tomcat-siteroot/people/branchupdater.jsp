<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>



<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.id}" var="chkid1"/>
<c:if test="${(chkid1 == 'true') and ((param.action=='ping') or (param.action=='runsyncman') or (param.action=='rebootpbx'))}">
	<sql:query dataSource="${databasp}" var="branch">
	select lastip from branchesorg_${G_org}_${G_ver} where id=?
		<sql:param value="${param.id}"/>
	</sql:query>
		
		<c:set var="blastip" value="${branch.rows[0].lastip}"/>
		<c:if test="${param.action == 'ping'}"><c:set var="comm">ping -c 5 ${blastip}</c:set></c:if>

		Выполненние комманды ${param.action}
		<hr/>
		<isoft:runcmd var="r" value="${comm}">
		<textarea rows="10" cols="100">${r}</textarea>
		</isoft:runcmd>
</c:if>
