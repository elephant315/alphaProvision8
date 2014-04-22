<%@ attribute name="write" required="true" %>
<%@ attribute name="content" required="true" %>
<% response.setContentType( "text/html; charset=utf-8" ); %>
<% request.setCharacterEncoding("utf-8");%> 
 
<%@ tag
import="java.util.*"
import="java.io.*"
import="java.lang.String.*"
import="javax.servlet.jsp.*" 
%>


<%
      
          //      FileOutputStream fos = new FileOutputStream(write);
          //     DataOutputStream dos = new DataOutputStream(fos);
          //     dos.writeChars(content);
               

//PrintWriter outa = new PrintWriter(new FileOutputStream(write, "UTF-8"));
//outa.println(content);
//outa.close();

 PrintWriter writer = new PrintWriter(new OutputStreamWriter(new FileOutputStream(write), "UTF-8"));
            writer.println(content);
            writer.close();
            BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(write),"UTF-8"));
            String s = reader.readLine();
            writer.close();
		 
%>
<jsp:doBody/>
