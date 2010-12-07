package edu.pitt.sis.action;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.StringTokenizer;


import javax.servlet.http.*;

import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;
import edu.pitt.sis.form.LoginForm;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
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
public class ProfileAction extends Action {

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
		
		
		String user_id = (String)request.getParameter("user_id");
		if(user_id!=null){
			session.setAttribute("menu","profile");
		}else{
			session.setAttribute("menu","myaccount");
		}

		if(session.getAttribute("UserSession")==null&&user_id!=null){
			session.removeAttribute("HideBar");
			session.setAttribute("before-login-redirect", "profile.do");
			return mapping.findForward("Login");
		}
		
		if(session.getAttribute("HideBar")!=null){
			session.removeAttribute("HideBar");
		}
		
		return mapping.findForward("Success");			
		
	}

}