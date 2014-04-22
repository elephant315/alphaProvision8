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
String todecrypt = value;

		byte[] raw=key.getBytes("UTF-8");
		
	    SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");

		Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");

		cipher.init(Cipher.DECRYPT_MODE, skeySpec);

		byte[] original = cipher.doFinal(todecrypt.getBytes("ISO-8859-1"));
	
	    String originalString = new String(original, "UTF-8");
	       
// Returning back values      

jspContext.setAttribute("current", originalString);	  

%>

<jsp:doBody/>