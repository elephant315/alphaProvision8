<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<c:catch var="catch1">
<x:parse var="doc"><?xml version="1.0" encoding="UTF-8"?>${param.xmldata}</x:parse>
<x:forEach var="nodes" select="$doc/diagram/node">
	<c:set var="pnodes">${pnodes}${newline}
		diagram.addNode(new Node({
		'nodeId': '<x:out select="@nodeId" />',
		'nodeType':'<x:out select="@nodeType" />',
		'nodeContent': '<x:out select="content" escapeXml="false"/>',
		'xPosition':<x:out select="@xPosition" />,
		'yPosition':<x:out select="@yPosition" />,
		'width': '<x:out select="@width" />',
		'height' : '<x:out select="@height" />',
		'bgColor':'<x:out select="@bgColor" />',
		'borderColor':'<x:out select="@borderColor" />',
		'borderWidth':'<x:out select="@borderWidth" />',
		'fontColor':'<x:out select="@fontColor" />',
		'fontSize':'<x:out select="@fontSize" />',
		'fontType':'<x:out select="@fontType" />',
		'minHeight':<x:out select="@minHeight" />,
		'maxHeight':<x:out select="@maxHeight" />,
		'minWidth':<x:out select="@minWidth" />,
		'maxWidth':<x:out select="@maxWidth" />,
		'nPort':<x:out select="@nPort" />,
		'ePort':<x:out select="@ePort" />,
		'sPort':<x:out select="@sPort" />,
		'wPort':<x:out select="@wPort" />,
		'image':'<x:out select="@image" />',
		'draggable':<x:out select="@draggable" />,
		'resizable':<x:out select="@resizable" />,
		'editable':<x:out select="@editable" />,
		'selectable':<x:out select="@selectable" />,
		'deletable':<x:out select="@deletable" />,
		'nPortMakeConnection': <x:out select="@nPortMakeConnection" />,
		'ePortMakeConnection': <x:out select="@ePortMakeConnection" />,
		'sPortMakeConnection': <x:out select="@sPortMakeConnection" />,
		'wPortMakeConnection': <x:out select="@wPortMakeConnection" />,
		'nPortAcceptConnection': <x:out select="@nPortAcceptConnection" />,
		'ePortAcceptConnection': <x:out select="@ePortAcceptConnection" />,
		'sPortAcceptConnection': <x:out select="@sPortAcceptConnection" />,
		'wPortAcceptConnection': <x:out select="@wPortAcceptConnection" />
		}));
	</c:set>
</x:forEach>

<x:forEach var="conns" select="$doc/diagram/connection">
	<c:set var="pconns">
		${pconns}${newline}
		diagram.addConnection(new Connection('<x:out select="@nodeFrom" />','<x:out select="@portFrom" />','<x:out select="@nodeTo" />','<x:out select="@portTo" />','<x:out select="@color" />','<x:out select="@stroke" />'));
	</c:set>
</x:forEach>

<c:set var="diagramjs" scope="session">${pnodes}${newline}${pconns}</c:set>
saved!
</c:catch>

<c:if test="${! empty catch1}">error:${catch1}</c:if>

<textarea>${param.xmldata}</textarea>







