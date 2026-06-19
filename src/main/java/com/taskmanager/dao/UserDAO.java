package com.taskmanager.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.taskmanager.model.User;
import com.taskmanager.util.DBConnection;
import com.taskmanager.util.PasswordUtil;

public class UserDAO {

    private User mapRow(ResultSet rs) throws Exception {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setProfileImage(rs.getString("profile_image"));
        return user;
    }

    // Register User
    public boolean registerUser(User user) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO users(username, email, password) VALUES(?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // Authenticate user by email and password
    public User authenticate(String email, String password) {

        User user = getUserByEmail(email);

        if (user == null) {
            return null;
        }

        if (!PasswordUtil.verify(password, user.getPassword())) {
            return null;
        }

        if (!PasswordUtil.isHashed(user.getPassword())) {
            String hashed = PasswordUtil.hash(password);
            updatePassword(user.getId(), hashed);
            user.setPassword(hashed);
        }

        return user;
    }

    // Get user by email
    public User getUserByEmail(String email) {

        User user = null;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM users WHERE email=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = mapRow(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    // Login User (legacy entry point)
    public User loginUser(String email, String password) {
        return authenticate(email, password);
    }

    // Check Username Exists
    public boolean usernameExists(String username) {

        boolean exists = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT id FROM users WHERE username=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    // Check Email Exists
    public boolean emailExists(String email) {

        boolean exists = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT id FROM users WHERE email=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    // Check email exists for another user
    public boolean emailExistsForOtherUser(String email, int userId) {

        boolean exists = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT id FROM users WHERE email=? AND id<>?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setInt(2, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    // Check username exists for another user
    public boolean usernameExistsForOtherUser(String username, int userId) {

        boolean exists = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT id FROM users WHERE username=? AND id<>?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, username);
            ps.setInt(2, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    // Get User By Id
    public User getUserById(int userId) {

        User user = null;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM users WHERE id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = mapRow(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    // Update profile details
    public boolean updateProfile(int userId, String username, String email) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE users SET username=?, email=? WHERE id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setInt(3, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // Update password
    public boolean updatePassword(int userId, String hashedPassword) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE users SET password=? WHERE id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // Update profile image path
    public boolean updateProfileImage(int userId, String profileImagePath) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE users SET profile_image=? WHERE id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, profileImagePath);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}
