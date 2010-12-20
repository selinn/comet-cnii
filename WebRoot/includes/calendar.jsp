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
		
		divBtnDay.style.background = "#003399";
		divBtnDay.style.color = "#ffffff";
		divBtnDay.style.fontWeight = "bold";
		divBtnDay.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
		divBtnDay.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		

		divBtnWeek.style.background = "#ffffff";
		divBtnWeek.style.color = "#003399";
		divBtnWeek.style.fontWeight = "normal";
		divBtnWeek.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
		divBtnWeek.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnMonth.style.background = "#ffffff";
		divBtnMonth.style.color = "#003399";
		divBtnMonth.style.fontWeight = "normal";
		divBtnMonth.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
		divBtnMonth.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		
		clearSelection();
		
		//alert(aDay);
		if(aDay){
			aDay.style.color = "#003399";	
			aDay.style.border = "1px #003399 solid";
			aDay.style.fontWeight = "bold";	
		}
		//selectedDay = aDay;
		//selectedWeek = undefined;

		var action = "utils/loadTalks.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = "utils/loadImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
			action = action.concat('&impact=1');
		}else if(isBookmark == 3){
			action = "utils/popImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		}	
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadTalks(action);
		
		action = "utils/namedEntity.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(isBookmark == 0 || isBookmark == 1){
			if(queryString){
				action = action.concat('&',queryString);
			}
			loadExtension(action);		
		}			
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
		divBtnDay.style.color = "#003399";
		divBtnDay.style.fontWeight = "normal";
		divBtnDay.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
		divBtnDay.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnWeek.style.background = "#003399";
		divBtnWeek.style.color = "#ffffff";
		divBtnWeek.style.fontWeight = "bold";
		divBtnWeek.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
		divBtnWeek.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		

		divBtnMonth.style.background = "#ffffff";
		divBtnMonth.style.color = "#003399";
		divBtnMonth.style.fontWeight = "normal";
		divBtnMonth.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
		divBtnMonth.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
	
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

		aWeek.style.color = "#003399";	
		aWeek.style.border = "1px #003399 solid";
		aWeek.style.fontWeight = "bold";	

		//selectedDay = undefined;
		//selectedWeek = aWeek;

		var action = "utils/loadTalks.jsp";
		action = action.concat('?month=',month,'&year=',year,'&week=',week);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = "utils/loadImpact.jsp";
			action = action.concat('?month=',month,'&year=',year,'&week=',week);
			action = action.concat('&impact=1');
		}else if(isBookmark == 3){
			action = "utils/popImpact.jsp";
			action = action.concat('?month=',month,'&year=',year,'&week=',week);
		}	
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadTalks(action);

		action = "utils/namedEntity.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(isBookmark == 0 || isBookmark == 1){
			if(queryString){
				action = action.concat('&',queryString);
			}
			loadExtension(action);		
		}			
	}
	function navMonth(year,month){
		period = 2;
		
		//divCalDebug.innerHTML = strDebug;
		
		divBtnDay.style.background = "#ffffff";
		divBtnDay.style.color = "#003399";
		divBtnDay.style.fontWeight = "normal";
		divBtnDay.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
		divBtnDay.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnWeek.style.background = "#ffffff";
		divBtnWeek.style.color = "#003399";
		divBtnWeek.style.fontWeight = "normal";
		divBtnWeek.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
		divBtnWeek.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnMonth.style.background = "#003399";
		divBtnMonth.style.color = "#ffffff";
		divBtnMonth.style.fontWeight = "bold";
		divBtnMonth.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
		divBtnMonth.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
	
		clearSelection();
	
		var action = "utils/loadTalks.jsp";
		action = action.concat('?month=',month,'&year=',year);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = "utils/loadImpact.jsp";
			action = action.concat('?month=',month,'&year=',year);
			action = action.concat('&impact=1');
		}else if(isBookmark == 3){
			action = "utils/popImpact.jsp";
			action = action.concat('?month=',month,'&year=',year);
		}	
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadTalks(action);

		action = "utils/namedEntity.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(isBookmark == 0 || isBookmark == 1){
			if(queryString){
				action = action.concat('&',queryString);
			}
			loadExtension(action);		
		}			
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
    String color_view = "#003399";

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
	String[] user_id_value = request.getParameterValues("user_id");
	String[] tag_id_value = request.getParameterValues("tag_id");
	String[] entity_id_value = request.getParameterValues("entity_id");
	String[] type_value = request.getParameterValues("_type");
	String[] series_id_value = request.getParameterValues("series_id");
	String[] comm_id_value = request.getParameterValues("comm_id");
	String[] affiliate_id_value = request.getParameterValues("affiliate_id");
	boolean req_posted = false;//True means user posts' talks 
	boolean req_impact = false;//True means user impact
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
    }else{
    	req_week = calendar.get(Calendar.WEEK_OF_MONTH);
    }
    if(request.getParameter("post")!=null){
    	req_posted = true;
    }
    if(request.getParameter("impact")!=null){
    	req_impact = true;
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
	String feed_para = "";
	String menu = (String)session.getAttribute("menu");
	if(menu.equalsIgnoreCase("myaccount")){
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		String uid = String.valueOf(ub.getUserID());
		if(req_posted){
			feed_para = "?owner_id=" + uid;
		}else{
			feed_para = "?user_id=" + uid;
		}
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

	strBeginDate += " 00:00:00";
	strEndDate += " 23:59:59";
	
	String sql = "SELECT date_format(_date,_utf8'%m%d') AS `day`, COUNT(*) AS lecture_no " +
					"FROM colloquium " +
					"WHERE " +
					"_date >= '" + strBeginDate + "' " +
					"AND _date <= '" + strEndDate + "' ";

	if(req_impact){
		sql = "SELECT date_format(viewTime,_utf8'%m%d') AS `day`, col_id,ipaddress,sessionid,COUNT(*) AS lecture_no " +
				"FROM talkview " +
				"WHERE " +
				" viewTime >= '" + strBeginDate + "' " +
				"AND viewTime <= '" + strEndDate + "' ";
	}
	if(req_posted){
		sql = "SELECT date_format(posttime,_utf8'%m%d') AS `day`, COUNT(*) AS lecture_no " +
				"FROM (SELECT col_id,MIN(lastupdate) posttime FROM " +
				"(SELECT col_id,MIN(lastupdate) lastupdate FROM col_bk GROUP BY col_id " +
				"UNION " +
				"SELECT col_id,lastupdate FROM colloquium) tpost GROUP BY col_id) pt " +
				"WHERE " +
				"posttime >= '" + strBeginDate + "' " +
				"AND posttime <= '" + strEndDate + "' ";
	}
					
	if(user_id_value != null){//User Mode
		for(int i=0;i<user_id_value.length;i++){
			if(req_posted || req_impact){
				sql += "AND col_id IN (SELECT col_id FROM colloquium WHERE owner_id=" + user_id_value[i] + ") ";
			}else{
				sql += "AND col_id IN (SELECT col_id FROM userprofile WHERE user_id=" + user_id_value[i] + ") ";
			}
		}
	}
	if(comm_id_value != null){//Community Mode
		for(int i=0;i<comm_id_value.length;i++){
			sql += "AND col_id IN (SELECT col_id FROM contribute WHERE comm_id=" + comm_id_value[i] + ") ";
		}
	}
	if(tag_id_value != null){//Tag Mode
		for(int i=0;i<tag_id_value.length;i++){
			sql += "AND col_id IN (SELECT col_id FROM tags WHERE tag_id="+ tag_id_value[i] + ") ";
		}
	}
	if(affiliate_id_value !=null ){
		for(int i=0;i<affiliate_id_value.length;i++){
			sql += "AND col_id IN " +
					"(SELECT ac.col_id FROM affiliate_col ac," +
					"(SELECT child_id FROM relation WHERE " +
					"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ affiliate_id_value[i] + "),',%')) cc " +
					"WHERE ac.affiliate_id = cc.child_id " +
					"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id_value[i] + ") ";
		}
	}
	
	if(req_impact){
		sql += "GROUP BY date_format(viewTime,_utf8'%m%d'),col_id,ipaddress,sessionid;";
	}else{
		if(req_posted){
			sql += "GROUP BY date_format(posttime,_utf8'%m%d');";
		}else{
			sql += "GROUP BY date_format(_date,_utf8'%m%d');";
		}
	}
	
	connectDB conn = new connectDB();
	ResultSet rs = conn.getResultSet(sql);
	//out.print("sql: " + sql + "<br/>");
	HashMap<String,Integer> days = new HashMap<String,Integer>();
	while(rs.next()){
		if(req_impact){
			String ipaddress = rs.getString("ipaddress");
			String sessionid = rs.getString("sessionid").trim().toLowerCase();
			int _prev_viewno = 0;
			String _day = rs.getString("day");
			if(days.containsKey(_day)){
				_prev_viewno = days.get(_day);
			}
			int viewno = 0;
			if(ipaddress.trim().length()==0||sessionid.trim().length()==0){
				viewno = rs.getInt("lecture_no");
			}else{
				viewno = 1;
			}
			days.put(_day,_prev_viewno + viewno);
		}else{
			days.put(rs.getString("day"),new Integer(rs.getInt("lecture_no")));
		}
		//out.print("day:" + rs.getString("day") + " no:" + rs.getString("lecture_no") + "<br/>");
	}	
	rs.close();
	conn.conn.close();
	conn = null;
%>
<table width="100%" border="0" id="tblCalendar" cellpadding="0" cellspacing="1">
	<tr>
		<td colspan="8">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center" style="font-size: 0.7em;cursor: pointer;color: #003399;border: 1px #003399 solid;"
						onmouseover="this.style.fontWeight='bold'"
						onmouseout="this.style.fontWeight='normal'"
						onclick="flip2Month();window.setTimeout(function(){back();},150);"
					>
						&nbsp;&lt;&nbsp;
					</td>
					<td align="center" style="color: #003399;font-size: 0.9em;font-weight: bold;"><%=months[req_month-1]%>&nbsp;<%=req_year%></td>
					<td align="center" style="font-size: 0.7em;cursor: pointer;color: #003399;border: 1px #003399 solid;"
						onmouseover="this.style.fontWeight='bold'"
						onmouseout="this.style.fontWeight='normal'"
						onclick="flip2Month();window.setTimeout(function(){next();},150);"
					>
						&nbsp;&gt;&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>   
<% // Calendar Headers: S M T W TH F S
	for (int i = 0; i < 7; i++) {
%>
		<td style="font-size: 0.85em;background-color: <%=color_week%>;" align="center" width="14.28%">
			<%=day_short[i]%>
		</td>
<%
	}  
%>
		<td style="font-size: 0.85em;background-color: <%=color_week_header%>;" align="center" width="14.28%">
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
  		String fontWeight = "normal";
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
				style += "color: #003399;border: 1px #003399 solid;font-weight: bold;";
				fontWeight = "bold";
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
			onmouseover="this.style.fontWeight = 'bold';"
			onmouseout="this.style.fontWeight = '<%=fontWeight%>';"
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
	        		style += "color: #003399;border: 1px #003399 solid;font-size: 0.7em;font-weight: bold;";
	        		fontWeight = "bold";
	        	}
%>
		<td id="week<%=(i/7+1)%>" style="<%=style%>" 
			align="right"
			onmouseover="this.style.fontWeight = 'bold';"
			onmouseout="this.style.fontWeight = '<%=fontWeight%>';"
			onclick="navWeek(this,<%=req_year%>,<%=req_month%>,<%=i/7+1%>);">
			W<%=i/7+1%>
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
	<tr>
		<td colspan="8">&nbsp;</td>
	</tr>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+path+"/";
%>
	<tr>
		<td colspan="8">
			<div id="divFeed">
				<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
					<tr>
						<td colspan="4"  bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					<tr>
						<td colspan="4" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">Feed</td>
					</tr>
					<tr>
						<td width="25%" style="font-size: 0.75em;"><a href="utils/_rss.jsp<%
							if(request.getQueryString()!=null)out.print("?"+request.getQueryString());
							if(feed_para.length() > 0)out.print(feed_para);
							%>"><img border="0" src="images/rss_feed.gif" alt="RSS 2.0" /></a></td>
						<td width="25%" style="font-size: 0.75em;"><a href="utils/_atom.jsp<%
							if(request.getQueryString()!=null)out.print("?"+request.getQueryString());
							if(feed_para.length() > 0)out.print(feed_para);
							%>"><img border="0" src="images/atom_feed.gif" alt="Atom" /></a></td>
						<td width="35%" align="right" style="font-size: 0.75em;"><a href="utils/_ical.jsp<%
							if(request.getQueryString()!=null)out.print("?"+request.getQueryString());
							if(feed_para.length() > 0)out.print(feed_para);
							%>"><img border="0" style="height: 14px;width: auto;" src="images/ical.jpg" alt="Atom" /></a></td>
						<td width="15%" align="right" style="font-size: 0.75em;">
<!-- AddThis Button BEGIN -->
<div class="addthis_toolbox addthis_default_style">
<a href="http://www.addthis.com/bookmark.php?v=250&amp;pub=chirayukong" class="addthis_button_compact"></a>
</div>
<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pub=chirayukong"></script>
<!-- AddThis Button END -->
						</td>
<%-- 
						<td align="right" width="15%" style="font-size: 0.9em;"><a href="javascript:var d=document,f='http://www.facebook.com/share',l=d.location,e=encodeURIComponent,p='.php?src=bm&v=4&i=1256076901&u='+e(l.href.concat('<%if(request.getQueryString()!=null)out.print("?"+request.getQueryString());%>'))+'&t='+e(d.title);1;try{if (!/^(.*\.)?facebook\.[^.]*$/.test(l.host))throw(0);share_internal_bookmarklet(p)}catch(z) {a=function() {if (!window.open(f+'r'+p,'sharer','toolbar=0,status=0,resizable=1,width=626,height=436'))l.href=f+p};if (/Firefox/.test(navigator.userAgent))setTimeout(a,0);else{a()}}void(0)"><img border="0" src="http://static.ak.fbcdn.net/rsrc.php/zAB5S/hash/4273uaqa.gif" alt="Facebook" /></a></td>
--%>
					</tr>	
				</table>
			</div>
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
<%
		if(request.getParameter("year")!=null){
 %>
</div>
<%
		} 
%>
		</td>
	</tr>
	<tr>
		<td>
			<div id="divExtension">&nbsp;</div>
		</td>
	</tr>
	<tr>
		<td>
<div id="divCalDebug">
	&nbsp;<%=debugText%>
</div>
		</td>
	</tr>
</table>