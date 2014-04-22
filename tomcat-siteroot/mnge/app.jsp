<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jstl/xml_rt" prefix="x" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib prefix="isoft" tagdir="/WEB-INF/tags/isoft" %>
<%  request.setCharacterEncoding("UTF-8"); %>
<%  response.setCharacterEncoding("UTF-8"); %>
<fmt:requestEncoding value="UTF-8" />   
<%-- default application jsp --%>
<c:if test="${empty databas}">
<sql:setDataSource var="databas" driver="com.mysql.jdbc.Driver"
   url="jdbc:mysql://localhost/isoft_config?autoReconnect=true&useUnicode=true&characterEncoding=UTF8"
   user="*user*"  password="*pwd*" scope="session" />
</c:if>

<c:if test="${(empty G_userid) or (empty G_username) or (empty G_userlogin) or (empty G_userlevel) or (empty G_org) or (empty G_orgname)}">
<c:redirect url="login.jsp"/>
</c:if>

<c:if test="${empty G_ver}">
<sql:query dataSource="${databas}" var="getsubver">
select id from subversion where orgid = ? order by id desc LIMIT 0,1
<sql:param value="${G_org}"/>
</sql:query>
<c:set var="G_ver" value="${getsubver.rows[0].id}" scope="session"/>
</c:if>

<c:if test="${G_ver == ''}">
<c:redirect url="login.jsp"/>
</c:if>


<%--FORM SECURITY CHECK--%>
<c:set var="locstr" value="/errors/error-503.html"/>
<c:set var="locflag" value="0"/>
<c:set var="sym_bad_slash" value="<%= \"\b\" %>" />
<c:forEach var="stest" items="<%=request.getParameterNames()%>">
<c:if test="${stest != 'xmldata'}">
	<c:set var="stest_val" value="${param[stest]}"/>
		
	<c:set var="sym_bad1" value="'"/>
	<c:set var="sym_bad2" value='"'/>
	<c:set var="sym_bad3" value='./'/>
	<c:set var="sym_bad4" value="${sym_bad_slash}"/>
	
	<c:set var="sym_bad5" value='<'/>
	<c:set var="sym_bad6" value=';;'/>
	<c:set var="sym_bad7" value='{disabled'/>
	<c:set var="sym_bad8" value='}disabled'/>
	<c:set var="sym_bad9" value='<script>'/>
    			
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad1) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad2) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>	
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad3) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad4) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>		
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad5) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>		
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad6) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>		
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad7) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>		
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad8) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>	
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad9) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>
</c:if>
</c:forEach>

<c:if test="${locflag == 1}">
<c:redirect url="${locstr}"/>
</c:if> 
<%--END OF FORM SECURITY CHECK--%>
<c:set var="newline" value="<%= \"\n\" %>" />
<c:set var="newliner" value="<%= \"\r\" %>" />