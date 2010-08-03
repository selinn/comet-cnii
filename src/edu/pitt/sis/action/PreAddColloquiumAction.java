package edu.pitt.sis.action;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

import javax.servlet.http.*;

import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

/** 
 * MyEclipse Struts
 * Creation date: 11-22-2004
 * 
 * XDoclet definition:
 * @struts:action validate="true"
 */
public class PreAddColloquiumAction extends Action {

	// --------------------------------------------------------- Instance Variables

	// --------------------------------------------------------- Methods

	/** 
	 * Method execute
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 */
	public ActionForward execute(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
			
		HttpSession session = request.getSession();
		
		if(session.getAttribute("UserSession")==null){
			session.setAttribute("HideBar", "");
			session.setAttribute("redirect", "PreColloquiumEntry.do");
			return mapping.findForward("Login");
		}
		if(session.getAttribute("HideBar")!=null){
			session.removeAttribute("HideBar");
		}
		if(session.getAttribute("redirect") != null){
			session.removeAttribute("redirect");
		}
		if(session.getAttribute("Colloquium") != null){
			session.removeAttribute("Colloquium");
		}
		if(session.getAttribute("SubmitTalkError") != null){
			session.removeAttribute("SubmitTalkError");
		}
		session.setAttribute("menu","TalkEntry");
		return mapping.findForward("Success");			
		
	}

}