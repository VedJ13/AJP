package com.voting.servlets;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.voting.dao.VoterDAO;
import com.voting.model.Voter;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String voterId = request.getParameter("voter_id");
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        Voter voter = new Voter();
        voter.setVoterId(voterId);
        voter.setName(name);
        voter.setPassword(password);
        voter.setEmail(email);
        voter.setPhone(phone);
        voter.setAddress(address);
        
        VoterDAO voterDAO = new VoterDAO();
        
        try {
            if (voterDAO.registerVoter(voter)) {
                response.sendRedirect("success.jsp?message=Registration successful! Please login.");
            } else {
                response.sendRedirect("error.jsp?message=Registration failed. Please try again.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Database error occurred: " + e.getMessage());
        }
    }
} 