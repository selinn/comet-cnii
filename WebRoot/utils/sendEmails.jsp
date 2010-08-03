<%@ page language="java" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="edu.pitt.sis.MailNotifier"%>
<%@page import="java.sql.ResultSet"%>
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
	}else if(request.getParameter("col_id") != null && request.getParameter("emails") != null){
		int col_id = Integer.parseInt((String)request.getParameter("col_id"));
		String emails = (String)request.getParameter("emails");
		connectDB conn = new connectDB();
		//Log email notification
		String sql = "INSERT INTO emailfriends (col_id,user_id,emails,timesent) VALUES (?,?,?,NOW())";
		PreparedStatement pstmt = conn.conn.prepareStatement(sql);
		pstmt.setInt(1,col_id);
		pstmt.setLong(2,ub.getUserID());
		pstmt.setString(3,emails);	
		pstmt.execute();
		//Commit sending emails
		sql = "SELECT name,email FROM userinfo WHERE user_id=" +  ub.getUserID();
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String sender_name = rs.getString("name");
			String sender_email = rs.getString("email");
			String[] email = emails.split(",");
			MailNotifier.suggestionNotify(col_id,email,sender_name,sender_email);
		}
		conn.conn.close();
		conn = null;
		//Tell parent to reset send email friends function		
%>
<script type="text/javascript">
<!--
	window.onload = function(){
		parent.enableEmailFriends();
	}
//-->
</script>
<%		
	}else{
%>
<%=(String)request.getParameter("id")%>
<%	
	}
%>

