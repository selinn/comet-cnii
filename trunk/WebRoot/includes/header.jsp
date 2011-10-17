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
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.LinkedHashMap"%><html>
  	<head>  	
  		<link rel="CoMeT Icon" href="images/favicon.ico" />
    	<title>
    		<tiles:getAsString name="title"/>
	    </title>
	    <meta http-equiv="pragma" content="no-cache">
	    <meta http-equiv="cache-control" content="no-cache">
	    <meta http-equiv="expires" content="0">    

<%-- 
<link type="text/css" href="../css/jquery-ui-1.8.5.custom.css" rel=
  "stylesheet" /> 
--%>
<link rel="stylesheet" type="text/css" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/themes/base/jquery-ui.css">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js"> 
</script> 
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js"> 
</script> 
<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/jquery.cookie.js"%>"> 
</script> 

<link rel="stylesheet" href="css/jquery.autocomplete.css" type="text/css" />
<link type='text/css' href='css/basic.css' rel='stylesheet' media='screen' />

<script src="http://code.jquery.com/jquery-latest.js"></script>
<script type='text/javascript' src='scripts/jquery.bgiframe.min.js'></script>
<script type='text/javascript' src='scripts/jquery.autocomplete.js'></script>
<script type='text/javascript' src='scripts/jquery.simplemodal.js'></script>
<%-- 
		<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/xtree.js"%>"></script>
		<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/xmlextras.js"%>"></script>
		<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/xloadtree.js"%>"></script>	
--%>
		<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en"></script>
<% 
	session=request.getSession(false);
	int userID = -1;
	String userName = "";
	String sessionID = session.getId();
	Cookie cookies[] = request.getCookies();
	//Find session id & user id
	//boolean foundSessionID = false;
	boolean foundUserID = false;
	if(cookies != null){
		for(int i=0;i<cookies.length;i++){
			Cookie c = cookies[i];
            /*if (c.getName().equals("comet_session_id")) {
                sessionID = c.getValue();
            	foundSessionID = true;
            }*/			
            if (c.getName().equals("comet_user_id")) {
            	if(c.getValue() != null){
                    userID = Integer.parseInt(c.getValue());
                	foundUserID = true;
            	}
            }			
            if (c.getName().equals("comet_user_name")) {
                userName = c.getValue();
            }			
		}
	}
	/*if(!foundSessionID){
		Cookie c = new Cookie("comet_session_id", sessionID);
        c.setMaxAge(365*24*60*60);
        response.addCookie(c);
	}*/
	connectDB conn = new connectDB();
	ResultSet rs;
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	if(ub != null){
		Cookie cid = new Cookie("comet_user_id", "" + ub.getUserID());
        cid.setMaxAge(365*24*60*60);
        cid.setPath("/");
        response.addCookie(cid);
		Cookie cname = new Cookie("comet_user_name", ub.getName());
        cname.setMaxAge(365*24*60*60);
        cname.setPath("/");
        response.addCookie(cname);
	}else if(foundUserID && userID > 0){
		if(session.getAttribute("logout")==null){
			ub = new UserBean();
			ub.setUserID(userID);
			ub.setName(userName);
			session.setAttribute("UserSession",ub);
		}
	}
%>
<script type="text/javascript">
	/*************************************************/
	/* Request Add Friend Script                     */
	/*************************************************/
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
		if(typeof period != "undefined"){
			var action = "utils/loadTalks.jsp";
			if(period == 0){//Day
				action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
			}else if(period == 1){//Week
				var thisweek = getWeekNoInMonth(_year,_month,_day);
				action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
			}else{
				action = action.concat('?month=',_month,'&year=',_year);
			}
			if(queryString){
				action = action.concat('&',queryString);
			}
			//alert(action);
			loadTalks(action);
			
		}else{
			window.parent.location.reload();
		}
		$.modal.close();
	}
	function   DrawImage(ImgD, iwidth, iheight){ 
	      var image = new Image();     
	      image.src = ImgD.src; 
	      if(image.width > 0  &&  image.height> 0){ 
	        if(image.width/image.height >= iwidth/iheight){    
	          	 ImgD.width=iwidth; 
	          	 ImgD.height=image.height*iwidth/image.width;  
	          	 ImgD.alt=image.width+ "* "+image.height; 
	        } 
	       else{ 
	          	ImgD.height=iheight; 
	          	ImgD.width=image.width*iheight/image.height;           
	          	ImgD.alt=image.width+ "* "+image.height; 
	       } 
	     }
	} 

	function s_confirm(){
		if(document.s_search.search_text.value == "" || document.s_search.search_text.value == " "){
	        alert("Enter keywords");
	    }else{
	        document.s_search.submit();
	    }
	}
	
	function showAddFriendDialog(divAddFriend){
		//var divAddFriend = document.getElementById("divAddFriend");
		divAddFriend.style.display = "block";
	}
	
	function hideAddFriendDialog(divAddFriend){
		//var divAddFriend = document.getElementById("divAddFriend");
		divAddFriend.style.display = "none";
	}
	
	function sendFriendRequest(objParent,uid,reqtype){
		$.post("profile/friendRequest.jsp",{user_id: uid,request_type: reqtype},function(data){
				if(data){
					if(data.status=="OK"){
						if(objParent != null){
							if(reqtype=="add"){
								objParent.innerHTML = "<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">Friend Request Sent</span> <a href=\"javascript:return false;\"".concat(
										" onclick=\"addFriend(",objParent.id,",",uid,",'drop');return false;\">",
											"<img border='0' src='images/x.gif' /></a>");
							}
							if(reqtype=="drop"){
								objParent.innerHTML = "<input class =\"btn\" type=\"button\" id=\"btnAddAsFriend\"".concat(
										" value=\"Add as Friend\" onclick=\"showAddFriendDialog(divAddFriend);return false;\" />");
							}
							if(reqtype=="accept"){
								objParent.innerHTML = "<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">You both are connected.</span>";
								window.setTimeout(function(){location.reload();},500);
							}
							if(reqtype=="notnow"){
								objParent.innerHTML = "&nbsp;";
							}				
							if(reqtype=="reject"){
								objParent.innerHTML = "<input class =\"btn\" type=\"button\" id=\"btnAddAsFriend\"".concat(
									" value=\"Add as Friend\" onclick=\"showAddFriendDialog(divAddFriend);return false;\" />");
							}				
						}	
					}else{
						alert(data.status + " : " + data.message);
					}		
				}	
			});
	}	

	function toggleRequestList(aList,divTopList){
		var _class = divTopList.getAttribute("class");
		if(_class == "hiddenlist"){
			$(".shownlist").removeClass("shownlist").addClass("hiddenlist");
			divTopList.setAttribute("class","shownlist");
			aList.setAttribute("class","shownlist");
		}else{
			divTopList.setAttribute("class","hiddenlist");
			aList.setAttribute("class","hiddenlist");
		}		
	}
	
	function autohintGotFocus(txtShare){
	    if(txtShare.value == txtShare.getAttribute('title')){ 
	        txtShare.value = '';
	        var rows = txtShare.getAttribute('rows');
	        if(rows){
				var r = parseInt(rows);
	        	txtShare.setAttribute('rows',(r+1));
	        }   
	        txtShare.removeAttribute('class');
	    }
	}	
	
	function autohintGotFocus(txtShare,objButton){
	    if(txtShare.value == txtShare.getAttribute('title')){ 
	        txtShare.value = '';
	        var rows = txtShare.getAttribute('rows');
	        if(rows){
				var r = parseInt(rows);
	        	txtShare.setAttribute('rows',(r+1));
	        }   
	        txtShare.removeAttribute('class');
	        objButton.style.display = "block";
	    }
	}	
	
	function autohintGotBlur(txtShare){
	    if(txtShare.value == '' && txtShare.getAttribute('title') != ''){ 
	    	txtShare.value = txtShare.getAttribute('title');
	        var rows = txtShare.getAttribute('rows');
	        if(rows){
				var r = parseInt(rows);
	        	txtShare.setAttribute('rows',(r-1));
	        }   
	    	txtShare.setAttribute('class','auto-hint'); 
	    }
	}
		
	function autohintGotBlur(txtShare,objButton){
	    if(txtShare.value == '' && txtShare.getAttribute('title') != ''){ 
	    	txtShare.value = txtShare.getAttribute('title');
	        var rows = txtShare.getAttribute('rows');
	        if(rows){
				var r = parseInt(rows);
	        	txtShare.setAttribute('rows',(r-1));
	        }   
	    	txtShare.setAttribute('class','auto-hint');
	    	objButton.style.display = "none"; 
	    }
	}
	
	function postComment(u_id,txtShare,objButton){
		if(txtShare.getAttribute('class') != 'auto-hint'){
			txtShare.style.disabled = true;
			$.post("utils/postComment.jsp",{user_id: u_id,comment: txtShare.value},
				function(data){
					if(data.status == "OK"){
						txtShare.value = "";
						autohintGotBlur(txtShare,objButton);
						var latestTime = document.getElementById("latestTime");
						if(latestTime){
							$.get("profile/recentActivity.jsp",{user_id: u_id,insertfirst: 1,timestamp: latestTime.value},
								function(data){
									var now = new Date();
									latestTime.value = now.getFullYear() + "-" + (now.getMonth()+1) + "-" + now.getDate() + " " +
											now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds();
									var tdRecentActivity = document.getElementById("tdRecentActivity");
									tdRecentActivity.innerHTML = data.concat(tdRecentActivity.innerHTML);
								}
							);
						}	
					}else{
							alert("<b><red>" + data.status + ":</red></b> " + data.message);
					}		
					txtShare.style.disabled = false;
				}
			);
		}	
	}
	
	function replyComment(cid,_txtComment,_objButton){
		var txtComment = document.getElementById(_txtComment);
		var objButton = document.getElementById(_objButton); 
		if(txtComment.getAttribute('class') != 'auto-hint'){
			txtComment.style.disabled = true;
			$.post("utils/postComment.jsp",{comment_id: cid,comment: txtComment.value},
				function(data){
					if(data.status == "OK"){
						txtComment.value = "";
						autohintGotBlur(txtComment,objButton);
						var latestTime = document.getElementById("commenttimeccid".concat(cid));
						if(latestTime){
							$.get("utils/replyComment.jsp",{user_id: u_id,comment_id: cid,timestamp: latestTime.value},
								function(data){
									var now = new Date();
									latestTime.value = now.getFullYear() + "-" + (now.getMonth()+1) + "-" + now.getDate() + " " +
											now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds();
									var tdReplyComment = document.getElementById("tdcommentcid".concat(cid));
									if(tdReplyComment){
										tdReplyComment.innerHTML = tdReplyComment.innerHTML.concat(data);
										tdReplyComment.style.display = "block";
									}else{
										//alert("No found " + "tdcommentcid".concat(cid));
									}	
								}
							);
						}
					}else{
							alert("<b><red>" + data.status + ":</red></b> " + data.message);
					}		
					txtComment.style.disabled = false;
				}
			);
		}	
	}	
	
	function likeComment(uid,cid,anchorlike,tdlike){
		var txtLike = anchorlike.innerHTML;
		if(txtLike){
			$.post("utils/postLike.jsp",{user_id: uid,comment_id: cid,like: txtLike},
				function(data){
					if(data.status == "OK"){
						var like_tag = document.getElementById(tdlike);
						if(data.like_tag == "&nbsp;"){
							like_tag.style.display = "none";
						}else{
							like_tag.style.display = "block";
						}
						like_tag.innerHTML = data.like_tag;		
					}	
				}
			);
			if(txtLike == "Like"){
				anchorlike.innerHTML = "Unlike";
			}else{
				anchorlike.innerHTML = "Like";
			}		
		}	
	}	
	
	function likeSeries(uid,sid,anchorlike,tdlike){
		var classname = $(anchorlike).attr('class');
		var txtLike;
		
		if(classname == 'btn'){
			txtLike = anchorlike.value;
		}else{
			txtLike = anchorlike.innerHTML;
		}		

		if(txtLike){
			$.post("utils/postLike.jsp",{user_id: uid,series_id: sid,like: txtLike},
				function(data){
					if(data.status == "OK"){
						if(tdlike!=null){
							var classname = $('#'.concat(tdlike)).attr('class');
							if(data.like_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.like_tag);
						}
					}	
				}
			);
			
			if(classname == 'btn'){
				if(txtLike == "Like"){
					anchorlike.value = "Unlike";
				}else{
					anchorlike.value = "Like";
				}		
			}else{
				if(txtLike == "Like"){
					$('.'.concat(classname)).text('Unlike');
				}else{
					$('.'.concat(classname)).text('Like');
				}		
			}		
		}	
	}	

	function insertTag(tag){
		/*var el = document.getElementById('myTags');
		el.innerHTML += '<div><div class="tags">' + tag + '&nbsp;&nbsp;</div><input style="float:left" height="15" width="15" type="image" src="./images/delete.jpg" onclick="deleteTag(this, \'' + tag + '\')"/></div>';
		
		//document.AddBookmarkColloquiumForm.tags.value += tag + ",,";
		document.getElementById(tag).removeAttribute("onclick");
		document.getElementById(tag).removeAttribute("href");
		document.getElementById(tag).style.color = "black";*/
		var inserted = false;

		$("input.tagInput").each(function(index){
			if(jQuery.trim($(this).val()) == '' && !inserted){
				$(this).val(tag);
				inserted = true;

				$("a.".concat(tag.split(" ").join("_"))).attr("color","black");
				$("a.".concat(tag.split(" ").join("_"))).removeAttr("onclick");
				$("a.".concat(tag.split(" ").join("_"))).removeAttr("href");
			}
		});

		if(!inserted){
			addMoreTagInputRow();
			insertTag(tag);
			
		}	
	}

	/*function deleteTag(element, tag){
		 var parentElement = element.parentNode;
		 var parentElement2 = parentElement.parentNode;
	     if(parentElement2){
	            parentElement2.removeChild(parentElement);  
	     }
	     //var tagContent = document.AddBookmarkColloquiumForm.tags.value;
	     //document.AddBookmarkColloquiumForm.tags.value = tagContent.replace(tag+",,", "");
	     
	     document.getElementById(tag).onclick = function() {insert(tag);};
	     document.getElementById(tag).href = "javascript: void(0)";
	     document.getElementById(tag).style.color = "#00A";	
	     
	}*/

	function getSuggestedTag(colid){
		if(colid != null){

			$("#spanSuggestedTag").html("<div align='center'><img border='0' src='images/loading-small.gif' /></div>");
			
			var key = "0494dda81af7f0b4c28c93401dd0326845df8d91";
			var alchemyURL = "http://access.alchemyapi.com/calls/url/URLGetRankedConcepts";
			var talkurl = "http://halley.exp.sis.pitt.edu/comet/presentColloquium.do?col_id=".concat(colid);

			$.post(alchemyURL,{apikey: key, url: talkurl, outputMode: "json"},
				function(data){
					if(data.status == "OK"){
						var i;
						var suggestedtags = "";
						for(i=0;i<data.concepts.length;i++){
							suggestedtags = suggestedtags
								.concat("<a class='",data.concepts[i].text.toLowerCase().split(" ").join("_"),"' href='javascript:void(0)' onclick='insertTag(\"",
										data.concepts[i].text.toLowerCase(),"\")'>",data.concepts[i].text.toLowerCase(),"</a>&nbsp;");
						}
						if(suggestedtags.length > 0){
							suggestedtags = " <b>Suggested tags (click to add): </b>".concat(suggestedtags);
							//alert(suggestedtags);
							$("#spanSuggestedTag").html(suggestedtags);
						}else{
							$("#spanSuggestedTag").html("&nbsp;");
						}
					}else{
						alert(data.statusInfo);
					}
				}
			);

		}
	}

	function addMoreTagInputRow(){
		var currowno = $("#tags_container tr").length;
		var col1 = "<td width=\"30%\" align=\"center\">Keyword".concat(currowno*3 + 1,": <input style=\"font-size: 10px;\" class=\"tagInput\" type=\"text\" size=\"20\"  /></td>");
		var col2 = "<td width=\"30%\" align=\"center\">Keyword".concat(currowno*3 + 2,": <input style=\"font-size: 10px;\" class=\"tagInput\" type=\"text\" size=\"20\"  /></td>");
		var col3 = "<td width=\"30%\" align=\"center\">Keyword".concat(currowno*3 + 3,": <input style=\"font-size: 10px;\" class=\"tagInput\" type=\"text\" size=\"20\"  /></td>");
		var col4 = "<td width=\"10%\">&nbsp;</td>";
		
		$("#tags_container").append("<tr class='removable'>".concat(col1,col2,col3,col4,"</tr>"));
		
	}
	
	function getTalkUserTag(uid,colid){
		if(uid != null && colid != null){
			
			//$("#myTags").html("<div align='center'><img border='0' src='images/loading-small.gif' /></div>");
			$("#tags_container").hide();
			$("#divUserTagLoading").show();
			
			$.post("utils/getTags.jsp",{user_id: uid, col_id: colid, outputMode: "json"},
				function(data){
					//alert(data.status);
					if(data.status == "OK"){
						$("#divUserTagLoading").hide();
						//Create tag cells more to fit user tags
						if(data.tags.length > 6){
							var remainder = data.tags.length % 6;
						    var quotient = ( data.tags.length - remainder ) / 6;

						    if ( quotient >= 0 ){
						        quotient = Math.floor( quotient );
						    }else{  // negative
						        quotient = Math.ceil( quotient );
						    }

						    if(remainder > 0){
								quotient++;
							}

							if(quotient > 2){// 2 is the fixed number of initial rows
								var newrowno = qutient - 2;
								for(var i=0;i<newrowno;i++){
									addMoreTagInputRow();
								}
							}
		
						}

						$("input.tagInput").each(function(index){
							//alert(index);
							if(index < data.tags.length){
								//alert(data.tags[index].tag.toLowerCase());
								$(this).val(data.tags[index].tag.toLowerCase());
							}
						});
						
						$("#tags_container").show();
					}else{
						alert(data.message);
					}
				}
			);

		}
	}
	
	function getPopUserTag(uid){
		if(uid != null){
			
			$("#spanPopUserTag").html("<div align='center'><img border='0' src='images/loading-small.gif' /></div>");

			$.post("utils/getTags.jsp",{user_id: uid, outputMode: "json"},
				function(data){
					//alert(data.status);
					if(data.status == "OK"){
						var i;
						var popUserTags = "";
						for(i=0;i<data.tags.length;i++){
							popUserTags = popUserTags
								.concat("<a class='",data.tags[i].tag.toLowerCase().split(" ").join("_"),
										"' href='javascript:void(0)' onclick='insertTag(\"",
										data.tags[i].tag.toLowerCase(),"\")'>",data.tags[i].tag.toLowerCase(),"</a>&nbsp;");
						}
						if(popUserTags.length > 0){
							popUserTags = " <b>Top 10 your tags (click to add): </b>".concat(popUserTags);
							//alert(popUserTags);
							$("#spanPopUserTag").html(popUserTags);
						}else{
							$("#spanPopUserTag").html("&nbsp;");
						}
					}else{
						alert(data.message);
					}
				}
			);

		}
	}

	function showPopupTag(uid,colid,anchorTag,tdTag){
		$("#tags_container tr.removable").remove();
		$('.tagInput').val('');
		
		var talkDetail = '&nbsp;Title: '.concat($('#aTitleColID'.concat(colid)).text());
		$("#tdTagTitle").html(talkDetail);
		//talkDetail = talkDetail.concat('&nbsp;Speaker: ',document.getElementById('spanSpeakerColID'.concat(colid)).innerHTML);
		//document.getElementById('spanTagTalkDetail').innerHTML = talkDetail;

		getTalkUserTag(uid,colid);
		getSuggestedTag(colid);
		getPopUserTag(uid);

		$("#btnAddMoreTagRow").unbind();
		$("#btnAddMoreTagRow").click(function(){addMoreTagInputRow();});	
		
		$("#btnDoneTagging").unbind();
		$("#btnDoneTagging").click( function(){
				var tags = null;
				if($("input.tagInput").length > 0){
					tags = "";
					jQuery.each($("input.tagInput"), function(){
						if(jQuery.trim($(this).val()) != ""){
							tags = tags.concat(jQuery.trim($(this).val()),";;");
						}
					});
				}
				
				$.post("utils/postTags.jsp",{user_id: uid,col_id: colid,tag: tags},
					function(data){
						if(data.status=="OK"){

							$(anchorTag).text(data.tag_tag);
							
							var i;
							var talkTags = "";
							for(i=0;i<data.tags.length;i++){
								//"&nbsp;<a href=\"tag.do?tag_id=" + tag_id + "\">" + tag + "</a>";
								talkTags = talkTags
									.concat("&nbsp;<a href=\"tag.do?tag_id=",data.tags[i].tag_id,"\">",
											data.tags[i].tag.toLowerCase(),"</a>");
							}
							if(talkTags.length > 0){
								talkTags = "<br/><b>Tags:</b>".concat(talkTags);
								$(tdTag).html(talkTags);
								$(tdTag).show();
							}else{
								$(tdTag).html("&nbsp;");
								$(tdTag).hide;
							}
						}else{
							alert(data.message);
						}
						//divTagTalk.style.display = 'none';
						$("#divTagTalk").fadeOut();
					}
				);
			}
		);
		
		var position = $(anchorTag).position();
		divTagTalk.style.top = position.top;
		divTagTalk.style.display = 'block';
	
	}
	
	function bookmarkTalk(uid,colid,anchorBookmark,tdBookmark){
		var classname = $(anchorBookmark).attr('class');
		var txtBookmark;
		if(classname == 'btn'){
			txtBookmark = anchorBookmark.value;
		}else{
			txtBookmark = anchorBookmark.innerHTML;
		}
 
		if(typeof txtBookmark != "undefined"){
			$.post("utils/postBookmark.jsp",{user_id: uid,col_id: colid,bookmark: txtBookmark},
				function(data){
					if(data.status == "OK"){
						if(tdBookmark != null){
							var classname = $('#'.concat(tdBookmark)).attr('class');
							if(data.bookmark_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.bookmark_tag);
						}

						if($('.tdBookNoColID'.concat(colid)) != null){
							if(data.bookmarkno > 0){
								$('.tdBookNoColID'.concat(colid)).css('display','inline');
								$('.tdBookNoColID'.concat(colid)).html('<b>'
										.concat(data.bookmarkno,
											'</b><br/><span style=\'font-size: 0.55em;\'>bookmark',
											data.bookmarkno > 1?'s':''));
							}else{
								$('.tdBookNoColID'.concat(colid)).css('display','none');
							}
						}

						if($('.spanWhomBookmarkColID'.concat(colid)) != null){
							if(data.whombookmark.length > 0){
								$('.spanWhomBookmarkColID'.concat(colid)).css('display','inline');
								$('.spanWhomBookmarkColID'.concat(colid)).html('<br/><b>Bookmarked by:</b>'
										.concat(data.whombookmark));
							}else{
								$('.spanWhomBookmarkColID'.concat(colid)).css('display','none');
							}
						}

						if($('.tdEmailNoColID'.concat(colid)) != null){
							if(data.emailno > 0){
								$('.tdEmailNoColID'.concat(colid)).css('display','inline');
								$('.tdEmailNoColID'.concat(colid)).html('<b>'
										.concat(data.emailno,
											'</b><br/><span style=\'font-size: 0.55em;\'>email',
											data.emailno > 1?'s':''));
							}else{
								$('.tdEmailNoColID'.concat(colid)).css('display','none');
							}
						}							

						if($('.tdViewNoColID'.concat(colid)) != null){
							if(data.viewno > 0){
								$('.tdViewNoColID'.concat(colid)).css('display','inline');
								$('.tdViewNoColID'.concat(colid)).html('<b>'
										.concat(data.viewno,
											'</b><br/><span style=\'font-size: 0.55em;\'>view',
											data.viewno > 1?'s':''));
							}else{
								$('.tdViewNoColID'.concat(colid)).css('display','none');
							}
						}

						if(data.bookmark_tag == "&nbsp;Bookmarked&nbsp;"){							
							//$("#btnNoAskAgain").show();
							$("#btnTagClose").val("No, Thanks");
							showPopupTag(uid,colid,".atagcolid".concat(colid),".spanTagColID".concat(colid));
						}
					}else{
						alert(data.message);
					}		
				}
			);

			if(classname == 'btn'){
				if(txtBookmark == "Bookmark"){
					anchorBookmark.value = 'Unbookmark';
				}else{
					anchorBookmark.value = 'Bookmark';
				}		
			}else{
				if(txtBookmark == "Bookmark"){
					$('.'.concat(classname)).text('Unbookmark');
				}else{
					$('.'.concat(classname)).text('Bookmark');
				}		
			}		
		}	
	}
	
	function subscribeSeries(uid,sid,anchorSubscribe,tdSubscribe){
		var classname = $(anchorSubscribe).attr('class');
		var txtSubscribe;
		if(classname == 'btn'){
			txtSubscribe = anchorSubscribe.value;
		}else{
			txtSubscribe = anchorSubscribe.innerHTML;
		}
 
		if(txtSubscribe){
			$.post("utils/postSubscribe.jsp",{user_id: uid,series_id: sid,subscribe: txtSubscribe},
				function(data){
					if(data.status == "OK"){
						if(tdSubscribe != null){
							var classname = $('#'.concat(tdSubscribe)).attr('class');
							if(data.subscribe_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.subscribe_tag);
						}	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtSubscribe == "Subscribe"){
					anchorSubscribe.value = 'Unsubscribe';
				}else{
					anchorSubscribe.value = 'Subscribe';
				}		
			}else{
				if(txtSubscribe == "Subscribe"){
					$('.'.concat(classname)).text('Unsubscribe');
				}else{
					$('.'.concat(classname)).text('Subscribe');
				}		
			}		
		}	
	}	

	function deleteSeries(sid){
		$.post("utils/postDelete.jsp",{series_id: sid},
			function(data){
				if(data.status == "OK"){
					window.location = 'series.do';
				}else{
					alert(data.message);
				}	
			}
		);
	}
	
	function subscribeCommunity(uid,cid,anchorSubscribe,classSubscribe){
		var classname = $(anchorSubscribe).attr('class');
		var txtSubscribe;
		if(classname == 'btn'){
			txtSubscribe = anchorSubscribe.value;
		}else{
			txtSubscribe = anchorSubscribe.innerHTML;
		}
 
		if(txtSubscribe){
			$.post("utils/postSubscribe.jsp",{user_id: uid,comm_id: cid,subscribe: txtSubscribe},
				function(data){
					if(data.status == "OK"){
						if(classSubscribe != null){
							
							if(data.subscribe_tag == "&nbsp;"){
								$('.'.concat(classSubscribe)).css('display','none');
							}else{
								$('.'.concat(classSubscribe)).css('display','inline');
							}
							$('.'.concat(classSubscribe)).html(data.subscribe_tag);
						}	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtSubscribe == "Subscribe"){
					anchorSubscribe.value = 'Unsubscribe';
				}else{
					anchorSubscribe.value = 'Subscribe';
				}		
			}else{
				if(txtSubscribe == "Subscribe"){
					$('.'.concat(classSubscribe)).text('Unsubscribe');
				}else{
					$('.'.concat(classSubscribe)).text('Subscribe');
				}		
			}		
		}	
	}	

	function joinCommunity(uid,cid,anchorJoin,tdJoin){
		var classname = $(anchorJoin).attr('class');
		var txtJoin;
		if(classname == 'btn'){
			txtJoin = anchorJoin.value;
		}else{
			txtJoin = anchorJoin.innerHTML;
		}
 
		if(txtJoin){
			$.post("utils/postMember.jsp",{user_id: uid,comm_id: cid,join: txtJoin},
				function(data){
					if(data.status == "OK"){
						if(tdJoin != null){
							var classname = $('#'.concat(tdJoin)).attr('class');
							if(data.member_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
								$('.sub'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
								$('.sub'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.member_tag);
						}	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtJoin == "Join"){
					anchorJoin.value = 'Leave';
				}else{
					anchorJoin.value = 'Join';
				}		
			}else{
				if(txtJoin == "Join"){
					$('.'.concat(classname)).text('Leave');
				}else{
					$('.'.concat(classname)).text('Join');
				}		
			}		
		}	
	}	
	
	$(document).ready(function(){
		$("input.tagInput").autocomplete("./utils/tags.jsp", {
			  	delay: 20,
				formatItem: function(data, i, n, value) {			
					return  value;
						
				},
				formatResult: function(data, value) {
					return value;
				}
		});
		
		/*$("#divAddFriend").dialog({ 
				autoOpen: false,
			 	buttons: {
					"Send Request" : function(){
						$(this).dialog("close");
					},
					"Cancel": function(){
						$(this).dialog("close");
					}
		 		},
		 		minWidth: 300,
		 		width: 400,
		 		minHeight: 160
			}
		);
		$("#btnAddAsFriend").click(function(){
			$("#divAddFriend").dialog('open');
			return false;
		});*/
	});	

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
a.hiddenlist,a.hiddenlist:visited{
	background-color: white;
	border-left: 1px solid white;
	border-right: 1px solid white;
	text-decoration:none;
	color: black;
}
a.shownlist,a.shownlist:visited{
	background-color: #003366;
	border: 1px solid #003366;
	text-decoration:none;
	color: white;
}
div.hiddenlist{
	display: none;	
}
div.shownlist{
	display: block;
	position:absolute;
	right: 0;
	border: 1px solid #003366;
	width: 200px;
	text-align: left;
	background-color: #efefef;
	/*padding-left: 0;
	margin-left: 0;*/
} 
div.showlist ul{
	list-style-type: none;
	margin: 0;
	padding: 0;
	border: 1px solid #003366;
	width: 100%;
}
div.shownlist ul li{
	float: left;
	margin: 0;
	border-top: 1px solid #003366;
	width: 100%;
}
div.shownlist table{
	width: 100%;
	padding: 0;
	border: 0;
	margin: 0;
}
div.tags {float: left; background-color: #0080ff; margin-left:6px;  margin-bottom: 4px; font-size: 13px}
</style>

		<link href="<%=request.getContextPath() + "/css/stylesheet.css"%>" rel="stylesheet" media="grey" />  
	</head>
	<body leftmargin="0" topmargin="0" style="font-family: arial,Verdana,sans-serif,serif;font-size: 0.9em;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style = "margin-top:8px;margin-bottom:8px;"> 
			<tr>
				<td valign="top" align="left" style = "background-color: #fff;padding-right:4px" rowspan="3" width="18%">
                	<html:link forward="aaa.index" >
                		<img src="images/comet_logo.png" border="0">
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
				<td align="right" style="color: #003366; font-size:0.75em;">
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
						<logic:present name="UserSession">
							<div id="divNotifications" style="float: right;position: relative;" title="Notifications">
								<a class="hiddenlist" title="Notifications" href="javascript:return false;" onclick="toggleRequestList(this,divTopNotifyList);return false;">Notifications</a>
								<div id="divTopNotifyList" class="hiddenlist">
										<ul>
											<li>Notifications</li>
											<li>No new notifications.</li>
											<li>See All Notifications</li>
										</ul>
								</div>
							</div>
							<div style="float: right;">&nbsp;</div>
<% 
	String sql = "SELECT u.name,u.user_id FROM userinfo u JOIN request r ON u.user_id=r.requester_id " +
				"WHERE r.accepttime IS NULL AND r.rejecttime IS NULL AND r.droprequesttime IS NULL AND r.target_id=" + ub.getUserID() +
				" ORDER BY r.requesttime DESC LIMIT 5;";
	rs = conn.getResultSet(sql);
	LinkedHashMap<Integer,String> requestMap = new LinkedHashMap<Integer,String>();
	while(rs.next()){
		String uname = rs.getString("name");
		int uid = rs.getInt("user_id");
		requestMap.put(uid,uname);
		
	}
	if(requestMap.size()==0){
		
	}else{
		
	}
%>											
							<div id="divFriendRequest" style="float: right;position: relative;" title="Friend Requests">
								<a class="hiddenlist" title="Friend Requests" href="javascript:return false;" onclick="toggleRequestList(this,divTopReqList);return false;"><%=requestMap.size()>0?""+requestMap.size():"" %> Friend Request<%=requestMap.size()>1?"s":"" %></a>
								<div id="divTopReqList" class="hiddenlist">
										<ul>
<%-- 
											<li>Friend Requests</li>
--%>
<%		
	if(requestMap.size()==0){
%>
											<li>No new requests.</li>
<%-- 
											<li>See All Friends</li>
--%>
<%		
	}else{
		for(int uid : requestMap.keySet()){
			String uname = requestMap.get(uid);
%>
											<li><a style="text-decoration: none" href="profile.do?user_id=<%=uid %>"><%=uname %></a></li>
<%		
		}
	}
%>											
										</ul>
								</div>
							</div>
						</logic:present>

					</logic:notPresent>
				</td>
			</tr>
			<tr>
				<td align="left" style = "background-color: #fff;padding-right:4px;width: 60%;">
					<logic:notPresent name="HideBar">
						<form name="s_search" action="searchResult.do" style="border:0px;margin:0px;padding:0px">
<% 
	String s_opt = request.getParameter("s_opt");
%>
	                  		<select   name= "s_opt" id="s_opt">  	
	                  					 
    							<option   value= "1" <%=s_opt==null?"":(s_opt.trim().equalsIgnoreCase("1")?"selected":"") %>> Title </option> 
    							<option   value= "2" <%=s_opt==null?"":(s_opt.trim().equalsIgnoreCase("2")?"selected":"") %>> Detail </option>
    							<option   value= "3" <%=s_opt==null?"":(s_opt.trim().equalsIgnoreCase("3")?"selected":"") %>> Speaker </option>
    							<option   value= "4" <%=s_opt==null?"selected":(s_opt.trim().equalsIgnoreCase("4")?"selected":"") %>> ALL </option>
							</select> 
							<%
								String query = new String();
								if ((query = request.getParameter("search_text")) != null){
									int index;
									if ((index = query.indexOf("AND")) != -1){
										query = query.substring(0, index).trim();
									}
									if ((query.startsWith("(") && query.endsWith(")") )){
										query = query.substring(1, query.length()-1);
									}
										
								}
								else{
									query = "";
								}
							%>
						    <input name="search_text" size="38" type="text" value = "<%= query %>">
						    <input name="sa" class ="btn" value="Search" type="button" onclick="s_confirm()">
						    <input name="sortBy" value="1" type="hidden" />
							<input name="firstSearch" value="true" type="hidden" />
						    <a href="advancedSearch.do" style="font-size:11px; text-decoration: none; cursor: pointer; color: #36C">Advanced Search</a>
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

			String sql = "SELECT COUNT(*) _no FROM colloquium c " +
							"WHERE c.col_id IN " +
							"(SELECT ac.col_id FROM affiliate_col ac JOIN " +
							"(SELECT child_id FROM relation WHERE " +
							"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ id + "),',%')) cc " +
							"ON ac.affiliate_id = cc.child_id " +
							"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + id + ")" +
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

		<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="divTagTalk">
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 550px;border: 1px solid #aaaaaa;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td id="tdTagTitle" bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
						&nbsp;Tag a talk
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td id="tdTagHeader" colspan="3" style="font-size: 0.85em;padding: 4px;">
									<table cellpadding="1" cellspacing="0" border="0" width="100%">
										<tr>
											<td>
												<img width='75' alt='Information icon' 
													src='http://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Information_icon.svg/75px-Information_icon.svg.png'/>
											</td>
											<td valign="middle">
												Could you please help us provide some keywords to organize this talk?
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<div id="divUserTagLoading" align='center'><img border='0' src='images/loading-small.gif' /></div>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<table cellpadding="0" cellspacing="0" border="0" width="100%" style="font-size: 0.7em;padding: 4px;">
										<tbody id="tags_container" >
											<tr>
												<td width="30%" align="center">Keyword1: <input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="30%" align="center">Keyword2: <input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="30%" align="center">Keyword3: <input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="10%" valign="middle"><input id="btnAddMoreTagRow" class="btn" type="button" value="Add More Tags"/></td>
											</tr>
											<tr>
												<td width="30%" align="center">Keyword4: <input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="30%" align="center">Keyword5: <input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="30%" align="center">Keyword6: <input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="10%">&nbsp;</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3" style="font-size: 0.7em;padding: 4px;">
									<span id="spanSuggestedTag">&nbsp;</span>
								</td>
							</tr>
							<tr>
								<td colspan="3" style="font-size: 0.7em;padding: 4px;">
									<span id="spanPopUserTag">&nbsp;</span>
								</td>
							</tr>
							<tr>
								<td colspan="3" style="font-size: 0.7em;padding: 4px;">
									&nbsp;
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="470">&nbsp;&nbsp;<input id="btnNoAskAgain" class="btn" type="button" style="display: none;" value="Never Ask Again"></input></td>
								<td align="center" width="40"><input id="btnDoneTagging" class="btn" type="button" value="Save"></input></td>
								<td align="center" width="40"><input id="btnTagClose" class="btn" type="button" value="Close" onclick="$('#divTagTalk').fadeOut();return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>

</body>
</html>