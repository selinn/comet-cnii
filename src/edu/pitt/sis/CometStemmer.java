package edu.pitt.sis;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import edu.pitt.sis.db.connectDB;

public class CometStemmer {
	
	public CometStemmer(connectDB conn, long col_id) throws SQLException, IOException {
		String sql = "SELECT title,detail FROM colloquium WHERE col_id=" + col_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String title = rs.getString("title");
			String detail = rs.getString("detail");
			
			Html2Text htmlParser = new Html2Text();
			removeStopWords rsw = new removeStopWords();
			
			title = cleanNstem(title, htmlParser, rsw);
			detail = cleanNstem(detail, htmlParser, rsw);
			
			HashMap<String, Integer> title_tf = extractTF(title);
			HashMap<String, Integer> detail_tf = extractTF(detail);
			
			if(title_tf != null || detail_tf != null){
				sql = "DELETE FROM colterm WHERE col_id=" + col_id;
				conn.executeUpdate(sql);
				
				if(title_tf != null){
					for(String term : title_tf.keySet()){
						int freq = title_tf.get(term);
						sql = "INSERT INTO colterm (col_id,termtype,term,freq) VALUES (?,?,?,?)";
						PreparedStatement pstmt = conn.conn.prepareStatement(sql);
						pstmt.setLong(1, col_id);
						pstmt.setString(2, "title");
						pstmt.setString(3, term);
						pstmt.setInt(4, freq);
						pstmt.executeUpdate();
						pstmt.close();
					}
				}
				
				if(detail_tf != null){
					for(String term : detail_tf.keySet()){
						int freq = detail_tf.get(term);
						sql = "INSERT INTO colterm (col_id,termtype,term,freq) VALUES (?,?,?,?)";
						PreparedStatement pstmt = conn.conn.prepareStatement(sql);
						pstmt.setLong(1, col_id);
						pstmt.setString(2, "abstract");
						pstmt.setString(3, term);
						pstmt.setInt(4, freq);
						pstmt.executeUpdate();
						pstmt.close();
					}
				}
				
			}
		}
		
	}

	private String cleanNstem(String content, Html2Text htmlParser, removeStopWords rsw) throws IOException{
		//Cleaning and stemming processes
		content = content.trim().replaceAll("\\<.*?>"," ");
		htmlParser.parse(content);
		content = htmlParser.getText();
		content = rsw.getResult(content);
		content = RunKStemmer.transform(content);
		return content;
	}
	
	private HashMap<String, Integer> extractTF(String content){
		/**
		 * Extracting Term Frequency (TF)
		 * */
		String[] token = content.split("\\s+");
		HashMap<String, Integer> tfMap = null;
		if(token != null){
			tfMap = new HashMap<String, Integer>();
			for(int i=0;i < token.length;i++){
				int freq = 0;
				if(tfMap.containsKey(token[i])){
					freq = tfMap.get(token[i]);
				}
				freq++;
				tfMap.put(token[i], freq);
			}
		}
		return tfMap;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		connectDB conn = new connectDB();
		String sql = "SELECT col_id FROM colloquium WHERE col_id >= 1119";
		ResultSet rs = conn.getResultSet(sql);
		try {
			while(rs.next()){
				long col_id = rs.getLong("col_id");
				new CometStemmer(conn, col_id);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
