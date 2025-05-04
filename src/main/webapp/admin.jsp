<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - Online Voting System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Admin Login</h1>
        </header>
        
        <main>
            <div class="form-container">
                <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
                %>
                    <div class="error-message"><%= errorMessage %></div>
                <% } %>
                
                <form action="AdminLoginServlet" method="post">
                    <div class="form-group">
                        <label for="adminId">Username:</label>
                        <input type="text" id="adminId" name="username" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    
                    <div class="form-group">
                        <input type="submit" value="Login" class="btn">
                    </div>
                </form>
                
                <div class="form-links">
                    <p><a href="index.jsp">Back to Home</a></p>
                </div>
            </div>
        </main>
        
        <footer>
            <p>&copy; Online Voting System</p>
        </footer>
    </div>
</body>
</html>