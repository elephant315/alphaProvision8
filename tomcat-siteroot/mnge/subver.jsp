<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>

<c:if test="${! empty new_G_ver}">
	<c:remove var="new_G_ver" scope="session"/>
	<sql:transaction dataSource="${databas}">
		<sql:update>
		insert into subversion (orgid,vdate)
		values (?,now())
		<sql:param value="${G_org}"/>
		</sql:update>
			<sql:query var="getnewsubver">
			select id from subversion where orgid = ? order by id desc LIMIT 0,1
			<sql:param value="${G_org}"/>
			</sql:query>
				<sql:update>
				CREATE TABLE extensionparams_${G_org}_${getnewsubver.rows[0].id} LIKE extensionparams_${G_org}_${G_ver}
				</sql:update>
				<sql:update>
				INSERT INTO extensionparams_${G_org}_${getnewsubver.rows[0].id} SELECT * FROM extensionparams_${G_org}_${G_ver}
				</sql:update>
				
				<sql:update>
				CREATE TABLE extensionsorg_${G_org}_${getnewsubver.rows[0].id} LIKE extensionsorg_${G_org}_${G_ver}
				</sql:update>
				<sql:update>
				INSERT INTO extensionsorg_${G_org}_${getnewsubver.rows[0].id} SELECT * FROM extensionsorg_${G_org}_${G_ver}
				</sql:update>
				
				<sql:update>
				CREATE TABLE branchparams_${G_org}_${getnewsubver.rows[0].id} LIKE branchparams_${G_org}_${G_ver}
				</sql:update>
				<sql:update>
				INSERT INTO branchparams_${G_org}_${getnewsubver.rows[0].id} SELECT * FROM branchparams_${G_org}_${G_ver}
				</sql:update>
				
				<sql:update>
				CREATE TABLE branchesorg_${G_org}_${getnewsubver.rows[0].id} LIKE branchesorg_${G_org}_${G_ver}
				</sql:update>
				<sql:update>
				INSERT INTO branchesorg_${G_org}_${getnewsubver.rows[0].id} SELECT * FROM branchesorg_${G_org}_${G_ver}
				</sql:update>
				
		<c:set var="G_ver" value="${getnewsubver.rows[0].id}" scope="session"/>
	</sql:transaction>
</c:if>