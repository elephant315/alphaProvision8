<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jstl/xml_rt" prefix="x" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib prefix="isoft" tagdir="/WEB-INF/tags/isoft" %>
<%  request.setCharacterEncoding("UTF-8"); %>
<%  response.setCharacterEncoding("UTF-8"); %>
<fmt:requestEncoding value="UTF-8" />   
<%-- default application jsp --%>

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
									<td>${dso.macaddr}
										</td>
									<td>${dso.manufacturer} / ${dso.model} <br/>sn:${dso.serial}</td>
									<td>${! empty dso.lastip ? dso.lastip : 'нет данных'}</td>
									<td>A-${dso.provisionextension}</td>
									<td><c:if test="${dso.statusflag > 3}">
											<sql:query dataSource="${databasp}" var="as">
												select extensionsorg_${G_org}_${G_ver}.*, 
												activation.extid from extensionsorg_${G_org}_${G_ver},activation 
												where activation.deviceid = ? and extensionsorg_${G_org}_${G_ver}.id = activation.extid
												<sql:param>${dso.id}</sql:param>
											</sql:query>
											<strong>${as.rows[0].extension}</strong>&nbsp;(${as.rows[0].name}&nbsp;${as.rows[0].secondname})<br/> 
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
</c:if>