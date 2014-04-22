<%@ attribute name="url" required="true" %>
<%@ attribute name="server" required="true" %>
<%@ attribute name="login" required="true" %>
<%@ attribute name="pwd" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<%@ tag import="org.apache.http.HttpResponse"%>
<%@ tag import="org.apache.http.auth.AuthScope"%>
<%@ tag import="org.apache.http.auth.UsernamePasswordCredentials"%>
<%@ tag import="org.apache.http.client.methods.HttpGet"%>
<%@ tag import="org.apache.http.impl.client.DefaultHttpClient"%>
<%@ tag import="org.apache.http.client.ResponseHandler"%>
<%@ tag import="org.apache.http.client.HttpClient"%>
<%@ tag import="org.apache.http.impl.client.BasicResponseHandler"%>

<c:catch var="ahaha">
<%
DefaultHttpClient httpclient = new DefaultHttpClient();
try
{

    httpclient.getCredentialsProvider().setCredentials(
            new AuthScope(server, 80),
            new UsernamePasswordCredentials(login, pwd));
	//String url = "http://192.168.130.139/cgi-bin/cgiServer.exx?msgSendMessage(%22autoServer%22,%220xA0000%22,%220%22,%220%22)";

	HttpGet httpget = new HttpGet(url);
	
	ResponseHandler<String> responseHandler = new BasicResponseHandler();
	String responseBody = httpclient.execute(httpget, responseHandler);
	jspContext.setAttribute("current", responseBody);
	
} 
finally {httpclient.getConnectionManager().shutdown();
}

%>
</c:catch>
<c:set var="current" value="${ahaha}"/>
<jsp:doBody/>

