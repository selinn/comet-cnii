<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<% 
	String user_id = (String)request.getParameter("user_id");
	if(user_id==null){
%>
	<script type="text/javascript">
		window.onload = function(){
			if(parent.displayNoUserIdError){
				parent.displayNoUserIdError("No request user to add.");
			}
		}
	</script>
<%	
	}else{
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		if(ub == null){
%>
	<script type="text/javascript">
		window.onload = function(){
				if(parent.displayUserSessionError){
					parent.displayUserSessionError("Please login to send a friend request.");
				}
		}
	</script>	
<%
			return;
		}
		String location = (String)request.getParameter("location");
		String job = (String)request.getParameter("job");
		String affiliation = (String)request.getParameter("affiliation");
		String website = (String)request.getParameter("website");
		String aboutme = (String)request.getParameter("aboutme");
		String interests = (String)request.getParameter("interests");
		
		connectDB conn = new connectDB();
		String sql = "UPDATE userinfo SET name=?,email=?,location=?,job=?,affiliation=?,website=?,aboutme=?,interests=? " +
				"WHERE user_id=?";
		try {
			PreparedStatement pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1,name);
			pstmt.setString(2,email);
			pstmt.setString(3,location);
			pstmt.setString(4,job);
			pstmt.setString(5,affiliation);
			pstmt.setString(6,website);
			pstmt.setString(7,aboutme);
			pstmt.setString(8,interests);
			pstmt.setInt(9,Integer.parseInt(user_id));
			pstmt.executeUpdate();
			pstmt.close();
		} catch (SQLException e) {
%>
	<script type="text/javascript">
		window.onload = function(){
			if(parent.displayUpdateInfoError){
				parent.displayUpdateInfoError("Error: Please try again.");
			}
		}
	</script>	
<%			
			return;
		}
%>
OK
	<script type="text/javascript">
		window.onload = function(){
			if(parent.displayUpdatedInfo){
				parent.displayUpdatedInfo();
			}
		}
	</script>	
<%
	}
%>