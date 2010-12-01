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
	session.setAttribute("before-login-redirect", 
		"series.do" + (request.getQueryString()==null?"":"?" + request.getQueryString()));
%>
</logic:notPresent>
<% 
	String series_id = (String)request.getParameter("series_id");
	if(series_id == null){
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="2">
			<html:link style="font-size: 0.85em;" forward="aaa.pre.create.series">Create New Series</html:link>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td width="50%" valign="top" style="padding-right: 1px;">
			<tiles:insert template="/utils/recentSeries.jsp" />
		</td>
		<td width="50%" valign="top" style="padding-left: 1px;">
			<tiles:insert template="/utils/popSeries.jsp" />
		</td>
	</tr>
</table>
<% 
	}else{
		session=request.getSession(false);
		connectDB conn = new connectDB();
		String sql = "SELECT s.name,s.description,s.owner_id,u.name owner,s.url " +
						"FROM series s,userinfo u WHERE s.owner_id = u.user_id AND s.series_id = " + series_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String name = rs.getString("name");
			String description = rs.getString("description");
			String owner_id = rs.getString("owner_id");
			String owner = rs.getString("owner");
			String url = rs.getString("url");
%>
<script type="text/javascript">
<!--
	var aTitle = "CoMeT | Series: ";
	aTitle = aTitle.concat('<%=name%>');
	window.setTimeout(function(){document.title = aTitle;},50);	
//-->
</script>
 <table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="2" align="left" style="color: #003399;font-weight: bold;font-size: 0.9em;">
			Series: <%=name%>
		</td>
	</tr>
	<tr>
		<td style="font-size: 0.8em;">
			Post by <a href="calendar.do?user_id=<%=owner_id%>"><%=owner%></a><br/>
			URL: <a href="<%=url%>"><%=url%></a><br/>
			<%=description%>
		</td>
		<td align="right" valign="top"><input class="btn" type="button" onclick="document.location='PreCreateSeries.do?series_id=<%=series_id%>'" value="Edit" /></td>
	</tr>
	<tr>
		<td align="left" valign="top" width="650">
			<div id="divMain">
				<tiles:insert template="/includes/bookmarks.jsp" />			
			</div>
        </td>
		<td align="right" valign="top" width="130"> 
			<br/>	
			<div id="divFeed">
				<tiles:insert template="/utils/feed.jsp" />
			</div>
			<logic:present name="UserSession">
				<div id="divTag">
					<tiles:insert template="/utils/tagCloud.jsp" />
				</div>
				<div id="divFacet">
					<tiles:insert template="/utils/namedEntity.jsp" />
				</div>
			</logic:present>
        </td>
	</tr>
</table>
<%		
		}else{
%>
<span style="color: #003399;font-size: 0.9em;font-weight: bold;">Series Not Found</span>
<%		
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}
%>
