<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='papp.jsp'%>
<%@ include file='h_menu.jsp'%>
<isoft:regexp pat="^[0-9]{1,10}+$" value="${param.branch}" var="chkbranch1"/>
<isoft:regexp pat="^[0-9A-Za-zА-Яа-я ,.]{1,40}+$" value="${param.search}" var="chksrch1"/>

<c:choose>
	<c:when test="${(chkbranch1 == 'true') and (G_bookmanager == param.branch)}">

	<c:if test="${param.action == 'edit'}">
		<c:set var="err" value="2"/>
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.city}" var="chk_city"/>
		<c:if test="${chk_city == 'true'}"><c:set var="ecity" value="${param.city}"/></c:if>
		<c:if test="${chk_city == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Город;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я ():,.-]{1,100}+$" value="${param.addr}" var="chk_addr"/>
		<c:if test="${chk_addr == 'true'}"><c:set var="eaddr" value="${param.addr}"/></c:if>
		<c:if test="${chk_addr == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Адрес;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.techname1}" var="chk_techname1"/>
		<c:if test="${chk_techname1 == 'true'}"><c:set var="etechname1" value="${param.techname1}"/></c:if>
		<c:if test="${chk_techname1 == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Имя;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.techname2}" var="chk_techname2"/>
		<c:if test="${chk_techname2 == 'true'}"><c:set var="etechname2" value="${param.techname2}"/></c:if>
		<c:if test="${chk_techname2 == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Фамилия;"/></c:if>		
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.techphone1}" var="chk_techphone1"/>
		<c:if test="${chk_techphone1 == 'true'}"><c:set var="etechphone1" value="${param.techphone1}"/></c:if>
		<c:if test="${chk_techphone1 == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Телефон;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.techphone2}" var="chk_techphone2"/>
		<c:if test="${chk_techphone2 == 'true'}"><c:set var="etechphone2" value="${param.techphone2}"/></c:if>
		<c:if test="${chk_techphone2 == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Телефон;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.crmcell1}" var="chk_crmcell1"/>
		<c:if test="${chk_crmcell1 == 'true'}"><c:set var="ecrmcell1" value="${param.crmcell1}"/></c:if>
		<c:if test="${chk_crmcell1 == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Сотовый Тел;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.crmcell2}" var="chk_crmcell2"/>
		<c:if test="${chk_crmcell2 == 'true'}"><c:set var="ecrmcell2" value="${param.crmcell2}"/></c:if>
		<c:if test="${chk_crmcell2 == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Сотовый Тел;"/> </c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.crmadslphone}" var="chk_crmadslphone"/>
		<c:if test="${chk_crmadslphone == 'true'}"><c:set var="ecrmadslphone" value="${param.crmadslphone}"/></c:if>
		<c:if test="${chk_crmadslphone == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} номер ADSL Тел;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.crmethsock}" var="chk_crmethsock"/>
		<c:if test="${chk_crmethsock == 'true'}"><c:set var="ecrmethsock" value="${param.crmethsock}"/></c:if>
		<c:if test="${chk_crmethsock == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Наличие розетки Ethernet;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.crmservcase}" var="chk_crmservcase"/>
		<c:if test="${chk_crmservcase == 'true'}"><c:set var="ecrmservcase" value="${param.crmservcase}"/></c:if>
		<c:if test="${chk_crmservcase == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Серверная стойка;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.crmheadaccess}" var="chk_crmheadaccess"/>
		<c:if test="${chk_crmheadaccess == 'true'}"><c:set var="ecrmheadaccess" value="${param.crmheadaccess}"/></c:if>
		<c:if test="${chk_crmheadaccess == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Доступ к Головному офису;"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.crmvlan}" var="chk_crmvlan"/>
		<c:if test="${chk_crmvlan == 'true'}"><c:set var="ecrmvlan" value="${param.crmvlan}"/></c:if>
		<c:if test="${chk_crmvlan == 'false'}"><c:set var="ecrmvlan" value="0"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я :,.-]{1,100}+$" value="${param.crmdhcp}" var="chk_crmdhcp"/>
		<c:if test="${chk_crmdhcp == 'true'}"><c:set var="ecrmdhcp" value="${param.crmdhcp}"/></c:if>
		<c:if test="${chk_crmdhcp == 'false'}"><c:set var="ecrmdhcp" value="0"/></c:if>
		
		<isoft:regexp pat="^[0-9A-Za-zА-Яа-я _.-@]{1,100}+$" value="${param.crmmail}" var="chk_crmmail"/>
		<c:if test="${chk_crmmail == 'true'}"><c:set var="ecrmmail" value="${param.crmmail}"/></c:if>
		<c:if test="${chk_crmmail == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} MAIL;"/></c:if>
		
		<isoft:regexp pat="^[0-9./]{1,100}+$" value="${param.crmpbxip}" var="chk_crmpbxip"/>
		<c:if test="${chk_crmpbxip == 'true'}"><c:set var="ecrmpbxip" value="${param.crmpbxip}"/></c:if>
		<c:if test="${chk_crmpbxip == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Server IP;"/></c:if>
		
		<isoft:regexp pat="^[0-9.]{1,100}+$" value="${param.crmpbxgw}" var="chk_crmpbxgw"/>
		<c:if test="${chk_crmpbxgw == 'true'}"><c:set var="ecrmpbxgw" value="${param.crmpbxgw}"/></c:if>
		<c:if test="${chk_crmpbxgw == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Server IP Gateway;"/></c:if>
		
		<isoft:regexp pat="^[0-9.]{1,100}+$" value="${param.crmippool1}" var="chk_crmippool1"/>
		<c:if test="${chk_crmippool1 == 'true'}"><c:set var="ecrmippool1" value="${param.crmippool1}"/></c:if>
		<c:if test="${chk_crmippool1 == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Phone IP pool start;"/></c:if>
		
		<isoft:regexp pat="^[0-9.]{1,100}+$" value="${param.crmippool2}" var="chk_crmippool2"/>
		<c:if test="${chk_crmippool2 == 'true'}"><c:set var="ecrmippool2" value="${param.crmippool2}"/></c:if>
		<c:if test="${chk_crmippool2 == 'false'}"><c:set var="err" value="1"/><c:set var="errmsg" value="${errmsg} Phone IP pool end;"/></c:if>
		
	</c:if>
		<sql:query dataSource="${databasp}" var="branch">
		select * from branchesorg_${G_org}_${G_ver} where id=?
			<sql:param value="${param.branch}"/>
		</sql:query>
			<c:set var="bid" value="${branch.rows[0].id}"/>
			<c:set var="bname" value="${branch.rows[0].name}"/>
			<c:set var="bcity" value="${branch.rows[0].city}"/>
			<c:set var="baddr" value="${branch.rows[0].addr}"/>
			<c:set var="btechperson" value="${branch.rows[0].techperson}"/>
			<c:set var="btechtel" value="${branch.rows[0].techtel}"/>
			<c:set var="btime" value="${branch.rows[0].lasttime}"/>
			<c:set var="blastip" value="${branch.rows[0].lastip}"/>
			
			<sql:query dataSource="${databasp}" var="loadcrm1">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Сотовый телефон:%"
			</sql:query>
			<c:set var="crm1id" value="${loadcrm1.rows[0].id}"/><c:set var="crm1info" value="${fn:substringAfter(loadcrm1.rows[0].info,'Сотовый телефон: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm2">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Номер телефона для SIP iDphone:%"
			</sql:query>
			<c:set var="crm2id" value="${loadcrm2.rows[0].id}"/><c:set var="crm2info" value="${fn:substringAfter(loadcrm2.rows[0].info,'Номер телефона для SIP iDphone: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm3">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Наличие розетки Ethernet:%"
			</sql:query>
			<c:set var="crm3id" value="${loadcrm3.rows[0].id}"/><c:set var="crm3info" value="${fn:substringAfter(loadcrm3.rows[0].info,'Наличие розетки Ethernet: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm4">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Серверная стойка:%"
			</sql:query>
			<c:set var="crm4id" value="${loadcrm4.rows[0].id}"/><c:set var="crm4info" value="${fn:substringAfter(loadcrm4.rows[0].info,'Серверная стойка: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm5">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Доступ к Головному офису:%"
			</sql:query>
			<c:set var="crm5id" value="${loadcrm5.rows[0].id}"/><c:set var="crm5info" value="${fn:substringAfter(loadcrm5.rows[0].info,'Доступ к Головному офису: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm6">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Существуют VLAN:%"
			</sql:query>
			<c:set var="crm6id" value="${loadcrm6.rows[0].id}"/><c:set var="crm6info" value="${fn:substringAfter(loadcrm6.rows[0].info,'Существуют VLAN: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm7">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Настроен DHCP в сети:%"
			</sql:query>
			<c:set var="crm7id" value="${loadcrm7.rows[0].id}"/><c:set var="crm7info" value="${fn:substringAfter(loadcrm7.rows[0].info,'Настроен DHCP в сети: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm8">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "Mail:%"
			</sql:query>
			<c:set var="crm8id" value="${loadcrm8.rows[0].id}"/><c:set var="crm8info" value="${fn:substringAfter(loadcrm8.rows[0].info,'Mail: ')}"/>			
			<sql:query dataSource="${databasp}" var="loadcrm9">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "IP адрес ATC:%"
			</sql:query>
			<c:set var="crm9id" value="${loadcrm9.rows[0].id}"/><c:set var="crm9info" value="${fn:substringAfter(loadcrm9.rows[0].info,'IP адрес ATC: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm10">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "IP шлюз для АТС:%"
			</sql:query>
			<c:set var="crm10id" value="${loadcrm10.rows[0].id}"/><c:set var="crm10info" value="${fn:substringAfter(loadcrm10.rows[0].info,'IP шлюз для АТС: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm11">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "IP адреса начало:%"
			</sql:query>
			<c:set var="crm11id" value="${loadcrm11.rows[0].id}"/><c:set var="crm11info" value="${fn:substringAfter(loadcrm11.rows[0].info,'IP адреса начало: ')}"/>
			<sql:query dataSource="${databasp}" var="loadcrm12">
				select id,info from crm where idorg="${G_org}" and idbr="${bid}" and info like "IP адреса конец:%"
			</sql:query>
			<c:set var="crm12id" value="${loadcrm12.rows[0].id}"/><c:set var="crm12info" value="${fn:substringAfter(loadcrm12.rows[0].info,'IP адреса конец: ')}"/>
			
		<div id="content">

			<div id="contentHeader">
				<c:if test="${! empty param.search}"><h1>Поиск: ${param.search}</h1></c:if>
				<c:if test="${chkbranch1 == 'true'}">
				<h1>${bname}</h1>
				</c:if>
				<c:if test="${(chkbranch1 == 'false') and (empty param.search) and  (fn:length(getPhones.rows[0].bname) gt 0)}">
				<h1>${getPhones.rows[0].bname}</h1>
				</c:if>
			</div> <!-- #contentHeader -->	
			<div class="container">
				<div class="grid-24">
					
					<c:choose>
						<c:when test="${(err == '2') and (branch.rowCount == 1) }">
								<sql:update dataSource="${databasp}">
									update branchesorg_${G_org}_${G_ver} set 
									city="${ecity}", addr="${eaddr}", techperson="${etechname1} ${etechname2}", techtel="${etechphone1} ${etechphone2}" 
									where id = ?
								 <sql:param value="${bid}"/>
								</sql:update>

								<c:choose>
									<c:when test="${loadcrm1.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="Сотовый телефон: ${ecrmcell1} ${ecrmcell2}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm1id}"
										 <sql:param value="Сотовый телефон: ${ecrmcell1} ${ecrmcell2}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm2.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="Номер телефона для SIP iDphone: ${ecrmadslphone}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm2id}"
										 <sql:param value="Номер телефона для SIP iDphone: ${ecrmadslphone}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm3.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="Наличие розетки Ethernet: ${ecrmethsock}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm3id}"
										 <sql:param value="Наличие розетки Ethernet: ${ecrmethsock}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm4.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="Серверная стойка: ${ecrmservcase}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm4id}"
										 <sql:param value="Серверная стойка: ${ecrmservcase}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm5.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="Доступ к Головному офису: ${ecrmheadaccess}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm5id}"
										 <sql:param value="Доступ к Головному офису: ${ecrmheadaccess}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm6.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="Существуют VLAN: ${ecrmvlan}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm6id}"
										 <sql:param value="Существуют VLAN: ${ecrmvlan}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm7.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="Настроен DHCP в сети: ${ecrmdhcp}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm7id}"
										 <sql:param value="Настроен DHCP в сети: ${ecrmdhcp}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm8.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="Mail: ${ecrmmail}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm8id}"
										 <sql:param value="Mail: ${ecrmmail}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm9.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="IP адрес ATC: ${ecrmpbxip}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm9id}"
										 <sql:param value="IP адрес ATC: ${ecrmpbxip}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm10.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="IP шлюз для АТС: ${ecrmpbxgw}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm10id}"
										 <sql:param value="IP шлюз для АТС: ${ecrmpbxgw}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm11.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="IP адреса начало: ${ecrmippool1}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm11id}"
										 <sql:param value="IP адреса начало: ${ecrmippool1}"/></sql:update></c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${loadcrm12.rowCount == 0}"><sql:update dataSource="${databasp}">
											insert into crm (idorg,idbr,type,cdata,who,info) values ("${G_org}","${bid}","3",Now(),"techmanager",?)
										 <sql:param value="IP адреса конец: ${ecrmippool2}"/></sql:update></c:when>
									<c:otherwise>
										<sql:update dataSource="${databasp}">
											update crm set info = ?, cdata = Now(), who = "techmanager" where id = "${crm12id}"
										 <sql:param value="IP адреса конец: ${ecrmippool2}"/></sql:update></c:otherwise>
								</c:choose>
								
									<div class="notify notify">
										<a href="javascript:;" class="close">&times;</a>
										<h3>Изменения сделаны!</h3>
										<p><a href="editbranch.jsp?branch=${bid}" class="btn btn-primary">вернуться</a></p>
									</div> <!-- .notify -->
									<isoft:loger l1="${databasp}" l2="${G_org}" l3m="" l3e="" l3u="${G_bookmanagerPerson}" l4="branch info update: ${ecity}, ${eaddr}, ${etechname1} ${etechname2}, ${etechphone1} ${etechphone2}"/>
									<c:set var="G_bookmanagerPerson" value="${etechname1} ${etechname2}" scope="session"/>
						</c:when>
						<c:otherwise>
				
									<c:if test="${err == '1'}">
											<div class="notify notify-error">
												<a href="javascript:;" class="close">&times;</a>
												<h3>Ошибка редактирования</h3>
												<p>Введены недопустимые символы или некоторые поля пустые. Разрешенные символы 0-9A-Za-zА-Яа-я :,.-<hr/>${errmsg}</p>
											</div> <!-- .notify -->
									</c:if>
				
									<form class="form uniformForm" method="post" action="editbranch.jsp?branch=${param.branch}&action=edit">

										<div class="widget">

											<div class="widget-header">
												<span class="icon-book-alt"></span>
												<h3>Общая информация</h3>
											</div> <!-- .widget-header -->

											<div class="widget-content">
							
												<div class="field-group">
													<label>Адрес:</label>

													<div class="field">
														<input type="text" name="city" id="city" size="25" value="${err == '1' ? param.city : bcity}"/>
														<label for="city">Область</label>
													</div>

													<div class="field">
														<input type="text" name="addr" id="addr" size="40" value="${err == '1' ? param.addr : baddr}" />
														<label for="addr">Город, Улица, дом</label>
													</div>
												</div> <!-- .field-group -->
							
												<div class="field-group">
													<label>Системный Администратор:</label>

													<div class="field">
														<input type="text" name="techname1" id="techname1" size="25" value="${err == '1' ? param.techname1 : fn:substringBefore(btechperson, " ")}"/>
														<label for="techname1">Имя</label>
													</div>
													<div class="field">
														<input type="text" name="techname2" id="techname2" size="25" value="${err == '1' ? param.techname2 : fn:substringAfter(btechperson, " ")}"/>
														<label for="techname2">Фамилия</label>
													</div>
												</div> <!-- .field-group -->

												<div class="field-group">
													<label>Контактный телефон:</label>

													<div class="field">
														<input type="text" name="techphone1" id="techphone1" size="25" value="${err == '1' ? param.techphone1 : fn:substring(btechtel, 0, 3)}"/>
														<label for="techphone1">Код (например: 727)</label>
													</div>

													<div class="field">
														<input type="text" name="techphone2" id="techphone2" size="25" value="${err == '1' ? param.techphone2 : fn:substring(btechtel, 4,11)}"/>
														<label for="techphone2">Номер (например: 2747070)</label>
													</div>
												</div> <!-- .field-group -->
												
												<div class="field-group">
													<label>Почтовый адрес:</label>

													<div class="field">
														<input type="text" name="crmmail" id="crmmail" size="25" value="${err == '1' ? param.crmmail : crm8info}"/>
														<label for="crmmail">Код (например: info@isoft.kz)</label>
													</div>

												</div> <!-- .field-group -->
							
												<div class="field-group">
													<label>Сотовый:</label>

													<div class="field">
														<input type="text" name="crmcell1" id="crmcell1" size="25" value="${err == '1' ? param.crmcell1 : fn:substring(crm1info, 0, 3)}"/>
														<label for="phone1">Код (например: 777)</label>
													</div>

													<div class="field">
														<input type="text" name="crmcell2" id="crmcell2" size="25" value="${err == '1' ? param.crmcell2 : fn:substring(crm1info, 4,11)}"/>
														<label for="phone2">Номер (например: 2747070)</label>
													</div>
												</div> <!-- .field-group -->
							
											</div> <!-- .widget-content -->
										</div> <!-- .widget -->
										<div class="widget">

										<div class="widget-header">
											<span class="icon-wrench"></span>
											<h3>Технические детали</h3>
										</div> <!-- .widget-header -->

										<div class="widget-content">
						
											<div class="field-group">
												<label>Номер телефона для SIP iDphone:</label>

												<div class="field">
													<input type="text" name="crmadslphone" id="crmadslphone" size="25" value="${err == '1' ? param.crmadslphone : crm2info}" />
													<label for="phone1">например: 2747070 или "оптика"</label>
												</div>

											</div> <!-- .field-group -->
						
												<div class="field-group control-group inline">	
													<label>Наличие розетки Ethernet (и портов на коммутаторах) для телефонов:</label>	

													<div class="field">
														<input type="radio" name="crmethsock" id="crmethsock" value="1" ${((err == "1") and (param.crmethsock == "1") or (crm3info == "1")) ? "checked" : " "} />
														<label for="crmethsock">да</label>
													</div>

													<div class="field">
														<input type="radio" name="crmethsock" id="crmethsock" value="2" ${((err == "1") and (param.crmethsock == "2") or (crm3info == "2")) ? "checked" : " "}/>
														<label for="crmethsock">нет</label>
													</div>

												</div>	

												<div class="field-group control-group inline">	
													<label>Серверная стойка (19"):</label>	

													<div class="field">
														<input type="radio" name="crmservcase" id="crmservcase" value="1" ${((err == "1") and (param.crmservcase == "1") or (crm4info == "1")) ? "checked" : " "}/>
														<label for="crmservcase">да</label>
													</div>

													<div class="field">
														<input type="radio" name="crmservcase" id="crmservcase" value="2" ${((err == "1") and (param.crmservcase == "2") or (crm4info == "2")) ? "checked" : " "}/>
														<label for="crmservcase">нет</label>
													</div>

												</div>
							
												<div class="field-group control-group inline">	
													<label>Доступ к Центральному офису (ping 172.16.17.xxx):</label>	

													<div class="field">
														<input type="radio" name="crmheadaccess" id="crmheadaccess" value="1" ${((err == "1") and (param.crmheadaccess == "1") or (crm5info == "1")) ? "checked" : " "} />
														<label for="crmheadaccess">да</label>
													</div>

													<div class="field">
														<input type="radio" name="crmheadaccess" id="crmheadaccess" value="2" ${((err == "1") and (param.crmheadaccess == "2") or (crm5info == "2")) ? "checked" : " "}/>
														<label for="crmheadaccess">нет</label>
													</div>

												</div>
							
							
												<div class="field-group control-group">	
													<label>Локальная сеть:</label>

													<div class="field">
														<input type="checkbox" name="crmvlan" id="crmvlan" value="1" ${((err == "1") and (param.crmvlan == "1") or (crm6info == "1")) ? "checked" : " "}/>
														<label for="crmvlan">Существуют VLAN</label>
													</div>

													<div class="field">
														<input type="checkbox" name="crmdhcp" id="crmdhcp" value="1" ${((err == "1") and (param.crmdhcp == "1") or (crm7info == "1")) ? "checked" : " "}/>
														<label for="crmdhcp">Настроен DHCP в сети</label>
													</div>

												</div>
												
												<div class="field-group">
													<label>IP настройки ATC:</label>
													<p>* Внимание, с данными настройками локальный сервер АТС должен иметь доступ к серверу настроек. (ping 172.16.17.222)</p>
													<div class="field">
														<input type="text" name="crmpbxip" id="crmpbxip" size="30" value="${err == '1' ? param.crmpbxip : crm9info}"/>
														<label for="crmpbxip">IP адрес и маска, например: 172.16.32.123/24</label>
													</div>
													
													<div class="field">
														<input type="text" name="crmpbxgw" id="crmpbxgw" size="30" value="${err == '1' ? param.crmpbxgw : crm10info}"/>
														<label for="crmpbxgw">Шлюз, например: 172.16.32.20</label>
													</div>
												</div> <!-- .field-group -->
												
												<div class="field-group">
													<label>Диапазон IP адресов для телефонов:</label>
													<div class="field">
														<input type="text" name="crmippool1" id="crmippool1" size="30" value="${err == '1' ? param.crmippool1 : crm11info}"/>
														<label for="crmippool1">например: 192.168.20.10</label>
													</div>
													
													<div class="field">
														<input type="text" name="crmippool2" id="crmippool2" size="30" value="${err == '1' ? param.crmippool2 : crm12info}"/>
														<label for="crmippool2">например: 192.168.20.150</label>
													</div>
												</div> <!-- .field-group -->

										</div> <!-- .widget-content -->

									</div> <!-- .widget -->
					
										<div class="actions">
											<button type="submit" class="btn btn-error">Сохранить</button>
										</div> <!-- .actions -->
									</form>
				
								</div>
						</c:otherwise>
					</c:choose>
			</div>
		</div>
	</c:when>
	
	<c:otherwise>
		<div id="content">none!</div>
	</c:otherwise>
</c:choose>

	<c:set var="pagescript">

	</c:set>
	
<%@ include file='foot.jsp'%>
