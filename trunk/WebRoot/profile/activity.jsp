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
<div id="divUserActivityContent">
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
		redirect("login.do");
		//window.setTimeout(function(){window.location="login.do";},50);
	</script>
<%		
	}else{
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td width="75%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
<% 
			if(ub!=null){
				boolean allowed2shareComment = false;
				if(user_id==null||user_id==String.valueOf(ub.getUserID())){
					allowed2shareComment = true;
				}else if(user_id!=null){//Is there a friendship
					String user0_id = user_id;
					String user1_id = "" + ub.getUserID();
					if(Integer.parseInt(user_id) > ub.getUserID()){
						user0_id = "" + ub.getUserID();
						user1_id = user_id;
					}
					String sql = "SELECT friend_id FROM friend WHERE user0_id=" + user0_id + " AND user1_id=" + user1_id + " AND breaktime IS NULL";
					connectDB conn = new connectDB();
					ResultSet rs = conn.getResultSet(sql);
					if(rs.next()){
						String friend_id = rs.getString("friend_id");
						allowed2shareComment = true;
					}
				}
				if(allowed2shareComment){
%>
				<tr>
					<td><input type="text" id="usercomment" size="90"></input>&nbsp;<input class="btn" id="btnShareComment" type="button" value="Share"></input></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
<% 
				}
			}
%>
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
						<tiles:insert template="/profile/recentActivity.jsp" />
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
</div>
<script type="text/javascript">
	window.onload = function(){
		if(divUserActivityContent){
			if(parent.displayTalks){
				parent.displayTalks(divUserActivityContent.innerHTML);
			}
		}
	}
</script>	
