package com.voting.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.voting.model.Election;
import com.voting.util.DatabaseUtil;

public class ElectionDAO {
    public boolean createElection(Election election) throws SQLException {
        String sql = "INSERT INTO elections (title, description, start_date, end_date, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, election.getTitle());
            pstmt.setString(2, election.getDescription());
            pstmt.setDate(3, new java.sql.Date(election.getStartDate().getTime()));
            pstmt.setDate(4, new java.sql.Date(election.getEndDate().getTime()));
            pstmt.setString(5, election.getStatus());
            
            return pstmt.executeUpdate() > 0;
        }
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
                    election.setStartDate(rs.getDate("start_date"));
                    election.setEndDate(rs.getDate("end_date"));
                    election.setStatus(rs.getString("status"));
                    return election;
                }
            }
        }
        return null;
    }
    
    public List<Election> getAllElections() throws SQLException {
        List<Election> elections = new ArrayList<>();
        String sql = "SELECT * FROM elections ORDER BY start_date DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Election election = new Election();
                    election.setElectionId(rs.getInt("election_id"));
                    election.setTitle(rs.getString("title"));
                    election.setDescription(rs.getString("description"));
                    election.setStartDate(rs.getDate("start_date"));
                    election.setEndDate(rs.getDate("end_date"));
                    election.setStatus(rs.getString("status"));
                    elections.add(election);
                }
            }
        }
        return elections;
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
    
    public boolean isElectionActive(int electionId) throws SQLException {
        System.out.println("ElectionDAO: Checking if election " + electionId + " is active");
        String sql = "SELECT status FROM elections WHERE election_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    System.out.println("ElectionDAO: Found election with status: " + status);
                    boolean isActive = "ACTIVE".equalsIgnoreCase(status);
                    System.out.println("ElectionDAO: Is election active? " + isActive);
                    return isActive;
                } else {
                    System.out.println("ElectionDAO: No election found with ID: " + electionId);
                }
            }
        }
        return false;
    }
} 