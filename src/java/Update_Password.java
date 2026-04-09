/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author user
 */
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Update_Password")
public class Update_Password extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("mail_id");

        if (email == null) {
            response.sendRedirect("Forgot_Password.jsp");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("msg", "Passwords do not match!");
            response.sendRedirect("New_Password.jsp");
            return;
        }

        try {
            Connection conn = new Database.DbConnection().getConnection();

            String query = "UPDATE student_register SET password=? WHERE student_mail=?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, newPassword);
            ps.setString(2, email);
            int result = ps.executeUpdate();

            if (result > 0) {
                session.setAttribute("msg", "Password updated successfully!");
                response.sendRedirect("index.jsp");
            } else {
                session.setAttribute("msg", "Failed to update password.");
                response.sendRedirect("New_Password.jsp");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error: " + e.getMessage());
            response.sendRedirect("New_Password.jsp");
        }
    }
}

