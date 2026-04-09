/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package student_profile;


import Database.DbConnection;
import java.io.*;
import java.nio.file.Paths;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

@WebServlet("/Update_Modules")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 5,
    maxFileSize       = 1024 * 1024 * 600,
    maxRequestSize    = 1024 * 1024 * 600
)
public class Update_Modules extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Session check ──────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("teacher_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection conn = null;

        String topic_id  = request.getParameter("topic_id");
        String course_id = request.getParameter("course_id");
        String moduleCountStr = request.getParameter("moduleCount");

        // ── 2. Validate ───────────────────────────────────────────
        if (moduleCountStr == null || moduleCountStr.trim().isEmpty()) {
            session.setAttribute("msg", "❌ No modules found to update!");
            response.sendRedirect("Edit_Modules.jsp?topic_id=" + topic_id
                                + "&course_id=" + course_id);
            return;
        }

        int moduleCount = Integer.parseInt(moduleCountStr);

        try {
            DbConnection db = new DbConnection();
            conn = db.getConnection();
            conn.setAutoCommit(false); // ✅ One transaction for ALL modules

            String basePath = getServletContext().getRealPath("/") + "uploads";
            File videoDir   = new File(basePath, "videos");
            File notesDir   = new File(basePath, "notes");
            if (!videoDir.exists()) videoDir.mkdirs();
            if (!notesDir.exists()) notesDir.mkdirs();

            // ✅ Loop through ALL modules at once
            for (int i = 1; i <= moduleCount; i++) {

                String moduleId = request.getParameter("module_id_" + i);
                String title    = request.getParameter("module_title_" + i);

                if (moduleId == null || moduleId.trim().isEmpty()) continue;
                if (title    == null || title.trim().isEmpty())    continue;

                // ── 3. Get old file paths ──────────────────────────
                String oldVideoPath = null;
                String oldNotesPath = null;

                PreparedStatement psOld = conn.prepareStatement(
                    "SELECT video_path, notes_path FROM modules WHERE modules_id=?"
                );
                psOld.setString(1, moduleId);
                ResultSet rsOld = psOld.executeQuery();
                if (rsOld.next()) {
                    oldVideoPath = rsOld.getString("video_path");
                    oldNotesPath = rsOld.getString("notes_path");
                }
                rsOld.close();
                psOld.close();

                // ── 4. Handle file uploads ─────────────────────────
                Part   videoPart        = request.getPart("video_" + i);
                Part   notesPart        = request.getPart("notes_" + i);
                String newVideoPath     = null;
                String newNotesPath     = null;
                boolean newVideoUploaded = false;
                boolean newNotesUploaded = false;

                if (videoPart != null && videoPart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + i + "_" +
                        Paths.get(videoPart.getSubmittedFileName()).getFileName().toString();
                    videoPart.write(new File(videoDir, fileName).getAbsolutePath());
                    newVideoPath     = "uploads/videos/" + fileName;
                    newVideoUploaded = true;
                }

                if (notesPart != null && notesPart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + i + "_" +
                        Paths.get(notesPart.getSubmittedFileName()).getFileName().toString();
                    notesPart.write(new File(notesDir, fileName).getAbsolutePath());
                    newNotesPath     = "uploads/notes/" + fileName;
                    newNotesUploaded = true;
                }

                // ── 5. Build dynamic UPDATE SQL ────────────────────
                StringBuilder sql = new StringBuilder(
                    "UPDATE modules SET module_title=?"
                );
                if (newVideoUploaded) sql.append(", video_path=?");
                if (newNotesUploaded) sql.append(", notes_path=?");
                sql.append(" WHERE modules_id=?");

                PreparedStatement ps = conn.prepareStatement(sql.toString());
                int idx = 1;
                ps.setString(idx++, title.trim());
                if (newVideoUploaded) ps.setString(idx++, newVideoPath);
                if (newNotesUploaded) ps.setString(idx++, newNotesPath);
                ps.setString(idx, moduleId);
                ps.executeUpdate();
                ps.close();

                System.out.println("✅ Module " + i + " updated: " + moduleId);

                // ── 6. Clear student video progress if new video ───
                if (newVideoUploaded) {
                    PreparedStatement psDel = conn.prepareStatement(
                        "DELETE FROM video_progress WHERE module_id=?"
                    );
                    psDel.setString(1, moduleId);
                    psDel.executeUpdate();
                    psDel.close();
                    System.out.println("✅ Cleared video_progress for module: " + moduleId);
                }

                // ── 7. Update quiz questions for this module ───────
                String qCountStr = request.getParameter("questionCount_" + i);
                if (qCountStr != null && !qCountStr.trim().isEmpty()) {
                    int qCount = Integer.parseInt(qCountStr);

                    for (int q = 1; q <= qCount; q++) {
                        String quizId  = request.getParameter("quiz_id_" + i + "_" + q);
                        String question= request.getParameter("q_" + i + "_" + q);
                        String optA    = request.getParameter("q_" + i + "_" + q + "_a");
                        String optB    = request.getParameter("q_" + i + "_" + q + "_b");
                        String optC    = request.getParameter("q_" + i + "_" + q + "_c");
                        String optD    = request.getParameter("q_" + i + "_" + q + "_d");
                        String correct = request.getParameter("q_" + i + "_" + q + "_correct");

                        if (question == null || question.trim().isEmpty()) continue;
                        if (quizId   == null || quizId.trim().isEmpty())   continue;

                        PreparedStatement qps = conn.prepareStatement(
                            "UPDATE quiz SET question=?, option_a=?, option_b=?, " +
                            "option_c=?, option_d=?, correct_answer=? WHERE quiz_id=?"
                        );
                        qps.setString(1, question.trim());
                        qps.setString(2, optA);
                        qps.setString(3, optB);
                        qps.setString(4, optC);
                        qps.setString(5, optD);
                        qps.setString(6, correct);
                        qps.setString(7, quizId);
                        qps.executeUpdate();
                        qps.close();

                        System.out.println("✅ Quiz " + q + " updated for module: " + moduleId);
                    }
                }
            } // ✅ End loop — all modules processed

            // ── 9. Commit ALL changes at once ─────────────────────
            conn.commit();
            System.out.println("✅ All " + moduleCount + " modules committed!");

            session.setAttribute("msg", "✅ All modules updated successfully!");
            response.sendRedirect("Edit_Modules.jsp?topic_id=" + topic_id
                                + "&course_id=" + course_id);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
                System.out.println("❌ Rolled back all changes");
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            session.setAttribute("msg", "❌ Update failed: " + e.getMessage());
            response.sendRedirect("Edit_Modules.jsp?topic_id=" + topic_id
                                + "&course_id=" + course_id);

        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
