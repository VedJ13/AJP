<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Online Voting System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Online Voting System</h1>
            <p>Welcome to the Online Voting Platform</p>
        </header>
        
        <main>
            <div class="welcome-content">
                <p>This platform allows to participate in elections securely and conveniently.</p>
                <p>Please login to cast your vote or register if you haven't already.</p>
                
                <div class="action-buttons">
                    <a href="login.jsp" class="btn">Login</a>
                    <a href="register.jsp" class="btn">Register</a>
                    <a href="admin.jsp" class="btn admin-btn">Admin Login</a>
                </div>
            </div>
        </main>
        
        <footer>
            <p>&copy; Online Voting System</p>
        </footer>
    </div>
</body>
</html>