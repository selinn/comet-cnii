
<%@ page language="java" pageEncoding="UTF-8"%>

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
<logic:present name="makeComm">
	<div style="font-size: 0.85em;color: #003399;">Create your group successful!</div>
	<html:link style="font-size: 0.75em;" forward="aaa.pre.make.community">Create New Group</html:link>
</logic:present>

<logic:notPresent name="makeComm">
	<html:form action="/PostNewCommunity" method="POST">
		<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center" style="font-size: 0.85em;">
			<tr>
				<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
			</tr>
			<tr>
				<td colspan="2" bgcolor="#efefef">
					<b>Create your own group</b>
				</td>
			</tr>
			<tr>
				<td width="10%" align="left">
						Group Name
				</td>
				<td align="left">
					<html:text maxlength="200" property="name" size="50" />
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color: red;font-weight: bold;"><html:errors property="name" /></td>
			</tr>
			<tr>
				<td width="10%" align="left" valign="top">
					Description
				</td>
				<td align="left">
					<html:textarea property="description" rows="5" cols="65" />
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color: red;font-weight: bold;"><html:errors property="description" /></td>
			</tr>
			<tr>
				<td>
					<input type="submit" class="btn" name="btnSubmit" value="Submit" />
				</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</html:form> 
</logic:notPresent>
	