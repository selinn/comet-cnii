<%@ page language="java" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<logic:present name="UserSession">
<% 
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String comment = (String)request.getParameter("comment");
	if(comment==null){
%>
<script type="text/javascript">
<!--
	alert("Comment cannot be blank!");
-->
</script>
<%
		return;
	}else if(comment.length() <= 0){
%>
<script type="text/javascript">
<!--
	alert("Comment cannot be blank!");
-->
</script>
<%
		return;
	}
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
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
	if(request.getParameter("series_id") != null){
		series_id = Integer.parseInt((String)request.getParameter("series_id"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	String[] entity_id_value = request.getParameterValues("entity_id");
	String[] type_value = request.getParameterValues("_type");
	String entity_id_list = "";
	String type_list = "";
	if(entity_id_value !=null){
		for(int i=0;i<entity_id_value.length;i++){
			if(i!=0)entity_id_list += ",";
			entity_id_list += entity_id_value[i];
		}
	}
	if(type_value != null){
		for(int i=0;i<type_value.length;i++){
			if(i!=0)type_list += ",";
			type_list += "'" + type_value[i].replaceAll("'","''") + "'";
		}
	}
	if(request.getParameter("submitComment")!=null){
	
		connectDB conn = new connectDB();

		try{
	        if(col_id > 0){
				String sql = "INSERT INTO comment (comment,comment_date) " +
						"VALUES (?,NOW())";	        
				PreparedStatement pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1,comment);
				pstmt.executeUpdate();
				pstmt.close();
				
				sql = "SELECT LAST_INSERT_ID()";
				ResultSet rs = conn.getResultSet(sql);
				if(rs.next()){
					String commentID = rs.getString(1);
					sql = "INSERT INTO comment_col (comment_id,user_id,col_id)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(commentID));
					pstmt.setLong(2,ub.getUserID());
					pstmt.setInt(3,col_id);
					pstmt.executeUpdate();
					pstmt.close();
				}
			}
			
			conn.conn.close();

		}catch(Exception e){
			out.println("<red>Error: " + e.toString() + "</red>");
		}
	}else{
%>
<script type="text/javascript" src="ckeditor/ckeditor.js"></script>	
<script src="ckeditor/sample.js" type="text/javascript"></script> 
<link href="ckeditor/sample.css" rel="stylesheet" type="text/css"/>		
 	<table width="100%" cellpadding="0" cellspacing="0">
 		<tr>
 			<td valign="top">
				<form method="post" action="postComment.jsp">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td>&nbsp;</td>
							<td>
								<textarea name="comment" rows="20" cols="80"></textarea>
									<script type="text/javascript"> 
									//<![CDATA[
					 
										// This call can be placed at any point after the
										// <textarea>, or inside a <head><script> in a
										// window.onload event handler.
					 
										// Replace the <textarea id="editor"> with an CKEditor
										// instance, using default configurations.
										CKEDITOR.replace( 'comment' );
					 
									//]]>
									</script> 
							</td>
						</tr>
						<tr>
							<td>
								<input name="poster_id" type="hidden" value="<%=ub.getUserID()%>">
							</td>
							<td><input name="submitComent" type="submit" value="comment"></td>
						</tr>
					</table>
				</form>
 			</td>
 		</tr>
 	</table> 
<%	
	}
%>
</logic:present>
<logic:notPresent name="UserSession">
</logic:notPresent>