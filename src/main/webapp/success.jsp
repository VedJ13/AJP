<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.voting.model.Voter"%>
<%@ page import="com.voting.model.VoteResult" %>
<%
    Voter voter = (Voter) session.getAttribute("voter");
    if (voter == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String message = request.getParameter("message");
    if (message == null || message.trim().isEmpty()) {
        message = "Operation completed successfully!";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Success - Online Voting System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Success!</h1>
        </header>
        
        <main>
            <div class="success-container">
                <div class="success-icon">✓</div>
                <h2><%= message %></h2>
                
                <% if (voter.isVoted()) { %>
                    <div class="vote-confirmation">
                        <p>Thank you for participating in the election.</p>
                        <p>Your vote has been recorded securely.</p>
                    </div>
                <% } %>
                
                <div class="action-buttons">
                    <% if (voter.isVoted()) { %>
                        <a href="logout" class="btn">Logout</a>
                    <% } else { %>
                        <a href="vote.jsp" class="btn">Cast Vote</a>
                        <a href="logout" class="btn-secondary">Logout</a>
                    <% } %>
                </div>
            </div>
        </main>
        
        <footer>
            <p>&copy; Online Voting System</p>
        </footer>
    </div>
</body>
</html>