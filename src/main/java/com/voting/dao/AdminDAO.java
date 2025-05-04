package com.voting.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.voting.model.Admin;
import com.voting.util.DatabaseUtil;

public class AdminDAO {
    public Admin authenticateAdmin(String username, String password) throws SQLException {
        String sql = "SELECT * FROM admins WHERE username = ? AND password = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setPassword(rs.getString("password"));
                    admin.setEmail(rs.getString("email"));
                    admin.setCreatedAt(rs.getTimestamp("created_at"));
                    return admin;
                }
            }
        }
        return null;
    }

    public boolean createAdmin(Admin admin) throws SQLException {
        String sql = "INSERT INTO admins (username, password, email) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, admin.getUsername());
            pstmt.setString(2, admin.getPassword());
            pstmt.setString(3, admin.getEmail());
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public Admin getAdminById(int adminId) throws SQLException {
        String sql = "SELECT * FROM admins WHERE admin_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, adminId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setPassword(rs.getString("password"));
                    admin.setEmail(rs.getString("email"));
                    admin.setCreatedAt(rs.getTimestamp("created_at"));
                    return admin;
                }
            }
        }
        return null;
    }
} 