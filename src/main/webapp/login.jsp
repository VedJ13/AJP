<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Online Voting System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Voter Login</h1>
        </header>
        
        <main>
            <div class="form-container">
                <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
                %>
                    <div class="error-message"><%= errorMessage %></div>
                <% } %>
                
                <form action="LoginServlet" method="post">
                    <div class="form-group">
                        <label for="voterId">Voter ID:</label>
                        <input type="text" id="voterId" name="voter_id" required>
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
                    <p>Don't have an account? <a href="register.jsp">Register here</a></p>
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