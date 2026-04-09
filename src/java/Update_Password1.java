import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Update_Password1")
public class Update_Password1 extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("mail_id");

        if (email == null) {
            response.sendRedirect("Forgot_Password1.jsp");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("msg", "Passwords do not match!");
            response.sendRedirect("New_Password1.jsp");
            return;
        }

        try {
            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                session.setAttribute("msg", "Database Connection Failed!");
                response.sendRedirect("New_Password1.jsp");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("teachers");

            // 🔹 Update teacher password
            long updatedCount = collection.updateOne(eq("teacher_mail", email), set("password", newPassword)).getModifiedCount();

            if (updatedCount > 0) {
                session.setAttribute("msg", "Password updated successfully!");
                response.sendRedirect("index.jsp");
            } else {
                session.setAttribute("msg", "Failed to update password. Teacher record not found.");
                response.sendRedirect("New_Password1.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error: " + e.getMessage());
            response.sendRedirect("New_Password1.jsp");
        }
    }
}
