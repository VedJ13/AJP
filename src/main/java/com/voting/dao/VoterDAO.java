package com.voting.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.voting.model.Voter;
import com.voting.util.DatabaseUtil;

public class VoterDAO {
    public boolean registerVoter(Voter voter) throws SQLException {
        String sql = "INSERT INTO voters (voter_id, name, password, email, phone, address) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, voter.getVoterId());
            pstmt.setString(2, voter.getName());
            pstmt.setString(3, voter.getPassword());
            pstmt.setString(4, voter.getEmail());
            pstmt.setString(5, voter.getPhone());
            pstmt.setString(6, voter.getAddress());
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public Voter getVoterById(String voterId) throws SQLException {
        String sql = "SELECT * FROM voters WHERE voter_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, voterId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Voter voter = new Voter();
                    voter.setVoterId(rs.getString("voter_id"));
                    voter.setName(rs.getString("name"));
                    voter.setPassword(rs.getString("password"));
                    voter.setEmail(rs.getString("email"));
                    voter.setPhone(rs.getString("phone"));
                    voter.setAddress(rs.getString("address"));
                    voter.setHasVoted(rs.getBoolean("has_voted"));
                    voter.setCreatedAt(rs.getTimestamp("created_at"));
                    return voter;
                }
            }
        }
        return null;
    }

    public boolean updateVoterStatus(String voterId, boolean hasVoted) throws SQLException {
        String sql = "UPDATE voters SET has_voted = ? WHERE voter_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBoolean(1, hasVoted);
            pstmt.setString(2, voterId);
            
            return pstmt.executeUpdate() > 0;
        }
    }
} 