<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>

<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.id}" var="chkid1"/>
<c:if test="${(chkid1 == 'true') and (G_userlevel > 100)}">

<sql:query dataSource="${databas}" var="getCityCode">
	select dialplan1 from branchesorg_${G_org}_${G_ver} where id = ?
 <sql:param value="${param.id}"/>
</sql:query>
<c:set var="extcitycode">${fn:substringAfter(getCityCode.rows[0].dialplan1, ";City")}</c:set>
<c:set var="extcitycode">${fn:substringAfter(extcitycode, "exten => _8")}</c:set>
<c:set var="extcitycode">${fn:substringBefore(extcitycode, ",1,Dial(SIP/")}</c:set>
<c:set var="extcitycode">${fn:replace(extcitycode, "X", "")}</c:set>

<sql:query dataSource="${databas}" var="getExt">
	select id,extension,name,secondname from extensionsorg_${G_org}_${G_ver} where branchid=?
 <sql:param value="${param.id}"/>
</sql:query>
	<c:if test="${(getExt.rowCount > 0) and (fn:length(getExt.rows[0].extension) > 3)}">
		<c:set var="nopattern" value="0"/>
		<c:set var="ei" value="3"/>
			<c:if test="${fn:startsWith(getExt.rows[0].extension,'1')}"><c:set var="ei" value="2"/></c:if>
		<c:set var="pref">${fn:substring(getExt.rows[0].extension,0,ei)}</c:set>
		<c:forEach items="${getExt.rows}" var="che">
			<c:if test="${fn:substring(che.extension,0,ei) != pref}">
				<c:set var="nopattern" value="1"/>
			</c:if>
		</c:forEach>
			<c:if test="${nopattern == '1'}">
				<c:set var="nopattern" value="0"/>
				<c:set var="ei" value="2"/>
				<c:set var="pref">${fn:substring(getExt.rows[0].extension,0,ei)}</c:set>
				<c:forEach items="${getExt.rows}" var="che">
					<c:if test="${fn:substring(che.extension,0,ei) != pref}">
						<c:set var="nopattern" value="1"/>
					</c:if>
				</c:forEach>
			</c:if>
			<c:if test="${nopattern == '1'}">
				<c:set var="nopattern" value="0"/>
				<c:set var="ei" value="1"/>
				<c:set var="pref">${fn:substring(getExt.rows[0].extension,0,ei)}</c:set>
				<c:forEach items="${getExt.rows}" var="che">
					<c:if test="${fn:substring(che.extension,0,ei) != pref}">
						<c:set var="nopattern" value="1"/>
					</c:if>
				</c:forEach>
			</c:if>
		<c:if test="${nopattern == '0'}"> 
			<c:set var="extpatt">${pref}</c:set>
			<c:set var="extpatt2"><c:forEach begin='1' end='${fn:length(getExt.rows[0].extension)-fn:length(pref)}'>X</c:forEach></c:set>
		</c:if>
	</c:if>
	
<c:set var="pageheader"> 
	<link rel="stylesheet" href="javascripts/editor/codemirror.css">
    <script src="javascripts/editor/codemirror.js"></script>
    <script src="javascripts/editor/pascal.js"></script>
    <link rel="stylesheet" href="stylesheets/editor/eclipse.css">
	<link rel="stylesheet" href="stylesheets/sample_pages/stream.css" type="text/css" />
		<style type="text/css">/*this does dynamic scaling!!!	*/
	      .CodeMirror {
	        border: 1px solid #eee;
	      }
	      .CodeMirror-scroll {

			 height: auto;
			 width:auto;
			  overflow-y: hidden;
			  overflow-x: hidden;
/*
	        height: 400px;
			width: 700px;*/

	      }
		.controls {
		position:relative;
		z-index:20;
		overflow-y:scroll;overflow:-moz-scrollbars-vertical; 
		height:335px; 
		width : 100%;
		word-wrap:break-word
		}

		.controls::-webkit-scrollbar {
		    width: 14px;
		}

		.controls::-webkit-scrollbar-track {
		    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
		    border-radius: 10px;
		}

		.controls::-webkit-scrollbar-thumb {
		    border-radius: 10px;
		    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.5);
		}
		</style>
</c:set>
<c:set var="pagescript">
	<script>
      var editor = CodeMirror.fromTextArea(document.getElementById("dptext"), {
        lineNumbers: true,
        matchBrackets: true,
        mode: "text/x-pascal",
		tabMode: "indent",
		theme: "eclipse",
		readOnly: true,
		onChange: function (n) { showsave()}
      });
	
	var viewer = CodeMirror.fromTextArea(document.getElementById("dpglob"), {
        lineNumbers: true,
        matchBrackets: true,
        mode: "text/x-pascal",
		tabMode: "indent",
		theme: "eclipse",
		readOnly: true,
		onChange: function (n) { showsave()}
      });
	$( "#starteditbtn" ).click(function() {
		 editor.setOption("readOnly",false );
		 editor.focus();
		$('#starteditbtn').hide();
	});
	function showsave()
	{
	//	savebutton.style.display = (savebutton.style.display == 'none') ? '' : 'none'		
	$('#savebutton').show();
	}
	$(function() {
		$( "#accordion" ).accordion({ 
			collapsible: true, 
			autoHeight: false, 
			active: false
			});
		viewer.setSize("100%","100%")	
	});
    </script>
	<script src="javascripts/jquery.fastLiveFilter.js"></script>
	<script>
	$('#filter_branch').fastLiveFilter('#list_branch', {
	    timeout: 200,
	    callback: function(total) { $('#filter_results').html(total); }
	});
	$(function() {
		$('#filter_branch').val("${filter_val_temp}").change();
	});
	$( "#filter_pin" ).click(function() {
		$('#filter_pin').load('filter_helper.jsp?new_filter='+$('#filter_branch').val());
		$('#filter_pin').hide();
	});
	
	$('#orgsubnav').load('orgmenuhelper.jsp?extbranch=${param.id}', function() {
		$('#filter_ext1').fastLiveFilter('#filter_list1', {
	    	timeout: 200
		});
	});
	
	$('#tadd1').live ('click', function (e) {
		e.preventDefault ();
		$.modal ({ 
					title: 'Вставка шаблона'
					, ajax: 'dialplanhelper.jsp?template=internal&extpatt=${extpatt}&extpatt2=${extpatt2}'
				});	
		
	});
		
	$('#tadd2').live ('click', function (e) {
		e.preventDefault ();
		$.modal ({ 
					title: 'Вставка шаблона'
					, ajax: 'dialplanhelper.jsp?template=external&extcitycode=${extcitycode}'
				});
	});
	
	$('#tadd3').live ('click', function (e) {
		e.preventDefault ();
		$.modal ({ 
					title: 'Вставка шаблона'
					, ajax: 'dialplanhelper.jsp?template=trunk&extcitycode=${extcitycode}'
				});
	});
	
	$('#tadd4').live ('click', function (e) {
		e.preventDefault ();
		$.modal ({ 
					title: 'Вставка шаблона'
					, ajax: 'dialplanhelper.jsp?template=ivr'
				});
	});
	</script>
</c:set>
<%@ include file='h_menu.jsp'%>

<c:if test="${param.type==1}"><c:set var="dptype" value="dialplan1"/></c:if>
<c:if test="${param.type==2}"><c:set var="dptype" value="dialplan2"/></c:if>
<c:if test="${param.type==3}"><c:set var="dptype" value="customsip"/></c:if>
	
	<c:if test="${(! empty param.dptext) and (! empty dptype)}">
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я\n\r\t _>#@?$!-=,;:.|/()\{\}\[\]]{1,1000000}+$" value="${param.dptext}" var="chkdptext"/>
			<c:choose>
				<c:when test="${chkdptext == 'true'}">
				
					<sql:update dataSource="${databas}">
						update branchesorg_${G_org}_${G_ver}
						set ${dptype} = ?
						where id = ?
					 <sql:param value="${param.dptext}"/>
					<sql:param value="${param.id}"/>
					</sql:update><c:set var="derr">updated ${dptype}</c:set>
					
				</c:when>
				<c:otherwise>
					<c:set var="derr">
						<div class="notify notify-error">
						<a href="javascript:;" class="close">&times;</a>
						<h3>Ошибка</h3>
						<p>Возможно не корректные символы.</p>
						</div> <!-- .notify -->
					</c:set>
				</c:otherwise>
			</c:choose>
	</c:if>
	<div id="content">
		<sql:query dataSource="${databas}" var="dp">
			select ${dptype} AS 'dptext',name,id,city,addr,lasttime,lastip from branchesorg_${G_org}_${G_ver} where id = ?
		 <sql:param value="${param.id}"/>
		</sql:query>
		<div id="contentHeader">
			<h1>${param.type == '1' ? 'Внутренние звонки' : ''}${param.type == '2' ? 'Входящие звонки и IVR' : ''}${param.type == '3' ? 'Шлюзы SIP и регистрации' : ''}: ${dp.rows[0].name}
				<c:if test="${! empty extpatt}"> (${extpatt}${extpatt2})</c:if></h1>
		</div> <!-- #contentHeader -->
		<div class="container">			
			<div class="grid-18">
				<div class="widget widget-plain">
					<div class="widget-content">
						<c:if test="${fn:contains(derr,'updated')}">
							<div class="notify notify-success">
									<a href="javascript:;" class="close">&times;</a>
									<h3>Сохранение удачно</h3>
									<p>${derr}</p>
									</div> <!-- .notify -->
						</c:if>	
						
						
						<p><strong>ID: ${dp.rows[0].id}. ${dp.rows[0].city}</strong>
							<a href="branch.jsp?id=${dp.rows[0].id}">Адрес: ${dp.rows[0].addr}</a>
							<c:if test="${! empty dp.rows[0].lasttime}"> , <isoft:friendlytime time="${dp.rows[0].lasttime}" var="hc"/> с IP адресом ${dp.rows[0].lastip}</c:if></p>
						<c:if test="${param.type == 3}">
						<div id="accordion">
							<h3><a href="#">Глобальные настройки (readonly)</a></h3>
							<div>
								<p>
								Данные настройки автоматически включаются во все диалпланы всех серверов организации.<br/>
								<strong>
								${param.type == '1' ? 'Включается после локального диалплана.' : ''}
								${param.type == '2' ? 'Включается после локального диалплана.' : ''}
								${param.type == '3' ? 'Включается перед локальными настройками SIP.' : ''}
								</strong>
								</p>
								<sql:query dataSource="${databas}" var="dpglob">
									select ${dptype} AS 'dptext',name from orgs where id = ?
								 <sql:param value="${G_org}"/>
								</sql:query>
								<textarea cols="100" rows="30" name="dpglob" id="dpglob">${dpglob.rows[0][dptype]}</textarea>
							</div>
							
							

							
						</div>
						</c:if>
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
				
				<c:forEach items="${getExt.rows}" var="exts" varStatus="status">
					<c:set var="extlist">${extlist}${exts.extension}${! status.last ? ',':''}</c:set>
				</c:forEach>
				<isoft:dialplancheck value="${dp.rows[0][dptype]}" var="dptestresult" validExtensions="${extlist}"/>
				<c:if test="${! empty dptestresult}">
						<div class="notify notify-error">
						<a href="javascript:;" class="close">&times;</a>
						<h3>Ошибка</h3>
						<p><pre>${dptestresult}</pre></p>
						</div> <!-- .notify -->
				</c:if>
				
				
				<div class="widget">
					<div class="widget-header">
						<span class="icon-compass"></span>
						<h3>Синтаксис диалпланов Asterisk:</h3>
					</div> <!-- .widget-header -->
					<div class="widget-content">
						<form class="form uniformForm validateForm" method="post">
							<div class="field-group">
								<div class="field">
									<textarea cols="100" rows="30" name="dptext" id="dptext">${dp.rows[0][dptype]}</textarea>
									<input type="hidden" name="type" value="${param.type}"/>
									<input type="hidden" name="id" value="${param.id}"/>
								</div>
							</div> <!-- .field-group -->
							<div class="actions">
								<div id="savebutton" style="display:none">
									<button type="submit" class="btn btn-error" name="action" value="edit">Сохранить</button>
									<a href="dialplans.jsp?type=${param.type}&id=${param.id}" class="btn btn-tertiary">Отмена</a>
								</div>
								<a href="Javascript:;" class="btn btn-warning" name="starteditbtn" id="starteditbtn">Редактировать</a>
							</div> <!-- .actions -->
						</form>

					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
				<c:if test="${(param.type == 1) or (param.type == 2)}">
				<div id="accordion">
					<h3><a href="#">Глобальные настройки (readonly)</a></h3>
					<div>
						<p>
						Данные настройки автоматически включаются во все диалпланы всех серверов организации.<br/>
						<strong>
						${param.type == '1' ? 'Включается после локального диалплана.' : ''}
						${param.type == '2' ? 'Включается после локального диалплана.' : ''}
						${param.type == '3' ? 'Включается перед локальными настройками SIP.' : ''}
						</strong>
						</p>
						<sql:query dataSource="${databas}" var="dpglob">
							select ${dptype} AS 'dptext',name from orgs where id = ?
						 <sql:param value="${G_org}"/>
						</sql:query>
						<textarea cols="100" rows="30" name="dpglob" id="dpglob">${dpglob.rows[0][dptype]}</textarea>
					</div>
				</div>
				</c:if>
			
			</div> <!-- .grid -->
			
			<div class="grid-6">
				<div class="box plain">
					<a href="dialplans.jsp?type=1&id=${param.id}" class="${param.type == '1' ? ' btn btn-primary' : 'btn btn-tertiary'} btn-large block">Внутренние звонки</a>
					<a href="dialplans.jsp?type=2&id=${param.id}" class="${param.type == '2' ? ' btn btn-primary' : 'btn btn-tertiary'} btn-large block">Внешние звонки и IVR</a>
					<a href="dialplans.jsp?type=3&id=${param.id}" class="${param.type == '3' ? ' btn btn-primary' : 'btn btn-tertiary'} btn-large block">Шлюзы SIP и регистрации</a>
					
				</div>

				<h3>Шаблоны</h3>

				<ul class="projectMembersList">
				<li><a href="javascript:;" id="tadd1" class="projectMemberAdd tooltip" title="шаблон внутренних звонков">IN</a></li>
				<li><a href="javascript:;" id="tadd2" class="projectMemberAdd tooltip" title="шаблон внешних звонков">OUT</a></li>
				<li><a href="javascript:;" id="tadd3" class="projectMemberAdd tooltip" title="шаблон транков">Tr</a></li>
				<li><a href="javascript:;" id="tadd4" class="projectMemberAdd tooltip" title="голосовое меню">IVR</a></li>
				</ul>
				<br>

				<sql:query dataSource="${databas}" var="getDepts">
				select id,name from branchesorg_${G_org}_${G_ver} order by name ASC
				</sql:query>
				<div id="brancheslist" class="box"><h3>Выбрать офис</h3>
					<a class="icon-pin" href="Javascript:;" id="filter_pin"></a><input id="filter_branch" placeholder="фильтр..." size="18"><em id="filter_results"></em><p>
				<div class="controls">
					
					<ul id="list_branch">
						<c:forEach items="${getDepts.rows}" var="dept">
							<li>
								<c:choose>
									<c:when test="${param.id != dept.id}">
										<a href="dialplans.jsp?type=${param.type}&id=${dept.id}" rel="branch${dept.id}">${dept.name}</a><br>
									</c:when>
									<c:otherwise>
										${dept.name}<br>
									</c:otherwise>
								</c:choose>
							</li>
						</c:forEach>
					</ul>
				</div></p>
				</div>
			</div>
			
		</div> <!-- .container -->
	</div> <!-- #content -->
</c:if>
<c:if test="${chkid1 == 'false'}">
	<div id="content">
		<div id="contentHeader">
			<h1>Просмотр офиса</h1>
		</div> <!-- #contentHeader -->
		<div class="container">
			<div class="grid-24">
				<div class="notify notify-error">
				<a href="javascript:;" class="close">&times;</a>
				<h3>Ошибка</h3>
				<p>не найденo.</p>
				</div> <!-- .notify -->
			</div>
		</div>
	</div>
</c:if>
<%@ include file='h_quicknav.jsp'%>
