package com.voting.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.voting.model.Candidate;
import com.voting.util.DatabaseUtil;

public class CandidateDAO {
    public List<Candidate> getCandidatesByElection(int electionId) throws SQLException {
        System.out.println("CandidateDAO: Getting candidates for election " + electionId);
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT * FROM candidates WHERE election_id = ? ORDER BY votes DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            System.out.println("CandidateDAO: Executing SQL: " + sql + " with electionId = " + electionId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                System.out.println("CandidateDAO: Executed query, processing results");
                while (rs.next()) {
                    Candidate candidate = new Candidate();
                    candidate.setCandidateId(rs.getInt("candidate_id"));
                    candidate.setElectionId(rs.getInt("election_id"));
                    candidate.setName(rs.getString("name"));
                    candidate.setParty(rs.getString("party"));
                    candidate.setSymbol(rs.getString("symbol"));
                    candidate.setManifesto(rs.getString("manifesto"));
                    candidate.setVotes(rs.getInt("votes"));
                    candidates.add(candidate);
                    System.out.println("CandidateDAO: Added candidate: " + candidate.getName() + " (ID: " + candidate.getCandidateId() + ")");
                }
                System.out.println("CandidateDAO: Total candidates found: " + candidates.size());
            }
        }
        return candidates;
    }

    public boolean addCandidate(Candidate candidate) throws SQLException {
        // First check if the election exists
        if (!isElectionExists(candidate.getElectionId())) {
            throw new SQLException("Election with ID " + candidate.getElectionId() + " does not exist");
        }

        String sql = "INSERT INTO candidates (election_id, name, party, symbol, manifesto, votes) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, candidate.getElectionId());
            pstmt.setString(2, candidate.getName());
            pstmt.setString(3, candidate.getParty());
            pstmt.setString(4, candidate.getSymbol());
            pstmt.setString(5, candidate.getManifesto());
            pstmt.setInt(6, candidate.getVotes());
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: " + candidate.getElectionId() + ", " + candidate.getName() + ", " + 
                             candidate.getParty() + ", " + candidate.getSymbol() + ", " + candidate.getManifesto() + 
                             ", " + candidate.getVotes());
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
        }
    }

    private boolean isElectionExists(int electionId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM elections WHERE election_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }
        return false;
    }

    public boolean updateCandidateVotes(int candidateId) throws SQLException {
        String sql = "UPDATE candidates SET votes = votes + 1 WHERE candidate_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, candidateId);
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public Candidate getCandidateById(int candidateId) throws SQLException {
        String sql = "SELECT * FROM candidates WHERE candidate_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, candidateId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Candidate candidate = new Candidate();
                    candidate.setCandidateId(rs.getInt("candidate_id"));
                    candidate.setElectionId(rs.getInt("election_id"));
                    candidate.setName(rs.getString("name"));
                    candidate.setParty(rs.getString("party"));
                    candidate.setSymbol(rs.getString("symbol"));
                    candidate.setManifesto(rs.getString("manifesto"));
                    candidate.setVotes(rs.getInt("votes"));
                    return candidate;
                }
            }
        }
        return null;
    }

    public List<Candidate> getAllCandidates(int electionId) throws SQLException {
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT * FROM candidates WHERE election_id = ? ORDER BY name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Candidate candidate = new Candidate();
                    candidate.setCandidateId(rs.getInt("candidate_id"));
                    candidate.setElectionId(rs.getInt("election_id"));
                    candidate.setName(rs.getString("name"));
                    candidate.setParty(rs.getString("party"));
                    candidate.setSymbol(rs.getString("symbol"));
                    candidate.setManifesto(rs.getString("manifesto"));
                    candidate.setVotes(rs.getInt("votes"));
                    candidates.add(candidate);
                }
            }
        }
        return candidates;
    }
} 