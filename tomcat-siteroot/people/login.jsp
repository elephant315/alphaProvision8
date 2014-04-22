<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>
<%@ include file='h_menu.jsp'%>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.branch}" var="chkbranch1"/>
<c:if test="${chkbranch1 == 'true'}">

<sql:query dataSource="${databasp}" var="bra">
select * from branchesorg_${G_org}_${G_ver} where id=?
	<sql:param value="${param.branch}"/>
</sql:query>

<c:if test="${bra.rowCount == 1 }">

<c:set var="blogin" value="${bra.rows[0].mnglogin}"/>
<c:set var="bpwd" value="${bra.rows[0].mngpwd}"/>

<c:if test="${(fn:length(blogin) < 1) and (fn:length(bpwd) < 1)}">
	<c:set var="blogin" value="default"/>
	<c:set var="bpwd" value="nopwd"/>
</c:if>

<div id="content">

	<div id="contentHeader">
		<h1>Вход для администратора - ${bra.rows[0].name}</h1>	
	</div> <!-- #contentHeader -->	

	<div class="container">
		<div class="grid-24">
			<c:set var="clientbrowser"><%=request.getHeader("user-agent")%></c:set>
			<c:if test="${(fn:contains(clientbrowser,'Chrome') == false) and (fn:contains(clientbrowser,'Firefox') == false)}">
				<div class="notify notify-success">
					<a href="javascript:;" class="close">&times;</a>
					<h3>Совместимость</h3>
					<p>Для использования всех функций портала, пожалуйста используйте Forefox или Chrome.</p>
					Вы используете ${clientbrowser}
				</div> <!-- .notify -->
			</c:if>
			
			<c:choose>
			<c:when test="${(param.password1 == blogin) and (param.password2 == bpwd)}">
			<c:set var="G_bookmanager" value="${param.branch}" scope="session"/>
			<c:set var="G_bookmanagerPerson" value="${bra.rows[0].techperson}" scope="session"/>
			
				<c:if test="${(fn:length(bra.rows[0].mnglogin) < 1) and (fn:length(bra.rows[0].mngpwd) < 1)}">
				<c:set var="needchgpwd" value="yes" scope="session"/>
				</c:if>
						<div class="notify notify-info">
							<a href="javascript:;" class="close">&times;</a>
							<h3>Успешно</h3>
							<p><a href="${empty needchgpwd ? 'index' : 'login'}.jsp?branch=${param.branch}" class="btn btn-primary">продолжить</a></p>
						</div> <!-- .notify -->
			</c:when>
			<c:when test="${! empty param.logout}"><c:remove var="G_bookmanager" scope="session"/><c:remove var="needchgpwd" scope="session"/>
				<div class="notify">
					<a href="javascript:;" class="close">&times;</a>
					<h3>Вы вышли</h3>
					<p><a href="index.jsp?branch=${param.branch}" class="btn">продолжить</a></p>
				</div> <!-- .notify -->
			</c:when>
			<c:when test="${(needchgpwd == 'yes') and (! empty G_bookmanager)}">
				<c:choose>
					<c:when test="${(! empty param.newpassword0) and (!empty param.newpassword1) and (!empty param.newpassword2)}">
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я]{1,29}+$" value="${param.newpassword0}" var="chknpwd0"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я]{1,29}+$" value="${param.newpassword1}" var="chknpwd1"/>
						<isoft:regexp pat="^[0-9-a-zA-Zа-яА-Я]{1,29}+$" value="${param.newpassword2}" var="chknpwd2"/>
						<c:if test="${chknpwd0 == 'true'}">
							<sql:query dataSource="${databasp}" var="doubchk1">
								select id from branchesorg_${G_org}_${G_ver} where mnglogin = ?
							 <sql:param value="${param.newpassword0}"/>
							</sql:query>
							<c:if test="${doubchk1.rowCount > 0 }"><c:set var="doubchk2" value="true"/></c:if>
						</c:if>
							<c:choose>
								<c:when test="${(empty doubchk2) and (chknpwd0 == 'true') and (chknpwd1 == 'true') and (chknpwd2 == 'true') and (param.newpassword1 == param.newpassword2) and (param.newpassword0 != 'admin') and (param.newpassword0 != 'administrator') and (param.newpassword0 != 'root') and (fn:length(param.newpassword0) > 4) and (fn:length(param.newpassword1) > 4) }">
									<sql:update dataSource="${databasp}">
										update branchesorg_${G_org}_${G_ver} 
										set mnglogin = ?, mngpwd = ?
										where id=?
									 <sql:param value="${param.newpassword0}"/>
									 <sql:param value="${param.newpassword1}"/>
									 <sql:param value="${G_bookmanager}"/>
									</sql:update>
									<div class="notify notify-info">
										<a href="javascript:;" class="close">&times;</a>
										<h3>Данные изменены</h3>
										<p><a href="index.jsp?branch=${param.branch}" class="btn btn-primary">продолжить</a></p>
										<c:remove var="needchgpwd" scope="session"/>
									</div> <!-- .notify -->
								</c:when>
								<c:otherwise>
									<div class="notify notify-error">
										<a href="javascript:;" class="close">&times;</a>
										<h3>Ошибка при изменении пароля</h3>
										<p><b>${empty doubchk2 ? 'Новый логин и пароль не верные' : 'Пользователь с таким именем уже существует'}</b><br/><br/>* Возможны только цифры и латинские буквы в имени пользователя и пароле.
											<br/>* Имя пользователя не может быть admin,administrator или root.<br/>* Длина имени пользователя и пароля не менее 6 символов.</p>
											<p><a href="login.jsp?branch=59" class="btn">продолжить</a></p>
									</div> <!-- .notify -->
								</c:otherwise>
							</c:choose>
					</c:when>
					<c:otherwise>
						<div class="widget">

							<div class="widget-header">
								<span class="icon-article"></span>
								<h3>Создание учетной записи</h3>
							</div> <!-- .widget-header -->

							<div class="widget-content">

								<form class="form uniformForm validateForm" method="post" action="login.jsp?branch=${param.branch}">
									<div class="field-group">
										<label for="password0">Имя пользователя:</label>
										<div class="field">
											<input type="text" name="newpassword0" id="password0" size="25" value="" />	
										</div>
									</div> <!-- .field-group -->

									<div class="field-group">
										<label for="password1">Новый пароль:</label>
										<div class="field">
											<input type="password" name="newpassword1" id="password1" size="25" class="validate[required,minSize[6]]" value="" />	
										</div>
									</div> <!-- .field-group -->

									<div class="field-group">
										<label for="password2">Повтор пароля:</label>
										<div class="field">
											<input type="password" name="newpassword2" id="password2" size="25" class="validate[required,equals[password1]]" value="" />	
										</div>
									</div> <!-- .field-group -->

									<div class="actions">						
										<button type="submit" class="btn btn-success">Изменить данные</button>
									</div> <!-- .actions -->
								</form>
							</div> <!-- .widget-content -->
						</div> <!-- .widget -->
					</c:otherwise>
				</c:choose>	
			</c:when>
			
			<c:otherwise>
			<c:if test="${! empty param.password1}">
						<div class="notify notify-error">
							<a href="javascript:;" class="close">&times;</a>
							<h3>Ошибка</h3>
							<p>логин или пароль не верен</p>
						</div> <!-- .notify -->
			</c:if>
			
			<div class="widget">
									<div class="widget-header">
										<span class="icon-unlock-fill"></span>
										<h3>${bra.rows[0].name}</h3>
									</div> <!-- .widget-header -->

									<div class="widget-content">

										<form class="form uniformForm validateForm" action="login.jsp?branch=${param.branch}" method="post">
											<div class="field-group">
												<label for="password1">Логин:</label>
												<div class="field">
													<input type="text" name="password1" id="password1" size="25" value="" />	
												</div>
											</div> <!-- .field-group -->

											<div class="field-group">
												<label for="password2">Пароль:</label>
												<div class="field">
													<input type="password" name="password2" id="password2" size="25" value="" />	
												</div>
											</div> <!-- .field-group -->

											<div class="actions">						
												<button type="submit" class="btn">Вход</button>
											</div> <!-- .actions -->

										</form>
									</div> <!-- .widget-content -->
								</div> <!-- .widget -->	
			
				</c:otherwise>
				</c:choose>

</div></div></div></div>
	<c:set var="pagescript">
	<script>
	$('#filter_branch').fastLiveFilter('#list_branch', {
	    timeout: 200,
	    callback: function(total) { $('#filter_results').html(total); }
	});
	</script>
	</c:set>

</c:if></c:if>
<c:if test="${chkbranch1 == 'false'}">
<div id="content">

	<div id="contentHeader">
		<h1>Вход для администратора</h1>	
	</div> <!-- #contentHeader -->	
	<div class="container">
		<div class="grid-24">
			Выберите офис в меню.
</div></div></div>
</c:if>

<%@ include file='foot.jsp'%>
