<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<%@page import="edu.pitt.sis.beans.UserBean"%><table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
			Popular Groups
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
	String sql = "SELECT c.comm_id,c.comm_name,COUNT(*) _no " +
					"FROM community c JOIN contribute cc ON c.comm_id = cc.comm_id " +
					"JOIN userprofile u ON cc.userprofile_id = u.userprofile_id " +
	    			"WHERE " +
	    			"u.col_id IN " +
	    			"(SELECT col_id FROM colloquium WHERE _date >= (SELECT beginterm FROM sys_config) AND " +
	    			"_date <= (SELECT endterm FROM sys_config)) ";
	if(affiliate_id > 0){
		sql += "AND u.col_id IN " + 
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ") ";
	}
	sql += "GROUP BY c.comm_id,c.comm_name " +
   			"ORDER BY _no DESC " +
			"LIMIT " + start + "," + rows;
	
    try{
    	rs = conn.getResultSet(sql);
        while(rs.next()){
%>
				<li>
					<a href="community.do?comm_id=<%=rs.getString("comm_id")%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>" style="text-decoration: none;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'">
					<span style="font-size: 0.8em;"><%=rs.getString("comm_name") %></span>
					&nbsp;-&nbsp;<span style="font-size: 0.6em;"><%=rs.getString("_no") %> bookmarks</span>
					</a>&nbsp;
<% 
			String comm_id = rs.getString("comm_id");
			sql = "SELECT COUNT(*) _no FROM final_member_community WHERE comm_id=" + comm_id;
			ResultSet rsExt = conn.getResultSet(sql);
			int memberno = 0;
			if(rsExt.next()){
				memberno = rsExt.getInt("_no");
			}
%>					
					<logic:present name="UserSession">
<% 
			UserBean ub = (UserBean)session.getAttribute("UserSession");
			sql = "SELECT user_id FROM final_member_community WHERE user_id=" + ub.getUserID() +
					" AND comm_id=" + comm_id;
			rsExt = conn.getResultSet(sql);
			boolean membered = false;
			if(rsExt.next()){
				membered = true;
			}
%>
						<span class="spanmemcid<%=comm_id %>" id="spanmempcid<%=comm_id %>"
							style="display: <%=!membered?"none":"inline" %>;font-size: 0.75em;cursor: pointer;background-color: Khaki;font-weight: bold;color: white;"
							onclick="window.location='community.do?comm_id=<%=comm_id %>'"><%=membered?"&nbsp;Joined&nbsp;":"" %>
						</span>&nbsp;
						<a class="amemcid<%=comm_id %>" href="javascript:return false;" 					
							style="text-decoration: none;font-size: 0.6375em;"
							onmouseover="this.style.textDecoration='underline'" 
							onmouseout="this.style.textDecoration='none'"
							onclick="joinCommunity(<%=ub.getUserID() %>,<%=comm_id %>,this,'spanmempcid<%=comm_id %>')"
						><%=membered?"Leave":"Join" %></a>
					</logic:present>
				</li>
<%
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	}
%>
			</ol>
<% 
	if(rows==3){
%>
				<div style="color:#003399;cursor:pointer;font-size: 0.75em;font-weight: bold;" 
					onmouseover="this.style.textDecoration='underline'" 
					onmouseout="this.style.textDecoration='none'"
					onclick="window.location='community.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'">More &gt;&gt;</div>
<%	
	}else{

	}
%>
		</td>
	</tr>
</table>