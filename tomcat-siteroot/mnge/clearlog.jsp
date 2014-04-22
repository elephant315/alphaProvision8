<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.branch}" var="chkbr1"/>	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Очистка логов</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
			
				<form class="form uniformForm" action="clearlog.jsp" method="post">	
				<div class="widget">
					
					<div class="widget-header">
						<span class="icon-cog-alt"></span>
						<h3 class="icon aperture">Логи это хорошо!</h3>
					</div> <!-- .widget-header -->
					
					<div class="widget-content">
						<div class="field-group">
							
							
						</div> <!-- .field-group -->
						<div class="actions">
								<!--<button type="submit" class="btn btn-primary">Проверка</button>-->
						</div>
					</div> <!-- .widget-content -->
					
				</div> <!-- .widget -->
				</form>
			</div> <!-- .grid -->
		</div> <!-- .container -->		
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>