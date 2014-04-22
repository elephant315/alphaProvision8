<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>	

<div id="topNav">
	 <ul>
	 	<li>
	 		<c:if test="${(empty G_bookmanager)}"><a href="login.jsp?branch=${param.branch}${fakeparambranch}" class="menu">Логин</a></c:if>
			<c:if test="${!empty G_bookmanager}">
			<a href="index.jsp?branch=${G_bookmanager}" class="menu">Домой</a>
			<a href="login.jsp?logout=true&branch=${G_bookmanager}" class="menu">Выход: ${G_bookmanagerPerson}</a>
			</c:if>
 		</li>
	 </ul>
</div> <!-- #topNav -->


	</div> <!-- #wrapper -->
	<div id="footer">
		Copyright ISOFT &copy; www.isoft.kz
	</div>
	
	${pagescript}
	</body>

	</html>