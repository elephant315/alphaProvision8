<%@ attribute name="pat" required="true" %>
<%@ attribute name="value" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 


<%@ tag import="java.util.regex.Matcher"%>
<%@ tag import="java.util.regex.Pattern"%>

<%
String testresult="false";

Pattern pattern = Pattern.compile(pat);
		Matcher matcher = pattern.matcher(value);
		if (matcher.find()){
			testresult="true";
		} 
		
jspContext.setAttribute("current", testresult);	  

%>

<jsp:doBody/>