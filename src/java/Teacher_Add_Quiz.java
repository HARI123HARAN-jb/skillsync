import Connection.DbConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Teacher_Add_Quiz")
public class Teacher_Add_Quiz extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String course_id = request.getParameter("course_id");
        String teacher_id = request.getParameter("teacher_id");
        String quiz_type = request.getParameter("quiz_type");

        if (course_id == null || course_id.isEmpty()) {
            response.getWriter().println("ERROR: course_id missing");
            return;
        }
if (quiz_type == null || quiz_type.isEmpty()) {
    quiz_type = "NORMAL";
}

        try {
            DbConnection db = new DbConnection();
            Connection conn = db.getConnection();

            for (int i = 1; i <= 5; i++) {
                String q = request.getParameter("question" + i);
                String a = request.getParameter("option" + i + "_a");
                String b = request.getParameter("option" + i + "_b");
                String c = request.getParameter("option" + i + "_c");
                String d = request.getParameter("option" + i + "_d");
                String ans = request.getParameter("answer" + i);

                if (q == null || ans == null || q.trim().isEmpty() || ans.trim().isEmpty()) {
                    continue; // skip empty
                }

                String insertSQL = "INSERT INTO topic_quiz \n" +
"(question, option_a, option_b, option_c, option_d, correct_answer, course_id, teacher_id, status)\n" +
"VALUES (?,?,?,?,?,?,?,?,?)";

                PreparedStatement ps = conn.prepareStatement(insertSQL);
                ps.setString(1, q.trim());
                ps.setString(2, a.trim());
                ps.setString(3, b.trim());
                ps.setString(4, c.trim());
                ps.setString(5, d.trim());
                ps.setString(6, ans.trim());
                ps.setString(7, course_id);
                ps.setString(8, teacher_id);
                ps.setString(9, quiz_type);
                ps.executeUpdate();
                ps.close();
            }

            conn.close();
            response.sendRedirect("select_course_quiz.jsp?msg=Quiz Added Successfully");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
