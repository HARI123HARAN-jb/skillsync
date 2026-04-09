import Database.DbConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.InputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

@WebServlet("/Add_Topic")
@MultipartConfig(maxFileSize = 1024 * 1024 * 50) // 50MB
public class Add_Topic extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        String courseIdStr = request.getParameter("course_id");
        String coursename = request.getParameter("course_name");
        String teacher_id = request.getParameter("teacher_id");
        String totalStr = request.getParameter("totalModules");

        int totalModules = 0;
        if (totalStr != null && !totalStr.isEmpty()) {
            totalModules = Integer.parseInt(totalStr);
        }

        System.out.println("Total modules received: " + totalModules);

        try {
            DbConnection db = new DbConnection();
            Connection conn = db.getConnection();

            // Count existing topics for this course
            PreparedStatement psCount = conn.prepareStatement(
                "SELECT COUNT(*) AS topic_count FROM topics WHERE course_id=?"
            );
            psCount.setString(1, courseIdStr);
            ResultSet rsCount = psCount.executeQuery();
            int existingTopics = 0;
            if (rsCount.next()) {
                existingTopics = rsCount.getInt("topic_count");
            }
            rsCount.close();
            psCount.close();

            int addedCount = 0;

            // Loop dynamically based on form count
            for (int i = 1; i <= totalModules; i++) {
                String topic = request.getParameter("topic" + i);
                Part filePart = request.getPart("image" + i);
                InputStream inputStream = null;

                if (filePart != null && filePart.getSize() > 0) {
                    inputStream = filePart.getInputStream();
                }

                System.out.println("Module " + i + " Title: " + topic);

                if (topic != null && !topic.trim().isEmpty()) {
                    // Check if topic already exists
                    PreparedStatement psCheck = conn.prepareStatement(
                        "SELECT * FROM topics WHERE course_id=? AND topic_title=?"
                    );
                    psCheck.setString(1, courseIdStr);
                    psCheck.setString(2, topic);
                    ResultSet rsCheck = psCheck.executeQuery();

                    if (rsCheck.next()) {
                        rsCheck.close();
                        psCheck.close();
                        System.out.println("⚠️ Skipped duplicate: " + topic);
                        continue;
                    }
                    rsCheck.close();
                    psCheck.close();

                    // Insert new topic
                    String sql = "INSERT INTO topics(course_id, topic_title, course_name, teacher_id, image) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, courseIdStr);
                    ps.setString(2, topic);
                    ps.setString(3, coursename);
                    ps.setString(4, teacher_id);
                    if (inputStream != null) {
                        ps.setBlob(5, inputStream);
                    } else {
                        ps.setNull(5, java.sql.Types.BLOB);
                    }

                    ps.executeUpdate();
                    ps.close();
                    addedCount++;
                }
            }

            if (addedCount == 0) {
                session.setAttribute("msg", "⚠️ No new modules added. (Duplicates or empty fields)");
            } else {
                session.setAttribute("msg", "✅ " + addedCount + " Module(s) added successfully!");
            }

            response.sendRedirect("select_course.jsp");
            conn.close();
            db.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
