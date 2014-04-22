<%@ attribute name="read" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 
<% response.setContentType( "text/html; charset=utf-8" ); %>
<% request.setCharacterEncoding("utf-8");%>
 
<%@ tag
import="java.util.*"
import="java.io.*"
import="java.lang.String.*"
import="javax.servlet.jsp.*" 
%>


<%

StringBuffer fileData = new StringBuffer(1000);
     BufferedReader reader = new BufferedReader(new FileReader(read));
     char[] buf = new char[1024];
     int numRead=0;
     while((numRead=reader.read(buf)) != -1){
         String readData = String.valueOf(buf, 0, numRead);
         fileData.append(readData);
         buf = new char[1024];
     }
     reader.close();
jspContext.setAttribute("current", fileData.toString());     

%>


<jsp:doBody/>
