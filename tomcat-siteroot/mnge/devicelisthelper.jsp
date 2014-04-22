<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
	
<c:if test="${! empty ds.rows}">
					<div class="widget-content">
						<table class="table table-bordered table-striped data-table">
						<thead>
							<tr>
								<th>MAC</th>
								<th>Модель и серийный #</th>
								<th>Время и IP</th>
								<th># преднастройки</th>
								<th>Состояние устройства</th>
								<th>Статус</th>
							</tr>
						</thead>
						<tbody>
							
							<c:forEach var="dso" items="${ds.rows}">
								<tr class="odd">
									<td>${dso.macaddr}<c:if test="${(dso.statusflag != '0') and (dso.statusflag < 4)}"><br/>
									<a href="dashboard.jsp?sendtobox=${dso.id}" class="sendtoboxun">в кoробку</a></c:if>
									</td>
									<td>${dso.manufacturer} / ${dso.model} <br/>sn:${dso.serial}</td>
									<td>${! empty dso.lastip ? dso.lastip : 'нет данных'}</td>
									<td>A-${dso.provisionextension}</td>
									<td><c:if test="${dso.statusflag > 3}">
											<sql:query dataSource="${databas}" var="as">
												select extensionsorg_${G_org}_${G_ver}.*, 
												activation.extid from extensionsorg_${G_org}_${G_ver},activation 
												where activation.deviceid = ? and extensionsorg_${G_org}_${G_ver}.id = activation.extid
												and activation.orgid = ${G_org}
												<sql:param>${dso.id}</sql:param>
											</sql:query>
											<strong><a href="extension.jsp?id=${as.rows[0].id}">${as.rows[0].extension}</a></strong>&nbsp;(${as.rows[0].name}&nbsp;${as.rows[0].secondname})<br/> 
										</c:if>
										${dso.statusflag == '0' ? 'в коробке':''} 
										${dso.statusflag == '1' ? 'активация отправлена':''} 
										${dso.statusflag == '2' ? 'регистрируется но, не в сети':''} 
										${dso.statusflag == '3' ? 'включен и регистрируется':''} 
										${dso.statusflag == '4' ? 'активирован':''} 
										${dso.statusflag == '5' ? 'зарегистрирован':''} 
										${dso.statusflag == '6' ? 'зарегистрирован но не в сети':''} 
										${dso.statusflag == '7' ? 'зарегистрирован в сети':''} 
										${dso.statusflag == '8' ? 'заблокирован':''} 
										${dso.statusflag == '9' ? 'jailbreak':''}
										
											<c:if test="${! empty dso.lasttime}">
												<isoft:friendlytime time="${dso.lasttime}" var="hc"/>
											</c:if>
											
									</td>
									<td>
										${dso.statusflag == '0' ? '<img src="images/stream/box.png"/>':''} 
										${dso.statusflag == '1' ? '<img src="images/stream/person-grey-warning.png"/>':''} 
										${dso.statusflag == '2' ? '<img src="images/stream/person-error.png"/>':''} 
										${dso.statusflag == '3' ? '<img src="images/stream/person-grey.png"/>':''} 
										
										${dso.statusflag == '4' ? '<img src="images/stream/person-warning.png"/>':''} 
										${dso.statusflag == '5' ? '<img src="images/stream/person-blue.png"/>':''} 
										${dso.statusflag == '6' ? '<img src="images/stream/person-blue.png"/>':''} 
										${dso.statusflag == '7' ? '<img src="images/stream/person-blue.png"/>':''} 
										
										${dso.statusflag == '8' ? '<img src="images/stream/person-black.png"/>':''} 
										${dso.statusflag == '9' ? '<img src="images/stream/person-black.png"/>':''} 
										
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
	</div> <!-- .widget-content -->	
	<c:set var="pagescript">
	<script>
		$('.sendtoboxun').live ('click', function (e) {
			e.preventDefault ();
			var targetUrl = $(this).attr("href");
			$.alert ({ 
				type: 'confirm'
				, title: 'Отправка в коробку'
				, text: '<p>Вы уверены что хотите этого?</p>'
				, callback: function () { window.location.href = targetUrl }	
			});		
		});
	</script>
	</c:set>
</c:if>