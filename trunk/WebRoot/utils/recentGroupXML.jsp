<%@ page language="java"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><% 
	session = request.getSession(false);
	int rows = 20;
	int start = 0;
	int affiliate_id = -1;
	if(request.getParameter("rows")!=null){
		rows = Integer.parseInt((String)request.getParameter("rows"));
	}	
	if(request.getParameter("start") != null){
		start = Integer.parseInt((String)request.getParameter("start"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT comm_id,comm_name " +
					"FROM community ";
	
	if(affiliate_id > 0 ){
		sql += "WHERE comm_id IN " +
				"(SELECT c.comm_id FROM contribute c,userprofile u " +
				"WHERE c.userprofile_id = u.userprofile_id AND u.col_id IN " +
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")) ";
	}

	sql += "ORDER BY lastupdate " +
			"LIMIT " + start + "," + rows;
	
    try{
    	response.setContentType("application/xml");
    	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");

    	rs = conn.getResultSet(sql);
    	out.print("<recentgroup>");
        while(rs.next()){
        	out.print("<group id=\"" + rs.getString("comm_id") + "\">");
        	out.print("<name><![CDATA[" + rs.getString("comm_name") + "]]></name>");
			out.print("</group>");
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 out.print("</recentgroup>");
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	}
%>