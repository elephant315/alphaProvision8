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

<jsp:doBody/>