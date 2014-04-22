<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:set var="pageheader"><link rel="stylesheet" href="stylesheets/sample_pages/people.css" type="text/css" />
<style>
.cb-enable, .cb-disable, .cb-enable span, .cb-disable span { background: url(images/switch.gif) repeat-x; display: block; float: left; }
.cb-enable span, .cb-disable span { line-height: 30px; display: block; background-repeat: no-repeat; font-weight: bold; }
.cb-enable span { background-position: left -90px; padding: 0 10px; }
.cb-disable span { background-position: right -180px;padding: 0 10px; }
.cb-disable.selected { background-position: 0 -30px; }
.cb-disable.selected span { background-position: right -210px; color: #fff; }
.cb-enable.selected { background-position: 0 -60px; }
.cb-enable.selected span { background-position: left -150px; color: #fff; }
.switch label { cursor: pointer; }
.switch input { display: none; }
</style>
</c:set>
<%@ include file='h_menu.jsp'%>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.id}" var="chkid1"/>
<c:if test="${chkid1 == 'true'}">
	<sql:query dataSource="${databas}" var="exten">
	select * from extensionsorg_${G_org}_${G_ver} where id=?
		<sql:param value="${param.id}"/>
	</sql:query>
		<c:set var="eid" value="${exten.rows[0].id}"/>
		<c:set var="ebid" value="${exten.rows[0].branchid}"/>
		<c:set var="newbid" value="${extenbrnew.rows[0].branchid}"/>
		<c:set var="eext" value="${exten.rows[0].extension}"/>
</c:if>

<c:choose>
	<c:when test="${!empty eid}">

<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.sendtobox}" var="chkbox"/>
<c:if test="${chkbox == 'true'}">
<isoft:loger l1="${databas}" l2="${G_org}" l3m="" l3e="${exten.rows[0].extension}" l3u="${G_username}" l4="ext tobox: ID${eid},BID${ebid}"/>
	<sql:update dataSource="${databas}">
	update devices set statusflag = 0 where id = ? LIMIT 1<sql:param value="${param.sendtobox}"/>
	</sql:update>
	<sql:update dataSource="${databas}">
	update activation set deviceid = null where deviceid = ? LIMIT 1 <sql:param value="${param.sendtobox}"/>  
	</sql:update>
	<c:redirect url="extension.jsp?id=${param.id}&enleftnav=${param.enleftnav}"/>
</c:if>

<c:if test="${param.delete == 'yes'}">
<isoft:loger l1="${databas}" l2="${G_org}" l3m="" l3e="${exten.rows[0].extension}" l3u="${G_username}" l4="ext delete: ID${eid},BID${ebid}"/>
	<sql:update dataSource="${databas}">
	update devices set statusflag = 0 where id in (select deviceid from activation where extid = ? and orgid = ${G_org})
	<sql:param value="${eid}"/>
	</sql:update>
	<sql:update dataSource="${databas}">
	delete from extensionparams_${G_org}_${G_ver} where extenid = ?
	<sql:param value="${eid}"/>
	</sql:update>
	<sql:update dataSource="${databas}">
	delete from extensionsorg_${G_org}_${G_ver} where id = ?
	<sql:param value="${eid}"/>
	</sql:update>
	<sql:update dataSource="${databas}">
	delete from activation where extid = ? and orgid = ${G_org}
	<sql:param value="${eid}"/>
	</sql:update>
	<c:redirect url="organization.jsp"/>
</c:if>

<c:if test="${param.action == 'edit'}">
	<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.newext}" var="chkNExt"/>
	<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я]{1,29}+$" value="${param.newname}" var="chkNName"/>
	<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я]{1,29}+$" value="${param.newsname}" var="chkNSname"/>
	<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.newbranch}" var="chkbrchg"/>
		<c:choose>
			<c:when test="${(chkNExt == 'true') and (chkNName == 'true') and (chkNSname == 'true') and (chkbrchg == 'true')}">
			
			<sql:query dataSource="${databas}" var="chkbranch1">
			select id from branchesorg_${G_org}_${G_ver} where id=?
				<sql:param value="${param.newbranch}"/>
			</sql:query>
			<sql:query dataSource="${databas}" var="chkdouble2">
				select id,name,secondname from extensionsorg_${G_org}_${G_ver} where extension = ? and id != ? and branchid = ?
				<sql:param value="${param.newext}"/>
				<sql:param value="${eid}"/>
				<sql:param value="${param.newbranch}"/>
			</sql:query>
			
				<sql:query dataSource="${databas}" var="chkdouble1">
					select id,name,secondname from extensionsorg_${G_org}_${G_ver} where extension = ? and id != ? and branchid = ?
					<sql:param value="${param.newext}"/>
					<sql:param value="${eid}"/>
					<sql:param value="${ebid}"/>
				</sql:query>
				<c:choose>
					<c:when test="${(chkdouble1.rowCount == 0) and (chkdouble2.rowCount == 0) and (chkbranch1.rowCount == 1)}">
						<isoft:loger l1="${databas}" l2="${G_org}" l3m="" l3e="${exten.rows[0].extension}" l3u="${G_username}" l4="ext change: ID${eid},BID${ebid}"/>
						<sql:update dataSource="${databas}">
						 update extensionsorg_${G_org}_${G_ver} set extension = ?, name = ?, secondname = ?,branchid = ? where id = ?
							<sql:param value="${param.newext}"/>
							<sql:param value="${param.newname}"/>
							<sql:param value="${param.newsname}"/>
							<sql:param value="${chkbranch1.rows[0].id}"/>
							<sql:param value="${eid}"/>
						</sql:update>
						<sql:update dataSource="${databas}">
							update extensionparams_${G_org}_${G_ver} set paramvalue=? where paramid=? and extenid=?
							<sql:param value="${param.newname} ${param.newsname}"/>
							<sql:param value="2"/>
							<sql:param value="${eid}"/>
						</sql:update>
						<sql:update dataSource="${databas}">
							update extensionparams_${G_org}_${G_ver} set paramvalue=? where paramid=? and extenid=?
							<sql:param value="${param.newext}"/>
							<sql:param value="3"/>
							<sql:param value="${eid}"/>
						</sql:update>
						<sql:query dataSource="${databas}" var="exten">
						select * from extensionsorg_${G_org}_${G_ver} where id=?
							<sql:param value="${param.id}"/>
						</sql:query>
							<c:set var="eid" value="${exten.rows[0].id}"/>
							<c:set var="ebid" value="${exten.rows[0].branchid}"/>
							<c:set var="eext" value="${exten.rows[0].extension}"/>
					</c:when>
					<c:otherwise>
						<c:set var="actionerror">
							<div class="notify notify-error">
								<a href="javascript:;" class="close">&times;</a>
								<h3>Ошибка редактирования</h3>
								<p>Номер уже такой существует у ${empty chkdouble2.rows[0].name ? chkdouble1.rows[0].name : chkdouble2.rows[0].name}
									&nbsp;${empty chkdouble2.rows[0].secondname ? chkdouble1.rows[0].secondname : chkdouble2.rows[0].secondname}</p>
							</div> <!-- .notify -->
						</c:set>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<c:set var="actionerror">
					<div class="notify notify-error">
						<a href="javascript:;" class="close">&times;</a>
						<h3>Ошибка редактирования</h3>
						<p>Введены недопустимые символы или некоторые поля пустые.</p>
					</div> <!-- .notify -->
				</c:set>
			</c:otherwise>
		</c:choose>
</c:if>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Внутренний номер # ${exten.rows[0].extension}</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-17">
				
				<div class="widget widget-plain">
					<div class="widget-header">
					<span class="icon-layers"></span>
					<h3>People</h3>
					</div>
					
					<div class="widget-content">

						<sql:query dataSource="${databas}" var="activ">
						select * from activation where extid=? and orgid = ${G_org}
							<sql:param value="${eid}"/>
						</sql:query>	
						<sql:query dataSource="${databas}" var="device">
						select * from devices where id=? 
							<sql:param value="${activ.rows[0].deviceid}"/>
						</sql:query>
						<sql:query dataSource="${databas}" var="branch">
						select * from branchesorg_${G_org}_${G_ver} where id=?
							<sql:param value="${ebid}"/>
						</sql:query>
						
								<div class="department">
											<div class="user-card-long">
												${actionerror}
												<div class="avatar">
													<img src="${activ.rows[0].deviceid != NULL ? 'images/stream/person-blue.png' : 'images/stream/person-grey.png'}" title="User" alt="" onClick="editexten('${exten.rows[0].id}')">
													<c:if test="${! empty device.rows[0].model}"><br/><br/><br/><br/><br/>
													<img src="images/__${device.rows[0].model}.png" title="Device" alt=""><br/>
													<img src="images/stream/lock2.png" id="south-west" href="#" title="Ключи не редактируются">
													<br/><br/>
													<img src="images/stream/update2.png" title="update1" alt="" id="update1">
													
													</c:if>
												</div> <!-- .user-card-avatar -->
												<div class="details">
													<p><strong>${exten.rows[0].name}&nbsp;${exten.rows[0].secondname}</strong>
														<!--<a onClick="editexten('${exten.rows[0].id}')"><span class="icon-pen-alt2"></span></a>&nbsp;-->
														<!--<a onClick="javascript:;" id="delextension"><span class="icon-x"></span></a>-->
													<br>
													Местонахождение:	<a href="branch.jsp?id=${branch.rows[0].id}">${branch.rows[0].name}</a><br/>${branch.rows[0].city} 
																		<c:if test="${exten.rows[0].cabin != 'none'}">, &nbsp;${exten.rows[0].groups} (${exten.rows[0].cabin}) </c:if><br/>
													Внутренний номер:	${exten.rows[0].extension}<br/>
													Активационный код: ${activ.rows[0].code}<br/>
													<a href="#" onClick="editexten('${exten.rows[0].id}')"  class="btn btn-small btn-green">изменить</a> <a href="#" id="delextension"  class="btn btn-small">удалить</a><br/><br/>
													
													Статус : ${activ.rows[0].deviceid == NULL ? 'не активирован' : ''}
													${device.rows[0].statusflag == '0' ? '<span class="ticket">в коробке</span>':''} 
													${device.rows[0].statusflag == '1' ? '<span class="ticket ticket-warning">активация отправлена</span>':''} 
													${device.rows[0].statusflag == '2' ? '<span class="ticket ticket-warning">регистрируется но, не в сети</span>':''} 
													${device.rows[0].statusflag == '3' ? '<span class="ticket ticket-warning">включен и регистрируется</span>':''} 
													${device.rows[0].statusflag == '4' ? '<span class="ticket ticket-info">активирован</span>':''} 
													${device.rows[0].statusflag == '5' ? '<span class="ticket ticket-info">зарегистрирован</span>':''} 
													${device.rows[0].statusflag == '6' ? '<span class="ticket ticket-success">зарегистрирован но не в сети</span>':''} 
													${device.rows[0].statusflag == '7' ? '<span class="ticket ticket-success">зарегистрирован в сети</span>':''} 
													${device.rows[0].statusflag == '8' ? '<span class="ticket ticket-important">заблокирован</span>':''} 
													${device.rows[0].statusflag == '9' ? '<span class="ticket ticket-important">jailbreak</span>':''}
													<br/>
													<c:if test="${device.rowCount != 0}">
													Устройство : ${device.rows[0].manufacturer}&nbsp;${device.rows[0].model} 
													<br/>Серийный номер: ${device.rows[0].serial} <br/> AES 128bit ключи установлены <br/>MAC: ${device.rows[0].macaddr}  
													<br/> <a href="extension.jsp?id=${param.id}&showlog=yes#log">Активность</a><isoft:friendlytime time="${device.rows[0].lasttime}" var="hc"/> с IP адресом ${device.rows[0].lastip}
													<div id="manualautopresult">Обновить немедленно.<br> Не отключайте питание во время обработки.</div>
													</c:if>
												</div> <!-- .user-card-content -->
											</div> <!-- .user-card -->
								</div> <!-- .department -->
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
			</div> <!-- .grid -->
			<div class="grid-7">				
				<div id="gettingStarted" class="box">
					<h3>Заметки</h3><p>
						Добавить или удалить основные параметры нельзя. Они обновляются при импорте или через форуму редактирования внутреннего номера.</p>
				</div>
				<div class="box plain">
					<a href="paramadd.jsp?id=${exten.rows[0].id}&nice=1&action=extension" class="btn btn-primary btn-large dashboard_add">Добавить параметр</a>
					<c:if test="${device.rowCount != 0}">
					<a href="javascript:;" id="gotobox" class="btn btn-orange btn-large dashboard_add">Отправить в коробку</a>
					</c:if>
				</div>

			</div> <!-- .grid -->
			<div class="grid-24">
				<div class="box plain">
					
					<h3>Текущие настройки</h3>
					
					<table class="table table-striped table-bordered">
					<thead>
						<tr>
							<th># параметр</th>
							<th>значение</th>
							<th>описание</th>
						</tr>
					</thead>
					<tbody>
						<sql:query dataSource="${databas}" var="extenparam">
						select extensionparams_${G_org}_${G_ver}.*,params.param,params.paramdescr,params.type,params.typedescr,params.rgexp from extensionparams_${G_org}_${G_ver},params 
						where extensionparams_${G_org}_${G_ver}.extenid=? and params.id = extensionparams_${G_org}_${G_ver}.paramid
						order by params.type ASC
							<sql:param value="${eid}"/>
						</sql:query>
					<sql:query dataSource="${databas}" var="branchparam">	
						select branchparams_${G_org}_${G_ver}.*,params.param,params.paramdescr,params.type,params.typedescr from branchparams_${G_org}_${G_ver},params 
							where branchparams_${G_org}_${G_ver}.branchid=? 						
								and params.id = branchparams_${G_org}_${G_ver}.paramid						
								and branchparams_${G_org}_${G_ver}.paramid 	
									NOT IN (select paramid from extensionparams_${G_org}_${G_ver} where extenid=?)
							<sql:param value="${ebid}"/>
							<sql:param value="${eid}"/>
						</sql:query>
							<c:forEach items="${extenparam.rows}" var="ex">
							<c:set var="zaq">${zaq+1}</c:set>
								<tr class="odd">
									<td>${zaq}.
										<c:choose>
											<c:when test="${fn:contains(ex.type,'readonly') == false}">
												<a onClick="editparam('${ex.id}')">${ex.param}</a>
											</c:when>
											<c:otherwise>
												<span class="ticket">${ex.param}</span>
											</c:otherwise>
										</c:choose>
									</td>
									<td>
										<c:choose>
											<c:when test="${ex.rgexp == '^[0-1]{1}+$'}">
												<div id="el_${ex.id}" class="field switch">
												    <input type="radio" id="${ex.id}radio1" name="${ex.id}" class="myRadio" value="1" ${ex.paramvalue == '1' ? 'checked' : ''} />
												    <input type="radio" id="${ex.id}radio2" name="${ex.id}" class="myRadio" value="0" ${ex.paramvalue == '0' ? 'checked' : ''}/>
												    <label for="${ex.id}radio1" class="cb-enable  ${ex.paramvalue == '1' ? 'selected' : ''}"><span>Вкл</span></label>
												    <label for="${ex.id}radio2" class="cb-disable ${ex.paramvalue == '0' ? 'selected' : ''}"><span>Выкл</span></label>
												<div id="dummyresult" style="display:none"/></div>
											</c:when>
											<c:otherwise>
											<div id="el_${ex.id}">${ex.paramvalue}</div>
											</c:otherwise>
										</c:choose>
										</td>
									<td>${empty ex.typedescr ? ex.type : ex.typedescr } <br/>${ex.paramdescr}</td>
								</tr>
							</c:forEach>
							<tr><td colspan="3"><strong>Наследуемые параметры:</strong></td></tr>
							<c:forEach items="${branchparam.rows}" var="bx">
							<c:set var="zaq">${zaq+1}</c:set>
								<tr class="odd">
									<td>${zaq}. ${bx.param}</td>
									<td>${bx.paramvalue}</td>
									<td>${empty bx.typedescr ? bx.type : bx.typedescr } <br/>${bx.paramdescr}</td>
								</tr>
							</c:forEach>
							<c:if test="${branchparam.rowCount ==  0}">
								<tr><td colspan="3"><i>параметры не найдены, отредактируйте офис!</i></td></tr>
							</c:if>
						</tbody>
					</table>
				</div> <!-- .box -->
				<c:if test="${param.showlog == 'yes'}">
							<h3 class="icon aperture"><a name="log">Последние записи журнала событий (top 30)</a></h3>
					<div class="widget widget-table">
						<div class="widget-content">
							<table class="table table-striped table-bordered data-table">
								<sql:query dataSource="${databas}" var="getLog">
								select * from logs where org=? and ext=? order by logtime DESC LIMIT 30
									<sql:param value="${G_org}"/><sql:param value="${exten.rows[0].extension}"/>
								</sql:query>
							<thead>
								<tr>
									<th>#</th>
									<th>Время</th>
									<th>MAC-адрес</th>
									<th>Пользователь</th>
									<th>Что было сделано</th>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${getLog.rows}" var="vo">
								<tr class="odd">
									<td>${vo.id}</td>
									<td>${vo.logtime}</td>
									<td>${vo.macaddr}</td>
									<td>${vo.username}</td>
									<td>${vo.message}</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>	
						</div> <!-- .widget-content -->
					</div> <!-- .widget -->
				</c:if>
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->
	<div id="modalwin"></div>
	<c:set var="pagescript">
		<script src="javascripts/jquery.fastLiveFilter.js"></script>
		<script>
			function editparam(paramid) {
				$.modal ({ 
					title: 'Изменение параметра'
					, ajax: 'paramchg.jsp?action=extension&chgparam='+paramid
				});	
			}
			function editexten(extid) {
				$.modal ({ 
					title: 'Редактирование номера'
					, ajax: 'edit.jsp?action=extension&enleftnav=${param.enleftnav}&extid='+extid
				});	
			}
			$('#gotobox').live ('click', function (e) {
				e.preventDefault ();
				$.alert ({ 
					type: 'confirm'
					, title: 'Подтверждение'
					, text: '<p>Вы уверены что хотите провести снова активацию для данного устройства? Возможно устройство потребуется сбросить в заводские настройки после данной операции.</p>'
					, callback: function () { window.location = "extension.jsp?&enleftnav=${param.enleftnav}&sendtobox=${device.rows[0].id}&id=${exten.rows[0].id}"; }	
				});		
			});
			$('#delextension').live ('click', function (e) {
				e.preventDefault ();
				$.alert ({ 
					type: 'confirm'
					, title: 'Удаление номера'
					, text: '<p>Вы уверены что хотите удалить номер? Откат базы не будет создан, действие не возвратимо.</p>'
					, callback: function () { window.location = "extension.jsp?delete=yes&id=${exten.rows[0].id}"; }	
				});		
			});
			$( "#update1" ).click(function() {
				$("#manualautopresult").html("отправка запроса...");
				$("#manualautopresult").load("autophelper.jsp?model=${device.rows[0].model}&clientip=${device.rows[0].lastip}");
			})
			$(function () {
				$('#south-west').tipsy({gravity: 'sw'});
				
			});
				$('#orgsubnav').load('orgmenuhelper.jsp?extbranch=${ebid}', function() {
					$('#filter_ext1').fastLiveFilter('#filter_list1', {
				    	timeout: 200
					});
				});
		</script>
		<script>
			$(document).ready( function(){ 
			    $(".cb-enable").click(function(){
			        var parent = $(this).parents('.switch');
			        $('.cb-disable',parent).removeClass('selected');
			        $(this).addClass('selected');
			        $('.checkbox',parent).attr('checked', true);
			    });
			    $(".cb-disable").click(function(){
			        var parent = $(this).parents('.switch');
			        $('.cb-enable',parent).removeClass('selected');
			        $(this).addClass('selected');
			        $('.checkbox',parent).attr('checked', false);
			    });
			});
			$('.myRadio').change(function() {           
			    var name = $(this).attr("name");
				var tval = $(this).val();
				$('#dummyresult').load('paramchg.jsp?action=extension&chgparam='+name+'&paramval='+tval);
			});
		</script>
	</c:set>
		


</c:when>
<c:otherwise>
<div id="content">
	<div id="contentHeader">
		<h1>Просмотр внутреннего номера</h1>
	</div> <!-- #contentHeader -->
	<div class="container">
		<div class="grid-24">
			<div class="notify notify-error">
			<a href="javascript:;" class="close">&times;</a>
			<h3>Ошибка</h3>
			<p>Номер не найден.</p>
			</div> <!-- .notify -->
		</div>
	</div>
</div>
</c:otherwise>
</c:choose>
<%@ include file='h_quicknav.jsp'%>