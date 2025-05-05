package com.voting.servlets;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.voting.dao.CandidateDAO;
import com.voting.model.Candidate;

@WebServlet("/AddCandidateServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddCandidateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads/symbols";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Load existing candidates when accessing the admin dashboard
        try {
            CandidateDAO candidateDAO = new CandidateDAO();
            request.setAttribute("candidates", candidateDAO.getAllCandidates(1));
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading candidates: " + e.getMessage());
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
            // Get form data
            String name = request.getParameter("name");
            String party = request.getParameter("party");
            String manifesto = request.getParameter("manifesto");
            
            System.out.println("Received candidate data: " + name + ", " + party);
            
            // Handle file upload
            Part filePart = request.getPart("symbol");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            System.out.println("Received file: " + fileName);
            
            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                System.out.println("Created upload directory: " + created);
            }
            
            // Save the file
            String filePath = uploadPath + File.separator + fileName;
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                System.out.println("File saved to: " + filePath);
            }
            
            // Create candidate object
            Candidate candidate = new Candidate();
            candidate.setName(name);
            candidate.setParty(party);
            candidate.setSymbol(UPLOAD_DIR + "/" + fileName);
            candidate.setManifesto(manifesto);
            candidate.setElectionId(1);
            candidate.setVotes(0);
            
            // Save to database
            CandidateDAO candidateDAO = new CandidateDAO();
            boolean success = candidateDAO.addCandidate(candidate);
            
            System.out.println("Candidate added to database: " + success);
            
            if (success) {
                request.setAttribute("success", "Candidate added successfully!");
            } else {
                request.setAttribute("error", "Failed to add candidate. Please try again.");
            }
            
            // Get updated list of candidates
            request.setAttribute("candidates", candidateDAO.getAllCandidates(1));
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while adding the candidate: " + e.getMessage());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }
} 