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

@WebServlet(urlPatterns = {"/Admin_Login"})
public class Admin_Login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);
        
        try {
            String userName = request.getParameter("userName");
            String password = request.getParameter("password");

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();

            if (database == null) {
                session.setAttribute("msg", "Database Connection Failed! Please check your MongoDB configuration.");
                response.sendRedirect("index.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("admins");

            // 🔹 Query admin collection
            Document admin = collection.find(and(eq("email", userName), eq("password", password))).first();

            if (admin != null) {
                session.setAttribute("msg", "Successfully Login");
                session.setAttribute("userName", userName);
                session.setAttribute("password", password);
                response.sendRedirect("Admin_Home.jsp");
            } else {
                session.setAttribute("msg", "UserName & password incorrect!...");
                response.sendRedirect("index.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Login Servlet";
    }
}
