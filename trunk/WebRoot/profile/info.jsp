<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%><div id="divUserInfoContent">
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
		String sql = "SELECT name,email,location,job,affiliation,website,aboutme,interests FROM userinfo WHERE user_id=";
		if(user_id==null){
			sql += ub.getUserID();
		}else{
			sql += user_id;
		}
		String name=null;
		String email=null;
		String location=null;
		String job=null;
		String affiliation=null;
		String website=null;
		String aboutme=null;
		String interests=null;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			name = rs.getString("name");
			email = rs.getString("email");
			location = rs.getString("location");
			job = rs.getString("job");
			affiliation = rs.getString("affiliation");
			website = rs.getString("website");
			aboutme = rs.getString("aboutme");
			interests = rs.getString("interests");
			
%>
<table width="100%" border="0" cellspacing="0" cellpadding="2" >
	<tr>
		<td width="85%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					Info
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
							<tr> 
								<td width="20%" valign="top" style="font-weight: bold;">Name:</td>
						  		<td><%if(name==null){out.print("Not specified");}else{out.print(name);} %></td>
							</tr>
<% 
			if(user_id==null){
%>
							<tr> 
								<td width="20%" valign="top" style="font-weight: bold;">Email:</td>
						  		<td><%if(email==null){out.print("Not specified");}else{out.print(email + "&nbsp;<i>(only you can see this)</i>");} %></td>
							</tr>
<%				
			}
%>
							<tr> 
								<td width="20%" valign="top" style="font-weight: bold;">Job Title:</td>
						  		<td><%if(job==null){out.print("Not specified");}else{out.print(job);} %></td>
							</tr>
							<tr> 
								<td width="20%" valign="top" style="font-weight: bold;">Affiliation:</td>
						  		<td><%if(affiliation==null){out.print("Not specified");}else{out.print(affiliation);} %></td>
							</tr>
							<tr> 
								<td width="20%" valign="top" style="font-weight: bold;">Website:</td>
						  		<td><%if(website==null){out.print("Not specified");}else{out.print(website);} %></td>
							</tr>
							<tr> 
								<td width="20%" valign="top" style="font-weight: bold;">About me:</td>
						  		<td><%if(aboutme==null){out.print("Not specified");}else{out.print(aboutme);} %></td>
							</tr>
							<tr> 
								<td width="20%" valign="top" style="font-weight: bold;">Interests:</td>
						  		<td><%if(interests==null){out.print("Not specified");}else{out.print(interests);} %></td>
							</tr>
						
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
		<td width="15%" valign="top">
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
					<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
						<tr>
							<td>No friend</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>	
<%			
		}
	}
%>
	<script type="text/javascript">
		window.onload = function(){
			if(divUserInfoContent){
				if(parent.displayTalks){
					parent.displayTalks(divUserInfoContent.innerHTML);
				}
			}
		}
	</script>	
</div>
