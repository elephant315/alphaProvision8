<%@ attribute name="type" required="true" %>
<%@ attribute name="length" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 


<%@ tag import="org.apache.commons.lang3.RandomStringUtils;"%>


<%
String newpwd = "Unknown type";
Integer i = Integer.parseInt(length);

if (type == "numbers"){
newpwd = RandomStringUtils.random(1,"2345678") + RandomStringUtils.randomNumeric(i-1);
}
if (type == "strings"){
newpwd = RandomStringUtils.randomAlphanumeric(i);
}

jspContext.setAttribute("current", newpwd.toLowerCase());	  

%>

<jsp:doBody/>