package com.voting.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.voting.model.Election;
import com.voting.util.DatabaseUtil;

public class ElectionDAO {
    public List<Election> getAllElections() throws SQLException {
        List<Election> elections = new ArrayList<>();
        String sql = "SELECT * FROM elections ORDER BY start_date DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Election election = new Election();
                election.setElectionId(rs.getInt("election_id"));
                election.setTitle(rs.getString("title"));
                election.setDescription(rs.getString("description"));
                election.setStartDate(rs.getTimestamp("start_date"));
                election.setEndDate(rs.getTimestamp("end_date"));
                election.setStatus(rs.getString("status"));
                election.setCreatedAt(rs.getTimestamp("created_at"));
                elections.add(election);
            }
        }
        return elections;
    }

    public Election getElectionById(int electionId) throws SQLException {
        String sql = "SELECT * FROM elections WHERE election_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Election election = new Election();
                    election.setElectionId(rs.getInt("election_id"));
                    election.setTitle(rs.getString("title"));
                    election.setDescription(rs.getString("description"));
                    election.setStartDate(rs.getTimestamp("start_date"));
                    election.setEndDate(rs.getTimestamp("end_date"));
                    election.setStatus(rs.getString("status"));
                    election.setCreatedAt(rs.getTimestamp("created_at"));
                    return election;
                }
            }
        }
        return null;
    }

    public boolean createElection(Election election) throws SQLException {
        String sql = "INSERT INTO elections (title, description, start_date, end_date, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, election.getTitle());
            pstmt.setString(2, election.getDescription());
            pstmt.setTimestamp(3, election.getStartDate());
            pstmt.setTimestamp(4, election.getEndDate());
            pstmt.setString(5, election.getStatus());
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateElectionStatus(int electionId, String status) throws SQLException {
        String sql = "UPDATE elections SET status = ? WHERE election_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, electionId);
            
            return pstmt.executeUpdate() > 0;
        }
    }
} 