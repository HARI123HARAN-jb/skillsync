package student_profile;

import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.combine;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import org.bson.types.Binary;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Update_Course")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class Update_Course extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String courseIdStr = request.getParameter("course_id");
        String name = request.getParameter("course_name");
        String desc = request.getParameter("description");

        if (courseIdStr == null || courseIdStr.isEmpty()) {
            response.getWriter().println("ERROR: Missing course_id");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);

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
                response.sendRedirect("Admin_Course.jsp"); // Fallback
                return;
            }

            MongoCollection<Document> collection = database.getCollection("courses");

            // 🔹 Update course document
            if (imageData != null) {
                collection.updateOne(eq("course_id", courseId),
                    combine(
                        set("course_name", name),
                        set("description", desc),
                        set("image", new Binary(imageData))
                    ));
            } else {
                collection.updateOne(eq("course_id", courseId),
                    combine(
                        set("course_name", name),
                        set("description", desc)
                    ));
            }

            session.setAttribute("msg", "Course Updated successfully!");
            response.sendRedirect("Edit_Course.jsp?course_id=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
