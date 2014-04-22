<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>
<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.bid}" var="chkbid"/>
<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.mapx}" var="chkmapx"/>
<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.mapy}" var="chkmapy"/>

<c:if test="${(chkbid == 'true') and (chkmapx == 'true') and (chkmapy == 'true')}">

	<sql:query dataSource="${databasp}" var="getExts">
	select id from extensionsorg_${G_org}_${G_ver} where branchid = ?
		<sql:param value="${param.bid}"/>
	</sql:query>
	<c:choose>
		<c:when test="${getExts.rowCount > 40}"><c:set var="kpisize" value="3"/><c:set var="kx" value="12"/> <c:set var="ky" value="24"/></c:when>
		<c:when test="${getExts.rowCount > 9}"><c:set var="kpisize" value="2"/> <c:set var="kx" value="8"/> <c:set var="ky" value="16"/></c:when>
		<c:otherwise><c:set var="kpisize" value="1"/>							<c:set var="kx" value="9"/> <c:set var="ky" value="17"/></c:otherwise>
	</c:choose>

	<sql:update dataSource="${databasp}">
		update branchesorg_${G_org}_${G_ver} set mapxy = '${param.mapx-kx}, ${param.mapy-ky}' where id = ?
	 <sql:param value="${param.bid}"/>
	</sql:update>
	<script>
		//alert ('Координаты заданы!')
		window.location.href = "map.jsp?fullscreen=yes&edit=yes";
	</script>
</c:if>
