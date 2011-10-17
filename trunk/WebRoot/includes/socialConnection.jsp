<%@ page language="java"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.ExternalProfile"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>


<%@page import="edu.pitt.sis.beans.UserBean"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<script type="text/javascript">
	function addFriend(divDialog,objParent,uid,reqtype){
			var data = sendFriendRequest(objParent,uid,reqtype);
			hideAddFriendDialog(divDialog);		
		}	

</script>

<table cellspacing="0" cellpadding="0" width="100%" align="center" border="1">
<tr>
<th bgcolor="#6699FF">CoMet Profile</th>
<th bgcolor="#6699FF">FaceBook Profile</th>
<th bgcolor="#6699FF">Connection in CoMet</th>
</tr>
<%
	connectDB conn = new connectDB();
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
    
    
	String comfacConnection, comLinkedConnection, connection, comet_url, fname, fprofile_url, fpic_small_with_logo, fheadline, lname, lprofile_url, lpic_small_with_logo, lheadLine, cname, caffiliation, cinterest = "";
	Hashtable<Integer, Integer> facebookFriends = new Hashtable<Integer, Integer>();
	Hashtable<Integer, Integer> linkedInFriends = new Hashtable<Integer, Integer>();
	int userId, externalID, cid = -1;

	//	session=request.getSession(false);
	//	String menu = (String)session.getAttribute("menu");
	//	String _v = (String)session.getAttribute("v");
	//	String t = (String)request.getParameter("t");
	//	String v = (String)request.getParameter("v");
	//	String user_id = (String)request.getParameter("user_id");
	//	UserBean ub = (UserBean)session.getAttribute("UserSession");
	long my_id =  ub.getUserID();
	//long my_id =  1;

	ExternalProfile externalProfile = new ExternalProfile();
	
	//Get external profile ID and table from facebook
	int fExternalID = externalProfile.getExternalID(my_id, "facebook");

	//Get external profile ID and table from linkedin
	int lExternalID = externalProfile.getExternalID(my_id, "linkedin");

	//Get facebook friend list also in Comet
	externalProfile.getFriendList(fExternalID,
			"extprofile.facebook_friendship");

	//Get linkedIn friend list also in Comet
	externalProfile.getFriendList(lExternalID,
			"extprofile.linkedin_connection");

	//Get info of friends
	facebookFriends = externalProfile.facebookFriends;

	Set<Integer> set = facebookFriends.keySet();
	Iterator ite = set.iterator();
	int i = 0;
	String divID = "";
	String spanID="";
	String picHTML="";
String sql="";
ResultSet rs;
	while (ite.hasNext()) {
		i++;
		divID = "divAddFriendF" + i;
		spanID = "spanAddAsFriendF"+i;
		userId = (Integer) ite.next();
	//	divID = "divAddFriendF" + userId;
	//	spanID = "spanAddAsFriendF"+userId;
		externalID = facebookFriends.get(userId);

		//Whether they are friends in Comet
		comfacConnection = externalProfile.connectionStatus(my_id,
				userId);
		if (comfacConnection.equals("Connected")) {
			connection = "You are friends in CoMet too!";
		} else if (comfacConnection.equals("No")) {
			sql = "SELECT request_id,notnowtime FROM request WHERE requester_id=" + userId + " AND target_id=" + my_id + " AND accepttime IS NULL AND rejecttime IS NULL AND droprequesttime IS NULL ORDER BY requesttime DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			
			if(rs.next()){
					String request_id = rs.getString("request_id");
					
					connection = "<input class ='btn' type='button' id='btnRespondRequest' value='Respond to Friend Request' onclick='showAddFriendDialog("+ divID + ");return false;' />";
		
			}else{

					connection = "<input class ='btn' type='button' id='btnAddAsFriend' value='Add as Friend' onclick='showAddFriendDialog("+divID+");return false;' />";
	
			}
							
			
		} else {

			String request_id = comfacConnection;
			connection ="<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">Friend Request Sent</span> <a href=\"javascript:return false;\" onclick=\"addFriend("+divID+","+spanID+","+userId+",'drop');return false;\"><img border=\"0\" src=\"images/x.gif\" /></a>";
		}

		//Get profile of user in Comet
		externalProfile.getCometProfile(userId);
		comet_url = "http://halley.exp.sis.pitt.edu/comet.dev/profile.do?user_id="
				+ userId;
		cname = externalProfile.cname;
		caffiliation = externalProfile.caffiliation;
		cinterest = externalProfile.cinterest;

		//Get profile of user in facebook
		externalProfile.getFacebookProfileInfo(externalID);
		fname = externalProfile.fname;
		fprofile_url = externalProfile.fprofile_url;
		fpic_small_with_logo = externalProfile.fpic_small_with_logo;
		fheadline = externalProfile.fheadline;
		
		if(fpic_small_with_logo.contains("http://"))
		{
			picHTML = "<div style='display:inline;float:left'>" +
			"<img alt='' src='"+fpic_small_with_logo+"' width='40' height='50'></img></div>";	
		}else
		{
			picHTML ="";
		}

		//Layout for facebook and comet profile
%>
		<tr>
			<td align="center">
			
				<b><%=cname%></b>
				<br/>
			<%-- 	<%=caffiliation%>
				<br/>--%>
				<a href="<%=comet_url%>" target="_blank">See CoMet Profile</a>
			</td>
		
		
			<td align="center">
				<%=picHTML%>
				<div style="display:inline;float:left">
				<b><%=fname%></b>
				<br/>
				<%=fheadline%>
				<br/>
				<a href="<%=fprofile_url%>" target="_blank">See FaceBook Profile</a>
				</div>
			</td>
		
		
			<td align="center">
			<span id="<%=spanID%>">
				<%=connection%>
			</span>
				<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="<%=divID%>">
			
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 400px;border: 1px solid #aaaaaa;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
						&nbsp;Send <%=cname%> a friend request?
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td colspan="2" style="font-size: 0.75em;padding: 4px;">
									<b><%=cname%></b> will have to confirm your request.
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="85%"><input class="btn" type="button" value="Send Request" onclick="addFriend(<%=divID%>,<%=spanID%>,<%=userId%>,'add');return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog(<%=divID%>);return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
			</td>
		</tr>
	<%
		}
	%>



<%
	//Get friends from linkedin
	linkedInFriends = externalProfile.linkedInFriends;
	int size = linkedInFriends.size();
	Set<Integer> setL = linkedInFriends.keySet();
	Iterator iteL = setL.iterator();
	int index = 0;
	String divIDL = "";
	String spanIDL="";
	String lpicHTML="";
	String connectionL="";
	if(size > 0)
	{
	
%>
	<tr>
		<th bgcolor="#6699FF">CoMet Profile</th>
		<th bgcolor="#6699FF">LinkedIn Profile</th>
		<th bgcolor="#6699FF">Connection in CoMet</th>
	</tr>
<%
	while (iteL.hasNext()) {
		index++;
		divIDL = "divAddFriendL" + index;
		spanIDL = "spanAddAsFriendL" + index;
		
		userId = (Integer) iteL.next();
		//divIDL = "divAddFriendF" + userId;
		//spanIDL = "spanAddAsFriendF"+userId;
		externalID = linkedInFriends.get(userId);

		//Whether they are friends in Comet
		comLinkedConnection = externalProfile.connectionStatus(my_id,
				userId);
		if (comLinkedConnection.equals("Connected")) {
			connectionL = "You are friends in CoMet too!";
		} else if (comLinkedConnection.equals("No")) {
			sql = "SELECT request_id,notnowtime FROM request WHERE requester_id=" + userId + " AND target_id=" + my_id + " AND accepttime IS NULL AND rejecttime IS NULL AND droprequesttime IS NULL ORDER BY requesttime DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			
			if(rs.next()){
					String request_id = rs.getString("request_id");
					
					connectionL = "<input class ='btn' type='button' id='btnRespondRequest' value='Respond to Friend Request' onclick='showAddFriendDialog("+ divIDL + ");return false;' />";
		
			}else{

					connectionL = "<input class ='btn' type='button' id='btnAddAsFriend' value='Add as Friend' onclick='showAddFriendDialog("+divIDL+");return false;' />";
	
			}
							
			
		} else {

			String request_idL = comLinkedConnection;
			connectionL ="<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">Friend Request Sent</span> <a href=\"javascript:return false;\" onclick=\"addFriend("+divIDL+","+spanIDL+","+userId+",'drop');return false;\"><img border=\"0\" src=\"images/x.gif\" /></a>";
		}

		//Get profile of user in Comet
		externalProfile.getCometProfile(userId);
		comet_url = "http://halley.exp.sis.pitt.edu/comet.dev/profile.do?user_id="
				+ userId;
		cname = externalProfile.cname;
		caffiliation = externalProfile.caffiliation;
		cinterest = externalProfile.cinterest;

		//Get profile of user in linkedIn
		externalProfile.getLinkedInProfileInfo(externalID);
		lname = externalProfile.lname;
		lprofile_url = externalProfile.lprofile_url;
		lpic_small_with_logo = externalProfile.lpic_small_with_logo == null ? "" :externalProfile.lpic_small_with_logo;
		lheadLine = externalProfile.lheadLine;
		
		if(lpic_small_with_logo.contains("linkedin"))
		{
			lpicHTML = "<div style='display:inline;float:left'>" +
			"<img alt='' src='"+lpic_small_with_logo+"' width='40' height='50'></img></div>";	
		}else
		{
			lpicHTML ="";
		}

		//Layout for facebook and comet profile
%>
		<tr>
			<td align="center">
			
				<b><%=cname%></b>
				<br/>
			<%-- 	<%=caffiliation%>
				<br/>--%>
				<a href="<%=comet_url%>" target="_blank">See CoMet Profile</a>
			</td>
		
		
			<td align="center">
				<%=lpicHTML%>
				<div style="display:inline;float:left">
				<b><%=lname%></b>
				<br/>
				<%=lheadLine%>
				<br/>
				<a href="<%=lprofile_url%>" target="_blank">See LinkedIn Profile</a>
				</div>
			</td>
		
		
			<td align="center">
			<span id="<%=spanIDL%>">
				<%=connectionL%>
			</span>
				<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="<%=divIDL%>">
			
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 400px;border: 1px solid #aaaaaa;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
						&nbsp;Send <%=cname%> a friend request?
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td colspan="2" style="font-size: 0.75em;padding: 4px;">
									<b><%=cname%></b> will have to confirm your request.
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="85%"><input class="btn" type="button" value="Send Request" onclick ="addFriend(<%=divIDL%>,<%=spanIDL%>,<%=userId%>,'add');return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog(<%=divIDL%>);return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
			</td>
		</tr>
	<%
	}
		}
	%>


</table>
