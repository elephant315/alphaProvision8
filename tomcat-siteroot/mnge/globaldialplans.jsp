 <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
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
	        overflow-y: auto;
	        overflow-x: auto;*/

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
        mode: "text/x-pascal",
		matchBrackets: true,
		tabMode: "indent",
		theme: "eclipse",
		readOnly: "true",
		onChange: function (n) { showsave()}
      });
	function showsave()
	{
	//	savebutton.style.display = (savebutton.style.display == 'none') ? '' : 'none'		
	//savebutton.style.display = 'inline';
	$('#savebutton').show();
	}
	$(function() {
		$( "#accordion" ).accordion({ 
			collapsible: true, 
			autoHeight: false, 
			active: false
			});
	});
	$( "#starteditbtn" ).click(function() {
		 editor.setOption("readOnly",false );
		 editor.focus();
		$('#starteditbtn').hide();
	});
    </script>
	<script src="javascripts/jquery.fastLiveFilter.js"></script>
	<script>
	$('#filter_branch').fastLiveFilter('#list_branch', {
	    timeout: 200,
	    callback: function(total) { $('#filter_results').html(total); }
	});
	$('#genbut').live ('click', function (e) {
		e.preventDefault ();
		$.modal ({ 
					title: 'Вставка шаблона'
					, ajax: 'dialplanhelper.jsp?template=global'
				});
	});
	</script>
</c:set>
<%@ include file='h_menu.jsp'%>

<c:if test="${G_userlevel > 100}">
<c:if test="${param.type==1}"><c:set var="dptype" value="dialplan1"/></c:if>
<c:if test="${param.type==2}"><c:set var="dptype" value="dialplan2"/></c:if>
<c:if test="${param.type==3}"><c:set var="dptype" value="customsip"/></c:if>
	<c:if test="${empty param.type}"><c:set var="dptype" value="dialplan1"/></c:if>
	
	<c:if test="${(! empty param.dptext) and (! empty dptype)}">
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я\n\r\t _>#@?$!-=,;:.|/()\{\}\[\]]{1,1000000}+$" value="${param.dptext}" var="chkdptext"/>
			<c:choose>
				<c:when test="${chkdptext == 'true'}">
					<sql:update dataSource="${databas}">
						update orgs
						set ${dptype} = ?
						where id = ?
					 <sql:param value="${param.dptext}"/>
					<sql:param value="${G_org}"/>
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
			select ${dptype} AS 'dptext',name from orgs where id = ?
		 <sql:param value="${G_org}"/>
		</sql:query>
		<div id="contentHeader">
			<h1>${param.type == '1' ? 'Внутренние звонки' : ''}${param.type == '2' ? 'Входящие звонки и IVR' : ''}${param.type == '3' ? 'Шлюзы SIP и регистрации' : ''}: ${dp.rows[0].name}</h1>
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
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
				<div class="widget">
					<div class="widget-header">
						<span class="icon-compass"></span>
						<h3>Внимание, глобальные настройки !</h3>
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
							<div class="actions"><hr/>
								<div id="savebutton" style="display:none">
									<button type="submit" class="btn btn-error" name="action" value="edit">Сохранить</button>
									<a href="globaldialplans.jsp?type=${param.type}&id=${param.id}" class="btn btn-tertiary">Отмена</a>
								</div>
								<a href="Javascript:;" class="btn btn-warning" name="starteditbtn" id="starteditbtn">Редактировать</a>
							</div> <!-- .actions -->
						</form>

					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
				
			</div> <!-- .grid -->
			
			<div class="grid-6">
				<div class="box plain">
					<a href="globaldialplans.jsp?type=1&id=${param.id}" class="${param.type == '1' ? ' btn btn-primary' : 'btn btn-tertiary'} btn-large block">Внутренние звонки</a>
					<a href="globaldialplans.jsp?type=2&id=${param.id}" class="${param.type == '2' ? ' btn btn-primary' : 'btn btn-tertiary'} btn-large block">Входящие звонки и IVR</a>
					<a href="globaldialplans.jsp?type=3&id=${param.id}" class="${param.type == '3' ? ' btn btn-primary' : 'btn btn-tertiary'} btn-large block">Шлюзы SIP и регистрации</a>
						<div id="gettingStarted" class="box">
							<h3>Заметки</h3><p>
								Для генерации глобального диалплана воспользуйтесь <a href="Javascript:;" id="genbut">этой ссылкой</a></p>
						</div>
				</div>		
			</div>
			
		</div> <!-- .container -->
		
	</div> <!-- #content -->
</c:if>
<%@ include file='h_quicknav.jsp'%>
