package com.taskmanager.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import com.taskmanager.util.DBConnection;

public class OtpDAO {

    public void invalidateExistingOtps(String email) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE password_reset_otps SET is_used=1 WHERE email=? AND is_used=0";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean saveOtp(String email, String otp, LocalDateTime expiresAt) {
        boolean status = false;
        try {
            invalidateExistingOtps(email);
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO password_reset_otps(email, otp_code, expires_at, is_used) VALUES(?,?,?,0)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, otp);
            ps.setTimestamp(3, Timestamp.valueOf(expiresAt));
            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public boolean verifyOtp(String email, String otp) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT id, expires_at, is_used FROM password_reset_otps "
                    + "WHERE email=? AND otp_code=? ORDER BY id DESC LIMIT 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                if (rs.getInt("is_used") == 1) {
                    return false;
                }
                Timestamp expiresAt = rs.getTimestamp("expires_at");
                if (expiresAt == null || LocalDateTime.now().isAfter(expiresAt.toLocalDateTime())) {
                    return false;
                }
                int id = rs.getInt("id");
                markUsed(id);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void markUsed(int otpId) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE password_reset_otps SET is_used=1 WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, otpId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
