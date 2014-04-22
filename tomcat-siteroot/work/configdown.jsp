<%@ page contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jstl/xml_rt" prefix="x" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib prefix="isoft" tagdir="/WEB-INF/tags/isoft" %>
<%  request.setCharacterEncoding("ISO-8859-1"); %>
<%  response.setCharacterEncoding("ISO-8859-1"); %>
<c:set var="newline" value="<%= \"\n\" %>" />
<c:set var="newliner" value="<%= \"\r\" %>" />
<c:set var="nl" value="<%= \"\n\" %>" />
<c:set var="whitespc">
<!--
	OPENWRTorg1branch2.config
	(PBXType)org(OrgID)branch(branchID).config
	
	extra params is 'type': can be equal only to dialplan1,dialplan2,customsip
	no param will generate sip account list
-->
<fmt:requestEncoding value="UTF-8" />
	<c:set var="device" value="${param.device}"/>
	<isoft:regexp pat="^[0-9-a-zA-Z]{1,40}+$" value="${device}" var="chkdev1"/>
		<c:if test="${chkdev1 == 'true'}">
		  	<c:set var="agent">${fn:trim(fn:substringBefore(device,'org'))}</c:set>
			<c:set var="org">${fn:trim(fn:substringBefore(fn:substringAfter(device,'org'),'branch'))}</c:set>
			<c:set var="branch">${fn:trim(fn:substringAfter(device,'branch'))}</c:set>
				<isoft:regexp pat="^[0-9-a-zA-Z]{1,20}+$" value="${agent}" var="chkdev2"/>
				<isoft:regexp pat="^[0-9]{1,5}+$" value="${org}" var="chkdev3"/>
				<isoft:regexp pat="^[0-9]{1,5}+$" value="${branch}" var="chkdev4"/>
					<c:if test="${chkdev2 == 'true'}">
						<c:if test="${agent == 'OPENWRT'}"><c:set var="template">pbx/openwrt.tpl</c:set></c:if>
						<c:if test="${agent == 'ASTERISK18'}"><c:set var="template">pbx/asterisk18.tpl</c:set></c:if>
					</c:if>
					<c:if test="${(chkdev2 == 'true') and (chkdev3 == 'true') and (chkdev4 == 'true') and (! empty template)}">
						<sql:setDataSource var="datapro" driver="com.mysql.jdbc.Driver"
						   url="jdbc:mysql://localhost/isoft_config?autoReconnect=true&useUnicode=true&characterEncoding=UTF8"
						   user="*user*"  password="*pwd*"/>
						<sql:query dataSource="${datapro}" var="chkorg1">
							select id from orgs where id=?
							<sql:param value="${org}"/>
						</sql:query>
							<c:if test="${chkorg1.rowCount == 1}">
								<c:set var="aorgid" value="${org}"/>
								<sql:query dataSource="${datapro}" var="getsubver">
									select id from subversion where orgid = ? order by id desc LIMIT 0,1
									<sql:param value="${chkorg1.rows[0].id}"/>
								</sql:query>
								<c:set var="subver" value="${getsubver.rows[0].id}"/>
									<sql:query dataSource="${datapro}" var="getExts">
									select id,cabin from extensionsorg_${aorgid}_${subver} where branchid = ? 
									<sql:param value="${branch}"/>
									</sql:query>
									<c:if test="${getExts.rowCount > 0 }">
										<sql:query dataSource="${datapro}" var="getKey">
										select aeskey from branchesorg_${aorgid}_${subver} where id = ? 
										<sql:param value="${branch}"/>
										</sql:query>
										<c:choose>
											<c:when test="${empty param.type}">
												<c:forEach var="exts" items="${getExts.rows}" varStatus="status">
													<c:set var="aextid" value="${exts.id}"/>
													<sql:query dataSource="${datapro}" var="workparams">	
													(select 	params.param,extensionparams_${aorgid}_${subver}.paramvalue
																from extensionparams_${aorgid}_${subver},params 
													where extensionparams_${aorgid}_${subver}.extenid=? and params.id = extensionparams_${aorgid}_${subver}.paramid
													)
													UNION 
													(select 	params.param,branchparams_${aorgid}_${subver}.paramvalue
																from branchparams_${aorgid}_${subver},params 
													where 	branchparams_${aorgid}_${subver}.branchid=? and params.id = branchparams_${aorgid}_${subver}.paramid
																and branchparams_${aorgid}_${subver}.paramid 	
																NOT IN (select paramid from extensionparams_${aorgid}_${subver} where extenid=?)
													)
														<sql:param value="${aextid}"/>
														<sql:param value="${branch}"/>
														<sql:param value="${aextid}"/>
													</sql:query>
														<c:remove var="cabin"/>
														<isoft:regexp pat="^[0-9]{1,2}+$" value="${exts.cabin}" var="chkCabin1"/>
														<c:if test="${chkCabin1 == 'true'}"><c:set var="cabin" value="${nl}cabin=${exts.cabin}"/></c:if>
													<isoft:mapsplit sortedmap="${workparams.rows}" var="sm" key="param" keyval="paramvalue" delm1="${newline}" delm2="="/>
													<c:set var="result">${sm}</c:set>
													<isoft:jtpl template="/siteroot/templates/${template}" params="${sm}${cabin}" var="tresult" delm1="${newline}" delm2="=" />
													<c:set var="sresult">${sresult} ${not status.first ? newline : ''} ${tresult}</c:set>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<c:set var="sresult">dummy!</c:set>
												<c:if test="${(param.type=='dialplan1') or (param.type=='dialplan2') or (param.type=='customsip') or (param.type=='updinterval')}">
													<sql:query dataSource="${datapro}" var="dp">
														select ${param.type} AS 'dptext' from branchesorg_${aorgid}_${subver} where id = ?
													 <sql:param value="${branch}"/>
													</sql:query>
													<c:if test="${(param.type=='dialplan1') or (param.type=='dialplan2') or (param.type=='customsip')}">
														<sql:query dataSource="${datapro}" var="dpglobal">
															select ${param.type} AS 'dptext' from orgs where id = ?
														 <sql:param value="${aorgid}"/>
														</sql:query>
													</c:if>
													<c:if test="${(param.type=='dialplan1') or (param.type=='dialplan2')}">
														<c:set var="sresult">${dp.rows[0][param.type]} ${nl} ${dpglobal.rows[0][param.type]}</c:set>
													</c:if>
													<c:if test="${param.type=='customsip'}">
														<c:set var="sresult">${dpglobal.rows[0][param.type]} ${nl} ${dp.rows[0][param.type]}</c:set>
													</c:if>
													<c:if test="${param.type=='updinterval'}">
														<c:set var="sresult">${dp.rows[0][param.type]}</c:set>
														<c:if test="${sresult == ''}"><c:set var="sresult">120</c:set></c:if>
													</c:if>
												</c:if>
											</c:otherwise>
										</c:choose>
										<c:if test="${! empty param.hwstat}">
											<isoft:b64 value="${param.hwstat}" var="hwstatd" action="decode"/>
											<isoft:regexp pat="^[-0-9A-Za-zА-Яа-я ,:.;()\t]{1,500}+$" value="${hwstatd}" var="chkhwstat1"/>
										</c:if>
										<c:if test="${chkhwstat1 == 'true'}">
											<sql:update dataSource="${datapro}">
												update branchesorg_${aorgid}_${subver} set hwstatus = ? where id = ?
												<sql:param value="${hwstatd}"/>
												<sql:param value="${branch}"/>
											</sql:update>
											<isoft:loger l1="${datapro}" l2="${aorgid}" l3m="" l3e="" l3u="pbx${branch}" l4="${hwstatd}"/>
										</c:if>
										<c:set var="sresult">;start${newline}${sresult}${newline};end</c:set>
										<isoft:aesencode var="result" value="${sresult}" key="${getKey.rows[0].aeskey}"/>
										<sql:update dataSource="${datapro}">
												update branchesorg_${aorgid}_${subver} set lastip = ?, lasttime = Now() where id = ?
												<sql:param value="<%=request.getRemoteAddr()%>"/>
												<sql:param value="${branch}"/>
										</sql:update>
									</c:if>
							</c:if>
					</c:if>
		</c:if>
</c:set>${result}