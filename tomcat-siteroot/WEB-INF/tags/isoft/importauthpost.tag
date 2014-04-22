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
<%@ tag import="org.apache.http.message.BasicNameValuePair"%>

<%@ tag import="org.apache.http.client.methods.HttpPost"%>
<%@ tag import="org.apache.http.NameValuePair"%>
<%@ tag import="org.apache.http.client.entity.UrlEncodedFormEntity"%>
<%@ tag import="java.util.ArrayList"%>
<%@ tag import="java.util.List"%>
<c:catch var="ahaha">
<%
DefaultHttpClient httpclient = new DefaultHttpClient();
try
{
	HttpPost httppost = new HttpPost(url);
    httpclient.getCredentialsProvider().setCredentials(
            new AuthScope(server, 80),
            new UsernamePasswordCredentials(login, pwd));

		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);

		nameValuePairs.add(new BasicNameValuePair("PAGEID","16"));
		nameValuePairs.add(new BasicNameValuePair("CONFIG_DATA","AUTOPROVISION NOWþþ1þhttp://config.isoft.kzþþ********þ********þ0þyealink"));
		httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
		
	
	ResponseHandler<String> responseHandler = new BasicResponseHandler();
	String responseBody = httpclient.execute(httppost, responseHandler);
	jspContext.setAttribute("current", "reboot");
	
} 
finally {httpclient.getConnectionManager().shutdown();
}

%>
</c:catch><c:if test="${! empty ahaha}">
<c:set var="current" value="${ahaha}"/></c:if>
<jsp:doBody/>

