<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:set var="pageheader">
	<link rel="stylesheet" href="stylesheets/diagram.css">
</c:set>
<c:set var="pagescript"><script>
	$(document).ready(function () {
	  	$( "#dialeditor" ).html('<center><img src="images/loaders/squares.gif"/></center>');
		$( "#dialeditor" ).load('dialeditor.jsp');
	});
</script></c:set>
<%@ include file='h_menu.jsp'%>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>module name</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			<div class="grid-24">
				<div class="widget widget-plain">
					<div class="widget-content">
						<div id="dialeditor" name="dialeditor"></div>	
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>