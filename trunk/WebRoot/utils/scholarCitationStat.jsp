<%@ page language="java"%>
<%@page import="edu.pitt.sis.GoogleScholarCitation"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>

<% 
	String col_id = (String)request.getParameter("col_id");
	if(col_id == null){
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td>
			<i>Scholar Name Not Provided</i>
		</td>
	</tr>
</table>
<% 
	}else{
		String sql = "SELECT s.name from speaker s JOIN colloquium c ON s.speaker_id = c.speaker_id WHERE c.col_id=" + col_id;
		connectDB conn = new connectDB();
		ResultSet rs = conn.getResultSet(sql);
		String name = "";
		if(rs != null){
			if(rs.next()){
				name = rs.getString("name");
			}
		}else{
			return;
		}
		int commapos = name.indexOf(",");
		if(commapos > 0){
			name = name.substring(0,commapos);
		}
		GoogleScholarCitation gsc = new GoogleScholarCitation(name);
		int citations = gsc.getTotal_cites();
		int publications = gsc.getPublications();
		int h_index = gsc.getH_index();
		String _publication_link = gsc.getLink();
%>					
<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-left: 1px #efefef solid;border-right: 1px #efefef solid;border-bottom: 1px #efefef solid;">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
			&nbsp;Scholar Statistics
		</td>
	</tr>
	<tr>
		<td style="font-size: 0.75em;">&nbsp;Citations: <span style="color: #003399;"><%=citations%></span></td>
	</tr>
	<tr>
		<td style="font-size: 0.75em;">&nbsp;Cited Publications: <span style="color: #003399;"><%=publications%></span></td>
	</tr>
	<tr>
		<td style="font-size: 0.75em;">&nbsp;H-Index: <span style="color: #003399;"><%if(h_index > 0){out.print(h_index);}else{out.print("undefined");}%></span></td>
	</tr>
	<tr>
		<td style="font-size: 0.75em;">&nbsp;<a href="<%=_publication_link%>" target="_blank">view publications</a></td>
	</tr>
	<tr>
		<td><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
</table>
<%		
		conn.conn.close();
	}
%>
