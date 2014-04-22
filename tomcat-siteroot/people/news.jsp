<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>
<c:set var="pageheader">
<link rel="stylesheet" href="stylesheets/sample_pages/stream.css" type="text/css" />
</c:set>
<%@ include file='h_menu.jsp'%>

<div id="content">		
		
		<div id="contentHeader">
			<h1>Новости</h1>
		</div> <!-- #contentHeader -->	
		
		<div class="container">
			
			<div class="row">
				<div class="grid-24">
				<c:if test="${! empty param.editor}">
					<form id="activityStreamForm">	
						<h3>Новости</h3>

						<textarea name="activityPost" placeholder="Share images, links, polls and files with other members."></textarea>

						<div id="activityStreamFormActions">


							<div class="streamShare">
								<button class="btn btn-small btn-primary">Share</button>
							</div>
						</div>

						<div class="clear"></div>
					</form>
				</c:if>
					<div class="activityStreamRow">
						<table class="activityTable">

							<tr>
								<td class="activityStreamAvatarTd">
									<img src="images/stream/defaultavatar_small.png" alt="Profile" />	
								</td>

								<td class="tdDetails">
									<p class="activityStreamWho"><a href="javascript:;">Что делать если в сети один или несколько DHCP серверов?</a></p>
									<p class="streamAnswer">.</p>

									<p class="streamAnswer">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>

								</td>						
							</tr>						
						</table>
					</div> <!-- .activityStreamRow -->

					<div class="activityStreamRow">
						<table class="activityTable">

							<tr>
								<td class="activityStreamAvatarTd">
									<img src="images/stream/defaultavatar_small.png" alt="Profile" />	
								</td>

								<td class="tdDetails">
									<p class="activityStreamWho"><a href="javascript:;">John Doe</a> posted the <strong>4 files</strong>: <a href="javascript:;">Annual Reports</a></p>
									<p class="streamFile"><a href="javascript:;">Annual Report 2007</a> - annual_report_2007.pdf</p>
									<p class="streamFile"><a href="javascript:;">Annual Report 2008</a> - annual_report_2008.pdf</p>
									<p class="streamFile"><a href="javascript:;">Annual Report 2009</a> - annual_report_2009.pdf</p>
									<p class="streamFile"><a href="javascript:;">Annual Report 2010</a> - annual_report_2010.pdf</p>

								</td>						
							</tr>						
						</table>
					</div> <!-- .activityStreamRow -->

					<div class="activityStreamRow">
						<table class="activityTable">

							<tr>
								<td class="activityStreamAvatarTd">
									<img src="images/stream/defaultavatar_small.png" alt="Profile" />	
								</td>

								<td class="tdDetails">
									<p class="activityStreamWho"><a href="javascript:;">John Doe</a> uploaded a new image: <a href="javascript:;">placeholder.jpg</a></p>

									<p class="streamImage">
										<img src="images/stream/imagePlaceholder_330x230.gif" alt="Placeholder">
									</p>

								</td>						
							</tr>						
						</table>
					</div> <!-- .activityStreamRow -->

					<div class="activityStreamRow">
						<table class="activityTable">

							<tr>
								<td class="activityStreamAvatarTd">
									<img src="images/stream/defaultavatar_small.png" alt="Profile" />	
								</td>

								<td class="tdDetails">
									<p class="activityStreamWho"><a href="javascript:;">John Doe</a> bookmarked a page on Delicious: <a href="javascript:;">themeforest.net</a></p>

								</td>						
							</tr>						
						</table>
					</div> <!-- .activityStreamRow -->

					<div class="activityStreamRow">
						<table class="activityTable">

							<tr>
								<td class="activityStreamAvatarTd">
									<img src="images/stream/defaultavatar_small.png" alt="Profile" />	
								</td>

								<td class="tdDetails">
									<p class="activityStreamWho"><a href="javascript:;">John Doe</a> shared an idea: <a href="javascript:;">Create an Awesome Admin Theme</a></p>

									<p class="streamAnswer"> Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>

								</td>						
							</tr>						
						</table>
					</div> <!-- .activityStreamRow -->
				</div>								

			
		</div> <!-- .container -->
		
	</div> <!-- #content -->

	<c:set var="pagescript">
	<script>
	$('#filter_branch').fastLiveFilter('#list_branch', {
	    timeout: 200,
	    callback: function(total) { $('#filter_results').html(total); }
	});
	
	
	</script>
	</c:set>
	
<%@ include file='foot.jsp'%>
