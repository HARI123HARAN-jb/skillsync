import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.addToSet;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Submit_Quiz")
public class Submit_Quiz extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("student_id");

        if (studentId == null) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        String moduleIdStr = request.getParameter("module_id");
        String topicIdStr = request.getParameter("topic_id");
        String courseIdStr = request.getParameter("course_id");
        String topicName = request.getParameter("topic_name");
        String courseName = request.getParameter("course_name");
        int totalQuestions = Integer.parseInt(request.getParameter("totalQuestions"));

        try {
            int courseId = Integer.parseInt(courseIdStr);
            int moduleId = Integer.parseInt(moduleIdStr);

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                response.getWriter().println("<script>alert('Database connection failed!'); window.history.back();</script>");
                return;
            }

            MongoCollection<Document> courses = database.getCollection("courses");
            MongoCollection<Document> enrollments = database.getCollection("enrollments");

            // 🔹 1. Fetch the course to get nested quizzes
            Document course = courses.find(eq("course_id", courseId)).first();
            if (course == null) {
                response.getWriter().println("<script>alert('Course not found!'); window.history.back();</script>");
                return;
            }

            List<Document> nestedQuizzes = course.getList("quizzes", Document.class);
            int correctCount = 0;

            // 🔹 2. Loop through student answers and verify against nested data
            for (int i = 1; i <= totalQuestions; i++) {
                String quizIdParam = request.getParameter("quizId" + i);
                String selectedAnswer = request.getParameter("answer" + i);

                if (quizIdParam == null || selectedAnswer == null) continue;

                int quizId = Integer.parseInt(quizIdParam);

                // Find the quiz in our nested list
                if (nestedQuizzes != null) {
                    for (Document q : nestedQuizzes) {
                        if (q.getInteger("quiz_id") == quizId) {
                            String correctAnswer = q.getString("correct_answer");
                            if (selectedAnswer.equalsIgnoreCase(correctAnswer)) {
                                correctCount++;
                            }
                            break;
                        }
                    }
                }
            }

            double percentage = ((double) correctCount / totalQuestions) * 100;
            response.setContentType("text/html");

            if (percentage == 100) { // ✅ PASS
                // 🔹 3. Update Enrollment: Add this module to completed list
                enrollments.updateOne(
                    and(eq("student_id", studentId), eq("course_id", courseId)),
                    addToSet("completed_modules", moduleId)
                );

                // Check if all modules are completed for this course
                Document enrollment = enrollments.find(and(eq("student_id", studentId), eq("course_id", courseId))).first();
                List<Integer> completed = enrollment.getList("completed_modules", Integer.class);
                List<Document> courseModules = course.getList("modules", Document.class);

                if (completed != null && courseModules != null && completed.size() >= courseModules.size()) {
                    enrollments.updateOne(
                        and(eq("student_id", studentId), eq("course_id", courseId)),
                        set("course_status", "completed")
                    );
                }

                response.getWriter().println("<script>alert('You passed the quiz! Score: " 
                        + correctCount + "/" + totalQuestions + ". Module completed!'); " +
                        "window.location='chose_modules.jsp?topic_name=" + topicName +
                        "&course_name=" + courseName + "&topic_id=" + topicIdStr +
                        "&course_id=" + courseIdStr + "';</script>");

            } else { // ❌ FAIL
                response.getWriter().println("<script>alert('You failed the quiz! Score: " 
                        + correctCount + "/" + totalQuestions + ". Try again!'); " +
                        "window.location='Student_Modules.jsp?module_id=" + moduleIdStr +
                        "&topic_id=" + topicIdStr + "&course_id=" + courseIdStr +
                        "&course_name=" + courseName + "';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error: " + e.getMessage() + "'); window.history.back();</script>");
        }
    }
}
