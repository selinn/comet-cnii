<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<div id="divUserActivityContent">
Activity
	<script type="text/javascript">
		window.onload = function(){
			if(divUserActivityContent){
				if(parent.displayTalks){
					parent.displayTalks(divUserActivityContent.innerHTML);
				}
			}
		}
	</script>	
</div>
