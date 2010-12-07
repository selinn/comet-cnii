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
	
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Iterator"%><script type="text/javascript">
		window.setTimeout(function(){window.location="login.do";},50);
	</script>
<%		
	}else{
		connectDB conn = new connectDB();
		ResultSet rs;
		String sql;
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
					<table width="100%" border="0" cellspacing="0" cellpadding="1" style="font-size: 0.7em;">
						<tr>
							<td>No friend</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
<%
		if(user_id==null){
%>
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					External Email Contacts
					</td>
				</tr>
				<tr>
					<td style="border: 1px #EFEFEF solid;">
						<table width="100%" border="0" cellspacing="0" cellpadding="1" style="font-size: 0.7em;">
<% 
			sql = "SELECT emails FROM emailfriends WHERE user_id=" + ub.getUserID() + " GROUP BY emails";
			rs = conn.getResultSet(sql);
			if(rs!=null){
				HashSet<String> emailSet = new HashSet<String>();
				while(rs.next()){				
					String[] email = rs.getString("emails").trim().split(",");
					if(email!=null){
						for(int i=0;i<email.length;i++){
							emailSet.add(email[i].trim().toLowerCase());
						}
					}
				}
				if(emailSet.size() > 0){
					int i=0;
					for(Iterator<String> it=emailSet.iterator();it.hasNext();){
						if(i%2==0){
							out.println("<tr>");
						}
						out.print("<td>" + it.next() + "</td>");
						if(i%2==1){
							out.println("</tr>");
						}
						i++;
					}
					if(i%2==1){
						out.println("<td>&nbsp;</td></tr>");	
					}
				}else{
					%>
							<tr>
								<td>No contact</td>
							</tr>
<%				
				}
			}else{
%>
							<tr>
								<td>No contact</td>
							</tr>
<%				
			}
%>
						</table>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
<%			
		}
%>
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
					<table width="100%" border="0" cellspacing="0" cellpadding="1" style="font-size: 0.7em;">
<% 
		sql = "SELECT c.comm_name,c.comm_id " +
				"FROM contribute ct JOIN community c ON ct.comm_id = c.comm_id " +
				"JOIN userprofile u ON ct.userprofile_id = u.userprofile_id " +
				" WHERE u.user_id=" + (user_id==null?ub.getUserID():user_id) +
				" GROUP BY c.comm_name,c.comm_id " +
				"ORDER BY COUNT(*) DESC";
		rs = conn.getResultSet(sql);
		if(rs!=null){
			int i=0;
			while(rs.next()){
				String comm_name = rs.getString("comm_name");
				String comm_id = rs.getString("comm_id");
				if(i%2==0){
					out.println("<tr>");
				}
				out.print("<td><a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a></td>");
				if(i%2==1){
					out.println("</tr>");
				}
				i++;
			}
			if(i%2==1){
				out.println("<td>&nbsp</td></tr>");
			}
%>

<%		
		}else{
%>
						<tr>
							<td>No group</td>
						</tr>
<%			
		}
%>
					</table>
					</td>
				</tr>
			</table>
<%			
	}
%>
