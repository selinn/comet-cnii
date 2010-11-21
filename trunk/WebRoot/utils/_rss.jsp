<%@page import="java.util.GregorianCalendar"%><%@page import="java.util.Calendar"%><%@page import="edu.pitt.sis.beans.UserBean"%><?xml version="1.0" encoding="UTF-8" ?><%@ page contentType="text/xml" language="java"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.Html2Text"%><% 
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
	
	ResultSet rs = null;
	String sql = "SELECT date_format(c._date,_utf8'%W, %b %d') AS `day`, c.col_id, c.title, " +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"s.name,c.location,h.host_id,h.host,c.owner_id,u.name owner,lc.abbr,c.video_url,s.affiliation, " +
					"date_format(c._date,_utf8'%Y') _year,c.detail,date_format(c.lastupdate,_utf8'%W, %b %d %l:%i %p') _lastupdate " +
					"FROM colloquium c JOIN speaker s ON c.speaker_id = s.speaker_id " +
					"JOIN userinfo u ON c.owner_id = u.user_id " +
					"LEFT JOIN host h ON c.host_id = h.host_id " +
					"LEFT JOIN loc_col lc ON c.col_id = lc.col_id ";// +
					//"WHERE TRUE ";// +
					//"c._date >= (SELECT beginterm FROM sys_config) " +
					//"AND c._date <= (SELECT endterm FROM sys_config) ";
	if(req_posted){
		sql = "SELECT date_format(pt.posttime,_utf8'%W, %b %d') AS `day`, c.col_id, c.title, " +
				"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
				"s.name,c.location,h.host_id,h.host,c.owner_id,u.name owner,lc.abbr,c.video_url,s.affiliation, " +
				"date_format(c._date,_utf8'%Y') _year,c.detail,date_format(c.lastupdate,_utf8'%W, %b %d %l:%i %p') _lastupdate " +
				"FROM colloquium c JOIN speaker s ON c.speaker_id = s.speaker_id " +
				"JOIN userinfo u ON c.owner_id = u.user_id " +
				"JOIN " +
				"(SELECT col_id,MIN(lastupdate) posttime FROM " +
				" (SELECT col_id,MIN(lastupdate) lastupdate FROM col_bk GROUP BY col_id " +
				" UNION " +
				" SELECT col_id,lastupdate FROM colloquium) tpost " +
				"GROUP BY col_id) pt ON c.col_id = pt.col_id " +
				"LEFT JOIN host h ON c.host_id = h.host_id " +
				"LEFT JOIN loc_col lc ON c.col_id = lc.col_id ";// +
				//"WHERE TRUE ";
	}

	if(user_id_value !=null){//User Mode
		for(int i=0;i<user_id_value.length;i++){
			if(req_posted){
				sql += "JOIN colloquium cc" + i + " ON c.col_id=cc" + i + ".col_id AND cc"+ i + ".owner_id = " + user_id_value[i] + " ";
			}else{
				sql += "JOIN userprofile up" + i + " WHERE c.col_id=up" + i + ".col_id AND up" + i + ".user_id = " + user_id_value[i] + " ";
			}
		}
	}
	if(comm_id_value != null){//Community Mode
		for(int i=0;i<comm_id_value.length;i++){
			sql += "JOIN userprofile upc" + i + " ON c.col_id=upc" + i + ".col_id " +
					"JOIN contribute ct" + i + " ON upc" + i + ".userprofile_id = ct" + i + ".userprofile_id " + 
					"AND ct" + i + ".comm_id = " + comm_id_value[i] + " ";
		}
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
			sql += "JOIN seriescol sc" + i + " ON c.col_id = sc" + i + ".col_id AND sc" + i + ".series_id=" + series_id_value + " ";
		}
	}
	if(entity_id_value != null){//Entity Mode
		for(int i=0;i<entity_id_value.length;i++){
			sql += "JOIN entities ee" + i + " ON c.col_id = ee" + i + ".col_id AND ee" + i + ".entity_id = " + entity_id_value[i] + " ";
		}
	}
	if(type_value != null){//Entity Type Mode
		for(int i=0;i<type_value.length;i++){
			sql += "JOIN entities eee" + i + " ON c.col_id = eee" + i + ".col_id JOIN entity e" + i + " ON " +
			"e" + i + ".entity_id = eee" + i + ".entity_id AND e" + i + "._type = '" + type_value + "' ";
		}
	}
	sql += "WHERE TRUE ";
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
	if(menu.equalsIgnoreCase("calendar")||menu.equalsIgnoreCase("myaccount")||req_most_recent||req_specific_date){
		if(req_posted){
			sql += "AND pt.posttime >= '" + strBeginDate + " 00:00:00' " +
			"AND pt.posttime <= '" + strEndDate + " 23:59:59' ";
		}else{
			sql += "AND c._date >= '" + strBeginDate + " 00:00:00' " +
			"AND c._date <= '" + strEndDate + " 23:59:59' ";
		}
	}
	sql += "GROUP BY c.col_id ";
	if(req_posted){
		sql += "ORDER BY pt.posttime;";
	}else{
		sql += "ORDER BY c._date,c.begintime;";
	}
    //out.println(sql);
    try{
		//response.setContentType("application/xml");
		//response.setHeader("Content-Disposition","attachment; filename=\"rss.xml\"");
		
		out.println("<rss version=\"2.0\" xmlns:content=\"http://purl.org/rss/1.0/modules/content/\" >");
		out.println("<channel>");
		out.println("<title>CoMeT</title>");
		out.println("<description>Collaborative Management of Talks: A social web system for research communities</description>");
		out.println("<link>http://halley.exp.sis.pitt.edu/comet/</link>");
		
		Html2Text parser = new Html2Text();
		
    	rs = conn.getResultSet(sql);
        while(rs.next()){
        	String title = rs.getString("title");
        	String _col_id = rs.getString("col_id");
        	String description = rs.getString("detail");
        	String link = "http://halley.exp.sis.pitt.edu/comet/presentColloquium.do?col_id=" + _col_id;
        	String _lastupdate = rs.getString("_lastupdate");
        	String author = rs.getString("owner");
        	String speaker = rs.getString("name");
        	String day = rs.getString("day");
        	String _begin = rs.getString("_begin");
        	String _end = rs.getString("_end");
        	String location = rs.getString("location");

			out.println("<item>");
			out.println("<title><![CDATA[" + title.trim() + "]]></title>");
			out.println("<pubDate>" + _lastupdate + " -0400</pubDate>");
			out.println("<link>" + link + "</link>");
			
			String content = "<b>Speaker:</b>&nbsp;" + speaker + "<br/>";
			content += "<b>Date:</b>&nbsp;" + day + " on " + _begin + " - " + _end + "<br/>";
			content += "<b>Location:</b>&nbsp;" + location;
			
			/** //Tags
			sql = "SELECT t.tag_id,t.tag,COUNT(*) _no FROM tag t,tags tt,userprofile u " +
					"WHERE t.tag_id = tt.tag_id AND " +
					"tt.userprofile_id = u.userprofile_id AND " +
					"u.col_id = " + _col_id +
					" GROUP BY t.tag_id,t.tag " +
					"ORDER BY t.tag";
			ResultSet rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				String tag = rsExt.getString("tag");
				long _tag_id = rsExt.getLong("tag_id");
				long _no = rsExt.getLong("_no");
				content += "<br/><b>Tags:</b>&nbsp;<a href=\"http://washington.sis.pitt.edu/comet/tag.do?tag_id=" + _tag_id + "\">" + tag + "</a>";
			}
			while(rsExt.next()){
				String tag = rsExt.getString("tag");
				long _tag_id = rsExt.getLong("tag_id");
				long _no = rsExt.getLong("_no");
				content += "&nbsp;<a href=\"http://washington.sis.pitt.edu/comet/tag.do?tag_id=" + _tag_id + "\">" + tag + "</a>";
			}
			
			sql = "SELECT c.comm_id,c.comm_name,COUNT(*) _no FROM community c,contribute ct,userprofile u " +
					"WHERE c.comm_id = ct.comm_id AND " +
					"ct.userprofile_id = u.userprofile_id AND " + 
					"u.col_id = " + _col_id +
					" GROUP BY c.comm_id,c.comm_name " +
					"ORDER BY c.comm_name";
			rsExt.close();
			rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				String comm_name = rsExt.getString("comm_name");
				long _comm_id = rsExt.getLong("comm_id");
				long _no = rsExt.getLong("_no");
				content += "<br/><b>Posted to communities:</b>&nbsp;" +
							"<a href=\"http://washington.sis.pitt.edu/comet/community.do?comm_id=" + _comm_id + "\">" + comm_name + "</a>";
			}
			while(rsExt.next()){
				String comm_name = rsExt.getString("comm_name");
				long _comm_id = rsExt.getLong("comm_id");
				long _no = rsExt.getLong("_no");
				content += "&nbsp;" +
							"<a href=\"http://washington.sis.pitt.edu/comet/community.do?comm_id=" + _comm_id + "\">" + comm_name + "</a>";
			}
			//Bookmark by
			sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u,userprofile up " +
					"WHERE u.user_id = up.user_id AND up.col_id = " + _col_id +
					" GROUP BY u.user_id,u.name ORDER BY u.name";
			rsExt.close();
			rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				String user_name = rsExt.getString("name");
				long _user_id = rsExt.getLong("user_id");
				long _no = rsExt.getLong("_no");
				content += "<br/><b>Bookmarked by:</b>&nbsp;" +
							"<a href=\"http://washington.sis.pitt.edu/comet/calendar.do?user_id=" + _user_id + "\">" + user_name + "</a>";
			}
			while(rsExt.next()){
				String user_name = rsExt.getString("name");
				long _user_id = rsExt.getLong("user_id");
				long _no = rsExt.getLong("_no");
				content += "&nbsp;" +
							"<a href=\"http://washington.sis.pitt.edu/comet/calendar.do?user_id=" + _user_id + "\">" + user_name + "</a>";
			}*/

			if(description != null){			
				description = description.trim();
				content += "<br/><b>Detail:<b>" + description;
				
			}

			out.println("<content:encoded><![CDATA[" + content + "]]></content:encoded>");
			content = content.replaceAll("\\<.*?>","");
			parser.parse(content);				
			content = "<![CDATA[" + parser.getText().trim() + "]]>";
			out.println("<description>" + content + "</description>");

			out.println("<author>" + author + "</author>");
			out.println("</item>");
		}
		rs.close();
		out.println("</channel>");
		out.println("</rss>");
		
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	 conn.conn.close();
	 conn = null;
	}
%>