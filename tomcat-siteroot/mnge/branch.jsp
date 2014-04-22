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
	<sql:query dataSource="${databas}" var="branch">
	select * from branchesorg_${G_org}_${G_ver} where id=?
		<sql:param value="${param.id}"/>
	</sql:query>
		<c:set var="bid" value="${branch.rows[0].id}"/>
		<c:set var="bname" value="${branch.rows[0].name}"/>
		<c:set var="bcity" value="${branch.rows[0].city}"/>
		<c:set var="baddr" value="${branch.rows[0].addr}"/>
		<c:set var="btechperson" value="${branch.rows[0].techperson}"/>
		<c:set var="btechtel" value="${branch.rows[0].techtel}"/>
		<c:set var="btime" value="${branch.rows[0].lasttime}"/>
		<c:set var="blastip" value="${branch.rows[0].lastip}"/>
</c:if>
<c:choose>
	<c:when test="${!empty bid}">
	
	<c:if test="${param.action == 'updbranch'}">
		<isoft:regexp pat="^[0-9]{1,3}+$" value="${param.uptime}" var="chkuptime"/>
			<c:if test="${(chkuptime == 'true') and (param.uptime > 4) and (param.uptime < 481)}">
			<sql:update dataSource="${databas}">
			 update branchesorg_${G_org}_${G_ver} set updinterval = ? where id = ?
				<sql:param value="${param.uptime}"/>
				<sql:param value="${bid}"/>
			</sql:update>
				<c:set var="actionerror">
					<div class="notify notify-info">
						<a href="javascript:;" class="close">&times;</a>
						<h3>Обновление конфигурации каждые ${param.uptime} минут</h3>
						<p>Перезагрузите АТС или дождитесь пока параметры вступят в силу.</p>
					</div> <!-- .notify -->
				</c:set>
			</c:if>
	</c:if>
	<c:if test="${param.action == 'resetpwd'}">
			<sql:update dataSource="${databas}">		 
			update branchesorg_${G_org}_${G_ver} set mnglogin = null, mngpwd = null where id = ?
			<sql:param value="${bid}"/>
		</sql:update>
	</c:if>
	
	<c:if test="${param.action == 'edit'}">
		<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я .,-]{1,200}+$" value="${param.newname}" var="chkbname"/>
		<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я ]{1,100}+$" value="${param.newcity}" var="chkbcity"/>
		<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я ().,-]{1,100}+$" value="${param.newaddr}" var="chkbaddr"/>
		<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я ]{1,29}+$" value="${param.newtp}" var="chkbtp"/>
		<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я ]{1,29}+$" value="${param.newtt}" var="chkbtt"/>
		<c:set var="newae" value="${param.newae}"/>
		<c:if test="${newae == 'generate'}"><isoft:genpwd var="newae" type="strings" length="16" /></c:if>
		<isoft:regexp pat="^[0-9-a-zA-Z]{16,16}+$" value="${newae}" var="chkbae"/>
			<c:choose>
				<c:when test="${(chkbname == 'true') and (chkbcity == 'true') and (chkbaddr == 'true') and (chkbtp == 'true') and (chkbtt == 'true') and (chkbae == 'true')}">
					<sql:query dataSource="${databas}" var="chkdouble1">
						select id,name from branchesorg_${G_org}_${G_ver} where name = ? and id != ?
						<sql:param value="${param.newname}"/>
						<sql:param value="${bid}"/>
					</sql:query>
					<c:choose>
						<c:when test="${chkdouble1.rowCount == 0}">
							<sql:update dataSource="${databas}">
							 update branchesorg_${G_org}_${G_ver} set name = ?, city = ?, addr = ?, techperson = ?, techtel = ?, aeskey = ? where id = ?
								<sql:param value="${param.newname}"/>
								<sql:param value="${param.newcity}"/>
								<sql:param value="${param.newaddr}"/>
								<sql:param value="${param.newtp}"/>
								<sql:param value="${param.newtt}"/>
								<sql:param value="${newae}"/>
								<sql:param value="${bid}"/>
							</sql:update>
						</c:when>
						<c:otherwise>
							<c:set var="actionerror">
								<div class="notify notify-error">
									<a href="javascript:;" class="close">&times;</a>
									<h3>Ошибка редактирования</h3>
									<p>Уже существует офис: ${chkdouble1.rows[0].name}</p>
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
			<h1>Просмотр офиса</h1>
		</div> <!-- #contentHeader -->
		

			
		<div class="container">
			
			<div class="grid-17">
				${actionerror}
				<div class="widget widget-tabs">

						<div class="widget-header">
							<h3 class="icon aperture">${bid}. ${bname}</h3>

							<ul class="tabs right">	
								<li class="active"><a href="#tab-1">общая информация</a></li>	
								<li class=""><a href="#tab-2">состояние сервера</a></li>
								<li class=""><a href="#tab-3">внешние линии</a></li>
							</ul>					
						</div> <!-- .widget-header -->

						<div id="tab-1" class="widget-content">
									
						</div> <!-- .widget-content -->

						<div id="tab-2" class="widget-content">
	
						</div> <!-- .widget-content -->

						<div id="tab-3" class="widget-content">

						</div> <!-- .widget-content -->

				</div> <!-- .widget -->
				
			</div> <!-- .grid -->

			<div class="grid-7">
				<div id="gettingStarted" class="box">
					<h3>Операции</h3>
					<ul class="bullet secondary">
						<c:if test="${G_userlevel > 100}">
						<li><a href="dialplans.jsp?type=1&id=${param.id}">Изменить диалплан</a></li></c:if>
							<sql:query dataSource="${databas}" var="branchcrm">
							select id from crm where idorg = ? and idbr = ? and type <> 3
								<sql:param value="${G_org}"/>
								<sql:param value="${bid}"/>
							</sql:query>
						<li><a href="crmlist.jsp?type=1&id=${param.id}">Информация по офису <c:if test="${branchcrm.rowCount > 0}"> (${branchcrm.rowCount})</c:if></a></li>
						<li><a href="newtask.jsp?dept=${branch.rows[0].id}" target="_blank">Распечатать коды активации</a></li>
						<li><a href="branch.jsp?id=${branch.rows[0].id}&showlog=yes#log">Производительность и логи</a></li>
						<li><a href="cdrview.jsp?id=${branch.rows[0].id}">Журнал звонков</a></li>
						<c:if test="${(! empty branch.rows[0].mnglogin) and (! empty branch.rows[0].mngpwd)}">
							<li><a href="#" id="resetpwd">Обнулить логин и пароль</a></li>
						</c:if>
						<li><a href="#" onclick="syncmanstart('${bid}')">Запустить Syncman</a></li>
						<li><a href="#" id="rebootpbx">Перезагрузить сервер</a></li>
					</ul>
				</div>
				<div class="box plain">					
					<a href="paramadd.jsp?action=branch&id=${branch.rows[0].id}&nice=1" class="btn btn-primary btn-large dashboard_add">Добавить параметр</a>
					<a href="organization.jsp?searchb=${branch.rows[0].name}&showusers=true" class="btn btn-quaternary btn-large dashboard_add">Просмотреть пользователей</a> 
				</div>
				
					
			</div> <!-- .grid -->
			<div class="grid-24">
				<div class="box plain">
					
					<h3>Текущие настройки</h3>
					
					<table class="table table-striped table-bordered">
					<thead>
						<tr>
							<th>параметр</th>
							<th>значение</th>
							<th>описание</th>
						</tr>
					</thead>
					<tbody>
						<sql:query dataSource="${databas}" var="branchparam">
						select branchparams_${G_org}_${G_ver}.*,params.param,params.paramdescr,params.rgexp from branchparams_${G_org}_${G_ver},params 
						where branchparams_${G_org}_${G_ver}.branchid=? and params.id = branchparams_${G_org}_${G_ver}.paramid
						order by branchparams_${G_org}_${G_ver}.paramid ASC
							<sql:param value="${bid}"/>
						</sql:query>
							<c:forEach items="${branchparam.rows}" var="bx">
								<tr class="odd gradeX">
									<td><a onClick="editparam('${bx.id}')">${bx.param}</a></td>
									<td>
										<c:choose>
											<c:when test="${bx.rgexp == '^[0-1]{1}+$'}">
												<div id="el_${bx.id}" class="field switch">
												    <input type="radio" id="${bx.id}radio1" name="${bx.id}" class="myRadio" value="1" ${bx.paramvalue == '1' ? 'checked' : ''} />
												    <input type="radio" id="${bx.id}radio2" name="${bx.id}" class="myRadio" value="0" ${bx.paramvalue == '0' ? 'checked' : ''}/>
												    <label for="${bx.id}radio1" class="cb-enable  ${bx.paramvalue == '1' ? 'selected' : ''}"><span>Вкл</span></label>
												    <label for="${bx.id}radio2" class="cb-disable ${bx.paramvalue == '0' ? 'selected' : ''}"><span>Выкл</span></label>
												<div id="dummyresult" style="display:none"/></div>
											</c:when>
											<c:otherwise>
											<div id="el_${bx.id}">${bx.paramvalue}</div>
											</c:otherwise>
										</c:choose>
									</td>
									<td>${bx.paramdescr}</td>
								</tr>
							</c:forEach>
							<c:if test="${branchparam.rowCount ==  0}">
								<tr><td colspan="3"><i>нет настроек!</i></td></tr>
							</c:if>
						</tbody>
					</table>
				</div> <!-- .box -->
				<c:if test="${param.showlog == 'yes'}">
					<c:catch var="logerrr">
							<h3 class="icon aperture"><a name="log">Последние записи журнала событий (top 30)</a></h3>
							
							<sql:query dataSource="${databas}" var="getPerf">
							select * from logs where org=? and username=? and message like 'FRAM:%'  order by logtime DESC LIMIT 16
								<sql:param value="${G_org}"/><sql:param value="pbx${bid}"/>
							</sql:query>
							<div class="widget">

									<div class="widget-header">
										<span class="icon-chart"></span>
										<h3 class="icon chart">Данные за последние сутки</h3>		
									</div>

									<div class="widget-content">
										<table class="stats" data-chart-type="line" data-chart-colors="">
											<caption>Состояние сервера</caption>
											<thead>
													<tr>
														<td>&nbsp;</td>
														<c:forEach items="${getPerf.rows}" var="po">
														<fmt:formatDate var="ptime" value="${po.logtime}" type="time" timeStyle="SHORT"/>
														<th>${ptime}</th>
														</c:forEach>
													</tr>

												</thead>

												<tbody>

													<tr>
														<th>RAM (kb)</th>
														<c:forEach items="${getPerf.rows}" var="po">
															<c:set var="perf">${po.message}</c:set>
															<c:set var="pram">${fn:substringAfter(perf,'FRAM:')}</c:set>
															<c:set var="pram">${fn:substringBefore(pram,'kb;')}</c:set>
															<td>${pram}</td>
														</c:forEach>
														
													</tr>	

													<tr>
														<th>SDA (mb)</th>
														<c:forEach items="${getPerf.rows}" var="po">
															<c:set var="perf">${po.message}</c:set>
															<c:set var="proot">${fn:substringAfter(perf,'FROOT:')}</c:set>
															<c:set var="proot">${fn:substringBefore(proot,'M;')}</c:set>	
															<c:set var="proot">${fn:substringBefore(proot,'.')}</c:set>	
															<td>${proot}</td>
														</c:forEach>

													</tr>	

													<tr>
														<th>CPU (1-100)</th>
														<c:forEach items="${getPerf.rows}" var="po">
															<c:set var="perf">${po.message}</c:set>
															<c:set var="pcpu">${fn:substringAfter(perf,'load average: ')}</c:set>
															<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>
															<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>	
															<c:set var="pcpu">${fn:substringBefore(pcpu,';')}</c:set>	
															<td>${pcpu*10000}</td>
														</c:forEach>
													</tr>
												</tbody>
										</table>
									</div> <!-- .widget-content -->

							</div> <!-- .widget -->
					</c:catch>
					${logerrr}		
					<sql:query dataSource="${databas}" var="getLog">
					select * from logs where org=? and username=? and message not like 'FRAM:%' order by logtime DESC LIMIT 30
						<sql:param value="${G_org}"/><sql:param value="pbx${bid}"/>
					</sql:query>
					<c:if test="${getLog.rowCount > 0}">		
					<div class="widget widget-table">
						<div class="widget-content">
							<table class="table table-striped table-bordered data-table">
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
				</c:if>
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->
<div id="modalwin"></div>
<c:set var="pagescript">
${pagescript}
<script src="javascripts/jquery.peity.min.js"></script>
	<script>
		function editparam(paramid) {
			$.modal ({ 
				title: 'Изменение параметра'
				, ajax: 'paramchg.jsp?action=branch&chgparam='+paramid
			});	
		}
		function editbranch(brid) {
			$.modal ({ 
				title: 'Редактирование офиса'
				, ajax: 'edit.jsp?action=branch&brid='+brid
			});	
		}
		function updbranch(brid) {
			$.modal ({ 
				title: 'Обновление конфигурации'
				, ajax: 'edit.jsp?action=updbranch&brid='+brid
			});	
		}
		$('#resetpwd').live ('click', function (e) {
			e.preventDefault ();
			$.alert ({ 
				type: 'confirm'
				, title: 'Подтверждение'
				, text: '<p>Вы уверены что хотите удалить логин и пароль?</p>'
				, callback: function () { window.location = "branch.jsp?&id=${param.id}&action=resetpwd"; }	
			});		
		});
		
		function syncmanstart(brid) {
			$.modal ({ 
				title: 'Удаленный запуск Syncman'
				, ajax: 'branchupdater.jsp?action=runsyncman&id='+brid
			});	
		}
		function pingpbx(brid) {
			$.modal ({ 
				title: 'Ping PBX'
				, ajax: 'branchupdater.jsp?action=ping&id='+brid
			});	
		}
		$('#rebootpbx').live ('click', function (e) {
			e.preventDefault ();
			$.alert ({ 
				type: 'confirm'
				, title: 'Подтверждение'
				, text: '<p>Вы уверены что хотите перезапустить сервер?</p>'
				, callback: function () { 
					$.modal ({ 
						title: 'Перезагрузка АТС'
						, ajax: 'branchupdater.jsp?action=rebootpbx&id=${bid}'
					});
				}	
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
			$('#dummyresult').load('paramchg.jsp?action=branch&chgparam='+name+'&paramval='+tval);
		});	
		function tabscallback (e) {
			$(e).load('branchhelper.jsp?id=${bid}&show='+e.substring(1));
		};
	</script>
</c:set>
</c:when>
<c:otherwise>
<div id="content">
	<div id="contentHeader">
		<h1>Просмотр офиса</h1>
	</div> <!-- #contentHeader -->
	<div class="container">
		<div class="grid-24">
			<div class="notify notify-error">
			<a href="javascript:;" class="close">&times;</a>
			<h3>Ошибка</h3>
			<p>Офис не найден.</p>
			</div> <!-- .notify -->
		</div>
	</div>
</div>
</c:otherwise>
</c:choose>
<%@ include file='h_quicknav.jsp'%>