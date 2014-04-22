<%@ attribute name="template" required="true" %>
<%@ attribute name="params" required="true" %>
<%@ attribute name="delm1" required="true" %>
<%@ attribute name="delm2" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>


<%@ tag import="java.io.File"%>
<%@ tag import="net.sf.jtpl.Template"%>
<%@ tag import="java.util.regex.Pattern"%>
<%@ tag import="java.util.regex.Matcher"%>

<%
String key[];

Template tpl;
tpl = new Template(new File(template));

String values[]=params.split(delm1);
for (int i = 0; i < values.length; i++) {
	key = values[i].split(delm2);
	tpl.assign(key[0], key[1]);
}

tpl.parse("main");
String ready =  tpl.out();

//String pattern = "\\{[^}]*\\}";
//ready =  ready.replaceAll(pattern,"");

jspContext.setAttribute("ready", ready);
%>

<c:set var="newline" value="<%= \"\n\" %>" />
<c:set var="newliner" value="<%= \"\r\" %>" />
<c:forEach items="${fn:split(ready,newline)}" var="s">
	<c:if test="${(! fn:contains(s,'{')) and (! fn:startsWith(s,'#')) and (! fn:startsWith(s,';'))}">
		<c:set var="current">${current}${newline}${s}</c:set>
	</c:if>
</c:forEach>

<jsp:doBody/>