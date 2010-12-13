<%@ page language="java"%>
<%@ page import="edu.pitt.sis.beans.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
	String path = request.getContextPath();
	//String basePath = request.getScheme()+"://"+request.getServerName()+path+"/";
%>

<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="4"  bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td colspan="4" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">Feed</td>
	</tr>
	<tr>
		<td align="center" width="20%" style="font-size: 0.75em;"><a href="utils/_rss.jsp<%if(request.getQueryString()!=null)out.print("?"+request.getQueryString());%>"><img border="0" src="images/rss_feed.gif" alt="RSS 2.0" /></a></td>
		<td align="center" width="20%" style="font-size: 0.75em;"><a href="utils/_atom.jsp<%if(request.getQueryString()!=null)out.print("?"+request.getQueryString());%>"><img border="0" src="images/atom_feed.gif" alt="Atom" /></a></td>
		<td align="center" width="20%" style="font-size: 0.75em;"><a href="utils/_ical.jsp<%if(request.getQueryString()!=null)out.print("?"+request.getQueryString());%>"><img border="0" style="height: 14px;width: auto;" src="images/ical.jpg" alt="iCal" /></a></td>
		<td align="center" width="20%" style="font-size: 0.75em;">
<!-- AddThis Button BEGIN -->
<a class="addthis_button" href="http://www.addthis.com/bookmark.php?v=250&amp;pub=chirayukong"><img src="http://s7.addthis.com/static/btn/sm-share-en.gif" width="83" height="16" alt="Bookmark and Share" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pub=chirayukong"></script>
<!-- AddThis Button END -->
		</td>
<%-- 
		<td align="center" width="15%" style="font-size: 0.9em;"><a href="javascript:var d=document,f='http://www.facebook.com/share',l=d.location,e=encodeURIComponent,p='.php?src=bm&v=4&i=1256076609&u='+e(l.href)+'&t='+e(d.title);1;try{if (!/^(.*\.)?facebook\.[^.]*$/.test(l.host))throw(0);share_internal_bookmarklet(p)}catch(z) {a=function() {if (!window.open(f+'r'+p,'sharer','toolbar=0,status=0,resizable=1,width=626,height=436'))l.href=f+p};if (/Firefox/.test(navigator.userAgent))setTimeout(a,0);else{a()}}void(0)"><img border="0" src="http://static.ak.fbcdn.net/rsrc.php/zAB5S/hash/4273uaqa.gif" alt="Facebook" /></a></td>
--%>
	</tr>
	<tr>
		<td align="center" width="20%" style="font-size: 0.75em;"><a href="http://www.google.com/calendar/render?cid=http://halley.exp.sis.pitt.edu/comet/utils/_gcal.jsp<%if(request.getQueryString()!=null)out.print("?"+request.getQueryString());%>"><img border="0" style="height: 20px;width: auto;" src="images/gcal.png" alt="Google Calendar" /></a></td>
	</tr>	
</table>