import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.Binary;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Random;

@WebServlet(urlPatterns = {"/Add_Course"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class Add_Course extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            String course_name = request.getParameter("course_name");
            String description = request.getParameter("description");
            String teacher_id = session.getAttribute("teacher_id").toString();

            Part imagePart = request.getPart("image");
            byte[] imageData = null;

            if (imagePart != null && imagePart.getSize() > 0) {
                try (InputStream is = imagePart.getInputStream()) {
                    imageData = new byte[(int) imagePart.getSize()];
                    is.read(imageData);
                }
            }

            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                session.setAttribute("msg", "Database Connection Failed!");
                response.sendRedirect("Teacher_Home.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("courses");

            int courseId = 500 + new Random().nextInt(500);

            // 🔹 Create course document with an empty modules array (Nesting)
            Document course = new Document("course_id", courseId)
                    .append("course_name", course_name)
                    .append("description", description)
                    .append("teacher_id", teacher_id)
                    .append("status", "NOT APPROVED")
                    .append("modules", new ArrayList<Document>()); // Ready for nesting

            if (imageData != null) {
                course.append("image", new Binary(imageData));
            }

            collection.insertOne(course);

            session.setAttribute("msg", "Course Added Successfully! Waiting for Admin Approval.");
            response.sendRedirect("Add_Course.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error: " + e.getMessage());
            response.sendRedirect("Teacher_Home.jsp");
        }
    }
}
