<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js ie7 oldie" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js ie8 oldie" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->

<head>

	<title>alpha provision</title>

	<meta charset="utf-8" />
	<meta name="description" content="" />
	<meta name="author" content="" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
	<link rel="stylesheet" href="stylesheets/all.css" type="text/css" />
	
	<!--[if gte IE 9]>
	<link rel="stylesheet" href="stylesheets/ie9.css" type="text/css" />
	<![endif]-->
	
	<!--[if gte IE 8]>
	<link rel="stylesheet" href="stylesheets/ie8.css" type="text/css" />
	<![endif]-->
	
	${pageheader}
	<style>
		.slidingDiv {
		    height:300px;
		    background-color: #99CCFF;
		    padding:20px;
		    margin-top:10px;
		    border-bottom:5px solid #3399FF;
		}

		.show_hide {
		    display:none;
		}
		
	</style>
</head>

<body>

<div id="wrapper">
	

<div id="header">
	<h1><a href="dashboard.jsp">Alpha config</a></h1>
	
	<a href="javascript:;" id="reveal-nav">
		<span class="reveal-bar"></span>
		<span class="reveal-bar"></span>
		<span class="reveal-bar"></span>
	</a>
</div> <!-- #header -->

<div id="search">
	<form action="search.jsp" method="post">
	<input type="text" name="search" placeholder="Найти..." id="searchField" value="${param.search}" />
	</form>
</div> <!-- #search -->

<div id="sidebar">
	
	<ul id="mainNav">
		<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/mnge/dashboard.jsp' ? 'active' : ''}">
			<span class="icon-home"></span>
			<a href="dashboard.jsp">Состояние системы</a>
		</li>
		
		<li id="navDashboard" class="nav ${(pageContext.request.servletPath == '/mnge/crmlist.jsp') or (pageContext.request.servletPath == '/mnge/cdrview.jsp') or (pageContext.request.servletPath == '/mnge/organization.jsp') or (pageContext.request.servletPath == '/mnge/people.jsp') or (pageContext.request.servletPath == '/mnge/branch.jsp') or ((pageContext.request.servletPath == '/mnge/extension.jsp')and (empty param.enleftnav)) ? 'active' : ''}">
			<span class="icon-cloud"></span>
			<a href="organization.jsp?showusers=false">Организация</a>
		</li>
	
		<c:if test="${(pageContext.request.servletPath == '/mnge/extension.jsp') and (param.enleftnav == 'yes')}">
			 <li class="nav ${pageContext.request.servletPath == '/mnge/extension.jsp' ? 'active' : ''}">
				<span class="icon-user"></span>
				<a href="javascript:;">Соседние вн. номера</a>
				<input id="filter_ext1" placeholder="фильтр..." size="25">
				<ul class="subNav">
					<li><div id="orgsubnav">загрузка...</div></li>
				</ul>
			</li>
		</c:if>
		
		<c:if test="${(pageContext.request.servletPath == '/mnge/dialplans.jsp')}">
			 <li class="nav ${pageContext.request.servletPath == '/mnge/dialplans.jsp' ? 'active' : ''}">
				<span class="icon-user"></span>
				<a href="javascript:;">Пользователи</a>
				<input id="filter_ext1" placeholder="фильтр..." size="25">
				<ul class="subNav">
					<li><div id="orgsubnav">загрузка...</div></li>
				</ul>
			</li>
		</c:if>
	
		<li id="navMaps" class="nav ${fn:contains(pageContext.request.servletPath, 'monitoring') ? 'active' : ''}">
			<span class="icon-map-pin-fill"></span>
			<a href="monitoringmap1.jsp">Мониторинг</a>
		</li>
		
<!--
		<li id="navCharts" class="nav ${fn:contains(pageContext.request.servletPath, 'dial') ? 'active' : ''}">
			<span class="icon-layers"></span>
			<a href="dialplans.jsp">Сценарии</a>
		</li>-->

		
		<li id="navType" class="nav ${(fn:contains(pageContext.request.servletPath,'chkext')) or (fn:contains(pageContext.request.servletPath,'import')) or (fn:contains(pageContext.request.servletPath,'export')) ? 'active' : ''}">
			<span class="icon-loop"></span>
			<a href="javascript:;">Манипуляции</a>
			
			<ul class="subNav">
				<li><a href="importbranch.jsp">Импорт офисов</a></li>
				<li><a href="importext.jsp">Импорт номеров</a></li>
				<li><a href="exportext.jsp">Экспорт номеров</a></li>
				<li><a href="chkext.jsp">Проверка номеров</a></li>
			</ul>	
		</li>
		
		<li id="navForms" class="nav ${(pageContext.request.servletPath == '/mnge/globaldialplans.jsp') or (pageContext.request.servletPath == '/mnge/subvermng.jsp') or (pageContext.request.servletPath == '/mnge/audit.jsp')  ? 'active' : ''}">
			<span class="icon-wrench"></span>
			<a href="javascript:;">Настройки</a>
			
			<ul class="subNav">
				<li><a href="globaldialplans.jsp?type=1">Диалплан</a></li>
				<li><a href="audit.jsp">Аудит работы</a></li>
				<li><a href="subvermng.jsp">Версии базы</a></li>
				<li><a href="clearlog.jsp">Очистка логов</a></li>
			</ul>	
		</li>

<%--		
		<li id="navGrid" class="nav">
			<span class="icon-layers"></span>
			<a href="grids.html">Grid Layout</a>	
		</li>
		
		<li id="navTables" class="nav">
			<span class="icon-list"></span>
			<a href="tables.html">Tables</a>	
		</li>
		
		<li id="navButtons" class="nav">
			<span class="icon-compass"></span>
			<a href="buttons.html">Buttons & Icons</a>	
		</li>
		
		<li id="navInterface" class="nav">
			<span class="icon-equalizer"></span>
			<a href="interface.html">Interface Elements</a>	
		</li>
		
		<li id="navCharts" class="nav">
			<span class="icon-chart"></span>
			<a href="charts.html">Charts & Graphs</a>
		</li>
			
		
		<li class="nav">
			<span class="icon-denied"></span>
			<a href="javascript:;">Error Pages</a>
			
			<ul class="subNav">
				<li><a href="error-401.html">401 Page</a></li>
				<li><a href="error-403.html">403 Page</a></li>
				<li><a href="error-404.html">404 Page</a></li>	
				<li><a href="error-500.html">500 Page</a></li>	
				<li><a href="error-503.html">503 Page</a></li>					
			</ul>	
		</li>
	--%>
	</ul>
			
</div> <!-- #sidebar -->
