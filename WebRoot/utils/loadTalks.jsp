<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.BufferedReader"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<% 
	final String[] months = {"January","February","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	String insertFirst = (String)request.getParameter("insertfirst");
	String appendLast = (String)request.getParameter("appendlast");
	int num = 0;
%>
<style>
	img.speakerImg {
	    display: block;
	    margin-left: auto;
	    margin-right: auto;
	}

</style>
<script type="text/javascript">

<!--
window.onload = function(){
<%
	if(insertFirst!=null){
%>	
	if(typeof divTalkContent != "undefined"){
		if(parent.insertTalks){
			parent.insertTalks(divTalkContent.innerHTML	);
		}
	}
<% 
	}else if(appendLast!=null){
%>	
	if(typeof divTalkContent != "undefined"){
		if(parent.appendTalks){
			parent.appendTalks(divTalkContent.innerHTML);
		}
	}
<% 
	}else{
%>	
	if(typeof divTalkContent != "undefined"){
		if(parent.displayTalks){
			parent.displayTalks(divTalkContent.innerHTML);
		}
	}
<% 
	}
%>
}

//-->
/*
function   DrawImage(ImgD, iwidth, iheight){ 
      var image = new Image();     
      image.src = ImgD.src; 
      if(image.width > 0  &&  image.height> 0){ 
        if(image.width/image.height >= iwidth/iheight){    
          	 ImgD.width=iwidth; 
          	 ImgD.height=image.height*iwidth/image.width;  
          	 ImgD.alt=image.width+ "� "+image.height; 
        } 
       else{ 
          	ImgD.height=iheight; 
          	ImgD.width=image.width*iheight/image.height;           
          	ImgD.alt=image.width+ "� "+image.height; 
       } 
     }
} 

function addQuickBookmark(col_id){
	
	var src = "utils/bookmarkPage.jsp?col_id=" + col_id;
	$.modal('<iframe src="' + src + '" height="450" width="830" style="border:0" >', {
		
		containerCss:{
			backgroundColor:"#fff",
			borderColor:"#000",
			height:450,
			padding:0,
			width:830
		},
		overlayClose:true
		
	});

	
}

function closeWindow(){
	if(period){
		var action = "utils/loadTalks.jsp";
		if(period == 0){//Day
			action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		}else if(period == 1){//Week
			action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
		}else{
			action = action.concat('?month=',_month,'&year=',_year);
		}
		if(queryString){
			action = action.concat('&',queryString);
		}
		alert(action);
		loadTalks(action);
		
	}else{
		window.parent.location.reload();
	}
	$.modal.close();
}
*/
</script>

<div id="divTalkContent">
<% 

	connectDB conn = new connectDB();
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
    Calendar calendar = new GregorianCalendar();
    int month = calendar.get(Calendar.MONTH);
    int year = calendar.get(Calendar.YEAR);
    int this_year = year;
    int req_day = -1;
    int req_week = -1;
    int req_month = month+1;
    int req_year = year;
    boolean isdebug = false;
	boolean req_specific_date = false;
    boolean req_posted = false;//True means user posts' talks
	boolean req_impact = false;//True means user impact
	boolean req_most_recent = false;
	boolean searchResult = false;
	String[] user_id_value = request.getParameterValues("user_id");
	String[] tag_id_value = request.getParameterValues("tag_id");
	String[] entity_id_value = request.getParameterValues("entity_id");
	String[] type_value = request.getParameterValues("_type");
	String[] series_id_value = request.getParameterValues("series_id");
	String[] comm_id_value = request.getParameterValues("comm_id");
	String[] affiliate_id_value = request.getParameterValues("affiliate_id");
    if(request.getParameter("day")!=null){
        req_day = Integer.parseInt(request.getParameter("day"));
        req_specific_date = true;
        //out.println("d:" + req_day);
    }
    
    if(request.getParameter("week")!=null){
        req_week = Integer.parseInt(request.getParameter("week"));
        req_specific_date = true;
        //out.println("w:" + req_week);
    }
    
    if(request.getParameter("month")!=null){
        req_month = Integer.parseInt(request.getParameter("month"));
        req_specific_date = true;
        //out.println("m:" + req_month);
    }
    
    if(request.getParameter("year")!=null){
        req_year = Integer.parseInt(request.getParameter("year"));
        req_specific_date = true;
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
        req_specific_date = true;
    }
    if(request.getParameter("isdebug")!=null){
    	isdebug = true;
    }
    if(request.getParameter("searchResult") != null){
    	searchResult = true;
    }
    
	String menu = (String)session.getAttribute("menu");
	if(menu.equalsIgnoreCase("myaccount")){
		String uid = String.valueOf(ub.getUserID());
		if(user_id_value == null){
			String temp[] = new String[1];
			temp[0] = uid;
			user_id_value = temp;
		}else{
			String temp[] = new String[user_id_value.length+1];
			System.arraycopy(user_id_value,0,temp,0,user_id_value.length);
			temp[user_id_value.length] = uid;
			user_id_value = temp;
		}
	}else if(menu.equalsIgnoreCase("series")||menu.equalsIgnoreCase("community")){
		req_specific_date = true;
		if(appendLast==null){
			req_day = calendar.get(Calendar.DAY_OF_MONTH);
			req_month = month+1;
			req_year = year;
		}
	}
	
    Calendar setcal = new GregorianCalendar();
    setcal.set(req_year, req_month-1, 1);
    int startday = setcal.get(Calendar.DAY_OF_WEEK) - 1;
    int stopday = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
    
	String strBeginDate = "";
	String strEndDate = "";
	
	String strDisplayDateRange = "";
	/*****************************************************************/
	/* Day View                                                      */
	/*****************************************************************/
	if(req_day > 0){
		strBeginDate = req_year + "-" + req_month + "-" + req_day;
		strEndDate = req_year + "-" + req_month + "-" + req_day;
		
		strDisplayDateRange = "Date: " + months[req_month-1] + " " + req_day + ", " + req_year; 
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
			strDisplayDateRange = "Week " + req_week + " of " + months[req_month-1] + ": ";
			if(startday == 0){
				strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week-1) + 1);
				strDisplayDateRange += " " + (7*(req_week-1) + 1);
			}else{
				if(req_week == 1){
					strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
					String tmpBeginDate = "";
					if(req_month==1){
						strBeginDate = (req_year-1) + "-12-" + (daysPrevMonth - startday + 1);
						strDisplayDateRange += months[11] + " " + (daysPrevMonth - startday + 1) + ", " + (req_year-1);
					}else{
						strDisplayDateRange += months[req_month-2] + " " + (daysPrevMonth - startday + 1);
					}
				}else{
					strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week - 1) - startday + 1);
					strDisplayDateRange += months[req_month-1] + " " + (7*(req_week - 1) - startday + 1);
				}
			}
			if(7*req_week - startday <= stopday ){
				strEndDate = req_year + "-" + req_month + "-" + (7*req_week - startday);
				if(req_week == 1){
					strDisplayDateRange += " - " + months[req_month-1] + " " + (7*req_week - startday) + ", " + req_year;
				}else{
					strDisplayDateRange += " - " + (7*req_week - startday) + ", " + req_year;
				}
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
					strDisplayDateRange += " - " + months[0] + " " + (7 - ((startday + stopday)%7)) + ", " + (req_year+1);
				}else{
					strEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
					strDisplayDateRange += " - " + months[req_month] + " " + (7 - ((startday + stopday)%7)) + ", " + (req_year);
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
				strDisplayDateRange = "Month: " + months[req_month-1] + " " + req_year + ": 1";
			}else{
				if(req_month == 1){
					strBeginDate = (req_year-1) + "-12-" + (31 - startday + 1);
					strDisplayDateRange = "Month: " + months[req_month-1] + " " + req_year + ": " + months[11] + " " + (31 - startday + 1) + ", " + (req_year-1);
				}else{
					strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
					if(req_month == 12){
						strDisplayDateRange = "Month: " + months[req_month-1] + " " + req_year + ": " + months[req_month-2] + " " + (daysPrevMonth - startday + 1) + ", " + req_year;
					}else{
						strDisplayDateRange = "Month: " + months[req_month-1] + " " + req_year + ": " + months[req_month-2] + " " + (daysPrevMonth - startday + 1);						
					}
				}
			}
			if((startday + stopday)%7 == 0){
				strEndDate = req_year + "-" + req_month + "-" + (stopday);
				strDisplayDateRange += " - " + months[req_month-1] + " " + (stopday) + ", " + req_year;
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
					strDisplayDateRange += " - " + months[0] + " " + (7 - ((startday + stopday)%7)) + ", " + (req_year+1);
				}else{
					strEndDate = (req_year) + "-" + (req_month + 1) + "-" +(7 - ((startday + stopday)%7));
					strDisplayDateRange += " - " + months[req_month] + " " + (7 - ((startday + stopday)%7)) + ", " + req_year;
				}
			}
		}
    }

//=================================================================
// Recommendation Part
//=================================================================
	HashSet<Integer> recSet = null;
	if(ub != null){
		recSet = new HashSet<Integer>();
	    setcal.set(req_year, req_month-1, 1);
		String strRecBeginDate = "";
		String strRecEndDate = "";
		/*****************************************************************/
		/* Day or Week View                                                      */
		/*****************************************************************/
		if(req_day > 0 || req_week > 0){
			int week_no = setcal.get(Calendar.WEEK_OF_MONTH);
			if(req_week > 0){
				week_no = req_week;
			}
			//Calcuate begin date first
			if(startday == 0){//Is Sunday?
				strRecBeginDate = req_year + "-" + req_month + "-" + (7*(week_no-1) + 1);
			}else{//Not Sunday
				if(week_no == 1){//Is the first week of month?
					if(req_month == 1){//January?
				    	setcal.set(req_year-1, 11, 1);
				    }else{
				    	setcal.set(req_year, req_month-2, 1);
				    }  
				    int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);				
					int rec_prev_month = req_month-1;
					int rec_year = req_year;
					if(rec_prev_month == 0){
						rec_prev_month = 12;
						rec_year = req_year - 1;
					}
					strRecBeginDate = rec_year + "-" + (rec_prev_month) + "-" + (daysPrevMonth - startday + 1);		
				}else{//Not the first week
					strRecBeginDate = req_year + "-" + req_month + "-" + (7*(week_no - 1) - startday + 1);
				}
			}
			
			//Calculate end date second
			if(7*week_no - startday <= stopday ){
				strRecEndDate = req_year + "-" + req_month + "-" + (7*week_no - startday);			
			}else{
				if(req_month == 12){
					strRecEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
				}else{
					strRecEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
				}
			}
			
			//Fetch user recommendation
			String sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
							"JOIN userinfo u ON ru.user_id = u.user_id " +
							"WHERE ru.weight >= u.min_score AND ru.user_id=" + ub.getUserID() + 
							" AND c._date >='" + strRecBeginDate + "' " +
							"AND c._date <='" + strRecEndDate + "' " +
							"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
							"AND c.col_id NOT IN (SELECT col_id FROM lastuserfeedback where user_id=" + ub.getUserID() + 
							" AND rating <= (SELECT averageUserfeedback FROM averageuserratings WHERE user_id=" +ub.getUserID() + ")) " +
							"ORDER BY ru.weight DESC LIMIT 5";
			ResultSet rs = conn.getResultSet(sql);
			//out.println(sql);
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				recSet.add(col_id);
			}		
		}else{
	    /*****************************************************************/
	    /* Month View                                                    */
	    /*****************************************************************/
	    	for(int i=0;i<6;i++){//No more than 6 weeks a month

				int week_no = i;
				
				//Calculate begin date first
				if(startday == 0){//Is Sunday?
					strRecBeginDate = req_year + "-" + req_month + "-" + (7*(week_no-1) + 1);
				}else{//Not Sunday
					if(week_no == 1){//Is the first week of month?
						if(req_month == 1){//January?
					    	setcal.set(req_year-1, 11, 1);
					    }else{
					    	setcal.set(req_year, req_month-2, 1);
					    }  
					    int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);				
						int rec_prev_month = req_month-1;
						int rec_year = req_year;
						if(rec_prev_month == 0){
							rec_prev_month = 12;
							rec_year = req_year - 1;
						}
						strRecBeginDate = rec_year + "-" + (rec_prev_month) + "-" + (daysPrevMonth - startday + 1);		
					}else{//Not the first week
						strRecBeginDate = req_year + "-" + req_month + "-" + (7*(week_no - 1) - startday + 1);
					}
				}
				
				//Get out of the for loop if begin date is beyond that month
				if((7*(week_no - 1) - startday + 1) > stopday){
					break;
				}
				
				//Then calculate the end date
				if(7*week_no - startday <= stopday ){
					strRecEndDate = req_year + "-" + req_month + "-" + (7*week_no - startday);			
				}else{
					if(req_month == 12){
						strRecEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
					}else{
						strRecEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
					}
				}

				String sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
								"JOIN userinfo u ON ru.user_id = u.user_id " +
								"WHERE ru.weight >= u.min_score AND ru.user_id=" + ub.getUserID() + 
								" AND c._date >='" + strRecBeginDate + "' " +
								"AND c._date <='" + strRecEndDate + "' " +
								"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
								"AND c.col_id NOT IN (SELECT col_id FROM lastuserfeedback where user_id=" + ub.getUserID() + 
								" AND rating <= (SELECT averageUserfeedback FROM averageuserratings WHERE user_id=" + ub.getUserID() + ")) " +
								"ORDER BY ru.weight DESC LIMIT 5";
				ResultSet rs = conn.getResultSet(sql);
				//out.println(sql);
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					recSet.add(col_id);
				}		

	    	}

	    }
	}
//=================================================================
// ~ Recommendation Part
//=================================================================

	//Search Result Part
	ArrayList<Long> searchList = new ArrayList<Long>();
	if(searchResult){
		searchList = (ArrayList<Long>)session.getAttribute("searchResultList");
	}

	String sql = "SELECT date_format(c._date,_utf8'%W, %b %d') AS `day`, c.col_id, c.title, " +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"s.name,c.location,h.host_id,h.host,c.owner_id,u.name owner,lc.abbr,c.video_url,s.affiliation, " +
					"date_format(c._date,_utf8'%Y') _year,c.slide_url, s.picURL " +
					"FROM colloquium c JOIN speaker s ON c.speaker_id = s.speaker_id " +
					"JOIN userinfo u ON c.owner_id = u.user_id ";// +
					//"LEFT JOIN host h ON c.host_id = h.host_id " +
					//"LEFT JOIN loc_col lc ON c.col_id = lc.col_id ";// +
					//"WHERE TRUE ";// +
					//"c._date >= (SELECT beginterm FROM sys_config) " +
					//"AND c._date <= (SELECT endterm FROM sys_config) ";
	if(req_posted){
		sql = "SELECT date_format(pt.posttime,_utf8'%W, %b %d') AS `day`, c.col_id, c.title, " +
				"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
				"s.name,c.location,h.host_id,h.host,c.owner_id,u.name owner,lc.abbr,c.video_url,s.affiliation, " +
				"date_format(c._date,_utf8'%Y') _year,c.slide_url, s.picURL " +
				"FROM colloquium c JOIN speaker s ON c.speaker_id = s.speaker_id " +
				"JOIN userinfo u ON c.owner_id = u.user_id " +
				"JOIN " +
				"(SELECT col_id,MIN(lastupdate) posttime FROM " +
				" (SELECT col_id,MIN(lastupdate) lastupdate FROM col_bk GROUP BY col_id " +
				" UNION " +
				" SELECT col_id,lastupdate FROM colloquium) tpost " +
				"GROUP BY col_id) pt ON c.col_id = pt.col_id ";// +
				//"LEFT JOIN host h ON c.host_id = h.host_id " +
				//"LEFT JOIN loc_col lc ON c.col_id = lc.col_id ";// +
				//"WHERE TRUE ";
	}
		
	if(user_id_value !=null){//User Mode
		for(int i=0;i<user_id_value.length;i++){
			if(req_posted){
				sql += "JOIN colloquium cc" + i + " ON c.col_id=cc" + i + ".col_id AND cc"+ i + ".owner_id = " + user_id_value[i] + " ";
			}else{
				sql += "JOIN userprofile up" + i + " ON c.col_id=up" + i + ".col_id AND up" + i + ".user_id = " + user_id_value[i] + " ";
			}
		}
	}
	if(comm_id_value != null){//Community Mode
		for(int i=0;i<comm_id_value.length;i++){
			sql += "JOIN userprofile upc" + i + " ON c.col_id=upc" + i + ".col_id " +
					"JOIN contribute ct" + i + " ON upc" + i + ".userprofile_id = ct" + i + ".userprofile_id " + 
					"AND ct" + i + ".comm_id = " + comm_id_value[i] + " ";
		}
		//sql += "AND c._date >= (SELECT beginterm FROM sys_config) AND c._date < (SELECT endterm FROM sys_config) ";
	}
	if(tag_id_value != null){//Tag Mode
		for(int i=0;i<tag_id_value.length;i++){
			sql += "JOIN userprofile upt" + i + " ON c.col_id=upt" + i + ".col_id " +
					"JOIN tags tt" + i + " ON upt" + i + ".userprofile_id = tt" + i + ".userprofile_id " + 
					"AND tt" + i + ".tag_id = " + tag_id_value[i] + " ";
		}
	}
	if(series_id_value != null){//Series Mode
		for(int i=0;i<series_id_value.length;i++){
			sql += "JOIN seriescol sc" + i + " ON c.col_id = sc" + i + ".col_id AND sc" + i + ".series_id=" + series_id_value[i] + " ";
		}
		//sql += "AND c._date >= (SELECT beginterm FROM sys_config) AND c._date < (SELECT endterm FROM sys_config) ";
	}
	if(entity_id_value != null){//Entity Mode
		for(int i=0;i<entity_id_value.length;i++){
			sql += "JOIN entities ee" + i + " ON c.col_id = ee" + i + ".col_id AND ee" + i + ".entity_id = " + entity_id_value[i] + " ";
		}
	}
	if(type_value != null){//Entity Type Mode
		for(int i=0;i<type_value.length;i++){
			sql += "JOIN entities eee" + i + " ON c.col_id = eee" + i + ".col_id JOIN entity e" + i + " ON " +
			"e" + i + ".entity_id = eee" + i + ".entity_id AND e" + i + "._type = '" + type_value[i] + "' ";
		}
	}
	sql += "LEFT JOIN host h ON c.host_id = h.host_id " +
			"LEFT JOIN loc_col lc ON c.col_id = lc.col_id " +
			"WHERE TRUE ";
	if(affiliate_id_value !=null ){
		for(int i=0;i<affiliate_id_value.length;i++){
			sql += "AND c.col_id IN " +
					"(SELECT ac.col_id FROM affiliate_col ac JOIN " +
					"(SELECT child_id FROM relation WHERE " +
					"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ affiliate_id_value[i] + "),',%')) cc " +
					"ON ac.affiliate_id = cc.child_id " +
					"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id_value[i] + ") ";
		}
	}
	if(searchResult){
		sql += " AND c.col_id IN (";
		for (long a: searchList){
		 	sql += "'" + a + "',";
		}
		sql = sql.substring(0, sql.length()-1);
		sql += ")";
	}
	int olderTalkNo = 0;
	if(menu.equalsIgnoreCase("calendar")||menu.equalsIgnoreCase("myaccount")||req_most_recent||req_specific_date){
		if(req_posted){
			sql += "AND pt.posttime >= '" + strBeginDate + " 00:00:00' " +
			"AND pt.posttime <= '" + strEndDate + " 23:59:59' ";
		}else{
			if(menu.equalsIgnoreCase("series")||menu.equalsIgnoreCase("community")){
				if(insertFirst==null){
					sql += "AND c._date >='" + strBeginDate + " 00:00:00' ";
					
					//Count # earlier talks
					String _sql = "SELECT COUNT(*) _no FROM colloquium c ";
					if(series_id_value != null){//Series Mode
						for(int i=0;i<series_id_value.length;i++){
							_sql += "JOIN seriescol sc" + i + " ON c.col_id = sc" + i + ".col_id AND sc" + i + ".series_id=" + series_id_value[i] + " ";
						}
					}
					if(comm_id_value != null){//Community Mode
						for(int i=0;i<comm_id_value.length;i++){
							_sql += "JOIN userprofile upc" + i + " ON c.col_id=upc" + i + ".col_id " +
									"JOIN contribute ct" + i + " ON upc" + i + ".userprofile_id = ct" + i + ".userprofile_id " + 
									"AND ct" + i + ".comm_id = " + comm_id_value[i] + " ";
						}
					}
					_sql += "AND c._date < '" + strBeginDate + " 00:00:00' ";
					ResultSet rs = conn.getResultSet(_sql);
					if(rs.next()){
						olderTalkNo = rs.getInt("_no");
						if(olderTalkNo > 0){
%>
	<br/>
	<div id="divOlderTalks" align="center">
		<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
			<tr>
				<td bgcolor="#efefef" style="font-size: 0.25em;">&nbsp;</td>
			</tr>
			<tr>
				<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
					&nbsp;
					<input class="btn" type="button" 
						onclick="this.value='Loading...';this.style.disabled='disabled';showOlderTalks();return false;" 
						value="Show <%=olderTalkNo %> Earlier Talk<%=(olderTalkNo>0?"s":"") %>" />
				</td>
			</tr>
			<tr>
				<td bgcolor="#efefef" style="font-size: 0.25em;">&nbsp;</td>
			</tr>
		</table>	
	</div>
<%							
						}
					}
				}else{
					sql += "AND c._date < '" + strBeginDate + " 00:00:00' ";
				}
			}else{
				sql += "AND c._date >= '" + strBeginDate + " 00:00:00' " +
				"AND c._date <= '" + strEndDate + " 23:59:59' ";
			}
		}
	}
	sql += "GROUP BY c.col_id ";
	if(searchResult){
		//No order
		sql += " ORDER BY FIELD(c.col_id, ";
		for (long a: searchList){
		 	sql += "'" + a + "',";
		}
		sql = sql.substring(0, sql.length()-1);
		sql += ")";

	}else{
		if(req_posted){
			sql += "ORDER BY pt.posttime;";
		}else{
			sql += "ORDER BY c._date,c.begintime;";
		}
	}
	
	String day = "";
	if(isdebug){
		out.println(sql);
	}
	ResultSet rs = conn.getResultSet(sql);
	boolean noTalks = true;
	
	if(menu.equalsIgnoreCase("myaccount")){
%>
	<form name="talkForm" method="post">
<%		
	}
%>
	<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
<%	
	if(!req_most_recent && tag_id_value==null && entity_id_value==null && series_id_value==null && comm_id_value==null && !searchResult){
%>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td><%=strDisplayDateRange%></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
<%		
	}
	int deli=0;
	while(rs.next()){
		num++;
		noTalks = false;
		String aDay = rs.getString("day");
		String _year = rs.getString("_year");
		if(this_year != Integer.parseInt(_year)){
			aDay += ", " + _year;
		}
		//String host = rs.getString("host");
		String owner_id = rs.getString("owner_id");
		String owner = rs.getString("owner");
		String pic_url = "images/speaker/avartar.gif";
		if (rs.getString("picURL") != null)
			pic_url = rs.getString("picURL");
		if(!day.equalsIgnoreCase(aDay)){
			if(!day.equalsIgnoreCase("")){
%>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
<%			
			}else if(menu.equalsIgnoreCase("myaccount")){
%>
		<tr>
			<td align="right">
				<input class="btn" type="button" value="Delete" onclick="deleteCols();" >
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
<%			}else if(menu.equalsIgnoreCase("series")||menu.equalsIgnoreCase("community")){
				if(insertFirst!=null&&day.equalsIgnoreCase("")){
%>
		<tr>
			<td>&nbsp;</td>
		</tr>
<%					
				}
			}		
			day = aDay;
%>
<%-- 
		<tr>
			<td>&nbsp;</td>
		</tr>
--%>
		<tr>
			<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
				<%=day%>
			</td>
		</tr>
		<tr>
			<td align="center" style="border: 1px #EFEFEF solid;">
				<table border="0" cellspacing="5" cellpadding="0" width="100%" align="center">
<%
		}
		//Show talk snap shot
		String col_id = rs.getString("col_id");
%>
					<tr>
<% 
		if(menu.equalsIgnoreCase("myaccount")){
%>
						<td align="left" valign="top" width="10">
							<input id="deleted<%=deli %>" name="deleted" type="checkbox" value="<%=col_id%>" />
						</td>
<% 
			deli++;
		}
		//How many emails
		int emailno = 0;
		/*sql = "SELECT emails FROM emailfriends WHERE col_id=" + col_id;
		ResultSet rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			HashSet<String> setEmails = new HashSet<String>();
			while(rsExt.next()){
				String emails = rsExt.getString("emails");
				String[] email = emails.split(",");
				if(email != null){
					for(int i=0;i<email.length;i++){
						String aEmail = email[i].trim().toLowerCase();
						setEmails.add(aEmail);
					}
				}
			}
			emailno = setEmails.size();
		}*/
		
		//How many views
		int viewno = 0;
		/*sql = "SELECT ipaddress,sessionid,COUNT(*) _no FROM talkview WHERE col_id=" + col_id + " GROUP BY ipaddress,sessionid";
		rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			while(rsExt.next()){
				String ipaddress = rsExt.getString("ipaddress");
				String sessionid = rsExt.getString("sessionid").trim().toLowerCase();
				if(ipaddress.trim().length()==0||sessionid.trim().length()==0){
					viewno += rsExt.getInt("_no");
				}else{
					viewno++;
				}
				
			}
		}*/
		
		//Bookmark by
		HashSet<Integer> bookSet = null; 
		if(ub != null){
			bookSet = new HashSet<Integer>();
		}
		String bookmarks = "";
		int bookmarkno = 0;
		sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u,userprofile up " +
				"WHERE u.user_id = up.user_id AND up.col_id = " + col_id +
				" GROUP BY u.user_id,u.name ORDER BY u.name";
		ResultSet rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			while(rsExt.next()){
				String user_name = rsExt.getString("name");
				long user_id = rsExt.getLong("user_id");
				//long _no = rsExt.getLong("_no");
				if(user_name.length() > 0){
					bookmarks += "&nbsp;<a href=\"calendar.do?user_id=" + user_id + "\">" + user_name + "</a>";
					bookmarkno++;				
				}
				if(ub != null){
					if(ub.getUserID()==user_id){
						bookSet.add(Integer.parseInt(col_id));
					}
				}
			}
		}
		
		sql = "SELECT viewno,emailno FROM col_impact WHERE col_id=" + col_id;
		rsExt = conn.getResultSet(sql);
		while(rsExt.next()){
			viewno = rsExt.getInt("viewno");
			emailno = rsExt.getInt("emailno");
		}
%>
						<td>
							<table align="center" width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size: 0.8em;">
								<tr>
									<td valign="top" width="9.5%">
<%
		String strBookmark = "", strEmail = "", strView = "";
		if(viewno > 0 || emailno > 0 || bookmarkno > 0){
%>
<%-- 
										<table width="100%" border="0" cellpadding="0" cellspacing="1">
--%>
<% 
			if(bookmarkno > 0){
				strBookmark = "<b>" + bookmarkno + "</b><br/><span style='font-size: 0.55em;'>bookmark";
				if(bookmarkno > 1){
					strBookmark += "s";
				}
				strBookmark += "</span>";
%>
<%-- 
											<tr>
												<td valign="top" align="center" 
													style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #228b22;color: #fff;">
													<%=strBookmark%>
												</td>
											</tr>
--%>
<%			
			}
			if(emailno > 0){
				strEmail = "<b>" + emailno + "</b><br/><span style='font-size: 0.55em;'>email";
				if(emailno > 1){
					strEmail += "s";
				}
				strEmail += "</span>";
%>
<%-- 
											<tr>
												<td valign="top" align="center" style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #eedd82;color: #fff;">
													<%=strEmail%>
												</td>
											</tr>
--%>
<%			
			}
			if(viewno > 0){
				strView = "<b>" + viewno + "</b><br/><span style='font-size: 0.55em;'>view";
				if(viewno > 1){
					strView += "s";
				}
				strView += "</span>";
%>
<%-- 
											<tr>
												<td valign="top" align="center" 
													style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #9370db;color: #fff;">
													<%=strView%>
												</td>
											</tr>
--%>
<%			
			}
%>											
<%-- 
										</table>
--%>
<%		
		}
%>
										<table width="100%" border="0" cellpadding="0" cellspacing="1">
											<tr>
												<td class="tdBookNoColID<%=col_id %>" valign="top" align="center" 
													style="display:<%=bookmarkno==0?"none":"inline" %>;padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #228b22;color: #fff;">
													<%=strBookmark%>
												</td>
											</tr>
											<tr>
												<td class="tdEmailNoColID<%=col_id %>" valign="top" align="center" 
													style="display:<%=emailno==0?"none":"inline" %>;padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #eedd82;color: #fff;">
													<%=strEmail%>
												</td>
											</tr>
											<tr>
												<td class="tdViewNoColID<%=col_id %>" valign="top" align="center" 
													style="display:<%=viewno==0?"none":"inline" %>;padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #9370db;color: #fff;">
													<%=strView%>
												</td>
											</tr>
										</table>
									</td>
									<td width="75.5%" valign="top">

							<b><a id="aTitleColID<%=col_id %>" href="presentColloquium.do?col_id=<%=col_id%>"><%=rs.getString("title")%></a></b>
<% 
		String video_url = rs.getString("video_url");
		if(video_url != null){
			if(video_url.length() > 7){
%>
							&nbsp;<a href="<%=video_url%>"><img alt="Video Link" src="images/video-icon.jpg" border="0" /></a>
<%				
			}
		}
		String slide_url = rs.getString("slide_url");
		if(slide_url != null){
			if(slide_url.length() > 7){
%>
							&nbsp;<a href="<%=slide_url%>"><img alt="Slide Link" src="images/Slide-Show-icon.jpg" border="0" /></a>
<%				
			}
		}
		boolean bookmarked = false;
%>
							<logic:present name="UserSession">
<%		
		if(recSet != null){
			if(recSet.contains(Integer.parseInt(col_id))){
%>
&nbsp;<span style="cursor: pointer;font-size: 1em;background-color: red;font-weight: bold;color: white;"
onclick="javascript:return false;">&nbsp;Recommended&nbsp;</span>
<%				
			}
		}
		if(bookSet != null){
			if(bookSet.contains(Integer.parseInt(col_id))){
				bookmarked = true;
%>
<%				
			}else{
%>
<%-- 
			<input type='image' onClick="addQuickBookmark(<%= col_id %>)" src="images/bookmark.jpeg" 
			width="20" height="20"  align = "right" />
--%>
<% 
			}
		}
%>
&nbsp;<span id="spanbookcolid<%=col_id %>" class="spanbookcolid<%=col_id %>" 
style="display:<%=bookmarked?"inline":"none" %>;cursor: pointer;font-size: 1em;background-color: green;font-weight: bold;color: white;"
onclick="window.location='myaccount.do'">&nbsp;Bookmarked&nbsp;</span>
<%-- 
&nbsp;
<a class="abookcolid<%=col_id %>" href="javascript:return false;" 					
	style="text-decoration: none;"
	onmouseover="this.style.textDecoration='underline'" 
	onmouseout="this.style.textDecoration='none'"
	onclick="bookmarkTalk(<%=ub.getUserID() %>, <%=col_id %>, this, 'spanbookcolid<%=col_id %>')"
><%=bookmarked?"Unbookmark":"Bookmark" %></a>
--%>
<%-- 
<input class="btn" type="button" value="<%=bookmarked?"Unbookmark":"Bookmark" %>"
					onclick="bookmarkTalk(<%=ub.getUserID() %>,<%=col_id %>,this,'spanbookcolid<%=col_id %>');" />
--%>
							</logic:present>
<%	
		
		String speaker = rs.getString("name");
		String affiliation = rs.getString("affiliation");
		if(!affiliation.equalsIgnoreCase("n/a")){
			if(affiliation.trim().length() > 2){
				speaker += ", " + affiliation;
			}
		}
%>							
							<br/>
							<span style="font-size: 0.75em;"><b>By:</b> <span id="spanSpeakerColID<%=col_id %>"><%=speaker%></span>&nbsp;
							<b>on:</b> <%=rs.getString("_begin")%> - <%=rs.getString("_end")%><br/>
<% 
		sql = "SELECT r.path FROM affiliate_col ac INNER JOIN relation r ON ac.affiliate_id = r.child_id WHERE ac.col_id = " + col_id;
		ResultSet rsSponsor = conn.getResultSet(sql);
		ArrayList<String> relationList = new ArrayList<String>();
		HashMap<String,String> aList = new HashMap<String,String>();
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
		sql = "SELECT affiliate_id,affiliate FROM affiliate WHERE affiliate_id IN ("+affList+")";
		rsSponsor = conn.getResultSet(sql);
		while(rsSponsor.next()){
			aList.put(rsSponsor.getString("affiliate_id"),rsSponsor.getString("affiliate"));
		}
		rsSponsor.close();
		if(relationList.size()>0){
%>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size: 1em;font-family: arial,Verdana,sans-serif,serif;">
								<tr>
									<td valign="top" width="8%" style="font-weight: bold;">Sponsor:</td>
									<td align="left" style="">
<% 
			for(int i=0;i<relationList.size();i++){
				String[] path = relationList.get(i).split(",");
				for(int j=0;j<path.length;j++){
%>
								<a href="index.do?affiliate_id=<%=path[j]%>"><%=(String)aList.get(path[j])%>
									</a>
<%					
						if(j!=path.length-1){
%>
								&nbsp;>&nbsp;
<%
						}
				}			
				if(i!=relationList.size()-1){
%>
								<br/>
<%
				}
			}
%>									
									</td>
								</tr>
							</table>
<%		
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
							<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size: 1em;font-family: arial,Verdana,sans-serif,serif;">
								<tr>
									<td style="font-weight: bold;" width="8%" align="left">Series:</td>
									<td>
										<a href="series.do?series_id=<%=series_id%>"><%=series_name%></a>
										<logic:present name="UserSession">
<% 
				int subno = 0;
				if(ub != null){
					sql = "SELECT COUNT(*) _no FROM final_subscribe_series WHERE series_id=" + series_id + " AND user_id=" + ub.getUserID();
					rsExt = conn.getResultSet(sql);
					if(rsExt.next()){
						subno = rsExt.getInt("_no");
					}
				}
%>
										&nbsp;
										<span class="spansubsid<%=series_id %>" id="spansubcid<%=col_id %>" 
											style="display: <%=subno==0?"none":"inline" %>;font-size: 0.9em;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
											onclick="window.location='series.do?series_id=<%=series_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
										</span>
										&nbsp;	
										<a class="asubsid<%=series_id %>" href="javascript:return false;" 					
											style="text-decoration: none;"
											onmouseover="this.style.textDecoration='underline'" 
											onmouseout="this.style.textDecoration='none'"
											onclick="subscribeSeries(<%=ub.getUserID() %>, <%=series_id %>, this, 'spansubcid<%=col_id %>')"
										><%=subno>0?"Unsubscribe":"Subscribe" %></a>
										</logic:present>	
									</td>
								</tr>
							</table>
<%				
			}
			rsSeries.close();
%>
							<b>Location:</b> <%=rs.getString("location")%>
<% 
		String abbr = rs.getString("abbr");
		if(abbr != null){
%>
					&nbsp;(<a href="http://gis.sis.pitt.edu/CampusLocator/searchBuilding?abbr=<%=abbr%>">map</a>)
<%			
		}
%>					
							<br/>
							<b>Posted By:</b> <a href="profile.do?user_id=<%=owner_id%>"><%=owner%></a> <b>on</b>&nbsp; 
<%
		sql = "SELECT date_format(MIN(lastupdate),_utf8'%b %d %r') posttime " +
				"FROM (SELECT lastupdate FROM colloquium WHERE col_id = "+col_id+" " +
				"UNION " +
				"SELECT MIN(lastupdate) lastupdate FROM col_bk WHERE col_id = "+col_id+") ptime";
		rsExt = conn.getResultSet(sql);
		if(rsExt.next()){
			String posttime = rsExt.getString("posttime");
%>
							<%=posttime%>
<%
		}
%>
		<logic:present name="UserSession">
<%
		
		//Tags
		sql = "SELECT t.tag_id,t.tag,COUNT(*) _no FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
				"WHERE  tt.col_id = " + col_id +
				" GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
		String tags = "";
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
		
		sql = "SELECT COUNT(*) _no FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
				"WHERE  tt.col_id = " + col_id + " AND tt.user_id=" + ub.getUserID() +
				" GROUP BY t.tag_id ";
		boolean usertagged = false;
		rsExt = conn.getResultSet(sql);
		if(rsExt != null){
			while(rsExt.next()){
				long _no = rsExt.getLong("_no");
				if(_no > 0)usertagged = true;
			}
		}
%>
							<span class="spanTagColID<%=col_id %>" style="display:<%=tags.length()>0?"inline":"none" %>;">
								<br/><b>Tags:</b><%=tags %>
							</span>
<%
		
		sql = "SELECT c.comm_id,c.comm_name,COUNT(*) _no FROM community c,contribute ct,userprofile u " +
				"WHERE c.comm_id = ct.comm_id AND " +
				"ct.userprofile_id = u.userprofile_id AND " + 
				"u.col_id = " + col_id +
				" GROUP BY c.comm_id,c.comm_name " +
				"ORDER BY c.comm_name";
		rsExt.close();
		rsExt = conn.getResultSet(sql);
		String communities = "";		
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
%>
							<span class="spanPostGroupColID<%=col_id %>" style="display:<%=communities.length()>0?"inline":"none" %>;">
								<br/><b>Posted to groups:</b><%=communities%>
							</span>

							<span class="spanWhomBookmarkColID<%=col_id %>" style="display:<%=bookmarks.length()>0?"inline":"none" %>;">
								<br/><b>Bookmarked by:</b><%=bookmarks%>
							</span>
<br/>
<a class="abookcolid<%=col_id %>" href="javascript:return false;" 					
	style="text-decoration: none;"
	onmouseover="this.style.textDecoration='underline'" 
	onmouseout="this.style.textDecoration='none'"
	onclick="bookmarkTalk(<%=ub.getUserID() %>, <%=col_id %>, this, 'spanbookcolid<%=col_id %>')"
><%=bookmarked?"Unbookmark":"Bookmark" %></a>
&nbsp;
<a class="atagcolid<%=col_id %>" href="javascript:return false;"
	style="text-decoration: none;"
	onmouseover="this.style.textDecoration='underline'" 
	onmouseout="this.style.textDecoration='none'"
	onclick="$('#tdTagHeader').hide();$('#btnTagClose').val('Close');showPopupTag(<%=ub.getUserID() %>,<%=col_id %>,this,'.spanTagColID<%=col_id %>')"
><%=usertagged?"Edit Tags":"Add Tags" %></a>
		</logic:present>

							</span>

									</td>
									<td width="15%" valign = "top">
										<img class="speakerImg" src="<%=pic_url %>" onload="javascript: DrawImage(this, 100, 100)" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
<%		
	}
	conn.conn.close();
	conn = null;
		
	if(!day.equalsIgnoreCase("")){
%>
				</table>
			</td>
		</tr>
<%			
		if(menu.equalsIgnoreCase("myaccount")){
%>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="right"><input class="btn" type="button" value="Delete" onclick="deleteCols();"></td>
		</tr>
<%			
		}
	}
	if(noTalks){
%>
		<tr>
			<td id="lblNoTalk" style="font-size: 0.95em;font-weight: bold;" align="center"><%=olderTalkNo>0?"No Forthcoming Talks":"No Talks" %></td>
		</tr>
<%	
	}
%>
	</table>
	<input type="hidden" id="count" value="<%= num %>" />
<% 
	if(menu.equalsIgnoreCase("myaccount")){
%>
	</form>
<% 
	}
%>
</div>
	
