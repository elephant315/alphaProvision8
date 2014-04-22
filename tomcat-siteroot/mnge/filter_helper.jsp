<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:choose>
	<c:when test="${! empty param['new_filter']}">
		<c:set var="filter_val_temp" value="${param['new_filter']}" scope="session"/>
	</c:when>
	<c:otherwise>
		<c:remove var="filter_val_temp" scope="session"/>
	</c:otherwise>
</c:choose>