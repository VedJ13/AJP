<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="site-header">
    <div class="header-content">
        <h1 class="site-title">Online Voting System</h1>
        
        <% if (session.getAttribute("voter") != null) { %>
            <div class="user-info">
                <span>Welcome, <%= ((com.voting.model.Voter) session.getAttribute("voter")).getName() %></span>
                <a href="logout" class="btn-small">Logout</a>
            </div>
        <% } else if (session.getAttribute("isAdmin") != null && (Boolean) session.getAttribute("isAdmin")) { %>
            <div class="user-info">
                <span>Admin Panel</span>
                <a href="logout" class="btn-small">Logout</a>
            </div>
        <% } %>
    </div>
</header>