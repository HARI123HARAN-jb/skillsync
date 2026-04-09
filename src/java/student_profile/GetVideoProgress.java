package student_profile;

import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import org.bson.Document;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/GetVideoProgress")
public class GetVideoProgress extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

        if (courseIdStr == null || moduleIdStr == null) {
            out.print("{\"status\":\"error\",\"message\":\"Missing parameters\"}");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            int moduleId = Integer.parseInt(moduleIdStr);

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                out.print("{\"status\":\"error\",\"message\":\"DB Connection failed\"}");
                return;
            }

            MongoCollection<Document> enrollments = database.getCollection("enrollments");

            // 🔹 Fetch enrollment
            Document enrollment = enrollments.find(and(eq("student_id", studentId), eq("course_id", courseId))).first();

            double lastTime = 0.0;
            if (enrollment != null) {
                List<Document> progressList = enrollment.getList("modules_progress", Document.class);
                if (progressList != null) {
                    for (Document p : progressList) {
                        if (p.getInteger("module_id") == moduleId) {
                            lastTime = p.get( "watched_seconds", 0.0);
                            break;
                        }
                    }
                }
            }

            out.print("{\"status\":\"ok\",\"seconds\":" + lastTime + "}");

        } catch (Exception e) {
            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
