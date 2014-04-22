<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>	

<html>
	<head>
		<title>Company directory</title>
		<link rel="stylesheet" href="stylesheets/all.css" type="text/css" />

		<link rel="stylesheet" href="stylesheets/sample_pages/people.css" type="text/css" />
		<script src="javascripts/jquery.js" type="text/javascript"></script>
		<script src="javascripts/jquery.fastLiveFilter.js"></script>
				${pageheader}
		<style>
		.relative {
		position:relative;
		}

		.boxx {
			background: #555;
			width: 218px;
			font-size: 13px;
			font-weight: normal;
			text-decoration: none;
			color: #FFF;
			list-style-type: none;
			padding-top: 1em;
			padding-bottom: .75em;
			padding-left: 35px;
			/* margin-left: 40px; */

			margin-top: 0;
			margin-bottom: 0;
			border-bottom: none;
			position: relative;
			top: -25px;
			left: -20px;
			
		}
	
		 .nav a:hover {
			background: #616161;
			background: rgba(0,0,0,.075);
		}
		
		
		 .nav a {		

			color: #FFF;
		
		}
		
		.controls {
		position:relative;
		z-index:20;
		overflow-y:scroll;overflow:-moz-scrollbars-vertical; 
		height:335px; 
		width : 100%;
		word-wrap:break-word
		}

		.controls::-webkit-scrollbar {
		    width: 14px;
		}

		.controls::-webkit-scrollbar-track {
		    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
		    border-radius: 10px;
		}

		.controls::-webkit-scrollbar-thumb {
		    border-radius: 10px;
		    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.5);
		}
		
		</style>
		<style>
		#searchb {
			background: #FFFFFF;
			width: 80%;
			min-height: 28px;
		}
		</style>
	</head>
	<body>
<div id="wrapper">
	<div id="header">
		<a href="index.jsp">${empty G_bookmanager ? '<h1></h1>' : '<h2></h2>'}</a>
		<a href="javascript:;" id="reveal-nav">
			<span class="reveal-bar"></span>
			<span class="reveal-bar"></span>
			<span class="reveal-bar"></span>
		</a>
	</div> <!-- #header -->
	<div id="search">
		<form action="index.jsp" method="post">
		<input type="text" name="search" placeholder="Найти..." id="searchField" value="${param.search}" />
		<button class="btn btn-small" style="top: 10px;">&nbsp;&nbsp;<span class="icon-magnifying-glass-alt"></span></button>
		</form>
	</div> <!-- #search -->
	<div id="sidebar">

			<ul id="mainNav">
				<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/people/index.jsp' ? 'active' : ''}">
					<span class="icon-home"></span>
					<a href="index.jsp">Поиск сотрудников</a>
				</li>
				<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/people/map.jsp' ? 'active' : ''}">
					<span class="icon-compass"></span>
					<a href="map.jsp">Найти на карте</a>
				</li>
				<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/people/help.jsp' ? 'active' : ''}">
					<span class="icon-info"></span>
					<a href="help.jsp">Как пользоваться телефоном?</a>
				</li>
<!--
				<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/people/news.jsp' ? 'active' : ''}">
					<span class="icon-chat-alt-fill"></span>
					<a href="news.jsp">Новости</a>
				</li>-->

				<c:if test="${! empty G_bookmanager}">
				<li id="navDashboard" class="nav ${pageContext.request.servletPath == '/people/helpdesk.jsp' ? 'active' : ''}">
					<span class="icon-user"></span>
					<a href="helpdesk.jsp"><strong>Поддержка</strong></a>
				</li>
				</c:if>
				
			</ul>
			
			<div id="brancheslist" class="boxx" style="margin: 5px;">
				<input id="filter_branch" placeholder="фильтр..." size="22"><!--
				<div id="filter_results"></div>
				-->
				<p>
			<div class="controls">

				<c:choose>
					<c:when test="${empty G_bookmanager}">
						<sql:query dataSource="${databasp}" var="getDepts">
						select * from branchesorg_${G_org}_${G_ver} order by name ASC
						</sql:query>
					</c:when>
					<c:otherwise>
						<sql:query dataSource="${databasp}" var="getDeptsCity">
						select city from branchesorg_${G_org}_${G_ver} where id = ${G_bookmanager}
						</sql:query>
						<strong>Ваш регион: ${getDeptsCity.rows[0].city} </strong>
						
						<sql:query dataSource="${databasp}" var="getDepts">
						select * from branchesorg_${G_org}_${G_ver} where city = ? order by name ASC
							<sql:param value="${getDeptsCity.rows[0].city}"/>
						</sql:query>
					</c:otherwise>
				</c:choose>
				

				<ul id="list_branch">
					<c:forEach items="${getDepts.rows}" var="dept">
						<li class="nav">
								<a href="index.jsp?branch=${dept.id}">${dept.name}</a><br>
					</li></c:forEach>
				</ul>
			</div></p></div>

		</div> <!-- #sidebar -->
