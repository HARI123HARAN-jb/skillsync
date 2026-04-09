/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author admin
 */
@WebServlet(urlPatterns = {"/Admin_Login"})
public class Admin_Login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);
        try {
            String userName = request.getParameter("userName");
            String password = request.getParameter("password");

            // 🔹 Database connection
            Database.DbConnection db = new Database.DbConnection();
            java.sql.Connection con = db.getConnection();

            if (con == null) {
                session.setAttribute("msg", "Database Connection Failed! Please check your Render Environment Variables.");
                response.sendRedirect("index.jsp");
                return;
            }

            // 🔹 Query admin table
            String query = "SELECT * FROM admin WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, userName);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("msg", "Successfully Login");
                session.setAttribute("userName", userName);
                session.setAttribute("password", password);
                response.sendRedirect("Admin_Home.jsp");
            } else {
                session.setAttribute("msg", "UserName & password incorrect!...");
                response.sendRedirect("index.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Login Servlet";
    }
}
