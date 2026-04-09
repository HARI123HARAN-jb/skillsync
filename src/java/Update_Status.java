import Database.DbConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/Update_Status")
public class Update_Status extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String moduleId = request.getParameter("module_id");
        String action = request.getParameter("status"); // "video_completed" or "notes_completed"
        String topicId = request.getParameter("topic_id");
        Integer studentId = (Integer) request.getSession().getAttribute("student_id");

        try {
            DbConnection db = new DbConnection();
            Connection conn = db.getConnection();

            // Update the respective column
            if ("video_completed".equals(action)) {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE student_modules SET video_status='completed' WHERE student_id=? AND modules_id=? AND topic_id=?");
                ps.setInt(1, studentId);
                ps.setString(2, moduleId);
                ps.setString(3, topicId);
                ps.executeUpdate();
                ps.close();
            } else if ("notes_completed".equals(action)) {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE student_modules SET notes_status='completed' WHERE student_id=? AND modules_id=? AND topic_id=?");
                ps.setInt(1, studentId);
                ps.setString(2, moduleId);
                ps.setString(3, topicId);
                ps.executeUpdate();
                ps.close();
            }

            // Check if both video + notes are completed
            PreparedStatement psCheck = conn.prepareStatement(
                "SELECT video_status, notes_status FROM student_modules WHERE student_id=? AND modules_id=? AND topic_id=?");
            psCheck.setInt(1, studentId);
            psCheck.setString(2, moduleId);
            psCheck.setString(3, topicId);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                String videoStatus = rs.getString("video_status");
                String notesStatus = rs.getString("notes_status");

                if ("completed".equals(videoStatus) && "completed".equals(notesStatus)) {
                    // Now both are done → unlock quiz
                    PreparedStatement psReady = conn.prepareStatement(
                        "UPDATE student_modules SET status='ready_for_quiz' WHERE student_id=? AND modules_id=? AND topic_id=?");
                    psReady.setInt(1, studentId);
                    psReady.setString(2, moduleId);
                    psReady.setString(3, topicId);
                    psReady.executeUpdate();
                    psReady.close();
                }
            }
            rs.close();
            psCheck.close();

            response.getWriter().println("OK");

        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
