<%@ page contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jstl/xml_rt" prefix="x" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib prefix="isoft" tagdir="/WEB-INF/tags/isoft" %>
<%@ include file='default.jsp'%>
<%  request.setCharacterEncoding("ISO-8859-1"); %>
<%  response.setCharacterEncoding("ISO-8859-1"); %>

<c:set var="whitespc">
<fmt:requestEncoding value="ISO-8859-1" />

<c:set var="uag" value='<%=request.getHeader("user-agent")%>' />
<c:choose>
	<c:when test="${(fn:contains(uag,'ealink')) and (fn:contains(uag,'SIP-T2')) and (fn:contains(uag,'.6'))}">
		<c:set var="gentemplate">/phones/yealinkT2X.tpl</c:set>
	</c:when>
	<c:when test="${(fn:contains(uag,'ealink')) and (fn:contains(uag,'SIP-T3'))}">
		<c:set var="gentemplate">/phones/yealinkT3X.tpl</c:set>
	</c:when>
	<c:when test="${(fn:contains(uag,'ealink')) and (fn:contains(uag,'VP'))}">
		<c:set var="gentemplate">/phones/yealinkVP.tpl</c:set>
	</c:when>
	<c:when test="${fn:contains(uag,'Chrome')}">
		<c:set var="gentemplate">/phones/yealinkT2X.tpl</c:set>
	</c:when>
	<c:otherwise>

	</c:otherwise>
</c:choose>

<c:choose>
<c:when test="${!empty gentemplate}">

<c:if test="${empty datapro}">
<sql:setDataSource var="datapro" driver="com.mysql.jdbc.Driver"
   url="jdbc:mysql://localhost/isoft_config?autoReconnect=true&useUnicode=true&characterEncoding=UTF8"
   user="*user*"  password="*pwd*" scope="session" />
</c:if>

<c:set var="newline" value="<%= \"\n\" %>" />
<c:set var="newliner" value="<%= \"\r\" %>" />
<c:set var="nl" value="<%= \"\n\" %>" />

	<c:set var="macc" value="${param.mac}"/>
	<c:if test="${! empty macc}">
		<isoft:regexp pat="^[0-9-a-zA-Z]{1,20}+$" value="${macc}" var="chkMac1"/>
			<c:if test="${chkMac1 == 'true'}">
				<sql:query dataSource="${datapro}" var="getMac1">
					select * from devices where macaddr = ?
					<sql:param value="${macc}"/>
				</sql:query>
					<c:if test="${getMac1.rowCount != 1}">
						<c:redirect url="work/preprovision.jsp?mac=${macc}"/>
					</c:if>
					<c:if test="${getMac1.rowCount == 1}">
						<c:set var="pext" value="${getMac1.rows[0].provisionextension}"/>
						<c:set var="pid" value="${getMac1.rows[0].id}"/>
						<c:set var="ppwd" value="${getMac1.rows[0].provisionpassword}"/>
						<c:set var="pkey" value="${getMac1.rows[0].aeskey}"/>
						<c:set var="pstat" value="${getMac1.rows[0].statusflag}"/>
							<c:choose>							
								<c:when test="${(pstat == '0') or (pstat == '1')}">
<c:set var="sm">enabled=1${nl}label=A-${pext}${nl}username=${pext}${nl}password=${ppwd}${nl}aeskey=${pkey}${nl}serverhost=${preserver}${nl}serverport=${preserverport}${nl}provision_retry_min=1</c:set>
									<isoft:jtpl template="/siteroot/templates/${gentemplate}" params="${sm}" var="result" delm1="${newline}" delm2="=" />
									<sql:update dataSource="${datapro}">
										update devices set statusflag = 1 where id = ?
										<sql:param value="${pid}"/>
									</sql:update>
									<isoft:loger l1="${datapro}" l2="${getMac1.rows[0].shiporder}" l3m="${getMac1.rows[0].macaddr}" l3e="A-${pext}" l3u="" l4="auth provision send"/>
								</c:when>
								<c:when test="${(pstat == '4') or (pstat == '5')}">
									<sql:query dataSource="${datapro}" var="getext1">
										select orgid,extid from activation where deviceid=?
										<sql:param value="${pid}"/>
									</sql:query>
										<c:if test="${getext1.rowCount == 1}">
											<c:set var="aorgid" value="${getext1.rows[0].orgid}"/>
											<c:set var="aextid" value="${getext1.rows[0].extid}"/>
												<sql:query dataSource="${datapro}" var="getsubver">
												select id from subversion where orgid = ? order by id desc LIMIT 0,1
												<sql:param value="${aorgid}"/>
												</sql:query>
												<c:set var="subver" value="${getsubver.rows[0].id}"/>
												<sql:query dataSource="${datapro}" var="getbranch">
												select branchid,extension from extensionsorg_${aorgid}_${subver} where id = ? 
												<sql:param value="${aextid}"/>
												</sql:query>
												<c:set var="branch" value="${getbranch.rows[0].branchid}"/>
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
														<isoft:mapsplit sortedmap="${workparams.rows}" var="sm" key="param" keyval="paramvalue" delm1="${newline}" delm2="="/>
														<c:set var="result">${sm}</c:set>
														
														<isoft:jtpl template="/siteroot/templates/${gentemplate}" params="${sm}${nl}provision_retry_min=720" var="result" delm1="${newline}" delm2="=" />
														
												<sql:update dataSource="${datapro}">
													update devices set statusflag = 5 where id = ?
													<sql:param value="${pid}"/>
												</sql:update>
												<isoft:aes var="result" value="${result}" key="${pkey}"/>
											<%--	<isoft:loger l1="${datapro}" l2="${aorgid}" l3m="${getMac1.rows[0].macaddr}" l3e="${getbranch.rows[0].extension}" l3u="" l4="work provision send bID:${getbranch.rows[0].branchid}"/>--%>
										</c:if>
								</c:when>
								<c:otherwise>
								</c:otherwise>
							</c:choose>
						<sql:update dataSource="${datapro}">
								update devices set lastip = ?, lasttime = Now() where id = ?
								<sql:param value="<%=request.getRemoteAddr()%>"/>
								<sql:param value="${getMac1.rows[0].id}"/>
						</sql:update>	
					</c:if>
			</c:if>
	</c:if>
</c:when>
<c:otherwise>
<c:set var="result">you device not supported</c:set>
</c:otherwise>
</c:choose>
</c:set>${result}