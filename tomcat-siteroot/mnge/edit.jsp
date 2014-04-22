<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.extid}" var="chkext1"/>
<isoft:regexp pat="^[0-9]{1,29}+$" value="${param.brid}" var="chkbr1"/>

<c:if test="${(param.action == 'extension') and (chkext1 == 'true')}">
<sql:query dataSource="${databas}" var="getExt">
	select * from extensionsorg_${G_org}_${G_ver} where id = ?
	<sql:param value="${param.extid}"/>
</sql:query>
	<c:if test="${getExt.rowCount == 1}">
		<div class="box plain">
		
			<form class="form uniformForm validateForm" method="post" action="extension.jsp?id=${param.extid}&action=edit&enleftnav=${param.enleftnav}">
				<div class="field-group">
					<label for="newext">Номер:</label>
					<div class="field">
						<input type="text" name="newext" id="newext" value="${getExt.rows[0].extension}" size="32" />	
					</div>
				</div> <!-- .field-group -->
			
				<div class="field-group">
					<label for="newname">Имя:</label>
					<div class="field">
						<input type="text" name="newname" id="newname" value="${getExt.rows[0].name}" size="32"  />	
					</div>
				</div> <!-- .field-group -->
			
				<div class="field-group">
					<label for="newsname">Фамилия:</label>
					<div class="field">
						<input type="text" name="newsname" id="newsname" value="${getExt.rows[0].secondname}" size="32" />	
					</div>
				</div> <!-- .field-group -->
		
				<div class="field-group inlineField">
					
						<label for="branch">Местонахождение:</label>
						<div class="field">
							<select id="newbranch" name="newbranch">
								<option value="${getExt.rows[0].branchid}">Не изменять</option>
								<sql:query dataSource="${databas}" var="getDept">
								select * from branchesorg_${G_org}_${G_ver} order by name ASC
								</sql:query>
									<c:forEach items="${getDept.rows}" var="dept">
										<option value="${dept.id}">${dept.name}</option>
									</c:forEach>
							</select>
						</div>
					</div>
				<div class="actions">						
					<button type="submit" class="btn btn-success">Применить</button><br/>
				</div> <!-- .actions -->
			
			</form>
		</div> <!-- .widget-content -->
	</c:if>
</c:if>

<c:if test="${(param.action == 'branch') and (chkbr1 == 'true')}">
<sql:query dataSource="${databas}" var="getBr">
	select * from branchesorg_${G_org}_${G_ver} where id = ?
	<sql:param value="${param.brid}"/>
</sql:query>
	<c:if test="${getBr.rowCount == 1}">
		<div class="box plain">
		
			<form class="form uniformForm validateForm" method="post" action="branch.jsp?id=${param.brid}&action=edit">
				<div class="field-group">
					<label for="newname">Название:</label>
					<div class="field">
						<input type="text" name="newname" id="newname" value="${getBr.rows[0].name}" size="32" value="32"/>	
					</div>
				</div> <!-- .field-group -->
			
				<div class="field-group">
					<label for="newcity">Область:</label>
					<div class="field">
						<input type="text" name="newcity" id="newcity" value="${getBr.rows[0].city}" size="32" />	
					</div>
				</div> <!-- .field-group -->
			
				<div class="field-group">
					<label for="newaddr">Адрес:</label>
					<div class="field">
						<input type="text" name="newaddr" id="newaddr" value="${getBr.rows[0].addr}" size="32" />	
					</div>
				</div> <!-- .field-group -->
				
				<div class="field-group">
					<label for="newtp">Системный администратор:</label>
					<div class="field">
						<input type="text" name="newtp" id="newtp" value="${getBr.rows[0].techperson}" size="32" />	
					</div>
				</div> <!-- .field-group -->
				
				<div class="field-group">
					<label for="newtt">Телефон поддержки:</label>
					<div class="field">
						<input type="text" name="newtt" id="newtt" value="${getBr.rows[0].techtel}" size="32" value="5" />	
					</div>
				</div> <!-- .field-group -->
	
				<div class="field-group">
					<label for="newae">AES-128 ключ <a href="javascript:;" id="genae">генировать</a> :</label>
					<div class="field">
						<input type="text" name="newae" id="newae" value="${getBr.rows[0].aeskey}" size="32" value="5" />	
					</div>
				</div> <!-- .field-group -->
				
				<div class="actions">
					<button type="submit" class="btn btn-success">Применить</button>
				</div> <!-- .actions -->
			
			</form>
		</div> <!-- .widget-content -->
	<script>
		$( "#genae" ).click(function() {
			$("#newae").val("generate");
		});			
	</script>
	</c:if>
</c:if>


<c:if test="${(param.action == 'updbranch') and (chkbr1 == 'true')}">
<sql:query dataSource="${databas}" var="getBr">
	select * from branchesorg_${G_org}_${G_ver} where id = ?
	<sql:param value="${param.brid}"/>
</sql:query>
<c:set var="bupdtime" value="${getBr.rows[0].updinterval}"/>
	<c:if test="${getBr.rowCount == 1}">					
					<script>
					$(function() {
						$( "#slider" ).slider({
							value:${empty bupdtime ? '120' : bupdtime},
							min: 5,
							max: 480,
							step: 5,
							slide: function( event, ui ) {
								$( "#uptime" ).val( ui.value);
							}
						});
						$( "#uptime" ).val( $( "#slider" ).slider( "value" ));
					});
					$( "#deftimer" ).click(function() {
						$( "#slider" ).slider( "value", "120" );
						$( "#uptime" ).val( 120);
					});
					</script>
		<div class="box plain">
		
			<form class="form uniformForm validateForm" method="post" action="branch.jsp?id=${param.brid}&action=updbranch">

				<p>
					<label for="uptime">Интервал обновления (мин): </label>
					<input type="text" id="uptime" name="uptime" style="border:0; color:#f6931f; font-weight:bold;" readonly />
				</p>

				<div id="slider" style="width:400px;"></div><br/>
				<div style="width:400px;">
				<p>Для удобства настройки сервера установите минимальное значение. Рекомендуемый интервал обновления сервера в рабочем режиме каждые 
					<a href="Javascript:;" id="deftimer">2 часа</a>.</p>
				</div>
				<div class="actions">
					<button type="submit" class="btn btn-success">Применить</button>
				</div> <!-- .actions -->
			
			</form>
		</div> <!-- .widget-content -->
	</c:if>
</c:if>
