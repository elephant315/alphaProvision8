<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 
<%@ attribute name="varform" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="varform" alias="current2" variable-class="java.lang.String" scope="AT_END" %>
<% response.setContentType( "text/html; charset=utf-8" ); %>
<% request.setCharacterEncoding("utf-8");%>
 
<%@ tag
import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.servlet.ServletFileUpload, org.apache.commons.fileupload.disk.DiskFileItemFactory, org.apache.commons.io.FilenameUtils, java.util.*, java.io.File, java.lang.Exception"
%>

<%
if (ServletFileUpload.isMultipartContent(request)){
  ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());
  List fileItemsList = servletFileUpload.parseRequest(request);

  String parfva = "";
  String optionalFileName = "";
  FileItem fileItem = null;

  Iterator it = fileItemsList.iterator();
  while (it.hasNext()){
    FileItem fileItemTemp = (FileItem)it.next();
    if (fileItemTemp.isFormField()){

      if (fileItemTemp.getFieldName().equals("filename"))
        optionalFileName = fileItemTemp.getString();

		//chg1
		parfva = parfva + "&"+ fileItemTemp.getFieldName()+"="+fileItemTemp.getString();
		//eof

    }
    else
      fileItem = fileItemTemp;
  }

  if (fileItem!=null){
    String fileName = fileItem.getName();

jspContext.setAttribute("current", fileItem.getString("UTF-8")); 
jspContext.setAttribute("current2", parfva); 

    /* Save the uploaded file if its size is greater than 0. */
    if (fileItem.getSize() > 0){
      if (optionalFileName.trim().equals(""))
        fileName = FilenameUtils.getName(fileName);
      else
        fileName = optionalFileName;

      String dirName = "/siteroot/temp/";

      File saveTo = new File(dirName + fileName);
      try {
       // fileItem.write(saveTo);

      }
      catch (Exception e){
////
      }
    }
  }
}
%>

<jsp:doBody/>
