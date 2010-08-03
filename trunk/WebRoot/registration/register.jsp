<%@ page language="java"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>


<html:form action="/registration">
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td width="85%" colspan="3" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.95em;font-weight: bold;">
				Signup
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>

		<logic:present name="RegisterError">
		<tr>
			<td colspan="3">		
				<font class="error">
					<b><bean:write name="RegisterError" property="errorDescription" /></b>
				</font>
			</td>
		</tr>
		</logic:present>

		<tr>
			<td width="25%" style="font-size: 0.75em;font-weight: bold;">Screen Name:</td>
			<td><html:text style="font-size: 0.75em;" property="name" size="30" /></td>
			<td><font class="error"><html:errors property="name"/></font></td>
		</tr>
		<tr>
			<td width="25%" style="font-size: 0.75em;font-weight: bold;">E-Mail Address:</td>
			<td><html:text style="font-size: 0.75em;" property="userEmail" size="30" /></td>
			<td><font class="error"><html:errors property="userEmail"/></font></td>
		</tr>
		<tr>
			<td width="25%" style="font-size: 0.75em;font-weight: bold;">Choose a Password:</td>
			<td><html:password style="font-size: 0.75em;" property="password" size="30" /></td>
			<td><font class="error"><html:errors property="password"/></font></td>
		</tr>
		<tr>
			<td width="25%" style="font-size: 0.75em;font-weight: bold;">Re-enter Password:</td>
			<td><html:password style="font-size: 0.75em;" property="repassword" size="30" /></td>
			<td><font class="error"><html:errors property="repassword"/></font></td>
		</tr>
		<tr>
			<td colspan="3">
				<tiles:insert template="affiliation.jsp" />
			</td>
		</tr>
		<tr>	
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td width="10%" align="right">
				&nbsp;
				<input type="submit" id="btnRegister" class="btn" value="Register" />
			</td>
			<td colspan="2">&nbsp;<html:link style="font-size: 0.75em;" forward="aaa.authentication.login">Sign in?</html:link></td>
		</tr>
	</table>
</html:form> 
