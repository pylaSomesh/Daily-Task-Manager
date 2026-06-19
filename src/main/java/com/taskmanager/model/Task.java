package com.taskmanager.model;

public class Task {
	    private int id;
	    private String title;
	    private String status;
	    private int userId;
	    private String dueDate;
	    private String priority;
	    private String category;

	    public String getDueDate() {
	        return dueDate;
	    }

	    public void setDueDate(String dueDate) {
	        this.dueDate = dueDate;
	    }

	    public String getPriority() {
	        return priority;
	    }

	    public void setPriority(String priority) {
	        this.priority = priority;
	    }

	    public String getCategory() {
	        return category;
	    }

	    public void setCategory(String category) {
	        this.category = category;
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
