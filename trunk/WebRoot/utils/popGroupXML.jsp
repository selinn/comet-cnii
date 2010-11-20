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
	String sql = "SELECT c.comm_id,c.comm_name,COUNT(*) _no " +
					"FROM community c,contribute cc,userprofile u " +
	    			"WHERE c.comm_id = cc.comm_id AND " +
	    			"u.col_id IN " +
	    			"(SELECT col_id FROM colloquium WHERE _date >= (SELECT beginterm FROM sys_config) AND _date <= (SELECT endterm FROM sys_config)) AND " +
	    			"cc.userprofile_id = u.userprofile_id ";
	if(affiliate_id > 0){
		sql += "AND u.col_id IN " + 
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ") ";
	}
	sql += "GROUP BY c.comm_id,c.comm_name " +
   			"ORDER BY _no DESC " +
			"LIMIT " + start + "," + rows;
	
    try{
    	response.setContentType("application/xml");
    	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");

    	rs = conn.getResultSet(sql);
    	out.print("<popgroup>");
        while(rs.next()){
        	out.print("<group id=\"" + rs.getString("comm_id") + "\">");
        	out.print("<name><![CDATA[" + rs.getString("comm_name") + "]]></name>");
        	out.print("<bookmark>" + rs.getString("_no") + "</bookmark>");
			out.print("</group>");
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 out.print("</popgroup>");
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	}
%>