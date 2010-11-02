<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<script type="text/javascript">
	var oAJAXIFrame = null;
	function setDocumentTitle(aTitle){
		document.title = aTitle;
	}
	function editNote(){
		if(btnEditNote.value == "Cancel"){
			cancelEditNote();
			return;
		}
		btnEditNote.value = "Cancel";
		if(divNote){
			divNote.style.height = "0px";
			divNote.style.overflow = "hidden";
		}
		if(divBookmark){
			divBookmark.style.height = "auto";
			divBookmark.style.overflow = "visible";
		}
		/*if(btnCancelEditNote){
			btnCancelEditNote.style.width = "auto";
			btnCancelEditNote.style.display = "block";
		}
		if(btnEditNote){
			btnEditNote.style.width = "0px";
			btnEditNote.style.display = "none";
		}*/
	}
	function cancelEditNote(){
		btnEditNote.value = "Edit";
		if(divNote){
			divNote.style.height = "auto";
			divNote.style.overflow = "visible";
		}
		if(divBookmark){
			divBookmark.style.height = "0px";
			divBookmark.style.overflow = "hidden";
		}
		/*if(btnCancelEditNote){
			btnCancelEditNote.style.width = "0px";
			btnCancelEditNote.style.display = "none";
		}
		if(btnEditNote){
			btnEditNote.style.width = "auto";
			btnEditNote.style.display = "block";
		}*/
	}
	function createAJAXIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenAJAXFrame";
			iframe.id = "hiddenAJAXFrame";
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oAJAXIFrame = frames["hiddenAJAXFrame"];
		}else{
			window.setTimeout(function(){createAJAXIFrame();},50);
		}
	}
	
	function sendEmailFriends(col_id){
		if(txtEmail.value.length < 1){
			alert("Please enter your friends emails");
			return;
		}

		if(col_id){
			if(!oAJAXIFrame){
				createAJAXIFrame();
				window.setTimeout(function(){ sendEmailFriends(col_id);},50); 
			}else{
				txtEmail.disabled = true;
				btnSendEmail.value = "Sending...";
				btnSendEmail.disabled = true;
				var action = "utils/sendEmails.jsp?col_id=".concat(col_id,"&emails=",txtEmail.value);
				//alert(action);
				oAJAXIFrame.location = action;
			}
		}
	}
	
	function enableEmailFriends(){
		btnSendEmail.value = "Sent";
		window.setTimeout(
			function(){
				txtEmail.value = "";
				txtEmail.disabled = false;
				btnSendEmail.value = "Send";
				btnSendEmail.disabled = false;
			},500
		);
	}
	
	function deleteCol(col_id,isPost){
		if(col_id){
			if(!oAJAXIFrame){
				createAJAXIFrame();
				window.setTimeout(function(){ deleteCol(col_id,isPost);},50); 
			}else{
				var action = "utils/deleteTalks.jsp?col_id=".concat(col_id);
				//alert(action);
				oAJAXIFrame.location = action;
				window.setTimeout(function(){clearNote();},50);
			}
		}
	}
	function redirect(html){
		window.location = html;
	}
	function clearNote(){
		if(divNote){
			divNote.style.height = "0px";
			divNote.style.overflow = "hidden";
		}
		if(divBookmark){
			divBookmark.style.height = "auto";
			divBookmark.style.overflow = "visible";
		}
		if(btnDeleteNote){
			btnDeleteNote.style.width = "0px";
			btnDeleteNote.style.display = "none";
		}
		/*if(btnCancelEditNote){
			btnCancelEditNote.style.width = "0px";
			btnCancelEditNote.style.display = "none";
		}*/
		if(btnEditNote){
			btnEditNote.style.width = "0px";
			btnEditNote.style.display = "none";
		}
		if(document.forms[1]){
			for(var i=0;document.forms[1].elements.length;i++){
				var element = document.forms[1].elements[i];
				var elName = element.name;
				switch(element.type){
					case "text":
					case "textarea":
						element.value = "";break;
					case "checkbox":
						element.checked = 0;break; 
					default:
						break;
				}
			}
		}
	}
</script>
<%
	session=request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String col_id = (String)request.getParameter("col_id");
	String sql = "SELECT c.title,date_format(c._date,_utf8'%b %d, %Y') _date," +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin," +
					"date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"c.detail,h.host_id,h.host,s.speaker_id,s.name,c.location," +
					"c.user_id,c.url,u.name owner,c.owner_id,lc.abbr,c.video_url,s.affiliation " +
					"FROM colloquium c JOIN speaker s ON c.speaker_id=s.speaker_id " +
					"JOIN userinfo u ON c.owner_id = u.user_id " +
					"LEFT OUTER JOIN host h ON c.host_id = h.host_id " +
					"LEFT OUTER JOIN loc_col lc ON c.col_id = lc.col_id " +
					"WHERE c.col_id = " + col_id;
	connectDB conn = new connectDB();
	try{
		ResultSet rs = conn.getResultSet(sql);
		if(!rs.next()){
%>
<div style="font-size: 2em;">Talk Not Found</div>
<%
		}else{
			String url = rs.getString("url");
			String title = rs.getString("title");
			String host = rs.getString("host");
			String speaker = rs.getString("name");
			String affiliation = rs.getString("affiliation");
			if(affiliation != null){
				if(!affiliation.equalsIgnoreCase("N/A")){
					speaker += ", " + affiliation;
				}
			}
%>
<script type="text/javascript">
<!--
	window.onload = function(){
		var aTitle = "CoMeT | ";
		aTitle = aTitle.concat("<%=title%>");
		setDocumentTitle(aTitle);
	};
//-->
</script>
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td width="790" valign="top">
			<table width="100%" cellspacing="0" cellpadding="0" align="left" style="padding-right: 1px;">
				<tr>
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td width="85%" colspan="2" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
						Colloquium Detail
					</td>
					<td align="right" width="15%" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
<% 
			if(ub != null){
%>
						<input type="button" class="btn" name="btnEditTalk" value="Edit" onclick="redirect('PreColloquiumEntry.do?col_id=<%=col_id%>');">
<%			
			}
%>
					</td>
				</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Posted:</td>
					<td colspan="2" style="font-size: 0.75em;"><a href="calendar.do?user_id=<%=rs.getString("owner_id")%>"><%=rs.getString("owner")%></a> <b>on</b>&nbsp;
<% 
			sql = "SELECT date_format(MIN(lastupdate),_utf8'%b %d %r') posttime " +
					"FROM (SELECT lastupdate FROM colloquium WHERE col_id = "+col_id+" " +
					"UNION " +
					"SELECT MIN(lastupdate) lastupdate FROM col_bk WHERE col_id = "+col_id+") ptime";
			ResultSet rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				String posttime = rsExt.getString("posttime");
%>
						<%=posttime%>
<%							
			}
%>
					</td>
				</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Title:</td>
					<td colspan="2" style="font-size: 0.9em;font-weight: bold;"><%=title%></td>
				</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left">Speaker:</td>
					<td colspan="2" style="font-size: 0.75em;"><%=speaker%></td>
				</tr>
<% 
			if(host!=null){
				if(host.trim().length() > 0){
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Host:</td>
					<td colspan="2" style="font-size: 0.75em;"><%=host%></td>
				</tr>
<%			
				}
			}
%>
<% 
			String _sql = "SELECT s.series_id,s.name FROM series s,seriescol sc " +
							"WHERE s.series_id = sc.series_id AND sc.col_id=" + col_id;
			
			ResultSet rsSeries = conn.getResultSet(_sql);
			if(rsSeries.next()){
				String series_id = rsSeries.getString("series_id");
				String series_name = rsSeries.getString("name");
				
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left">Series:</td>
					<td colspan="2" style="font-size: 0.75em;"><a href="series.do?series_id=<%=series_id%>"><%=series_name%></a></td>
				</tr>
<%				
			}
			rsSeries.close();
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left">Date:</td>
					<td colspan="2" style="font-size: 0.75em;"><%=rs.getString("_date")%> <%=rs.getString("_begin")%> - <%=rs.getString("_end")%></td>
				</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">URL:</td>
					<td colspan="2" style="font-size: 0.75em;"><a href="<%=url%>"><%=url%></a></td>
				</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Location:</td>
					<td colspan="2" style="font-size: 0.75em;"><%=rs.getString("location")%>
<% 
			String abbr = rs.getString("abbr");
			if(abbr != null){
%>
					&nbsp;(<a href="http://gis.sis.pitt.edu/CampusLocator/searchBuilding?abbr=<%=abbr%>">map</a>)
<%			
			}
%>					
					</td>
				</tr>
<% 
			String video = rs.getString("video_url");
			if(video!=null){
				if(video.length() > 0){
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Video:</td>
					<td colspan="2" style="font-size: 0.75em;">
<%
					if(video.length() > 7){
%>
						<a href="<%=video%>"><%=video%></a>
<%					
					}else{
%>
						<%=video%>
<%					
					}
%>
					</td>
				</tr>
<%
				}
			}
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Detail:</td>
					<td colspan="2" style="font-size: 0.75em;"><%=rs.getString("detail")%></td>
				</tr>
<%
		//Insert time log
		long uid = 0;
		if(ub != null){
			uid = ub.getUserID();
		} 
		String sessionID = session.getId();
		Cookie cookies[] = request.getCookies();
		//Find session id
		boolean foundSessionID = false;
		if(cookies != null){
			for(int i=0;i<cookies.length;i++){
				Cookie c = cookies[i];
			    if (c.getName().equalsIgnoreCase("sessionid")) {
			        sessionID = c.getValue();
			    	foundSessionID = true;
			    }			
			}
		}
		String ipaddress = request.getRemoteAddr();
		sql = "INSERT INTO talkview (user_id,viewTime,col_id,ipaddress,sessionid) VALUES (" + uid + ",NOW()," + col_id + ",'" + ipaddress + "','" + sessionID + "')";
		conn.executeUpdate(sql);

		if(ub != null){
			sql = "SELECT userprofile_id,usertags,comment,DATE_FORMAT(lastupdate,_utf8'%b %e, %Y %r') _date FROM userprofile u WHERE user_id = " + ub.getUserID() + " AND col_id = " + col_id;
			rs.close();
			rs = conn.getResultSet(sql);
			
			long userprofile_id = -1;			
			String tags = "";
			String usertags = "";
			String notes = "";
			String _date = "";
			HashMap<String,Long> mapComm = new HashMap<String,Long>();
			if(rs.next()){
				userprofile_id = rs.getLong("userprofile_id");
				usertags = rs.getString("usertags");
				notes = rs.getString("comment");
				_date = rs.getString("_date");
				rs.close();
				sql = "SELECT t.tag_id,t.tag FROM tags tt,tag t WHERE tt.tag_id = t.tag_id AND tt.userprofile_id = " + userprofile_id;
				rs = conn.getResultSet(sql);
				while(rs.next()){
					tags += "<a href='tag.do?tag_id=" + rs.getString("tag_id") + "'>" + rs.getString("tag") + "</a>&nbsp;";
				}
				sql = "SELECT c.comm_id,c.comm_name FROM community c,contribute cc WHERE c.comm_id = cc.comm_id AND cc.userprofile_id = " + userprofile_id;
				rs = conn.getResultSet(sql);
				while(rs.next()){
					mapComm.put(rs.getString("comm_name"),Long.valueOf(rs.getString("comm_id")));
				}
			}
%>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
						Rate relevance of this talk (0 comet: not at all - 5 comets: totally relevant)
					</td>
				</tr>
				<tr>
					<td colspan="3"><tiles:insert template="/SliderBarFeedback.html" /></td>
				</tr>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
						E-mail this talk to your friends (Separate them by comma)
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<table cellspacing="0" cellpadding="0" width="100%" align="center">
							<tr>
								<td width="20%" style="font-size: 0.75em;font-weight: bold;">E-mails:</td>
								<td style="font-size: 0.9em;">
									<input type="text" id="txtEmail" style="font-size: 0.75em;" size="60" />&nbsp;<input class="btn" id="btnSendEmail" onclick="sendEmailFriends(<%=col_id%>)" type="button" value="Send" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
<% 
			String styleBookmark = "";
			if(userprofile_id == -1){
%>
					<td colspan="3" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
						Bookmark This Colloquium
					</td>
<%			
			}else{
				styleBookmark = "style=\"height: 0px;overflow: hidden;\"";
%>
					<td colspan="3" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
						Your Note
					</td>
					<td width="40%" bgcolor="#efefef" align="right">
						<input id="btnDeleteNote" class="btn" type="button" value="Delete" onclick="deleteCol(<%=col_id%>);" />&nbsp;
<%-- 
						<input style="width: 0px;display: none;" id="btnCancelEditNote"  type="button" value="Cancel" onclick="cancelEditNote();" />
--%>
						<input id="btnEditNote" class="btn" type="button" value="Edit" onclick="editNote();" />
					</td>
<%			
			}
%>
				</tr>
				<tr>
					<td colspan="3">
<% 
			if(userprofile_id != -1){
%>
						<div id="divNote">
							<table cellspacing="0" cellpadding="0" width="100%" align="center">
								<tr>
									<td style="font-size: 0.75em;font-weight: bold;" width="20%">Tags:</td>
									<td style="font-size: 0.75em;"><%=tags%></td>
								</tr>
								<tr>
									<td valign="top" style="font-size: 0.75em;font-weight: bold;" width="20%">Notes:</td>
									<td style="font-size: 0.75em;"><%=notes%></td>
								</tr>
<% 
				if(mapComm.size() > 0){
%>								
								<tr>
									<td valign="top" style="font-size: 0.75em;font-weight: bold;">Post to:</td>
									<td style="font-size: 0.75em;">
<% 
					Vector<String> v = new Vector<String>(mapComm.keySet());
					Collections.sort(v);
					for(Iterator<String> it = v.iterator();it.hasNext();){	
						String comm_name = it.next();					
%>
						<a href="community.do?comm_id=<%=mapComm.get(comm_name).longValue()%>"><%=comm_name%></a>&nbsp;
<%					
					}
%>
									</td>
								</tr>
<% 
				}
%>							
								<tr>
									<td style="font-size: 0.75em;font-weight: bold;" width="20%">Post Time:</td>
									<td style="font-size: 0.75em;"><%=_date%></td>
								</tr>
							</table>
						</div>
<%			
			}
%>
						<div id="divBookmark" <%=styleBookmark%>>
							<html:form action="/bookmarkColloquium">
								<table cellspacing="0" cellpadding="0" width="100%" align="center">
									<tr>
										<td width="20%" style="font-size: 0.75em;font-weight: bold;">Tags:</td>
										<td style="font-size: 0.75em;">
											<input type="text" name="tags" size="50" value="<%=usertags%>" />
											<input type="hidden" name="col_id" value="<%=col_id%>"  /><b>(Separate them by white space)</b>
										</td>
									</tr>
									<tr>
										<td valign="top" style="font-size: 0.75em;font-weight: bold;">Notes:</td>
										<td style="font-size: 0.75em;"><textarea name="note" cols="45" rows="5"><%=notes%></textarea></td>
									</tr>
									<tr>
										<td width="20%" valign="top" style="font-size: 0.75em;font-weight: bold;">Post to:</td>
										<td>
											<table cellspacing="0" cellpadding="0" width="100%" align="center" >
<% 
			sql = "SELECT comm_id,comm_name FROM community ORDER BY comm_name";
			rs.close();
			rs = conn.getResultSet(sql);
			int row = 0;
			while(rs.next()){
				if(row%3==0){
%>
												<tr>
<%			
				}
				String checked = "";
				if(mapComm.containsValue(Long.valueOf(rs.getString("comm_id")))){
					checked = "checked=\"checked\"";
				}
%>
													<td style="font-size: 0.75em;" valign="top">
														<input type="checkbox" name="selectedCommunities" <%=checked%> value="<%=rs.getString("comm_id")%>" />
															&nbsp;<span style="font-size: 0.8em;"><%=rs.getString("comm_name")%></span>
													</td>
<%						
				if(row%3==2){
%>
												</tr>
<%			
				}
				row++;
			}
			if(row > 0 && row%3 != 2){
%>
													<td colspan="<%=(3-row%3)%>" style="font-size: 0.75em;">&nbsp;</td>
												</tr>
<%		
			}
%>										
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="2"><input type="submit" class="btn" value="Save" /></td>
									</tr>
								</table>
							</html:form>
						</div>
					</td>
				</tr>
<%		
		}

		//Tags
		String tags = "";
		sql = "SELECT t.tag_id,t.tag,COUNT(*) _no FROM tag t,tags tt,userprofile u " +
				"WHERE t.tag_id = tt.tag_id AND " +
				"tt.userprofile_id = u.userprofile_id AND " +
				"u.col_id = " + col_id;
		if(ub != null){
			sql += " AND u.user_id <> " + ub.getUserID();
		}
		sql +=	" GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
		rsExt = conn.getResultSet(sql);
		if(rsExt != null){
			while(rsExt.next()){
				String tag = rsExt.getString("tag");
				long tag_id = rsExt.getLong("tag_id");
				long _no = rsExt.getLong("_no");
				if(tag.length() > 0){
					tags +=	"&nbsp;<a href=\"tag.do?tag_id=" + tag_id + "\">" + tag + "</a>";
				}
			}
		}
		
		String communities = "";		
		sql = "SELECT c.comm_id,c.comm_name,COUNT(*) _no FROM community c,contribute ct,userprofile u " +
				"WHERE c.comm_id = ct.comm_id AND " +
				"ct.userprofile_id = u.userprofile_id AND " + 
				"u.col_id = " + col_id;
		if(ub != null){
			sql += " AND u.user_id <> " + ub.getUserID();
		}
		sql +=	" GROUP BY c.comm_id,c.comm_name " +
				"ORDER BY c.comm_name";
		rsExt.close();
		rsExt = conn.getResultSet(sql);
		if(rsExt != null){
			while(rsExt.next()){
				String comm_name = rsExt.getString("comm_name");
				long comm_id = rsExt.getLong("comm_id");
				long _no = rsExt.getLong("_no");
				if(comm_name.length() > 0){
					communities += "&nbsp;<a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a>"; 
				}
			}
		}
		//Bookmark by
		String bookmarks = "";
		sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u,userprofile up " +
				"WHERE u.user_id = up.user_id AND up.col_id = " + col_id;
		if(ub != null){
			sql += " AND u.user_id <> " + ub.getUserID();
		}
		sql +=	" GROUP BY u.user_id,u.name ORDER BY u.name";
		rsExt.close();
		rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			while(rsExt.next()){
				String user_name = rsExt.getString("name");
				long user_id = rsExt.getLong("user_id");
				long _no = rsExt.getLong("_no");
				if(user_name.length() > 0){
					bookmarks += "&nbsp;<a href=\"calendar.do?user_id=" + user_id + "\">" + user_name + "</a>";				
				}
			}
		}
		
		if(tags.length() + communities.length() + bookmarks.length() > 0){
%>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td width="85%" colspan="3" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
						Others Notes
					</td>
				</tr>
				<tr>
					<td colspan="3">
							<table cellspacing="0" cellpadding="0" width="100%" align="center">
<% 
			if(tags.length() > 0){
%>
								<tr>
									<td style="font-size: 0.75em;font-weight: bold;" width="20%">Tags:</td>
									<td style="font-size: 0.75em;"><%=tags%></td>
								</tr>
<%
			}
			if(communities.length() > 0){
%>
								<tr>
									<td valign="top" style="font-size: 0.75em;font-weight: bold;" width="20%">Post to communities:</td>
									<td style="font-size: 0.75em;"><%=communities%></td>
								</tr>
<%			
			}
			if(bookmarks.length() > 0){
%>
								<tr>
									<td style="font-size: 0.75em;font-weight: bold;" width="20%">Bookmarked by:</td>
									<td style="font-size: 0.75em;"><%=bookmarks%></td>
								</tr>
<%			
			}
%>
							</table>
					</td>
				</tr>
<%		
		}
%>
			</table>
		</td>
		<td width="90" valign="top">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
				<tr>
					<td>
						<tiles:insert template="/utils/impact.jsp" />
					</td>
				</tr>
				<tr>
					<td>
						<%@include file="/utils/feed.jsp" %>
						<tiles:insert template="/utils/tagCloud.jsp" />
					</td>
				</tr>
				<tr>
					<td>
						<tiles:insert template="/utils/scholarCitationStat.jsp" />
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">
						<tiles:insert template="/utils/namedEntity.jsp" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%
		}
		rs.close();	
		conn.conn.close();
		conn = null;																					
	}catch(SQLException e){
		
	}
%>		
