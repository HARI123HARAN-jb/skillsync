import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.push;
import org.bson.Document;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Random;

@WebServlet(urlPatterns = {"/Add_Modules"})
public class Add_Modules extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            String course_id_str = request.getParameter("course_id");
            String module_title = request.getParameter("module_title");
            String video_path = request.getParameter("video_path");
            String notes_path = request.getParameter("notes_path");
            String topic_id = request.getParameter("topic_id");
            String topic_name = request.getParameter("topic_name");
            String teacher_id = session.getAttribute("teacher_id").toString();

            int course_id = Integer.parseInt(course_id_str);

            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                session.setAttribute("msg", "Database Connection Failed!");
                response.sendRedirect("Teacher_Home.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("courses");

            int moduleId = 1000 + new Random().nextInt(9000);

            // 🔹 Create module document
            Document module = new Document("modules_id", moduleId)
                    .append("module_title", module_title)
                    .append("video_path", video_path)
                    .append("notes_path", notes_path)
                    .append("topic_id", topic_id)
                    .append("topic_name", topic_name)
                    .append("teacher_id", teacher_id);

            // 🔹 Use MongoDB $push to nest the module inside the specific course
            collection.updateOne(eq("course_id", course_id), push("modules", module));

            session.setAttribute("msg", "Module Added Successfully to Course!");
            response.sendRedirect("Add_Modules.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error: " + e.getMessage());
            response.sendRedirect("Teacher_Home.jsp");
        }
    }
}
