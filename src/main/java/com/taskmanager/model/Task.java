package com.taskmanager.model;

public class Task {
	    private int id;
	    private String title;
	    private String status;
	    private int userId;
	    private String dueDate;

	    public String getDueDate() {
	        return dueDate;
	    }

	    public void setDueDate(String dueDate) {
	        this.dueDate = dueDate;
	    }
	    
		public int getId() {
			return id;
		}
		public void setId(int id) {
			this.id = id;
		}
		public String getTitle() {
			return title;
		}
		public void setTitle(String title) {
			this.title = title;
		}
		public String getStatus() {
			return status;
		}
		public void setStatus(String status) {
			this.status = status;
		}
		public int getUserId() {
			return userId;
		}
		public void setUserId(int userId) {
			this.userId = userId;
		}
	    
	    
}
