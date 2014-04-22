<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

<c:if test="${empty databasp}">
<sql:setDataSource var="databasp" driver="com.mysql.jdbc.Driver"
   url="jdbc:mysql://localhost/isoft_config?autoReconnect=true&useUnicode=true&characterEncoding=UTF8&useOldAliasMetadataBehavior=true"
   user="*user*"  password="*pwd*" scope="session" />
</c:if>
<%--PLEASE CHANGE THIS ID FOR CORRESPONDING ORGANIZATION--%>
<c:set var="G_org" value="1"/>
<%--------------------------------------------------------%>

<sql:query dataSource="${databasp}" var="getsubver">
	select id from subversion where orgid = ? order by id desc LIMIT 0,1
	<sql:param value="${G_org}"/>
</sql:query>
<c:set var="G_ver" value="${getsubver.rows[0].id}"/>

<%--FORM SECURITY CHECK--%>
<c:set var="locstr" value="error.jsp"/>
<c:set var="locflag" value="0"/>

<c:forEach var="stest" items="<%=request.getParameterNames()%>">
	<c:set var="stest_val" value="${param[stest]}"/>
		
	<c:set var="sym_bad1" value="'"/>
	<c:set var="sym_bad2" value='"'/>
	<c:set var="sym_bad3" value='./'/>
	<c:set var="sym_bad4" value='\.'/>
	
	<c:set var="sym_bad5" value='<'/>
	<c:set var="sym_bad7" value='${'/>
	<c:set var="sym_bad8" value='$}'/>
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
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad7) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>		
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad8) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>	
	<c:if test="${fn:containsIgnoreCase(param[stest],sym_bad9) == true}">
		<c:set var="locflag" value="1"/>
	</c:if>

</c:forEach>

<c:if test="${(locflag == 1) and (empty param.dptext)}">
<c:redirect url="${locstr}"/>
</c:if> 
<%--END OF FORM SECURITY CHECK--%>

