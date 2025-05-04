package com.voting.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.voting.util.DatabaseUtil;

@jakarta.servlet.annotation.WebServlet("/VoteServlet")
public class VoteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("voter_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String voterId = (String) session.getAttribute("voter_id");
        int electionId = Integer.parseInt(request.getParameter("election_id"));
        int candidateId = Integer.parseInt(request.getParameter("candidate_id"));
        
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
                response.sendRedirect("error.jsp?message=You have already voted in this election.");
                return;
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
            response.sendRedirect("success.jsp?message=Your vote has been recorded successfully!");
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Error occurred while recording your vote. Please try again.");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                DatabaseUtil.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
} 