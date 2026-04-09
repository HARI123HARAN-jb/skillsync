/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package student_profile;


import Connection.DbConnection;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.*;


@WebServlet("/GetVideoProgress")
public class GetVideoProgress extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student_id") == null) {
            out.print("{\"seconds\":0,\"completed\":false}");
            return;
        }

        String studentId = session.getAttribute("student_id").toString();
        String moduleId  = request.getParameter("module_id");
        String topicId   = request.getParameter("topic_id");

        if (moduleId == null || topicId == null) {
            out.print("{\"seconds\":0,\"completed\":false}");
            return;
        }

        try {
            DbConnection db = new DbConnection();

            // ✅ STEP 1: Check if already completed in student_modules
            ResultSet rsCompleted = db.Select(
                "SELECT video_status FROM student_modules " +
                "WHERE student_id='" + studentId + "' " +
                "AND modules_id='" + moduleId + "' " +
                "AND topic_id='" + topicId + "'"
            );

            if (rsCompleted.next()) {
                String videoStatus = rsCompleted.getString("video_status");
                if ("completed".equals(videoStatus)) {
                    // ✅ Already completed — delete progress row if still exists
                    db.update(
                        "DELETE FROM video_progress " +
                        "WHERE student_id='" + studentId + "' " +
                        "AND module_id='" + moduleId + "' " +
                        "AND topic_id='" + topicId + "'"
                    );
                    // Tell JS: video is done, don't show resume
                    out.print("{\"seconds\":0,\"completed\":true}");
                    return;
                }
            }

            // ✅ STEP 2: Not completed — get saved progress
            ResultSet rs = db.Select(
                "SELECT watched_seconds FROM video_progress " +
                "WHERE student_id='" + studentId + "' " +
                "AND module_id='" + moduleId + "' " +
                "AND topic_id='" + topicId + "'"
            );

            if (rs.next()) {
                double seconds = rs.getDouble("watched_seconds");
                out.print("{\"seconds\":" + seconds + ",\"completed\":false}");
            } else {
                out.print("{\"seconds\":0,\"completed\":false}");
            }

        } catch (Exception e) {
            out.print("{\"seconds\":0,\"completed\":false}");
            e.printStackTrace();
        }
    }
}