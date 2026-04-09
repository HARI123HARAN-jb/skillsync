package student_profile;

import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.UpdateOptions;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.combine;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import java.io.IOException;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Update_Modules")
public class Update_Modules extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String courseIdStr = request.getParameter("course_id");
        String moduleIdStr = request.getParameter("modules_id");
        String title = request.getParameter("module_title");
        String video = request.getParameter("video_path");
        String notes = request.getParameter("notes_path");

        if (courseIdStr == null || moduleIdStr == null) {
            response.getWriter().println("ERROR: Missing IDs");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            int moduleId = Integer.parseInt(moduleIdStr);

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                session.setAttribute("msg", "Database Connection Failed!");
                response.sendRedirect("Admin_Home.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("courses");

            // 🔹 Update the specific MODULE inside the MODULES array using Array Filters
            collection.updateOne(eq("course_id", courseId),
                combine(
                    set("modules.$[m].module_title", title),
                    set("modules.$[m].video_path", video),
                    set("modules.$[m].notes_path", notes)
                ),
                new UpdateOptions().arrayFilters(Arrays.asList(eq("m.modules_id", moduleId))));

            session.setAttribute("msg", "Module Updated successfully!");
            response.sendRedirect("Edit_Modules.jsp?modules_id=" + moduleId + "&course_id=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
