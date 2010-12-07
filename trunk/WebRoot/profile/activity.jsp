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
