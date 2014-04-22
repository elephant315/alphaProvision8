<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>

<c:if test="${! empty G_bookmanager}">

<sql:query dataSource="${databasp}" var="getCityCode">
	select dialplan2 from branchesorg_${G_org}_${G_ver} where id = ?
 <sql:param value="${G_bookmanager}"/>
</sql:query>
<sql:query dataSource="${databasp}" var="getExt">
	select id,extension,name,secondname from extensionsorg_${G_org}_${G_ver} where branchid=?
 <sql:param value="${G_bookmanager}"/>
</sql:query>

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
    </script>
</c:set>

<%@ include file='h_menu.jsp'%>
	
	<c:if test="${! empty param.dptext}">
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я\n\r\t _>#@?$!-=,;:.|/()\{\}\[\]]{1,1000000}+$" value="${param.dptext}" var="chkdptext"/>
			<c:choose>
				<c:when test="${chkdptext == 'true'}">
					<c:forEach items="${getExt.rows}" var="exts" varStatus="status">
						<c:set var="extlist">${extlist}${exts.extension}${! status.last ? ',':''}</c:set>
					</c:forEach>
					<isoft:dialplancheck value="${param.dptext}" var="dptestresult" validExtensions="${extlist}"/>
					<c:choose>
						<c:when test="${! empty dptestresult}">
								<c:set var="derr">
								<div class="notify notify-error">
								<a href="javascript:;" class="close">&times;</a>
								<h3>Ошибка, сохранение отменено</h3>
								<p><pre>${dptestresult}</pre></p>
								</div></c:set> <!-- .notify -->
						</c:when>
						<c:otherwise>
							<sql:query dataSource="${databasp}" var="dpold">
								select dialplan2 from branchesorg_${G_org}_${G_ver} where id = ?
							 <sql:param value="${G_bookmanager}"/>
							</sql:query>
							
							<isoft:loger l1="${databasp}" l2="${G_org}" l3m="backupdialplan" l3e="dialplan2" l3u="${G_bookmanagerPerson}" l4="${dpold.rows[0].dialplan2}"/>
							<sql:update dataSource="${databasp}">
								update branchesorg_${G_org}_${G_ver}
								set dialplan2 = ?
								where id = ?
							 <sql:param value="${param.dptext}"/>
							<sql:param value="${G_bookmanager}"/>
							</sql:update><c:set var="derr">
								<div class="notify notify-success">
								<a href="javascript:;" class="close">&times;</a>
								<h3>Сохранение удачно</h3>
								<p>Изменения вступят в силу в течении 2 часов.</p>
								</div> <!-- .notify -->
							</c:set>
						</c:otherwise>
					</c:choose>
					
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
	<sql:query dataSource="${databasp}" var="dp">
		select dialplan2,name,id,city,addr,lasttime,lastip from branchesorg_${G_org}_${G_ver} where id = ?
	 <sql:param value="${G_bookmanager}"/>
	</sql:query>
	<div id="content">
		<div id="contentHeader">
			<h1>Входящие звонки и IVR: ${dp.rows[0].name}
				</h1>
		</div> <!-- #contentHeader -->
		<div class="container">			
			<div class="grid-24">
				${derr}	
				<div class="widget">
					<div class="widget-header">
						<span class="icon-compass"></span>
						<h3>Синтаксис диалпланов Asterisk:</h3>
					</div> <!-- .widget-header -->
					<div class="widget-content">
						<form class="form uniformForm validateForm" method="post">
							<div class="field-group">
								<div class="field">
									<textarea cols="100" rows="30" name="dptext" id="dptext">${empty param.dptext ? dp.rows[0].dialplan2 : param.dptext}</textarea>
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
			
			
			</div> <!-- .grid -->
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
<%@ include file='foot.jsp'%>