<%@ page language="java"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %><% 
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
	String sql = "SELECT s.series_id,s.name,s.description,COUNT(*) _count " +
					"FROM series s,seriescol sc,colloquium c,userprofile u " +
					"WHERE s.series_id = sc.series_id AND " +
					"sc.col_id = c.col_id AND " +
					"u.col_id = c.col_id ";//AND " +
					//"s.semester = (SELECT currsemester FROM sys_config) ";
	if(affiliate_id > 0){
		sql += "AND s.series_id IN " +
				"(SELECT afs.series_id FROM affiliate_series afs," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE afs.affiliate_id = cc.child_id " +
				"UNION SELECT series_id FROM affiliate_series WHERE affiliate_id = " + affiliate_id + ") ";
	}
	sql += "GROUP BY s.series_id,s.name,s.description " +
			//"HAVING _min <= CURDATE() AND _max >= CURDATE() " +
	  			"ORDER BY _count DESC " +
			"LIMIT " + start + "," + rows;
	//out.println(sql);
    try{
    	response.setContentType("application/xml");
    	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");

    	rs = conn.getResultSet(sql);
    	out.print("<popseries>");
        while(rs.next()){
        	out.print("<series id=\"" + rs.getString("series_id") + "\">");
        	out.print("<name><![CDATA[" + rs.getString("name").trim() + "]]></name>");
        	out.print("<bookmark>" + rs.getString("_count") + "</bookmark>");
        	out.print("</series>");
		}
        out.print("</popseries>");
		rs.close();
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	 conn.conn.close();
	 conn = null;
	}
%>