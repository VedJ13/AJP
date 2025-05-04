package com.voting.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.voting.model.VoteResult;
import com.voting.model.Candidate;
import com.voting.util.DatabaseUtil;

public class VoteDAO {
    public boolean castVote(int electionId, String voterId, int candidateId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Check if voter has already voted
            String checkSql = "SELECT * FROM votes WHERE voter_id = ? AND election_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, voterId);
            pstmt.setInt(2, electionId);
            
            if (pstmt.executeQuery().next()) {
                return false; // Voter has already voted
            }
            
            // Record the vote
            String voteSql = "INSERT INTO votes (election_id, voter_id, candidate_id) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(voteSql);
            pstmt.setInt(1, electionId);
            pstmt.setString(2, voterId);
            pstmt.setInt(3, candidateId);
            pstmt.executeUpdate();
            
            // Update candidate's vote count
            String updateSql = "UPDATE candidates SET votes = votes + 1 WHERE candidate_id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, candidateId);
            pstmt.executeUpdate();
            
            // Update voter's has_voted status
            String voterSql = "UPDATE voters SET has_voted = TRUE WHERE voter_id = ?";
            pstmt = conn.prepareStatement(voterSql);
            pstmt.setString(1, voterId);
            pstmt.executeUpdate();
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.setAutoCommit(true);
                DatabaseUtil.closeConnection(conn);
            }
        }
    }

    public boolean hasVoted(int electionId, String voterId) throws SQLException {
        String sql = "SELECT * FROM votes WHERE election_id = ? AND voter_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            pstmt.setString(2, voterId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int getTotalVotes(int electionId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM votes WHERE election_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    public List<VoteResult> getVoteResults(int electionId) throws SQLException {
        List<VoteResult> results = new ArrayList<>();
        String sql = "SELECT c.candidate_id, c.name as candidate_name, c.party, c.votes, " +
                    "e.title as election_title, " +
                    "(SELECT COUNT(*) FROM votes WHERE election_id = ?) as total_votes " +
                    "FROM candidates c " +
                    "JOIN elections e ON c.election_id = e.election_id " +
                    "WHERE c.election_id = ? " +
                    "ORDER BY c.votes DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            pstmt.setInt(2, electionId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                int totalVotes = 0;
                if (rs.next()) {
                    totalVotes = rs.getInt("total_votes");
                    rs.beforeFirst();
                }
                
                while (rs.next()) {
                    VoteResult result = new VoteResult();
                    result.setElectionId(electionId);
                    result.setElectionTitle(rs.getString("election_title"));
                    result.setCandidateId(rs.getInt("candidate_id"));
                    result.setCandidateName(rs.getString("candidate_name"));
                    result.setParty(rs.getString("party"));
                    result.setVotes(rs.getInt("votes"));
                    result.setTotalVotes(totalVotes);
                    
                    // Calculate percentage
                    double percentage = totalVotes > 0 ? 
                        ((double) result.getVotes() / totalVotes) * 100 : 0;
                    result.setPercentage(percentage);
                    
                    results.add(result);
                }
            }
        }
        return results;
    }

    public boolean isVoted(int electionId, String voterId) throws SQLException {
        String sql = "SELECT * FROM votes WHERE election_id = ? AND voter_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            pstmt.setString(2, voterId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
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

    public String getElectionDescription(int electionId) throws SQLException {
        String sql = "SELECT description FROM elections WHERE election_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("description");
                }
            }
        }
        return null;
    }
} 