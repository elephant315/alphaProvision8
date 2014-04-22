<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Импорт внутренних номеров</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-17">
				<form class="form uniformForm" action="importextstep1.jsp" method="post" enctype="multipart/form-data">	
				<div class="widget">

						<div class="widget-header">
							<span class="icon-info"></span>
							<h3 class="icon aperture">Важно! прочтите перед загрузкой</h3>
						</div> <!-- .widget-header -->

						<div class="widget-content">
							<p>Для создания справочника мы рекомендуем импользовать MS Excel, сохраните файл в формате CSV с разделителями точка-запятая (;) 
								Перед началом загрузки, откройте файл обычным блокнотом и удостоверьтесь что разделители точка-запятая, а также файл
								сохранен в кодировке UTF-8, (Для пользователей MAC - CRLF Windows) </p>
								<p>
									<b>Пример файла:</b><br>
									name;secondname;extension;branchName/ID;password;cabinet<br>
									Bill;Иванов;101;1;generated;Приемная<br>
									<i>* рекомендуем оставить пароль - generated</i>
								</p>
						</div> <!-- .widget-content -->
					</div> <!-- .widget -->	
					
				<div class="widget">
					
					<div class="widget-header">
						<span class="icon-cog-alt"></span>
						<h3 class="icon aperture">Загрузить список внутренних телефонов</h3>
					</div> <!-- .widget-header -->
					
					<div class="widget-content">
						<div class="field-group control-group inline">	
							<label>Выберите формат:</label>	
	
							<div class="field">
								<input type="radio" name="fradio" id="fradio1" value="default" checked />
								<label for="radio1">Формат по умолчанию</label>
							</div>
	
							<div class="field">
								<input type="radio" name="fradio" id="fradio2" value="freepbx29" />
								<label for="radio2">FreeBPX 2.9 Bulk Extensions</label>
							</div>
	
							<div class="field">
								<input type="radio" name="fradio" id="fradio3" value="asterisk18" />
								<label for="radio3">Asterisk 1.8 sip.conf</label>
							</div>		
						</div>	
						
						<div class="field-group control-group">	
							<label>При нахождении повторяющихся номеров:</label>
	
							<div class="field">
								<input type="checkbox" name="unique" id="unique" value="update" />
								<label for="checkbox">Обновлять повторяющиеся номера (следует устанавливать только в случае обновления базы)</label>
							</div>
		
						</div>
						
						<div class="field-group control-group inline">	
							<label>Проверка уникальности:</label>	

							<div class="field">
								<input type="radio" name="chkglobal" id="chkglobal1" value="1"/>
								<label for="chkglobal1">только по офису</label>
							</div>

							<div class="field">
								<input type="radio" name="chkglobal" id="chkglobal2" value="2" checked/>
								<label for="chkglobal2">по всей организации</label>
							</div>

						</div>
							
						<div class="field-group inlineField">
						
							<label for="branch">Выберите офис:</label>
							<div class="field">
								<select id="branch" name="branch">
									<option value="infile_office">Указан в файле импорта</option>
									<sql:query dataSource="${databas}" var="getDept">
									select * from branchesorg_${G_org}_${G_ver} order by name ASC
									</sql:query>
										<c:forEach items="${getDept.rows}" var="dept">
											<option value="${dept.id}">${dept.name}</option>
										</c:forEach>
								</select>
							</div>
						</div>
						
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