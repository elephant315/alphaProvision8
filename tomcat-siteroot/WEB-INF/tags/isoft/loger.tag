<%@ attribute name="l1" required="true" type="javax.sql.DataSource"%>
<%@ attribute name="l2" required="true" %>
<%@ attribute name="l3m" required="true" %>
<%@ attribute name="l3e" required="true" %>
<%@ attribute name="l3u" required="true" %>
<%@ attribute name="l4" required="true" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>
<c:choose>
	<c:when test="${fn:length(l4) > 254}">
		<c:set var="messagefield">bigmessage</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="messagefield">message</c:set>
	</c:otherwise>
</c:choose>
<sql:update dataSource="${l1}">
INSERT logs (macaddr,ext,org,${messagefield},username)
VALUES (?,?,?,?,?)
	<sql:param value="${l3m}"/>
	<sql:param value="${l3e}"/>
	<sql:param value="${l2}"/>
	<sql:param value="${l4}"/>
	<sql:param value="${l3u}"/>
</sql:update>
<jsp:doBody/>
