<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter Dashboard - Online Voting System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .dashboard-welcome {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .welcome-text h2 {
            color: #1a3a6c;
            margin-bottom: 10px;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            margin-left: 10px;
        }
        
        .badge-success {
            background-color: #ebfbee;
            color: #2b8a3e;
        }
        
        .badge-warning {
            background-color: #fff3bf;
            color: #e67700;
        }
        
        .badge-danger {
            background-color: #fff5f5;
            color: #e03131;
        }
        
        .election-status {
            background-color: #f0f7ff;
            border-radius: 8px;
            padding: 20px;
            border-left: 4px solid #3273dc;
            margin-bottom: 30px;
        }
        
        .status-details {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
        }
        
        .status-item {
            text-align: center;
            flex: 1;
        }
        
        .status-label {
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 5px;
        }
        
        .status-value {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
        }
        
        .candidate-preview {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .candidate-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .candidate-item {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            transition: transform 0.2s;
        }
        
        .candidate-item:hover {
            transform: translateY(-5px);
        }
        
        .candidate-name {
            font-weight: 600;
            color: #1a3a6c;
            margin: 10px 0 5px;
        }
        
        .candidate-party {
            color: #e67700;
            font-size: 0.9rem;
            margin-bottom: 10px;
        }
        
        .profile-pic {
            width: 80px;
            height: 80px;
            background-color: #ddd;
            border-radius: 50%;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: #1a3a6c;
        }
        
        .voter-info {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .info-group {
            display: flex;
            margin-bottom: 15px;
        }
        
        .info-label {
            flex: 1;
            font-weight: 500;
            color: #666;
        }
        
        .info-value {
            flex: 2;
            color: #333;
        }
        
        .election-calendar {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .calendar-item {
            display: flex;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .calendar-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .calendar-date {
            flex: 0 0 80px;
            text-align: center;
            padding: 5px;
            border-radius: 5px;
            background-color: #f0f7ff;
            color: #1a3a6c;
            font-weight: 500;
            height: fit-content;
        }
        
        .calendar-details {
            margin-left: 15px;
        }
        
        .calendar-title {
            font-weight: 500;
            color: #333;
            margin-bottom: 5px;
        }
        
        .calendar-desc {
            color: #666;
            font-size: 0.9rem;
        }
        
        .two-col-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }
        
        @media (max-width: 768px) {
            .two-col-layout {
                grid-template-columns: 1fr;
            }
            
            .dashboard-welcome {
                flex-direction: column;
                text-align: center;
            }
            
            .welcome-text, .welcome-actions {
                width: 100%;
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<body>
    <header class="site-header">
        <div class="header-content container">
            <h1 class="site-title">Online Voting System</h1>
            <div class="user-info">
     <%--       <span>Welcome, <%= "John Doe"  %></span>  --%>
     <%
    	String username = (String) session.getAttribute("name");
   		 if (username == null) {
     	   response.sendRedirect("admin.jsp"); // Or login page
     	   return;
  	  }
	%>
<span>Welcome, <%= username %></span>
     
                <a href="logout.jsp" class="btn btn-small btn-secondary">Logout</a>
            </div>
        </div>
    </header>
    
    <div class="container">
        <div class="dashboard-welcome">
            <div class="welcome-text">
                <h2>Welcome, <%= username %>
                <%-- First name would be loaded from session --%>
                </h2>
                <p>
                    Voter ID: <%= "V1042"  %>
                    <%-- // Voter ID would be loaded from session --%>
                    <% 
                    
                    boolean hasVoted = false;
                    if(hasVoted) {
                    %>
                        <span class="badge badge-success">Voted</span>
                    <% } else { %>
                        <span class="badge badge-warning">Not Voted</span>
                    <% } %>
                </p>
            </div>
            <div class="welcome-actions">
                <a href="voting_booth.jsp" class="btn <%= hasVoted ? "btn-secondary" : "" %>" <%= hasVoted ? "disabled" : "" %>>
                    <%= hasVoted ? "Already Voted" : "Cast Your Vote" %>
                </a>
            </div>
        </div>
        
        <div class="election-status">
            <h2>Current Election Status</h2>
            
            
            <div class="status-details">
                <div class="status-item">
                    <div class="status-label">Status</div>
                    <div class="status-value">Active</div>
                </div>
                <div class="status-item">
                    <div class="status-label">End Date</div>
                    <div class="status-value">23 Apr 2025</div>
                </div>
                <div class="status-item">
                    <div class="status-label">Time Remaining</div>
                    <div class="status-value">21 hours</div>
                </div>
                <div class="status-item">
                    <div class="status-label">Voter Turnout</div>
                    <div class="status-value">79%</div>
                </div>
            </div>
        </div>
        
        <%--
        <div class="two-col-layout">
            <div class="left-column">
                <div class="candidate-preview">
                    <h2>Current Candidates</h2>
                    <p>Get to know the candidates before casting your vote.</p>
                    
                    <div class="candidate-grid">
                        <% 
                        // Simulated candidate data
                        String[] candidateNames = {"Sarah Johnson", "Michael Chen", "Priya Patel", "David Wilson"};
                        String[] candidateParties = {"Progress Party", "Student Union", "Future Alliance", "Independent"};
                        
                        for(int i = 0; i < candidateNames.length; i++) {
                        %>
                            <div class="candidate-item">
                                <div class="profile-pic">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="candidate-name"><%= candidateNames[i] %></div>
                                <div class="candidate-party"><%= candidateParties[i] %></div>
                                <a href="candidate_details.jsp?id=<%= i+1 %>" class="btn btn-small">View Profile</a>
                            </div>
                        <% } %>
                    </div>
                    
                    <div style="text-align: center; margin-top: 20px;">
                        <a href="view_all_candidates.jsp" class="btn">View All Candidates</a>
                    </div>
                </div>
                
                <div class="voter-info">
                    <h2>Your Voter Information</h2>
                    <div class="info-group">
                        <div class="info-label">Full Name:</div>
                        <div class="info-value"><%= username %></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Student ID:</div>
                        <div class="info-value">ST1234567</div>
                    </div>
                 div class="info-group">
                        <div class="info-label">Department:</div>
                        <div class="info-value">Computer Science</div>
                    </div>
                 
                    <div class="info-group">
                        <div class="info-label">Year:</div>
                        <div class="info-value">3rd Year</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Email:</div>
                        <div class="info-value">john.doe@college.edu</div>
                    </div>
                    
                    <div style="margin-top: 20px;">
                        <a href="update_profile.jsp" class="btn btn-secondary btn-small">Update Profile</a>
                        <a href="change_password.jsp" class="btn btn-secondary btn-small">Change Password</a>
                    </div>
                </div>
            </div>
            
            <div class="right-column">
                <div class="election-calendar">
                    <h2>Election Calendar</h2>
                    
                    <div class="calendar-item">
                        <div class="calendar-date">18 Apr</div>
                        <div class="calendar-details">
                            <div class="calendar-title">Candidate Registration Closed</div>
                            <div class="calendar-desc">Final list of candidates published</div>
                        </div>
                    </div>
                    
                    <div class="calendar-item">
                        <div class="calendar-date">20 Apr</div>
                        <div class="calendar-details">
                            <div class="calendar-title">Voting Begins</div>
                            <div class="calendar-desc">Online voting system opens for all registered voters</div>
                        </div>
                    </div>
                    
                    <div class="calendar-item">
                        <div class="calendar-date">23 Apr</div>
                        <div class="calendar-details">
                            <div class="calendar-title">Voting Ends</div>
                            <div class="calendar-desc">Last day to cast your vote (closes at 11:59 PM)</div>
                        </div>
                    </div>
                    
                    <div class="calendar-item">
                        <div class="calendar-date">25 Apr</div>
                        <div class="calendar-details">
                            <div class="calendar-title">Results Announcement</div>
                            <div class="calendar-desc">Official election results will be published</div>
                        </div>
                    </div>
                    
                    <div class="calendar-item">
                        <div class="calendar-date">30 Apr</div>
                        <div class="calendar-details">
                            <div class="calendar-title">Inauguration Ceremony</div>
                            <div class="calendar-desc">New student council members take office</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
 
    <footer class="site-footer">
        <div class="footer-content container">
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> Online Voting System. All rights reserved.</p>
            <div class="footer-links">
                <a href="about.jsp">About</a>
                <a href="contact.jsp">Contact</a>
                <a href="help.jsp">Help</a>
                <a href="faq.jsp">FAQ</a>
            </div>
        </div>
    </footer>
    --%> 
    <script>
      <%-- // Script to update remaining time dynamically --%>
        function updateRemainingTime() {
         <%--   // In a real application, this would calculate time based on server end date
            // For demonstration, we'll just use hardcoded values --%>
            const remainingHours = 21;
            const remainingMinutes = 30;
            document.querySelector('.status-value:nth-child(6)').textContent = 
                remainingHours + ' hours';
        }
        
        <%-- // Call once on page load --%>
        updateRemainingTime();
    </script>
</body>
</html>