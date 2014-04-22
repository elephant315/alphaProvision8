<%@ page contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%  request.setCharacterEncoding("ISO-8859-1"); %>
<%  response.setCharacterEncoding("ISO-8859-1"); %>
<c:set var="preserver"><%= request.getLocalAddr()%></c:set>
<c:set var="preserverport">5060</c:set>