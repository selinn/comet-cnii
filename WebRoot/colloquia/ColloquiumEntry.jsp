<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.form.ColloquiumForm"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
	session=request.getSession(false);
%>

<logic:present name="UserSession">
<% 
	session.removeAttribute("redirect");
%>
<!-- calendar stylesheet -->
<link rel="stylesheet" type="text/css" media="all" href="css/calendar-win2k-cold-1.css" title="win2k-cold-1" />

<!-- main calendar program -->
<script type="text/javascript" src="scripts/calendar.js"></script>

<!-- language for the calendar -->
<script type="text/javascript" src="scripts/calendar-en.js"></script>

<!-- the following script defines the Calendar.setup helper function, which makes
     adding a calendar a matter of 1 or 2 lines of code. -->
<script type="text/javascript" src="scripts/calendar-setup.js"></script>

<script type="text/javascript" src="ckeditor/ckeditor.js"></script>	
<script src="ckeditor/sample.js" type="text/javascript"></script> 
<link href="ckeditor/sample.css" rel="stylesheet" type="text/css"/>		

	
<logic:present name="Colloquium">
<% 
	ColloquiumForm cqf = (ColloquiumForm)session.getAttribute("Colloquium");
	String title = cqf.getTitle();
	long col_id = cqf.getCol_id();
%>
<span style="font-size: 0.8em;font-weight: bold;"><a href="presentColloquium.do?col_id=<%=col_id %>"><%=title %></a> was Submitted Successfully!</span>
<br/><br/>
<span style="font-size: 0.8em;">It will automatically redirect to the talk page in 3 seconds.</span><br/>
<script type="text/javascript">
	var talkpage = "presentColloquium.do?col_id=<%=col_id %>";
	window.setTimeout(function(){window.location = talkpage;},3000);
</script>
<span style="font-size: 0.8em;">
Questions can be directed to CoMeT via email at 
<a href="mailto:comet.paws@gmail.com">comet.paws@gmail.com</a>.</span>
</logic:present>

<logic:notPresent name="Colloquium">

<style type='text/css' media='all'>
 ul li{
     list-style-type:none;
     margin:0;
     padding:0;
     margin-left:8px;
 }
</style>
<script type="text/javascript">
	function showChildren(obj,btn){
		if(obj){
			obj.style.display = "block";
			btn.style.width="0px";
			btn.style.display="none";
		}
	}
</script>

<html:form action="/PostColloquiumEntry" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
<% 
	//UserBean ub = (UserBean)session.getAttribute("UserSession");
	String col_id = "0";
	String title = "";
	String speaker = "";
	String affiliation = "";
	String host = "";
	HashSet<String> seriesSet = new HashSet<String>();
	String _date = "";
	String begintime = "";
	String endtime = "";
	String location = "";
	String detail = "";
	String url = "";
	String video_url = "";
	String slide_url = "";
	String s_bio = "";
	HashSet<String> sponsorSet = new HashSet<String>();

	String sql = "SELECT c.col_id,c.title,s.name,s.affiliation,h.host,date_format(c._date,_utf8'%m/%d/%Y') _date," +
					"date_format(c.begintime,_utf8'%l %i %p') _begin," +
					"date_format(c.endtime,_utf8'%l %i %p') _end,c.location,c.detail,c.url,c.video_url,c.slide_url,c.s_bio " +
					"FROM colloquium c JOIN speaker s ON c.speaker_id = s.speaker_id " +
					"LEFT OUTER JOIN host h ON c.host_id = h.host_id " + 
					"WHERE " +
					//"c.user_id = " + ub.getUserID() + " AND " +
					"c.col_id = " + request.getParameter("col_id");
	connectDB conn = new connectDB();
	ResultSet rs = conn.getResultSet(sql);
	if(rs.next()){
		col_id = rs.getString("col_id");
		title = rs.getString("title");
		speaker = rs.getString("name");
		affiliation = rs.getString("affiliation");
		host = rs.getString("host");
		if(host == null){
			host = "";
		}
		_date = rs.getString("_date");
		begintime = rs.getString("_begin");
		endtime = rs.getString("_end");
		location = rs.getString("location");
		detail = rs.getString("detail");
		url = rs.getString("url");
		video_url = rs.getString("video_url");
		if(video_url==null){
			video_url = "";
		}
		slide_url = rs.getString("slide_url");
		if(slide_url==null){
			slide_url = "";
		}
		s_bio = rs.getString("s_bio");
		if(s_bio==null){
			s_bio = "";
		}
		
		sql = "SELECT affiliate_id FROM affiliate_col WHERE col_id = " + request.getParameter("col_id");
		rs = conn.getResultSet(sql);
		while(rs.next()){
			sponsorSet.add(rs.getString("affiliate_id"));
		}
	}
	
%>
	<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td width="85%" colspan="2" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
<%
	if(col_id.equalsIgnoreCase("0")){
%>
				Post Talk
<%	
	}else{
%>
				Edit Talk
<%	
	}
%>
		</td>
	</tr>
	<logic:present name="SubmitTalkError">
<% 
	String error = (String)session.getAttribute("SubmitTalkError");
%>
	<tr>
		<td colspan="2">
			<font color="red"><b><%=error%></b></font>
		</td>
	</tr>
	</logic:present>

	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
				<tr> 
						<td width="20%" valign="top" style="font-weight: bold;">Title:</td>
			  		<td><html:text style="font-size: 1em;" property="title" size="80" value="<%=title%>"/></td>
				</tr>
				<tr> 
					<td colspan="2"><font style="color: red;"><b><html:errors property="title"/></b></font></td>
				</tr>
				<tr> 
					<td width="20%" valign="top" style="font-weight: bold;">Speaker:</td>
			  		<td><html:text style="font-size: 1em;" property="speaker" size="80" value="<%=speaker%>"/></td>
				</tr>
				<tr> 
					<td colspan="2"><font style="color: red;"><b><html:errors property="speaker"/></b></font></td>
				</tr>
				<tr> 
					<td width="20%" valign="top" style="font-weight: bold;">Speaker Affiliation: (optional)</td>
			  		<td><html:text style="font-size: 1em;" property="affiliation" size="80" value="<%=affiliation%>"/></td>
				</tr>
				<tr> 
					<td colspan="2"><font style="color: red;"><b><html:errors property="affiliation"/></b></font></td>
				</tr>
				<tr> 
					<td width="20%" style="font-weight: bold;">Person hosting a talk: (optional)</td>
				  	<td><html:text style="font-size: 1em;" property="host" size="80" value="<%=host%>"/></td>
				</tr>
				<tr> 
					<td colspan="2"><font style="color: red;"><html:errors property="host"/></font></td>
				</tr>
				<tr>
					<td width="20%" valign="top" style="font-weight: bold;">Series (optional):</td>
					<td>
<% 
	if(!col_id.equalsIgnoreCase("0")){
		sql = "SELECT series_id FROM seriescol WHERE col_id = " + col_id;
		rs = conn.getResultSet(sql);
		while(rs.next()){
			seriesSet.add(rs.getString("series_id"));	
		}
	}
	String seriesStyle = "display: block;";
	if(seriesSet.size() == 0){
		seriesStyle = "display: none;";
%>
						<input class="btn" type="button" id="btnShowSeries" value="Show Series" 
						onclick="showChildren(ulSeries,this);" />
<%	
	}
%>

<%	
	sql = "SELECT series_id,name FROM series " +
			//"WHERE semester = (SELECT currsemester FROM sys_config) " + 
			"ORDER BY name";
	rs = conn.getResultSet(sql);
%>
						<ul id="ulSeries" style="<%=seriesStyle%>">
<%
	while(rs.next()){
		String checked = "";
		String _series_id = rs.getString("series_id");
		String _name = rs.getString("name");
		if(seriesSet.contains(_series_id)){
			checked = "checked='checked'";
		}
%>
						<li>
							<input type="checkbox" name="series_id" value="<%=_series_id%>" <%=checked%>/>&nbsp;<%=_name%><br/>
						</li>
<%	
	}
%>
						</ul>	
					</td>
				</tr>
				<tr> 
					<td width="20%" valign="top" style="font-weight: bold;">Sponsor(s) (optional):</td>
					<td>
						<ul>
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
							<li>
								<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%>
<%
		sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + 
		" ORDER BY a.affiliate";
		ResultSet rs1 = conn.getResultSet(sql);
		boolean lvl1Hidden = false;
		while(rs1.next()){
			aid = rs1.getString("affiliate_id");
			aff = rs1.getString("affiliate");
			if(!lvl1Hidden){
%>
								<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
								onclick="showChildren(ulSponsor<%=aid%>,this);"  />
								<ul id="ulSponsor<%=aid %>" style="display: none;">
<%		
				lvl1Hidden = true;
			}
			checked = "";
			if(sponsorSet.contains(aid)){
				checked = "checked='checked'";		
			}
%>
									<li>
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%>
<%
			sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
			ResultSet rs2 = conn.getResultSet(sql);
			boolean lvl2Hidden = false;
			while(rs2.next()){
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
				if(!lvl2Hidden){
%>
										<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
										onclick="showChildren(ulSponsor<%=aid%>,this);"  />
										<ul id="ulSponsor<%=aid%>" style="display: none;">
<%
					lvl2Hidden = true;
				}
				checked = "";
				if(sponsorSet.contains(aid)){
					checked = "checked='checked'";		
				}
%>
											<li>
												<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
												&nbsp;&nbsp;<%=aff%>
<%
				sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + 
						aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				boolean lvl3Hidden = false;
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					if(!lvl3Hidden){
						lvl3Hidden = true;
%>
												<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
												onclick="showChildren(ulSponsor<%=aid%>,this);"  />
												<ul id="ulSponsor<%=aid%>" style="display: none;">
<%
					}
					checked = "";
					if(sponsorSet.contains(aid)){
						checked = "checked='checked'";		
					}
%>
													<li>
														<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
														&nbsp;&nbsp;<%=aff%>
													</li>
<%
				}
				rs3.close();
				if(lvl3Hidden){
%>
												</ul>
<%
				}
%>
											</li>
<%						
				
			}
			rs2.close();
			if(lvl2Hidden){
%>
										</ul>
<%
			}
%>
									</li>
<%						
		}
		rs1.close();
		if(lvl1Hidden){
%>
								</ul>
<%
		}
%>
							</li>
<%						
	}
	rs0.close();
	conn.conn.close();
	conn = null;
%>			
						</ul>
					</td>
				</tr>
				<tr> 
				  <td width="20%" style="font-weight: bold;">Date(month/date/year):</td>
				  <td>
					  <html:text style="font-size: 1em;" property="talkDate" size="10" styleId="f_date_c" value="<%=_date%>" />
					  <html:img page="/images/calendar.gif" styleId="f_trigger_c" 
					    style="cursor: pointer; border: 0px solid red;" 
					    imageName="Date selector"
						onmouseover="this.style.background='cyan';" 
						onmouseout="this.style.background=''" />  
					  <script type="text/javascript">
							      Calendar.setup({
							        inputField     :    "f_date_c",     // id of the input field
							        ifFormat       :    "%m/%d/%Y",     // format of the input field
							        button         :    "f_trigger_c",  // trigger for the calendar (button ID)
							        align          :    "Tl",           // alignment (defaults to "Bl")
							        singleClick    :    true
							    });
					  </script>
				   </td>			
				</tr>
				<tr> 
				  <td colspan="2"><font style="color: red;"><html:errors property="talkDate"/></font></td>
				</tr>
			<tr> 
			  <td width="20%" style="font-weight: bold;">Begin Time:</td>
			  <td>
			  	<select name="beginHour" style="font-size: 1em;" >
<% 
	String beginhour = "";
	String beginmin = "";
	String beginampm = "";
	if(!begintime.equalsIgnoreCase("")){
		String[] btime = begintime.split(" ");
		beginhour = btime[0];
		beginmin = btime[1];
		beginampm = btime[2];
	}
	for(int i=0;i<12;i++){
		String selected = "";
		if(beginhour.equalsIgnoreCase(String.valueOf(i+1))){
			selected = "selected='selected'";	
		}
%>
					<option value="<%=i+1%>" <%=selected%>><%=i+1%></option>
<%	
	}
%>
			  	</select> : 
			  	<select name="beginMin" style="font-size: 1em;" >
<% 
	for(int i=0;i<12;i++){
		String value = String.valueOf(i*5);
		if(value.length()==1){
			value = "0" + value;
		}
		String selected = "";
		if(beginmin.equalsIgnoreCase(value)){
			selected = "selected='selected'";	
		}
%>
					<option value="<%=value%>" <%=selected%>><%=value%></option>
<%	
	}
%>
			  	</select>  
			  	<select name="beginAMPM" style="font-size: 1em;" >
			  		<option value="PM">PM</option>
<% 
	String selected = "";
	if(beginampm.equalsIgnoreCase("am")){
		selected = "selected='selected'";
	}	
%>
			  		<option value="AM" <%=selected%>>AM</option>
			  	</select>
			  </td>
			</tr>
			<tr> 
			  <td width="20%" style="font-weight: bold;">End Time:</td>
			  <td>
			  	<select name="endHour" style="font-size: 1em;">
<% 
	String endhour = "";
	String endmin = "";
	String endampm = "";
	if(!endtime.equalsIgnoreCase("")){
		String[] etime = endtime.split(" ");
		endhour = etime[0];
		endmin = etime[1];
		endampm = etime[2];
	}
	for(int i=0;i<12;i++){
		selected = "";
		if(endhour.equalsIgnoreCase(String.valueOf(i+1))){
			selected = "selected='selected'";	
		}
%>
					<option value="<%=i+1%>" <%=selected%>><%=i+1%></option>
<%	
	}
%>
			  	</select> : 
			  	<select name="endMin" style="font-size: 1em;" >
<% 
	for(int i=0;i<12;i++){
		String value = String.valueOf(i*5);
		if(value.length()==1){
			value = "0" + value;
		}
		selected = "";
		if(endmin.equalsIgnoreCase(value)){
			selected = "selected='selected'";	
		}
%>
					<option value="<%=value%>" <%=selected%>><%=value%></option>
<%	
	}
%>
			  	</select>  
			  	<select name="endAMPM" style="font-size: 1em;" >
			  		<option value="PM">PM</option>
<% 
	selected = "";
	if(endampm.equalsIgnoreCase("am")){
		selected = "selected='selected'";
	}	
%>
			  		<option value="AM" <%=selected%>>AM</option>
			  	</select>
			</tr>
			<tr>
				<td width="20%" style="font-weight: bold;">URL:</td>
				<td><html:text style="font-size: 1em;" property="url" size="80" value="<%=url%>" /></td>
			</tr>
			<tr> 
			  <td width="20%" style="font-weight: bold;">Location:</td>
			  <td><html:text style="font-size: 1em;" property="location" size="80" value="<%=location%>"/></td>
			</tr>
			<tr> 
			  <td colspan="2"><font style="color: red;"><html:errors property="location"/></font></td>
			</tr>
			<tr>
				<td width="20%" style="font-weight: bold;">Video URL: (optional)</td>
				<td><html:text style="font-size: 1em;" property="video_url" size="80" value="<%=video_url%>" /></td>
			</tr>
			<tr>
				<td width="20%" style="font-weight: bold;">Slide URL: (optional)</td>
				<td><html:text style="font-size: 1em;" property="slide_url" size="80" value="<%=slide_url%>" /></td>
			</tr>
			<tr>
				<td valign="top" style="font-weight: bold;">Detail:</td>
				<td>
					<textarea style="font-size: 1em;" name="detail" rows="20" cols="80"><%=detail%></textarea>
				<script type="text/javascript"> 
				//<![CDATA[
 
					// This call can be placed at any point after the
					// <textarea>, or inside a <head><script> in a
					// window.onload event handler.
 
					// Replace the <textarea id="editor"> with an CKEditor
					// instance, using default configurations.
					CKEDITOR.replace( 'detail' );
 
				//]]>
				</script> 
				</td>
			</tr>
			<tr>
				<td colspan="2"><font style="color: red;"><html:errors property="detail" /></font></td>
			</tr>
<%-- 
			<tr>
				<td valign="top" style="font-weight: bold;">Bio: (optional)</td>
				<td>
					<textarea style="font-size: 1em;" name="s_bio" rows="20" cols="80"><%=s_bio%></textarea>
				<script type="text/javascript"> 
				//<![CDATA[
 
					// This call can be placed at any point after the
					// <textarea>, or inside a <head><script> in a
					// window.onload event handler.
 
					// Replace the <textarea id="editor"> with an CKEditor
					// instance, using default configurations.
					CKEDITOR.replace( 's_bio' );
 
				//]]>
				</script> 
				</td>
			</tr>
--%>
      </table></td>
      </tr>
</table>
<input type="hidden" name="s_bio" value="" />
<input type="hidden" name="col_id" value="<%=col_id %>" />
<input type="submit" class="btn" value="Post Talk" />
</html:form>
</logic:notPresent>

</logic:present>