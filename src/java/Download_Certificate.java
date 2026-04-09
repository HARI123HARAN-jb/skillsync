import Database.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import org.bson.Document;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.awt.*;
import java.awt.geom.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;

@WebServlet("/Download_Certificate")
public class Download_Certificate extends HttpServlet {

    private static final int W = 1400;
    private static final int H = 990;

    private static final Color BG_OUTER   = new Color(15,  118, 110);
    private static final Color BG_INNER   = new Color(255, 255, 254);
    private static final Color GOLD       = new Color(180, 140, 30);
    private static final Color GOLD_LIGHT = new Color(212, 175, 55);
    private static final Color TEAL       = new Color(13,  148, 136);
    private static final Color TEAL_DARK  = new Color(15,  118, 110);
    private static final Color TEAL_PALE  = new Color(240, 253, 251);
    private static final Color TEXT_DARK  = new Color(26,  26,  26);
    private static final Color TEXT_MUTED = new Color(120, 113, 108);
    private static final Color SIG_INK    = new Color(30,  60,  100);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentIdStr = request.getParameter("student_id");
        String courseIdStr  = request.getParameter("course_id");

        if (studentIdStr == null || courseIdStr == null || studentIdStr.isEmpty() || courseIdStr.isEmpty()) {
            sendErrorPage(response, "Invalid Access", "Missing parameters.");
            return;
        }

        try {
            int studentId = Integer.parseInt(studentIdStr);
            int courseId  = Integer.parseInt(courseIdStr);

            // 🍃 MongoDB Connection
            MongoDatabase database = MongoConnection.getDatabase();
            if (database == null) {
                sendErrorPage(response, "Database Error", "Connection failed.");
                return;
            }

            MongoCollection<Document> enrollmentsView = database.getCollection("enrollments");
            MongoCollection<Document> studentsView = database.getCollection("students");
            MongoCollection<Document> coursesView = database.getCollection("courses");
            MongoCollection<Document> teachersView = database.getCollection("teachers");

            // 1. Check Enrollment
            Document enrollment = enrollmentsView.find(and(eq("student_id", studentId), eq("course_id", courseId))).first();
            if (enrollment == null || !"completed".equalsIgnoreCase(enrollment.getString("course_status"))) {
                sendErrorPage(response, "Not Eligible", "Course not completed yet.");
                return;
            }

            // 2. Fetch Student Info
            Document student = studentsView.find(eq("student_id", studentId)).first();
            if (student == null) {
                sendErrorPage(response, "Error", "Student record not found.");
                return;
            }

            // 3. Fetch Course Info
            Document course = coursesView.find(eq("course_id", courseId)).first();
            if (course == null) {
                sendErrorPage(response, "Error", "Course record not found.");
                return;
            }

            // 4. Fetch Teacher Info (optional)
            String teacherId = course.get("teacher_id").toString();
            Document teacher = teachersView.find(eq("teacher_id", Integer.parseInt(teacherId))).first();

            String studentName = student.getString("student_name");
            String courseName  = course.getString("course_name");
            String teacherName = (teacher != null) ? teacher.getString("teacher_name") : "SkillSync Director";
            Date issueDate = enrollment.getDate("enrolled_at"); // or completion date

            // Generate image
            BufferedImage cert = generateCertificate(studentName, courseName, teacherName, studentIdStr, courseIdStr, issueDate);

            // Stream download
            String filename = "SkillSync_Certificate_" + studentName.replace(" ", "_") + ".png";
            response.setContentType("image/png");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
            ImageIO.write(cert, "png", response.getOutputStream());

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorPage(response, "Server Error", e.getMessage());
        }
    }

    private BufferedImage generateCertificate(String studentName, String courseName, String teacherName, String studentId, String courseId, Date issueDate) {
        BufferedImage img = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = img.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_LCD_HRGB);

        g.setColor(BG_OUTER);
        g.fillRect(0, 0, W, H);

        int margin = 48;
        g.setColor(BG_INNER);
        g.fillRoundRect(margin, margin, W - margin * 2, H - margin * 2, 24, 24);

        g.setColor(TEAL);
        g.setFont(new Font("Serif", Font.BOLD | Font.ITALIC, 48));
        String brand = "SkillSync";
        g.drawString(brand, (W - g.getFontMetrics().stringWidth(brand)) / 2, margin + 80);

        g.setColor(TEXT_MUTED);
        g.setFont(new Font("SansSerif", Font.PLAIN, 20));
        String certTitle = "CERTIFICATE OF COMPLETION";
        g.drawString(certTitle, (W - g.getFontMetrics().stringWidth(certTitle)) / 2, margin + 120);

        g.setColor(TEXT_DARK);
        g.setFont(new Font("Serif", Font.BOLD, 72));
        g.drawString(studentName, (W - g.getFontMetrics().stringWidth(studentName)) / 2, H / 2 - 40);

        g.setColor(TEXT_MUTED);
        g.setFont(new Font("SansSerif", Font.PLAIN, 24));
        String text1 = "has successfully completed the course";
        g.drawString(text1, (W - g.getFontMetrics().stringWidth(text1)) / 2, H / 2 + 20);

        g.setColor(TEAL_DARK);
        g.setFont(new Font("Serif", Font.BOLD, 52));
        g.drawString(courseName, (W - g.getFontMetrics().stringWidth(courseName)) / 2, H / 2 + 100);

        g.setColor(TEXT_MUTED);
        g.setFont(new Font("SansSerif", Font.PLAIN, 18));
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMMM yyyy");
        String dateStr = java.time.Instant.ofEpochMilli(issueDate.getTime()).atZone(java.time.ZoneId.systemDefault()).toLocalDate().format(dtf);
        g.drawString("Issued on: " + dateStr, (W - g.getFontMetrics().stringWidth("Issued on: " + dateStr)) / 2, H - margin - 100);

        g.drawString("Instructor: " + teacherName, (W - g.getFontMetrics().stringWidth("Instructor: " + teacherName)) / 2, H - margin - 60);

        g.dispose();
        return img;
    }

    private void sendErrorPage(HttpServletResponse response, String title, String message) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body><h2>" + title + "</h2><p>" + message + "</p><a href='javascript:history.back()'>Back</a></body></html>");
    }
}
