<%@ page language="java"%>
<%@ page import="edu.pitt.sis.beans.*" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jstl/xml_rt" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%><html>
  	<head>  	
  		<link rel="CoMeT Icon" href="images/logo.png" />
    	<title>
    		<tiles:getAsString name="title"/>
	    </title>
	    <meta http-equiv="pragma" content="no-cache">
	    <meta http-equiv="cache-control" content="no-cache">
	    <meta http-equiv="expires" content="0">    

<%-- 
		<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/xtree.js"%>"></script>
		<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/xmlextras.js"%>"></script>
		<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/xloadtree.js"%>"></script>	
--%>
		<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en"></script>
		<script type="text/javascript">
			function setDocumentTitle(aTitle){
				document.title = aTitle;
			}
		</script>

<style>
input.btn { 
  color:#003399; 
	font: bold 0.7em verdana,helvetica,sans-serif; 
	background-color: #99CCFF; 
  border: 2px solid; 
	border-color: #0066CC #003366 #003366 #0066CC; 
  filter:progid:DXImageTransform.Microsoft.Gradient (GradientType=0,StartColorStr='#ffffffff',EndColorStr='#ffeeddaa'); 
} 
</style>

		<link href="<%=request.getContextPath() + "/css/stylesheet.css"%>" rel="stylesheet" media="grey" />  
	</head>
<% 
	session=request.getSession(false);
	int userID = -1;
	String userName = "";
	String sessionID = session.getId();
	Cookie cookies[] = request.getCookies();
	//Find session id & user id
	boolean foundSessionID = false;
	boolean foundUserID = false;
	if(cookies != null){
		for(int i=0;i<cookies.length;i++){
			Cookie c = cookies[i];
            if (c.getName().equals("comet.session.id")) {
                sessionID = c.getValue();
            	foundSessionID = true;
            }			
            if (c.getName().equals("comet.user.id")) {
                userID = Integer.parseInt(c.getValue());
            	foundUserID = true;
            }			
            if (c.getName().equals("comet.user.name")) {
                userName = c.getValue();
            }			
		}
	}
	if(!foundSessionID){
		Cookie c = new Cookie("comet.session.id", sessionID);
        c.setMaxAge(356*24*60*60);
        response.addCookie(c);
	}
	connectDB conn = new connectDB();
	ResultSet rs;
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	if(ub != null){
		Cookie c = new Cookie("comet.user.id", "" + ub.getUserID());
        c.setMaxAge(356*24*60*60);
        response.addCookie(c);
		c = new Cookie("comet.user.name", ub.getName());
        c.setMaxAge(356*24*60*60);
        response.addCookie(c);
	}else if(foundUserID){
		ub = new UserBean();
		ub.setUserID(userID);
		ub.setName(userName);
		session.setAttribute("UserSession",ub);
	}
%>
	<body leftmargin="0" topmargin="0" style="font-family: arial,Verdana,sans-serif,serif;font-size: 0.9em;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style = "margin-top:8px;margin-bottom:8px;"> 
			<tr>
				<td valign="top" align="left" style = "background-color: #fff;padding-right:4px" rowspan="3" width="18%">
                	<html:link forward="aaa.index" >
                		<img src="images/logo.png" border="0">
                	</html:link>
				</td>			
				<td align="left" style = "background-color: #fff;padding-left:4px" width="52%">		
	                <span style="font-weight:bold; color:#003366;font-size:1.2em;">Collaborative Management of Talks</span>
				</td>    
              	<td align="right" width="30%" style="font-weight:bold; color:#003366;font-size:0.75em;">                        							
					<logic:notPresent name="HideBar">
						<logic:present name="UserSession">
							Welcome <bean:write name="UserSession" property="name" /> <html:link forward="aaa.authentication.logout" >Log out</html:link>
						</logic:present>
						<logic:notPresent name="UserSession">
							<b>Hello!</b> <html:link forward="aaa.authentication.login" >sign in</html:link>
							or <html:link forward="aaa.registration.register" >register</html:link>						
						</logic:notPresent>
					</logic:notPresent>
					<logic:present name="HideBar" />
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold; color: #0080ff; font-size:0.75em;">
					  Bookmark Talks, Share with Friends, and We Recommend More! 
				</td>
				<td align="right">
					<logic:notPresent name="HideBar">
						<logic:notPresent name="UserSession">
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="google" src="images/google.png" border="0"></a> 
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="facebook" src="images/facebook.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="yahoo" src="images/yahoo.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="twitter" src="images/twitter.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="yahoo" src="images/aol.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="myspace" src="images/myspace.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="mslive" src="images/mslive.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="openid" src="images/openid.png" border="0"></a>
						</logic:notPresent>
					</logic:notPresent>
				</td>
			</tr>
			<tr>
				<td align="left" style = "background-color: #fff;padding-right:4px">
					<logic:notPresent name="HideBar">
						<form action="http://www.google.com/cse" id="cse-search-box" style="border:0px;margin:0px;padding:0px">
	                  		<input name="cx" value="007783681798264447413:mijruzgwfwi" type="hidden">
							<input name="ie" value="UTF-8" type="hidden">
						    <input name="q" size="38" type="text">
						    <input name="sa" class ="btn" value="Search" type="submit">
					    </form>
                	</logic:notPresent>
              	</td>    
              	<td align="right">
					<logic:notPresent name="HideBar">
                		<input class ="btn" id="btnPostNewTalk" onclick="window.location='PreColloquiumEntry.do'" value="Post New Talk" type="button">
                	</logic:notPresent>
				</td>													
			</tr>

<% 
	String affiliate_id = null;
	String affiliate = "";
	ArrayList<String> relationList = new ArrayList<String>();
	HashMap<String,String> aList = new HashMap<String,String>();
	String childrenList = null;
	Object hideBar = session.getAttribute("HideBar");
	if(request.getParameter("affiliate_id") != null && hideBar == null){
		affiliate_id = request.getParameter("affiliate_id");
		String sql = "SELECT affiliate FROM affiliate WHERE affiliate_id = " + affiliate_id;
		rs = conn.getResultSet(sql);
		if(rs.next()){
			affiliate = rs.getString("affiliate");
%>
<%-- 
			<tr>
				<td align="left" colspan="3">
					<span style="color:#0080ff;cursor:pointer;font-size: 1.5em;" 
						onclick="window.location='index.do?affiliate_id=<%=affiliate_id%>'"><%=affiliate%>
					</span>
				</td>
			</tr>
--%>
<%	
			sql = "SELECT r.path FROM relation r WHERE r.child_id = " + affiliate_id;
			ResultSet rsSponsor = conn.getResultSet(sql);
			while(rsSponsor.next()){
				String relation = rsSponsor.getString("path");
				relationList.add(relation);
				String[] path = relation.split(",");
				for(int i=0;i<path.length;i++){
					aList.put(path[i],null);
				}
				
			}
			String affList = null;
			for(Iterator<String> i=aList.keySet().iterator();i.hasNext();){
				if(affList ==null){
					affList = "";
				}else{
					affList +=",";
				}
				affList +=i.next();
			}
			
			sql = "SELECT r.child_id FROM relation r JOIN affiliate a ON r.child_id = a.affiliate_id WHERE r.parent_id=" + affiliate_id + " ORDER BY a.affiliate";
			rsSponsor = conn.getResultSet(sql);
			while(rsSponsor.next()){
				String child_id = rsSponsor.getString("child_id");
				if(childrenList==null){
					childrenList = "";
				}else{
					childrenList += ",";
				}
				childrenList+=child_id;
				if(affList ==null){
					affList = "";
				}else{
					affList +=",";
				}
				affList +=child_id;
				
			}
			sql = "SELECT affiliate_id,affiliate FROM affiliate WHERE affiliate_id IN ("+affList+")";
			rsSponsor = conn.getResultSet(sql);
			while(rsSponsor.next()){
				aList.put(rsSponsor.getString("affiliate_id"),rsSponsor.getString("affiliate"));
			}
			rsSponsor.close();
			
			/*if(relationList.size()>0){

				for(int ii=0;ii<relationList.size();ii++){
					String[] parents = relationList.get(ii).split(",");
%>
				<tr>
					<td align="left" colspan="3">
<% 
					String aParent = "";
					if(parents.length > 1){
						for(int j=parents.length-2;j>-1;j--){
%>				
							<span onclick="window.location='index.do?affiliate_id=<%=parents[j]%>'" 
							style="color:#0080ff;cursor:pointer;font-size: 0.9em;">
								<%=aList.get(parents[j])%>
							</span>
<% 
							if(j>0)out.print(" , ");
						}
					}
					if(ii!=relationList.size()-1)out.print("<br/> and ");
%>				
					</td>
				</tr>
<%	
				}
			}*/
		}
		rs.close();
	}
%>
		</table>
<logic:notPresent name="HideBar">
<%
	CommunityBean cb = new CommunityBean();
	cb.setCommID(0);
	cb.setName("default");
	session.setAttribute("CommunitySession", cb);

	String menu = "home";	
	if(session.getAttribute("menu") != null){
		menu = (String)session.getAttribute("menu");
	}
%>
	<table align="center" width="100%" style="padding:2px; font-family: verdana,arial; font-size: 0.85em;border-bottom: 2px solid #003399;">
		<tr>
		<%
			String colsize = "25%";
			if(ub != null){
				colsize = "20%";
			}			
			if(menu.equalsIgnoreCase("home")){
		%>
			<td align="center" width="<%=colsize%>" bgcolor="#003399" >
				<div style="color:#fff;cursor:pointer;" onclick="window.location='index.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'"><b>Home</b></div>
		<%		
			}else{
		%>
			<td align="center" width="<%=colsize%>" style = "border:1px solid #003399;">
				<div style="color:#003399;cursor:pointer;" onclick="window.location='index.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'">Home</div>
		<%	
			}
		%>
			</td>
			<logic:present name="UserSession">
			<%

				if(menu.equalsIgnoreCase("myaccount")){
			%>
				<td align="center" width="20%" bgcolor="#003399">
					<div style="color:#fff;cursor:pointer;" onclick="window.location='profile.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'"><b>My Account</b></div>
			<%		
				}else{
			%>
				<td align="center" width="20%" style = "border:1px solid #003399;">
					<div style="color:#003399;cursor:pointer;" onclick="window.location='profile.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'">My Account</div>
			<%	
				}
			%>	
				</td>
			</logic:present>
		<% 
			if(menu.equalsIgnoreCase("series")){
		%>
			<td align="center" width="<%=colsize%>" bgcolor="#003399">
				<div style="color:#fff;cursor:pointer;" onclick="window.location='series.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'"><b>Series</b></div>
		<%	
			}else{
		%>
			<td align="center" width="<%=colsize%>" style = "border:1px solid #003399;">
				<div style="color:#003399;cursor:pointer;" onclick="window.location='series.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'">Series</div>
		<%	
			}
		%>	
			</td>
		<%
			if(menu.equalsIgnoreCase("calendar")){
		%>
			<td align="center" width="<%=colsize%>" bgcolor="#003399">
				<div style="color:#fff;cursor:pointer;" onclick="window.location='calendar.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'"><b>Calendar</b></div>
		<%		
			}else{
		%>
			<td align="center" width="<%=colsize%>" style = "border:1px solid #003399;">
				<div style="color:#003399;cursor:pointer;" onclick="window.location='calendar.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'">Calendar</div>
		<%	
			}
		%>	
			</td>
		<% 
			if(menu.equalsIgnoreCase("community")){
		%>
			<td align="center" width="<%=colsize%>" bgcolor="#003399">
				<div style="color:#ffffff;cursor:pointer;" onclick="window.location='community.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'"><b>Groups</b></div>
		<% 	
			}else{
		%>
			<td align="center" width="<%=colsize%>" style = "border:1px solid #003399;">
				<div style="color:#003399;cursor:pointer;" onclick="window.location='community.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'">Groups</div>
		<% 	
			}
		%>	
			</td>
<%-- 
		<%
			if(menu.equalsIgnoreCase("tag")){
		%>
			<td align="center" width="<%=colsize%>" bgcolor="#003399">
				<div style="color:#ffffff;cursor:pointer;" onclick="window.location='tag.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'"><b>Tags</b></div>
		<%		
			}else{
		%>
			<td align="center" width="<%=colsize%>" style = "border:1px solid #003399;">
				<div style="color:#003399;cursor:pointer;" onclick="window.location='tag.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'">Tags</div>
		<%	
			}
		%>	
			</td>
		<% 
			if(menu.equalsIgnoreCase("entity")){
		%>
			<td align="center" width="<%=colsize%>" bgcolor="#003399">
				<div style="color:#ffffff;cursor:pointer;" onclick="window.location='entity.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'"><b>Entities</b></div>
		<%	
			}else{
		%>
			<td align="center" width="<%=colsize%>" style = "border:1px solid #003399;">
				<div style="color:#003399;cursor:pointer;" onclick="window.location='entity.do<%if(affiliate_id!=null)out.print("?affiliate_id=" + affiliate_id);%>'">Entities</div>
		<%	
			}
		%>	
			</td>
--%>
		</tr>
	</table>

	<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
<% 
	if(affiliate_id!=null){
%>
		<tr>
			<td colspan="3" style="font-size: 0.9em;font-weight: bold;">
<% 
		for(int i=0;i<relationList.size();i++){
			String[] aff_id  = relationList.get(i).split(",");
			for(int j=0;j<aff_id.length;j++){
				String id = aff_id[j];
				String aff = (String)aList.get(id);
%>
				<span style="cursor:pointer;" 
					onclick="window.location='index.do?affiliate_id=<%=id%>'"><%=aff%>
					</span> 
<%			
				if(j!=aff_id.length-1)out.print(" > ");	
			}
			if(i!=relationList.size()-1)out.print("<br/>");
		}
%>			
			</td>
		</tr>
<% 
		if(childrenList!=null){
%>
		<tr>
			<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td colspan="3" bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
				Affiliations
			</td>
		</tr>
		<tr>
			<td colspan="3" style="font-size: 0.9em;font-weight: bold;">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
<% 
		int column = -1;
		String[] child_id = childrenList.split(",");
		for(int i=0;i<child_id.length;i++){
			String id = child_id[i];
			String aff = (String)aList.get(id);
			column = i%3;
			if(column == 0){
%>
					<tr>
<%			
			}
%>
						<td>
							<span style="cursor:pointer;font-size: 0.9em;font-weight: bold;" 
								onclick="window.location='index.do?affiliate_id=<%=id%>'"><%=aff%></span>
<% 
			Calendar calendar = new GregorianCalendar();
			int month = calendar.get(Calendar.MONTH);
			int year = calendar.get(Calendar.YEAR);
			int req_day = -1;
			int req_week = -1;
			int req_month = month+1;
			int req_year = year;
			boolean req_posted = false;//True means user posts' talks
			boolean req_impact = false;//True means user impact
			boolean req_most_recent = false;

			String[] user_id_value = request.getParameterValues("user_id");
			String[] tag_id_value = request.getParameterValues("tag_id");
			String[] entity_id_value = request.getParameterValues("entity_id");
			String[] type_value = request.getParameterValues("_type");
			String[] series_id_value = request.getParameterValues("series_id");
			String[] comm_id_value = request.getParameterValues("comm_id");
			String[] affiliate_id_value = request.getParameterValues("affiliate_id");
		    if(request.getParameter("day")!=null){
		        req_day = Integer.parseInt(request.getParameter("day"));
		        //out.println("d:" + req_day);
		    }
		    
		    if(request.getParameter("week")!=null){
		        req_week = Integer.parseInt(request.getParameter("week"));
		        //out.println("w:" + req_week);
		    }
		    
		    if(request.getParameter("month")!=null){
		        req_month = Integer.parseInt(request.getParameter("month"));
		        //out.println("m:" + req_month);
		    }
		    
		    if(request.getParameter("year")!=null){
		        req_year = Integer.parseInt(request.getParameter("year"));
		    }else{
		    	req_week = calendar.get(Calendar.WEEK_OF_MONTH);
		    }
		    if(request.getParameter("post")!=null){
		    	req_posted = true;
		    }
		    if(request.getParameter("impact")!=null){
		    	req_impact = true;
		    }
		    if(request.getParameter("mostrecent")!=null){
		    	req_most_recent = true;
			    req_week = calendar.get(Calendar.WEEK_OF_MONTH);
		    }

		    if(menu != null){
				if(menu.equalsIgnoreCase("home")){
					req_most_recent = true;
				    req_week = calendar.get(Calendar.WEEK_OF_MONTH);
				}
			}
			
		    Calendar setcal = new GregorianCalendar();
		    setcal.set(req_year, req_month-1, 1);
		    int startday = setcal.get(Calendar.DAY_OF_WEEK) - 1;
		    int stopday = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);

		    String strBeginDate = "";
			String strEndDate = "";
			
			/*****************************************************************/
			/* Day View                                                      */
			/*****************************************************************/
			if(req_day > 0){
				strBeginDate = req_year + "-" + req_month + "-" + req_day;
				strEndDate = req_year + "-" + req_month + "-" + req_day;
			}else{
			    if(req_month == 1){
			    	setcal.set(req_year-1, 11, 1);
			    }else{
			    	setcal.set(req_year, req_month-2, 1);
			    }  
			    int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
			/*****************************************************************/
			/* Week View                                                     */
			/*****************************************************************/
				if(req_week > 0){
					if(startday == 0){
						strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week-1) + 1);
					}else{
						if(req_week == 1){
							strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
							String tmpBeginDate = "";
							if(req_month==1){
								strBeginDate = (req_year-1) + "-12-" + (daysPrevMonth - startday + 1);
							}else{

							}
						}else{
							strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week - 1) - startday + 1);
						}
					}
					if(7*req_week - startday <= stopday ){
						strEndDate = req_year + "-" + req_month + "-" + (7*req_week - startday);
						if(req_week == 1){
						}else{
						}
					}else{
						if(req_month == 12){
							strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
						}else{
							strEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
						}
					}
					if(req_most_recent){
					    int today = calendar.get(Calendar.DAY_OF_MONTH);
						strBeginDate = req_year + "-" + req_month + "-" + today;	
					}
				}else{
			/*****************************************************************/
			/* Month View                                                    */
			/*****************************************************************/
					if(startday == 0){
						strBeginDate = req_year + "-" + req_month + "-1";
					}else{
						if(req_month == 1){
							strBeginDate = (req_year-1) + "-12-" + (31 - startday + 1);
						}else{
							strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
							if(req_month == 12){
							}else{
							}
						}
					}
					if((startday + stopday)%7 == 0){
						strEndDate = req_year + "-" + req_month + "-" + (stopday);
					}else{
						if(req_month == 12){
							strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
						}else{
							strEndDate = (req_year) + "-" + (req_month + 1) + "-" +(7 - ((startday + stopday)%7));
						}
					}
				}
			}

			String sql = "SELECT COUNT(*) _no FROM affiliate_col ac JOIN colloquium c ON ac.col_id = c.col_id " +
							"WHERE ac.affiliate_id = " + id +
							" AND c._date >= '" + strBeginDate + " 00:00:00' AND c._date <= '" + strEndDate + " 23:59:59'";
			rs = conn.getResultSet(sql);
			if(rs.next()){
				int no = rs.getInt("_no");
%>
							<span style="color:#0080ff;font-size: 0.85em;">
<%
				if(no > 1){
%>
						&nbsp;(<%=no%> talks)
<%						
				}else if(no==1){
%>
						&nbsp;(<%=no%> talk)
<%						
				}
%>
							</span>
<%
			}
			rs.close();
%>
						</td> 
<%			
			if(column == 2){
%>
					</tr>
<%			
			}
		}
		if(column > -1){
			if(column < 2){
%>
					<tr>
						<td>&nbsp;</td>
					</tr>
<%			
			}else if(column < 1){
%>
					<tr>
						<td>&nbsp;</td>
					</tr>
<%			
			}
		}
%>			
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
<%	
		}
%>			
<%	
	}
	conn.conn.close();
	conn = null;
	
%>
	</table>

</logic:notPresent>		
 <script type="text/javascript">
  var rpxJsHost = (("https:" == document.location.protocol) ? "https://" : "http://static.");
  document.write(unescape("%3Cscript src='" + rpxJsHost +
"rpxnow.com/js/lib/rpx.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
  RPXNOW.overlay = true;
  RPXNOW.language_preference = 'en';
</script>
</body>
</html>