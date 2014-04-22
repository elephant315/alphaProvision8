<%@ attribute name="value" required="true" %>
<%@ attribute name="action" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 


<%@ tag 
import="java.util.Arrays"
import="org.apache.commons.codec.binary.Base64"
%>


<%
String res64 = "none";


if (action == "encode") {
	res64 = Base64.encodeBase64String(value.getBytes());
}	
if (action == "decode") {
	res64 = new String(Base64.decodeBase64(value));
}	
// Returning back values      
jspContext.setAttribute("current", res64);	  

%>

<jsp:doBody/>