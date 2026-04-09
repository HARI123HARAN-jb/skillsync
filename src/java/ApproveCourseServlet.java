/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author user
 */

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Database.DbConnection;

@WebServlet("/ApproveCourseServlet")
public class ApproveCourseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseId = request.getParameter("course_id");
        response.setContentType("text/html");
        
        try {
            DbConnection db = new DbConnection();
            Connection con = db.getConnection();

            // ✅ Check number of topics in this course
            String topicQuery = "SELECT COUNT(*) FROM topics WHERE course_id = ?";
            PreparedStatement psTopic = con.prepareStatement(topicQuery);
            psTopic.setString(1, courseId);
            ResultSet rsTopic = psTopic.executeQuery();

            int topicCount = 0;
            if (rsTopic.next()) {
                topicCount = rsTopic.getInt(1);
            }

            // ✅ Check modules count under each topic
            boolean hasThreeModulesEach = true;
            if (topicCount >= 3) {
                String moduleQuery = "SELECT topic_id FROM topics WHERE course_id = ?";
                PreparedStatement psModules = con.prepareStatement(moduleQuery);
                psModules.setString(1, courseId);
                ResultSet rsModules = psModules.executeQuery();

                while (rsModules.next()) {
                    String topicId = rsModules.getString("topic_id");
                    PreparedStatement psCount = con.prepareStatement(
                        "SELECT COUNT(*) FROM modules WHERE topic_id = ?");
                    psCount.setString(1, topicId);
                    ResultSet rsCount = psCount.executeQuery();
                    if (rsCount.next() && rsCount.getInt(1) < 3) {
                        hasThreeModulesEach = false;
                        break;
                    }
                }
            } else {
                hasThreeModulesEach = false;
            }
boolean hasFiveQuiz = false;
            String quizCheck = "SELECT COUNT(*) FROM topic_quiz WHERE course_id = ?";
            PreparedStatement psQuiz = con.prepareStatement(quizCheck);
            psQuiz.setString(1, courseId);
            ResultSet rsQuiz = psQuiz.executeQuery();

            if (rsQuiz.next() && rsQuiz.getInt(1) >= 5) {
                hasFiveQuiz = true;
            }
            // ✅ Approve or reject
            if (hasThreeModulesEach && hasFiveQuiz) {
                PreparedStatement psApprove = con.prepareStatement(
                    "UPDATE courses SET status='APPROVED' WHERE course_id=?");
                psApprove.setString(1, courseId);
                psApprove.executeUpdate();

                response.getWriter().println("<script>alert('Course approved successfully!');window.location='Admin_Course.jsp';</script>");
            } else {
                response.getWriter().println("<script>alert('Each course must have at least 3 topics and each topic must have 3 modules,and at least 5 quiz questions in course!');window.location='Admin_Course.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
