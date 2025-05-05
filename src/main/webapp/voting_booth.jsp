<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.voting.model.Candidate, java.util.List" %>
<%@ page import="com.voting.model.Election" %>

<%
// Check if candidates are already in the request
List<Candidate> candidates = (List<Candidate>) request.getAttribute("candidates");
if (candidates == null) {
    // If not, redirect to CastVoteServlet
    response.sendRedirect("CastVoteServlet");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voting Booth - Online Voting System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .voting-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .voting-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .voting-title {
            font-size: 2rem;
            color: #1a3a6c;
            margin-bottom: 10px;
        }
        
        .voting-subtitle {
            color: #666;
            font-size: 1.1rem;
        }
        
        .candidates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .candidate-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        
        .candidate-card:hover {
            transform: translateY(-5px);
        }
        
        .candidate-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 50%;
            margin: 0 auto 15px;
            display: block;
        }
        
        .candidate-name {
            font-size: 1.3rem;
            color: #1a3a6c;
            margin-bottom: 5px;
            text-align: center;
        }
        
        .candidate-party {
            color: #666;
            font-size: 1rem;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .candidate-manifesto {
            color: #444;
            font-size: 0.9rem;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        
        .vote-button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            width: 100%;
            transition: background-color 0.2s;
        }
        
        .vote-button:hover {
            background-color: #45a049;
        }
        
        .vote-button:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }
        
        .error-message {
            background-color: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .success-message {
            background-color: #e8f5e9;
            color: #2e7d32;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .election-info {
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .election-title {
            font-size: 1.5rem;
            color: #1a3a6c;
            margin-bottom: 10px;
        }
        
        .election-dates {
            color: #666;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <header class="site-header">
        <div class="header-content container">
            <h1 class="site-title">Online Voting System</h1>
            <div class="user-info">
                <span>Welcome, Voter</span>
                <a href="logout.jsp" class="btn btn-small btn-secondary">Logout</a>
            </div>
        </div>
    </header>
    
    <div class="voting-container">
        <div class="voting-header">
            <h1 class="voting-title">Voting Booth</h1>
            <p class="voting-subtitle">Cast your vote for your preferred candidate</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <%
        Election currentElection = (Election) request.getAttribute("currentElection");
        if (currentElection != null) {
        %>
            <div class="election-info">
                <h2 class="election-title"><%= currentElection.getTitle() %></h2>
                <p><%= currentElection.getDescription() %></p>
                <div class="election-dates">
                    <p>Start Date: <%= currentElection.getStartDate() %></p>
                    <p>End Date: <%= currentElection.getEndDate() %></p>
                </div>
            </div>
        <%
        }
        %>
        
        <form action="CastVoteServlet" method="post">
            <%
            String electionId = request.getParameter("election_id");
            if (electionId == null || electionId.isEmpty()) {
                electionId = "1"; // Default election ID
            }
            %>
            <input type="hidden" name="election_id" value="<%= electionId %>">
            
            <div class="candidates-grid">
                <%
                if (candidates != null && !candidates.isEmpty()) {
                    for (Candidate candidate : candidates) {
                %>
                    <div class="candidate-card">
                        <img src="<%= candidate.getSymbol() %>" alt="<%= candidate.getParty() %> Symbol" class="candidate-image">
                        <h3 class="candidate-name"><%= candidate.getName() %></h3>
                        <p class="candidate-party"><%= candidate.getParty() %></p>
                        <div class="candidate-manifesto">
                            <h4>Manifesto:</h4>
                            <p><%= candidate.getManifesto() %></p>
                        </div>
                        <button type="submit" name="candidate_id" value="<%= candidate.getCandidateId() %>" class="vote-button">
                            Vote for <%= candidate.getName() %>
                        </button>
                    </div>
                <%
                    }
                } else {
                %>
                    <div class="no-candidates">
                        <p>No candidates available for this election.</p>
                        <a href="voter_dashboard.jsp" class="btn">Back to Dashboard</a>
                    </div>
                <%
                }
                %>
            </div>
        </form>
    </div>
    
    <footer class="site-footer">
        <div class="footer-content container">
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> Online Voting System. All rights reserved.</p>
            <div class="footer-links">
                <a href="about.jsp">About</a>
                <a href="contact.jsp">Contact</a>
                <a href="privacy.jsp">Privacy Policy</a>
                <a href="terms.jsp">Terms of Service</a>
            </div>
        </div>
    </footer>
</body>
</html> 