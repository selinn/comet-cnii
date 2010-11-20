<%@page import="java.io.IOException"%><%@page import="java.net.MalformedURLException"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.URLConnection"%><%@page import="java.net.URL"%><%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	ResultSet rs = null;
	String user_id = request.getParameter("user_id");
	String col_id = request.getParameter("col_id");
	String rating = request.getParameter("rating");
	
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<addrating>");
	if(user_id == null){
		out.print("<status>ERROR: user_id required</status>");
	}else if(user_id.trim().length()==0){
		out.print("<status>ERROR: user_id cannot be blank</status>");
	}else if(col_id == null){
		out.print("<status>ERROR: col_id required</status>");
	}else if(col_id.trim().length()==0){
		out.print("<status>ERROR: col_id cannot be blank</status>");
	}else if(rating == null){
		out.print("<status>ERROR: rating required</status>");
	}else if(!rating.matches("((-|\\+)?[0-9]+(\\.[0-9]+)?)+")){
		out.print("<status>ERROR: rating must be numeric (0.0 - 5.0)</status>");
	}else{
		
		connectDB conn = new connectDB();

		String sql = "INSERT INTO userfeedback (user_id,col_id,rating,ratingtime) VALUES " + 
						"(?,?,?,NOW())";
		
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1, Long.parseLong(user_id));
			pstmt.setLong(2, Long.parseLong(col_id));
			pstmt.setDouble(3,Double.parseDouble(rating));
			pstmt.executeUpdate();

			out.print("<status>OK</status>");
			
			//Call recTalk
			try {
				//System.out.println(url_to_get);
				URL url = new URL("http://localhost:8080/recTalk/userprofile.jsp?user_id=" + user_id);
				//make connection
				URLConnection urlc = url.openConnection();
		        /** Some web servers requires these properties */
		        urlc.setRequestProperty("User-Agent", 
		                "Profile/MIDP-1.0 Configuration/CLDC-1.0");
		        urlc.setRequestProperty("Content-Length", "0");
		        urlc.setRequestProperty("Connection", "close");
		        //urlc.connect();
		
				//get result
				BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()));
		
				br.close();
			} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			rs = null;
			pstmt.close();
			conn.conn.close();
			conn = null;
		}catch(SQLException e){
			try {
				if (pstmt != null) pstmt.close();			
				if (conn.conn !=null) conn.conn.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}	
	out.print("</addrating>");
%>