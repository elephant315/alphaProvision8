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
<c:set var="whitecps"><c:set var="result" value="error"/>
<c:catch var="err">
<fmt:requestEncoding value="ISO-8859-1" />
<c:set var="newline" value="<%= \"\n\" %>" />
<c:set var="newliner" value="<%= \"\r\" %>" />
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.Reader"%>
<%@ page import="java.io.StringWriter"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.util.zip.GZIPInputStream"%>
<%@ page import="java.util.zip.*"%>
<%@ page import="java.security.*"%>
<%@ page import="javax.crypto.*"%>
<%@ page import="javax.crypto.spec.*"%>


<c:set var="device" value="${param.device}"/>
<isoft:regexp pat="^[0-9-a-zA-Z]{1,40}+$" value="${device}" var="chkdev1"/>
<c:if test="${chkdev1 == 'true'}">
	<c:set var="agent">${fn:trim(fn:substringBefore(device,'org'))}</c:set>
	<c:set var="org">${fn:trim(fn:substringBefore(fn:substringAfter(device,'org'),'branch'))}</c:set>
	<c:set var="branch">${fn:trim(fn:substringAfter(device,'branch'))}</c:set>
	<isoft:regexp pat="^[0-9-a-zA-Z]{1,20}+$" value="${agent}" var="chkdev2"/>
	<isoft:regexp pat="^[0-9]{1,5}+$" value="${org}" var="chkdev3"/>
	<isoft:regexp pat="^[0-9]{1,5}+$" value="${branch}" var="chkdev4"/>
	<c:if test="${(chkdev2 == 'true') and (chkdev3 == 'true') and (chkdev4 == 'true') and (! empty param.report) and (! empty param.md5)}">
		<c:set var="report" value="${param.report}"/>
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
			<sql:query dataSource="${datapro}" var="getKey">
				select aeskey from branchesorg_${aorgid}_${subver} where id = ? 
			<sql:param value="${branch}"/>
			</sql:query>
			<c:set var="aeskey" value="${getKey.rows[0].aeskey}"/>
			<!--
			<c:set var="csvtest">
			"","501","181","context-user-501","""HomeDroid"" <501>","SIP/501-00000004","SIP/isoft-00000005","Dial","SIP/181@isoft,60","2012-08-01 15:41:08","2012-08-01 15:41:08","2012-08-01 15:41:13",5,5,"ANSWERED","DOCUMENTATION","1343835668.4",""
			"","501","181","context-user-501","""HomeDroid"" <501>","SIP/501-00000000","SIP/isoft-00000001","Dial","SIP/181@isoft,60","2012-08-01 15:59:33","2012-08-01 15:59:34","2012-08-01 15:59:45",12,11,"ANSWERED","DOCUMENTATION","1343836773.0",""
			"","501","181","context-user-501","""HomeDroid"" <501>","SIP/501-00000002","SIP/isoft-00000003","Dial","SIP/181@isoft,60","2012-08-01 16:03:21","2012-08-01 16:03:21","2012-08-01 16:03:26",5,5,"ANSWERED","DOCUMENTATION","1343837001.2",""
			"","501","181","context-user-501","""HomeDroid"" <501>","SIP/501-00000004","SIP/isoft-00000005","Dial","SIP/181@isoft,60","2012-08-01 16:03:38","2012-08-01 16:03:38","2012-08-01 16:03:46",8,8,"ANSWERED","DOCUMENTATION","1343837018.4",""
			</c:set>

			<%
			//	String str = (String) pageContext.getAttribute("csvtest");
			//	ByteArrayOutputStream outa = new ByteArrayOutputStream();
			//   GZIPOutputStream gzip = new GZIPOutputStream(outa);
			//    gzip.write(str.getBytes());
			//    gzip.close();
			//    String zipstring=outa.toString("ISO-8859-1");
			%>
			-->

			<%
				String key = (String) pageContext.getAttribute("aeskey");
				String todecrypt = (String) pageContext.getAttribute("report");

				byte[] raw=key.getBytes("ISO-8859-1");
				SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
				Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
				cipher.init(Cipher.DECRYPT_MODE, skeySpec);
				byte[] decrypted = cipher.doFinal(todecrypt.getBytes("ISO-8859-1"));

				GZIPInputStream gzipInputStream =new GZIPInputStream(new ByteArrayInputStream(decrypted));
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				for (int value = 0; value != -1;) {
				    value = gzipInputStream.read();
				    if (value != -1) {
				                     baos.write(value);
				    }
				}
				gzipInputStream.close();
				baos.close();
				String unzipstring=new String(baos.toByteArray(), "UTF-8");
			%>
			<c:set var="csvdata" value="<%= unzipstring %>"/>
			<isoft:md5end value="${csvdata}" var="chkmd5"/>
			<c:if test="${chkmd5 == param.md5}">
				<isoft:csvcdr csv="${csvdata}" var="cdrarray"/>
				<c:if test="${fn:length(cdrarray) > 0}">
					<c:forEach items="${cdrarray}" var="cdr">
					<sql:query dataSource="${datapro}" var="chkuniq">
						select uniqueid from cdr_${aorgid}_b${branch} where uniqueid=? and src = ?
					 <sql:param value="${cdr.uniqueid}"/>
					 <sql:param value="${cdr.src}"/>
					</sql:query>
					<c:if test="${chkuniq.rowCount == 0}">
						<sql:update dataSource="${datapro}">
						insert into cdr_${aorgid}_b${branch} 
							(accountcode,src,dst,dcontext,clid,channel,dstchannel,lastapp,lastdata,start,answer,end,duration,billsec,disposition,amaflags,uniqueid)
							values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
							<sql:param value="${cdr.accountcode}"/>
							<sql:param value="${cdr.src}"/>
							<sql:param value="${cdr.dst}"/>
							<sql:param value="${cdr.dcontext}"/>
							<sql:param value="${cdr.clid}"/>
							<sql:param value="${cdr.channel}"/>
							<sql:param value="${cdr.dstchannel}"/>
							<sql:param value="${cdr.lastapp}"/>
							<sql:param value="${cdr.lastdata}"/>
							<sql:param value="${cdr.start}"/>
							<sql:param value="${cdr.answer == '' ? null : cdr.answer}"/> 
							<sql:param value="${cdr.end == '' ? null : cdr.end}"/>
							<sql:param value="${cdr.duration == '' ? null : cdr.duration}"/>
							<sql:param value="${cdr.billsec == '' ? null : cdr.billsec}"/>
							<sql:param value="${cdr.disposition}"/>
							<sql:param value="${cdr.amaflags}"/>
							<sql:param value="${cdr.uniqueid}"/>
						</sql:update>
					</c:if>
					</c:forEach>
					<c:set var="result" value="ok"/>	
				</c:if>
			</c:if>
		</c:if>	
	</c:if>
</c:if>
</c:catch></c:set>${result}${err}
