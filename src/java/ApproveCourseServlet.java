import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/ApproveCourseServlet")
public class ApproveCourseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseIdStr = request.getParameter("course_id");
        response.setContentType("text/html");
        
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            response.getWriter().println("ERROR: course_id missing");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                response.getWriter().println("ERROR: Database Connection Failed!");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("courses");

            // 🔹 Fetch the course document
            Document course = collection.find(eq("course_id", courseId)).first();

            if (course == null) {
                response.getWriter().println("<script>alert('Course not found!');window.location='Admin_Course.jsp';</script>");
                return;
            }

            // 🔹 Get arrays from the nested document
            List<Document> topics = course.getList("topics", Document.class);
            List<Document> modules = course.getList("modules", Document.class);
            List<Document> quizzes = course.getList("quizzes", Document.class);

            boolean hasMinimumTopics = (topics != null && topics.size() >= 3);
            boolean hasMinimumQuizzes = (quizzes != null && quizzes.size() >= 5);
            boolean hasThreeModulesPerTopic = true;

            if (hasMinimumTopics && modules != null) {
                for (Document topic : topics) {
                    final String tid = String.valueOf(topic.get("topic_id"));
                    long count = modules.stream()
                            .filter(m -> tid.equals(String.valueOf(m.get("topic_id"))))
                            .count();
                    if (count < 3) {
                        hasThreeModulesPerTopic = false;
                        break;
                    }
                }
            } else {
                hasThreeModulesPerTopic = false;
            }

            // 🔹 Approve or reject based on requirements
            if (hasMinimumTopics && hasThreeModulesPerTopic && hasMinimumQuizzes) {
                collection.updateOne(eq("course_id", courseId), set("status", "APPROVED"));
                response.getWriter().println("<script>alert('Course approved successfully!');window.location='Admin_Course.jsp';</script>");
            } else {
                response.getWriter().println("<script>alert('Validation Failed: Each course must have at least 3 topics, each topic must have 3 modules, and at least 5 quiz questions must be added.');window.location='Admin_Course.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
