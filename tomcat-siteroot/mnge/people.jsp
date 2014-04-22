<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:set var="pageheader"><link rel="stylesheet" href="stylesheets/sample_pages/people.css" type="text/css" /></c:set>
<%@ include file='h_menu.jsp'%>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Внутренние номера</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
				
				<div class="widget widget-plain">
					<div class="widget-header">
					<span class="icon-layers"></span>
					<h3>People</h3>
					</div>
					
					<div class="widget-content">
						<sql:query dataSource="${databas}" var="getDept">
						select * from branchesorg_${G_org}_${G_ver} order by name ASC
						</sql:query>
							<c:forEach items="${getDept.rows}" var="dept">
								<div class="department">
									<h2><a href="branch.jsp?id=${dept.id}">${dept.name}</a></h2>
									<sql:query dataSource="${databas}" var="getExt">
									select * from extensionsorg_${G_org}_${G_ver} where branchid=? order by name ASC
										<sql:param value="${dept.id}"/>
									</sql:query>
										<c:forEach items="${getExt.rows}" var="exten">
											<div class="user-card">
												<div class="avatar">
													<img src="images/stream/person-blue.png" title="User" alt="">
												</div> <!-- .user-card-avatar -->

												<div class="details">
													<p><strong>${exten.name}  ${exten.secondname}</strong><br>
														${exten.extension}<br>

														<a href="extension.jsp?id=${exten.id}">Просмотреть детали</a></p>
												</div> <!-- .user-card-content -->
											</div> <!-- .user-card -->
										</c:forEach>
								</div> <!-- .department -->
							</c:forEach>
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>