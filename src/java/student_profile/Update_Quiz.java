package student_profile;

import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.UpdateOptions;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.combine;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/Update_Quiz")
public class Update_Quiz extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String courseIdStr = request.getParameter("course_id");
        String quizIdStr = request.getParameter("quiz_id");
        
        String question = request.getParameter("question");
        String a = request.getParameter("option_a");
        String b = request.getParameter("option_b");
        String c = request.getParameter("option_c");
        String d = request.getParameter("option_d");
        String ans = request.getParameter("correct_answer");

        if (courseIdStr == null || quizIdStr == null) {
            response.getWriter().println("ERROR: Missing IDs");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            int quizId = Integer.parseInt(quizIdStr);

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                response.getWriter().println("ERROR: Database Connection Failed!");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("courses");

            // 🔹 Update the specific QUIZ inside the QUIZZES array using Array Filters
            collection.updateOne(eq("course_id", courseId),
                combine(
                    set("quizzes.$[q].question", question),
                    set("quizzes.$[q].option_a", a),
                    set("quizzes.$[q].option_b", b),
                    set("quizzes.$[q].option_c", c),
                    set("quizzes.$[q].option_d", d),
                    set("quizzes.$[q].correct_answer", ans)
                ),
                new UpdateOptions().arrayFilters(Arrays.asList(eq("q.quiz_id", quizId))));

            session.setAttribute("msg", "Quiz Updated successfully!");
            response.sendRedirect("Edit_Quiz.jsp?quiz_id=" + quizId + "&course_id=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
