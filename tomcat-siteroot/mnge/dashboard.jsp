<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:set var="pageheader">
	<link rel="stylesheet" href="stylesheets/sample_pages/people.css" type="text/css" />
					<style>
					.ui-autocomplete {
							max-height: 250px;
							overflow-y: auto;
							/* prevent horizontal scrollbar */
							overflow-x: hidden;
							/* add padding to account for vertical scrollbar */
							padding-right: 20px;
						}
						/* IE 6 doesn't support max-height
						 * we use height instead, but this forces the menu to always be this tall
						 */
						* html .ui-autocomplete {
							height: 250px;
						}
					.ui-menu-item {
						line-height: 1.5;
						list-style: none;
						list-style-type:none;
					}
					.ui-autocomplete-category {
						font-weight: bold;
						padding: .2em .4em;
						margin: .8em 0 .2em;
						line-height: 1.5;
						list-style: none;
						list-style-type:none;
					}
					#searchb {
						background: #FFFFFF;
						width: 65%;
						min-height: 28px;
					}
					
					</style>
</c:set>
<%@ include file='h_menu.jsp'%>
<c:set var="pagescript">
					<script>
					$.widget( "custom.catcomplete", $.ui.autocomplete, {
						_renderMenu: function( ul, items ) {
							var self = this,
								currentCategory = "";
							$.each( items, function( index, item ) {
								if ( item.category != currentCategory ) {
									ul.append( "<li class='ui-autocomplete-category bullet bullet-blue'>" + item.category + "</li>" );
									currentCategory = item.category;
								}
								self._renderItem( ul, item );
							});
						}
					});

					$(function() {
						var data = [
						<sql:query dataSource="${databas}" var="getDept">
						select * from branchesorg_${G_org}_${G_ver} order by city ASC
						</sql:query>
							<c:forEach items="${getDept.rows}" var="dept">
							{ label: "${dept.name}", category: "${dept.city}" },
							</c:forEach>
						]; 
						
						function split( val ) {
							return val.split( /;\s*/ );
						}
						function extractLast( term ) {
							return split( term ).pop();
						}
						
						$( "#searchb" )
						.bind( "keydown", function( event ) {
							if ( event.keyCode === $.ui.keyCode.TAB &&
									$( this ).data( "autocomplete" ).menu.active ) {
								event.preventDefault();
							}
						})
						.catcomplete({
							delay: 0,
							minLength: 0,
							source: function( request, response ) {
												response( $.ui.autocomplete.filter(
													data, extractLast( request.term ) ) );
											},
							select: function( event, ui ) {
												var terms = split( this.value );
												terms.pop();
												terms.push( ui.item.value );
												terms.push( "" );
												this.value = terms.join( "; " );
												return false;
											}
							
						});
						
						$( "#vallsearch" ).click(function() {
								if ( $( "#searchb" ).catcomplete( "widget" ).is( ":visible" ) ) {
															$( "#searchb" ).catcomplete( "close" );
															return;
														}
						$( "#searchb" ).catcomplete( "search","" );
						});
						
						$( "#delsearch" ).click(function() {
						$( "#searchb" ).val("");
						$( "#orghelper" ).html('<center><img src="images/loaders/squares.gif"/></center>');
						$( "#orghelper" ).load('organizationhelper.jsp?clear=yes', function() {
						  		if ($.fn.dataTable) { $('.data-tablex').dataTable ({ "bJQueryUI": true,
								"sPaginationType": "full_numbers","bAutoWidth": false,"bFilter": true,"bStateSave": true,
								}); };
							});
						});
							
						$( "#gosearch" ).click(function() {
						var result = $('#searchb').val().replace(/\s/g, "+")
						$( "#orghelper" ).html('<center><img src="images/loaders/squares.gif"/></center>');
						window.location = 'organization.jsp?searchb='+result;

						});
						
					});//top funct end
					</script>
</c:set>

<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.sendtobox}" var="chkbox"/>
<c:if test="${chkbox == 'true'}">
<isoft:loger l1="${databas}" l2="${G_org}" l3m="" l3e="ID${param.sendtobox}" l3u="${G_username}" l4="ext tobox: ID${param.sendtobox}"/>
	<sql:update dataSource="${databas}">
	update devices set statusflag = 0 where id = ? LIMIT 1<sql:param value="${param.sendtobox}"/>
	</sql:update>
	<sql:update dataSource="${databas}">
	update activation set deviceid = null where deviceid = ? LIMIT 1 <sql:param value="${param.sendtobox}"/>  
	</sql:update>
	<script>
		 window.location.href = "dashboard.jsp";
	</script>
</c:if>
	
	<div id="content">
		
		<div id="contentHeader">
			<h1>Сервер настройки оборудования ${G_orgname}</h1>
		</div> <!-- #contentHeader -->	
		
		<div class="container">
			
			<div class="grid-17">
				
				<div class="widget widget-plain">
					
					<div class="widget-content">
				
						<h2 class="dashboard_title">
							Текущее состояние VOIP оборудования <%--<isoft:loger l1="${databas}" l2="${G_org}" l3m="mac" l3e="ext" l3u="usr" l4="some msg here"/>--%>
						</h2>
						
						<div class="dashboard_report first activeState">
							<div class="pad">
								<sql:query dataSource="${databas}" var="ia">
									select id from devices where statusflag > 4
								</sql:query>
								<span class="value">${ia.rowCount}</span> телефонов в сети
							</div> <!-- .pad -->
						</div>
						
						<div class="dashboard_report defaultState">
							<div class="pad">
								<sql:query dataSource="${databas}" var="il">
									select id from extensionsorg_${G_org}_${G_ver}
								</sql:query>
								<span class="value">${il.rowCount-ia.rowCount}</span> не установлено
							</div> <!-- .pad -->
						</div>
						
						<div class="dashboard_report defaultState">
							<div class="pad">
								<sql:query dataSource="${databas}" var="iu">
									select id from devices where statusflag > 0 and statusflag <5
								</sql:query>
								<span class="value">${iu.rowCount}</span> авторизируются
							</div> <!-- .pad -->
						</div>
						
						<div class="dashboard_report defaultState last">
							<div class="pad">
								
								<span class="value">${il.rowCount}</span> пользователей
							</div> <!-- .pad -->
						</div>
						
					</div> <!-- .widget-content -->

				</div> <!-- .widget -->
				
				
				<isoft:runcmd var="r" value="ps -A">
					 <c:if test="${fn:contains(r,'proxy') == 'false'}"><c:set var="serverr">Proxyman не запущен</c:set></c:if>
					 <c:if test="${fn:contains(r,'asterisk') == 'false'}"><c:set var="serverr">${serverr}, Asterisk не запущен</c:set></c:if>
					 <c:if test="${fn:contains(r,'sshd') == 'false'}"><c:set var="serverr">${serverr}, SSHD не запущен</c:set></c:if>
				</isoft:runcmd>
				<c:if test="${! empty serverr}">
					<div class="widget widget-plain">	
						<div class="widget-content">
							<div class="notify notify-error">
								<a href="javascript:;" class="close">&times;</a>
								<h3>Проблемы с сервисами</h3>
								<p>${serverr}</p>
							</div> <!-- .notify -->
						</div>
					</div>
				</c:if>
								
				<div class="widget widget-plain">
					
					<div class="widget-content">
						
						<div class="dashboard_report defaultState">
							<div class="pad">
								<sql:query dataSource="${databas}" var="ia">
									select id from branchesorg_${G_org}_${G_ver} where hwstatus is not NULL
								</sql:query>
								<sql:query dataSource="${databas}" var="il">
									select id from branchesorg_${G_org}_${G_ver} where hwstatus is NULL
								</sql:query>
								<span class="value">${ia.rowCount} / ${il.rowCount}</span> АТС настроено
							</div> <!-- .pad -->
						</div>
						
						<div class="dashboard_report defaultState">
							<div class="pad">
								<sql:query dataSource="${databas}" var="il">
									select id from branchesorg_${G_org}_${G_ver} where hwstatus is not NULL
									and lasttime >= ( NOW() - INTERVAL 4 HOUR ) 
								</sql:query>
								<span class="value">${il.rowCount}</span>АТС в сети
							</div> <!-- .pad -->
						</div>
						
						<div class="dashboard_report defaultState">
							<div class="pad">
								<sql:query dataSource="${databas}" var="il">
									select id from branchesorg_${G_org}_${G_ver} where hwstatus is not NULL
									and lasttime < ( NOW() - INTERVAL 4 HOUR ) and (updinterval is NULL
									or  updinterval > 119)
								</sql:query>
								<span class="value">${il.rowCount}</span><a href="organization.jsp?offline=true&showusers=false">АТС недоступны</a>
							</div> <!-- .pad -->
						</div>
						
						<div class="dashboard_report defaultState last">
							<div class="pad">
								<sql:query dataSource="${databas}" var="il">
									select id from branchesorg_${G_org}_${G_ver} where updinterval is not NULL
									and  updinterval < 119
								</sql:query>
								<span class="value">${il.rowCount}</span><a href="organization.jsp?maintenance=true&showusers=false">АТС в ремонте</a>
							</div> <!-- .pad -->
						</div>
						
					</div> <!-- .widget-content -->

				</div> <!-- .widget -->
				<div class="widget widget-plain">
					
					<div class="widget-content">
						<p>Выберите офис из списка, вы можете искать по имени, а также добавить несколько офисов для поиска.</p>
						<button class="btn btn-quaternary" id="delsearch">&nbsp;&nbsp;<span class="icon-x"></span></button>
						<button class="btn btn-tertiary" id="vallsearch"><span class="icon-arrow-down"></span>все</button>
							<label for="searchb"> </label>
							<input id="searchb" value="${G_navblist}"/>
							<button class="btn btn-primary" id="gosearch">показать</button>
							<sql:query dataSource="${databas}" var="getldep">
							select * from branchesorg_${G_org}_${G_ver} group by city
							</sql:query>
							<p><br/>Или выберите область в которой находится нужный вам офис:<br/><br/>
								<c:forEach items="${getldep.rows}" var="getlde">
								   <a href="organization.jsp?city=${getlde.city}">${getlde.city}</a> &nbsp;
								</c:forEach>
							</p>
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->

				
			</div> <!-- .grid -->
			
			<div class="grid-7">
				<div id="gettingStarted" class="box">
					<h3>С чего начать?</h3>
					<a href="importbranch.jsp" class="btn btn-primary btn-large dashboard_add">Добавить офис</a>
					<a href="importext.jsp" class="btn btn-tertiary btn-large dashboard_add">Импорт абонентов</a>
					<a href="newtask.jsp" class="btn btn-quaternary btn-large dashboard_add">Создать задание</a>
				</div>
			</div> <!-- .grid -->
		</div> <!-- .container -->
		
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>