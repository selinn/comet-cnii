package edu.pitt.sis;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import java.util.HashSet;
import java.util.Hashtable;

import edu.pitt.sis.db.connectDB;

public class ExternalProfile {
	public Connection conn;
	public String facebookTable = null;
	public String linkedInTable = null;
	public String fname,fprofile_url,fpic_small_with_logo,fheadline,lname,lprofile_url,lpic_small_with_logo,lheadLine,cname,caffiliation,cinterest="";
	public int fAutoID,lAutoID;
	public Hashtable<Integer,Integer> facebookFriends = new Hashtable<Integer,Integer>();
	public Hashtable<Integer,Integer> linkedInFriends = new Hashtable<Integer,Integer>();
	
	
	
	public ExternalProfile()
	{
		connectDB conns = new connectDB();
		conn = conns.conn;
	}

	
	 
	//Get external profile ID and table from facebook or linkedin
	public int getExternalID(long userID,String type) throws SQLException
	{
		
		String tableType = "%" + type +"%";
		String sqlProfile = "select ext_id,exttable from colloquia.extmapping where user_id=? and exttable like ?";
		PreparedStatement sf = conn.prepareStatement(sqlProfile);
		sf.setLong(1,userID);
		sf.setString(2,tableType);
		
		ResultSet result = sf.executeQuery();
		
		int extfacebook_id=-1;
		String ext_table = null;
		while(result.next())
		{
			extfacebook_id = result.getInt("ext_id");
			ext_table = result.getString("exttable");
		}
		result.close();
		sf.close();
		
		if(type.equals("facebook"))
		{
			facebookTable = ext_table;
		}else
		{
			linkedInTable = ext_table;
		}
		
		return extfacebook_id;
	}
	
	public void getFacebookProfileInfo(int profile_id) throws SQLException
	{
		//Get facebook Info
		
		String sqlFacebook = "select name,profile_url,pic_small_with_logo,current_location as description from "+ facebookTable + " where fAutoID=?";
		PreparedStatement infoState = conn.prepareStatement(sqlFacebook);
		infoState.setInt(1, profile_id);
		ResultSet infoResult = infoState.executeQuery();
		
		while(infoResult.next())
		{
			
			fname = infoResult.getString("name");
			fprofile_url = infoResult.getString("profile_url");
			fpic_small_with_logo = infoResult.getString("pic_small_with_logo");
			fheadline = infoResult.getString("description");
		}
		infoResult.close();
		infoState.close();
	}
	
	public void getLinkedInProfileInfo(int profile_id) throws SQLException
	{
		//Get linkedIn Info
		
		String sqllinkedIn = "select CONCAT(l.firstname, ' ', l.lastname) AS fullname, l.lAutoID, l.firstname, l.lastname, l.pictureurl as purl, l.publicprofileurl as profileurl, l.linkedinID, l.headline as description from extprofile.linkedin l where l.lAutoID=?";
		PreparedStatement infoState = conn.prepareStatement(sqllinkedIn);
		infoState.setInt(1, profile_id);
		ResultSet infoResult = infoState.executeQuery();
		
		while(infoResult.next())
		{
			
			lname = infoResult.getString("fullname");
			lprofile_url = infoResult.getString("profileurl");
			lpic_small_with_logo = infoResult.getString("purl");
			lheadLine = infoResult.getString("description");
		}
		infoResult.close();
		infoState.close();
	}
	
	public void getCometProfile(int user_id) throws SQLException
	{
		//Get info of user in colloquia
		String sqlcolloquia = "select name,affiliation,interests from colloquia.userinfo where user_id=?";
		PreparedStatement infoState = conn.prepareStatement(sqlcolloquia);
		infoState.setInt(1, user_id);
		ResultSet infoResult = infoState.executeQuery();
		
		while(infoResult.next())
		{
			
			cname = infoResult.getString("name");
			caffiliation = infoResult.getString("affiliation");
			cinterest = infoResult.getString("interests");
		}
		infoResult.close();
		infoState.close();
	}
	
	 
	//Get friends list from facebook or LinkedIn
	public void getFriendList(int fAutoID,String table) throws SQLException
	{
		String field1="";
		String field2="";
		if(table.contains("facebook"))
		{
			field1 = "fAuto1ID";
			field2 = "fAuto0ID";
			facebookFriends.clear();
			
		}else
		{
			field1 = "lAuto1ID";
			field2 = "lAuto0ID";
			linkedInFriends.clear();
		}
		
		String sqlFriends = "select "+field1+" as id from "+table+" where "+field2+"=? union select "+field2+" as id from "+table+" where "+field1+"=?";
		PreparedStatement sfriend = conn.prepareStatement(sqlFriends);
		sfriend.setInt(1,fAutoID);
		sfriend.setInt(2,fAutoID);
		
		ResultSet resultfriend = sfriend.executeQuery();
		
		int externalID = -1;
		int userID=-1;
		
		
		while(resultfriend.next())
		{
			externalID = resultfriend.getInt("id");
			userID = userIncolloquia(externalID);
				
			if(userID != -1)
			{
				if(table.contains("facebook"))
				{
					facebookFriends.put(userID,externalID);
					
				}else
				{
					linkedInFriends.put(userID,externalID);
				}
			}
			
		}
		sfriend.close();
		resultfriend.close();
	}
	
	//Check user exist in colloquia
	public int userIncolloquia(int externalId) throws SQLException
	{

		String sqlUser = "select user_id from colloquia.extmapping where ext_id=?";
		PreparedStatement sUser = conn.prepareStatement(sqlUser);
		sUser.setInt(1,externalId);
		
		ResultSet resultUsers = sUser.executeQuery();
		
		int userID = -1;
		
		while(resultUsers.next())
		{
			userID = resultUsers.getInt("user_id");
		}
		
		sUser.close();
		resultUsers.close();
		return userID;
	}
	
	//Check whether users are friends in colloquia
	public String connectionStatus(long user1,int user2) throws SQLException
	{
		
		String sql = "SELECT friend_id FROM colloquia.friend WHERE user0_id=? AND user1_id=? " +
				"AND breaktime IS NULL union " +
				"SELECT friend_id FROM colloquia.friend WHERE user0_id=? AND user1_id=? " +
				"AND breaktime IS NULL";
	
		PreparedStatement infoState = conn.prepareStatement(sql);
		infoState.setLong(1, user1);
		infoState.setInt(2, user2);
		infoState.setInt(3, user2);
		infoState.setLong(4, user1);
		
		ResultSet set = infoState.executeQuery();
		if(set.next()){
			set.close();
			infoState.close();
			return "Connected";
		}else{//They are not friends. So is there any befriending request?
			
			sql = "SELECT request_id FROM colloquia.request WHERE requester_id=? AND target_id=?" + 
				" AND droprequesttime IS NULL ORDER BY request_id DESC LIMIT 1";
			
			infoState = conn.prepareStatement(sql);
			infoState.setLong(1, user1);
			infoState.setInt(2, user2);
			set = infoState.executeQuery();
			
			
			if(set.next()){
				String request_id = set.getString("request_id");
				set.close();
				infoState.close();
				return request_id;
			}else
			{
				set.close();
				infoState.close();
				return "No";
			}
		}
		
		
		
	
	}
	
	
}
