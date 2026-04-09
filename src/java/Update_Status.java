import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import org.bson.Document;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Update_Status")
public class Update_Status extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String moduleIdStr = request.getParameter("module_id");
        String action = request.getParameter("status"); // "video_completed" or "notes_completed"
        String topicIdStr = request.getParameter("topic_id");
        String courseIdStr = request.getParameter("course_id");
        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("student_id");

        if (studentId == null || courseIdStr == null || moduleIdStr == null) {
            response.getWriter().println("ERROR: Unauthorized or missing params");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            int moduleId = Integer.parseInt(moduleIdStr);

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                response.getWriter().println("ERROR: DB Connection failed");
                return;
            }

            MongoCollection<Document> enrollments = database.getCollection("enrollments");

            // 🔹 Fetch existing enrollment
            Document enrollment = enrollments.find(and(eq("student_id", studentId), eq("course_id", courseId))).first();

            if (enrollment == null) {
                response.getWriter().println("ERROR: No enrollment found");
                return;
            }

            // 🔹 Get or initialize the nested module progress array
            List<Document> progressList = enrollment.getList("modules_progress", Document.class);
            if (progressList == null) progressList = new ArrayList<>();

            Document moduleProg = null;
            for (Document p : progressList) {
                if (p.getInteger("module_id") == moduleId) {
                    moduleProg = p;
                    break;
                }
            }

            if (moduleProg == null) {
                moduleProg = new Document("module_id", moduleId)
                        .append("video_status", "pending")
                        .append("notes_status", "pending")
                        .append("status", "pending");
                progressList.add(moduleProg);
            }

            // 🔹 Update status based on action
            if ("video_completed".equals(action)) {
                moduleProg.put("video_status", "completed");
            } else if ("notes_completed".equals(action)) {
                moduleProg.put("notes_status", "completed");
            }

            // 🔹 Check if ready for quiz
            if ("completed".equals(moduleProg.getString("video_status")) && 
                "completed".equals(moduleProg.getString("notes_status"))) {
                moduleProg.put("status", "ready_for_quiz");
            }

            // 🔹 Push the updated progress back to MongoDB
            // In a real app, we'd use positional operators, but here we replace the list for simplicity in a fresh migration
            enrollments.updateOne(and(eq("student_id", studentId), eq("course_id", courseId)), 
                    new Document("$set", new Document("modules_progress", progressList)));

            response.getWriter().println("OK");

        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
