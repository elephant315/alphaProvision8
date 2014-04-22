<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>
<c:set var="pageheader">
<link rel="stylesheet" href="stylesheets/sample_pages/stream.css" type="text/css" />
<style>
#pagination .widget-content { text-align: center; }
.pagination { margin-bottom: 0; }
</style>
</c:set>
<%@ include file='h_menu.jsp'%>

<div id="content">		
	
	<div id="contentHeader">
		<h1>Поддержка</h1>
	</div> <!-- #contentHeader -->	
	
	<div class="container">
			
			
		<div class="grid-17">
			
			
			<div class="widget">
				
				<div class="widget-header">
					<h3>Просмотр статей</h3>
				</div> <!-- .widget-header -->
			
				<div class="widget-content">
					
					<br />
			
			<div class="grid-12 ">
				
				<h3>Общая информация</h3>
				
				<ul class="bullet bullet-black">
					<li><a href="pdf/CONFIGtel.pdf">Настройка телефонов моделей SIP-T2X</a></li>
					<li><a href="pdf/PBXconfig.pdf">Подключение АТС 1043/3020</a></li>
					<li><a href="pdf/PeopleBook.pdf">Руководство администратора портала</a></li>
					<li><a href="pdf/DialplansBasics1.pdf">Часть 1 - Основы диалплана</a></li>
				</ul>		
				
			</div>
			
			<div class="grid-12">
				
				<h3>Решение проблем</h3>
				
				<ul class="bullet bullet-black">
					<li><a href="pdf/manualYealinkConf1.pdf">Ручная настройка телефонов для Alpha Provision</a></li>
					<li><a href="pdf/manualYealinkConf2.pdf">Настройка телефонов для работы c другими DHCP</a></li>
					<li><a href="pdf/DHCPconfig Win2003.pdf">Настройка фильтра DHCP для Windows Server</a></li>
					<li><a href="pdf/DHCPconfig.pdf">Автоматическая настройка телефонов Windows DHCP Server.</a></li>
				</ul>
			</div>
			
			</div> <!-- .widget-content -->
			
			</div> <!-- .widget -->
			
			
			
		</div> <!-- .grid -->
		
		
		<div class="grid-7">
			
			
			
			<div class="btn btn-primary btn-xlarge block">Задать вопрос</div>
			<a href="javascript:;" class="btn btn-tertiary btn-large block">Контакты</a>
		
			<br>
			
				
			<div class="box">
				<h3>Контакная информация</h3>
				
				
				<ul>
					<li>Телефон поддержки +7 7272 ... .....</li>
				</ul>
				
			</div> <!-- .box -->
			
		</div><!-- .grid -->
			
			
		
		
	</div> <!-- .container -->
	
</div> <!-- #content -->


	<c:set var="pagescript">
	<script>
	$('#filter_branch').fastLiveFilter('#list_branch', {
	    timeout: 200,
	    callback: function(total) { $('#filter_results').html(total); }
	});
	
	$(document).ready(function(){

	        $(".slidingDiv").hide();
	        $(".show_hide").show();

	    $('.show_hide').click(function(){
	    $(".slidingDiv").slideToggle();
	    });

	});
	
	</script>
	</c:set>
	
<%@ include file='foot.jsp'%>
