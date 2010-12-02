package edu.pitt.sis;

// MailNotifier.java by Rowland http://home.comcast.net/~rowland3/
// uses JavaMail to send a message

// NOTE: Needs mail.jar and activation.jar in CLASSPATH to run
//       Needs mail.jar to compile

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import edu.pitt.sis.db.connectDB;

import java.net.InetAddress;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

/** MailNotifier - a utility class to send a SMTP mail notification **/
public class MailNotifier {
	final String localhost;
    final String mailhost;
    final String mailuser;
    final String[] email_notify;
    protected Session session= null;
	                    
    public MailNotifier(String _localhost, String _mailhost, String _mailuser, String[] _email_notify) {
    	localhost= _localhost;
	    mailhost= _mailhost;
	    mailuser= _mailuser;
        email_notify= _email_notify;
    }
	                        
    public void send(String subject, String text)  throws Exception {
    	send(email_notify, subject, text);
    }
    public void send(String[] _to, String subject, String text) throws Exception{
		if(_to != null){
			if (session== null) {
				Properties p = new Properties();
				p.put("mail.transport.protocol", "smtp");
				p.put("mail.smtp.host", mailhost);
				p.put("mail.user",mailuser);
				p.put("mail.smtp.port","465");
				p.put("mail.smtp.socketFactory.port","465");
				p.put("mail.smtp.auth", "true");
				p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		        p.put("mail.smtp.socketFactory.fallback", "false");
				
				Authenticator auth = new Authenticator("comet.paws@gmail.com","colloquium");//("chw20@pitt.edu","@kongman@");
				session = Session.getDefaultInstance(p, auth);
				
				//session.setDebug(true);
				
				// Try to fake out SMTPTransport.java and get working EHLO:
				Properties properties = session.getProperties();
				String key= "mail.smtp.localhost";
				String prop= properties.getProperty(key);
				if (prop== null){
					properties.put(key, localhost);
				}else{
					System.out.println(key+ ": "+ prop);
				}
				
				//session.setDebug(true);
			}
			if(_to != null){
				for(int i=0;i < (_to.length-1)/100 + 1;i++){
					int k = 100*(i+1);
					if(k > _to.length){
						k = _to.length - 100*i;
					}
					MimeMessage msg = new MimeMessage(session);
					msg.setText(text);
					msg.setSubject(subject);
					Address fromAddr = new InternetAddress(mailuser);
					msg.setFrom(fromAddr);
					for(int j=0;j<k;j++){
						if(j==0){
							Address toAddr = new InternetAddress(_to[j + i*100].trim());
							msg.addRecipient(Message.RecipientType.TO, toAddr);       
						}else{
							Address toAddr = new InternetAddress(_to[j + i*100].trim());
							msg.addRecipient(Message.RecipientType.CC, toAddr);       
						}
					}
					Transport.send(msg);
					
				}
			}
		}
		// Note: will use results of getLocalHost() to fill in EHLO domain
    }
    
	/**
	 * Get the name of the local host, for use in the EHLO and HELO commands.
	 * The property mail.smtp.localhost overrides what InetAddress would tell
	 * us.
	 * Adapted from SMTPTransport.java
	 */
	public String getLocalHost() {
		String localHostName= null;
		String name = "smtp";  // Name of this protocol
		try {
			// get our hostname and cache it for future use
			if (localHostName == null || localHostName.length() <= 0)
				localHostName =  session.getProperty("mail." + name + ".localhost");      
			if (localHostName == null || localHostName.length() <= 0)
				localHostName = InetAddress.getLocalHost().getHostName();
		} catch (Exception uhex) {}
		return localHostName;
	}
	   
	public static void suggestionNotify(long col_id,String[] recipient,String sender_name,String sender_email){
		String localhost= "washington.sis.pitt.edu";
		String mailhost= "smtp.gmail.com";//"smtp.pitt.edu";
		String mailuser= "NoReply";
		String[] email_notify= recipient;
    
		//Email notifying
		String sql = "SELECT c.col_id,c.title,s.name,h.host,c.location,c.detail,date_format(c._date,_utf8'%b %d, %Y') _date," +
				"date_format(c.begintime,_utf8'%l:%i %p') _begin, " +
				"date_format(c.endtime,_utf8'%l:%i %p') _end " +
				"FROM colloquium c,speaker s,host h " +
				"WHERE c.speaker_id = s.speaker_id AND " +
				"c.host_id = h.host_id AND " +
				"c.col_id = " + col_id;
		connectDB con = new connectDB();
		ResultSet rs = con.getResultSet(sql);
		try {
			if(rs.next()){
				String content = //"Dear my friend,\n\n" + 
								//"This e-mail is on behalf of the CoMeT Sysytem:\n\n" + 
								sender_name + "(" + sender_email + ") sugguest this colloquium to you as follows.\n\n" + 
								"Title: " + rs.getString("title") + "\n" +
								"Speaker: " + rs.getString("name") +  "\n" +
								"Host: " + rs.getString("host") + "\n" + 
								"Date: " + rs.getString("_date") + "\n" +
								"Time: " + rs.getString("_begin") + " - " + rs.getString("_end") + "\n" +
								"Location: " + rs.getString("location") + "\n\n" +
								"More detail please visit http://halley.exp.sis.pitt.edu/comet/presentColloquium.do?col_id=" + col_id;

				System.out.println(content);
				
				String subject = "CoMeT: " + sender_name + " sugguested colloquium to you";

				MailNotifier mn= new MailNotifier(localhost, mailhost, mailuser, email_notify);
				try {
					mn.send(subject, content);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					System.out.println("Sending Error: " + e.getLocalizedMessage());
				}  
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			try {
				con.conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			con = null;
		}
	}
	
	private class Authenticator extends javax.mail.Authenticator {
		private String username;
		private String password; 
		public Authenticator(String username, String password) {
			// TODO Auto-generated constructor stub
			this.username = username;
			this.password = password;
		}
		protected PasswordAuthentication getPasswordAuthentication(){
			return new PasswordAuthentication(username,password);
		}
	}
	
	/** main() for testing only **/
	public static void main(String args[]) {
		// Adapt to your needs:
		/*String localhost= "washington.sis.pitt.edu";
		String mailhost= "smtp.gmail.com";//"smtp.pitt.edu";
		String mailuser= "NoReply";
		String subject = "CoMeT: tested peterb sugguested colloquium to you";
		String content = "Dear my friend,\n\n" + 
							"This e-mail is on behalf of the CoMeT Sysytem:\n\n" + 
							"peterb (peterb@pitt.edu) sugguest this colloquium to you as follows.\n\n" + 
							"Title: Emergent uses of Accessibility and Social Media for Emergencies\n" +
							"Speaker: Alessio Malizia\n" +
							"Host: \n" + 
							"Date: Dec 02, 2009\n" +
							"Time: 4:00 PM - 5:00 PM\n" +
							"Location: SENSQ 5317\n\n" +
							"More detail please visit http://washington.sis.pitt.edu/comet/presentColloquium.do?col_id=94";
		String[] email_notify= {"Chirayu <chirayu.kong@gmail.com>"};
    
		MailNotifier mn= new MailNotifier(localhost, mailhost, mailuser, email_notify);
		try {
			mn.send(subject, content);  
		} catch (Exception E) {
			System.out.println(E.toString());  
		}*/
		
		String[] requst_email = new String[1]; 
		requst_email[0] = "kshaffer@sis.pitt.edu";//request.getParameter("email");
		String encryptionScheme = StringEncrypter.DESEDE_ENCRYPTION_SCHEME;		
		StringEncrypter encrypter;
		String DecryptedPassword = "";
		String EncryptedPassword = "";
		String name = "";
		
		String sql = "SELECT Pass,name FROM userinfo WHERE TRIM(LOWER(Email)) = '"+ 
						requst_email[0].replaceAll("'", "''").trim().toLowerCase() + "'";
		connectDB conn = new connectDB();

		ResultSet rs = conn.getResultSet(sql);
		try {
			if(rs.next()){
				EncryptedPassword = rs.getString("Pass");
				name = rs.getString("name");
			}
			conn.conn.close();
		} catch (SQLException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		try {
			encrypter = new StringEncrypter(encryptionScheme, BasicFunctions.encKey);
			DecryptedPassword = encrypter.decrypt(EncryptedPassword);
		} catch (StringEncrypter.EncryptionException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		String localhost= "washington.sis.pitt.edu";
		String mailhost= "smtp.gmail.com";
		String mailuser= "NoReply";
		MailNotifier mail = new MailNotifier(localhost,mailhost,mailuser,requst_email);
		String emailContent = "Dear " + name + "\n\n" +
		"This automated e-mail of the CoMeT Sysytem:\n\n" + 
		"Your password is " + DecryptedPassword + "\n\n" +
		"CoMeT Website: http://washington.sis.pitt.edu/comet ";
		
		try {
			mail.send("Lost Password | CoMeT", emailContent);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		conn = null;  
		
	}
}