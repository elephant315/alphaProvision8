<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я .;,-]{1,1000}+$" value="${param.searchb}" var="chkbr1"/>
<c:choose>
	<c:when test="${(chkbr1 == 'true') and ( fn:length(fn:trim(param.searchb)) > 0 )}">
		<c:set var="G_navblist" value="${param.searchb}" scope="session"/>
	</c:when>
	<c:otherwise>
		
	</c:otherwise>
</c:choose>
<c:if test="${param.showusers == 'true'}">
	<c:set var="g_showusers" value="true" scope="session"/>
</c:if>
<c:if test="${param.showsipstat == 'true'}">
	<c:set var="g_showsipstat" value="true" scope="session"/>
</c:if>
<c:if test="${param.showsipstat == 'false'}">
	<c:remove var="g_showsipstat" scope="session"/>
</c:if>
<c:if test="${param.showservstat == 'true'}">
	<c:set var="g_showservstat" value="true" scope="session"/>
</c:if>
<c:if test="${param.showservstat == 'false'}">
	<c:remove var="g_showservstat" scope="session"/>
</c:if>
<c:if test="${param.showusers == 'false'}">
	<c:remove var="g_showusers" scope="session"/>
</c:if>
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
						$( "#orghelper" ).load('organizationhelper.jsp?searchb='+result, function() {
						  		if ($.fn.dataTable) { $('.data-tablex').dataTable ({ "bJQueryUI": true,
								"sPaginationType": "full_numbers","bAutoWidth": false,"bFilter": true,"bStateSave": true,
								}); };
							});
						});
						
					});//top funct end
					
					$(document).ready(function () {
					  	$( "#orghelper" ).html('<center><img src="images/loaders/squares.gif"/></center>');
						$( "#orghelper" ).load('organizationhelper.jsp', function() {
						  		if ($.fn.dataTable) { $('.data-tablex').dataTable ({ "bJQueryUI": true,
								"sPaginationType": "full_numbers","bAutoWidth": false,"bFilter": true,"bStateSave": true,
								}); };
							});
					});

					</script>
</c:set>	
<c:if test="${! empty param.city}">
	<sql:query dataSource="${databas}" var="getDeptlist">
	select * from branchesorg_${G_org}_${G_ver} where city = ?
		<sql:param value="${param.city}"/>
	</sql:query>
	<c:remove var="G_navblist" scope="session"/>
		<c:forEach items="${getDeptlist.rows}" var="getlde">
		   <c:set var="G_navblist_t">${getlde.name}; ${G_navblist_t}</c:set>
		</c:forEach>
	<c:set var="G_navblist" scope="session">${G_navblist_t}</c:set>
</c:if>
<c:if test="${! empty param.offline}">
	<sql:query dataSource="${databas}" var="getDeptlist">
	select * from branchesorg_${G_org}_${G_ver} where hwstatus is not NULL
	and lasttime < ( NOW() - INTERVAL 4 HOUR )
	</sql:query>
	<c:remove var="G_navblist" scope="session"/>
		<c:forEach items="${getDeptlist.rows}" var="getlde">
		   <c:set var="G_navblist_t">${getlde.name}; ${G_navblist_t}</c:set>
		</c:forEach>
	<c:set var="G_navblist" scope="session">${G_navblist_t}</c:set>
</c:if>
<c:if test="${! empty param.maintenance}">
	<sql:query dataSource="${databas}" var="getDeptlist">
	select * from branchesorg_${G_org}_${G_ver} where updinterval is not NULL
	and  updinterval < 119
	</sql:query>
	<c:remove var="G_navblist" scope="session"/>
		<c:forEach items="${getDeptlist.rows}" var="getlde">
		   <c:set var="G_navblist_t">${getlde.name}; ${G_navblist_t}</c:set>
		</c:forEach>
	<c:set var="G_navblist" scope="session">${G_navblist_t}</c:set>
</c:if>


<c:if test="${getDeptlist.rowCount < 2}">
	<c:set var="g_showusers" value="true" scope="session"/>
</c:if>
	<div id="content">
		
		<div id="contentHeader">
			<h1>Организация ${G_orgname}</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
				
				<div class="widget widget-plain">
					<div class="widget-header">
					<span class="icon-layers"></span>
					<h3>org</h3>
					</div>
					
					<div class="widget-content">
						<p>Выберите офис из списка, вы можете искать по имени, а также добавить несколько офисов для поиска.</p>
						<button class="btn btn-quaternary" id="delsearch">&nbsp;&nbsp;<span class="icon-x"></span></button>
						<button class="btn btn-tertiary" id="vallsearch"><span class="icon-arrow-down"></span>все</button>
							<label for="searchb"> </label>
							<input id="searchb" value="${G_navblist}"/>
							<button class="btn btn-primary" id="gosearch">показать</button>
					<br/><br/>
						<sql:query dataSource="${databas}" var="getldep">
						select * from branchesorg_${G_org}_${G_ver} group by city
						</sql:query>
						Или выберите область в которой находится нужный вам офис:<br/><br/>
						<p>
							<c:forEach items="${getldep.rows}" var="getlde">
							   <a href="organization.jsp?city=${getlde.city}">${param.city == getlde.city ? '<strong>' : ''} ${getlde.city} ${param.city == getlde.city ? '</strong>' : ''}</a> &nbsp;
							</c:forEach>
						</p>
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
				<div id="orghelper"></div>
			</div> <!-- .grid -->
		</div> <!-- .container -->
	</div> <!-- #content -->

<%@ include file='h_quicknav.jsp'%>