<%@ attribute name="value" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 


 
<%@ tag import="java.security.MessageDigest" %>

<%

String plainText = (String)value;
MessageDigest mdAlgorithm = MessageDigest.getInstance("MD5");
mdAlgorithm.update(plainText.getBytes());

byte[] digest = mdAlgorithm.digest();
StringBuffer hexString = new StringBuffer();

for (int i = 0; i < digest.length; i++) {
    plainText = Integer.toHexString(0xFF & digest[i]);

    if (plainText.length() < 2) {
        plainText = "0" + plainText;
    }

    hexString.append(plainText);
}


String upper = hexString.toString().toUpperCase();

jspContext.setAttribute("current", upper);	  

%>

<jsp:doBody/>