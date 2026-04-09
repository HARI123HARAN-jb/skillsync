import Connection.DbConnection;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Add_Modules")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 5,
    maxFileSize       = 1024 * 1024 * 600,
    maxRequestSize    = 1024 * 1024 * 600
)
public class Add_Modules extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
HttpSession session = request.getSession();
        // ── 1. Read common parameters ─────────────────────────────
        String teacherId  = request.getParameter("teacher_id");
        String courseId   = request.getParameter("course_id");
        String topicIdStr = request.getParameter("topic_id");
        String topicName  = request.getParameter("topic_name");
        String totalStr   = request.getParameter("topicCount");

        // ── 2. Validate required fields ───────────────────────────
        if (courseId == null || topicIdStr == null || totalStr == null) {
            session.setAttribute("msg", "Missing Value!");
            response.sendRedirect("select_course1.jsp");
            return;
        }

        int topicId     = Integer.parseInt(topicIdStr);
        int totalTopics = Integer.parseInt(totalStr);

        System.out.println("Total modules received: " + totalTopics);
       
        // ── 3. Prepare upload directories ─────────────────────────
        String basePath = getServletContext().getRealPath("/") + "uploads";
        File videoDir   = new File(basePath, "videos");
        File notesDir   = new File(basePath, "notes");
        if (!videoDir.exists()) videoDir.mkdirs();
        if (!notesDir.exists()) notesDir.mkdirs();

        Connection conn = null;

        try {
            DbConnection db = new DbConnection();
            conn = db.getConnection();
            conn.setAutoCommit(false); // ✅ Transaction — all or nothing

            for (int i = 1; i <= totalTopics; i++) {

                // ── 4. Get module fields ───────────────────────────
                String topicTitle = request.getParameter("topic" + i + "_title");
                if (topicTitle == null || topicTitle.trim().isEmpty()) continue;

                Part videoPart = request.getPart("topic" + i + "_video");
                Part notesPart = request.getPart("topic" + i + "_notes");

                // ── 5. Get filenames safely ────────────────────────
                String videoFileName = getFileName(videoPart);
                String notesFileName = getFileName(notesPart);

                // ── 6. Add timestamp to avoid filename conflicts ───
                String timestamp = String.valueOf(System.currentTimeMillis());

                String videoPath = "";
                String notesPath = "";

                if (!videoFileName.isEmpty()) {
                    String safeVideoName = timestamp + "_" + i + "_" + videoFileName;
                    videoPart.write(new File(videoDir, safeVideoName).getAbsolutePath());
                    videoPath = "uploads/videos/" + safeVideoName;
                }

                if (!notesFileName.isEmpty()) {
                    String safeNotesName = timestamp + "_" + i + "_" + notesFileName;
                    notesPart.write(new File(notesDir, safeNotesName).getAbsolutePath());
                    notesPath = "uploads/notes/" + safeNotesName;
                }

                // ── 7. Insert module into DB ───────────────────────
                PreparedStatement psTopic = conn.prepareStatement(
                    "INSERT INTO modules " +
                    "(topic_id, module_title, video_path, notes_path, topic_name, teacher_id, course_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
                );
                psTopic.setInt(1, topicId);
                psTopic.setString(2, topicTitle.trim());
                psTopic.setString(3, videoPath);
                psTopic.setString(4, notesPath);
                psTopic.setString(5, topicName);
                psTopic.setString(6, teacherId);
                psTopic.setString(7, courseId);
                psTopic.executeUpdate();

                // ── 8. Get generated module ID ─────────────────────
                int moduleId = 0;
                ResultSet rs = psTopic.getGeneratedKeys();
                if (rs.next()) {
                    moduleId = rs.getInt(1);
                }
                rs.close();
                psTopic.close();

                if (moduleId == 0) {
                    throw new Exception("Failed to get module ID for topic " + i);
                }

                // ── 9. Insert quiz questions ───────────────────────
                for (int q = 1; q <= 3; q++) {
                    String question = request.getParameter("topic" + i + "_q" + q);
                    if (question == null || question.trim().isEmpty()) continue;

                    String optA    = request.getParameter("topic" + i + "_q" + q + "_a");
                    String optB    = request.getParameter("topic" + i + "_q" + q + "_b");
                    String optC    = request.getParameter("topic" + i + "_q" + q + "_c");
                    String optD    = request.getParameter("topic" + i + "_q" + q + "_d");
                    String correct = request.getParameter("topic" + i + "_q" + q + "_correct");

                    PreparedStatement psQuiz = conn.prepareStatement(
                        "INSERT INTO quiz " +
                        "(module_id, question, option_a, option_b, option_c, option_d, " +
                        "correct_answer, teacher_id, course_id) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
                    );
                    psQuiz.setInt(1, moduleId);
                    psQuiz.setString(2, question.trim());
                    psQuiz.setString(3, optA);
                    psQuiz.setString(4, optB);
                    psQuiz.setString(5, optC);
                    psQuiz.setString(6, optD);
                    psQuiz.setString(7, correct);
                    psQuiz.setString(8, teacherId);
                    psQuiz.setString(9, courseId);
                    psQuiz.executeUpdate();
                    psQuiz.close();
                }

            } // end for loop

            conn.commit(); // ✅ All inserted successfully
            System.out.println("All modules and quizzes saved successfully!");
            session.setAttribute("msg", "All modules and quizzes saved successfully!");
            // ✅ Redirect ONLY — no getWriter() before this
            response.sendRedirect("chose_topic.jsp?course_id=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            // ✅ Rollback everything if any error
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            session.setAttribute("msg", "Missing Value!");
            response.sendRedirect("select_course1.jsp");

        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception ignored) {}
        }
    }

    // ── Helper: safely get filename from Part ─────────────────────
    private String getFileName(Part part) {
        if (part == null) return "";
        String submitted = part.getSubmittedFileName();
        if (submitted == null || submitted.trim().isEmpty()) return "";
        // Get just the filename (IE sends full path sometimes)
        return new File(submitted).getName();
    }
}