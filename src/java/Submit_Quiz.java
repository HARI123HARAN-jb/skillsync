import Database.DbConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Submit_Quiz")
public class Submit_Quiz extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer studentId = (Integer) request.getSession().getAttribute("student_id");
        if (studentId == null) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        String moduleId = request.getParameter("module_id");
        String topicName = request.getParameter("topic_name");
        String topicId = request.getParameter("topic_id");
        String courseId = request.getParameter("course_id");
        String courseName = request.getParameter("course_name");
        int totalQuestions = Integer.parseInt(request.getParameter("totalQuestions"));

        try {
            DbConnection db = new DbConnection();
             Connection con = db.getConnection(); 

            int correctCount = 0;

            // ✅ Loop through all questions shown to student
            for (int i = 1; i <= totalQuestions; i++) {
                String quizIdParam = request.getParameter("quizId" + i);
                String selectedAnswer = request.getParameter("answer" + i);

                if (quizIdParam == null || selectedAnswer == null) continue;

                int quizId = Integer.parseInt(quizIdParam);

                // Fetch correct answer for this specific question
                String sql = "SELECT correct_answer FROM quiz WHERE quiz_id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, quizId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String correctAnswer = rs.getString("correct_answer");
                    if (selectedAnswer.equalsIgnoreCase(correctAnswer)) {
                        correctCount++;
                    }
                }

                rs.close();
                ps.close();
            }

            double percentage = ((double) correctCount / totalQuestions) * 100;

            response.setContentType("text/html");

            if (percentage == 100) {  // ✅ Pass condition (>=60%)
                String updateModule = "UPDATE student_modules SET status='completed' WHERE student_id=? AND modules_id=? AND topic_id=?";
                PreparedStatement psUpdate = con.prepareStatement(updateModule);
                psUpdate.setInt(1, studentId);
                psUpdate.setString(2, moduleId);
                psUpdate.setString(3, topicId);
                psUpdate.executeUpdate();

                response.getWriter().println("<script>alert('You passed the quiz! Score: " 
                        + correctCount + "/" + totalQuestions + 
                        ". Module marked as completed.'); " +
                        "window.location='chose_modules.jsp?topic_name=" + topicName +
                        "&course_name=" + courseName +
                        "&topic_id=" + topicId +
                        "&course_id=" + courseId + "';</script>");
            } else {
                // ❌ Fail condition
                PreparedStatement psPending = con.prepareStatement(
                    "UPDATE student_modules SET video_status='pending', notes_status='pending', status='pending' WHERE student_id=? AND modules_id=? AND topic_id=?");
                psPending.setInt(1, studentId);
                psPending.setString(2, moduleId);
                psPending.setString(3, topicId);
                psPending.executeUpdate();

                PreparedStatement psPending1 = con.prepareStatement(
                    "UPDATE student_topics SET status='pending' WHERE student_id=? AND topic_id=?");
                psPending1.setInt(1, studentId);
                psPending1.setString(2, topicId);
                psPending1.executeUpdate();

                PreparedStatement psPending2 = con.prepareStatement(
                    "UPDATE student_courses SET course_status='pending' WHERE student_id=? AND course_id=?");
                psPending2.setInt(1, studentId);
                psPending2.setString(2, courseId);
                psPending2.executeUpdate();

                response.getWriter().println("<script>alert('You failed the quiz! Score: " 
                        + correctCount + "/" + totalQuestions + 
                        ". Try again.'); " +
                        "window.location='Student_Modules.jsp?module_id=" + moduleId +
                        "&topic_id=" + topicId +
                        "&course_id=" + courseId +
                        "&course_name=" + courseName + "';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error: " + e.getMessage() + "'); window.history.back();</script>");
        }
    }
}
