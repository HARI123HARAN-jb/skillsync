import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import org.bson.Document;
import org.bson.types.Binary;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Random;

@WebServlet(urlPatterns = {"/Student_Register"})
@MultipartConfig(maxFileSize = 50 * 1024 * 1024) 
public class Student_Register extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // 🔹 Get form fields
            String student_name = request.getParameter("student_name");
            String mail_id = request.getParameter("mail_id");
            String password = request.getParameter("password");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String ph_no = request.getParameter("ph_no");
            String college_name = request.getParameter("college_name");
            String department = request.getParameter("department");
            String degree = request.getParameter("degree");
            String age = request.getParameter("age");
            String register_id = request.getParameter("register_id");

            // 🔹 Get uploaded image
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
                session.setAttribute("msg", "Database Connection Failed! Please check your MongoDB configuration.");
                response.sendRedirect("index.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("students");

            // 🔹 Check duplicate email
            Document existing = collection.find(eq("student_mail", mail_id)).first();

            if (existing != null) {
                session.setAttribute("msg", "Email already exists!");
                response.sendRedirect("index.jsp");
                return;
            }

            // 🔹 Generate a simple integer ID for compatibility
            int studentId = 1000 + new Random().nextInt(9000);

            // 🔹 Create student document
            Document student = new Document("student_id", studentId)
                    .append("student_name", student_name)
                    .append("student_mail", mail_id)
                    .append("college_name", college_name)
                    .append("department", department)
                    .append("degree", degree)
                    .append("register_id", register_id)
                    .append("address", address)
                    .append("gender", gender)
                    .append("age", age)
                    .append("password", password)
                    .append("mobile", ph_no)
                    .append("Admin_Approve", "NOT APPROVED");

            if (imageData != null) {
                student.append("image", new Binary(imageData));
            }

            // 🔹 Insert student
            collection.insertOne(student);

            // 🔹 Success message
            session.setAttribute("msg", "Successfully Register");
            session.setAttribute("msg1", "Your User Identification Number: " + studentId);
            session.setAttribute("student_name", student_name);
            session.setAttribute("student_mail", mail_id);

            response.sendRedirect("Student_Register.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error: " + e.getMessage());
            response.sendRedirect("index.jsp");
        }
    }
}
