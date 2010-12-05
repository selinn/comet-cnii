<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>



<form action="profile/infoEntry.jsp" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">col_id:</td>
	 	<td><input type="text" id="col_id" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Name:</td>
	 	<td><input type="text" id="name" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Email:</td>
	 	<td><input type="text" id="email" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Job Title:</td>
	 	<td><input type="text" id="job" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Affiliation:</td>
	 	<td><input type="text" id="affiliation" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Website:</td>
	 	<td><input type="text" id="website" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">About me:</td>
	 	<td><input type="text" id="aboutme" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Interests:</td>
	 	<td><input type="text" id="interests" /></td>
	</tr>

</table>	
</form>
