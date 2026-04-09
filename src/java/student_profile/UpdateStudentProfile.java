/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package student_profile;

/**
 *
 * @author user
 */
import javax.servlet.http.HttpServlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import Connection.DbConnection;

@WebServlet("/UpdateStudentProfile")
public class UpdateStudentProfile extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("student_id"));
        String name = request.getParameter("student_name");
        String mail = request.getParameter("student_mail");
        String college = request.getParameter("college_name");
        String dept = request.getParameter("department");
        String degree = request.getParameter("degree");
        String address = request.getParameter("address");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            DbConnection db = new DbConnection();
            con = db.getConnection();

            ps = con.prepareStatement(
                "UPDATE student_register SET student_name=?, student_mail=?, college_name=?, department=?, degree=?, address=? WHERE student_id=?"
            );

            ps.setString(1, name);
            ps.setString(2, mail);
            ps.setString(3, college);
            ps.setString(4, dept);
            ps.setString(5, degree);
            ps.setString(6, address);
            ps.setInt(7, id);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("Student_Profile.jsp?updated=success");
            } else {
                response.sendRedirect("Student_Profile.jsp?updated=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}