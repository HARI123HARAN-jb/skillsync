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

@WebServlet(urlPatterns = {"/Teacher_Login"})
public class Teacher_Login extends HttpServlet {

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

            MongoCollection<Document> collection = database.getCollection("teachers");

            // 🔹 Query teacher collection
            Document teacher = collection.find(and(eq("teacher_mail", email), eq("password", password))).first();

            if (teacher != null) {
                String adminStatus = teacher.getString("Admin_Approve");

                if ("NOT APPROVED".equalsIgnoreCase(adminStatus)) {
                    session.setAttribute("msg", "Your account is pending approval. Wait for admin approval.");
                    response.sendRedirect("index.jsp");

                } else if ("REJECTED".equalsIgnoreCase(adminStatus)) {
                    session.setAttribute("msg", "Your account has been rejected.");
                    response.sendRedirect("index.jsp");

                } else if ("APPROVED".equalsIgnoreCase(adminStatus)) {
                    int id = teacher.getInteger("teacher_id", 0);
                    session.setAttribute("msg", "Successfully Logged In!");
                    session.setAttribute("teacher_id", id);
                    session.setAttribute("teacher_mail", email);
                    response.sendRedirect("Teacher_Home.jsp");

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
