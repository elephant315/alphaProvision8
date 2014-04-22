<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<%@ include file='h_menu.jsp'%>
<c:if test="${param.action == 'logout'}">
<c:remove var="G_userid" scope="session"/>
<c:remove var="G_username" scope="session"/>
<c:remove var="G_userlogin" scope="session"/>
<c:remove var="G_userlevel" scope="session"/>
<c:remove var="G_org" scope="session"/>
<c:remove var="G_orgname" scope="session"/>
<c:redirect url="login.jsp"/>
</c:if>

<c:if test="${! empty param.password0}">
<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я]{1,29}+$" value="${param.password0}" var="chkpwd0"/>
<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я]{1,29}+$" value="${param.password1}" var="chkpwd1"/>${chkpwd1}${chkpwd}
	<c:if test="${(chkpwd0 == 'true') and (chkpwd1 == 'true')}">
		<sql:update dataSource="${databas}">
			update serverusers set pwd = ? where id = ? and pwd = ?
			<sql:param value="${param.password1}"/>
			<sql:param value="${G_userid}"/>
			<sql:param value="${param.password0}"/>
		</sql:update>
			<div id="content">

				<div id="contentHeader">
					<h1>module name</h1>
				</div> <!-- #contentHeader -->

				<div class="container">

					<div class="grid-24">

						<div class="widget widget-plain">

							<div class="widget-content">
								Пароль изменен!

							</div> <!-- .widget-content -->

						</div> <!-- .widget -->

					</div> <!-- .grid -->

				</div> <!-- .container -->

			</div> <!-- #content -->
	</c:if>
</c:if>

<c:if test="${param.action == 'chgpwd'}">

	<div id="content">
		
		<div id="contentHeader">
			<h1>Настройки пользователя</h1>
		</div> <!-- #contentHeader -->
		
		<div class="container">
			
			<div class="grid-24">
				
				<div class="widget">
					
					<div class="widget-header">
						<span class="icon-article"></span>
						<h3>Изменение пароля</h3>
					</div> <!-- .widget-header -->
					
					<div class="widget-content">
						
						<form class="form uniformForm validateForm" method="post" action="user.jsp">
							<div class="field-group">
								<label for="password0">Старый пароль:</label>
								<div class="field">
									<input type="password" name="password0" id="password0" size="25" value="" />	
								</div>
							</div> <!-- .field-group -->
							
							<div class="field-group">
								<label for="password1">Новый пароль:</label>
								<div class="field">
									<input type="password" name="password1" id="password1" size="25" class="validate[required,minSize[6]]" value="" />	
								</div>
							</div> <!-- .field-group -->
							
							<div class="field-group">
								<label for="password2">Повтор пароля:</label>
								<div class="field">
									<input type="password" name="password2" id="password2" size="25" class="validate[required,equals[password1]]" value="" />	
								</div>
							</div> <!-- .field-group -->
						
							<div class="actions">						
								<button type="submit" class="btn btn-success">Изменить пароль</button>
							</div> <!-- .actions -->
							
						</form>
						
						
					</div> <!-- .widget-content -->
					
				</div> <!-- .widget -->
					
			</div> <!-- .grid -->
			
		</div> <!-- .container -->
	</div> <!-- #content -->
</c:if>

<%@ include file='h_quicknav.jsp'%>