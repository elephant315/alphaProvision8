<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>

<html>
<head>

	<title> edit </title>
	<script src="javascripts/wz_jsgraphics.js"></script>
	<script src="javascripts/jgraphui.js"/></script>

<div id="result">this for result</div>
	
<script language="javascript">

$(document).ready(function() {

var diagram = new Diagram(
			{
			'xPosition':250, 
			'yPosition':280, 
			'width':1000, 
			'height':600,
			'imagesPath': 'images/flow/',
			'connectionColor': '#AA0000',
			'toolbar_add_button' : true,
	        'toolbar_save_button' : true,
	        'toolbar_delete_button' : true,
	        'toolbar_background_color_button' : false,
	        'toolbar_border_color_button' : false,
	        'toolbar_font_color_button' : false,
	        'toolbar_font_size_button' : false,
	        'toolbar_font_family_button' : false,
	        'toolbar_border_width_button' : false,
			onSave: function(data){
				$('#result').html("saving...");
				$.post("dialedhelper.jsp", { xmldata: data },
				 function(rdata) {
				   $('#result').html(rdata);
				 });
			}
			});
			
${diagramjs}

});

</script>



