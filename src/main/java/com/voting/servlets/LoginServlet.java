package com.voting.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.voting.util.DatabaseUtil;

@jakarta.servlet.annotation.WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String voterId = request.getParameter("voter_id");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM voters WHERE voter_id = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, voterId);
            pstmt.setString(2, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("voter_id", rs.getString("voter_id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("has_voted", rs.getBoolean("has_voted"));
                
                response.sendRedirect("voter_dashboard.jsp");
            } else {
                response.sendRedirect("error.jsp?message=Invalid credentials. Please try again.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Database error occurred. Please try again later.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                DatabaseUtil.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
} 