<%@ page language="java"%>
<%@ page import="edu.pitt.sis.beans.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>


<logic:notPresent name="UserSession">
<% 
	String pagePath = "community.do";
	
	if(request.getQueryString()!=null){
		pagePath += "?" + request.getQueryString();
	} 
	session.setAttribute("before-login-redirect", pagePath);
%>
</logic:notPresent>
<% 
	String comm_id = (String)request.getParameter("comm_id");
	if(comm_id == null){
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="3"><html:link style="font-size: 0.85em;" forward="aaa.pre.make.community">Create New Group</html:link></td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td width="47.5%" valign="top">
			<tiles:insert template="/utils/recentCommunity.jsp" />
		</td>
		<td width="5%">&nbsp;</td>
		<td width="47.5%" valign="top">
			<tiles:insert template="/utils/popCommunity.jsp" />
		</td>
	</tr>
</table>
<% 
	}else{
		connectDB conn = new connectDB();
		String sql = "SELECT comm_name,comm_desc FROM community WHERE comm_id = " + comm_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String comm_name = rs.getString("comm_name");
			String comm_desc = rs.getString("comm_desc");
%>
<script type="text/javascript">
<!--
	var aTitle = "CoMeT | Group: ";
	aTitle = aTitle.concat('<%=comm_name%>');
	window.setTimeout(function(){document.title=aTitle;},50);	
//-->
</script>
 <table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="2" width="100%" align="center" style="color: #003399;font-weight: bold;font-size: 0.95em;">
			Group: <%=comm_name%>
<% 
			if(comm_desc.length() > 0){
				out.print("<div align='left' style='color: black;font-weight: normal;font-size: 0.75em;'><br/>" + comm_desc + "</div>");	
			}
%>			
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" width="690">
			<div id="divMain">
				<tiles:insert template="/includes/bookmarks.jsp" />			
			</div>
        </td>
		<td align="right" valign="top" width="90"> 		
			<br/>
			<div id="divFeed">
				<tiles:insert template="/utils/feed.jsp" />
			</div>
			<logic:present name="UserSession">
				<br/>
				<div id="divTag">
					<tiles:insert template="/utils/tagCloud.jsp" />
				</div>
				<br/>
				<div id="divFacet">
					<tiles:insert template="/utils/namedEntity.jsp" />
				</div>
			</logic:present>
        </td>
	</tr>
</table>
<%		
			rs.close();
			rs = null;
			conn.conn.close();
			conn = null;
		}else{
%>
<span style="font-size: 0.75em;font-weight: bold;">Community Not Found</span>
<%		
		}
	}
%>
