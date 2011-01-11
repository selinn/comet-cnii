<%@ page language="java"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<!-- calendar stylesheet -->

<%@page import="edu.pitt.sis.beans.UserBean"%><link rel="stylesheet" type="text/css" media="all" href="css/calendar-win2k-cold-1.css" title="win2k-cold-1" />

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

<% 
	session=request.getSession(false);
	String menu = (String)session.getAttribute("menu");
	String _v = (String)session.getAttribute("v");
	String t = (String)request.getParameter("t");
	String v = (String)request.getParameter("v");
	String user_id = (String)request.getParameter("user_id");
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	//Find friendship btw u and other
	if(ub!=null&&user_id!=null){
		String user0_id = user_id;
		String user1_id = "" + ub.getUserID();
		if(Integer.parseInt(user0_id) > ub.getUserID()){
			user0_id = "" + ub.getUserID();
			user1_id = user_id;
		}
		
	}
	
	if(t!=null&&menu!=null){
		if(t.equalsIgnoreCase("profile")&&menu.equalsIgnoreCase("myaccount")&&v==null){
			v="activity";
		}
	}
	
	if(_v!=null){
		v = _v;
		session.removeAttribute("v");
	}
	
	if(user_id!=null&&v==null){
		//This is ad-hoc page because we should choose v=activity if its user_id is friend of the user unless choosing v=info
		v="info";
	}
	if(t==null&&v==null){
		v="bookmark";
	}
%>
<script type="text/javascript">
	var isBookmark = 1;//0: Post;1: Bookmark;2: Impact;3: Impact Summary;4: Activity;5: Info
<% 
	if(v!=null){
		if(v.equalsIgnoreCase("post")){
%>
	isBookmark = 0;
<%			
		}
		if(v.equalsIgnoreCase("bookmark")){
%>
	isBookmark = 1;
<%			
		}
		if(v.equalsIgnoreCase("impact")){
%>
	isBookmark = 2;
<%			
		}
		if(v.equalsIgnoreCase("summary")){
%>
	isBookmark = 3;
<%			
		}
		if(v.equalsIgnoreCase("activity")){
%>
	isBookmark = 4;
<%			
		}
		if(v.equalsIgnoreCase("info")){
%>
	isBookmark = 5;
<%			
		}
	}
%>
	var period = 1;//0: day; 1: week; 2: month
	var queryString = window.location.search;
	if(queryString!=null){
		queryString = queryString.substr(1,queryString.length-1);
	}
	var oIFrame = null;
	var oTalkIFrame = null;
	var oDeleteTalkIFrame = null;
	var oCalExtIFrame = null;
	var oSelfTalkIFrame = null;
	var now = new Date();
	var _day = now.getDate();
	var _dayWeek = now.getDay();
	var _month = now.getMonth() + 1;
	var _year = now.getYear();
	if(_year < 1900){
		_year += 1900;
	}
	/***********************************************/
	/* Initialization                              */
	/***********************************************/
	window.onload = function() {
	}
	/***********************************************/
	/* Ajax Script                                 */	
	/***********************************************/
	function createIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenFrame";
			iframe.id = "hiddenFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oIFrame = frames["hiddenFrame"];
		}else{
			window.setTimeout(function(){createIFrame();},50);
		}
	}
	function createTalkIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenTalkFrame";
			iframe.id = "hiddenTalkFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oTalkIFrame = frames["hiddenTalkFrame"];
		}else{
			window.setTimeout(function(){createTalkIFrame();},50);
		}
	}
	function createDeleteTalkIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenDeleteTalkFrame";
			iframe.id = "hiddenDeleteTalkFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oDeleteTalkIFrame = frames["hiddenDeleteTalkFrame"];
		}else{
			window.setTimeout(function(){createDeleteTalkIFrame();},50);
		}
	}
	function createCalExtIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenCalExtFrame";
			iframe.id = "hiddenCalExtFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oCalExtIFrame = frames["hiddenCalExtFrame"];
		}else{
			window.setTimeout(function(){createCalExtIFrame();},50);
		}
	}
	
	function showOlderTalks(){
		if(!oSelfTalkIFrame){
			createSelfTalkIFrame();
			window.setTimeout(function(){showOlderTalks();},60);
			return;
		}else{
			var action = "utils/loadTalks.jsp?insertfirst=1";
			var queryString = window.location.search;
			if(queryString!=null){
				queryString = queryString.substr(1,queryString.length-1);
				action = action.concat('&',queryString);
			}
			oSelfTalkIFrame.location = action;
		}			
	}

	function createSelfTalkIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenSelfTalkFrame";
			iframe.id = "hiddenSelfTalkFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oSelfTalkIFrame = frames["hiddenSelfTalkFrame"];
		}else{
			window.setTimeout(function(){createSelfTalkIFrame();},50);
		}
	}

	function insertTalks(htmlTalks){
		var divMain = document.getElementById("divMain");
		divMain.innerHTML = htmlTalks.concat(divMain.innerHTML); 
		var tblOlderTalks = document.getElementById("tblOlderTalks");
		if(tblOlderTalks){
			tblOlderTalks.style.display = "none";
			tblOlderTalks.style.height = "0px";
			tblOlderTalks.style.overflow = "hidden";
		}
		var lblNoTalk = document.getElementById("lblNoTalk");
		if(lblNoTalk){
			lblNoTalk.style.display = "none";
		}		
	}

	function appendTalks(htmlTalks){
		var divMain = document.getElementById("divMain");
		divMain.innerHTML = divMain.innerHTML.concat(htmlTalks); 
	}

	function loadTalks(action){
		//divTalks.innerHTML = "<font color='red'><b>Loading...</b></font>";
		if(!oTalkIFrame){
			createTalkIFrame();
			window.setTimeout(function(){loadTalks(action);},60);
			return;
		}else{
			oTalkIFrame.location = action;
		}		
	}
	function displayTalks(htmlTalks){
		divTalks.innerHTML = htmlTalks;
	}
	function loadCalendar(action){
		if(!oIFrame){
			createIFrame();
			window.setTimeout(function(){loadCalendar(action);},60);
			return;
		}else{
			oIFrame.location = action;
		}		
	}	
	function displayCalendar(htmlCalendar){
		divCal.innerHTML = htmlCalendar;
	}
	function loadExtension(action){
		//alert(action);
		if(!oCalExtIFrame){
			//alert("No oCalExtIFrame");
			createCalExtIFrame();
			window.setTimeout(function(){loadExtension(action);},60);
			return;
		}else{
			//alert("Loading extension");
			oCalExtIFrame.location = action;
		}		
	}	
	function displayExtension(htmlExtension){
		//var divExtension = document.getElementById("divExtension");
		if(divExtension){
			divExtension.innerHTML = htmlExtension;
		}else{
			//alert("No divExtension");
		}
	}
	/***********************************************/
	/* Utility Function                            */
	/***********************************************/
	function daysInMonth(year,month){
		return 32 - (new Date(year,month-1,32)).getDate();	
	}
	function getWeekNoInMonth(year,month,day){
		var first = new Date(year,month-1,1);
		var startday = first.getDay();
		return Math.ceil((startday + day)/7);
		
	}
	/***********************************************/
	/* Account Navigation Script                   */
	/***********************************************/
	function flip2Activity(){
		divBtnActivity.style.background = "#003399";
		divBtnActivity.style.color = "#ffffff";
		divBtnActivity.style.fontWeight = "bold";
		divBtnActivity.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
		divBtnActivity.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
	
		divBtnInfo.style.background = "#ffffff";
		divBtnInfo.style.color = "#003399";
		divBtnInfo.style.fontWeight = "normal";
		divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnPost.style.background = "#ffffff";
		divBtnPost.style.color = "#003399";
		divBtnPost.style.fontWeight = "normal";
		divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnPost.style.background = "#ffffff";
		divBtnPost.style.color = "#003399";
		divBtnPost.style.fontWeight = "normal";
		divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		
		divBtnImpact.style.background = "#ffffff";
		divBtnImpact.style.color = "#003399";
		divBtnImpact.style.fontWeight = "normal";
		divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		
		divBtnImpactSummary.style.background = "#ffffff";
		divBtnImpactSummary.style.color = "#003399";
		divBtnImpactSummary.style.fontWeight = "normal";
		divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		

		isBookmark = 4;
		
		loadActivity();
	}
	function flip2Info(){
		divBtnActivity.style.background = "#ffffff";
		divBtnActivity.style.color = "#003399";
		divBtnActivity.style.fontWeight = "normal";
		divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
	
		divBtnInfo.style.background = "#003399";
		divBtnInfo.style.color = "#ffffff";
		divBtnInfo.style.fontWeight = "bold";
		divBtnInfo.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
		divBtnInfo.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		

		divBtnBookmark.style.background = "#ffffff";
		divBtnBookmark.style.color = "#003399";
		divBtnBookmark.style.fontWeight = "normal";
		divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
	
		divBtnPost.style.background = "#ffffff";
		divBtnPost.style.color = "#003399";
		divBtnPost.style.fontWeight = "normal";
		divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		
		divBtnImpact.style.background = "#ffffff";
		divBtnImpact.style.color = "#003399";
		divBtnImpact.style.fontWeight = "normal";
		divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		
		divBtnImpactSummary.style.background = "#ffffff";
		divBtnImpactSummary.style.color = "#003399";
		divBtnImpactSummary.style.fontWeight = "normal";
		divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		

		isBookmark = 5;

		loadInfo();
	}
	function flip2ImpactSummary(){
		divBtnActivity.style.background = "#ffffff";
		divBtnActivity.style.color = "#003399";
		divBtnActivity.style.fontWeight = "normal";
		divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";				
	
		divBtnInfo.style.background = "#ffffff";
		divBtnInfo.style.color = "#003399";
		divBtnInfo.style.fontWeight = "normal";
		divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnBookmark.style.background = "#ffffff";
		divBtnBookmark.style.color = "#003399";
		divBtnBookmark.style.fontWeight = "normal";
		divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
	
		divBtnPost.style.background = "#ffffff";
		divBtnPost.style.color = "#003399";
		divBtnPost.style.fontWeight = "normal";
		divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		
		divBtnImpact.style.background = "#ffffff";
		divBtnImpact.style.color = "#003399";
		divBtnImpact.style.fontWeight = "normal";
		divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		
		divBtnImpactSummary.style.background = "#003399";
		divBtnImpactSummary.style.color = "#ffffff";
		divBtnImpactSummary.style.fontWeight = "bold";
		divBtnImpactSummary.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
		divBtnImpactSummary.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		

		isBookmark = 3;
		
		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	function flip2Impact(){
		divBtnActivity.style.background = "#ffffff";
		divBtnActivity.style.color = "#003399";
		divBtnActivity.style.fontWeight = "normal";
		divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";				
	
		divBtnInfo.style.background = "#ffffff";
		divBtnInfo.style.color = "#003399";
		divBtnInfo.style.fontWeight = "normal";
		divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnBookmark.style.background = "#ffffff";
		divBtnBookmark.style.color = "#003399";
		divBtnBookmark.style.fontWeight = "normal";
		divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
	
		divBtnPost.style.background = "#ffffff";
		divBtnPost.style.color = "#003399";
		divBtnPost.style.fontWeight = "normal";
		divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		
		divBtnImpact.style.background = "#003399";
		divBtnImpact.style.color = "#ffffff";
		divBtnImpact.style.fontWeight = "bold";
		divBtnImpact.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
		divBtnImpact.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		
		divBtnImpactSummary.style.background = "#ffffff";
		divBtnImpactSummary.style.color = "#003399";
		divBtnImpactSummary.style.fontWeight = "normal";
		divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		isBookmark = 2;
		
		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	function flip2Post(){
		divBtnActivity.style.background = "#ffffff";
		divBtnActivity.style.color = "#003399";
		divBtnActivity.style.fontWeight = "normal";
		divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";				
	
		divBtnInfo.style.background = "#ffffff";
		divBtnInfo.style.color = "#003399";
		divBtnInfo.style.fontWeight = "normal";
		divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnBookmark.style.background = "#ffffff";
		divBtnBookmark.style.color = "#003399";
		divBtnBookmark.style.fontWeight = "normal";
		divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
	
		divBtnPost.style.background = "#003399";
		divBtnPost.style.color = "#ffffff";
		divBtnPost.style.fontWeight = "bold";
		divBtnPost.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
		divBtnPost.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		
		divBtnImpact.style.background = "#ffffff";
		divBtnImpact.style.color = "#003399";
		divBtnImpact.style.fontWeight = "normal";
		divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnImpactSummary.style.background = "#ffffff";
		divBtnImpactSummary.style.color = "#003399";
		divBtnImpactSummary.style.fontWeight = "normal";
		divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		isBookmark = 0;
		
		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	function flip2Bookmark(){
		divBtnActivity.style.background = "#ffffff";
		divBtnActivity.style.color = "#003399";
		divBtnActivity.style.fontWeight = "normal";
		divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";				
	
		divBtnInfo.style.background = "#ffffff";
		divBtnInfo.style.color = "#003399";
		divBtnInfo.style.fontWeight = "normal";
		divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnBookmark.style.background = "#003399";
		divBtnBookmark.style.color = "#ffffff";
		divBtnBookmark.style.fontWeight = "bold";
		divBtnBookmark.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
		divBtnBookmark.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		

		divBtnPost.style.background = "#ffffff";
		divBtnPost.style.color = "#003399";
		divBtnPost.style.fontWeight = "normal";
		divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnImpact.style.background = "#ffffff";
		divBtnImpact.style.color = "#003399";
		divBtnImpact.style.fontWeight = "normal";
		divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		divBtnImpactSummary.style.background = "#ffffff";
		divBtnImpactSummary.style.color = "#003399";
		divBtnImpactSummary.style.fontWeight = "normal";
		divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
		divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";

		isBookmark = 1;

		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	/*************************************************/
	/* User Profile Navigation Script                */
	/*************************************************/
	function loadActivity(){
		var action = "profile/activity.jsp";
		if(queryString){
			action = action.concat('?',queryString);
		}
		loadTalks(action);
	}
	function loadInfo(){
		var action = "profile/info.jsp";
		if(queryString){
			action = action.concat('?',queryString);
		}
		loadTalks(action);
	}
	/*************************************************/
	/* Calendar Navigation Script                    */
	/*************************************************/
	function flip2Day(){
		period = 0;

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

		var action = "includes/calendar.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2 || isBookmark == 3){
			action = action.concat('&impact=1');
		}	
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadCalendar(action);		
		
		action = "utils/loadTalks.jsp";
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
	function flip2Week(){
		period = 1;

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
		
		var thisweek = getWeekNoInMonth(_year,_month,_day);
		var action = "includes/calendar.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2 || isBookmark == 3){
			action = action.concat('&impact=1');
		}	
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadCalendar(action);		

		action = "utils/loadTalks.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = "utils/loadImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
			action = action.concat('&impact=1');
		}else if(isBookmark == 3){
			action = "utils/popImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
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
			//alert(action);
			loadExtension(action);		
		}			
	}
	function flip2Month(){
		period = 2;

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

		var action = "includes/calendar.jsp";
		action = action.concat('?month=',_month,'&year=',_year);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2 || isBookmark == 3){
			action = action.concat('&impact=1');
		}	
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadCalendar(action);		
		
		action = "utils/loadTalks.jsp";
		action = action.concat('?month=',_month,'&year=',_year);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = "utils/loadImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year);
			action = action.concat('&impact=1');
		}else if(isBookmark == 3){
			action = "utils/popImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year);
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
	function back(){
		var action = "";
		if(period == 0){
			_day--;
			if(_day <= 0){
				_month--;
				if(_month == 0){
					_month = 12;
					_year--;
				}
				_day = daysInMonth(_year,_month) + _day;
			}
			action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		}
		if(period == 1){
			_day -= 7;
			if(_day <= 0){
				_month--;
				if(_month == 0){
					_month = 12;
					_year--;
				}
				_day = daysInMonth(_year,_month) + _day;
			}
			var prevweek = getWeekNoInMonth(_year,_month,_day);
			action = action.concat('?month=',_month,'&year=',_year,'&week=',prevweek);
		}
		if(period == 2){
			_month--;
			if(_month == 0){
				_month = 12;
				_year--;
			}
			action = action.concat('?month=',_month,'&year=',_year);
		}
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = action.concat('&impact=1');
		}	
		//alert(action);
		if(queryString){
			action = action.concat('&',queryString);
		}
		//alert(action);
		if(isBookmark == 2){
			loadTalks("utils/loadImpact.jsp".concat(action));
		}else if(isBookmark == 3){
			loadTalks("utils/popImpact.jsp".concat(action));	
		}else{
			loadTalks("utils/loadTalks.jsp".concat(action));		
		}
		loadCalendar("includes/calendar.jsp".concat(action));
	}
	function next(){
		var action = "";
		
		if(period == 0){
			_day++;
			var days = daysInMonth(_year,_month);
			if(_day > days){
				_month++;
				if(_month == 13){
					_month = 1;
					_year++;
				}
				_day -= days;
			}
			action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		}
		if(period == 1){
			_day += 7;
			var days = daysInMonth(_year,_month);
			if(_day > daysInMonth(_year,_month)){
				_month++;
				if(_month == 13){
					_month = 1;
					_year++;
				}
				_day -= days;
			}
			var nextweek = getWeekNoInMonth(_year,_month,_day);
			action = action.concat('?month=',_month,'&year=',_year,'&week=',nextweek);
		}
		if(period == 2){
			_month++;
			if(_month == 13){
				_month = 1;
				_year++;
			}
			action = action.concat('?month=',_month,'&year=',_year);
		}
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = action.concat('&impact=1');
		}	
		if(queryString){
			action = action.concat('&',queryString);
		}
		if(isBookmark == 2){
			loadTalks("utils/loadImpact.jsp".concat(action));			
		}else if(isBookmark == 3){
			loadTalks("utils/popImpact.jsp".concat(action));	
		}else{
			loadTalks("utils/loadTalks.jsp".concat(action));		
		}
		loadCalendar("includes/calendar.jsp".concat(action));
	}
	function deleteCols(){
		if(document.talkForm && document.talkForm.length > 2){
				if(!oDeleteTalkIFrame){
					createDeleteTalkIFrame();
					window.setTimeout(function(){deleteCols();},50); 
				}else{
					var cols = "";
					if(document.talkForm.length == 3){
						cols = document.talkForm.deleted.value;			
					}else{//deleted as array
						for(var i=0;i<document.talkForm.deleted.length;i++){
							if(document.talkForm.deleted[i].checked){
								cols = cols.concat(document.talkForm.deleted[i].value,',');
							}
						}
						if(cols.length > 1){
							cols = cols.substr(0,cols.length-1);
						}
					}		
					if(cols.length > 0){
						var action = "utils/deleteTalks.jsp?col_id=".concat(cols);
						if(isBookmark == 0){
							action = action.concat('&post=1');
						}else if(isBookmark == 2){
							action = action.concat('&impact=1');
						}	
						oDeleteTalkIFrame.location = action;
						window.setTimeout(
							function(){
								alert("Delete Talk(s) Successful!");
								refreshTalks();
							},100);
					}
				}
		}else if(document.getElementById("deleted0")){
			if(!oDeleteTalkIFrame){
				createDeleteTalkIFrame();
				window.setTimeout(function(){deleteCols();},50); 
			}else{
				var cols = "";
				for(var i=0;true;i++){
					var deleted = document.getElementById("deleted" + i);
					if(deleted){
						if(deleted.checked){
							cols = cols.concat(deleted.value,',');
						}
					}else{
						break;
					}	
				}	
				if(cols.length > 1){
					cols = cols.substr(0,cols.length-1);
				}
				if(cols.length > 0){
					var action = "utils/deleteTalks.jsp?col_id=".concat(cols);
					if(isBookmark == 0){
						action = action.concat('&post=1');
					}else if(isBookmark == 2){
						action = action.concat('&impact=1');
					}	
					oDeleteTalkIFrame.location = action;
					window.setTimeout(
						function(){
							alert("Delete Talk(s) Successful!");
							refreshTalks();
						},100);
				}
			}
		}		
	}
	function redirect(html){
		window.location = html;
	}
	function refreshTalks(){
		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	function fillInfo(){
		var infoFrame = top.infoFrame;
		if(infoFrame){
			infoFrame.document.forms[0].elements["user_id"].value = document.getElementById("user_id").value;	
			infoFrame.document.forms[0].elements["name"].value = document.getElementById("name").value;	
			infoFrame.document.forms[0].elements["email"].value = document.getElementById("email").value;	
			infoFrame.document.forms[0].elements["location"].value = document.getElementById("location").value;
			infoFrame.document.forms[0].elements["job"].value = document.getElementById("job").value;
			infoFrame.document.forms[0].elements["affiliation"].value = document.getElementById("affiliation").value;
			infoFrame.document.forms[0].elements["website"].value = document.getElementById("website").value;
			infoFrame.document.forms[0].elements["aboutme"].value = document.getElementById("aboutme").value;
			infoFrame.document.forms[0].elements["interests"].value = document.getElementById("interests").value;
			infoFrame.document.forms[0].submit();
		}
	}
	function cancelEditInfo(){
		if(btnCancelEditInfo.value == "Edit"){
			btnCancelEditInfo.value = "Cancel";
			if(divInfo){
				divInfo.style.display = "none";
			}
			if(divEditInfo){
				divEditInfo.style.display = "block";
			}
			btnEditInfo.style.width = "auto";
			btnEditInfo.style.visibility = "visible";
			btnEditInfo.style.display = "inline";
			btnEditInfo.style.overflow = "visible";

			var infoFrame = top.infoFrame;
			if(!infoFrame.document.forms[0]){
				infoFrame.location = "profile/infoEntry.jsp";
			}

			displayUpdatingInfo();
			
			updateError.innerHTML = "";
			nameError.innerHTML = "";
			emailError.innerHTML = "";
		}else{
			btnCancelEditInfo.value = "Edit";
			btnEditInfo.disabled = false;
			btnCancelEditInfo.disabled = false;
			if(divEditInfo){
				divEditInfo.style.display = "none";
			}
			if(divInfo){
				divInfo.style.display = "block";
			}
			btnEditInfo.style.width = "0px";
			btnEditInfo.style.visibility = "hidden";
			btnEditInfo.style.display = "none";
			btnEditInfo.style.overflow = "hidden";

			infoDesc.innerHTML = "";	
		}	
	}	
	function updateInfo(){
		var infoFrame = top.infoFrame;
		if(!infoFrame.document.forms[0]){
			infoFrame.location = "profile/infoEntry.jsp";
			window.setTimeout(function(){updateInfo();},100);
		}
		btnEditInfo.disabled = true;
		btnCancelEditInfo.disabled = true;
		fillInfo();
	}
	function displayUpdateInfoError(error){
		updateError.innerHTML = error;
		btnEditInfo.disabled = false;
		btnCancelEditInfo.disabled = false;
	}
	function displayNameInfoError(error){
		nameError.innerHTML = error;
		btnEditInfo.disabled = false;
		btnCancelEditInfo.disabled = false;
	}
	function displayEmailInfoError(error){
		emailError.innerHTML = error;
		btnEditInfo.disabled = false;
		btnCancelEditInfo.disabled = false;
	}
	function displayUpdatedInfo(){
		document.getElementById("infoName").innerHTML = document.getElementById("name").value;	
		document.getElementById("infoEmail").innerHTML = document.getElementById("email").value;	
		document.getElementById("infoLocation").innerHTML = document.getElementById("location").value;	
		document.getElementById("infoJob").innerHTML = document.getElementById("job").value;	
		document.getElementById("infoAffiliation").innerHTML = document.getElementById("affiliation").value;	
		document.getElementById("infoWebsite").innerHTML = document.getElementById("website").value;	
		document.getElementById("infoAboutme").innerHTML = document.getElementById("aboutme").value;	
		document.getElementById("infoInterests").innerHTML = document.getElementById("interests").value;
		cancelEditInfo();
		infoDesc.innerHTML = "Update your information successfully";	
	}
	function displayUpdatingInfo(){
		document.getElementById("name").value = document.getElementById("infoName").innerHTML;	
		document.getElementById("email").value = document.getElementById("infoEmail").innerHTML;	
		document.getElementById("location").value = document.getElementById("infoLocation").innerHTML;	
		document.getElementById("job").value = document.getElementById("infoJob").innerHTML;	
		document.getElementById("affiliation").value = document.getElementById("infoAffiliation").innerHTML;	
		document.getElementById("website").value = document.getElementById("infoWebsite").innerHTML;	
		document.getElementById("aboutme").value = document.getElementById("infoAboutme").innerHTML;	
		document.getElementById("interests").value = document.getElementById("infoInterests").innerHTML;
	}
	function showAddFriendDialog(){
		var divAddFriend = document.getElementById("divAddFriend");
		divAddFriend.style.display = "block";
	}
	function hideAddFriendDialog(){
		var divAddFriend = document.getElementById("divAddFriend");
		divAddFriend.style.display = "none";
	}
</script>
<logic:notPresent name="UserSession">
<% 
	String pagePath = "";
	if(menu.equalsIgnoreCase("calendar")){
		pagePath = "calendar.do";
	} 
	if(menu.equalsIgnoreCase("myaccount")){
		pagePath = "myaccount.do";
	}
	if(menu.equalsIgnoreCase("community")){
		pagePath = "community.do";
	}
	if(menu.equalsIgnoreCase("series")){
		pagePath = "series.do";
	}
	
	if(request.getQueryString()!=null){
		pagePath += "?" + request.getQueryString();
	} 
	session.setAttribute("before-login-redirect", pagePath);
%>
</logic:notPresent>

<%	
	String redirect = (String)session.getAttribute("redirect");
	if(redirect != null){
		session.removeAttribute("redirect");
%>
	<script>
		window.location="<%=redirect%>";
	</script>
<%
	}		
%>

<div align="center">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
<% 
	if(user_id != null){// && menu.equalsIgnoreCase("profile")){
%>
		<tr>
			<td align="left">
<% 
		connectDB conn = new connectDB();
		String sql = "SELECT name FROM userinfo WHERE user_id = " + user_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String _username = rs.getString("name");
%>
		&nbsp;<span style="color: #003399;font-size: 0.9em;font-weight: bold;"><%=_username %></span>&nbsp;
<% 
			if(ub!=null){
				String user0_id = user_id;
				String user1_id = "" + ub.getUserID();
				if(!user0_id.equalsIgnoreCase(user1_id)){
					
					if(Integer.parseInt(user_id) > ub.getUserID()){
						user0_id = "" + ub.getUserID();
						user1_id = user_id;
					}
					
					sql = "SELECT friend_id FROM friend WHERE user0_id=" + user0_id + " AND user1_id=" + user1_id + 
						" AND breaktime IS NULL";
					
					rs = conn.getResultSet(sql);
					if(rs.next()){
						String friend_id = rs.getString("friend_id");
					}else{//They are not friends. So is there any befriending request?
						
						sql = "SELECT request_id FROM request WHERE user_id=" + ub.getUserID() + " AND target_id=" + user_id + 
							" AND droprequesttime IS NULL";
						
						rs = conn.getResultSet(sql);
						if(rs.next()){
							String request_id = rs.getString("request_id");
						}else{
%>
		<input class ="btn" type="button" id="btnAddAsFriend" value="Add as Friend" onclick="showAddFriendDialog();return false;" />
		<div style="z-index: 1000;position: absolute;display: none;background-color: #fff;text-align: center;width: 300px;" 
			id="divAddFriend">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
						&nbsp;Send <%=_username %> a friend request?
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
							<tr>
								<td align="right" width="85%"><input class="btn" type="button" value="Send Request" onclick="hideAddFriendDialog();return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog();return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
<%		
						}
					}
				}
			}
		}else{
%>
		User Not Found
<%		
		}
		conn.conn.close();
		conn = null;
%>
			</td>
		</tr>
<%
	}
	if(menu.equalsIgnoreCase("myaccount") || menu.equalsIgnoreCase("profile")){
%>
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="90">
<% 
		if(t!=null){
%>
							<div id="divBtnActivity" 
<% 
			if(v.equalsIgnoreCase("activity")){
%>
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
<%			
			}else{
%>
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
<%			
			}
%>
								align="center"
								onclick="flip2Activity();">
								Wall
							</div>
<%			
		}else{
%>
							<div id="divBtnActivity" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='profile.do?v=activity<%if(user_id!=null)out.print("&user_id="+user_id);%>'">
								Wall
							</div>
<%			
		}
%>
						</td>
						<td width="90">
<% 
		if(t!=null){
%>
							<div id="divBtnInfo" 
<% 
			if(v.equalsIgnoreCase("info")){
%>
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
<%			
			}else{
%>
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
<%			
			}
%>
								align="center"
								onclick="flip2Info();">
								Info
							</div>
<%		
		}else{
%>
							<div id="divBtnInfo" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='profile.do?v=info<%if(user_id!=null)out.print("&user_id="+user_id);%>'">
								Info
							</div>
<%		
		}
%>
						</td>
						<td width="90">
<% 
		if(t==null&&v.equalsIgnoreCase("bookmark")){
%>
							<div id="divBtnBookmark" 
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
								align="center"
								onclick="flip2Bookmark();">
								Bookmark
							</div>
<%
		}else if(t==null){
%>
							<div id="divBtnBookmark" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2Bookmark();">
								Bookmark
							</div>
<%
		}else if(menu.equalsIgnoreCase("myaccount")){
%>
							<div id="divBtnBookmark" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='myaccount.do?v=bookmark<%if(request.getQueryString()!=null)out.print("&"+request.getQueryString());%>'">
								Bookmark
							</div>
<%		
		}else{
%>
							<div id="divBtnBookmark" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='calendar.do?v=bookmark<%if(request.getQueryString()!=null)out.print("&"+request.getQueryString());%>'">
								Bookmark
							</div>
<%		
		}
%>
						</td>
						<td width="90">
<% 
		if(t==null&&v.equalsIgnoreCase("post")){
%>
							<div id="divBtnPost" 
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
								align="center"
								onclick="flip2Post();">
								Post
							</div>
<% 
		}else if(t==null){
%>
							<div id="divBtnPost" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2Post();">
								Post
							</div>
<% 
		}else if(menu.equalsIgnoreCase("myaccount")){
%>
							<div id="divBtnPost" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='myaccount.do?v=post<%if(request.getQueryString()!=null)out.print("&"+request.getQueryString());%>'">
								Post
							</div>
<%		
		}else{
%>
							<div id="divBtnPost" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='calendar.do?v=post<%if(request.getQueryString()!=null)out.print("&"+request.getQueryString());%>'">
								Post
							</div>
<%		
		}
%>
						</td>
						<td width="90">
<% 
		if(t==null&&v.equalsIgnoreCase("impact")){
%>
							<div id="divBtnImpact" 
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
								align="center"
								onclick="flip2Impact();">
								Impact
							</div>
<% 
		}else if(t==null){
%>
							<div id="divBtnImpact" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2Impact();">
								Impact
							</div>
<% 
		}else if(menu.equalsIgnoreCase("myaccount")){
%>
							<div id="divBtnImpact" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='myaccount.do?v=impact<%if(request.getQueryString()!=null)out.print("&"+request.getQueryString());%>'">
								Impact
							</div>
<% 
		}else{
%>
							<div id="divBtnImpact" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='calendar.do?v=impact<%if(request.getQueryString()!=null)out.print("&"+request.getQueryString());%>'">
								Impact
							</div>
<% 
		}
%>
						</td>
						<td width="140">
<% 
		if(t==null&&v.equalsIgnoreCase("summary")){
%>
							<div id="divBtnImpactSummary" 
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
								align="center"
								onclick="flip2ImpactSummary();">
								Impact Summary
							</div>
<% 
		}else if(t==null){
%>
							<div id="divBtnImpactSummary" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2ImpactSummary();">
								Impact Summary
							</div>
<% 
		}else if(menu.equalsIgnoreCase("myaccount")){
%>
							<div id="divBtnImpactSummary" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='myaccount.do?v=summary<%if(request.getQueryString()!=null)out.print("&"+request.getQueryString());%>'">
								Impact Summary
							</div>
<% 
		}else{
%>
							<div id="divBtnImpactSummary" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='calendar.do?v=summary<%if(request.getQueryString()!=null)out.print("&"+request.getQueryString());%>'">
								Impact Summary
							</div>
<% 
		}
%>
						</td>
						<td>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
<%	
	}
%>		
<tr>
	<td>&nbsp;</td>
</tr>
<%	
	if((menu.equalsIgnoreCase("profile") || menu.equalsIgnoreCase("calendar") || menu.equalsIgnoreCase("myaccount"))&&t==null){	
%>
		<tr>
			<td align="center">
				<table width="350" border="0" cellpadding="0" cellspacing="0" style="font-size:0.9em;">
					<tr>
						<td width="40">
							<div id="divBtnBack" style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="back();">
								&laquo;
							</div>
						</td>
						<td width="90">
							<div id="divBtnDay" style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2Day();">
								Day
							</div>
						</td>
						<td width="90">
							<div id="divBtnWeek" style="font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
								align="center"
								onclick="flip2Week();">
								Week
							</div>
						</td>
						<td width="90">
							<div id="divBtnMonth" style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2Month();">
								Month
							</div>
						</td>
						<td width="40">
							<div id="divBtnNext" style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="next();">
								&raquo;
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
<% 
	}
%>
		<tr>
			<td>
				<div id="divTalks">
					<script type="text/javascript">
<% 
	if(menu.equalsIgnoreCase("calendar")){
%>
						window.setTimeout(function(){flip2Week();},50);
<%		
	}else if(menu.equalsIgnoreCase("community")||menu.equalsIgnoreCase("series")||menu.equalsIgnoreCase("tag")||menu.equalsIgnoreCase("entity")){
%>
						var action = "utils/loadTalks.jsp<%if(request.getQueryString()!=null)out.print("?"+request.getQueryString());%>";
						window.setTimeout(function(){loadTalks(action);},50);
<%		
	}else if(v.equalsIgnoreCase("info")){
%>
						window.setTimeout(function(){flip2Info();},50);
<%		
	}else if(v.equalsIgnoreCase("activity")){
%>
						window.setTimeout(function(){flip2Activity();},50);
<%		
	}else if(v.equalsIgnoreCase("bookmark")){
%>
						window.setTimeout(function(){flip2Bookmark();},50);
<%		
	}else if(v.equalsIgnoreCase("post")){
%>
						window.setTimeout(function(){flip2Post();},50);
<%		
	}else if(v.equalsIgnoreCase("impact")){
%>
						window.setTimeout(function(){flip2Impact();},50);
<%		
	}else if(v.equalsIgnoreCase("summary")){
%>
						window.setTimeout(function(){flip2ImpactSummary();},50);
<%		
	}else{
%>
						var action = "utils/loadTalks.jsp<%if(request.getQueryString()!=null)out.print("?"+request.getQueryString());%>";
						window.setTimeout(function(){loadTalks(action);},50);
<%		
	}
%>
					</script>
				</div>
			</td>
		</tr>
	</table>
</div>