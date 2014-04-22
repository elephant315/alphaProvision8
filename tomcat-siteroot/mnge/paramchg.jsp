<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<script>
$(function () { 
	
	$('#submit').click(function() { 
		$('#updresult').load('paramchg.jsp?action=${param.action}&chgparam=${param.chgparam}&paramval='+$('#param').val());
		});
	$('#delete').click(function() { 
		$('#updresult').load('paramchg.jsp?action=${param.action}&chgparam=${param.chgparam}&paramdel=true');
		});
});
</script>


<c:if test="${(! empty param.action) and (! empty param.chgparam)}">
<c:if test="${param.action == 'extension'}">
	<c:set var="a1" value="extensionparams"/>
	</c:if>
<c:if test="${param.action == 'branch'}">
	<c:set var="a1" value="branchparams"/>
	</c:if>
	<c:catch var="catch1">
		<sql:query dataSource="${databas}" var="chk1">
			select paramid,paramvalue from ${a1}_${G_org}_${G_ver} where id = ? 
		<sql:param value="${param.chgparam}"/>
		</sql:query>
			<c:if test="${chk1.rowCount == 1}">
				<sql:query dataSource="${databas}" var="chk2">
					select rgexp,paramdescr,param from params where id = ? 
				<sql:param value="${chk1.rows[0].paramid}"/>
				</sql:query>
					<c:if test="${chk2.rowCount == 1}">
						<c:choose>
							<c:when test="${! empty param.paramval}">
								<isoft:regexp pat="${chk2.rows[0].rgexp}" value="${param.paramval}" var="chk3"/>
									<c:choose>
									<c:when test="${chk3 == 'true'}">
										<sql:update dataSource="${databas}">
											update ${a1}_${G_org}_${G_ver} set paramvalue = ? where id = ? limit 1
											<sql:param value="${param.paramval}"/>
											<sql:param value="${param.chgparam}"/>
										</sql:update>
										<script>
										//alert('${param.paramval} - ${param.chgparam}');
										<c:if test="${chk2.rows[0].rgexp != '^[0-1]{1}+$'}">$('#el_${param.chgparam}').html('${param.paramval}');</c:if>
										$.modal.close();
										</script>
									</c:when>
									<c:otherwise>
									<span class="ticket ticket-warning">Параметр не сохранен</span><br/>неверное значение: ${param.paramval}
									</c:otherwise>
									</c:choose>
							</c:when>
							<c:when test="${param.paramdel == 'true'}">
									<sql:update dataSource="${databas}">
										delete from ${a1}_${G_org}_${G_ver} where id = ? limit 1
										<sql:param value="${param.chgparam}"/>
									</sql:update>
									<script>
									$('#el_${param.chgparam}').html('<span class="ticket ticket-warning">удален</span>');
									$.modal.close();
									</script>
							</c:when>
							<c:otherwise>
								<div id="updresult">
								<div class="widget-content">
										<div class="field-group">
											<label for="ip"><b>${chk2.rows[0].param}:</b></label>
											<div class="field">
												<input type="text" name="param" id="param" value="${chk1.rows[0].paramvalue}" size="29"/>	
												<label><br/>${chk2.rows[0].paramdescr}<br/></label>
											</div>
										</div> <!-- .field-group -->
										<div class="actions">
											<hr/ style="margin:30px 20px 0px 0px;">
											<button type="submit" class="btn btn-success" id="submit" style="float:left;margin:10px 0px 0px 0px;">Применить</button>
											<button type="submit" class="btn btn-warning" id="delete" style="float:right;margin:10px 70px 0px 0px;">Удалить</button>											
										</div> <!-- .actions -->
								</div> <!-- .widget-content -->
								</div>
							</c:otherwise>
						</c:choose>
					</c:if>
			</c:if>

	</c:catch>${catch1}
</c:if>
