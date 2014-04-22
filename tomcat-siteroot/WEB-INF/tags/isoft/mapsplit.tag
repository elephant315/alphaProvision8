<%@ attribute name="key" required="true" %>
<%@ attribute name="keyval" required="true" %>
<%@ attribute name="delm1" required="true" %>
<%@ attribute name="delm2" required="true" %>
<%@ attribute name="sortedmap" required="true" type="java.util.SortedMap[]" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>

<%@ tag import="java.util.Map"%>
<%@ tag import="java.util.SortedMap"%>
<%@ tag import="java.util.Collection"%>

<c:set var="current">
<c:forEach items="${sortedmap}" var="sm" varStatus="status"><c:if test="${! empty sm[keyval]}">${sm[key]}${delm2}${sm[keyval]}${not status.last ? delm1 : ''}</c:if></c:forEach>
</c:set>
