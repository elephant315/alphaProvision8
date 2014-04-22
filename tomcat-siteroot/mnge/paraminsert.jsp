<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:if test="${(! empty param.action) and (! empty param.newparam) and (! empty param.id) }">
<c:if test="${param.action == 'extension'}">
	<c:set var="action" value="extensionsorg"/>
	<c:set var="a1" value="extensionparams"/>
	<c:set var="a2" value="extenid"/>
	</c:if>
<c:if test="${param.action == 'branch'}">
	<c:set var="action" value="branchesorg"/>
	<c:set var="a1" value="branchparams"/>
	<c:set var="a2" value="branchid"/>
	</c:if>
	<c:catch var="catch1">
		<sql:query dataSource="${databas}" var="chk1">
		select id,defval,dependency from params where id=? and nice > 0
		<sql:param value="${param.newparam}"/>
		</sql:query>
			<c:if test="${(chk1.rowCount ==1) and (! empty action) }">
				<sql:query dataSource="${databas}" var="chk2">
				select id from ${action}_${G_org}_${G_ver} where id=?
				<sql:param value="${param.id}"/>
				</sql:query>
					<c:if test="${chk2.rowCount == 1}">
						<c:set var="paramid" value="${chk1.rows[0].id}"/>
						<c:set var="paramdefval" value="${chk1.rows[0].defval}"/>
						<c:set var="pdept" value="${fn:split(chk1.rows[0].dependency,';')}"/>
						<c:set var="extid" value="${chk2.rows[0].id}"/>
							<sql:query dataSource="${databas}" var="chk3">
							select id from ${a1}_${G_org}_${G_ver} where paramid=? and ${a2}=?
							<sql:param value="${paramid}"/>
							<sql:param value="${extid}"/>
							</sql:query>
								<c:if test="${chk3.rowCount == 0}">
									<sql:update dataSource="${databas}">
										insert into ${a1}_${G_org}_${G_ver} (paramid,paramvalue,${a2})
										values (?,?,?)
										<sql:param value="${paramid}"/>
										<sql:param value="${paramdefval}"/>
										<sql:param value="${extid}"/>
									</sql:update>
										<c:forEach items="${pdept}" var="pd">
											<sql:query dataSource="${databas}" var="chk4">
											select id from ${a1}_${G_org}_${G_ver} where paramid=? and ${a2}=?
											<sql:param value="${pd}"/>
											<sql:param value="${extid}"/>
											</sql:query>
											<sql:query dataSource="${databas}" var="chk5">
											select id,defval,dependency from params where id=? and nice > 0
											<sql:param value="${pd}"/>
											</sql:query>
												<c:if test="${(chk4.rowCount == 0) and (chk5.rowCount == 1)}">
													<sql:update dataSource="${databas}">
														insert into ${a1}_${G_org}_${G_ver} (paramid,paramvalue,${a2})
														values (?,?,?)
														<sql:param value="${chk5.rows[0].id}"/>
														<sql:param value="${chk5.rows[0].defval}"/>
														<sql:param value="${extid}"/>
													</sql:update>
												</c:if>
										</c:forEach>
								</c:if>
					</c:if>
			</c:if>
	</c:catch>${catch1}
	<c:redirect url="${param.action}.jsp?id=${param.id}"/>
</c:if>
		
