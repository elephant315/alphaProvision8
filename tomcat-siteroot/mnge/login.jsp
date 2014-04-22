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
<c:if test="${empty datalogin}">
<sql:setDataSource var="datalogin" driver="com.mysql.jdbc.Driver"
   url="jdbc:mysql://localhost/isoft_config?autoReconnect=true&useUnicode=true&characterEncoding=UTF8"
   user="*user*"  password="*pwd*" scope="session" />
</c:if>
<%--FORM SECURITY CHECK--%>
<c:set var="locstr" value="/errors/error-503.html"/>
<c:set var="locflag" value="0"/>

<c:forEach var="stest" items="<%=request.getParameterNames()%>">
	<c:set var="stest_val" value="${param[stest]}"/>
		
	<c:set var="sym_bad1" value="'"/>
	<c:set var="sym_bad2" value='"'/>
	<c:set var="sym_bad3" value='./'/>
	<c:set var="sym_bad4" value='\.'/>
	
	<c:set var="sym_bad5" value='<'/>
	<c:set var="sym_bad6" value=';'/>
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

</c:forEach>

<c:if test="${locflag == 1}">
<c:redirect url="${locstr}"/>
</c:if> 
<%--END OF FORM SECURITY CHECK--%>
<isoft:regexp pat="^[A-Za-z0-9]{1,29}+$" value="${param.email}" var="echk1"/>
<isoft:regexp pat="^[A-Za-z0-9]{1,29}+$" value="${param.password}" var="echk2"/>

<c:if test="${(echk1 == 'true') and (echk2 == 'true')}">
	<sql:query dataSource="${datalogin}" var="chk1">
	select * from serverusers where login=? and pwd=?
	<sql:param value="${param.email}"/>
	<sql:param value="${param.password}"/>
	</sql:query>
		<c:choose>
			<c:when test="${chk1.rowCount == 1}">
				<sql:query dataSource="${datalogin}" var="chk1org">
					select name from orgs where id = ?
				 <sql:param value="${chk1.rows[0].orgid}"/>
				</sql:query>
				<c:set var="G_userid" scope="session">${chk1.rows[0].id}</c:set>
				<c:set var="G_username" scope="session">${chk1.rows[0].name}</c:set>
				<c:set var="G_userlogin" scope="session">${chk1.rows[0].login}</c:set>
				<c:set var="G_userlevel" scope="session">${chk1.rows[0].level}</c:set>
				<c:set var="G_org" scope="session">${chk1.rows[0].orgid}</c:set>
				<c:set var="G_orgname" scope="session">${chk1org.rows[0].name}</c:set>
					<c:redirect url="dashboard.jsp"/>
			</c:when>
			<c:otherwise>
				<c:redirect url="/errors/error-401.html"/>
			</c:otherwise>
		</c:choose>
</c:if>

<!doctype html>
<!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js ie7 oldie" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js ie8 oldie" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->

<head>

	<title>ISOFT.CONFIG - Login</title>

	<meta charset="utf-8" />
	<meta name="description" content="" />
	<meta name="author" content="" />		
	<meta name="viewport" content="width=device-width,initial-scale=1" />
	
	<link rel="stylesheet" href="stylesheets/reset.css" type="text/css" media="screen" title="no title" />
	<link rel="stylesheet" href="stylesheets/text.css" type="text/css" media="screen" title="no title" />
	<link rel="stylesheet" href="stylesheets/buttons.css" type="text/css" media="screen" title="no title" />
	<link rel="stylesheet" href="stylesheets/theme-default.css" type="text/css" media="screen" title="no title" />
	<link rel="stylesheet" href="stylesheets/login.css" type="text/css" media="screen" title="no title" />
</head>

<body>

<div id="login">
	<h1>Dashboard!</h1>
	<div id="login_panel">
		<form action="login.jsp" method="post" accept-charset="utf-8">		
			<div class="login_fields">
				<div class="field">
					<label for="email">Логин</label>
					<input type="text" name="email" value="" id="email" tabindex="1" placeholder="username" />		
				</div>
				
				<div class="field">
					<label for="password">Пароль <!--<small><a href="javascript:;">забыли пароль?</a></small>--></label>
					<input type="password" name="password" value="" id="password" tabindex="2" placeholder="password" />			
				</div>
			</div> <!-- .login_fields -->
			
			<div class="login_actions">
				<button type="submit" class="btn btn-primary" tabindex="3">Вход</button>
			</div>
		</form>
	</div> <!-- #login_panel -->		
</div> <!-- #login -->

<script src="javascripts/all.js"></script>


</body>

</html>