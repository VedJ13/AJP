<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Online Voting System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Voter Registration</h1>
        </header>
        
        <main>
            <div class="form-container">
                <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
                %>
                    <div class="error-message"><%= errorMessage %></div>
                <% } %>
                
                <% 
                String successMessage = (String) request.getAttribute("successMessage");
                if (successMessage != null) {
                %>
                    <div class="success-message"><%= successMessage %></div>
                <% } %>
                
                <form action="register" method="post" onsubmit="return validateForm()">
                    <div class="form-group">
                        <label for="voterId">Voter ID:</label>
                        <input type="text" id="voterId" name="voterId" required>
                        <small>Use your Voter ID</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="name">Full Name:</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required>
                        <small>Use your college email address</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password:</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    
                    <div class="form-group">
                        <input type="submit" value="Register" class="btn">
                    </div>
                </form>
                
                <div class="form-links">
                    <p>Already have an account? <a href="login.jsp">Login here</a></p>
                    <p><a href="index.jsp">Back to Home</a></p>
                </div>
            </div>
        </main>
        
        <footer>
            <p>&copy; Online Voting System</p>
        </footer>
    </div>
    
    <script>
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            
            if (password != confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>