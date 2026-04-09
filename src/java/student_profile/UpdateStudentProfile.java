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

@WebServlet("/UpdateStudentProfile")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class UpdateStudentProfile extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("student_id");

        if (studentId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            String name = request.getParameter("student_name");
            String email = request.getParameter("mail_id");
            String college = request.getParameter("college_name");
            String dept = request.getParameter("department");
            String degree = request.getParameter("degree");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String age = request.getParameter("age");
            String mobile = request.getParameter("ph_no");

            final Part imagePart = request.getPart("image");
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
                response.sendRedirect("Student_Profile.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("students");

            // 🔹 Update student document
            if (imageData != null) {
                collection.updateOne(eq("student_id", studentId), 
                    combine(
                        set("student_name", name),
                        set("student_mail", email),
                        set("college_name", college),
                        set("department", dept),
                        set("degree", degree),
                        set("address", address),
                        set("gender", gender),
                        set("age", age),
                        set("mobile", mobile),
                        set("image", new Binary(imageData))
                    ));
            } else {
                collection.updateOne(eq("student_id", studentId), 
                    combine(
                        set("student_name", name),
                        set("student_mail", email),
                        set("college_name", college),
                        set("department", dept),
                        set("degree", degree),
                        set("address", address),
                        set("gender", gender),
                        set("age", age),
                        set("mobile", mobile)
                    ));
            }

            session.setAttribute("msg", "Profile Updated Successfully!");
            session.setAttribute("student_name", name);
            session.setAttribute("student_mail", email);
            
            response.sendRedirect("Student_Profile.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error: " + e.getMessage());
            response.sendRedirect("Student_Profile.jsp");
        }
    }
}
