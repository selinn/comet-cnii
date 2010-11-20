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
			Popular Series
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
%>
	<tr>
		<td>
			<ol start="<%=start+1 %>">
<%
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT s.series_id,s.name,s.description,COUNT(*) _count " +
					"FROM series s,seriescol sc,colloquium c,userprofile u " +
					"WHERE s.series_id = sc.series_id AND " +
					"sc.col_id = c.col_id AND " +
					"u.col_id = c.col_id AND " +
					"c._date >= (SELECT beginterm FROM sys_config) AND " +
					"c._date < (SELECT endterm FROM sys_config) ";
	if(affiliate_id > 0){
		sql += "AND s.series_id IN " +
				"(SELECT afs.series_id FROM affiliate_series afs," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE afs.affiliate_id = cc.child_id " +
				"UNION SELECT series_id FROM affiliate_series WHERE affiliate_id = " + affiliate_id + ") ";
	}
	sql += "GROUP BY s.series_id,s.name,s.description " +
			//"HAVING _min <= CURDATE() AND _max >= CURDATE() " +
	  			"ORDER BY _count DESC " +
			"LIMIT " + start + "," + rows;
	//out.println(sql);
    try{
    	rs = conn.getResultSet(sql);
        while(rs.next()){
%>
				<li>
					<a href="series.do?series_id=<%=rs.getString("series_id")%>" style="text-decoration: none;font-size: 0.75em;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'"
						>
					<%=rs.getString("name") %>
					&nbsp;-&nbsp;<span style="font-size: 0.85em;"><%=rs.getString("_count") %> bookmarks</span>
					</a>&nbsp;
					<a href="PreCreateSeries.do?series_id=<%=rs.getString("series_id")%>"
						style="text-decoration: none;font-size: 0.6375em;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'"
					>Edit</a>
				</li>
<%
		}
		rs.close();
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	 conn.conn.close();
	 conn = null;
	}
%>
			</ol>
		</td>
	</tr>
	<tr>
		<td>
<% 
	if(rows==5){
%>
				<div style="color:#003399;cursor:pointer;font-size: 0.75em;font-weight: bold;"  
					onmouseover="this.style.textDecoration='underline'" 
					onmouseout="this.style.textDecoration='none'"
					onclick="window.location='series.do'">More &gt;&gt;</div>
<%	
	}else{

	}
%>
		</td>
	</tr>
</table>