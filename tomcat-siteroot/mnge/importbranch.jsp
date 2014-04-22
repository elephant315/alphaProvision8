<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Импорт офисов</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-17">
				<form class="form uniformForm" action="importbranchstep1.jsp" method="post" enctype="multipart/form-data">	
				<div class="widget">

						<div class="widget-header">
							<span class="icon-info"></span>
							<h3 class="icon aperture">Важно! прочтите перед загрузкой</h3>
						</div> <!-- .widget-header -->

						<div class="widget-content">
							<p>Для создания справочника мы рекомендуем импользовать MS Excel, сохраните файл в формате CSV с разделителями точка-запятая (;) 
								Перед началом загрузки, откройте файл обычным блокнотом и удостоверьтесь что разделители точка-запятая, а также файл
								сохранен в кодировке UTF-8, (Для пользователей MAC - CRLF Windows) </p>
						</div> <!-- .widget-content -->
					</div> <!-- .widget -->	
					
				<div class="widget">
					
					<div class="widget-header">
						<span class="icon-cog-alt"></span>
						<h3 class="icon aperture">Загрузить список офисов</h3>
					</div> <!-- .widget-header -->
					
					<div class="widget-content">
							<div class="field-group inlineField">	
								<label for="myfile">Укажите файл CVS:</label>
								<div class="field">
									<input type="file" name="myfile" id="myfile" />
								</div>	
							</div>
							<div class="actions">
								<button type="submit" class="btn btn-primary">Импорт</button>
							</div>
						
					</div> <!-- .widget-content -->
					
				</div> <!-- .widget -->	
				
			</form>
			</div> <!-- .grid -->
			
			<div class="grid-7">
				
				<div id="gettingStarted" class="box">
					<h3>Формат данных</h3>
					<ul class="bullet secondary">
						<li>Наименование офиса</li>
						<li>Город</li>
						<li>Адрес (разрешены символы: точка, запятая и пробел)</li>
						<li>Ответственное лицо за телефонию (разрешены пробелы)</li>
						<li>Контактный телефон (только цифры)</li>
					</ul>
					<p>* Допустимые символы: A-Z, А-Я в любом регистре, и цифры. Длина полей 30 символов</p>
				</div>
				<div id="gettingStarted" class="box">
					<h3>Скачать шаблоны</h3>
					<ul class="bullet secondary">
						<li><a href="javascript:;">Пример MS Excel</a></li>
						<li><a href="javascript:;">Пример файла CSV</a></li>
					</ul>
				</div>
					
			</div> <!-- .grid -->
			
		</div> <!-- .container -->
		
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>