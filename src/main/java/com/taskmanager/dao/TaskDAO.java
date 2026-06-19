package com.taskmanager.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.taskmanager.model.Task;
import com.taskmanager.util.DBConnection;

public class TaskDAO {

    // Add Task
    public boolean addTask(Task task) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql =
            		"INSERT INTO tasks(title, due_date, status, user_id) VALUES(?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDueDate());
            ps.setString(3, task.getStatus());
            ps.setInt(4, task.getUserId());

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

                Task task = new Task();

                task.setId(rs.getInt("id"));
                task.setTitle(rs.getString("title"));
                task.setDueDate(rs.getString("due_date"));
                task.setStatus(rs.getString("status"));
                task.setUserId(rs.getInt("user_id"));

                taskList.add(task);
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

            String sql = "UPDATE tasks SET status='Completed' WHERE id=?";

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

                task = new Task();

                task.setId(rs.getInt("id"));
                task.setTitle(rs.getString("title"));
                task.setDueDate(rs.getString("due_date"));
                task.setStatus(rs.getString("status"));
                task.setUserId(rs.getInt("user_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return task;
    }
}