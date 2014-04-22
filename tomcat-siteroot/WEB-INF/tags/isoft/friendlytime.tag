<%@ tag pageEncoding="UTF-8" %>
<%  request.setCharacterEncoding("UTF-8"); %>
<%  response.setCharacterEncoding("UTF-8"); %>
<%@ attribute name="time" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>

<%@ tag import="java.util.Calendar"%>
<%@ tag import="java.text.SimpleDateFormat"%>
<%@ tag import="java.text.ParseException"%>
<%@ tag import="java.text.*"%>
<%@ tag import="java.util.Date"%>
<%@ tag import="java.lang.String.*"%>

<c:catch>
<%
DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Date dob1 = df.parse(time);

Calendar clok  = Calendar.getInstance();
clok.setTime(dob1);
Calendar clok_  = Calendar.getInstance();
clok_.getTime();

long clok__ = clok_.getTimeInMillis() - clok.getTimeInMillis() ;
int clok_2__ = (int)clok__ / 1000;
clok_2__ = clok_2__ /60;

String results = Integer.toString(clok_2__);
jspContext.setAttribute("current", results);
%>

<c:choose>
	<c:when test="${current < 0}">
		больше трех дней
	</c:when>
	<c:when test="${current < 5}">
		пару минут назад
	</c:when>
	<c:when test="${current < 10}">
		десять минут назад
	</c:when>
	<c:when test="${current < 20}">
		около получаса назад
	</c:when>
	<c:when test="${current < 60}">
		около часа назад
	</c:when>
	<c:when test="${current < 180}">
		несколько часов
	</c:when>
	<c:when test="${current < 640}">
		около 6-ти часов
	</c:when>
	<c:when test="${current < 1440}">
		в районе суток
	</c:when>
	<c:when test="${current < 2880}">
		несколько дней назад
	</c:when>
	<c:otherwise>
		больше двух дней
	</c:otherwise>
</c:choose>
</c:catch>
<jsp:doBody/>