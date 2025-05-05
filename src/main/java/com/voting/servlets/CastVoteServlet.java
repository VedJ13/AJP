package com.voting.servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.voting.dao.CandidateDAO;
import com.voting.dao.VoterDAO;
import com.voting.dao.VoteDAO;
import com.voting.dao.ElectionDAO;
import com.voting.model.Candidate;
import com.voting.model.Voter;

@WebServlet("/CastVoteServlet")
public class CastVoteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("CastVoteServlet: doGet called");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("voter_id") == null) {
            System.out.println("CastVoteServlet: No valid session or voter_id");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String voterId = (String) session.getAttribute("voter_id");
        System.out.println("CastVoteServlet: Voter ID from session: " + voterId);
        
        CandidateDAO candidateDAO = new CandidateDAO();
        VoteDAO voteDAO = new VoteDAO();
        ElectionDAO electionDAO = new ElectionDAO();
        
        try {
            // Get election ID from request parameter or use default
            int electionId = 1; // Default election ID
            String electionIdParam = request.getParameter("election_id");
            if (electionIdParam != null && !electionIdParam.isEmpty()) {
                electionId = Integer.parseInt(electionIdParam);
            }
            System.out.println("CastVoteServlet: Using election ID: " + electionId);
            
            // Check if election exists and is active
            if (!electionDAO.isElectionActive(electionId)) {
                System.out.println("CastVoteServlet: Election not found or not active");
                request.setAttribute("error", "No active election found.");
                request.getRequestDispatcher("voter_dashboard.jsp").forward(request, response);
                return;
            }
            
            // Check if voter has already voted
            if (voteDAO.hasVoted(electionId, voterId)) {
                System.out.println("CastVoteServlet: Voter has already voted");
                request.setAttribute("error", "You have already cast your vote.");
                request.getRequestDispatcher("voter_dashboard.jsp").forward(request, response);
                return;
            }
            
            // Get candidates for the election
            System.out.println("CastVoteServlet: Fetching candidates for election " + electionId);
            List<Candidate> candidates = candidateDAO.getCandidatesByElection(electionId);
            System.out.println("CastVoteServlet: Number of candidates found: " + candidates.size());
            
            if (candidates.isEmpty()) {
                System.out.println("CastVoteServlet: No candidates found");
                request.setAttribute("error", "No candidates available for this election.");
            } else {
                System.out.println("CastVoteServlet: Setting candidates in request");
                request.setAttribute("candidates", candidates);
                request.setAttribute("currentElection", electionDAO.getElectionById(electionId));
            }
            
            request.getRequestDispatcher("voting_booth.jsp").forward(request, response);
        } catch (SQLException e) {
            System.out.println("CastVoteServlet: SQL Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading candidates: " + e.getMessage());
            request.getRequestDispatcher("voter_dashboard.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("CastVoteServlet: doPost called");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("voter_id") == null) {
            System.out.println("CastVoteServlet: No valid session or voter_id");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String voterId = (String) session.getAttribute("voter_id");
        System.out.println("CastVoteServlet: Voter ID from session: " + voterId);
        
        int candidateId = Integer.parseInt(request.getParameter("candidate_id"));
        int electionId = Integer.parseInt(request.getParameter("election_id"));
        System.out.println("CastVoteServlet: Processing vote - Election ID: " + electionId + ", Candidate ID: " + candidateId);
        
        try {
            VoteDAO voteDAO = new VoteDAO();
            
            // Check if voter has already voted
            if (voteDAO.hasVoted(electionId, voterId)) {
                System.out.println("CastVoteServlet: Voter has already voted");
                request.setAttribute("error", "You have already cast your vote.");
                request.getRequestDispatcher("voter_dashboard.jsp").forward(request, response);
                return;
            }
            
            // Cast the vote
            if (voteDAO.castVote(electionId, voterId, candidateId)) {
                System.out.println("CastVoteServlet: Vote cast successfully");
                request.setAttribute("success", "Your vote has been successfully cast!");
            } else {
                System.out.println("CastVoteServlet: Failed to cast vote");
                request.setAttribute("error", "Failed to cast your vote. Please try again.");
            }
            
            request.getRequestDispatcher("voter_dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            System.out.println("CastVoteServlet: SQL Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your vote: " + e.getMessage());
            request.getRequestDispatcher("voter_dashboard.jsp").forward(request, response);
        }
    }
}