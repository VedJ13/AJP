<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
<%@ page import="com.votingsystem.dao.CandidateDAO"%>
<%@ page import="com.votingsystem.model.Candidate"%>
<%@ page import="com.votingsystem.model.Voter"%>
 --%>

<%@ page import="java.util.List"%>
<%
    // Check if user is logged in
    Voter voter = (Voter) session.getAttribute("voter");
    if (voter == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Check if user has already voted
    if (voter.isVoted()) {
        response.sendRedirect("success.jsp?message=You have already voted!");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cast Your Vote - Online Voting System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Cast Your Vote</h1>
            <p>Welcome, <%= voter.getName() %></p>
        </header>
        
        <main>
            <div class="voting-instructions">
                <h2>Voting Instructions</h2>
                <ul>
                    <li>Select only one candidate by clicking on their card.</li>
                    <li>Review your selection before submitting.</li>
                    <li>Once your vote is cast, it cannot be changed.</li>
                </ul>
            </div>
            
            <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
            %>
                <div class="error-message"><%= errorMessage %></div>
            <% } %>
            
            <form action="vote" method="post" id="voteForm">
                <div class="candidates-list">
                    <% 
                    CandidateDAO candidateDAO = new CandidateDAO();
                    List<Candidate> candidates = candidateDAO.getAllCandidates();
                    
                    for (Candidate candidate : candidates) {
                    %>
                    <div class="candidate-card" onclick="selectCandidate(this, <%= candidate.getCandidateId() %>)">
                        <input type="radio" id="candidate<%= candidate.getCandidateId() %>" name="candidateId" value="<%= candidate.getCandidateId() %>" style="display:none;">
                        <div class="candidate-info">
                            <h3><%= candidate.getName() %></h3>
                            <p class="party"><%= candidate.getParty() %></p>
                            <p class="description"><%= candidate.getDescription() %></p>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <div class="form-actions">
                    <input type="submit" value="Cast Vote" class="btn" id="submitVote" disabled>
                    <a href="logout" class="btn-secondary">Logout</a>
                </div>
            </form>
            
            <div id="confirmation-modal" class="modal">
                <div class="modal-content">
                    <h2>Confirm Your Vote</h2>
                    <p>Are you sure you want to vote for <span id="selected-candidate"></span>?</p>
                    <p class="warning">This action cannot be undone!</p>
                    <div class="modal-actions">
                        <button id="confirm-vote" class="btn">Yes, Cast My Vote</button>
                        <button id="cancel-vote" class="btn-secondary">Cancel</button>
                    </div>
                </div>
            </div>
        </main>
        
        <footer>
            <p>&copy; 2025 Online Voting System</p>
        </footer>
    </div>
    
    <script>
        function selectCandidate(card, candidateId) {
            // Clear all selections
            document.querySelectorAll('.candidate-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Select this candidate
            card.classList.add('selected');
            document.getElementById('candidate' + candidateId).checked = true;
            document.getElementById('submitVote').disabled = false;
        }
        
        document.getElementById('voteForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const selectedCandidate = document.querySelector('.candidate-card.selected h3');
            if (selectedCandidate) {
                document.getElementById('selected-candidate').textContent = selectedCandidate.textContent;
                document.getElementById('confirmation-modal').style.display = 'flex';
            }
        });
        
        document.getElementById('confirm-vote').addEventListener('click', function() {
            document.getElementById('voteForm').submit();
        });
        
        document.getElementById('cancel-vote').addEventListener('click', function() {
            document.getElementById('confirmation-modal').style.display = 'none';
        });
    </script>
</body>
</html>