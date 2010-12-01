<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Date"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%><div id="divUserActivityContent">
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
%>
	<script type="text/javascript">
		window.setTimeout(function(){window.location="login.do";},50);
	</script>
<%		
	}else{
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td width="75%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					Recent Activity
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
<%
		connectDB conn = new connectDB();
		String sql = "SELECT activity,activity_id,activitytime,day,_year,_time FROM activities WHERE user_id=";
		if(user_id==null){
			sql += ub.getUserID();
		}else{
			sql += user_id;
		}
		sql += " LIMIT 0,100";
		String activity=null;
		String activity_id=null;
		Date activitytime=null;
		String _day=null;
		int _year=0;
		String _time=null;
		ResultSet rsExt;
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			activity = rs.getString("activity");
			activity_id = rs.getString("activity_id");
			activitytime = rs.getDate("activitytime");
			_day = rs.getString("day");
			_year = rs.getInt("_year");		
			_time = rs.getString("_time");
			
			if(_year != year){
				_day += ", " + _year;
			}
			
			if(activity.equalsIgnoreCase("joined")){
%>
				<tr> 
					<td width="10%" valign="top" style="font-weight: bold;"><%=ub.getName() %></td>
			  		<td>joined CoMeT on <%=_day %> at <%=_time %></td>
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
					<td width="10%" valign="top" style="font-weight: bold;"><%=ub.getName() %></td>
			  		<td>posted <a href="presentColloquium.do?col_id=<%=activity_id %>"><%=title %></a> on <%=_day %> at <%=_time %></td>
				</tr>
<%			
				}
			}
			if(activity.equalsIgnoreCase("bookmarked")){
				sql = "SELECT a.col_id,a.title FROM activitybookmark a WHERE activity_id=" + activity_id;
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String col_id = rsExt.getString("col_id");
					String title = rsExt.getString("title");
%>
				<tr> 
					<td width="10%" valign="top" style="font-weight: bold;"><%=ub.getName() %></td>
			  		<td>bookmarked <a href="presentColloquium.do?col_id=<%=col_id %>"><%=title %></a> on <%=_day %> at <%=_time %></td>
				</tr>
<%			
				}
			}
		}
%>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
		<td width="25%" valign="top">
			<tiles:insert template="/profile/basicInfo.jsp" />
		</td>
	</tr>
</table>	
<%
	}
%>
	<script type="text/javascript">
		window.onload = function(){
			if(divUserActivityContent){
				if(parent.displayTalks){
					parent.displayTalks(divUserActivityContent.innerHTML);
				}
			}
		}
	</script>	
</div>