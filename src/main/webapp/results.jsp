<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.voting.dao.VoteDAO"%>
<%@ page import="com.voting.dao.CandidateDAO"%>
<%@ page import="com.voting.model.Candidate"%>
<%@ page import="com.voting.model.VoteResult"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%
    // Check if admin is logged in
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("admin.jsp");
        return;
    }
    
    int electionId = Integer.parseInt(request.getParameter("electionId"));
    VoteDAO voteDAO = new VoteDAO();
    List<VoteResult> results = voteDAO.getVoteResults(electionId);
    int totalVotes = voteDAO.getTotalVotes(electionId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Election Results - Online Voting System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Election Results</h1>
            <div class="admin-controls">
                <span>Admin Panel</span>
                <a href="logout" class="btn-small">Logout</a>
            </div>
        </header>
        
        <main>
            <div class="results-container">
                <div class="results-summary">
                    <h2>Vote Summary</h2>
                    <p>Total Votes Cast: <%= totalVotes %></p>
                </div>
                
                <div class="results-chart">
                    <canvas id="resultsChart"></canvas>
                </div>
                
                <div class="results-table">
                    <h2>Detailed Results</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Candidate</th>
                                <th>Party</th>
                                <th>Votes</th>
                                <th>Percentage</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            for (VoteResult result : results) {
                                double percentage = totalVotes > 0 ? (result.getVoteCount() * 100.0 / totalVotes) : 0;
                            %>
                            <tr>
                                <td><%= result.getCandidateName() %></td>
                                <td><%= result.getCandidateParty() %></td>
                                <td><%= result.getVoteCount() %></td>
                                <td><%= String.format("%.2f%%", percentage) %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <div class="admin-actions">
                    <button id="printResults" class="btn">Print Results</button>
                    <a href="export" class="btn">Export CSV</a>
                </div>
            </div>
        </main>
        
        <footer>
            <p>&copy; Online Voting System</p>
        </footer>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Results chart
        const ctx = document.getElementById('resultsChart').getContext('2d');
        
        // Get data from JSP
        const candidates = [
            <% for (VoteResult result : results) { %>
                '<%= result.getCandidateName() %>',
            <% } %>
        ];
        
        const votes = [
            <% for (VoteResult result : results) { %>
                <%= result.getVoteCount() %>,
            <% } %>
        ];
        
        const partyColors = [
            '#FF6384',
            '#36A2EB',
            '#FFCE56',
            '#4BC0C0',
            '#9966FF',
            '#FF9F40'
        ];
        
        // Create chart
        const resultsChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: candidates,
                datasets: [{
                    label: 'Votes',
                    data: votes,
                    backgroundColor: partyColors.slice(0, candidates.length),
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                }
            }
        });
        
        // Print functionality
        document.getElementById('printResults').addEventListener('click', function() {
            window.print();
        });
    </script>
</body>
</html>
