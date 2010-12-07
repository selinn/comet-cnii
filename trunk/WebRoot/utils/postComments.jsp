<%@ page language="java" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<% 
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
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
	if(request.getParameter("submitComment")!=null && ub != null){

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
		
		connectDB conn = new connectDB();

		try{
	        if(col_id > 0){
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
					sql = "INSERT INTO comment_col (comment_id,col_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(commentID));
					pstmt.setInt(2,col_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					rs.close();
					sql = "SELECT title FROM colloquium WHERE col_id=" + col_id;
					rs = conn.getResultSet(sql);
					if(rs.next()){
						String title = rs.getString("title");
%>
<script type="text/javascript">
	window.setTimeout(function(){
		RPXNOW.loadAndRun(['Social'], function () {
		      var activity = new RPXNOW.Social.Activity(
		          "Share your comment",
		          "commented on '<%=title%>' on CoMeT",
		          "http://washington.sis.pitt.edu/comet/presentColloquium.do?col_id=<%=col_id%>#comment<%=commentID%>");
		      RPXNOW.Social.publishActivity(activity);
		  });
		},500);
	
</script>
<%
					}
				}
			}
			
			conn.conn.close();

		}catch(Exception e){
			out.println("<red>Error: " + e.toString() + "</red>");
		}
	}

	String sql = "SELECT c.comment_id,c.user_id,u.name,c.comment,date_format(c.comment_date,_utf8'%b %d %r') commenttime " +
					"FROM comment c JOIN userinfo u ON c.user_id = u.user_id " +
					"WHERE c.comment_id IN (SELECT cc.comment_id FROM comment_col cc WHERE cc.col_id=" + col_id + ")";
	connectDB conn = new connectDB();
	ResultSet rs = conn.getResultSet(sql);
%>
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="left">
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td colspan="2" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
			Comments
		</td>
	</tr>
<%	
	if(rs != null){
		while(rs.next()){
			String comment_id = rs.getString("comment_id");
			user_id = rs.getInt("user_id");
			String name = rs.getString("name");
			String comment = rs.getString("comment");
			String commenttime = rs.getString("commenttime");
%>
	<tr>
		<td width="20%" valign="top" style="font-size: 0.75em;">
			<a href="profile.do?user_id=<%=user_id%>"><%=name %></a><br/>
			<span style="color: #bebebe;font-size: 0.75em;"><%=commenttime %></span>
			<a name="comment<%=comment_id %>"></a>
		</td>
		<td width="80%" valign="top" style="font-size: 0.75em;">
			<%=comment %>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
<%		
		}
	}
%>
</table>
<logic:present name="UserSession">
<script type="text/javascript" src="ckeditor/ckeditor.js"></script>	
<script src="ckeditor/sample.js" type="text/javascript"></script> 
<link href="ckeditor/sample.css" rel="stylesheet" type="text/css"/>		
 	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>&nbsp;</td>
		</tr>
 		<tr>
 			<td valign="top">
				<form method="post" action="presentColloquium.do<%if(request.getQueryString()!=null)out.print("?"+request.getQueryString());%>">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="20%" valign="top"><b>Your comment:</b></td>
							<td>
								<textarea name="comment" rows="5" cols="45"></textarea>
<%-- 
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
--%>
							</td>
						</tr>
						<tr>
							<td colspan="2"><input name="poster_id" type="hidden" value="<%=ub.getUserID()%>">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2">
								<input name="submitComment" class="btn" type="submit" value="Post a comment">
							</td>
						</tr>
					</table>
				</form>
 			</td>
 		</tr>
 	</table> 
</logic:present>