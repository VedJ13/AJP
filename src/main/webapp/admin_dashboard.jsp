<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.voting.model.Candidate, java.util.List" %>
<%@ page import="com.voting.model.Election" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Online Voting System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .dashboard-card {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            transition: transform 0.2s;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        
        .card-icon {
            font-size: 2.5rem;
            color: #1a3a6c;
            margin-bottom: 15px;
            height: 60px;
            width: 60px;
            line-height: 60px;
            border-radius: 50%;
            background-color: #f0f7ff;
        }
        
        .card-title {
            font-size: 1.3rem;
            margin-bottom: 10px;
            color: #1a3a6c;
        }
        
        .card-value {
            font-size: 2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        
        .card-desc {
            color: #666;
            font-size: 0.9rem;
        }
        
        .recent-activity {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 30px;
        }
        
        .activity-item {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-info {
            display: flex;
            align-items: center;
        }
        
        .activity-icon {
            font-size: 1.2rem;
            color: #1a3a6c;
            margin-right: 15px;
        }
        
        .activity-time {
            color: #888;
            font-size: 0.9rem;
        }
        
        .quick-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 20px;
        }
        
        .admin-tabs {
            display: flex;
            justify-content: center;
            margin: 20px 0;
            border-bottom: 1px solid #ddd;
        }
        
        .tab-btn {
            padding: 10px 20px;
            border: none;
            background: none;
            font-size: 1rem;
            color: #555;
            cursor: pointer;
            margin: 0 5px;
            position: relative;
        }
        
        .tab-btn.active {
            color: #3273dc;
            font-weight: 500;
        }
        
        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: #3273dc;
        }
        
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .status-indicator {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            margin-left: 10px;
        }
        
        .status-active {
            background-color: #ebfbee;
            color: #2b8a3e;
        }
        
        .status-inactive {
            background-color: #fff5f5;
            color: #e03131;
        }
        
        .admin-dashboard {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .add-candidate-form {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }
        
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        .candidates-list {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .candidates-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .candidates-table th,
        .candidates-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .candidates-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        
        .candidates-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        
        .btn-edit {
            background-color: #3273dc;
            color: white;
        }
        
        .btn-delete {
            background-color: #e03131;
            color: white;
        }
        
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .section {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-group input[type="text"],
        .form-group input[type="date"],
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .form-group textarea {
            height: 100px;
        }
        
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .btn:hover {
            background-color: #45a049;
        }
        
        .candidates-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .candidate-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background-color: #f9f9f9;
        }
        
        .candidate-card img {
            max-width: 100px;
            max-height: 100px;
            margin-bottom: 10px;
        }
        
        .error {
            color: #ff0000;
            margin-bottom: 15px;
        }
        
        .success {
            color: #008000;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <header class="site-header">
        <div class="header-content container">
            <h1 class="site-title">Online Voting System</h1>
            <div class="user-info">
                <span>Welcome, Admin</span>
                <a href="logout.jsp" class="btn btn-small btn-secondary">Logout</a>
            </div>
        </div>
    </header>
    
    <div class="container">
        <div class="admin-dashboard">
            <div class="dashboard-header">
                <h1>Admin Dashboard</h1>
                <a href="logout.jsp" class="btn btn-secondary">Logout</a>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="success"><%= request.getAttribute("success") %></div>
            <% } %>
            
            <!-- Election Creation Form -->
            <div class="section">
                <h2>Create New Election</h2>
                <form action="ElectionServlet" method="post">
                    <div class="form-group">
                        <label for="title">Election Title:</label>
                        <input type="text" id="title" name="title" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea id="description" name="description" required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="start_date">Start Date:</label>
                        <input type="date" id="start_date" name="start_date" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="end_date">End Date:</label>
                        <input type="date" id="end_date" name="end_date" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="status">Status:</label>
                        <select id="status" name="status" required>
                            <option value="ACTIVE">Active</option>
                            <option value="PENDING">Pending</option>
                            <option value="COMPLETED">Completed</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn">Create Election</button>
                </form>
            </div>
            
            <!-- Add Candidate Form -->
            <div class="section">
                <h2>Add New Candidate</h2>
                <form action="AddCandidateServlet" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="name">Candidate Name:</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="party">Political Party:</label>
                        <input type="text" id="party" name="party" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="symbol">Party Symbol:</label>
                        <input type="file" id="symbol" name="symbol" accept="image/*" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="manifesto">Manifesto:</label>
                        <textarea id="manifesto" name="manifesto" required></textarea>
                    </div>
                    
                    <button type="submit" class="btn">Add Candidate</button>
                </form>
            </div>
            
            <!-- List of Candidates -->
            <div class="section">
                <h2>Current Candidates</h2>
                <div class="candidates-list">
                    <%
                    List<Candidate> candidates = (List<Candidate>) request.getAttribute("candidates");
                    if (candidates != null && !candidates.isEmpty()) {
                        for (Candidate candidate : candidates) {
                    %>
                        <div class="candidate-card">
                            <img src="<%= candidate.getSymbol() %>" alt="<%= candidate.getParty() %> Symbol">
                            <h3><%= candidate.getName() %></h3>
                            <p>Party: <%= candidate.getParty() %></p>
                            <p>Votes: <%= candidate.getVotes() %></p>
                            <div class="manifesto">
                                <h4>Manifesto:</h4>
                                <p><%= candidate.getManifesto() %></p>
                            </div>
                        </div>
                    <%
                        }
                    } else {
                    %>
                        <p>No candidates added yet.</p>
                    <%
                    }
                    %>
                </div>
            </div>
            
            <!-- List of Elections -->
            <div class="section">
                <h2>Current Elections</h2>
                <div class="elections-list">
                    <%
                    List<Election> elections = (List<Election>) request.getAttribute("elections");
                    if (elections != null && !elections.isEmpty()) {
                        for (Election election : elections) {
                    %>
                        <div class="election-card">
                            <h3><%= election.getTitle() %></h3>
                            <p><%= election.getDescription() %></p>
                            <p>Start Date: <%= election.getStartDate() %></p>
                            <p>End Date: <%= election.getEndDate() %></p>
                            <p>Status: <%= election.getStatus() %></p>
                        </div>
                    <%
                        }
                    } else {
                    %>
                        <p>No elections created yet.</p>
                    <%
                    }
                    %>
                </div>
            </div>
        </div>
    </div>
    
    <div class="modal" id="endElectionModal">
        <div class="modal-content">
            <h2>End Election</h2>
            <p>Are you sure you want to end the current election? This action cannot be undone.</p>
            <p class="warning">All voting will be stopped and final results will be calculated.</p>
            <div class="modal-actions">
                <button class="btn" id="confirmEndElection">Yes, End Election</button>
                <button class="btn btn-secondary" id="cancelEndElection">Cancel</button>
            </div>
        </div>
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
    
    <script>
        // Simple JavaScript for modal functionality
        document.getElementById('endElection').addEventListener('click', function() {
            document.getElementById('endElectionModal').style.display = 'flex';
        });
        
        document.getElementById('cancelEndElection').addEventListener('click', function() {
            document.getElementById('endElectionModal').style.display = 'none';
        });
        
        // Tab functionality
        const tabButtons = document.querySelectorAll('.tab-btn');
        tabButtons.forEach(button => {
            button.addEventListener('click', function() {
                tabButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');
                // In a real application, you would load different content here
            });
        });
        
        function editCandidate(candidateId) {
            // Implement edit functionality
            alert('Edit candidate with ID: ' + candidateId);
        }
        
        function deleteCandidate(candidateId) {
            if (confirm('Are you sure you want to delete this candidate?')) {
                // Implement delete functionality
                alert('Delete candidate with ID: ' + candidateId);
            }
        }
    </script>
</body>
</html>