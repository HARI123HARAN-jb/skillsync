/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package student_profile;

import Connection.DbConnection;
import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

@WebServlet("/Update_Course")
@MultipartConfig(maxFileSize = 1024 * 1024 * 50)
public class Update_Course extends HttpServlet {
@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        String courseId = request.getParameter("course_id");
        String name = request.getParameter("course_name");
        String desc = request.getParameter("description");

        try {
            DbConnection db = new DbConnection();
            Connection conn = db.getConnection();

            Part imagePart = request.getPart("image");

            PreparedStatement ps;

            // If new image uploaded
            if (imagePart != null && imagePart.getSize() > 0) {

                ps = conn.prepareStatement(
                    "UPDATE courses SET course_name=?, description=?, image=? WHERE course_id=?"
                );

                ps.setString(1, name);
                ps.setString(2, desc);
                ps.setBinaryStream(3, imagePart.getInputStream(), (int) imagePart.getSize());
                ps.setString(4, courseId);

            } else {

                ps = conn.prepareStatement(
                    "UPDATE courses SET course_name=?, description=? WHERE course_id=?"
                );

                ps.setString(1, name);
                ps.setString(2, desc);
                ps.setString(3, courseId);
            }

            ps.executeUpdate();
            ps.close();
            session.setAttribute("msg", "Course Updated successfully!");
            response.sendRedirect("Edit_Course.jsp?course_id="+courseId);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
