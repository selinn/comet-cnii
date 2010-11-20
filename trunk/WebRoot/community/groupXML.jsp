<%@ page language="java"%><%@ page import="edu.pitt.sis.beans.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.Html2Text"%><% 
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<group>");
	String comm_id = (String)request.getParameter("comm_id");
	if(comm_id == null){
		out.print("<status>ERROR: comm_id required</status>");
	}else{
		connectDB conn = new connectDB();
		String sql = "SELECT comm_name,comm_desc FROM community WHERE comm_id = " + comm_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String comm_name = rs.getString("comm_name");
			String comm_desc = rs.getString("comm_desc");

			comm_desc = comm_desc.replaceAll("\\<.*?>","");
			Html2Text parser = new Html2Text();
			parser.parse(comm_desc);
			comm_desc = parser.getText();
			
			out.print("<title><![CDATA[" + comm_name + "]]></title>");
			out.print("<description><![CDATA[" + comm_desc + "]]></description>");
			rs.close();
			conn.conn.close();
		}else{
			out.print("<status>ERROR: Group Not Found</status>");
		}
	}
	out.print("</group>");
%>
