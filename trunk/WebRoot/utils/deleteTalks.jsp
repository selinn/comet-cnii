<%@ page language="java" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.sql.PreparedStatement"%>
<%
	session = request.getSession(false);
	
	//No user bean -> redirect to sign in page
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	if(ub == null){
%>
<script type="text/javascript">
<!--
	window.onload = function(){
		parent.redirect('login.do');
	}
//-->
</script>
<%		
	}else if(request.getParameter("col_id") != null){
		String deletedCols = (String)request.getParameter("col_id");
		connectDB conn = new connectDB();
		if(request.getParameter("post") != null){
			String sql = "DELETE FROM colloquium WHERE user_id = " + ub.getUserID() +
							" AND col_id IN (" + deletedCols + ")";	
			conn.executeUpdate(sql);
		}else{
			String sql = "DELETE FROM tags WHERE userprofile_id IN " +
							"(SELECT userprofile_id FROM userprofile WHERE user_id = " + ub.getUserID() +
							" AND col_id IN (" + deletedCols + "))";	
			conn.executeUpdate(sql);
			
			sql = "DELETE FROM contribute WHERE userprofile_id IN " +
					"(SELECT userprofile_id FROM userprofile WHERE user_id = " + ub.getUserID() +
					" AND col_id IN (" + deletedCols + "))";
			conn.executeUpdate(sql);
									
			sql = "DELETE FROM userprofile WHERE user_id = " + ub.getUserID() +
					" AND col_id IN (" + deletedCols + ")";
			conn.executeUpdate(sql);
		}
		conn.conn.close();
		conn = null;
	}else{
%>
<%=(String)request.getParameter("id")%>
<%	
	}
%>

