package student_profile;

import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.UpdateOptions;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SaveVideoProgress")
public class SaveVideoProgress extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student_id") == null) {
            out.print("{\"status\":\"error\",\"message\":\"Not logged in\"}");
            return;
        }

        Integer studentId = (Integer) session.getAttribute("student_id");
        String courseIdStr = request.getParameter("course_id");
        String moduleIdStr = request.getParameter("module_id");
        String secondsStr = request.getParameter("seconds");

        if (courseIdStr == null || moduleIdStr == null || secondsStr == null) {
            out.print("{\"status\":\"error\",\"message\":\"Missing parameters\"}");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            int moduleId = Integer.parseInt(moduleIdStr);
            double seconds = Double.parseDouble(secondsStr);

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                out.print("{\"status\":\"error\",\"message\":\"DB Connection failed\"}");
                return;
            }

            MongoCollection<Document> enrollments = database.getCollection("enrollments");

            // 🔹 1. Fetch existing enrollment
            Document enrollment = enrollments.find(and(eq("student_id", studentId), eq("course_id", courseId))).first();

            if (enrollment == null) {
                out.print("{\"status\":\"error\",\"message\":\"Enrollment not found\"}");
                return;
            }

            // 🔹 2. Check if already completed
            List<Document> progressList = enrollment.getList("modules_progress", Document.class);
            if (progressList != null) {
                for (Document p : progressList) {
                    if (p.getInteger("module_id") == moduleId && "completed".equals(p.getString("status"))) {
                        out.print("{\"status\":\"already_completed\"}");
                        return;
                    }
                }
            } else {
                progressList = new ArrayList<>();
            }

            // 🔹 3. Save progress inside the modules_progress array
            // Check if module exists in array
            boolean found = false;
            for (Document p : progressList) {
                if (p.getInteger("module_id") == moduleId) {
                    p.put("watched_seconds", seconds);
                    found = true;
                    break;
                }
            }
            if (!found) {
                progressList.add(new Document("module_id", moduleId)
                        .append("watched_seconds", seconds)
                        .append("video_status", "pending")
                        .append("notes_status", "pending")
                        .append("status", "pending"));
            }

            enrollments.updateOne(and(eq("student_id", studentId), eq("course_id", courseId)), 
                    set("modules_progress", progressList));

            out.print("{\"status\":\"ok\",\"saved\":" + seconds + "}");

        } catch (Exception e) {
            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
