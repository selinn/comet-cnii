<%@ page language="java"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %><% 
	session = request.getSession(false);
	int rows = -1;
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
	String sql = "SELECT s.name,s.series_id,s.description,sc._no " +
					"FROM series s LEFT JOIN " +
					"(SELECT sc.series_id,COUNT(*) _no FROM seriescol sc GROUP BY sc.series_id) sc ON s.series_id = sc.series_id " +
					"WHERE TRUE ";// +
					//"s.semester = (SELECT currsemester FROM sys_config) ";
	if(affiliate_id > 0){
		sql += "AND s.series_id IN " +
				"(SELECT afs.series_id FROM affiliate_series afs," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE afs.affiliate_id = cc.child_id " +
				"UNION SELECT series_id FROM affiliate_series WHERE affiliate_id = " + affiliate_id + ") ";
	}
	sql += "ORDER BY s.name,s.series_id,s.description ";
	if(rows > 0){
		sql += "LIMIT " + start + "," + rows;
	}
	//out.println(sql);
	
    try{
    	response.setContentType("application/xml");
    	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");

    	rs = conn.getResultSet(sql);
    	out.print("<recentseries>");
        while(rs.next()){
        	out.print("<series id=\"" + rs.getString("series_id") + "\">");
        	out.print("<name><![CDATA[" + rs.getString("name").trim() + "]]></name>");
        	String _no = rs.getString("_no");
        	if(_no != null){
        		out.print("<talkno>" + _no + "</talkno>");
        	}
        	out.print("</series>");
        }
    	out.print("</recentseries>");
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