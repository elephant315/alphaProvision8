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
<c:if test="${param.superpwd=='superpwd'}"><c:set var="Gutilauth" value="ok" scope="session"/></c:if>
<c:if test="${empty Gutilauth}">
 <c:redirect url="/errors/error-404.html" />
</c:if>
<c:if test="${empty databas}">
<sql:setDataSource var="databas" driver="com.mysql.jdbc.Driver"
   url="jdbc:mysql://localhost/isoft_config?autoReconnect=true&useUnicode=true&characterEncoding=UTF8"
   user="*user*"  password="*pwd*" scope="session" />
</c:if>

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

<c:if test="${locflag == 1}">
<c:redirect url="${locstr}"/>
</c:if> 
<%--END OF FORM SECURITY CHECK--%>

<html>
	<head>
		<title>utils.</title>
		<link rel="stylesheet" href="stylesheets/all.css" type="text/css" />
	</head>
	<body>
<div id="wrapper">
	<div id="header">
		<h1></h1>		
		
		<a href="javascript:;" id="reveal-nav">
			<span class="reveal-bar"></span>
			<span class="reveal-bar"></span>
			<span class="reveal-bar"></span>
		</a>
	</div> <!-- #header -->
<c:choose>
	<c:when test="${(pageContext.request.servletPath == '/util/import_dev_pre.jsp') or (pageContext.request.servletPath == '/util/services.jsp')}">
		
	</c:when>
	<c:otherwise>
	<div id="sidebar">		

			<ul id="mainNav">
				<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/util/import_dev.jsp' ? 'active' : ''}">
					<span class="icon-home"></span>
					<a href="import_dev.jsp?startadd=yes">import dev  </a>
				</li>
				<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/util/orgs.jsp' ? 'active' : ''}">
					<span class="icon-home"></span>
					<a href="orgs.jsp?action=view">orgs</a>				
				</li>
				<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/util/params.jsp' ? 'active' : ''}">
					<span class="icon-home"></span>
					<a href="params.jsp?action=view">params</a>				
				</li>
				<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/util/users.jsp' ? 'active' : ''}">
					<span class="icon-home"></span>
					<a href="users.jsp?action=view">users</a>				
				</li>
			</ul>

		</div> <!-- #sidebar -->

	</c:otherwise>
</c:choose>
		<div id="content">		

			<div id="contentHeader">
				<h1>Utils</h1>
			</div> <!-- #contentHeader -->	

			<div class="container">


				<div class="grid-24">

					<div class="widget widget-plain">