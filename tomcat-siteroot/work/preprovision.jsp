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

<c:set var="whitespc">
<fmt:requestEncoding value="ISO-8859-1" />

<c:set var="uag" value='<%=request.getHeader("user-agent")%>' />
<c:choose>
	<c:when test="${(fn:contains(uag,'ealink')) and (fn:contains(uag,'SIP-T2')) and (fn:contains(uag,'.6'))}">
		<c:set var="gentemplate">/phones/pre_yealinkT2X.tpl</c:set>
	</c:when>
	<c:when test="${(fn:contains(uag,'ealink')) and (fn:contains(uag,'SIP-T3'))}">
		<c:set var="gentemplate">/phones/pre_yealinkT3X.tpl</c:set>
	</c:when>
	<c:when test="${(fn:contains(uag,'ealink')) and (fn:contains(uag,'VP'))}">
		<c:set var="gentemplate">/phones/pre_yealinkVP.tpl</c:set>
	</c:when>
	<c:when test="${fn:contains(uag,'Chrome')}">
		<c:set var="gentemplate">/phones/pre_yealinkT2X.tpl</c:set>
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
					select * from predevices where macaddr = ?
					<sql:param value="${macc}"/>
				</sql:query>
					<c:choose>
					<c:when test="${getMac1.rowCount == 1}">
						<c:choose>
							<c:when test="${fn:contains(gentemplate,'pre_yealink') == true}">
								<c:redirect url="${getMac1.rows[0].proserver}/${macc}.cfg"/>
							</c:when>
							<c:otherwise>
								no idea what to do with you device!
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>

					</c:otherwise>
					</c:choose>
			</c:if>
	</c:if>
</c:when>
<c:otherwise>
<c:set var="result">you device is not supported</c:set>
</c:otherwise>
</c:choose>
</c:set>${result}