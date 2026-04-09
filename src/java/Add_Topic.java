import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.push;
import org.bson.Document;
import org.bson.types.Binary;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Random;

@WebServlet(urlPatterns = {"/Add_Topic"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class Add_Topic extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            String course_id_str = request.getParameter("course_id");
            String topic_title = request.getParameter("topic_title");
            String course_name = request.getParameter("course_name");
            String teacher_id = session.getAttribute("teacher_id").toString();

            Part imagePart = request.getPart("image");
            byte[] imageData = null;

            if (imagePart != null && imagePart.getSize() > 0) {
                try (InputStream is = imagePart.getInputStream()) {
                    imageData = new byte[(int) imagePart.getSize()];
                    is.read(imageData);
                }
            }

            int course_id = Integer.parseInt(course_id_str);

            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                session.setAttribute("msg", "Database Connection Failed!");
                response.sendRedirect("Teacher_Home.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("courses");

            int topicId = 600 + new Random().nextInt(400);

            // 🔹 Create topic document
            Document topic = new Document("topic_id", topicId)
                    .append("topic_title", topic_title)
                    .append("course_name", course_name)
                    .append("teacher_id", teacher_id);

            if (imageData != null) {
                topic.append("image", new Binary(imageData));
            }

            // 🔹 Nest the topic inside the course document
            // If the topics array doesn't exist, MongoDB will create it
            collection.updateOne(eq("course_id", course_id), push("topics", topic));

            session.setAttribute("msg", "Topic Added Successfully to Course!");
            response.sendRedirect("Add_Topic.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error: " + e.getMessage());
            response.sendRedirect("Teacher_Home.jsp");
        }
    }
}
