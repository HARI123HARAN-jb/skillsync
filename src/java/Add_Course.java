import Database.DbConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/Add_Course")
@MultipartConfig(maxFileSize = 1024 * 1024 * 50) // 50MB
public class Add_Course extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        String courseName = request.getParameter("course_name");
        String description = request.getParameter("description");
        String teacher_id = request.getParameter("teacher_id");

        Part imagePart = request.getPart("image"); // get uploaded file

        try {
            DbConnection db = new DbConnection();
            Connection conn = db.getConnection();

            String sql = "INSERT INTO courses(course_name, description, teacher_id,image,status) VALUES (?, ?, ?, ?,'PENDING')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, courseName);
            ps.setString(2, description);
            ps.setString(3, teacher_id);

            if (imagePart != null) {
                ps.setBinaryStream(4, imagePart.getInputStream(), (int) imagePart.getSize());
            }

            int i = ps.executeUpdate();
            if (i > 0) {
                session.setAttribute("msg", "Course added successfully!");
                response.sendRedirect("Add_Course.jsp");
            } else {
                response.getWriter().println("Failed to add course.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

