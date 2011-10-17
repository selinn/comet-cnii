<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.Format"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>

<% 
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
	Calendar calendar = new GregorianCalendar();
	int day = calendar.get(Calendar.DAY_OF_MONTH);
	int month = calendar.get(Calendar.MONTH);
	int year = calendar.get(Calendar.YEAR);
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String user_id = (String)request.getParameter("user_id");
	String insertFirst = (String)request.getParameter("insertfirst");
	String appendLast = (String)request.getParameter("appendlast");
	String timeStamp = (String)request.getParameter("timestamp");
	String req_activity_id = (String)request.getParameter("activity_id");
	String req_activity = (String)request.getParameter("activity");
	if((user_id==null&&ub==null)&&(req_activity_id==null&&req_activity==null)){

	}else{

		if(user_id==null){
			user_id = "" + ub.getUserID();
		}
		connectDB conn = new connectDB();
		String sql = "SELECT u.user_id,u.name,a.activity,a.activity_id,a.activitytime,a.day,a._year,a._time " +
						"FROM activities a JOIN userinfo u ON a.user_id=u.user_id WHERE a.user_id=" + 
						user_id;
		boolean showAll = false;
		if(req_activity_id!=null&&req_activity!=null){
			sql = "SELECT u.user_id,u.name,a.activity,a.activity_id,a.activitytime,a.day,a._year,a._time " +
					"FROM activities a JOIN userinfo u ON a.user_id=u.user_id WHERE a.activity='" + req_activity + 
					"' AND a.activity_id=" + req_activity_id;
			showAll = true;
		}
		if(insertFirst!=null){
			sql += " AND a.activitytime > " + (timeStamp==null?"NOW()":"'" + timeStamp + "'");
		}else if(appendLast!=null){
			sql += " AND a.activitytime < " + (timeStamp==null?"NOW()":"'" + timeStamp + "'");
		}
		sql += " LIMIT 0,100";
		
		//out.println(sql);
		
		String lastTime = null;
		String lastTimeID = null;
		ResultSet rsExt;
		Format formatter = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss"); 
		Format formatterDay = new SimpleDateFormat("MMMMM d"); 
		Format formatterDayYear = new SimpleDateFormat("MMMMM d, yyyy"); 
		ResultSet rs = conn.getResultSet(sql);
		Date today = new Date();
		final long MILLISECS_PER_DAY = 24*60*60*1000;
		final long MILLISECS_PER_HOUR = 60*60*1000;
		final long MILLISECS_PER_MIN = 60*1000;
		final long MILLISECS = 1000;
		int ii = 0;
%>
<table width="<%=showAll?"70":"100" %>%" align="left" border="0" cellspacing="0" cellpadding="0" style="font-size: <%=appendLast!=null?"1":"0.7" %>em;">
<% 
		if(appendLast==null){
%>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<%
		}
		while(rs.next()){
			if(ii>0||appendLast!=null){
%>
<%-- 
	<tr>
		<td colspan="2"><hr style="border: none;height: 2px;color: #efefef;background-color: #efefef;" /></td>
	</tr>
--%>
	<tr>
		<td colspan="2" style="border-bottom: 1px solid #efefef;" >&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" style="border-top: 1px solid #efefef;" >&nbsp;</td>
	</tr>
<%
			}
			String _day = null;
			user_id = rs.getString("user_id");
			String name = rs.getString("name");
			String activity = rs.getString("activity");
			String activity_id = rs.getString("activity_id");
			String activitytime = rs.getString("activitytime");
			Timestamp _atime = rs.getTimestamp("activitytime");
			int _year = rs.getInt("_year");
			String _time = rs.getString("_time");
			lastTime = activitytime;
			lastTimeID = formatter.format(_atime);
			long _dateDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_DAY;
			long _hourDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_HOUR;
			long _minDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_MIN;
			long _secDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS;
			if(_dateDiff >= 1){
				if(_dateDiff == 1){
					_day = "Yesterday";
				}else{
					_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;				
				}
			}else if(_hourDiff >= 1){
				_day = (_hourDiff==1&&_minDiff>0?"about ":"") + _hourDiff + " hour" + (_hourDiff>1?"s":"") + " ago";
			}else if(_minDiff >= 1){
				_day = _minDiff + " minute" + (_minDiff>1?"s":"") + " ago";
			}else if(_secDiff > 0){
				_day = (_secDiff<=1?"a":"" + _secDiff) + " second" + (_secDiff>1?"s":"") + " ago";
			}else{
				_day = "a second ago";
			}

			if(activity.equalsIgnoreCase("was-user-commented")){
				sql = "SELECT u.user_id,u.name,c.comment FROM userinfo u JOIN comment c ON u.user_id = c.user_id WHERE c.comment_id=" + activity_id;
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String _uid = rsExt.getString("user_id");
					String commenter = rsExt.getString("name");
					String comment = rsExt.getString("comment").replaceAll("\\n","<br/>");
					
					int commentno = 0;
					sql = "SELECT COUNT(*) _no FROM comment_comment WHERE commentee_id=" + activity_id;
					rsExt = conn.getResultSet(sql);
					if(rsExt.next()){
						commentno = rsExt.getInt(1);
					}
					
					int likeno = 0;
					sql = "SELECT COUNT(*) _no FROM final_like_comment WHERE comment_id=" + activity_id;
					rsExt = conn.getResultSet(sql);
					if(rsExt.next()){
						likeno = rsExt.getInt(1);
					}
					String objLikeTag = "";
					boolean isyou = false;
					if(likeno > 0){
						if(ub!=null){
							//Is it you?
							sql = "SELECT COUNT(*) _no FROM final_like_comment WHERE comment_id=" + activity_id + " AND user_id=" + ub.getUserID();
							rsExt = conn.getResultSet(sql);
							if(rsExt.next()){
								isyou = (rsExt.getInt(1)>0?true:false);
							}
							
							//Any friends?Pick 3 randomly
							HashMap<Integer,String> friends = new HashMap<Integer,String>();
							sql = "SELECT u.user_id,u.name FROM userinfo u JOIN final_like_comment flc ON u.user_id=flc.user_id WHERE flc.comment_id=" + activity_id +
									" AND u.user_id<>" + ub.getUserID() + " ORDER BY RAND() LIMIT 3";
							rsExt = conn.getResultSet(sql);
							while(rsExt.next()){
								friends.put(rsExt.getInt(1),rsExt.getString(2));
							}
							
							int shownno = 0;
							if(isyou){
								objLikeTag += "You";
								shownno++;
							}
							
							for(int friendid : friends.keySet()){
								if(shownno == likeno-1){
									if(shownno > 0){
										objLikeTag += " and ";
									}
								}else{
									objLikeTag += ", ";
								}
								objLikeTag += "<a href='profile.do?user_id=" + friendid + "'>" + friends.get(friendid) + "</a>";
								shownno++;
							}
							
							if(shownno < likeno){
								objLikeTag += " and " + (likeno-shownno) + " " + (likeno-shownno>1?"people":"person"); 
							}
							
							objLikeTag += " like" + (likeno==1&&!isyou?"s":"") + " this";
						}else{
							objLikeTag += (likeno) + " " + (likeno>1?"people":"person"); 
							objLikeTag += " like" + (likeno==1?"s":"") + " this";
							
						}
					}
					
					//Here it is the rule: #comment + #like > 40 then hide detail just show only icons
					//For comment, #comment <=5 show all, else, show latest 2, the rest hidden
					//For like, if 1 like then show the user, else show only the 3 friends (randomly, if any, including youself) and the rest just shown the number
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 60px;">
			<a href="profile.do?user_id=<%=_uid %>"><%=commenter %></a>
		</td>
 		<td valign="top" align="left">
 			&nbsp;<%=comment %><br/>
	  		&nbsp;<span style="color: #aeaeae;font-size: 0.9em;"><%=_day %></span>&nbsp;
<% 
					if(commentno + likeno > 40){
%>
			<a href="javascript:return false;" onclick="document.getElementById('cid<%=activity_id %>').style.display='block';">
<%
						if(commentno > 0){
%>
				<img border="0" src="images/comment_icon.gif" /><%=commentno %>&nbsp;
<%							
						}
						if(likeno > 0){
%>
				<img border="0" src="images/like_icon.png" /><%=likeno %>
<%							
						}
%>
			</a>
<%
					}
%>				  		
			<logic:present name="UserSession">
		  		<a href="javascript:return false;" 
		  			onclick="likeComment(<%=ub.getUserID() %>,<%=activity_id %>,this,'tdlikecid<%=activity_id %>');document.getElementById('cid<%=activity_id %>').style.display='block';"><%=isyou?"Unlike":"Like" %></a>
		  		&nbsp;
		  		<a href="javascript:return false;" onclick="document.getElementById('cid<%=activity_id %>').style.display='block';">Comment</a>
			</logic:present>
	  		<div id="cid<%=activity_id %>" style="<%=(commentno + likeno > 0?(commentno + likeno <= 40?"":"display: none;"):"display: none;") %>">
	  			<br/>
	  			<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="background-color: #efefef;">
	  				<tr>
	  					<td align="center">
	  						<table width="98%" border="0" cellpadding="0" cellspacing="2" style="font-size: 0.7em;">
								<tr>
									<td colspan="2" id="tdlikecid<%=activity_id %>" style="<%=likeno>0?"":"display:none;" %>">
										<img border="0" src="images/like_icon.png" /> <%=objLikeTag %>
									</td>
								</tr>
<%
					if(commentno > 0){
						if(commentno <= 20 || showAll){
							if(commentno > 5 && !showAll){
%>
								<tr>
									<td id="tdccid<%=activity_id %>" colspan="2" style="vertical-align: middle;border-top: 1px solid white;">
										<img border="0" src="images/comment_icon.gif" /> 
										<a href="javascript:return false;" onclick="document.getElementById('tdccid<%=activity_id %>').style.display='none';document.getElementById('ccid<%=activity_id %>').style.display='block';">
											View all <%=commentno %> comments 
										</a>
									</td>
								</tr>
<%								
							}
							sql = "SELECT c.comment_id,c.comment,c.comment_date,c.user_id,u.name " +
									"FROM comment c JOIN comment_comment cc ON c.comment_id=cc.comment_id " +
									"JOIN userinfo u ON c.user_id=u.user_id " +
									"WHERE cc.commentee_id=" + activity_id + " ORDER BY c.comment_date";
							rsExt = conn.getResultSet(sql);
							int i=0;
							while(rsExt.next()){
								String comment_id = rsExt.getString("comment_id");
								String replycomment = rsExt.getString("comment").replaceAll("\\n","<br/>");
								String replyuid = rsExt.getString("user_id");
								String replyer = rsExt.getString("name");
								Timestamp replytime = rsExt.getTimestamp("comment_date");
								if(commentno > 5 && i==0 && !showAll){
%>
								<tr>
									<td colspan="2">
							  			<table id="ccid<%=activity_id %>" width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="font-size: 1em;background-color: #efefef;display: none;">
<%									
								}
%>
								<tr>
									<td colspan="2" style="border-top: 1px solid white;" />
								</tr>
								<tr>
									<td valign="top" style="width: 55px;">
										<a href="profile.do?user_id=<%=replyuid %>"><%=replyer %></a>
									</td>
									<td align="left">
										<%=replycomment %>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td align="left">
										<table cellpadding="0" cellspacing="0" border="0" style="font-size: 0.9em;">
											<tr>
												<td style="color: #aeaeae;margin-left: 0px;margin-right: 0px;">
<% 
								long dateDiff = (today.getTime() - replytime.getTime())/MILLISECS_PER_DAY;
								long hourDiff = (today.getTime() - replytime.getTime())/MILLISECS_PER_HOUR;
								long minDiff = (today.getTime() - replytime.getTime())/MILLISECS_PER_MIN;
								long secDiff = (today.getTime() - replytime.getTime())/MILLISECS;
								if(dateDiff >= 1){
									if(dateDiff == 1){
%>
													Yesterday
<%										
									}else{
										
%>
											<%=(replytime.getYear()==year?formatterDay.format(replytime):formatterDayYear.format(replytime)) %>
<%										
									}
								}else if(hourDiff >= 1){
%>
											<%=(hourDiff==1&&minDiff>0?"about ":"") %><%=hourDiff %> hour<%=hourDiff>1?"s":"" %> ago
<%									
								}else if(minDiff >= 1){
%>
											<%=minDiff %> minute<%=minDiff>1?"s":"" %> ago
<%									
								}else if(secDiff > 0){
%>
											<%=(secDiff<=1?"a":"" + secDiff) %> second<%=secDiff>1?"s":"" %> ago
<%									
								}else{
%>
											a second ago
<%													
								}
								likeno = 0;
								sql = "SELECT COUNT(*) _no FROM final_like_comment WHERE comment_id=" + comment_id;
								ResultSet _rsExt = conn.getResultSet(sql);
								if(_rsExt.next()){
									likeno = _rsExt.getInt(1);
								}
								objLikeTag = "";
								isyou = false;
								if(likeno > 0){
									if(ub!=null){
										//Is it you?
										sql = "SELECT COUNT(*) _no FROM final_like_comment WHERE comment_id=" + comment_id + " AND user_id=" + ub.getUserID();
										_rsExt = conn.getResultSet(sql);
										if(_rsExt.next()){
											isyou = (_rsExt.getInt(1)>0?true:false);
										}
										
										//Any friends?Pick 3 randomly
										HashMap<Integer,String> friends = new HashMap<Integer,String>();
										sql = "SELECT u.user_id,u.name FROM userinfo u JOIN final_like_comment flc ON u.user_id=flc.user_id WHERE flc.comment_id=" + comment_id +
												" AND u.user_id<>" + ub.getUserID() + " ORDER BY RAND() LIMIT 3";
										_rsExt = conn.getResultSet(sql);
										while(_rsExt.next()){
											friends.put(_rsExt.getInt(1),_rsExt.getString(2));
										}
										
										int shownno = 0;
										if(isyou){
											objLikeTag += "You";
											shownno++;
										}
										
										for(int friendid : friends.keySet()){
											if(shownno == likeno-1){
												objLikeTag += " and ";
											}else{
												objLikeTag += ", ";
											}
											objLikeTag += "<a href='profile.do?user_id=" + friendid + "'>" + friends.get(friendid) + "</a>";
											shownno++;
										}
										
										if(shownno < likeno){
											objLikeTag += " and " + (likeno-shownno) + " " + (likeno-shownno>1?"people":"person"); 
										}
										
										objLikeTag += " like" + (likeno==1&&!isyou?"s":"") + " this";
									}else{
										objLikeTag += (likeno) + " " + (likeno>1?"people":"person"); 
										objLikeTag += " like" + (likeno==1?"s":"") + " this";
										
									}
								}
%>													
														<logic:present name="UserSession">
															&nbsp;
															<a href="javascript:return false;" 
																onclick="likeComment(<%=ub.getUserID() %>,<%=comment_id %>,this,'tdlikeccid<%=comment_id %>')"><%=isyou?"Unlike":"Like" %>
															</a>
															&nbsp;
														</logic:present>
													</td>
													<td align="left" id="tdlikeccid<%=comment_id %>" style="margin-left: 0px;margin-right: 0px;">
														<%=objLikeTag %>&nbsp;						
													</td>
												</tr>
										</table>	
									</td>
								</tr>
<%								
								if(commentno > 5 && i==commentno-3 && !showAll){
%>
										</table>
									</td>
								</tr>
<%									
								}
								i++;
							}
							
						}else{//Here it should redirect to that post --- in the future :D
%>
								<tr>
									<td id="tdccid<%=activity_id %>" colspan="2" style="vertical-align: middle;border-top: 1px solid white;">
										<a href="javascript:return false;" onclick="loadAnActivity('was-user-commented','<%=activity_id %>');">
											<img border="0" src="images/comment_icon.gif" /> View all <%=commentno-2 %> comments 
										</a>
									</td>
								</tr>
<%								
						}
					}
%>				  				
	  							<tr>
	  								<td id="tdcommentcid<%=activity_id %>" colspan="2" style="display: none;">
	  									<input type="hidden" id="commenttimeccid<%=activity_id %>" value="<%=formatter.format(today) %>" />&nbsp;
	  								</td>
	  							</tr>
<% 
					if(commentno + likeno > 0){
%>
								<tr>
									<td colspan="2" style="border-top: 1px solid white;" />
								</tr>		
<% 
					}
%>
								<logic:present name="UserSession">
									<tr>
										<td style="width: 55px;vertical-align: top;">
											<a href="profile.do?user_id=<%=ub.getUserID() %>"><%=ub.getName() %></a>
										</td>
										<td align="right">
											<textarea id="txtcid<%=activity_id %>" rows="1" cols="64" 
												onfocus="autohintGotFocus(this,tdcb<%=activity_id %>);" 
												onblur="autohintGotBlur(this,tdcb<%=activity_id %>);" 
												class="auto-hint" style="border-style: solid;" title="Write a comment...">Write a comment...</textarea>	  								
										</td>
									</tr>
									<tr style="border-top: 1px solid white;">
										<td colspan="2" id="tdcb<%=activity_id %>" style="text-align: right;display: none;">
											<input class="btn" id="btnReplyComment<%=activity_id %>" 
												onclick="replyComment(<%=activity_id %>,'txtcid<%=activity_id %>','tdcb<%=activity_id %>');" 
												type="button" value="Comment"></input>
										</td>
									</tr>
								</logic:present>
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
			if(activity.equalsIgnoreCase("joined")){
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id%>"><%=name %></a></td>
  		<td valign="top" align="left">joined CoMeT <br/><span style="color: #aeaeae; font-size: 0.9em;"><%=_day %></span></td>
	</tr>
<%			
			}
			
			if(activity.equalsIgnoreCase("posted")){
				sql = "SELECT a.title FROM activitypost a WHERE activity_id=" + activity_id;
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String title = rsExt.getString("title");
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id%>"><%=name %></a></td>
  		<td valign="top" align="left">posted <a href="presentColloquium.do?col_id=<%=activity_id %>"><%=title %></a> <br/><span style="color: #aeaeae;font-size: 0.9em;"><%=_day %></span></td>
	</tr>
<%			
				}
			}
			if(activity.equalsIgnoreCase("updated")){
				sql = "SELECT a.title FROM activitypost a WHERE activity_id=" + activity_id;
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String title = rsExt.getString("title");
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id%>"><%=name %></a></td>
  		<td valign="top" align="left">updated <a href="presentColloquium.do?col_id=<%=activity_id %>"><%=title %></a> <br/><span style="color: #aeaeae;font-size: 0.9em;"><%=_day %></span></td>
	</tr>
<%			
				}
			}
			if(activity.equalsIgnoreCase("bookmarked")){
				sql = "SELECT a.col_id,a.title FROM activitybookmark a WHERE activity_id=" + activity_id;//It's userprofile_id
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String col_id = rsExt.getString("col_id");
					String title = rsExt.getString("title");
					
					String tags = "";
					sql = "SELECT t.tag,t.tag_id FROM tags tt JOIN tag t ON tt.tag_id=t.tag_id " +
							"WHERE tt.userprofile_id=" + activity_id +
							" AND LENGTH(TRIM(t.tag)) > 0 ";
					rsExt.close();
					rsExt = conn.getResultSet(sql);
					while(rsExt.next()){
						String tag = rsExt.getString("tag");
						String tag_id = rsExt.getString("tag_id");
						
						if(tags.length() > 0){
							tags += ", ";
						}
						
						tags += "<a href=\"tag.do?tag_id=" + tag_id + "\">" + tag + "</a>";
					}
					
					String groups = "";
					sql = "SELECT c.comm_id,c.comm_name FROM community c JOIN contribute ct ON c.comm_id=ct.comm_id WHERE ct.userprofile_id=" + activity_id;
					rsExt.close();
					rsExt = conn.getResultSet(sql);
					while(rsExt.next()){
						String comm_id = rsExt.getString("comm_id");
						String comm_name = rsExt.getString("comm_name");
						
						if(groups.length() > 0){
							groups += ", ";
						}
						
						groups += "<a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a>";
					}
					
					String extraAct = "";
					if(tags.trim().length() > 0){
						extraAct += ", and tagged with " + tags;
					}
					if(groups.trim().length() > 0){
						extraAct += ", and  contributed to " + groups;
					}
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id%>"><%=name %></a></td>
 		<td valign="top"  align="left">bookmarked <a href="presentColloquium.do?col_id=<%=col_id %>"><%=title %></a> <%=extraAct %> <br/><span style="color: #aaaaaa;font-size: 0.9em;"><%=_day %></span></td>
	</tr>
<%			
				}
			}
			ii++;
		}
		if(ii>0&&insertFirst!=null){
%>
<%-- 
	<tr>
		<td colspan="2"><hr style="border: none;height: 2px;color: #efefef;background-color: #efefef;" /></td>
	</tr>
--%>
	<tr>
		<td colspan="2" style="border-bottom: 1px solid #efefef;" >&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" style="border-top: 1px solid #efefef;" >&nbsp;</td>
	</tr>
<%
		}
		if(insertFirst==null&&!showAll){
			sql = "SELECT COUNT(*) _no " +
					"FROM activities a JOIN userinfo u ON a.user_id=u.user_id WHERE a.user_id=" + 
					user_id;
			sql += " AND a.activitytime < " + (lastTime==null?"NOW()":"'" + lastTime + "'");
			rs = conn.getResultSet(sql);
			if(rs.next()){
				int _no = rs.getInt(1);
				if(_no > 0){
%>
	<tr>
		<td colspan="2">
			<div id="divOlderPosts<%=lastTimeID %>" align="center">
				<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
					<tr>
						<td bgcolor="#efefef" style="font-size: 0.25em;">&nbsp;</td>
					</tr>
					<tr>
						<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">&nbsp;<input class="btn" type="button" onclick="this.value='Loading...';this.style.disabled='disabled';showOlderPosts(<%=user_id %>,'divOlderPosts<%=lastTimeID %>','<%=lastTime %>');return false;" value="Older Posts" ></input></td>
					</tr>
					<tr>
						<td bgcolor="#efefef" style="font-size: 0.25em;">&nbsp;</td>
					</tr>
				</table>	
			</div>
		</td>
	</tr>
<%					
				}
			}
		}
%>
</table>
<%

		conn.conn.close();
		conn = null;
	}
%>
<script type="text/javascript">
	window.onload = function(){
		if(divUserActivityContent){
			if(parent.displayTalks){
				parent.displayTalks(divUserActivityContent.innerHTML);
			}
		}
	}
</script>	
