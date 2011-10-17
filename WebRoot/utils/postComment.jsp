<%@ page language="java" pageEncoding="ISO-8859-1"%><%@page import="java.sql.*"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	response.setContentType("application/json");
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
	int comment_id = 0;
	int series_id = 0;
	int affiliate_id = -1;
	if(request.getParameter("tag_id")!=null){
		tag_id = Integer.parseInt((String)request.getParameter("tag_id"));
	}	
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	if(request.getParameter("user_id") != null){
		user_id = Integer.parseInt((String)request.getParameter("user_id"));
	}
	if(request.getParameter("comm_id") != null){
		comm_id = Integer.parseInt((String)request.getParameter("comm_id"));
	}
	if(request.getParameter("comment_id") != null){
		comment_id = Integer.parseInt((String)request.getParameter("comment_id"));
	}
	if(request.getParameter("series_id") != null){
		series_id = Integer.parseInt((String)request.getParameter("series_id"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	if(request.getParameter("comment")!=null && ub != null){

		String comment = (String)request.getParameter("comment");
		if(comment==null){
%>{
"status": "ERROR",
"message": "Comment cannot be blank!"
}<%
			return;
		}else if(comment.length() <= 0){
%>{
"status": "ERROR",
"message": "Comment cannot be blank!"
}<%
			return;
		}
		
		connectDB conn = new connectDB();

		try{
			String sql = "INSERT INTO comment (comment,comment_date,user_id) " +
					"VALUES (?,NOW(),?)";	        
			PreparedStatement pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1,comment);
			pstmt.setLong(2,ub.getUserID());
			pstmt.executeUpdate();
			pstmt.close();
			
			sql = "SELECT LAST_INSERT_ID()";
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String commentID = rs.getString(1);
				
				if(comment_id > 0){
					sql = "INSERT INTO comment_comment (comment_id,commentee_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(commentID));
					pstmt.setInt(2,comment_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					rs.close();
				}else{
					sql = "INSERT INTO comment_user (comment_id,user_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(commentID));
					pstmt.setInt(2,user_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					rs.close();
				}
					
%>{
"status": "OK",
"comment_id": "<%=commentID %>" 
}<%					
			}
			
			conn.conn.close();

		}catch(Exception e){
			out.println("{\"status\":\"ERROR\",\"message\":\"" + e.toString() + "\"}");
			return;
		}
	}
%>