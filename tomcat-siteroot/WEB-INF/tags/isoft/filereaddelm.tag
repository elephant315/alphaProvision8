<%@ attribute name="read" required="true" %>
<%@ attribute name="delm" required="true" %>
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


String filecont = null;

BufferedReader reader = null;

try
{
 reader = new BufferedReader(new FileReader(read));

 String currentLine = null;
 while ((currentLine = reader.readLine()) != null)
 {
   filecont=filecont+delm+currentLine;
   }

jspContext.setAttribute("current", filecont);


}

catch( IOException ioEx )
{
  // Report error or do something
}

finally
{
  try
  {
    if (reader!=null)
    {
      reader.close();
    }
  }

  catch( IOException ioEx )
  {
    // Finished with file so ignore this exception
  }
}



%>


<jsp:doBody/>
