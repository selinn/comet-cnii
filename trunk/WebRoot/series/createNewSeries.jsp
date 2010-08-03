
<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<logic:notPresent name="UserSession">
	<script type="text/javascript">
		window.location = "login.do";
	</script>
</logic:notPresent>
<logic:present name="createNewSeries">
	<div><h2>Post Colloquium Series Successful!</h2></div>
	<html:link forward="aaa.pre.create.series"><span style="font-size: 0.9em;">Create New Series</span></html:link>
</logic:present>

<logic:notPresent name="createNewSeries">
<% 
	session=request.getSession(false);
	connectDB conn = new connectDB();
	String sql = "SELECT series_id,name,description,url FROM series s WHERE series_id = " + request.getParameter("series_id");
	ResultSet rs = conn.getResultSet(sql);
	String series_id = "0";
	String name = "";
	String url = "";
	String description = "";
	HashSet<String> sponsorSet = new HashSet<String>();
	if(rs.next()){
		series_id = rs.getString("series_id");
		name = rs.getString("name");
		description = rs.getString("description");
		url = rs.getString("url");
		
		sql = "SELECT affiliate_id FROM affiliate_series WHERE series_id = " + series_id;
		rs = conn.getResultSet(sql);
		while(rs.next()){
			sponsorSet.add(rs.getString("affiliate_id"));
		}
	}	
%>
	<html:form action="/PostNewSeries" method="POST">
		<table cellspacing="0" cellpadding="0" width="100%" align="center" style="font-size: 0.9em;">
			<tr>
				<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
			</tr>
			<tr>
				<td colspan="2" bgcolor="#efefef">
					<h3>
<% 
		if(request.getParameter("series_id") == null){
%>
					Create New
<%		
		}else{
%>
					Edit
<%		
		}
%>					 Colloquium Series</h3>
				</td>
			</tr>
			<tr>
				<td width="25%" align="left">
						Series Name
				</td>
				<td align="left">
					<html:text maxlength="400" property="name" size="50" value="<%=name%>" />
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color: red;font-weight: bold;"><html:errors property="name" /></td>
			</tr>
			<tr>
				<td width="25%" align="left" valign="top">
					Semester
				</td>
				<td align="left">
<% 
	sql = "SELECT currsemester FROM sys_config";
	rs = conn.getResultSet(sql);
	String currsemester = "200903";
	if(rs.next()){
		currsemester = rs.getString("currsemester");
	}
	String year = currsemester.substring(0,4);
	String term = currsemester.substring(4,6);
	String semester[] = {"Spring","Summer","Fall"};
	int nextyear = Integer.parseInt(year) + 1;
	int termno = Integer.parseInt(term) -1;
%>
					<input type="radio" name="semester" value="<%=currsemester%>" checked="checked" />&nbsp;<%=semester[termno]%>&nbsp;<%=year%><br/>
<% 
	if(termno + 1 > 2){
%>
					<input type="radio" name="semester" value="<%=(nextyear + "01")%>" />&nbsp;<%=semester[0]%>&nbsp;<%=nextyear%><br/>
<%	
	}else{
%>
					<input type="radio" name="semester" value="<%=(year + "0" + (termno + 2))%>" />&nbsp;<%=semester[termno + 1]%>&nbsp;<%=year%><br/>
<%	
	}
	if(termno + 2 > 2){
%>
					<input type="radio" name="semester" value="<%=(nextyear + "0" + ((termno + 2)%3+1))%>" />&nbsp;<%=semester[(termno + 2)%3]%>&nbsp;<%=nextyear%><br/>
<%	
	}else{
%>
					<input type="radio" name="semester" value="<%=(year + "03")%>" />&nbsp;<%=semester[2]%>&nbsp;<%=year%><br/>
<%	
	}
%>
				</td>
			</tr>
			<tr>
				<td width="25%" align="left" valign="top">
					URL
				</td>
				<td align="left">
					<html:text maxlength="400" property="url" size="50" value="<%=url%>" />
				</td>
			</tr>
			<tr>
				<td width="25%" align="left" valign="top">
					Description
				</td>
				<td align="left">
					<html:textarea property="description" rows="5" cols="65" value="<%=description%>"></html:textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color: red;font-weight: bold;"><html:errors property="description" /></td>
			</tr>
			<tr>
				<td align="left" valign="top">Sponsor(s)</td>
				<td>
<% 
	sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id IS NULL ";
	ResultSet rs0 = conn.getResultSet(sql);
	while(rs0.next()){
		String aid = rs0.getString("affiliate_id");
		String aff = rs0.getString("affiliate");
		String checked = "";
		if(sponsorSet.contains(aid)){
			checked = "checked='checked'";		
		}
%>
				<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%><br/>
<%
		sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
		ResultSet rs1 = conn.getResultSet(sql);
		while(rs1.next()){
			aid = rs1.getString("affiliate_id");
			aff = rs1.getString("affiliate");
			checked = "";
			if(sponsorSet.contains(aid)){
				checked = "checked='checked'";		
			}
%>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%><br/>
<%
			sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
			ResultSet rs2 = conn.getResultSet(sql);
			while(rs2.next()){
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
				checked = "";
				if(sponsorSet.contains(aid)){
					checked = "checked='checked'";		
				}
%>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%><br/>
<%
				sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					checked = "";
					if(sponsorSet.contains(aid)){
						checked = "checked='checked'";		
					}
%>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%><br/>
<%
				}
				rs3.close();
			}
			rs2.close();
		}
		rs1.close();
%>
				<br/><br/>
<%		
	}
	rs0.close();
	conn.conn.close();
	conn = null;
%>			
				</td>				
			</tr>
			<tr>
				<td>
					<html:submit property="btnSubmit" value="Submit" />
				</td>
				<td>&nbsp;<input type="hidden" name="series_id" value="<%=series_id%>" /></td>
			</tr>
		</table>
	</html:form> 
</logic:notPresent>
	