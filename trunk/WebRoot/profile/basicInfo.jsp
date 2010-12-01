<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<%@page import="edu.pitt.sis.beans.UserBean"%>

<% 
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
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
		connectDB conn = new connectDB();
%>

			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					Friends
					</td>
				</tr>
				<tr>
					<td style="border: 1px #EFEFEF solid;">
					<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
						<tr>
							<td>No friend</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					Groups
					</td>
				</tr>
				<tr>
					<td style="border: 1px #EFEFEF solid;">
					<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
						<tr>
							<td>No group</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
<%			
	}
%>
