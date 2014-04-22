<%@ attribute name="value" required="true" %>
<%@ attribute name="key" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 


<%@ tag 
import="java.security.*"
import="javax.crypto.*"
import="javax.crypto.spec.*"
import="java.io.*"
%>


<%
String toencrypt = value;

		byte[] raw=key.getBytes("UTF-8");
		
	    SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");

		Cipher cipher = Cipher.getInstance("AES");

		cipher.init(Cipher.ENCRYPT_MODE, skeySpec);

		byte[] encrypted = cipher.doFinal(toencrypt.getBytes("UTF-8"));
		
		
// Returning back values      
String s = new String(encrypted, "ISO-8859-1");
jspContext.setAttribute("current", s);	  

%>

<jsp:doBody/>