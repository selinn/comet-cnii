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
<script src="ckeditor/_samples/sample.js" type="text/javascript"></script> 
<link href="ckeditor/_samples/sample.css" rel="stylesheet" type="text/css"/>		
<%-- Google Image Search API key genreated for halley machine from comet.paws google account --%>
<script src="https://www.google.com/jsapi?key=ABQIAAAAMDjC-1uomIqhzN4msnE4IRQpTBFSIt8SiVR52l2HcI54kgEULhQoHDiiDq1H2vDXjIv2FeimoAHnpQ"></script>

<script type="text/javascript">
    var counter = 0;

      google.load('search', '1');

      var imageSearch;
	  
	  //show more pages
	  function addPaginationLinks() {
        // To paginate search results, use the cursor function.
        var cursor = imageSearch.cursor;
        var curPage = cursor.currentPageIndex; // check what page the app is on
        var pagesDiv = document.createElement('div');
        pagesDiv.id = "pageDiv";
        for (var i = 0; i < cursor.pages.length; i++) {
          var page = cursor.pages[i];
          if (curPage == i) { 

          // If we are on the current page, then don't make a link.
            var label = document.createTextNode('  ' + page.label + '  ');
            
            pagesDiv.appendChild(label);
          } else {

            // Create links to other pages using gotoPage() on the searcher.
            var link = document.createElement('a');
            link.href = 'javascript:imageSearch.gotoPage('+i+');';
            link.innerHTML = page.label;
            link.style.marginRight = '4px';
            link.style.marginLeft = '4px';
            pagesDiv.appendChild(link);
          }
        }

        //var contentDiv = document.getElementById('content_' + counter);
        var contentDiv = document.getElementById('content');
        contentDiv.appendChild(pagesDiv);
      }

     

      function searchComplete() {
    	
        // Check that we got results
        if (imageSearch.results && imageSearch.results.length > 0) {

          // Grab our content div, clear it.
          //var contentDiv = document.getElementById('content_'+counter);
          var contentDiv = document.getElementById('content');
          contentDiv.innerHTML = '';

          // Loop through our results, printing them to the page.
          var results = imageSearch.results;
          for (var i = 0; i < results.length; i++) {
            // For each result write it's title and image to the screen
            var result = results[i];
            
            var imgContainer = document.createElement('div');
            imgContainer.id = "picDiv";
            
            var imgContainerInside = document.createElement('div');
            imgContainerInside.id = "imgDiv";
            
            var rdoContainer = document.createElement('div');
            rdoContainer.id = "rdoDiv";
            
            var newImg = document.createElement('img');
            
            // There is also a result.url property which has the escaped version
            newImg.src = result.tbUrl;
            imgContainerInside.appendChild(newImg);
            var rdo = document.createElement('input');
            rdo.type = 'radio';
            rdo.id = i;
            rdo.name = 'picture_url';
            rdo.value = result.tbUrl;
            rdo.onclick= function() {showImg(this.value);};
            rdoContainer.appendChild(rdo);
            
            imgContainer.appendChild(imgContainerInside);
            imgContainer.appendChild(rdoContainer);
            // Put our image in the content
            contentDiv.appendChild(imgContainer);
            //alert("haha");
          }
			

          // Now add links to additional pages of search results.
          addPaginationLinks(imageSearch);
        }
      }
	  
      function showImg(src){
    	  //var image = document.getElementById('imgDisplay_'+counter);
    	  var image = document.getElementById('imgDisplay');
    	  image.src = src;
      }
      
      function searchImage(imagekeyword){
    	 
        	// Create an Image Search instance.
        	imageSearch = new google.search.ImageSearch(); 		
        	imageSearch.setRestriction(google.search.ImageSearch.RESTRICT_IMAGETYPE, google.search.ImageSearch.IMAGETYPE_FACES);		         
        	// Set searchComplete as the callback function when a search is          
        	// complete.  The imageSearch object will have results in it.          
        	imageSearch.setSearchCompleteCallback(this, searchComplete, null);         
        	// execute search
          	imageSearch.execute(imagekeyword);               
        	// Include the required Google branding         
          	//google.search.Search.getBranding('branding');
        
     }

      var nameArray = new Array();
		var affiliationArray = new Array();

function addTeacherElement() {
		
		var name = document.getElementById('nameInput');
		var affiliation = document.getElementById('affiliationInput');
		var image = document.getElementById('imgDisplay');
		
		if (affiliation.value == ''){
			alert("Please enter the affiliation of speaker.");
			return;
		}
		//var lastOne = counter - 1;
		/* if (counter > 1 && (document.getElementById('speaker_'+lastOne) != null) ){
			
			document.getElementById('speaker_'+lastOne).setAttribute('disabled', 'disabled');
			document.getElementById('affiliation_'+lastOne).setAttribute('disabled', 'disabled');
			document.getElementById('selectImg_'+lastOne).style.visibility = "hidden";
			document.getElementById('content_'+lastOne).style.visibility = "hidden";
			
		} */
		var container = document.getElementById('speaker_container');		
		var trObj = document.createElement('tr');
		trObj.setAttribute('id','speaker_tr_' + counter);	
		//var trObj2 = document.createElement('tr');
				
		var tdLabelObj = document.createElement('td');
		/* var speakerLabelObj = document.createElement('label');
		speakerLabelObj.innerHTML ="Speaker ";
		speakerLabelObj.style.fontWeight = "bold";		
		tdLabelObj.appendChild(speakerLabelObj); */	
		trObj.appendChild(tdLabelObj);
			
		/* speakerObj.setAttribute('type', 'text');
		speakerObj.setAttribute('id','speaker_'+counter);
		speakerObj.setAttribute('name',counter);
		speakerObj.setAttribute('size','50');
		speakerObj.setAttribute('value', name); */
		/* speakerObj.onfocus = function(){
			return speakerObj.name;
		}; */
		//speakerObj.setAttribute('value', grade_no);
		var tdSpeakerObj = document.createElement('td');
		//tdSpeakerObj.style.width = "420px"
		
		var tab = document.createElement('table');
		tab.setAttribute('class', 'showSpeakers');
		
		var tr1 = document.createElement('tr');
		var tr2 = document.createElement('tr');
		
		var tdImage = document.createElement('td');
		tdImage.setAttribute('rowspan', 2);
		var imageObj = document.createElement('img');
		imageObj.setAttribute('src', image.src);
		tdImage.appendChild(imageObj);
		
		var tdName = document.createElement('td');
		var nameObj = document.createElement('label');
		nameObj.innerHTML = "<b>Name:</b> " + name.value;
		tdName.appendChild(nameObj);
		
		tr1.appendChild(tdImage);
		tr1.appendChild(tdName);
		
		
		var tdAffiliation = document.createElement('td');
		var affiliationLabelObj = document.createElement('label');
		affiliationLabelObj.innerHTML ="<b>Affiliation:</b> " + affiliation.value;	
		//affiliationLabelObj.style.fontWeight = "bold";
		//var tdLabelObj2 = document.createElement('td');
		tdAffiliation.appendChild(affiliationLabelObj);	
		//trObj.appendChild(tdLabelObj2);
		tr2.appendChild(tdAffiliation);
	
		tab.appendChild(tr1);
		tab.appendChild(tr2);
		tdSpeakerObj.appendChild(tab);
		
		var tdReoveObj = document.createElement('td');
		
		var buttonObj = document.createElement('input');
		buttonObj.setAttribute('type','button');
		buttonObj.setAttribute('name', counter);
		buttonObj.setAttribute('value','Remove');
		buttonObj.style.float = "right";
		
		buttonObj.onclick = function(){
			//trObj.parentNode.removeChild(trObj2);
			trObj.parentNode.removeChild(trObj);
			nameArray[this.name] = '';
			affiliationArray[this.name] = '';
			/* var speakers = document.getElementById('speaker').value.split(";;");
			document.getElementById('speaker').value = "";
			speakers[this.name - 1] = '';
			for (var i = 0; i < speakers.length - 1; i++)
				document.getElementById('speaker').value += speakers[i] + ";;"; */
		}; 	
		
		tdReoveObj.appendChild(buttonObj); 

		
		/* var affiliationObj = document.createElement('input');
		affiliationObj.setAttribute('type', 'text');
		affiliationObj.setAttribute('id','affiliation_'+counter);
		affiliationObj.setAttribute('name','affiliation_'+counter);
		affiliationObj.setAttribute('size','40');
		//affiliationObj.setAttribute('value', grade_no);
		//var tdAffiliationObj = document.createElement('td');
		tdSpeakerObj.appendChild(affiliationObj);	
		//trObj.appendChild(tdAffiliationObj); */
		

// 	if (document.getElementById("image")){
// 		var existEl = document.getElementById("image");
// 		existEl.setAttribute('id','imageExisted');
// 		var existEl2 = document.getElementById("content");
// 		existEl2.setAttribute('id','contentExisted');
// 		var existEl3 = document.getElementById("selectImg");
// 		existEl3.setAttribute('id','selectImgExisted');
// 		var existEl4 = document.getElementById("imgDisplay");
// 		existEl4.setAttribute('id','imgDisplayExisted');
// 	}
	
	/* var tdImageObj = document.createElement('td');
	tdImageObj.style.verticalAlign = "top";
	var imageObj = document.createElement('div');
	imageObj.setAttribute('id','image_'+counter);
	var buttonObj = document.createElement('input');
	buttonObj.setAttribute('id','selectImg_'+counter);
	buttonObj.setAttribute('type','button');
	//buttonObj.setAttribute('value', 'Not this Picture?');
	
	buttonObj.style.visibility = "hidden";
	buttonObj.style.margin = "5px 0";
	
	tdImageObj.appendChild(imageObj);	
	tdImageObj.appendChild(buttonObj);
	trObj2.appendChild(tdImageObj); */
	
	/* var tdContentObj = document.createElement('td');
	var contentObj = document.createElement('div');
	contentObj.setAttribute('id','content_'+counter);
	tdContentObj.appendChild(contentObj);	
	trObj2.appendChild(tdContentObj); */
	
	
	trObj.appendChild(tdSpeakerObj);
	trObj.appendChild(tdReoveObj);
	container.appendChild(trObj);
	//container.appendChild(trObj2);
	nameArray[counter] = name.value;
	affiliationArray[counter] = affiliation.value;
	
	
	
	name.value = '';
	affiliation.value = '';
	document.getElementById('selectImg').style.visibility = "hidden";
	document.getElementById('image').style.visibility = "hidden";
	document.getElementById('content').style.visibility = "hidden";
	
	counter++;
}

function submitform()
{
	
	var speakerAffiliation = document.getElementById('affiliation');
	var speakerName = document.getElementById('speaker');
	for(var i = 0; i < nameArray.length; i++){
		speakerName.value += nameArray[i] + ";;";
		if (affiliationArray[i] == '')
			affiliationArray[i] = 'null';
		speakerAffiliation.value += affiliationArray[i] + ";;";
	}
	//alert(speakerName.value + "!!!!!!" + speakerAffiliation.value);
  	document.forms[1].submit();
}

$(document).ready(function() {
	
	/* if (counter > 1){
		$("input").focus(function () {
	        counter = $(this).attr("name");
	        
	   });
	} */
	   
	  $("input#series").autocomplete("utils/series.jsp", {
		  	delay: 20,
			formatItem: function(data, i, n, value) {			
				return  value.split(";")[0];
					
			},
	  		formatResult: function(data, value) {
				return value.split(";")[0];
			}
	  }).result(function(event, data, formatted) {
		  $("input#series_id").val(formatted.split(";")[1]);
	  }); 	  
	
	  $("input#nameInput").autocomplete("utils/speakers.jsp", {
		  	delay: 20,
			formatItem: function(data, i, n, value) {
				var imageSrc = value.split(";")[2];
				if (imageSrc != "null"){
					if (imageSrc.indexOf("http") != 0){
						imageSrc = "images/speaker/" + imageSrc;
					}
					return "<table><tr><td rowspan=\"2\">" + "<img src='" + imageSrc + "' height=\"50\" width=\"50\" /> </td>" 
					+ "<td style=\"font-size:12px\"><b>" + value.split(";")[0] + "</b></td></tr><tr><td style=\"font-size:11px\">" + value.split(";")[1] +"</td></tr></table>";
				
				}
				else{
					return "<table><tr><td rowspan=\"2\">" + "<img src='images/speaker/avartar.gif' height=\"50\" width=\"50\" /> </td>" 
					+ "<td style=\"font-size:12px\"><b>" + value.split(";")[0] + "</b></td></tr><tr><td style=\"font-size:11px\">" + value.split(";")[1] +"</td></tr></table>";
				}
				
			},
	  		formatResult: function(data, value) {
				return value.split(";")[0];
			}
	  }).result(function(event, data, formatted) {
		  
		  if (data){
			  $("input#affiliationInput").val(formatted.split(";")[1]);
			  //$("#trShowImage").css("visibility", "visible");
			 
			  var imageSrc = formatted.split(";")[2];
			  if (imageSrc != "null"){
				  if (imageSrc.indexOf("http") != 0){
						imageSrc = "images/speaker/" + imageSrc;			
				  }
				  $("input#selectImg").css("visibility", "visible");
				  $("div#content").css("visibility", "visible");
				  $("div#image").css("visibility", "visible");
				  $("input#selectImg").val("Not this person?");	 					
				  $("div#image").html("<img id='imgDisplay' src='" + imageSrc + "' />");
				  
			  }else{
				  imageSrc = "images/speaker/avartar.gif";
				  $("input#selectImg").css("visibility", "visible");
				  $("div#content").css("visibility", "visible");
				  $("div#image").css("visibility", "visible");
				  $("input#selectImg").val("Select a picture");
				  $("div#image").html("<img id='imgDisplay' src='" + imageSrc + "' />");
				 
				  
			  }
		  }	else{
			  imageSrc = "images/speaker/avartar.gif";
			  $("input#selectImg").css("visibility", "visible");
			  $("div#content").css("visibility", "visible");
			  $("div#image").css("visibility", "visible");
			  $("input#selectImg").val("Select a picture");
			  $("div#image").html("<img id='imgDisplay' src='" + imageSrc + "' />");
			  
		  } 
		  		  		  
	  }).blur(function(){
		    $(this).search();
	  });	  
	 
});
	  
	  /* $("input#nameInput").autocomplete("speakers.jsp", {
		  	delay: 20,
			formatItem: function(data, i, n, value) {
				var imageSrc = value.split(";")[2];
				if (imageSrc != "null"){
					if (imageSrc.indexOf("http") != 0){
						imageSrc = "images/speaker/" + imageSrc;
					}
					return "<table><tr><td rowspan=\"2\">" + "<img src='" + imageSrc + "' height=\"50\" width=\"50\" /> </td>" 
					+ "<td style=\"font-size:12px\"><b>" + value.split(";")[0] + "</b></td></tr><tr><td style=\"font-size:11px\">" + value.split(";")[1] +"</td></tr></table>";
				
				}
				else{
					return "<table><tr><td rowspan=\"2\">" + "<img src='images/speaker/avartar.gif' height=\"50\" width=\"50\" /> </td>" 
					+ "<td style=\"font-size:12px\"><b>" + value.split(";")[0] + "</b></td></tr><tr><td style=\"font-size:11px\">" + value.split(";")[1] +"</td></tr></table>";
				}
				
			},
	  		formatResult: function(data, value) {
				return value.split(";")[0];
			}
	  }).result(function(event, data, formatted) {
		  
		  if (data){
			  $("input#affiliationInput").val(formatted.split(";")[1]);
			  
			  var imageSrc = formatted.split(";")[2];
			  if (imageSrc != "null"){
				  if (imageSrc.indexOf("http") != 0){
						imageSrc = "images/speaker/" + imageSrc;			
				  }
				  $("input#selectImg_"+counter).css("visibility", "visible");
				  $("input#selectImg_"+counter).val("Not this person?");	 					
				  $("div#image_"+counter).html("<img id='imgDisplay_" + counter + "' src='" + imageSrc + "' />");
				  $("#selectImg_"+counter).click(function(){
					  searchImage($("#speaker_"+counter).val(), counter);
				  });
				  
			  }else{
				  imageSrc = "images/speaker/avartar.gif";
				  $("input#selectImg_"+counter).css("visibility", "visible");
				  $("input#selectImg_"+counter).val("Select a picture");
				  $("div#image_"+counter).html("<img id='imgDisplay_" + counter + "' src='" + imageSrc + "' />");
				  $("#selectImg_"+counter).click(function(){
					  searchImage(formatted.split(";")[0], counter);
				  });
				  
			  }
		  }	else{
			  imageSrc = "images/speaker/avartar.gif";
			  
			  $("input#selectImg_"+counter).css("visibility", "visible");
			  $("input#selectImg_"+counter).val("Select a picture");
			  $("div#image_"+counter).html("<img id='imgDisplay_" + counter + "' src='" + imageSrc + "' />");
			  $("#selectImg_"+counter).click(function(){
				  searchImage($("input#speaker_"+counter).val(), counter);
			  });
			  
		  } 
		  		  		  
	  }).blur(function(){
		    $("input#speaker").val(function(index, value) {		    	
		    	  return value + $("input#speaker_"+counter).val() + ';;';
		    });
		    $("input#affiliation").val(function(index, value) {		    	
		    	  return value + $("input#affiliation_"+counter).val() + ';;';
		    });
		    $(this).search();
	  });	  
	 
  }); */
  
  
</script>
	
<logic:present name="Colloquium">
<% 
	ColloquiumForm cqf = (ColloquiumForm)session.getAttribute("Colloquium");
	String title = cqf.getTitle();
	long col_id = cqf.getCol_id();
%>
<span style="font-size: 0.8em;font-weight: bold;color: green;text-decoration: none;">
	<a style="text-decoration: none;" href="presentColloquium.do?col_id=<%=col_id %>"><%=title %></a> was Submitted Successfully!
</span>
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
.showSpeakers{
	font-size: 1em;
}
 ul li{
     list-style-type:none;
     margin:0;
     padding:0;
     margin-left:8px;
 }
 #content{
 	margin:5px 0px;
	margin-bottom: 20px;
 	float: left;
 }
 #picDiv{
 	margin:5px 20px;
 	margin-left: 0;
 	float: left;
 }
  #pageDiv{
  	clear:both;
  	margin: 15px 0;
 	text-align: center;
 	padding:0 3px;
 }
  #rdoDiv{;
 	margin: 5px 40px;
 	
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
	String paper_url = "";
	String video_url = "";
	String slide_url = "";
	String s_bio = "";
	HashSet<String> sponsorSet = new HashSet<String>();
	HashSet<String> pathSet = new HashSet<String>();

	String sql = "SELECT c.col_id,c.title,s.name,s.affiliation,h.host,date_format(c._date,_utf8'%m/%d/%Y') _date," +
					"date_format(c.begintime,_utf8'%l %i %p') _begin," +
					"date_format(c.endtime,_utf8'%l %i %p') _end,c.location,c.detail,c.url,c.video_url,c.slide_url,c.s_bio,c.paper_url " +
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
		paper_url = rs.getString("paper_url")==null?"":rs.getString("paper_url");
		
		sql = "SELECT r.path,a.affiliate_id FROM affiliate_col a JOIN relation r ON a.affiliate_id = r.child_id WHERE a.col_id = " + request.getParameter("col_id");
		rs = conn.getResultSet(sql);
		while(rs.next()){
			sponsorSet.add(rs.getString("affiliate_id"));
			String p = rs.getString("path");
			String[] path = p.split(",");
			if(path != null){
				for(int i=0;i<path.length;i++){
					if(!rs.getString("affiliate_id").equalsIgnoreCase(path[i])){
						pathSet.add(path[i]);
					}
				}
			}
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
<%-- 
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
--%>
				<tr>
							<td width="20%" valign="top" style="font-weight: bold;">
								Speaker:					
							</td>
							
							<td>
							<table width="100%" class="showSpeakers">
								<tbody id = "speaker_container">
					
								</tbody>
							</table>
							<b>Name:</b> <input style="font-size: 1em;" id="nameInput" name="nameInput"  size="50" value=""/>
								<b>&nbsp;&nbsp;&nbsp;&nbsp;Affiliation</b><input style="font-size: 1em;" id="affiliationInput" name="affiliationInput"  size="40" value=""/>
								<html:button property="addSpeakers"  
								onclick="addTeacherElement();return false;">Add</html:button><br/>
								
							</td>
							
				</tr>
				<tr id="trShowImage">
					<td style="vertical-align: top">
						<div id="image"></div>
						<input style="visibility: hidden;margin:5px 0;" type="button" id="selectImg" value="Not this Picture?" onclick='searchImage(nameInput.value)'/>
					</td>
					<td>
						<div id="content"></div>
					</td>
				</tr>
				
				
				<tr>
					<td><input type="hidden" id="speaker" name="speaker" size="20" /> </td>
					<td><input type="hidden" id="affiliation" name="affiliation" size="20" /></td>
				</tr>
				<tr> 
					<td colspan="2"><font style="color: red;"><b><html:errors property="speaker"/></b></font></td>
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
					<td width="20%" valign="top" style="font-weight: bold;">Series: (Optional)</td>
					<td>
                			<input id="series" name="series" size="80"  /> 
							<input type="hidden" id="series_id" name="series_id" size="80"  />
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
		//If the affiliation in the path, show children
		boolean show0 = false;
		if(pathSet.contains(aid)){
			show0 = true;			
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
				if(show0){
%>
							<ul id="ulSponsor<%=aid %>">
<%		
				}else{
%>
							<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
							onclick="showChildren(ulSponsor<%=aid%>,this);"  />
							<ul id="ulSponsor<%=aid %>" style="display: none;">
<%		
				}
				lvl1Hidden = true;
			}
			checked = "";
			if(sponsorSet.contains(aid)){
				checked = "checked='checked'";		
			}
			//If the affiliation in the path, show children
			boolean show1 = false;
			if(pathSet.contains(aid)){
				show1 = true;			
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
					if(show1){
%>
										<ul id="ulSponsor<%=aid%>">
<%
					}else{
%>
										<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
										onclick="showChildren(ulSponsor<%=aid%>,this);"  />
										<ul id="ulSponsor<%=aid%>" style="display: none;">
<%
					}
					lvl2Hidden = true;
				}
				checked = "";
				if(sponsorSet.contains(aid)){
					checked = "checked='checked'";		
				}
				//If the affiliation in the path, show children
				boolean show2 = false;
				if(pathSet.contains(aid)){
					show2 = true;			
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
						if(show2){
%>
												<ul id="ulSponsor<%=aid%>">
<%
						}else{
%>
												<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
												onclick="showChildren(ulSponsor<%=aid%>,this);"  />
												<ul id="ulSponsor<%=aid%>" style="display: none;">
<%
						}
						lvl3Hidden = true;
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
				<td width="20%" style="font-weight: bold;">Paper URL: (optional)</td>
				<td><html:text style="font-size: 1em;" property="paper_url" size="80" value="<%=slide_url%>" /></td>
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
<input type="button" class="btn" value="Post Talk" onclick="submitform()" />
</html:form>
</logic:notPresent>

</logic:present>