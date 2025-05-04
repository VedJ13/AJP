	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - Online Voting System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>An Error Occurred</h1>
        </header>
        
        <main>
            <div class="error-container">
                <div class="error-icon">!</div>
                
                <% 
                String errorMsg = request.getParameter("message");
                if (errorMsg == null && exception != null) {
                    errorMsg = exception.getMessage();
                }
                if (errorMsg == null) {
                    errorMsg = "An unexpected error occurred. Please try again.";
                }
                %>
                
                <h2><%= errorMsg %></h2>
                
                <div class="action-buttons">
                    <a href="javascript:history.back()" class="btn">Go Back</a>
                    <a href="index.jsp" class="btn-secondary">Return to Home</a>
                </div>
            </div>
        </main>
        
        <footer>
            <p>&copy; Online Voting System</p>
        </footer>
    </div>
</body>
</html>