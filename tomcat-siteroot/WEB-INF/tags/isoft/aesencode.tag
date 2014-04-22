<%@ attribute name="value" required="true" %>
<%@ attribute name="key" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 


<%@ tag 
import="java.security.*"
import="javax.crypto.*"
import="javax.crypto.spec.*"
import="java.io.*"
import="org.apache.commons.codec.binary.Base64"
%>


<%
String toencrypt = value;

		byte[] raw=key.getBytes("UTF-8");
		
	    SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");

		Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");

		cipher.init(Cipher.ENCRYPT_MODE, skeySpec);

		byte[] encrypted = cipher.doFinal(toencrypt.getBytes("UTF-8"));
				
// Returning back values      
String base64String = Base64.encodeBase64String(encrypted);
jspContext.setAttribute("current", base64String);	  

%>

<jsp:doBody/>