package student_profile;

import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.UpdateOptions;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.combine;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import org.bson.types.Binary;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Update_Topic")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class Update_Topic extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String courseIdStr = request.getParameter("course_id");
        String topicIdStr = request.getParameter("topic_id");
        String title = request.getParameter("topic_title");

        if (courseIdStr == null || topicIdStr == null) {
            response.getWriter().println("ERROR: Missing IDs");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            int topicId = Integer.parseInt(topicIdStr);

            Part imagePart = request.getPart("image");
            byte[] imageData = null;

            if (imagePart != null && imagePart.getSize() > 0) {
                try (InputStream is = imagePart.getInputStream()) {
                    imageData = new byte[(int) imagePart.getSize()];
                    is.read(imageData);
                }
            }

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                session.setAttribute("msg", "Database Connection Failed!");
                response.sendRedirect("Admin_Home.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("courses");

            // 🔹 Update the specific TOPIC inside the TOPICS array using Array Filters
            if (imageData != null) {
                collection.updateOne(eq("course_id", courseId),
                    combine(
                        set("topics.$[t].topic_title", title),
                        set("topics.$[t].image", new Binary(imageData))
                    ),
                    new UpdateOptions().arrayFilters(Arrays.asList(eq("t.topic_id", topicId))));
            } else {
                collection.updateOne(eq("course_id", courseId),
                    set("topics.$[t].topic_title", title),
                    new UpdateOptions().arrayFilters(Arrays.asList(eq("t.topic_id", topicId))));
            }

            session.setAttribute("msg", "Topic Updated successfully!");
            response.sendRedirect("Edit_Topic.jsp?topic_id=" + topicId + "&course_id=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
