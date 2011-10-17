<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
			Highest Comet Score Talks
		</td>
	</tr>
<% 
	session = request.getSession(false);
	int rows = 20;
	int start = 0;
	int affiliate_id = -1;
	if(request.getParameter("rows")!=null){
		rows = Integer.parseInt((String)request.getParameter("rows"));
	}	
	if(request.getParameter("start") != null){
		start = Integer.parseInt((String)request.getParameter("start"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}

	connectDB conn = new connectDB();
	
	String sql = "SELECT c.col_id,c.title, date_format(c._date,'%b %e') talkdate, " +
			      "date_format(c.begintime,'%l:%i %p') talktime, s.name, 3*ci.bookmarkno+2*ci.emailno+ci.viewno as comets " +  
				  "FROM colloquium c,speaker s, col_impact ci " +
				  "where ci.col_id= c.col_id and s.speaker_id = c.speaker_id " +
				  "GROUP BY c.col_id " +
	    		  "ORDER BY comets DESC " +
				  "LIMIT " + start + "," + rows;  		  
	
%>
	<tr>
		<td>
			<ol start="<%=start+1 %>">
<%
    try{
    	ResultSet rs = conn.getResultSet(sql);
        while(rs.next()){
%>
				<li>						
					<a href="presentColloquium.do?col_id=<%=rs.getString("col_id")%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>" 
						style="text-decoration: none;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'">
						<span style="font-size: 0.8em;"><%=rs.getString("title") %></span>
						<br/><span style="font-size: 0.65em;"><%=rs.getString("name")%>&nbsp;<%=rs.getString("talkdate")%>&nbsp;<%=rs.getString("talktime")%></span>					
					</a>
				</li>
<%
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}catch(SQLException ex){
	    out.println(ex.toString());
	}
%>
			</ol>
<% 
	if(rows==3){
%>
				<div style="color:#003399;cursor:pointer;font-size: 0.75em;font-weight: bold;" 
					onmouseover="this.style.textDecoration='underline'" 
					onmouseout="this.style.textDecoration='none'"
					onclick="window.location='popCometScore.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'">More &gt;&gt;</div>
<%	
	}else{

	}
%>
		</td>
	</tr>
</table>