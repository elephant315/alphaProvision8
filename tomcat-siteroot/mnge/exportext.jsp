<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Экспорт внутренних номеров</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-17">
				<form class="form uniformForm" action="exportext1.jsp" method="post">	
				<div class="widget">

						<div class="widget-header">
							<span class="icon-info"></span>
							<h3 class="icon aperture">Правила выгрузки</h3>
						</div> <!-- .widget-header -->

						<div class="widget-content">
							<p>хелп</p>
						</div> <!-- .widget-content -->
					</div> <!-- .widget -->	
					
				<div class="widget">
					
					<div class="widget-header">
						<span class="icon-cog-alt"></span>
						<h3 class="icon aperture">Задать шаблон для экспорта</h3>
					</div> <!-- .widget-header -->
					
					<div class="widget-content">
						<div class="field-group">
							<label for="branch">Выберите офис:</label>
							<div class="field">
								<select id="branch" name="branch">
									<option value="all_offices">Все офисы</option>
									<sql:query dataSource="${databas}" var="getDept">
									select * from branchesorg_${G_org}_${G_ver} order by name ASC
									</sql:query>
										<c:forEach items="${getDept.rows}" var="dept">
											<option value="${dept.id}">${dept.name}</option>
										</c:forEach>
								</select>
							</div>
							
							<label for="template">Шаблон:</label>
							<div class="field">
								<textarea name="template" id="template" rows="20" cols="80">${param.template}</textarea>
							</div>		
						</div> <!-- .field-group -->
						<div class="actions">
								<button type="submit" class="btn btn-primary">Экспорт</button>
						</div>
					</div> <!-- .widget-content -->
					
				</div> <!-- .widget -->	
				
			</form>
			</div> <!-- .grid -->
			
			<div class="grid-7">
				

				<div id="gettingStarted" class="box">
					<h3>Скачать шаблоны</h3>
					<ul class="bullet secondary">
						<li><a href="javascript:;">Пример -</a></li>
						<li><a href="javascript:;">Пример -</a></li>
					</ul>
				</div>
					
			</div> <!-- .grid -->
			
		</div> <!-- .container -->
		
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>