<%@ page language="java"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="java.util.Calendar"%><%@page import="java.util.GregorianCalendar"%><%@page import="edu.pitt.sis.beans.UserBean"%><%@page import="java.util.ArrayList"%><%@page import="java.util.HashMap"%><%@page import="java.util.Iterator"%><%@page import="java.util.HashSet"%><%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %><% 
	final String[] months = {"January","Febuary","March",
							    "April","May","June",
							    "July","August","September",
							    "October","November","December"};

	connectDB conn = new connectDB();
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
    Calendar calendar = new GregorianCalendar();
    int month = calendar.get(Calendar.MONTH);
    int year = calendar.get(Calendar.YEAR);
    int req_day = -1;
    int req_week = -1;
    int req_month = month+1;
    int req_year = year;
    boolean req_specific_date = false;
	boolean req_posted = false;//True means user posts' talks
	boolean req_impact = false;//True means user impact
	boolean req_most_recent = false;
	boolean req_recommend = false;
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
    if(request.getParameter("recommend")!=null){
    	req_recommend = true;
    }
    /*if(user_id_value!=null){
    	req_most_recent = true;
	    req_week = calendar.get(Calendar.WEEK_OF_MONTH);
	    req_specific_date = true;
    }*/
    
	String menu = "";
    
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
	if(user_id_value != null && req_recommend){
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
			String user_list = "";
			if(user_id_value !=null){//User Mode
				for(int i=0;i<user_id_value.length;i++){
					if(i!=0){
						user_list += ",";
					}
					user_list += user_id_value[i];
				}
			}
			String sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
							"JOIN userinfo u ON ru.user_id = u.user_id " + 
							"WHERE ru.weight >= u.min_score AND ru.user_id IN (" + user_list + 
							") AND c._date >='" + strRecBeginDate + "' " +
							" AND c._date <='" + strRecEndDate + "' " +
							"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id IN (" + user_list + ")) " +
							"AND c.col_id NOT IN (SELECT col_id FROM userfeedback where user_id IN (" + user_list + 
							") AND rating <= (SELECT SUM(rating)/COUNT(*) FROM userfeedback WHERE user_id IN (" + user_list + 
							")) GROUP BY col_id) " +
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

				String user_list = "";
				if(user_id_value !=null){//User Mode
					for(int j=0;i<user_id_value.length;j++){
						if(j!=0){
							user_list += ",";
						}
						user_list += user_id_value[j];
					}
				}
				String sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
								"JOIN userinfo u ON ru.user_id = u.user_id " + 
								"WHERE ru.weight >= u.min_score AND ru.user_id IN (" + user_list + 
								") AND c._date >='" + strRecBeginDate + "' " +
								"AND c._date <='" + strRecEndDate + "' " +
								"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id IN (" + user_list + ")) " +
								"AND c.col_id NOT IN (SELECT col_id FROM userfeedback where user_id IN (" + user_list + 
								") AND rating <= (SELECT SUM(rating)/COUNT(*) FROM userfeedback WHERE user_id IN (" + user_list + 
								")) GROUP BY col_id) " +
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

	String sql = "SELECT date_format(c._date,_utf8'%W, %b %d, %Y') AS `day`, c.col_id, c.title, " +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"s.name,c.location,h.host_id,h.host,c.owner_id,u.name owner,lc.abbr,c.video_url,s.affiliation " +
					"FROM colloquium c JOIN speaker s ON c.speaker_id = s.speaker_id " +
					"LEFT JOIN host h ON c.host_id = h.host_id " +
					"LEFT JOIN loc_col lc ON c.col_id = lc.col_id " +
					"JOIN userinfo u ON c.owner_id = u.user_id " +
					"WHERE TRUE ";// +
					//"c._date >= (SELECT beginterm FROM sys_config) " +
					//"AND c._date <= (SELECT endterm FROM sys_config) ";
	if(req_posted){
		sql = "SELECT date_format(pt.posttime,_utf8'%W, %b %d, %Y') AS `day`, c.col_id, c.title, " +
				"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
				"s.name,c.location,h.host_id,h.host,c.owner_id,u.name owner,lc.abbr,c.video_url,s.affiliation " +
				"FROM colloquium c JOIN speaker s ON c.speaker_id = s.speaker_id " +
				"LEFT JOIN host h ON c.host_id = h.host_id " +
				"LEFT JOIN loc_col lc ON c.col_id = lc.col_id " +
				"JOIN userinfo u ON c.owner_id = u.user_id " +
				"JOIN " +
				"(SELECT col_id,MIN(lastupdate) posttime FROM " +
				"(SELECT col_id,MIN(lastupdate) lastupdate FROM col_bk GROUP BY col_id " +
				"UNION " +
				"SELECT col_id,lastupdate FROM colloquium) tpost GROUP BY col_id) pt ON c.col_id = pt.col_id " +
				"WHERE TRUE ";
	}
	
	if(req_recommend){
		String col_id_list = "";
		for(Iterator<Integer> it=recSet.iterator();it.hasNext();){
			if(col_id_list.length() > 0){
				col_id_list += ",";
			}
			col_id_list += it.next();
		}
		sql += "AND c.col_id IN (" + col_id_list + ")";
		//out.println(sql);
	}else if(user_id_value !=null){//User Mode
		for(int i=0;i<user_id_value.length;i++){
			if(req_posted){
				sql += "AND c.col_id IN (SELECT col_id FROM colloquium WHERE owner_id=" + user_id_value[i] + ") ";
			}else{
				sql += "AND c.col_id IN (SELECT col_id FROM userprofile WHERE user_id=" + user_id_value[i]+") ";
			}
		}
	}
	if(comm_id_value != null){//Community Mode
		for(int i=0;i<comm_id_value.length;i++){
			sql += "AND c.col_id IN (SELECT u.col_id FROM contribute c,userprofile u WHERE u.userprofile_id = c.userprofile_id AND c.comm_id=" + comm_id_value[i] + ") ";
		}
	}
	if(tag_id_value != null){//Tag Mode
		for(int i=0;i<tag_id_value.length;i++){
			sql += "AND c.col_id IN (SELECT u.col_id FROM tags t,userprofile u WHERE t.userprofile_id = u.userprofile_id AND t.tag_id=" + tag_id_value[i] + ") ";
		}
	}
	if(series_id_value != null){//Series Mode
		for(int i=0;i<series_id_value.length;i++){
			sql += "AND c.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_id_value[i] + ") ";
		}
	}
	if(entity_id_value != null){//Entity Mode
		for(int i=0;i<entity_id_value.length;i++){
			sql += "AND c.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ") ";
		}
	}
	if(type_value != null){//Entity Type Mode
		for(int i=0;i<type_value.length;i++){
			sql += "AND c.col_id IN (SELECT ee.col_id FROM entity e,entities ee " +
					"WHERE e.entity_id = ee.entity_id AND e._type='" + type_value[i] + "') ";
		}
	}
	if(affiliate_id_value !=null ){
		for(int i=0;i<affiliate_id_value.length;i++){
			sql += "AND c.col_id IN " +
					"(SELECT ac.col_id FROM affiliate_col ac," +
					"(SELECT child_id FROM relation WHERE " +
					"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ affiliate_id_value[i] + "),',%')) cc " +
					"WHERE ac.affiliate_id = cc.child_id " +
					"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id_value[i] + ") ";
		}
	}
	if(req_specific_date){
		if(req_posted){
			sql += "AND pt.posttime >= '" + strBeginDate + " 00:00:00' " +
					"AND pt.posttime <= '" + strEndDate + " 23:59:59' ";
		}else{
			sql += "AND c._date >= '" + strBeginDate + " 00:00:00' " +
					"AND c._date <= '" + strEndDate + " 23:59:59' ";
		}
	}
	if(req_posted){
		sql += "ORDER BY pt.posttime;";
	}else{
		sql += "ORDER BY c._date,c.begintime;";
	}
	String day = "";
	/*if(user_id_value!=null){
		out.println(sql);
	}*/
	ResultSet rs = conn.getResultSet(sql);
	boolean noTalks = true;
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<talks>");
	while(rs.next()){
		noTalks = false;
		String aDay = rs.getString("day");
		//String host = rs.getString("host");
		String owner_id = rs.getString("owner_id");
		String owner = rs.getString("owner");
		//Show talk snap shot
		String col_id = rs.getString("col_id");

		out.print("<talk id=\"" + col_id + "\">");
		out.print("<title><![CDATA[" + rs.getString("title") + "]]></title>");
		String speaker = rs.getString("name");
		out.print("<speaker><![CDATA[" + speaker + "]]></speaker>");
		String affiliation = rs.getString("affiliation");
		if(!affiliation.equalsIgnoreCase("n/a")){
			if(affiliation.trim().length() > 2){
				out.print("<affiliation><![CDATA[" + affiliation.trim() + "]]></affiliation>");
			}
		}
		out.print("<date>" + aDay + "</date>");
		out.print("<begintime>" + rs.getString("_begin") + "</begintime>");
		out.print("<endtime>" + rs.getString("_end") + "</endtime>");
		out.print("<location><![CDATA[" + rs.getString("location") + "]]></location>");

		String _sql = "SELECT s.series_id,s.name FROM series s,seriescol sc " +
		"WHERE s.series_id = sc.series_id AND sc.col_id=" + col_id;

		ResultSet rsSeries = conn.getResultSet(_sql);
		if(rsSeries.next()){
		String series_id = rsSeries.getString("series_id");
		String series_name = rsSeries.getString("name");
		out.print("<series id=\"" + series_id + "\"><![CDATA[" + series_name + "]]></series>");	
		}
		rsSeries.close();

		//How many emails
		int emailno = 0;
		sql = "SELECT emails FROM emailfriends WHERE col_id=" + col_id;
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
		}
		
		//How many views
		int viewno = 0;
		sql = "SELECT ipaddress,sessionid,COUNT(*) _no FROM talkview WHERE col_id=" + col_id + " GROUP BY ipaddress,sessionid";
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
		}
		
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
		rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			while(rsExt.next()){
				out.print("<bookmarkby>");
				String user_name = rsExt.getString("name");
				long user_id = rsExt.getLong("user_id");
				long _no = rsExt.getLong("_no");
				if(user_name.length() > 0){
					out.print("<userid>" + user_id + "</userid>");
					out.print("<name>" + user_name + "</name>");
					bookmarkno++;				
				}
				if(ub != null){
					if(ub.getUserID()==user_id){
						bookSet.add(Integer.parseInt(col_id));
					}
				}
				out.print("</bookmarkby>");
			}
		}
		if(viewno > 0 || emailno > 0 || bookmarkno > 0){
			if(bookmarkno > 0){
				out.print("<bookmarkno>" + bookmarkno + "</bookmarkno>");
			}
			if(emailno > 0){
				out.print("<emailno>" + emailno + "</emailno>");
			}
			if(viewno > 0){
				out.print("<viewno>" + viewno + "</viewno>");
			}
		} 
		String video_url = rs.getString("video_url");
		if(video_url != null){
			if(video_url.length() > 7){
				out.print("<videourl>" + video_url + "</videourl>");
			}
		}
		if(recSet != null){
			if(recSet.contains(Integer.parseInt(col_id))){
				out.print("<recommend>1</recommend>");
			}
		}
		if(bookSet != null){
			if(bookSet.contains(Integer.parseInt(col_id))){
				out.print("<mybookmark>1</mybookmark>");
			}
		}
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
		int sponsorno = 0;
		if(relationList.size()>0){
			for(int i=0;i<relationList.size();i++){
				String[] path = relationList.get(i).split(",");
				if(path.length > 0){
					out.print("<sponsors no=\"" + sponsorno + "\">");
					for(int j=0;j<path.length;j++){
						out.print("<sponsor id=\"" + path[j] + "\">");		
						out.print("<level>" + j + "</level>");
						out.print("<name><![CDATA[" + (String)aList.get(path[j]) + "]]></name>");
						out.print("</sponsor>");
					}			
					out.print("</sponsors>");
					sponsorno++;
				}
			}
		}

		sql = "SELECT date_format(MIN(lastupdate),_utf8'%b %d %r') posttime " +
				"FROM (SELECT lastupdate FROM colloquium WHERE col_id = "+col_id+" " +
				"UNION " +
				"SELECT MIN(lastupdate) lastupdate FROM col_bk WHERE col_id = "+col_id+") ptime";
		rsExt = conn.getResultSet(sql);
		if(rsExt.next()){
			String posttime = rsExt.getString("posttime");
			out.print("<owner id=\"" + owner_id + "\" date=\"" + posttime + "\">" + owner + "</owner>");		
		}

		//Tags
		sql = "SELECT t.tag_id,t.tag,COUNT(*) _no FROM tag t,tags tt,userprofile u " +
				"WHERE t.tag_id = tt.tag_id AND " +
				"tt.userprofile_id = u.userprofile_id AND " +
				"u.col_id = " + col_id +
				" GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
		rsExt = conn.getResultSet(sql);
		if(rsExt != null){
			out.print("<tags>");
			String tags = "";
			while(rsExt.next()){
				String tag = rsExt.getString("tag");
				long tag_id = rsExt.getLong("tag_id");
				long _no = rsExt.getLong("_no");
				if(tag.length() > 0){
					out.print("<tag id=\"" + tag_id +"\">" + tag + "</tag>");
				}
			}
			out.print("</tags>");
		}
		
		sql = "SELECT c.comm_id,c.comm_name,COUNT(*) _no FROM community c,contribute ct,userprofile u " +
				"WHERE c.comm_id = ct.comm_id AND " +
				"ct.userprofile_id = u.userprofile_id AND " + 
				"u.col_id = " + col_id +
				" GROUP BY c.comm_id,c.comm_name " +
				"ORDER BY c.comm_name";
		rsExt.close();
		rsExt = conn.getResultSet(sql);
		if(rsExt != null){
			out.print("<groups>");
			String communities = "";		
			while(rsExt.next()){
				String comm_name = rsExt.getString("comm_name");
				long comm_id = rsExt.getLong("comm_id");
				long _no = rsExt.getLong("_no");
				if(comm_name.length() > 0){
					out.print("<group id=\"" + comm_id +"\">" + comm_name + "</group>");
				}
			}
			out.print("</groups>");
		}
		
		out.print("</talk>");
	}
	conn.conn.close();
	conn = null;
	out.print("</talks>");
%>