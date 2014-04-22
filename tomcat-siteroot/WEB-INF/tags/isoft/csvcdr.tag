<%@ attribute name="csv" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true"%>
<%@ variable name-from-attribute="var" alias="sortcurrent" variable-class="java.util.ArrayList" scope="AT_END" %> 

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>

<%@ tag import="au.com.bytecode.opencsv.CSVReader"%>
<%@ tag import="au.com.bytecode.opencsv.CSVWriter"%>

<%@ tag import="java.io.StringReader"%>
<%@ tag import="java.io.IOException"%>
<%@ tag import="java.io.StringWriter"%>
<%@ tag import="java.util.List"%>

<%@ tag import="java.util.SortedMap"%>
<%@ tag import="java.util.Map"%>
<%@ tag import="java.util.TreeMap"%>
<%@ tag import="java.util.ArrayList"%>

<%
	ArrayList result= new ArrayList();	
	
	CSVReader reader = new CSVReader(new StringReader(csv));
	String [] nextLine;
	while ((nextLine = reader.readNext()) != null) {
		SortedMap<String,String> sm=new TreeMap<String, String>();
		
		sm.put("accountcode", nextLine[0]);
		sm.put("src", nextLine[1]);
		sm.put("dst", nextLine[2]);
		sm.put("dcontext", nextLine[3]);
		sm.put("clid", nextLine[4]);
		sm.put("channel", nextLine[5]);
		sm.put("dstchannel", nextLine[6]);
		sm.put("lastapp", nextLine[7]);
		sm.put("lastdata", nextLine[8]);
		sm.put("start", nextLine[9]);
		sm.put("answer", nextLine[10]);
		sm.put("end", nextLine[11]);
		sm.put("duration", nextLine[12]);
		sm.put("billsec", nextLine[13]);
		sm.put("disposition", nextLine[14]);
		sm.put("amaflags", nextLine[15]);
		sm.put("uniqueid", nextLine[16]);
		result.add(sm);
	}
   
	jspContext.setAttribute("sortcurrent", result); 
%>


<jsp:doBody/>







