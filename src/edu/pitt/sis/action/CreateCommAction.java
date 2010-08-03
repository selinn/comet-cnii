package edu.pitt.sis.action;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.jms.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.pitt.sis.beans.UserBean;
import edu.pitt.sis.db.*;
import edu.pitt.sis.form.*;

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
public class CreateCommAction extends Action {

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
		
		if (this.isCancelled(request)){ return(mapping.findForward("Failure"));}
		HttpSession session = request.getSession();
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		if(ub == null){
			session.setAttribute("SubmitCommunityError", "Please login to create new community");
			return mapping.findForward("Login");
		}
	
		connectDB conn = new connectDB();
		PreparedStatement pstmt = null;
		CreateCommForm ccf = (CreateCommForm)form;
		try{
			String sql = "INSERT INTO community (comm_name,comm_desc,lastupdate,user_id) VALUES (?,?, now(),?);";
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1,ccf.getName());
			pstmt.setString(2,ccf.getDescription());
			pstmt.setLong(3, ub.getUserID());
			pstmt.execute();
			pstmt.close();
			conn.conn.close();
			
		}catch(SQLException e){
			try {
				if (pstmt != null) pstmt.close();			
				if (conn.conn !=null) conn.conn.close();
				conn = null;
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			System.out.println(e.getMessage().toString());
			return mapping.findForward("Failure");
		}
		session.setAttribute("makeComm",new Object());
		return mapping.findForward("Success");
	}
	
}