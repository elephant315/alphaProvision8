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

<c:if test="${ param.clear == 'yes'}"><c:remove var="G_navblist" scope="session"/></c:if>

<c:choose>
	<c:when test="${empty G_navblist}">
		<sql:query dataSource="${databas}" var="getDept">
		select * from branchesorg_${G_org}_${G_ver} where name like '%Главный%' or name like '%Центральный%' or name like '%Головной%' LIMIT 1
		</sql:query>
		<c:set var="defsearchtitle">, поиск по умолчанию</c:set>
	</c:when>
	<c:otherwise>
	<c:forTokens items="${G_navblist}" delims=";" var="blist" varStatus="status">
		<c:set var="blistsql">${blistsql} name = '${fn:trim(blist)}' ${!status.last ? ' or ' : ''}</c:set>
	</c:forTokens>
	  
		<sql:query dataSource="${databas}" var="getDept">
		select * from branchesorg_${G_org}_${G_ver} where ${blistsql}
		</sql:query>
		
	</c:otherwise>
</c:choose>
	
	<c:choose>
		<c:when test="${getDept.rowCount > 0}">
		
				<div class="widget widget-plain">
					<div class="widget-header">
					<span class="icon-layers"></span>
					<h3>People</h3>
					</div>
					<div class="widget-content">
								<div class="department">
									
									<h2>Результаты, найдено: ${getDept.rowCount}  ${defsearchtitle} <c:if test="${getDept.rowCount < 2}"><c:set var="g_showusers" value="true"/></c:if>
									<br/><br/>
									<div class="icons-holder"><span class="${empty g_showusers ? 'icon-document-alt-stroke' : 'icon-document-alt-fill'}"></span>
									<a href="organization.jsp?showusers=${empty g_showusers ? 'true' : 'false'}">
									<font size="1">${empty g_showusers ? 'показать' : 'спрятать'} пользователей</font></a>
									&nbsp;&nbsp;
									<span class="${empty g_showsipstat ? 'icon-bars' : 'icon-info'}"></span>
									<a href="organization.jsp?showsipstat=${empty g_showsipstat ? 'true' : 'false'}">
									<font size="1">${empty g_showsipstat ? 'статус внешних линий' : 'спрятать статус внешних линий'}</font></a>
									&nbsp;&nbsp;
									<span class="${empty g_showservstat ? 'icon-comment-alt3-stroke' : 'icon-comment-alt3-fill'}"></span>
									<a href="organization.jsp?showservstat=${empty g_showservstat ? 'true' : 'false'}">
									<font size="1">${empty g_showservstat ? 'статус серверов' : 'спрятать статус'}</font></a>
									</div>
									</h2>
										<c:forEach items="${getDept.rows}" var="dept">
											<div class="user-card${g_showusers}">
												<div class="avatar">
													<c:choose>
														<c:when test="${dept.updinterval < 119}"><c:set var="avat" value="maint"/></c:when>
														<c:when test="${! empty dept.lasttime}">
															<isoft:timediff time="${dept.lasttime}" var="hc"/>
															<c:set var="avat" value="cloudblue"/>
																<c:if test="${hc > 240}"><c:set var="avat" value="warning"/></c:if>
														</c:when>
														<c:otherwise><c:set var="avat" value="cloudgrey"/></c:otherwise>
													</c:choose>
													<a href="branch.jsp?id=${dept.id}"><img src="images/${avat}.png" title="User" alt=""></a>
												</div> <!-- .user-card-avatar -->

												<div class="details">
													

													<p>	
														<c:if test="${(fn:length(dept.dialplan1) < 5) or (fn:length(dept.dialplan2) < 5) or (fn:length(dept.customsip) < 5)}">
														<span class="icon-denied"></span>&nbsp;
														</c:if>
														<strong>${dept.id}.&nbsp;<a href="branch.jsp?id=${dept.id}">${dept.name}</a></strong> <i>${dept.lastip}</i>
														<br/>
														${dept.city}&nbsp;${dept.addr} <br/>
														${dept.techperson}&nbsp;${dept.techtel}&nbsp;<br/>
															<c:if test="${! empty g_showsipstat}">
																<c:if test="${fn:contains(dept.hwstatus,'PEER')}">

																	<c:set var="PEERSTOT">${fn:substringAfter(dept.hwstatus,'PEERSTOT:')}</c:set>
																	<c:set var="PEERSTOT">${fn:substringBefore(PEERSTOT,';PEERSREG')}</c:set>
																	
																	<c:set var="PEERSREG">${fn:substringAfter(dept.hwstatus,'PEERSREG:')}</c:set>
																	<c:set var="PEERSREG">${fn:substringBefore(PEERSREG,';SIPPINGLOSS')}</c:set>
																	
																	<c:set var="SIPPINGLOSS">${fn:substringAfter(dept.hwstatus,'SIPPINGLOSS:')}</c:set>
																	<c:set var="SIPPINGLOSS">${fn:substringBefore(SIPPINGLOSS,';SIPTRUNKS')}</c:set>
																	
																	<c:set var="SIPTRUNKS">${fn:substringAfter(dept.hwstatus,'SIPTRUNKS:')}</c:set>
																	<c:set var="SIPTRUNKS">${fn:substringBefore(SIPTRUNKS,';SIPREGISTRY')}</c:set>
																	
																	<c:set var="SIPREGISTRY">${fn:substringAfter(dept.hwstatus,'SIPREGISTRY:')}</c:set>
																	<c:set var="SIPREGISTRY">${fn:substringBefore(SIPREGISTRY,';')}</c:set>

																	<c:set var="SIPPINGQTY" value="${100 - SIPPINGLOSS}"/>
																	
																	<fmt:formatNumber value="${(PEERSREG div PEERSTOT) * 100}" pattern="0" var="PEERRATE"/>
																	<isoft:regexp pat="^[0-9]{1,10}+$" value="${PEERRATE}" var="chPER"/>
																	<c:if test="${chPER != 'true'}"><c:set var="PEERRATE" value="0"/></c:if>
																	<c:if test="${SIPPINGLOSS > 90}">
																	<strong><font color="red">нет связи с SIP шлюзом</font></strong><br/>
																	</c:if>
																	<c:if test="${(SIPTRUNKS != SIPREGISTRY) and (SIPPINGLOSS < 90)}">
																	<strong><font color="red">нет SIP регистрации</font></strong><br/>
																	</c:if>
																	<c:if test="${SIPTRUNKS == '-1'}">
																	<strong><font color="red">остановлен Asterisk</font></strong><br/>
																	</c:if>
																	<c:if test="${PEERSREG == 0}">
																	<strong><font color="red">все аппараты оффлайн</font></strong><br/>
																	</c:if>
																	<span class="ticket ${PEERSREG == 0 ? 'ticket-important' : ''} ${(PEERRATE < 50) and (PEERSREG != 0) ? 'ticket-warning' : ''}">пиры ${PEERSREG} из ${PEERSTOT}</span>&nbsp;
																	<span class="ticket ${SIPTRUNKS != SIPREGISTRY ? 'ticket-important' : ''}" > транки ${SIPREGISTRY} из ${SIPTRUNKS}</span>
																	<span class="ticket ${SIPPINGLOSS > 90 ? 'ticket-important' : ''} ${(SIPPINGLOSS > 0) and (SIPPINGLOSS <= 90) ? 'ticket-warning' : ''}">sip связь ${SIPPINGQTY}%</span>&nbsp;
																</c:if>
																<c:if test="${! fn:contains(dept.hwstatus,'SIP')}">
																<i>нет данных внешних линий</i>
																</c:if>
															</c:if>
														<c:if test="${g_showservstat == 'true'}">
															<c:set var="pram">${fn:substringAfter(dept.hwstatus,'FRAM:')}</c:set>
															<c:set var="pram">${fn:substringBefore(pram,'kb;')}</c:set>
															<c:set var="proot">${fn:substringAfter(dept.hwstatus,'FROOT:')}</c:set>
															<c:set var="proot">${fn:substringBefore(proot,'M;')}</c:set>	
															<c:set var="proot">${fn:substringBefore(proot,'.')}</c:set>
															<c:set var="pcpu">${fn:substringAfter(dept.hwstatus,'load average: ')}</c:set>
															<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>
															<c:set var="pcpu">${fn:substringAfter(pcpu,',')}</c:set>	
															<c:set var="pcpu">${fn:substringBefore(pcpu,';')}</c:set>
															<c:if test="${empty pcpu}"><c:set var="pcpu" value="0"/></c:if>
															<c:choose>
																<c:when test="${! empty dept.hwstatus}">
																	<br/>
																	<span class="ticket ${pram > 500 ? '' : 'ticket-important'}">RAM = ${pram} KB</span>&nbsp;
																	<span class="ticket ${proot > 200 ? '' : 'ticket-important'}">SDA = ${proot} MB</span>&nbsp;
																	<span class="ticket ${pcpu < 0.7 ? '' : 'ticket-important'}">CPU = <fmt:formatNumber value="${pcpu * 100}" pattern="0" var="pcpuok"/> ${pcpuok}%&nbsp;за 15 мин</span>&nbsp;
																</c:when>
																<c:otherwise><h4>Нет тех. данных</h4></c:otherwise>
															</c:choose>
														</c:if>
											<sql:query dataSource="${databas}" var="getExt">
											select extensionsorg_${G_org}_${G_ver}.*, activation.deviceid, activation.code
													from extensionsorg_${G_org}_${G_ver},activation
													 where extensionsorg_${G_org}_${G_ver}.branchid=${dept.id} and extensionsorg_${G_org}_${G_ver}.id = activation.extid
													and activation.orgid = ${G_org}
											</sql:query>
											<c:if test="${g_showusers == 'true'}">
											<c:choose>
												<c:when test="${getExt.rowCount > 0}">
													<div class="widget widget-table">
													<%@ include file='orglisthelper.jsp'%>
													</div> <!-- .widget -->
												</c:when>
												<c:otherwise>
													<div class="notify">
														<a href="javascript:;" class="close">&times;</a>
														<h3>В офисе ${dept.name} нет телефонов?</h3>
														<p>Пожалуйста импортируйте внутренние номера.</p>
													  </div> <!-- .notify -->
												</c:otherwise>
											</c:choose>
											</c:if>		
														</div> <!-- .user-card-content -->
													</div> <!-- .user-card -->
									</c:forEach>

								</div> <!-- .department -->
					</div> <!-- .widget-content -->
				</div> <!-- .widget -->
	
				

		</c:when>
		<c:otherwise>
			<div class="notify notify-error">
				<a href="javascript:;" class="close">&times;</a>
				<h3>Все, приплыли</h3>
				<p>Ничего не найдено.</p>
		  	</div> <!-- .notify -->
		</c:otherwise>
	</c:choose>

