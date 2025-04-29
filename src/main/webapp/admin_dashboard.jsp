<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
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
        <div class="admin-header">
            <div>
                <h1>Admin Dashboard</h1>
                <p>Election Status: 
                    <%
                    // Simulated election status
                    boolean electionActive = true;
                    if(electionActive) {
                    %>
                        <span class="status-indicator status-active">Active</span>
                    <% } else { %>
                        <span class="status-indicator status-inactive">Inactive</span>
                    <% } %>
                </p>
            </div>
            <div class="admin-controls">
                <% if(electionActive) { %>
                    <button class="btn btn-secondary btn-small" id="pauseElection">Pause Election</button>
                    <button class="btn admin-btn btn-small" id="endElection">End Election</button>
                <% } else { %>
                    <button class="btn btn-small" id="startElection">Start Election</button>
                <% } %>
            </div>
        </div>
        
        <div class="admin-tabs">
            <button class="tab-btn active">Overview</button>
            <button class="tab-btn">Candidates</button>
            <button class="tab-btn">Voters</button>
            <button class="tab-btn">Results</button>
            <button class="tab-btn">Settings</button>
        </div>
        
        <section class="dashboard-grid">
            <div class="dashboard-card">
                <div class="card-icon"><i class="fas fa-users"></i></div>
                <h3 class="card-title">Total Voters</h3>
                <div class="card-value">
                    <%
                    // Simulated data
                    int totalVoters = 218;
                    out.print(totalVoters);
                    %>
                </div>
                <p class="card-desc">Registered voters in the system</p>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon"><i class="fas fa-vote-yea"></i></div>
                <h3 class="card-title">Total Votes</h3>
                <div class="card-value">
                    <%
                    // Simulated data
                    int totalVotes = 173;
                    out.print(totalVotes);
                    %>
                </div>
                <p class="card-desc">Votes cast in the current election</p>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon"><i class="fas fa-user-tie"></i></div>
                <h3 class="card-title">Candidates</h3>
                <div class="card-value">
                    <%
                    // Simulated data
                    int totalCandidates = 5;
                    out.print(totalCandidates);
                    %>
                </div>
                <p class="card-desc">Candidates in the current election</p>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon"><i class="fas fa-chart-pie"></i></div>
                <h3 class="card-title">Turnout</h3>
                <div class="card-value">
                    <%
                    // Calculate turnout percentage
                    int turnoutPercentage = (int)((double)totalVotes / totalVoters * 100);
                    out.print(turnoutPercentage + "%");
                    %>
                </div>
                <p class="card-desc">Percentage of registered voters who voted</p>
            </div>
        </section>
        
        <section class="recent-activity">
            <h2>Recent Activity</h2>
            
            <div class="activity-item">
                <div class="activity-info">
                    <span class="activity-icon"><i class="fas fa-user-check"></i></span>
                    <span>Voter ID #1042 cast their vote</span>
                </div>
                <span class="activity-time">2 minutes ago</span>
            </div>
            
            <div class="activity-item">
                <div class="activity-info">
                    <span class="activity-icon"><i class="fas fa-user-plus"></i></span>
                    <span>New voter registered (ID #1056)</span>
                </div>
                <span class="activity-time">15 minutes ago</span>
            </div>
            
            <div class="activity-item">
                <div class="activity-info">
                    <span class="activity-icon"><i class="fas fa-edit"></i></span>
                    <span>Admin updated candidate information</span>
                </div>
                <span class="activity-time">1 hour ago</span>
            </div>
            
            <div class="activity-item">
                <div class="activity-info">
                    <span class="activity-icon"><i class="fas fa-user-check"></i></span>
                    <span>Voter ID #1035 cast their vote</span>
                </div>
                <span class="activity-time">2 hours ago</span>
            </div>
        </section>
        
        <div class="quick-actions">
            <a href="manage_candidates.jsp" class="btn">Manage Candidates</a>
            <a href="manage_voters.jsp" class="btn">Manage Voters</a>
            <a href="view_results.jsp" class="btn">View Results</a>
            <a href="system_settings.jsp" class="btn">System Settings</a>
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
    </script>
</body>
</html>