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
import Database.DbConnection;

@WebServlet("/MarkNotifRead")
public class MarkNotifRead extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    Integer studentId = (Integer) session.getAttribute("student_id");
    String courseId   = request.getParameter("course_id");
    String markAll    = request.getParameter("mark_all");

    if (studentId != null) {
        try {
            DbConnection db = new DbConnection();
            if ("true".equals(markAll)) {
                // Mark all read for this student
                db.insert(
                    "UPDATE student_notifications " +
                    "SET is_read = 1, last_shown = NOW() " +
                    "WHERE student_id = '" + studentId + "'"
                );
            } else if (courseId != null) {
                // Mark single notification read
                db.insert(
                    "UPDATE student_notifications " +
                    "SET is_read = 1, last_shown = NOW() " +
                    "WHERE student_id = '" + studentId + "' " +
                    "  AND course_id = '" + courseId + "'"
                );
            }
            db.close();
        } catch (Exception e) {}
    }
    response.setStatus(200);
}
}
