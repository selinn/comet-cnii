package edu.pitt.sis.beans;

import java.util.HashSet;

public class UserBean {
	private long userID;	
	private String name;
	private int roleID;
	private HashSet<Integer> recSet;
	private HashSet<Integer> bookSet;
	public UserBean(){
		recSet = new HashSet<Integer>();
		bookSet = new HashSet<Integer>();
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public long getUserID() {
		return userID;
	}
	public void setUserID(int userID) {
		this.userID = userID;
	}
	public int getRoleID() {
		return roleID;
	}
	public void setRoleID(int roleID) {
		this.roleID = roleID;
	}
	public HashSet<Integer> getRecSet() {
		return recSet;
	}
	public HashSet<Integer> getBookSet() {
		return bookSet;
	}
		
}
