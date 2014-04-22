<%@ attribute name="value" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="NESTED" %> 

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
 
<%@ tag import="java.io.*" %>
<c:catch>
<%
String output = "";
String s = "";


// run the Unix "ps -ef" command
        // using the Runtime exec method:
        Process p = Runtime.getRuntime().exec(value);
        
        BufferedReader stdInput = new BufferedReader(new 
             InputStreamReader(p.getInputStream()));

        BufferedReader stdError = new BufferedReader(new 
             InputStreamReader(p.getErrorStream()));

        // read the output from the command
        while ((s = stdInput.readLine()) != null) {
            output+=s+'\n';
        }
		output+="------------------\n";
		while ((s = stdError.readLine()) != null) {
            output+=s+'\n';
        }
jspContext.setAttribute("current", output);	  

%>
</c:catch>
<jsp:doBody/>