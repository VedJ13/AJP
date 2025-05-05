package com.voting.servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.voting.dao.ElectionDAO;
import com.voting.model.Election;

@WebServlet("/ElectionServlet")
public class ElectionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            ElectionDAO electionDAO = new ElectionDAO();
            request.setAttribute("elections", electionDAO.getAllElections());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading elections: " + e.getMessage());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            Date startDate = dateFormat.parse(request.getParameter("start_date"));
            Date endDate = dateFormat.parse(request.getParameter("end_date"));
            String status = request.getParameter("status");
            
            Election election = new Election();
            election.setTitle(title);
            election.setDescription(description);
            election.setStartDate(startDate);
            election.setEndDate(endDate);
            election.setStatus(status);
            
            ElectionDAO electionDAO = new ElectionDAO();
            if (electionDAO.createElection(election)) {
                request.setAttribute("success", "Election created successfully!");
            } else {
                request.setAttribute("error", "Failed to create election. Please try again.");
            }
            
            request.setAttribute("elections", electionDAO.getAllElections());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            
        } catch (ParseException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD.");
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }
} 