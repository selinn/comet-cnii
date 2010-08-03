<%@page language="java" import="java.util.*"%>
<%@page language="java" import="java.sql.*"%>
<%@page language="java" import="java.text.DateFormat"%>
<%@page language="java" import="edu.pitt.sis.beans.*"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.NumberFormat"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<script type="text/javascript">
	window.onload = function() {
		if(divCalContent){
			parent.displayCalendar(divCalContent.innerHTML);
		}
	}

	function clearSelection(){
		for(var i=0;i<48;i++){
			try{
				var node = document.getElementById('tblCalendar').rows[Math.floor(i/8)+1].cells[i%8];
				if(node){
					//alert(node.innerHTML);
					node.style.color = "#000000";	
					node.style.border = "none";
					node.style.fontWeight = "normal";	
				}
			}catch(err){
				if(divCalDebug){
					//divCalDebug.innerHTML = "Error description: ".concat(err.description);
				}
			}
		}
	}

	function navDay(aDay,year,month,day){
		period = 0;
		_day = day;
		_month = month;
		_year = year;
		
		divBtnDay.style.background = "#0080ff";
		divBtnDay.style.color = "#ffffff";
		divBtnDay.style.fontWeight = "bold";
		divBtnDay.onmouseover = "this.style.background='#0080ff';this.style.color='#ffffff';";
		divBtnDay.onmouseout = "this.style.background='#ffffff';this.style.color='#0080ff';";		

		divBtnWeek.style.background = "#ffffff";
		divBtnWeek.style.color = "#0080ff";
		divBtnWeek.style.fontWeight = "normal";
		divBtnWeek.onmouseover = "this.style.background='#ffffff';this.style.color='#0080ff';";		
		divBtnWeek.onmouseout = "this.style.background='#0080ff';this.style.color='#ffffff';";

		divBtnMonth.style.background = "#ffffff";
		divBtnMonth.style.color = "#0080ff";
		divBtnMonth.style.fontWeight = "normal";
		divBtnMonth.onmouseover = "this.style.background='#ffffff';this.style.color='#0080ff';";		
		divBtnMonth.onmouseout = "this.style.background='#0080ff';this.style.color='#ffffff';";
		
		clearSelection();
		
		//alert(aDay);
		if(aDay){
			aDay.style.color = "#0080FF";	
			aDay.style.border = "1px #0080ff solid";
			aDay.style.fontWeight = "bold";	
		}
		//selectedDay = aDay;
		//selectedWeek = undefined;

		var action = "utils/loadTalks.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(_id != -1){
			action = action.concat('&type=',browseType,'&id=',_id);
		}
		loadTalks(action);
		
		action = "utils/calExt.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(_id != -1){
			action = action.concat('&type=',browseType,'&id=',_id);
		}
		loadExtension(action);
	}
	function navWeek(aWeek,year,month,week){
		period = 1;
		var thisweek = getWeekNoInMonth(_year,_month,_day);
		var strDebug= "Before calculating ".concat(thisweek,' year:',_year,' month:',_month,' day:',_day,'<br/>');
		_day += (week - thisweek)*7;
		if(_day < 1){
			_month -= 1;
			if(_month == 0){
				_month = 12;
				_year -= 1;
			}
			strDebug = strDebug.concat('Previous month',_month,' day number is ',daysInMonth(_year,_month),' new day is ',_day,'<br/>');
			_day = daysInMonth(_year,_month) + _day;
		}else if(_day > daysInMonth(_year,_month)){
			var days = daysInMonth(_year,_month);
			_month += 1;
			if(_month == 13){
				_month = 1;
				_year += 1;
			}
			_day -= days;
			strDebug = strDebug.concat('Previous month day number is ',daysInMonth(_year,_month),' new day is ',_day,'<br/>');
		}
		
		strDebug = strDebug.concat('New date is year:',_year,' month:',_month,' day:',_day);
		
		//divCalDebug.innerHTML = strDebug;
		
		divBtnDay.style.background = "#ffffff";
		divBtnDay.style.color = "#0080ff";
		divBtnDay.style.fontWeight = "normal";
		divBtnDay.onmouseover = "this.style.background='#ffffff';this.style.color='#0080ff';";		
		divBtnDay.onmouseout = "this.style.background='#0080ff';this.style.color='#ffffff';";

		divBtnWeek.style.background = "#0080ff";
		divBtnWeek.style.color = "#ffffff";
		divBtnWeek.style.fontWeight = "bold";
		divBtnWeek.onmouseover = "this.style.background='#0080ff';this.style.color='#ffffff';";
		divBtnWeek.onmouseout = "this.style.background='#ffffff';this.style.color='#0080ff';";		

		divBtnMonth.style.background = "#ffffff";
		divBtnMonth.style.color = "#0080ff";
		divBtnMonth.style.fontWeight = "normal";
		divBtnMonth.onmouseover = "this.style.background='#ffffff';this.style.color='#0080ff';";		
		divBtnMonth.onmouseout = "this.style.background='#0080ff';this.style.color='#ffffff';";
	
		clearSelection();
	
		/*if(selectedDay){
			selectedDay.style.color = "#000000";	
			selectedDay.style.border = "none";
			selectedDay.style.fontWeight = "normal";	
		}
		if(selectedWeek){
			selectedWeek.style.color = "#000000";	
			selectedWeek.style.border = "none";
			selectedWeek.style.fontWeight = "normal";	
		}*/

		aWeek.style.color = "#0080FF";	
		aWeek.style.border = "1px #0080ff solid";
		aWeek.style.fontWeight = "bold";	

		//selectedDay = undefined;
		//selectedWeek = aWeek;

		var action = "utils/loadTalks.jsp";
		action = action.concat('?month=',month,'&year=',year,'&week=',week);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(_id != -1){
			action = action.concat('&type=',browseType,'&id=',_id);
		}
		loadTalks(action);

		action = "utils/calExt.jsp";
		action = action.concat('?month=',month,'&year=',year,'&week=',week);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(_id != -1){
			action = action.concat('&type=',browseType,'&id=',_id);
		}
		loadExtension(action);
	}
</script>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td>
<% 
    String color_week = "#6699FF";
    String color_week_header = "#00F078";
    String color_week_no = "#FFFF53";
    String color_month = "#1C37FF";
    String color_list = "#C0C0C0";
    String color_day = "#CECECE";
    String color_day_1 = "#AEAEAE";
    String color_day_2 = "#8E8E8E";
    String color_day_3 = "#6E6E6E";
    String color_view = "#0080FF";

	if(request.getParameter("year")!=null){
%>
<div id="divCalContent">
<% 
	}
	session=request.getSession(false);

    /*---- Variable for Calendar -------------*/
    final String[] months = {"January","Febuary","March",
							    "April","May","June",
							    "July","August","September",
							    "October","November","December"};
    final String[] day_short={"S", "M", "T", "W", "T", "F", "S","W"};

    Calendar calendar = new GregorianCalendar();
    int month = calendar.get(Calendar.MONTH);
    int year = calendar.get(Calendar.YEAR);
    int today = calendar.get(Calendar.DAY_OF_MONTH);
    int req_day = -1;
    int req_week = -1;
    int req_month = month+1;
    int req_year = year;
	long req_id = -1;
	int req_type = -1;//1:user 2:community 3:tag
	boolean req_posted = false;//True means user posts' talks 
	String debugText = " ";	
    if(request.getParameter("day")!=null){
        req_day = Integer.parseInt(request.getParameter("day"));
    }
    
    if(request.getParameter("week")!=null){
        req_week = Integer.parseInt(request.getParameter("week"));
    }
    
    if(request.getParameter("month")!=null){
        req_month = Integer.parseInt(request.getParameter("month"));
    }
    
    if(request.getParameter("year")!=null){
        req_year = Integer.parseInt(request.getParameter("year"));
    }
    
    if(request.getParameter("id")!=null){
        req_id = Long.parseLong(request.getParameter("id"));
    }
    
    if(request.getParameter("type")!=null){
        req_type = Integer.parseInt(request.getParameter("type"));
    }
    
    if(request.getParameter("post")!=null){
    	req_posted = true;
    }
    if(request.getParameter("user_id")!=null){
    	req_id = Integer.parseInt(request.getParameter("user_id"));
    	req_type = 1;
    }
    if(request.getParameter("comm_id")!=null){
    	req_id = Integer.parseInt(request.getParameter("comm_id"));
    	req_type = 2;
    }
    if(request.getParameter("tag_id")!=null){
    	req_id = Integer.parseInt(request.getParameter("tag_id"));
    	req_type = 3;
    }
    
    Calendar setcal = new GregorianCalendar();
    setcal.set(req_year, req_month-1, 1);
    int startday = setcal.get(Calendar.DAY_OF_WEEK) - 1;
    int stopday = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
    
	//daysPrevMonth - startday + 1
	String strBeginDate = "";
	String strEndDate = "";
    if(req_month == 1){
    	setcal.set(req_year-1, 11, 1);
    }else{
    	setcal.set(req_year, req_month-2, 1);
    }  
    int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
	if(startday == 0){
		strBeginDate = req_year + "-" + req_month + "-1";
	}else{
		if(req_month == 1){
			strBeginDate = (req_year-1) + "-12-" + (31 - startday + 1);
		}else{
			strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);		
		}
	}
	if((startday + stopday)%7 == 0){
		strEndDate = req_year + "-" + req_month + "-" + stopday;
	}else{
		if(req_month == 12){
			strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
		}else{
			strEndDate = (req_year) + "-" + (req_month + 1) + "-" +(7 - ((startday + stopday)%7));
		}
	}
	
	String menu = (String)session.getAttribute("menu");
	if(menu.equalsIgnoreCase("myaccount")){
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		req_type = 1;//User Mode
		req_id = ub.getUserID();		
	}
	String sql = "SELECT date_format(c._date,_utf8'%m%d') AS `day`, COUNT(*) AS lecture_no " +
					"FROM colloquium c " +
					"WHERE " +
					"c._date >= '" + strBeginDate + "' " +
					"AND c._date <= '" + strEndDate + "' " +
					"GROUP BY date_format(c._date,_utf8'%m%d');";
		
	if(req_type == 1){//User Mode
		sql = "SELECT date_format(c._date,_utf8'%m%d') AS `day`, COUNT(*) AS lecture_no " +
				"FROM colloquium c,userprofile u " +
				"WHERE " +
				"c.col_id = u.col_id AND " +
				"u.user_id = " + req_id + " AND " +
				"c._date >= '" + strBeginDate + "' " +
				"AND c._date <= '" + strEndDate + "' " +
				" GROUP BY date_format(c._date,_utf8'%m%d');";
		if(req_posted){
			sql = "SELECT date_format(c._date,_utf8'%m%d') AS `day`, COUNT(*) AS lecture_no " +
					"FROM colloquium c " +
					"WHERE " +
					"c._date >= '" + strBeginDate + "' " +
					"AND c._date <= '" + strEndDate + "' " +
					"AND c.user_id = " + req_id +
					" GROUP BY date_format(c._date,_utf8'%m%d');";
		}
	}else if(req_type == 2){//Community Mode
		sql = "SELECT date_format(c._date,_utf8'%m%d') AS `day`, COUNT(*) AS lecture_no " +
				"FROM colloquium c,userprofile u,contribute cc " +
				"WHERE " +
				"u.userprofile_id = cc.userprofile_id AND " +
				"c.col_id = u.col_id AND " +
				"cc.comm_id = " + req_id + " AND " +
				"c._date >= '" + strBeginDate + "' AND " +
				"c._date <= '" + strEndDate + "' " +
				"GROUP BY date_format(c._date,_utf8'%m%d');";
	}else if(req_type == 3){//Tag Mode
		sql = "SELECT date_format(c._date,_utf8'%m%d') AS `day`, COUNT(*) AS lecture_no " +
				"FROM colloquium c,userprofile u,tags t " +
				"WHERE " +
				"u.userprofile_id = t.userprofile_id AND " +
				"c.col_id = u.col_id AND " +
				"t.tag_id = " + req_id + " AND " +
				"c._date >= '" + strBeginDate + "' " +
				"AND c._date <= '" + strEndDate + "' " +
				"GROUP BY date_format(c._date,_utf8'%m%d');";
	}
	
	connectDB conn = new connectDB();
	ResultSet rs = conn.getResultSet(sql);
	//out.print("sql: " + sql + "<br/>");
	HashMap<String,Integer> days = new HashMap<String,Integer>();
	while(rs.next()){
		days.put(rs.getString("day"),new Integer(rs.getInt("lecture_no")));
		//out.print("day:" + rs.getString("day") + " no:" + rs.getString("lecture_no") + "<br/>");
	}	

%>
<div align="center" style="font-size: 0.95em;font-weight: bold;">
  	<%=months[req_month-1]%>&nbsp;<%=req_year%>
</div>
<table width="100%" border="0" id="tblCalendar">
    <tr>   
<% // Calendar Headers: S M T W TH F S
	for (int i = 0; i < 7; i++) {
%>
		<td style="font-size: 0.9em;background-color: <%=color_week%>;" align="center" width="14.28%">
			<%=day_short[i]%>
		</td>
<%
	}  
%>
		<td style="font-size: 0.9em;background-color: <%=color_week_header%>;" align="center" width="14.28%">
			<%=day_short[7]%>
		</td>
    </tr>
<%
	NumberFormat formatter = new DecimalFormat("00");
    for (int i = 0;i < 42; i++){   
        if(i%7==0){
        	if(i > startday + stopday - 1){
        		break;
        	}
        	//Insert a new row
%>
	<tr>
<%        
        }
  		//If a day exists in hashmap
  		String style = "font-size: 0.7em;cursor: pointer;";
  		String strDay = "";
		boolean selected = false;
  		int navYear = req_year;
  		int navMonth = req_month;
  		int navDay = -1;
  		int navWeek = -1;
  		if(i < startday){
			navDay = daysPrevMonth - startday + i + 1;
  			if(req_month == 1){
  	  			navMonth = 12;
  	  			navYear--;
			}else{
				navMonth--;
  			}
  		}
       	if((i>=startday)&&(i<=startday+stopday-1)){
       		navDay = i-startday+1;
 			if(req_day==(i-startday+1)){
				style += "color: #0080ff;border: 1px #0080ff solid;font-weight: bold;";
				selected = true;
			}
       	}
  		if(i>startday+stopday-1){
  			navDay = i+1-startday-stopday;
  			if(req_month == 12){
  				navMonth = 1;
  				navYear++;
  			}else{
  				navMonth++;
  			}
  		}
  		
		strDay = formatter.format(navMonth) + formatter.format(navDay);
  		Integer talkno = days.get(strDay);
  		if(talkno != null){
  			String bgcolor = "";
  			switch (talkno.intValue()/5){
  				case 0: bgcolor = color_day;break;
  				case 1: bgcolor = color_day_1;break;
  				case 2: bgcolor = color_day_2;break;
  				default: bgcolor = color_day_3;break;       				
  			}
  			style += "background-color: " + bgcolor + ";";
  		}

%>
		<td id="date<%=i%>" style="<%=style%>" 
			align="right"
			onmouseover="this.style.fontSize = '0.8em';"
			onmouseout="this.style.fontSize = '0.7em';"
			onclick="navDay(this,<%=navYear%>,<%=navMonth%>,<%=navDay%>);">
<% 
		if(i < startday){
%>
				<%=daysPrevMonth - startday + i + 1%>
<% 
		}else if((i>=startday)&&(i<=startday+stopday-1)){
%>
				<%=i-startday+1%>
<% 
		}else if(i>startday+stopday-1){
%>
				<%=i+1-startday-stopday%>
<% 
		}
%>
		</td>
<%		
		
       	//Insert week number
        if(i%7==6){
	        if(i < startday+stopday+6){
        		style = "cursor: pointer;font-size: 0.7em;background-color: " + color_week_no + ";";
	        	if((i/7+1) == req_week){
	        		selected = true;
	        		style += "color: #0080ff;border: 1px #0080ff solid;font-size: 0.7em;font-weight: bold;";
	        	}
%>
		<td id="week<%=(i/7+1)%>" style="<%=style%>" 
			align="right"
			onmouseover="this.style.fontSize = '0.8em';"
			onmouseout="this.style.fontSize = '0.7em';"
			onclick="navWeek(this,<%=navYear%>,<%=navMonth%>,<%=i/7+1%>);">
			<%=i/7+1%>
		</td>
	</tr>
<%
			}
        }
	}
%>
	<tr>
		<td colspan="8">
			<table cellspacing="0" cellpadding="0" width="100%" align="center">
				<tr>
					<td width="25%" style="font-size: 0.6em;background-color: #CECECE;">&nbsp;</td>
					<td width="25%" style="font-size: 0.6em;background-color: #AEAEAE;">&nbsp;</td>
					<td width="25%" style="font-size: 0.6em;background-color: #8E8E8E;">&nbsp;</td>
					<td width="25%" style="font-size: 0.6em;background-color: #6E6E6E;">&nbsp;</td>
				</tr>
				<tr align="center">
					<td width="25%" style="font-size: 0.6em;">1 - 5</td>
					<td width="25%" style="font-size: 0.6em;">6 - 10</td>
					<td width="25%" style="font-size: 0.6em;">11 - 20</td>
					<td width="25%" style="font-size: 0.6em;">21+</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%-- 
    <div align="center"><font size="-1">
		<div style="cursor:pointer;" onclick="window.location='calendar.do'">
	    	Today, <%=months[month]%>&nbsp;<%=today%>, <%=year%>
	    </div>
    </font></div>
--%>    

<div id="divCalDebug">
	&nbsp;<%=debugText%>
</div>
<div id="divExtension">
<% 
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
	    //int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
	/*****************************************************************/
	/* Week View                                                     */
	/*****************************************************************/
		if(req_week > 0){
			if(startday == 0){
				strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week-1) + 1);
			}else{
				if(req_week == 1){
					strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);		
				}else{
					strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week - 1) - startday + 1);		
				}
			}
			if(7*req_week - startday <= stopday ){
				strEndDate = req_year + "-" + req_month + "-" + (7*req_week - startday);			
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
				}else{
					strEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
				}
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
				}
			}
			if((startday + stopday)%7 == 0){
				strEndDate = req_year + "-" + req_month + "-" + stopday;
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
				}else{
					strEndDate = (req_year) + "-" + (req_month + 1) + "-" +(7 - ((startday + stopday)%7));
				}
			}
		}
    }

	sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no " +
					"FROM colloquium c,userprofile u,tags tt,tag t " +
					"WHERE " +
					"c.col_id = u.col_id " +
					"AND u.userprofile_id = tt.userprofile_id " +
					"AND tt.tag_id = t.tag_id " +
					"AND c._date >= '" + strBeginDate + "' " +
					"AND c._date <= '" + strEndDate + "' " +
					"GROUP BY t.tag_id,t.tag " +
					"ORDER BY t.tag";
		
	if(req_type == 1){//User Mode
		sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no  " +
				"FROM colloquium c,userprofile u,tags tt,tag t " +
				"WHERE " +
				"c.col_id = u.col_id " +
				"AND u.userprofile_id = tt.userprofile_id " +
				"AND tt.tag_id = t.tag_id " +
				"AND u.user_id = " + req_id + " " +
				"AND c._date >= '" + strBeginDate + "' " +
				"AND c._date <= '" + strEndDate + "' " +
				"GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
		if(req_posted){
			sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no  " +
					"FROM colloquium c,userprofile u,tags tt,tag t " +
					"WHERE " +
					"c.col_id = u.col_id " +
					"AND u.userprofile_id = tt.userprofile_id " +
					"AND tt.tag_id = t.tag_id " +
					"AND c._date >= '" + strBeginDate + "' " +
					"AND c._date <= '" + strEndDate + "' " +
					"AND c.user_id = " + req_id +
					" GROUP BY t.tag_id,t.tag " +
					"ORDER BY t.tag";
		}
	}else if(req_type == 2){//Community Mode
		sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no  " +
				"FROM colloquium c,tags tt,tag t,contribute cc " +
				"WHERE " +
				"c.col_id = u.col_id " +
				"AND tt.tag_id = t.tag_id " +
				"AND cc.userprofile_id = tt.userprofile_id AND " +
				"cc.comm_id = " + req_id + " AND " +
				"c._date >= '" + strBeginDate + "' AND " +
				"c._date <= '" + strEndDate + "' " +
				"GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
	}else if(req_type == 3){//Tag Mode
		sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no  " +
				"FROM colloquium c,tags tt,tag t " +
				"WHERE " +
				"c.col_id = u.col_id " +
				"AND tt.tag_id = t.tag_id " +
				"AND tt.userprofile_id IN " +
				"(SELECT userprofile_id FROM tags WHERE tag_id = " + req_id + ") " +
				"AND t.tag_id <> " + req_id + " AND " +
				"c._date >= '" + strBeginDate + "' " +
				"AND c._date <= '" + strEndDate + "' " +
				"GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
	}
	rs.close();
	rs = conn.getResultSet(sql);
	HashMap<String,Integer> occurMap = new HashMap<String,Integer>();
	HashMap<String,Integer> idMap = new HashMap<String,Integer>();
	long totalOccur = 0;
	while(rs.next()){
       	occurMap.put(rs.getString("tag").toLowerCase(), rs.getInt("tag_no"));
       	idMap.put(rs.getString("tag").toLowerCase(), rs.getInt("tag_id"));
       	totalOccur += rs.getInt("tag_no");
	}
	if(totalOccur > 0){
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td style="font-size: 0.95em;font-weight: bold;background-color: #efefef;">
			Tag Cloud
		</td>
	</tr>
	<tr>
		<td style="font-size: 0.9em;">
<% 
		//Sort map
		if(occurMap.size() > 0){
			Vector<String> v = new Vector<String>(occurMap.keySet());
			Collections.sort(v);
			double avgTagOccur = (double)totalOccur/(double)v.size(); 
			for(Iterator<String> it = v.iterator();it.hasNext();){
				String tag = it.next();
				double fontsize = (double)occurMap.get(tag)/avgTagOccur;
%>
			<a href="javascript: return false;" onclick="window.location='tag.do?tag_id=<%=idMap.get(tag)%>'" 
				onmouseout="this.style.textDecoration='none'"
				onmouseover="this.style.textDecoration='underline'"
				style="font-size: <%=Math.floor(fontsize*100)/100.0 %>em;"><%=tag%></a>&nbsp;
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
&nbsp;
</div>
<%
		if(request.getParameter("year")!=null){
 %>
</div>
<%
		} 
%>
		</td>
	</tr>
</table>