/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package student_profile;


import Database.DbConnection;
import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;



@WebServlet("/SaveVideoProgress")
public class SaveVideoProgress extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        // ── 1. Check session ──────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student_id") == null) {
            out.print("{\"status\":\"error\",\"message\":\"Not logged in\"}");
            return;
        }

        String studentId  = session.getAttribute("student_id").toString();
        String courseId   = request.getParameter("course_id");
        String moduleId   = request.getParameter("module_id");
        String topicId    = request.getParameter("topic_id");
        String secondsStr = request.getParameter("seconds");

        if (moduleId == null || topicId == null || secondsStr == null) {
            out.print("{\"status\":\"error\",\"message\":\"Missing parameters\"}");
            return;
        }

        double seconds;
        try {
            seconds = Double.parseDouble(secondsStr);
        } catch (NumberFormatException e) {
            out.print("{\"status\":\"error\",\"message\":\"Invalid seconds\"}");
            return;
        }

        try {
            DbConnection db = new DbConnection();

            // ✅ STEP 1: Check if video is already completed
            // If completed, do NOT save progress at all
            ResultSet rsCompleted = db.Select(
                "SELECT video_status FROM student_modules " +
                "WHERE student_id='" + studentId + "' " +
                "AND modules_id='" + moduleId + "' " +
                "AND topic_id='" + topicId + "'"
            );

            if (rsCompleted.next()) {
                String videoStatus = rsCompleted.getString("video_status");
                if ("completed".equals(videoStatus)) {
                    // ✅ Video already completed — delete any leftover progress row
                    db.update(
                        "DELETE FROM video_progress " +
                        "WHERE student_id='" + studentId + "' " +
                        "AND module_id='" + moduleId + "' " +
                        "AND topic_id='" + topicId + "'"
                    );
                    out.print("{\"status\":\"already_completed\"}");
                    return; // ✅ Stop here — don't save anything
                }
            }

            // ✅ STEP 2: Video not completed yet — save progress normally
            ResultSet rsExists = db.Select(
                "SELECT v_id FROM video_progress " +
                "WHERE student_id='" + studentId + "' " +
                "AND module_id='" + moduleId + "' " +
                "AND topic_id='" + topicId + "'"
            );

            if (rsExists.next()) {
                // UPDATE existing row
                db.update(
                    "UPDATE video_progress " +
                    "SET watched_seconds='" + seconds + "', " +
                    "last_updated=CURRENT_TIMESTAMP " +
                    "WHERE student_id='" + studentId + "' " +
                    "AND module_id='" + moduleId + "' " +
                    "AND topic_id='" + topicId + "'"
                );
            } else {
                // INSERT new row
                db.update(
                    "INSERT INTO video_progress " +
                    "(student_id, course_id, module_id, topic_id, watched_seconds) " +
                    "VALUES('" + studentId + "','" + courseId + "','" +
                    moduleId + "','" + topicId + "','" + seconds + "')"
                );
            }

            out.print("{\"status\":\"ok\",\"saved\":" + seconds + "}");

        } catch (Exception e) {
            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
