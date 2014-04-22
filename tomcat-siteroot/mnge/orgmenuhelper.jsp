<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.extbranch}" var="chkid1"/>
<c:if test="${chkid1 == 'true'}">
	<sql:query dataSource="${databas}" var="lex">
		select extensionsorg_${G_org}_${G_ver}.*,activation.deviceid from 
		extensionsorg_${G_org}_${G_ver},activation where extensionsorg_${G_org}_${G_ver}.branchid = ? 
		and extensionsorg_${G_org}_${G_ver}.id = activation.extid
		and activation.orgid = ${G_org} 
		order by extensionsorg_${G_org}_${G_ver}.extension ASC
	 <sql:param value="${param.extbranch}"/>
	</sql:query>
	<ul id="filter_list1">	
		<c:forEach items="${lex.rows}" var="lx">
			<li><a href="extension.jsp?id=${lx.id}&enleftnav=yes" class="${! empty lx.deviceid ? 'blue' : ''}">${lx.extension}&nbsp; ${lx.name}&nbsp;${lx.secondname}</a></li>
		</c:forEach>
	</ul>
</c:if>
