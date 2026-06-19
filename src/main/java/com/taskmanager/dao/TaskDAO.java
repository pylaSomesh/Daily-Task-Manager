package com.taskmanager.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.taskmanager.model.Task;
import com.taskmanager.model.TaskReminder;
import com.taskmanager.util.DBConnection;
import com.taskmanager.model.AnalyticsDTO;

public class TaskDAO {

	private Task mapRow(ResultSet rs) throws SQLException {
		Task task = new Task();
		task.setId(rs.getInt("id"));
		task.setTitle(rs.getString("title"));
		task.setDueDate(rs.getString("due_date"));
		task.setStatus(rs.getString("status"));
		task.setUserId(rs.getInt("user_id"));
		task.setPriority(rs.getString("priority"));
		task.setCategory(rs.getString("category"));
		return task;
	}

	// Add Task
	public boolean addTask(Task task) {

		boolean status = false;

		try {
			Connection con = DBConnection.getConnection();

			String sql = "INSERT INTO tasks(title, due_date, priority, category, status, user_id) VALUES(?,?,?,?,?,?)";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setString(1, task.getTitle());
			ps.setString(2, task.getDueDate());
			ps.setString(3, task.getPriority());
			ps.setString(4, task.getCategory());
			ps.setString(5, task.getStatus());
			ps.setInt(6, task.getUserId());

			int rows = ps.executeUpdate();

			if (rows > 0) {
				status = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return status;
	}

	// Get All Tasks By User
	public List<Task> getTasksByUser(int userId) {

		List<Task> taskList = new ArrayList<>();

		try {
			Connection con = DBConnection.getConnection();

			String sql = "SELECT * FROM tasks WHERE user_id=? ORDER BY id DESC";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				taskList.add(mapRow(rs));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return taskList;
	}

	// Search and filter tasks for a user
	public List<Task> searchTasksByUser(int userId, String search, String statusFilter, String categoryFilter) {

		List<Task> taskList = new ArrayList<>();

		try {
			Connection con = DBConnection.getConnection();

			StringBuilder sql = new StringBuilder("SELECT * FROM tasks WHERE user_id=?");
			List<Object> params = new ArrayList<>();
			params.add(userId);

			if (search != null && !search.trim().isEmpty()) {
				sql.append(" AND title LIKE ?");
				params.add("%" + search.trim() + "%");
			}

			if (statusFilter != null && !statusFilter.trim().isEmpty()
					&& !"All".equalsIgnoreCase(statusFilter.trim())) {
				sql.append(" AND status=?");
				params.add(statusFilter.trim());
			}

			if (categoryFilter != null && !categoryFilter.trim().isEmpty()
					&& !"All".equalsIgnoreCase(categoryFilter.trim())) {
				sql.append(" AND category=?");
				params.add(categoryFilter.trim());
			}

			sql.append(" ORDER BY id DESC");

			PreparedStatement ps = con.prepareStatement(sql.toString());

			for (int i = 0; i < params.size(); i++) {
				ps.setObject(i + 1, params.get(i));
			}

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				taskList.add(mapRow(rs));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return taskList;
	}

	// Mark Task as Completed
	public boolean markCompleted(int taskId) {

		boolean status = false;

		try {

			Connection con = DBConnection.getConnection();

			String sql = "UPDATE tasks " + "SET status='Completed', " + "completed_at=NOW() " + "WHERE id=?";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setInt(1, taskId);

			int rows = ps.executeUpdate();

			if (rows > 0) {

				status = true;
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return status;
	}

	// Delete Task
	public boolean deleteTask(int taskId) {

		boolean status = false;

		try {
			Connection con = DBConnection.getConnection();

			String sql = "DELETE FROM tasks WHERE id=?";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setInt(1, taskId);

			int rows = ps.executeUpdate();

			if (rows > 0) {
				status = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return status;
	}

	// Get Task By Id
	public Task getTaskById(int taskId) {

		Task task = null;

		try {
			Connection con = DBConnection.getConnection();

			String sql = "SELECT * FROM tasks WHERE id=?";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setInt(1, taskId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				task = mapRow(rs);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return task;
	}

	// Get Task By Id for a specific user
	public Task getTaskByIdAndUser(int taskId, int userId) {

		Task task = null;

		try {
			Connection con = DBConnection.getConnection();

			String sql = "SELECT * FROM tasks WHERE id=? AND user_id=?";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setInt(1, taskId);
			ps.setInt(2, userId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				task = mapRow(rs);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return task;
	}

	// Update Task
	public boolean updateTask(Task task) {

		boolean status = false;

		try {
			Connection con = DBConnection.getConnection();

			String sql = "UPDATE tasks SET title=?, due_date=?, priority=?, category=? WHERE id=? AND user_id=?";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setString(1, task.getTitle());
			ps.setString(2, task.getDueDate());
			ps.setString(3, task.getPriority());
			ps.setString(4, task.getCategory());
			ps.setInt(5, task.getId());
			ps.setInt(6, task.getUserId());

			int rows = ps.executeUpdate();

			if (rows > 0) {
				status = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return status;
	}

	public List<Task> getOverdueTasks() {

		List<Task> taskList = new ArrayList<>();

		try {

			Connection con = DBConnection.getConnection();

			String sql = "SELECT * FROM tasks " + "WHERE due_date < CURDATE() " + "AND status='Pending'";

			PreparedStatement ps = con.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				taskList.add(mapRow(rs));
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return taskList;
	}

	public List<TaskReminder> getOverdueTaskReminders() {

		List<TaskReminder> list = new ArrayList<>();

		try {

			Connection con = DBConnection.getConnection();

			String sql = "SELECT u.username, u.email, " + "t.title, t.due_date " + "FROM tasks t " + "JOIN users u "
					+ "ON t.user_id=u.id " + "WHERE t.status='Pending' " + "AND t.due_date < CURDATE()";

			PreparedStatement ps = con.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				TaskReminder reminder = new TaskReminder();

				reminder.setUsername(rs.getString("username"));

				reminder.setEmail(rs.getString("email"));

				reminder.setTitle(rs.getString("title"));

				reminder.setDueDate(rs.getString("due_date"));

				list.add(reminder);
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return list;
	}

	public List<TaskReminder> getOverdueTasksByEmail(String email) {

		List<TaskReminder> list = new ArrayList<>();

		try {

			Connection con = DBConnection.getConnection();

			String sql = "SELECT u.username, u.email, " + "t.title, t.due_date " + "FROM tasks t " + "JOIN users u "
					+ "ON t.user_id=u.id " + "WHERE u.email=? " + "AND t.status='Pending' "
					+ "AND t.due_date < CURDATE()";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setString(1, email);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				TaskReminder reminder = new TaskReminder();

				reminder.setUsername(rs.getString("username"));

				reminder.setEmail(rs.getString("email"));

				reminder.setTitle(rs.getString("title"));

				reminder.setDueDate(rs.getString("due_date"));

				list.add(reminder);
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return list;
	}

	public AnalyticsDTO getAnalytics(int userId) {

		AnalyticsDTO analytics = new AnalyticsDTO();

		try {

			Connection con = DBConnection.getConnection();

			// Total Tasks

			String totalSql = "SELECT COUNT(*) FROM tasks WHERE user_id=?";

			PreparedStatement totalPs = con.prepareStatement(totalSql);

			totalPs.setInt(1, userId);

			ResultSet totalRs = totalPs.executeQuery();

			if (totalRs.next()) {

				analytics.setTotalTasks(totalRs.getInt(1));
			}

			// Completed Tasks

			String completedSql = "SELECT COUNT(*) FROM tasks " + "WHERE user_id=? " + "AND status='Completed'";

			PreparedStatement completedPs = con.prepareStatement(completedSql);

			completedPs.setInt(1, userId);

			ResultSet completedRs = completedPs.executeQuery();

			if (completedRs.next()) {

				analytics.setCompletedTasks(completedRs.getInt(1));
			}

			// Pending Tasks

			String pendingSql = "SELECT COUNT(*) FROM tasks " + "WHERE user_id=? " + "AND status='Pending'";

			PreparedStatement pendingPs = con.prepareStatement(pendingSql);

			pendingPs.setInt(1, userId);

			ResultSet pendingRs = pendingPs.executeQuery();

			if (pendingRs.next()) {

				analytics.setPendingTasks(pendingRs.getInt(1));
			}

			// Overdue Tasks

			String overdueSql = "SELECT COUNT(*) FROM tasks " + "WHERE user_id=? " + "AND status='Pending' "
					+ "AND due_date < CURDATE()";

			PreparedStatement overduePs = con.prepareStatement(overdueSql);

			overduePs.setInt(1, userId);

			ResultSet overdueRs = overduePs.executeQuery();

			if (overdueRs.next()) {

				analytics.setOverdueTasks(overdueRs.getInt(1));
			}

			// Completion Rate

			if (analytics.getTotalTasks() > 0) {

				double rate = ((double) analytics.getCompletedTasks() / analytics.getTotalTasks()) * 100;

				analytics.setCompletionRate(rate);
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return analytics;
	}

	public List<Task> getTasksByStatus(int userId, String status) {

		List<Task> tasks = new ArrayList<>();

		try {

			Connection con = DBConnection.getConnection();

			String sql = "SELECT * FROM tasks " + "WHERE user_id=? " + "AND status=? " + "ORDER BY id DESC";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setInt(1, userId);
			ps.setString(2, status);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				tasks.add(mapRow(rs));
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return tasks;
	}

	public List<Task> getOverdueTasksByUser(int userId) {

		List<Task> taskList = new ArrayList<>();

		try {

			Connection con = DBConnection.getConnection();

			String sql = "SELECT * FROM tasks " + "WHERE user_id=? " + "AND status='Pending' "
					+ "AND due_date < CURDATE() " + "ORDER BY due_date ASC";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				taskList.add(mapRow(rs));
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return taskList;
	}

	public Map<String, Integer> getMonthlyCompletedTasks(int userId) {

		Map<String, Integer> data = new LinkedHashMap<>();
		String sql = """
				        	    SELECT

				        	  DATE_FORMAT(completed_at,'%Y-%m') AS month,

				        	    COUNT(*) AS total

				        	    FROM tasks

				        	    WHERE user_id = ?
				        	    AND status = 'Completed'
				        	    AND completed_at IS NOT NULL

				        	    GROUP BY month

				        	    ORDER BY
				        	    MIN(completed_at)
				        	    """;

		try (Connection con = DBConnection.getConnection();

				PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				data.put(rs.getString("month"), rs.getInt("total"));
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return data;
	}

	public AnalyticsDTO getAnalyticsByMonth(
	        int userId,
	        String month) {

	    AnalyticsDTO dto =
	            new AnalyticsDTO();

	    String sql = """
	        SELECT

	        COUNT(*) total,

	        SUM(
	            CASE
	            WHEN status='Completed'
	            THEN 1
	            ELSE 0
	            END
	        ) completed,

	        SUM(
	            CASE
	            WHEN status='Pending'
	            THEN 1
	            ELSE 0
	            END
	        ) pending,

	        SUM(
	            CASE
	            WHEN due_date < CURDATE()
	            AND status!='Completed'
	            THEN 1
	            ELSE 0
	            END
	        ) overdue

	        FROM tasks

	        WHERE user_id=?

	        AND DATE_FORMAT(
	            completed_at,
	            '%Y-%m'
	        )=?
	        """;

	    try(
	        Connection con =
	            DBConnection.getConnection();

	        PreparedStatement ps =
	            con.prepareStatement(sql)
	    ){

	        ps.setInt(
	            1,
	            userId);

	        ps.setString(
	            2,
	            month);

	        ResultSet rs =
	        	    ps.executeQuery();

	        	if(rs.next()){

	        	    dto.setTotalTasks(
	        	        rs.getInt("total"));

	        	    dto.setCompletedTasks(
	        	        rs.getInt("completed"));

	        	    dto.setPendingTasks(
	        	        rs.getInt("pending"));

	        	    dto.setOverdueTasks(
	        	        rs.getInt("overdue"));

	        	    double rate = 0;

	        	    if(dto.getTotalTasks() > 0){

	        	        rate =
	        	        (dto.getCompletedTasks()
	        	        * 100.0)

	        	        / dto.getTotalTasks();
	        	    }

	        	    dto.setCompletionRate(
	        	        rate);
	        	}
	        
	    }catch(Exception e){

	        e.printStackTrace();
	    }

	    return dto;
	}
	
	public List<Task>
	getTasksByMonth(
	        int userId,
	        String month){

	    List<Task> tasks =
	            new ArrayList<>();

	    String sql = """
	        SELECT *
	        FROM tasks
	        WHERE user_id=?
	        AND DATE_FORMAT(
	            completed_at,
	            '%Y-%m'
	        )=?
	        ORDER BY completed_at
	        """;

	    try(
	        Connection con =
	            DBConnection.getConnection();

	        PreparedStatement ps =
	            con.prepareStatement(sql)
	    ){

	        ps.setInt(1,userId);
	        ps.setString(2,month);

	        ResultSet rs =
	            ps.executeQuery();

	        while(rs.next()){

	            Task task =
	                    new Task();

	            task.setTitle(
	                rs.getString(
	                    "title"));

	            task.setStatus(
	                rs.getString(
	                    "status"));

	            task.setDueDate(
	            	    rs.getString(
	            	        "due_date"));

	            tasks.add(task);
	        }

	    }catch(Exception e){

	        e.printStackTrace();
	    }

	    return tasks;
	}
	
	public List<Task>
	getTasksByStatusAndMonth(
	        int userId,
	        String status,
	        String month) {

	    List<Task> tasks =
	            new ArrayList<>();

	    String sql = """
	        SELECT *
	        FROM tasks
	        WHERE user_id = ?
	        AND status = ?
	        AND DATE_FORMAT(
	            completed_at,
	            '%Y-%m'
	        ) = ?
	        """;

	    try(
	        Connection con =
	            DBConnection.getConnection();

	        PreparedStatement ps =
	            con.prepareStatement(sql)
	    ){

	        ps.setInt(1,userId);
	        ps.setString(2,status);
	        ps.setString(3,month);

	        ResultSet rs =
	            ps.executeQuery();

	        while(rs.next()){

	            Task task =
	                new Task();

	            task.setTitle(
	                rs.getString("title"));

	            task.setStatus(
	                rs.getString("status"));

	            task.setDueDate(
	                rs.getString("due_date"));

	            tasks.add(task);
	        }

	    }catch(Exception e){

	        e.printStackTrace();
	    }

	    return tasks;
	}
	
	
	public List<Task>
	getOverdueTasksByMonth(
	        int userId,
	        String month){

	    List<Task> tasks =
	            new ArrayList<>();

	    String sql = """
	        SELECT *
	        FROM tasks
	        WHERE user_id = ?
	        AND due_date < CURDATE()
	        AND status != 'Completed'
	        AND DATE_FORMAT(
	            due_date,
	            '%Y-%m'
	        ) = ?
	        """;

	    try(
	        Connection con =
	            DBConnection.getConnection();

	        PreparedStatement ps =
	            con.prepareStatement(sql)
	    ){

	        ps.setInt(1,userId);
	        ps.setString(2,month);

	        ResultSet rs =
	            ps.executeQuery();

	        while(rs.next()){

	            Task task =
	                    new Task();

	            task.setTitle(
	                rs.getString(
	                    "title"));

	            task.setStatus(
	                rs.getString(
	                    "status"));

	            task.setDueDate(
	                rs.getString(
	                    "due_date"));

	            tasks.add(task);
	        }

	    }catch(Exception e){

	        e.printStackTrace();
	    }

	    return tasks;
	}
}
