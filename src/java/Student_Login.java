import Database.DbConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
            DbConnection db = new DbConnection();
            java.sql.Connection connection = db.getConnection();
            
            if (connection == null) {
                session.setAttribute("msg", "Database Connection Failed! Please check your Render Environment Variables.");
                response.sendRedirect("index.jsp");
                return;
            }
            String email = request.getParameter("mail_id");
            String password = request.getParameter("password");

           
            String query = "SELECT * FROM student_register WHERE student_mail=? AND password=?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String adminStatus = rs.getString("Admin_Approve");

                if ("NOT APPROVED".equalsIgnoreCase(adminStatus)) {
                    session.setAttribute("msg", "Your account is pending approval. Wait for admin approval.");
                    response.sendRedirect("index.jsp");

                } else if ("REJECTED".equalsIgnoreCase(adminStatus)) {
                    session.setAttribute("msg", "Your account has been rejected.");
                    response.sendRedirect("index.jsp");

                } else if ("APPROVED".equalsIgnoreCase(adminStatus)) {
                    int id = rs.getInt("student_id");
                    session.setAttribute("msg", "Successfully Logged In!");
                    session.setAttribute("student_id", id);
                    session.setAttribute("student_mail", email);
                    response.sendRedirect("Student_View_Course.jsp");

                } else {
                    session.setAttribute("msg", "Invalid account status.");
                    response.sendRedirect("index.jsp");
                }

            } else {
                // No matching record
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
