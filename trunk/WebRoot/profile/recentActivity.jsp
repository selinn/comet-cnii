<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.Date"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>

<% 
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
	Calendar calendar = new GregorianCalendar();
	int day = calendar.get(Calendar.DAY_OF_MONTH);
	int month = calendar.get(Calendar.MONTH);
	int year = calendar.get(Calendar.YEAR);
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String user_id = (String)request.getParameter("user_id");
	if(user_id==null&&ub==null){

	}else{
%>
<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
<%
		connectDB conn = new connectDB();
		String sql = "SELECT u.name,a.activity,a.activity_id,a.activitytime,a.day,a._year,a._time " +
						"FROM activities a JOIN userinfo u ON a.user_id=u.user_id WHERE a.user_id=";
		if(user_id==null){
			sql += ub.getUserID();
		}else{
			sql += user_id;
		}
		sql += " LIMIT 0,100";
		String name=null;
		String activity=null;
		String activity_id=null;
		String activitytime=null;
		String _day=null;
		int _year=0;
		String _time=null;
		ResultSet rsExt;
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			name = rs.getString("name");
			activity = rs.getString("activity");
			activity_id = rs.getString("activity_id");
			activitytime = rs.getString("activitytime");
			_day = rs.getString("day");
			_year = rs.getInt("_year");		
			_time = rs.getString("_time");
			
			if(_year != year){
				_day += ", " + _year;
			}
			
			if(activity.equalsIgnoreCase("joined")){
%>
				<tr> 
					<td valign="top" style="font-weight: bold;"><%=name %></td>
			  		<td valign="top" >joined CoMeT on <%=_day %> at <%=_time %></td>
				</tr>
<%			
			}
			
			if(activity.equalsIgnoreCase("posted")){
				sql = "SELECT a.title FROM activitypost a WHERE activity_id=" + activity_id;
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String title = rsExt.getString("title");
%>
				<tr> 
					<td valign="top" style="font-weight: bold;"><%=name %></td>
			  		<td valign="top" >posted <a href="presentColloquium.do?col_id=<%=activity_id %>"><%=title %></a> on <%=_day %> at <%=_time %></td>
				</tr>
<%			
				}
			}
			if(activity.equalsIgnoreCase("updated")){
				sql = "SELECT a.title FROM activitypost a WHERE activity_id=" + activity_id;
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String title = rsExt.getString("title");
%>
				<tr> 
					<td valign="top" style="font-weight: bold;"><%=name %></td>
			  		<td valign="top" >updated <a href="presentColloquium.do?col_id=<%=activity_id %>"><%=title %></a> on <%=_day %> at <%=_time %></td>
				</tr>
<%			
				}
			}
			if(activity.equalsIgnoreCase("bookmarked")){
				sql = "SELECT a.col_id,a.title FROM activitybookmark a WHERE activity_id=" + activity_id;//It's userprofile_id
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String col_id = rsExt.getString("col_id");
					String title = rsExt.getString("title");
					
					String tags = "";
					sql = "SELECT t.tag,t.tag_id FROM tags tt JOIN tag t ON tt.tag_id=t.tag_id WHERE tt.userprofile_id=" + activity_id;
					rsExt.close();
					rsExt = conn.getResultSet(sql);
					while(rsExt.next()){
						String tag = rsExt.getString("tag");
						String tag_id = rsExt.getString("tag_id");
						
						if(tags.length() > 0){
							tags += ", ";
						}
						
						tags += "<a href=\"tag.do?tag_id=" + tag_id + "\">" + tag + "</a>";
					}
					
					String groups = "";
					sql = "SELECT c.comm_id,c.comm_name FROM community c JOIN contribute ct ON c.comm_id=ct.comm_id WHERE ct.userprofile_id=" + activity_id;
					rsExt.close();
					rsExt = conn.getResultSet(sql);
					while(rsExt.next()){
						String comm_id = rsExt.getString("comm_id");
						String comm_name = rsExt.getString("comm_name");
						
						if(groups.length() > 0){
							groups += ", ";
						}
						
						groups += "<a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a>";
					}
					
					String extraAct = "";
					if(tags.length() > 0){
						extraAct += ", and tagged with " + tags;
					}
					if(groups.length() > 0){
						extraAct += ", and  contributed to " + groups;
					}
%>
				<tr> 
					<td valign="top" style="font-weight: bold;"><%=name %></td>
			  		<td valign="top" >bookmarked <a href="presentColloquium.do?col_id=<%=col_id %>"><%=title %></a> <%=extraAct %> on <%=_day %> at <%=_time %></td>
				</tr>
<%			
				}
			}
		}
	}
%>
</table>