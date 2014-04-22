<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:if test="${! empty param.menugetlog}">
	<sql:query dataSource="${databas}" var="lgoq">select * from logs where org=? and message not like 'FRAM%'
	and message not like 'auth%' and message not like 'work%' order by id desc LIMIT 5<sql:param>${G_org}</sql:param></sql:query>
	<c:forEach var="log" items="${lgoq.rows}">
		<c:set var="gdetlink">Javascript:;</c:set>
		<c:if test="${! empty log.macaddr}"><c:set var="gdetlink">search.jsp?search=${log.macaddr}</c:set></c:if>
		<c:if test="${fn:contains(log.username,'pbx')}"><c:set var="gdetlink">branch.jsp?id=${fn:substringAfter(log.username,'pbx')}</c:set></c:if>
		<a href="${gdetlink}" class="qnc_item">
			<div class="qnc_content">
				<span class="qnc_title">
					${log.message}
				</span>
				<span class="qnc_preview">
					
					<c:if test="${! empty log.macaddr}">mac-адрес ${log.macaddr}</c:if><br/>
					<c:if test="${! empty log.ext}">Номер телефона  ${log.ext}</c:if><br/>
					<c:if test="${! empty log.username}">Пользователь портала ${log.username}</c:if><br/>
				<span class="qnc_time">${log.logtime}</span>
			</div> <!-- .qnc_content -->
		</a>
	</c:forEach>
</c:if>


<c:if test="${! empty param.menugetmsg}">

<c:if test="${! empty param.menudelmsg}">
	<c:forTokens items="${G_menumsg}" delims="${newline}" var="msgtoken" varStatus="status">
		<c:if test="${fn:substringAfter(param.menudelmsg,'delnot') != status.count}"><c:set var="temp_notifymsg">${msgtoken}${newline}${temp_notifymsg}</c:set></c:if>
	</c:forTokens>
<c:set var="G_menumsg" value="${temp_notifymsg}" scope="session"/>
</c:if>
	
<c:forTokens items="${G_menumsg}" delims="${newline}" var="msgtoken" varStatus="status">
<c:set var="notifymsgnum" value="${notifymsgnum+1}"/>
	<div class="qnc_item">
		<div class="qnc_content">
			<span class="qnc_title">Сообщение #${notifymsgnum}</span>
			<span class="qnc_preview">${fn:substringBefore(msgtoken,'##')}</span>
			<span class="qnc_time">${fn:substringAfter(msgtoken,'##')}</span>
		</div> <!-- .qnc_content -->
		<div class="qnc_actions">
			<button class="btn btn-primary btn-small" name="menumessage_del${status.count}" id="menumessage_del${status.count}">Прочитал</button>
			<button class="btn btn-quaternary btn-small" name="menumessage_notnow${status.count}" id="menumessage_notnow${status.count}">Не сейчас</button>
		</div>
	</div>
	<c:set var="btndelscript">
	${btndelscript}
		$('#menumessage_del${status.count}').click(function(){
		$('#menumessages').load('h_menuhelper.jsp?menugetmsg=yes&menudelmsg=delnot${status.count}');
		    })
		$('#menumessage_notnow${status.count}').click(function(){
			//AKAKA
		   })
	</c:set>
</c:forTokens>

<c:choose>
	<c:when test="${notifymsgnum > 0}">
	<script>
	$(document).ready(function() {
		$('#notify_ballon').html('<span class="alert">${notifymsgnum}</span>');
	});
	${btndelscript} //don't mess this came from EL
	</script>
	</c:when>
	<c:otherwise>
	<div class="qnc_content">
		<span class="qnc_time">сообщений нет. все хорошо.</span>
	</div>
	<script>
	$(document).ready(function() {
		$('#notify_ballon').html('');
	});
	${btndelscript} //don't mess this came from EL
	</script>	
	</c:otherwise>
</c:choose>
</c:if>