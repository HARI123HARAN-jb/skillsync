import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import org.bson.Document;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/Student_Login"})
public class Student_Login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(true);

        try {
            String email = request.getParameter("mail_id");
            String password = request.getParameter("password");

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();

            if (database == null) {
                session.setAttribute("msg", "Database Connection Failed! Please check your MongoDB configuration.");
                response.sendRedirect("index.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("students");

            // 🔹 Query student collection
            Document student = collection.find(and(eq("student_mail", email), eq("password", password))).first();

            if (student != null) {
                String adminStatus = student.getString("Admin_Approve");

                if ("NOT APPROVED".equalsIgnoreCase(adminStatus)) {
                    session.setAttribute("msg", "Your Registration is NOT APPROVED Wait for Admin Approval");
                    response.sendRedirect("index.jsp");

                } else if ("REJECTED".equalsIgnoreCase(adminStatus)) {
                    session.setAttribute("msg", "Your Account is REJECTED");
                    response.sendRedirect("index.jsp");

                } else if ("APPROVED".equalsIgnoreCase(adminStatus)) {
                    int id = student.getInteger("student_id", 0);
                    String name = student.getString("student_name");
                    
                    session.setAttribute("msg", "Successfully Logged In!");
                    session.setAttribute("student_id", id);
                    session.setAttribute("student_name", name);
                    session.setAttribute("student_mail", email);
                    response.sendRedirect("Student_Home.jsp");

                } else {
                    session.setAttribute("msg", "Invalid account status.");
                    response.sendRedirect("index.jsp");
                }

            } else {
                session.setAttribute("msg", "Invalid Email or Password!");
                response.sendRedirect("index.jsp");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.getWriter().println("Error: " + ex.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
