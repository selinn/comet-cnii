package edu.pitt.sis.action;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

import javax.servlet.http.*;

import edu.pitt.sis.FetchNE;
import edu.pitt.sis.MailNotifier;
import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;
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
public class AddColloquiumAction extends Action {

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
		if(session.getAttribute("Colloquium") != null)session.removeAttribute("Colloquium");
		if(session.getAttribute("SubmitTalkError") != null)session.removeAttribute("SubmitTalkError");
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		if(ub == null){
			session.setAttribute("SubmitTalkError", "Please login to post talk to CoMeT");
			return mapping.findForward("Failure");
		}
		
		ColloquiumForm cqf = (ColloquiumForm)form;
		
		connectDB conn = new connectDB();
		PreparedStatement pstmt = null;
		
		long speaker_id = -1;
		String concatname = "";
		
		//Search for existing speakers
		String[] name = cqf.getSpeaker().trim().split("\\s+");
		for(int i=0;i<name.length;i++){
			concatname += name[i];
		}
		
		String sql = "SELECT speaker_id FROM speaker WHERE concatname = ? and affiliation = ?";
		try {
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1, concatname.toLowerCase());
			pstmt.setString(2, cqf.getAffiliation());
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()){
				speaker_id = rs.getLong("speaker_id");
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			try {				
				pstmt.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#1) occured. Please try again.");
				return mapping.findForward("Failure");
			}
		}
		
		//If not there, insert new speakers
		if(speaker_id == -1){
			sql = "INSERT INTO speaker (name,concatname,affiliation) VALUES (?,?,?)";
			try {
				String speaker = "";
				for(int i=0;i<name.length;i++){
					speaker += name[i] + " ";
				}
				speaker = speaker.trim();
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, speaker);
				pstmt.setString(2, concatname.toLowerCase());
				pstmt.setString(3, cqf.getAffiliation());
				pstmt.execute();
				pstmt.close();				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				try {
					pstmt.close();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#3) occured. Please try again.");
					return mapping.findForward("Failure");
				}				
				session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#2) occured. Please try again.");
				return mapping.findForward("Failure");
			}
			sql = "SELECT LAST_INSERT_ID()";
			try {
				pstmt = conn.conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery();
				if(rs.next()){
					speaker_id = rs.getLong(1);
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		//Now host can be null so be aware of it!!!
		//Search for existing hosts
		long host_id = 0;
		if(cqf.getHost() != null){
			String hostconcat = "";
			String[] host = cqf.getHost().trim().split("\\s+");
			for(int i=0;i<host.length;i++){
				hostconcat += host[i];
			}
			sql = "SELECT host_id FROM host WHERE hostconcat = ?";
			try {
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, hostconcat.toLowerCase());
				ResultSet rs = pstmt.executeQuery();
				if(rs.next()){
					host_id = rs.getLong("host_id");
				}
				pstmt.close();
			} catch (SQLException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
				try {
					pstmt.close();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#5) occured. Please try again.");
					return mapping.findForward("Failure");
				}				
				session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#4) occured. Please try again.");
				return mapping.findForward("Failure");
			}
			if(host_id == 0){
				sql = "INSERT INTO host (host,hostconcat) VALUES (?,?)";
				String strHost = "";
				for(int i=0;i<host.length;i++){
					strHost += host[i] + " ";
				}
				strHost = strHost.trim();
				try {
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setString(1, strHost);
					pstmt.setString(2, hostconcat.toLowerCase());
					pstmt.execute();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					try {
						pstmt.close();
					} catch (SQLException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
						session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#7) occured. Please try again.");
						return mapping.findForward("Failure");
					}				
					session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#6) occured. Please try again.");
					return mapping.findForward("Failure");	
				}
				sql = "SELECT LAST_INSERT_ID()";
				try {
					pstmt = conn.conn.prepareStatement(sql);
					ResultSet rs = pstmt.executeQuery();
					if(rs.next()){
						host_id = rs.getLong(1);
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		Date talkDate;
		Date beginTime;
		Date endTime;
		
		try {
			SimpleDateFormat dateFormatter = new SimpleDateFormat("MM/dd/yyyy");
			SimpleDateFormat timeFormatter = new SimpleDateFormat("MM/dd/yyyy h:m a");
			talkDate = dateFormatter.parse(cqf.getTalkDate());
			beginTime = timeFormatter.parse(cqf.getTalkDate() + " " + cqf.getBeginHour() + ":" + cqf.getBeginMin() + " " + cqf.getBeginAMPM());
			endTime = timeFormatter.parse(cqf.getTalkDate() + " " + cqf.getEndHour() + ":" + cqf.getEndMin() + " " + cqf.getEndAMPM());
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			session.setAttribute("SubmitTalkError", "Technical problem (DateTime Conversion) occured. Please try again.");
			return mapping.findForward("Failure");
		}
		
		//Add/edit talk
		if(cqf.getCol_id() == 0){
			//Insert talk
			sql = "INSERT INTO colloquium " +
					"(_date,begintime,endtime,location,detail,lastupdate," +
					"title,user_id,speaker_id,host_id,url,owner_id,video_url,slide_url,s_bio) " +
					"VALUES " +
					"(?,?,?,?,?,NOW(),?,?,?,?,?,?,?,?,?)";
			try {
				SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat timeFormatter = new SimpleDateFormat("yyyy-MM-dd H:m");
				
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, dateFormatter.format(talkDate));
				pstmt.setString(2, timeFormatter.format(beginTime));
				pstmt.setString(3, timeFormatter.format(endTime));
				pstmt.setString(4, cqf.getLocation());
				pstmt.setString(5, cqf.getDetail());
				pstmt.setString(6, cqf.getTitle());
				pstmt.setLong(7, ub.getUserID());
				//pstmt.setInt(8, Integer.parseInt(cqf.getTypeoftalk()));
				pstmt.setLong(8, speaker_id);
				pstmt.setLong(9, host_id);
				pstmt.setString(10, cqf.getUrl());
				pstmt.setLong(11, ub.getUserID());
				pstmt.setString(12, cqf.getVideo_url());
				pstmt.setString(13, cqf.getSlide_url());
				pstmt.setString(14, cqf.getS_bio());
				pstmt.executeUpdate();
				pstmt.close();
				
				//Fetch back colloquium id
				sql = "SELECT LAST_INSERT_ID()";
				ResultSet rs = conn.getResultSet(sql);
				if(rs.next()){
					cqf.setCol_id(rs.getLong(1));
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
				session.setAttribute("SubmitTalkError", speaker_id + "Technical problem (DB Connection#4) occured. Please try again. " + e.getMessage());
				return mapping.findForward("Failure");
			}
			
		}else{//Edit
			//Copy from colloquium tbl to col_bk tbl
			sql = "INSERT INTO col_bk " +
					"(timestamp,col_id,_date,begintime,endtime,location,detail,lastupdate," +
					"title,user_id,owner_id,speaker_id,host_id,url,video_url,slide_url,s_bio) " +
					"SELECT NOW(),col_id,_date,begintime,endtime,location,detail,lastupdate," +
					"title,user_id,owner_id,speaker_id,host_id,url,video_url,slide_url,s_bio FROM colloquium WHERE col_id=" + cqf.getCol_id();
			conn.executeUpdate(sql);
			
			//Edit talk
			sql = "UPDATE colloquium  SET " +
					"_date = ? ,begintime =?,endtime = ?,location = ?,detail = ?,lastupdate = NOW()," +
					"title = ?,user_id = ?,speaker_id = ?,host_id = ?,url=?, video_url=?, slide_url=?, s_bio=? " +
					"WHERE col_id = ?";
			try {
				SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat timeFormatter = new SimpleDateFormat("yyyy-MM-dd H:m");
				
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, dateFormatter.format(talkDate));
				pstmt.setString(2, timeFormatter.format(beginTime));
				pstmt.setString(3, timeFormatter.format(endTime));
				pstmt.setString(4, cqf.getLocation());
				pstmt.setString(5, cqf.getDetail());
				pstmt.setString(6, cqf.getTitle());
				pstmt.setLong(7, ub.getUserID());
				//pstmt.setInt(8, Integer.parseInt(cqf.getTypeoftalk()));
				pstmt.setLong(8, speaker_id);
				pstmt.setLong(9, host_id);
				pstmt.setString(10, cqf.getUrl());
				pstmt.setString(11, cqf.getVideo_url());
				pstmt.setString(12, cqf.getSlide_url());
				pstmt.setString(13, cqf.getS_bio());
				pstmt.setLong(14, cqf.getCol_id());
				pstmt.executeUpdate();
				pstmt.close();
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
				session.setAttribute("SubmitTalkError", speaker_id + " Technical problem (DB Connection#4) occured. Please try again. " + e.getMessage());
				return mapping.findForward("Failure");
			}
			
			//Acknowledge bookmarked users
			try {
				int _updateno = 0;
				sql = "SELECT COUNT(*) _no FROM col_bk WHERE col_id=?";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setLong(1, cqf.getCol_id());
				ResultSet rs = pstmt.executeQuery();
				if(rs.next()){
					_updateno = rs.getInt("_no");
				}
				
				sql = "SELECT u.name,u.email FROM userinfo u JOIN userprofile up ON u.user_id=up.user_id WHERE up.col_id=? GROUP BY u.name,u.email";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setLong(1, cqf.getCol_id());
				rs = pstmt.executeQuery();
				SimpleDateFormat dateFormatter = new SimpleDateFormat("MMM d, yyyy");
				SimpleDateFormat timeFormatter = new SimpleDateFormat("hh:mm a");
				String _talkDate = dateFormatter.format(talkDate);
				String _beginTime = timeFormatter.format(beginTime);
				String _endTime = timeFormatter.format(endTime);
				while(rs.next()){
					String bname = rs.getString("name");
					String[] bemail = new String[1];
					bemail[0] = rs.getString("email");
	
					
					String localhost= "halley.exp.sis.pitt.edu";
					String mailhost= "smtp.gmail.com";
					String mailuser= "NoReply";
					MailNotifier mail = new MailNotifier(localhost,mailhost,mailuser,bemail);
					String emailContent = "Dear " + bname + "\n\n" +
					"Your bookmarked talk was updated as belows:\n\n" + 
					"Title: " + cqf.getTitle() + "\n" +
					"Speaker: " + cqf.getSpeaker() +  "\n" +
					"Host: " + cqf.getHost() + "\n" + 
					"Date: " + _talkDate + "\n" +
					"Time: " + _beginTime + " - " + _endTime + "\n" +
					"Location: " + cqf.getLocation() + "\n\n" +
					"More detail please visit http://halley.exp.sis.pitt.edu/comet/presentColloquium.do?col_id=" + cqf.getCol_id();
					
					try {
						mail.send("CoMeT | [Update #" + _updateno + "] " + cqf.getTitle(), emailContent);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			/**
			 * 		
			 * */
			
		}
		
		//Delete col_id in the seriescol table
		sql = "DELETE FROM seriescol WHERE col_id = " + cqf.getCol_id();
		conn.executeUpdate(sql);

		String[] selected_series = cqf.getSeries_id();
		String series_list = "";
		if(selected_series != null){
			for(int i=0;i<selected_series.length;i++){
				//Add series_id
				sql = "INSERT INTO seriescol (series_id,col_id) VALUES (" + 
						selected_series[i] + "," + cqf.getCol_id() + ") ";
				conn.executeUpdate(sql);
				if(series_list.length() > 0)series_list += ",";
				series_list += selected_series[i];
			}
		}
		
		//Assign a colloquium to sponsor affiliations
		HashSet<String> sponsorSet = new HashSet<String>();
		sql = "DELETE FROM affiliate_col WHERE col_id = " + cqf.getCol_id();
		conn.executeUpdate(sql);

		if(selected_series != null){
			sql = "SELECT DISTINCT affiliate_id FROM affiliate_series WHERE series_id IN (" + series_list + ")";
			ResultSet rs = conn.getResultSet(sql);
			try {
				while(rs.next()){
					sponsorSet.add(rs.getString("affiliate_id"));
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		if(cqf.getSponsor_id() !=null){
			for(int i=0;i<cqf.getSponsor_id().length;i++){
				sponsorSet.add(cqf.getSponsor_id()[i]);
			}
		}
		sql = "";
		for(Iterator<String> it=sponsorSet.iterator();it.hasNext();){
			if(sql.length() > 0){
				sql+=",";
			}
			sql+= "(" + it.next() + "," + cqf.getCol_id() + ")";
		}
		if(sql.length() > 0){
			sql = "INSERT INTO affiliate_col (affiliate_id,col_id) VALUES " + sql;
			conn.executeUpdate(sql);
		}
		
		try {
			conn.conn.close();
			conn = null;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//Fetch Named Entity
		FetchNE.getNameEntity(cqf.getCol_id());

		session.setAttribute("Colloquium", cqf);
			
		return mapping.findForward("Success");
	}	
}