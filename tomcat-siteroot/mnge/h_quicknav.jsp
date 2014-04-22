<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>	
<script src="javascripts/all.js"></script>
<div id="topNav">
	 <ul>
	 	<li>
	 		<a href="#menuProfile" class="menu">${G_username}</a>
	 		
	 		<div id="menuProfile" class="menu-container menu-dropdown">
				<div class="menu-content">
					<ul class="">
						<li><a href="user.jsp?action=chgpwd">Сменить пароль</a></li>
						<li><a href="user.jsp?action=logout">Выход из системы</a></li>
					</ul>
				</div>
			</div>
 		</li>
	 	
	 </ul>
</div> <!-- #topNav -->

<div id="quickNav">
	<ul>
		<li class="quickNavMail">
			<a href="#menuAmpersand" class="menu"><span class="icon-bolt"></span></a>		
			
			<div id="notify_ballon"></div>

			<div id="menuAmpersand" class="menu-container quickNavConfirm">
				<div class="menu-content cf">
				
					<div class="qnc qnc_confirm">
						
						<h3>Мониторинг сервера</h3>

						<div class="qnc_item">
							<div class="qnc_content">
								<span class="qnc_time">Состояние сервисов:</span>
								<span class="qnc_preview">
									<isoft:runcmd var="r" value="ps -A">
										<span class="ticket ${fn:contains(r,'proxyman') == 'false' ? 'ticket-important' : 'ticket-success'}">Proxyman</span>&nbsp;<span class="ticket ${fn:contains(r,'asterisk') == 'false' ? 'ticket-important' : 'ticket-success'}">Asterisk</span>&nbsp;<span class="ticket ${fn:contains(r,'sshd') == 'false' ? 'ticket-important' : 'ticket-success'}">SSHD</span>
									</isoft:runcmd>
								</span>
							</div> <!-- .qnc_content -->
						</div>
						
						<div id="menumessages" name="menumessages"><c:import url="h_menuhelper.jsp?menugetmsg=yes"/></div>
						
						<a href="javascript:;" class="qnc_more" id="menumessages_refresh">Обновить</a>
														
					</div> <!-- .qnc -->	
				</div>
			</div>
		</li>
		<li class="quickNavNotification">
			<a href="#menuPie" class="menu"><span class="icon-eye"></span></a>

			<div id="menuPie" class="menu-container">
				<div class="menu-content cf">					
					
					<div class="qnc">
						
						<h3>Последние события в журнале</h3>
								<div id="last10log" name="last10log"><c:import url="h_menuhelper.jsp?menugetlog=yes"/></div>
						<a href="javascript:;" class="qnc_more" id="last10log_refresh">Обновить</a>
						
					</div> <!-- .qnc -->
				</div>
			</div>				
		</li>
		<li class="quickNavNotification">
			<a href="#menuPie1" class="menu"><span class="icon-wrench"></span></a>

			<div id="menuPie1" class="menu-container">
				<div class="menu-content cf">					
					
					<div class="qnc">
						
						<h3>Developer version</h3>
					&nbsp;&nbsp;version 8.1
						
					</div> <!-- .qnc -->
				</div>
			</div>				
		</li>
	</ul>		
</div> <!-- .quickNav -->

	</div> <!-- #wrapper -->
	<div id="footer">
		Copyright &copy; 2012.
	</div>
	
	${pagescript}
	<script>
	$('#last10log_refresh').click(function() { 
		$('#last10log').html('<div class="qnc_item"><center><img src="images/loaders/squares.gif"/></center></div>');
		$('#last10log').load('h_menuhelper.jsp?menugetlog=yes');
		});
	$('#menumessages_refresh').click(function() { 
		$('#menumessages').html('<div class="qnc_item"><center><img src="images/loaders/squares.gif"/></center></div>');
		$('#menumessages').load('h_menuhelper.jsp?menugetmsg=yes');
		});	
	</script>
	</body>

	</html>