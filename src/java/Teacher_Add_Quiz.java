import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.push;
import org.bson.Document;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
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

        String course_id_str = request.getParameter("course_id");
        String teacher_id = request.getParameter("teacher_id");
        String quiz_type = request.getParameter("quiz_type");

        if (course_id_str == null || course_id_str.isEmpty()) {
            response.getWriter().println("ERROR: course_id missing");
            return;
        }
        
        int course_id = Integer.parseInt(course_id_str);
        
        if (quiz_type == null || quiz_type.isEmpty()) {
            quiz_type = "NORMAL";
        }

        try {
            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                response.getWriter().println("ERROR: Database Connection Failed!");
                return;
            }

            MongoCollection<Document> collection = database.getCollection("courses");
            List<Document> quizList = new ArrayList<>();

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

                int quizId = 7000 + new Random().nextInt(2000);

                Document quizItem = new Document("quiz_id", quizId)
                        .append("question", q.trim())
                        .append("option_a", a.trim())
                        .append("option_b", b.trim())
                        .append("option_c", c.trim())
                        .append("option_d", d.trim())
                        .append("correct_answer", ans.trim())
                        .append("teacher_id", teacher_id)
                        .append("status", quiz_type);
                
                quizList.add(quizItem);
            }

            if (!quizList.isEmpty()) {
                // 🔹 Nesting: Add the list of quizzes to the 'quizzes' array of the course
                for(Document quiz : quizList) {
                    collection.updateOne(eq("course_id", course_id), push("quizzes", quiz));
                }
            }

            response.sendRedirect("select_course_quiz.jsp?msg=Quiz Added Successfully");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
