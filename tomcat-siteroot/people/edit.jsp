<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>
<%@ include file='h_menu.jsp'%>
<c:if test="${! empty G_bookmanager}">
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.branch}" var="chkbranch1"/>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.ext}" var="chkext1"/>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.group}" var="chkcab1"/>
<isoft:regexp pat="^[0-9]{1,2}+$" value="${param.cabid}" var="chkcabid1"/>
</c:if>

<isoft:regexp pat="^[A-Za-zА-Яа-я0-9 .]{1,30}+$" value="${param.fname}" var="chkfname1"/>
<isoft:regexp pat="^[A-Za-zА-Яа-я0-9 .]{1,30}+$" value="${param.lname}" var="chklname1"/>
<isoft:regexp pat="^[A-Za-zА-Яа-я0-9 .]{1,30}+$" value="${param.grname}" var="chkgrname1"/>

	<c:if test="${(chkbranch1 == 'true') and (chkext1 == 'true') and (G_bookmanager == param.branch)}">
		<sql:query dataSource="${databasp}" var="branch">
		select * from branchesorg_${G_org}_${G_ver} where id=?
			<sql:param value="${param.branch}"/>
		</sql:query>
		<sql:query dataSource="${databasp}" var="ext">
		select * from extensionsorg_${G_org}_${G_ver} where id=? and branchid=?
			<sql:param value="${param.ext}"/><sql:param value="${G_bookmanager}"/>
		</sql:query>
			<c:if test="${branch.rowCount == 1}"><c:set var="chkbranch2" value="true"/></c:if>
			<c:if test="${ext.rowCount == 1}"><c:set var="chkext2" value="true"/></c:if>
	</c:if>
	<c:if test="${(chkbranch1 == 'true') and (chkcab1 == 'true') and (G_bookmanager == param.branch)}">
		<sql:query dataSource="${databasp}" var="branch">
		select * from branchesorg_${G_org}_${G_ver} where id=?
			<sql:param value="${param.branch}"/>
		</sql:query>
		<sql:query dataSource="${databasp}" var="cab">
		select * from extensionsorg_${G_org}_${G_ver} where cabin=? and branchid=?
			<sql:param value="${param.group}"/><sql:param value="${G_bookmanager}"/>
		</sql:query>
			<c:if test="${branch.rowCount == 1}"><c:set var="chkbranch2" value="true"/></c:if>
			<c:if test="${cab.rowCount > 0}"><c:set var="chkcab2" value="true"/></c:if>
	</c:if>
<div id="content">

	<div id="contentHeader">
		<h1>Редактирование ${ext.rows[0].extension}</h1>
	</div> <!-- #contentHeader -->	
	<div class="container">
		<div class="grid-24">
			<c:choose>
				<c:when test="${(param.action == 'editext') and (chkbranch2 == 'true') and (chkext2 == 'true')}">
					<form class="form uniformForm" method="post" action="edit.jsp?action=doeditext&branch=${param.branch}&ext=${param.ext}">	
						<div class="widget">
							<div class="widget-header">
								<span class="icon-pen"></span>
								<h3>Главная информация</h3>
							</div> <!-- .widget-header -->
							<div class="widget-content">
								<div class="field-group">
									<label>Имя:</label>
									<div class="field">
										<input type="text" name="fname" id="fname" size="20" class="" value="${ext.rows[0].name}"/>
										<label for="fname">Фамилия</label>
									</div>
									<div class="field">
										<input type="text" name="lname" id="lname" size="20" class="" value="${ext.rows[0].secondname}" />
										<label for="lname">Имя</label>
									</div>
									<p>* данная информация будет отображена на дисплее телефона его владельца, а так же на дисплее во время звонка. Рекомендуемая длина не более 15ти символов.</p>
								</div> <!-- .field-group -->
								
								<div class="field-group">
									<label>CallGroup:</label>
									<div class="field">
										<input type="text" name="cabid" id="cabid" size="20" class="" value="${ext.rows[0].cabin}"/>
										<label for="cabid">только номера c 1 до 64</label>
									</div>
								</div> <!-- .field-group -->
								<button class="btn btn-success">Изменить</button>
								
							</div> <!-- .widget-content -->
						</div> <!-- .widget -->
					</form>
					
					
					<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.sendtobox}" var="chkbox"/>
					<c:if test="${chkbox == 'true'}">
					<isoft:loger l1="${databasp}" l2="${G_org}" l3m="" l3e="${ext.rows[0].extension}" l3u="${G_bookmanagerPerson}" l4="send to box device: ${param.sendtobox}"/>
						<sql:update dataSource="${databasp}">
						update devices set statusflag = 0 where id = ? LIMIT 1<sql:param value="${param.sendtobox}"/>
						</sql:update>
						<sql:update dataSource="${databasp}">
						update activation set deviceid = null where deviceid = ? LIMIT 1 <sql:param value="${param.sendtobox}"/>  
						</sql:update>
					</c:if>
					
					<sql:query dataSource="${databasp}" var="activ">
					select * from activation where extid=? and orgid = ${G_org}
						<sql:param value="${param.ext}"/>
					</sql:query>	
					<sql:query dataSource="${databasp}" var="device">
					select * from devices where id=? 
						<sql:param value="${activ.rows[0].deviceid}"/>
					</sql:query>
					
					<div class="widget">
						<div class="widget-header">
						<span class="icon-layers"></span>
						<h3>Технические данные</h3>
						</div>

						<div class="widget-content">
								<c:choose>
									<c:when test="${device.rowCount > 0}">
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
									Устройство : ${device.rows[0].manufacturer}&nbsp;${device.rows[0].model} 
									<br/>Серийный номер: ${device.rows[0].serial} <br/> AES 128bit ключи установлены <br/>MAC: ${device.rows[0].macaddr}  
									<br/>Активность <isoft:friendlytime time="${device.rows[0].lasttime}" var="hc"/> с IP адресом ${device.rows[0].lastip}
									<br/><br/>
									<a href="javascript:;" id="gotobox" class="btn btn-orange">Отправить в коробку</a><br/><br/>
									<p>
									* Для возврата телефона в заводские настройки, зажмите кнопку OK на 15-20 секунд, 
									после того как на экране появиться запрос на возврат к заводским настройкам еще раз нажмите OK. 
									Пройдет некоторое время и телефон снова будет готов к активации. 
									</p>
									</c:when>
									<c:otherwise>
										<i> Пользователь не активирован !</i>
									</c:otherwise>
								</c:choose>
					</div> <!-- .widget-content -->
					</div> <!-- .widget -->
					
				</c:when>
				<c:when test="${(param.action == 'doeditext') and (chkbranch2 == 'true') and (chkext2 == 'true')}">
					<c:choose>
						<c:when test="${(chklname1 == 'true') and (chkfname1 == 'true') and (chkcabid1 == 'true')}">
							<sql:update dataSource="${databasp}">
								update extensionsorg_${G_org}_${G_ver} set
									name = ?, secondname = ?, cabin=?
									where id = ? and branchid = ?
							 <sql:param value="${param.fname}"/>
							 <sql:param value="${param.lname}"/>
							 <sql:param value="${param.cabid}"/>
							 <sql:param value="${param.ext}"/>
							 <sql:param value="${G_bookmanager}"/>
							</sql:update>
							<sql:update dataSource="${databasp}">
								update extensionparams_${G_org}_${G_ver} set paramvalue=? where paramid=? and extenid=?
								<sql:param value="${param.fname} ${param.lname}"/>
								<sql:param value="2"/>
								<sql:param value="${param.ext}"/>
							</sql:update>
							<isoft:loger l1="${databasp}" l2="${G_org}" l3m="" l3e="${ext.rows[0].extension}" l3u="${G_bookmanagerPerson}" l4="ext change: ${ext.rows[0].name} ${ext.rows[0].secondname} to  ${param.fname} ${param.lname}"/>
							<div class="notify notify">
								<a href="javascript:;" class="close">&times;</a>
								<h3>Изменения сделаны!</h3>
								<p><a href="index.jsp?branch=${param.branch}" class="btn btn-primary">вернуться</a></p>
							</div> <!-- .notify -->
						</c:when>
						<c:otherwise>
							<div class="notify notify-error">
								<a href="javascript:;" class="close">&times;</a>
								<h3>Ошибка редактирования</h3>
								<p>Введены недопустимые символы или некоторые поля пустые. Разрешенные символы 0-9A-Za-zА-Яа-я</p>
							</div> <!-- .notify -->
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:when test="${(param.action == 'editgroup') and (chkbranch2 == 'true') and (chkcab2 == 'true')}">
					<form class="form uniformForm" method="post" action="edit.jsp?action=doeditgroup&branch=${param.branch}&group=${param.group}">	
						<div class="widget">
							<div class="widget-header">
								<span class="icon-pen"></span>
								<h3>Дополнительная информация</h3>
							</div> <!-- .widget-header -->
							<div class="widget-content">
								<div class="field-group">
									<label>Группа/Кабинет:</label>
									<div class="field">
										<input type="text" name="grname" id="grname" size="20" class="" value="${cab.rows[0].groups}"/>
										<label for="grname">Приемная</label>
									</div>
								</div> <!-- .field-group -->
								<button class="btn btn-success">Изменить</button>
							</div> <!-- .widget-content -->
						</div> <!-- .widget -->
					</form>
				</c:when>
				<c:when test="${(param.action == 'doeditgroup') and (chkbranch2 == 'true') and (chkcab2 == 'true')}">
					<c:choose>
						<c:when test="${chkgrname1 == 'true'}">
							<sql:update dataSource="${databasp}">
								update extensionsorg_${G_org}_${G_ver} set
									groups = ?
									where cabin = ? and branchid=?
							 <sql:param value="${param.grname}"/>
							 <sql:param value="${param.group}"/>
							 <sql:param value="${G_bookmanager}"/>
							</sql:update>
							<isoft:loger l1="${databasp}" l2="${G_org}" l3m="" l3e="" l3u="${G_bookmanagerPerson}" l4="group ${param.group} rename: ${cab.rows[0].groups} to ${param.grname}"/>
							<div class="notify notify">
								<a href="javascript:;" class="close">&times;</a>
								<h3>Изменения сделаны!</h3>
								<p><a href="index.jsp?branch=${param.branch}" class="btn btn-primary">вернуться</a></p>
							</div> <!-- .notify -->
						</c:when>
						<c:otherwise>
							<div class="notify notify-error">
								<a href="javascript:;" class="close">&times;</a>
								<h3>Ошибка редактирования</h3>
								<p>Введены недопустимые символы или некоторые поля пустые. Разрешенные символы 0-9A-Za-zА-Яа-я</p>
							</div> <!-- .notify -->
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
				none!
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

	<script>
	(function($) {

	$.alert = function (config) {

		var defaults, options, container, content, actions, close, submit, cancel, title, overlay;

		defaults = {
			type: 'default'
			, title: ''
			, text: ''
			, confirmText: 'Я знаю что я делаю'
			, cancelText: 'Отмена операции'
			, callback: function () {}
			, overlayClose: false
			, escClose: true
		};

		options = $.extend (defaults, config);

		container = $('<div>', { id: 'alert' });
		content = $('<div>', { id: 'alertContent' });
		close = $('<a>', { 'class': 'close', href: 'javascript:;', html: '&times' });
		actions = $('<div>', { id: 'alertActions' });
		overlay = $('<div>', { id: 'overlay' });
		title = $('<h2>', { text: options.title });

		submit = $('<button>', { 'class': 'btn btn-small btn-error', text: options.confirmText });
		cancel = $('<button>', { 'class': 'btn btn-small btn-quaternary', text: options.cancelText });

		container.appendTo ('body');
		content.appendTo (container);
		close.appendTo (container);
		overlay.appendTo ('body');
		title.prependTo (content);

		content.append (options.text);

		actions.appendTo (content);

		if (options.type === 'confirm') {
			submit.appendTo (actions);
			cancel.appendTo (actions);
		} else {
			submit.appendTo (actions);
			submit.text ('Ok');
		}	

		submit.bind ('click', function (e) { 
			e.preventDefault (); 

			if (typeof options.callback === 'function') {
				options.callback.apply ();
			}

			$.alert.close (); 
		});

	//	submit.focus ();

		cancel.bind ('click', function (e) { 
			e.preventDefault (); 
			$.alert.close (); 		
		});

		close.bind ('click', function (e) {
			e.preventDefault ();
			$.alert.close ();
		});


		if (options.overlayClose) {
			overlay.bind ('click', function (e) { $.alert.close (); });
		}

		if (options.escClose) {
			$(document).bind ('keyup.alert', function (e) {
				var key = e.which || e.keyCode;

				if (key == 27) {
					$.alert.close ();
				}			
			});
		}


	}

	$.alert.close = function () {
		$('#alert').remove ();
		$('#overlay').remove ();
		$(document).unbind ('keyup.alert');
	}

	})(jQuery);
	
	(function($) {

	$.modal = function (config) {

		var defaults, options, container, header, close, content, title, overlay;

		defaults = {
			 title: ''
			, html: ''
			, ajax: ''
			, width: null
			, overlay: true
			, overlayClose: false
			, escClose: true
		};

		options = $.extend (defaults, config);

		container = $('<div>', { id: 'modal' });
		header = $('<div>',  { id: 'modalHeader' });
		content = $('<div>', { id: 'modalContent' });
		overlay = $('<div>', { id: 'overlay' });
		title = $('<h2>', { text: options.title });
		close = $('<a>', { 'class': 'close', href: 'javascript:;', html: '&times' });

		container.appendTo ('body');
		header.appendTo (container);
		content.appendTo (container);
		if (options.overlay) {
			overlay.appendTo ('body');
		}
		title.prependTo (header);
		close.appendTo (header);

		if (options.ajax == '' && options.html == '') {
			title.text ('No Content');
		}

		if (options.ajax !== '') {
			content.html ('<div id="modalLoader"><img src="./images/loaders/squares.gif" /></div>');
			$.modal.reposition ();
			$.get (options.ajax, function (response) {
				content.html (response);
				$.modal.reposition ();
			});
		}

		if (options.html !== '') {
			content.html (options.html);
		}

		close.bind ('click', function (e) { 
			e.preventDefault (); 
			$.modal.close (); 		
		});

		if (options.overlayClose) {
			overlay.bind ('click', function (e) { $.modal.close (); });
		}

		if (options.escClose) {
			$(document).bind ('keyup.modal', function (e) {
				var key = e.which || e.keyCode;

				if (key == 27) {
					$.modal.close ();
				}			
			});
		}

		$.modal.reposition ();
	}

	$.modal.reposition = function () {
		var width = $('#modal').outerWidth ();		
		var centerOffset = width / 2;	
		$('#modal').css ({ 'left': '50%', 'top': $(window).scrollTop () + 75, 'margin-left': '-' + centerOffset + 'px' });
	};

	$.modal.close = function () {
		$('#modal').remove ();
		$('#overlay').remove ();
		$(document).unbind ('keyup.modal');
	}

	function getPageScroll() {
		var xScroll, yScroll;

		if (self.pageYOffset) {
			yScroll = self.pageYOffset;
			xScroll = self.pageXOffset;
		} else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
			yScroll = document.documentElement.scrollTop;
			xScroll = document.documentElement.scrollLeft;
		} else if (document.body) {// all other Explorers
			yScroll = document.body.scrollTop;
			xScroll = document.body.scrollLeft;
		}

		return new Array(xScroll,yScroll);
	}

	})(jQuery);
	
	$('#filter_branch').fastLiveFilter('#list_branch', {
	    timeout: 200,
	    callback: function(total) { $('#filter_results').html(total); }
	});
	$('#gotobox').live ('click', function (e) {
		e.preventDefault ();
		$.alert ({ 
			type: 'confirm'
			, title: 'Подтверждение'
			, text: '<p>Вы уверены что хотите провести снова активацию для данного устройства? Возможно устройство потребуется сбросить в заводские настройки после данной операции.</p>'
			, callback: function () { window.location = "edit.jsp?action=editext&sendtobox=${device.rows[0].id}&branch=${param.branch}&ext=${param.ext}"; }	
		});		
	});
	</script>
	
<%@ include file='foot.jsp'%>
