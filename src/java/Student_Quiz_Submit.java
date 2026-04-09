
import Connection.DbConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


//@WebServlet("/Student_Quiz_Submit")
//public class Student_Quiz_Submit extends HttpServlet {
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String studentId = request.getParameter("student_id");
//        String courseId = request.getParameter("course_id");
//        String[] quizIds = request.getParameterValues("question_id");
//        String quizLevel = request.getParameter("quiz_level");
//
//        if (quizIds == null || quizIds.length == 0) {
//            response.getWriter().println("Missing parameter: question_id");
//            return;
//        }
//
//        int score = 0;
//
//        try {
//            DbConnection db = new DbConnection();
//            Connection conn = db.getConnection();
//
//            // --- Calculate Score ---
//            for (String qid : quizIds) {
//                String userAnswer = request.getParameter("answer_" + qid);
//                PreparedStatement ps = conn.prepareStatement(
//                        "SELECT correct_answer FROM topic_quiz WHERE question_id=?");
//                ps.setInt(1, Integer.parseInt(qid));
//                ResultSet rs = ps.executeQuery();
//                if (rs.next() && rs.getString("correct_answer").equalsIgnoreCase(userAnswer)) {
//                    score++;
//                }
//                rs.close();
//                ps.close();
//            }
//
//            // --- Check if previous attempt exists ---
//            PreparedStatement psCheck = conn.prepareStatement(
//                "SELECT attempt_number, status FROM student_quiz_attempts WHERE student_id=? AND course_id=?"
//            );
//            psCheck.setString(1, studentId);
//            psCheck.setString(2, courseId);
//            ResultSet rsCheck = psCheck.executeQuery();
//
//            int newAttempt = 1;
//            if (rsCheck.next()) {
//                newAttempt = rsCheck.getInt("attempt_number") + 1;
//            }
//            rsCheck.close();
//            psCheck.close();
//
//            String resultStatus = (score >= 4) ? "pass" : "fail";
//
//            // --- Insert or Update attempt in the same row ---
//            PreparedStatement psUpsert;
//            if (newAttempt == 1) {
//                psUpsert = conn.prepareStatement(
//                    "INSERT INTO student_quiz_attempts\n" +
//"(student_id, course_id, quiz_level, score, attempt_number, status)\n" +
//"VALUES (?,?,?,?,?,?)"
//                );
//            } else {
//                // overwrite the same row for second attempt
//                psUpsert = conn.prepareStatement(
//                    "UPDATE student_quiz_attempts SET score=?, attempt_number=?, status=? WHERE student_id=? AND course_id=?"
//                );
//                psUpsert.setInt(1, score);
//                psUpsert.setInt(2, newAttempt);
//                psUpsert.setString(3, resultStatus);
//                psUpsert.setString(4, studentId);
//                psUpsert.setString(5, courseId);
//                psUpsert.executeUpdate();
//                psUpsert.close();
//            }
//
//            if (newAttempt == 1) {
//                psUpsert.setString(1, studentId);
//                psUpsert.setString(2, courseId);
//                psUpsert.setInt(3, score);
//                psUpsert.setInt(4, newAttempt);
//                psUpsert.setString(5, resultStatus);
//                psUpsert.executeUpdate();
//                psUpsert.close();
//            }
//
//            // --- Handle result ---
//            if ("pass".equals(resultStatus)) {
//                // Mark course as completed
//                PreparedStatement psUpdate = conn.prepareStatement(
//                    "UPDATE student_courses SET course_status='completed' WHERE student_id=? AND course_id=?"
//                );
//                psUpdate.setString(1, studentId);
//                psUpdate.setString(2, courseId);
//                psUpdate.executeUpdate();
//                psUpdate.close();
//
//                response.sendRedirect("Student_View_Course.jsp?msg=PASS&score=" + score);
//
//            } if ("NORMAL".equalsIgnoreCase(quizLevel)) {
//
//    if ("pass".equals(resultStatus)) {
//        // Redirect to HARD quiz
//        response.sendRedirect(
//            "Student_Start_Quiz.jsp?course_id=" + courseId + "&level=HARD"
//        );
//        return;
//
//    } else {
//        // Redirect to EASY quiz
//        response.sendRedirect(
//            "Student_Start_Quiz.jsp?course_id=" + courseId + "&level=EASY"
//        );
//        return;
//    }
//}
//else if (newAttempt < 2) {
//                // First fail → allow second attempt
//                response.sendRedirect("Student_Start_Quiz.jsp?course_id=" + courseId + "&msg=FAIL_FIRST&score=" + score);
//
//            } else {
//                // Second fail → reset topics/modules
//                conn.createStatement().executeUpdate(
//                    "UPDATE student_topics SET status='pending' WHERE student_id='" + studentId+"' AND course_id='" + courseId+"'");
//                conn.createStatement().executeUpdate(
//                    "UPDATE student_modules SET video_status='pending',notes_status='pending',status='pending' WHERE student_id='" + studentId+"' AND course_id='" + courseId+"'");
//
//                conn.createStatement().executeUpdate(
//                    "UPDATE student_courses SET course_status='pending' WHERE student_id='" + studentId +
//                    "' AND course_id='" + courseId+"'");
//
//                response.sendRedirect("Student_View_Course.jsp?msg=FAIL_RESET&score=" + score);
//            }
//if ("EASY".equalsIgnoreCase(quizLevel) || "HARD".equalsIgnoreCase(quizLevel)) {
//
//    PreparedStatement psUpdate = conn.prepareStatement(
//        "UPDATE student_courses SET course_status='completed' " +
//        "WHERE student_id=? AND course_id=?"
//    );
//    psUpdate.setString(1, studentId);
//    psUpdate.setString(2, courseId);
//    psUpdate.executeUpdate();
//    psUpdate.close();
//
//    response.sendRedirect(
//        "Student_View_Course.jsp?msg=COURSE_COMPLETED&score=" + score
//    );
//}
//
//            conn.close();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.getWriter().println("Error: " + e.getMessage());
//        }
//    }
//}
//@WebServlet("/Student_Quiz_Submit")
//public class Student_Quiz_Submit extends HttpServlet {
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//HttpSession session = request.getSession();
//        String studentId = request.getParameter("student_id");
//        String courseId = request.getParameter("course_id");
//        String quizLevel = request.getParameter("quiz_level");
//        String[] quizIds = request.getParameterValues("question_id");
//
//        int score = 0;
//
//        try {
//            DbConnection db = new DbConnection();
//            Connection conn = db.getConnection();
//
//            
//            for (String qid : quizIds) {
//                String userAnswer = request.getParameter("answer_" + qid);
//
//                PreparedStatement ps = conn.prepareStatement(
//                    "SELECT correct_answer FROM topic_quiz WHERE question_id=?"
//                );
//                ps.setInt(1, Integer.parseInt(qid));
//                ResultSet rs = ps.executeQuery();
//
//                if (rs.next() && rs.getString("correct_answer")
//                        .equalsIgnoreCase(userAnswer)) {
//                    score++;
//                }
//                rs.close();
//                ps.close();
//            }
//
//            String resultStatus = (score >= 4) ? "pass" : "fail";
//
//            
//            PreparedStatement psInsert = conn.prepareStatement(
//                "INSERT INTO student_quiz_attempts " +
//                "(student_id, course_id, quiz_level, score, status) " +
//                "VALUES (?,?,?,?,?)"
//            );
//            psInsert.setString(1, studentId);
//            psInsert.setString(2, courseId);
//            psInsert.setString(3, quizLevel);
//            psInsert.setInt(4, score);
//            psInsert.setString(5, resultStatus);
//            psInsert.executeUpdate();
//            psInsert.close();
//
//            
//            if ("NORMAL".equalsIgnoreCase(quizLevel)) {
//
//                if ("pass".equals(resultStatus)) {
//                    session.setAttribute("msg", "🎉 Level 1 passed! Proceeding to next level.");
//                    response.sendRedirect(
//                        "Student_Start_Quiz.jsp?course_id=" + courseId + "&level=HARD"
//                    );
//                } else {
//                    session.setAttribute("msg", "❌ Level 1 failed. Please try again.");
//                    response.sendRedirect(
//                        "Student_Start_Quiz.jsp?course_id=" + courseId + "&level=EASY"
//                    );
//                }
//                return;
//            }
//
//           
//if ("EASY".equalsIgnoreCase(quizLevel) ||
//    "HARD".equalsIgnoreCase(quizLevel)) {
//
//    if ("pass".equalsIgnoreCase(resultStatus)) {
//
//        // ✅ PASS → complete course
//        PreparedStatement psUpdate = conn.prepareStatement(
//            "UPDATE student_courses SET course_status='completed' " +
//            "WHERE student_id=? AND course_id=?"
//        );
//        psUpdate.setString(1, studentId);
//        psUpdate.setString(2, courseId);
//        psUpdate.executeUpdate();
//        psUpdate.close();
//session.setAttribute("msg", "✅ Congratulations! You have completed the course.");
//        response.sendRedirect(
//            "Student_View_Course.jsp?msg=COURSE_COMPLETED&score=" + score
//        );
//
//    } else {
//
//        // ❌ FAIL → restart course (reset everything)
//        conn.createStatement().executeUpdate(
//            "UPDATE student_topics SET status='pending' " +
//            "WHERE student_id='" + studentId + "' AND course_id='" + courseId + "'"
//        );
//
//        conn.createStatement().executeUpdate(
//            "UPDATE student_modules SET video_status='pending', " +
//            "notes_status='pending', status='pending' " +
//            "WHERE student_id='" + studentId + "' AND course_id='" + courseId + "'"
//        );
//
//        conn.createStatement().executeUpdate(
//            "UPDATE student_courses SET course_status='pending' " +
//            "WHERE student_id='" + studentId + "' AND course_id='" + courseId + "'"
//        );
//session.setAttribute("msg", "❌ You failed the final level. Course restarted.");
//        response.sendRedirect(
//            "Student_View_Course.jsp?msg=FAIL_RESET&score=" + score
//        );
//    }
//    return;
//}
//
//
//            conn.close();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.getWriter().println("Error: " + e.getMessage());
//        }
//    }
//}

@WebServlet("/Student_Quiz_Submit")
public class Student_Quiz_Submit extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String studentId = request.getParameter("student_id");
        String courseId = request.getParameter("course_id");
        String quizLevel = request.getParameter("quiz_level");
        String[] quizIds = request.getParameterValues("question_id");

        if (quizIds == null || quizIds.length == 0) {
            response.getWriter().println("Missing parameter: question_id");
            return;
        }

        int score = 0;

        try {
                DbConnection db = new DbConnection(); 
                Connection conn = db.getConnection();

            // --- 1️⃣ Calculate Score ---
            for (String qid : quizIds) {
                String userAnswer = request.getParameter("answer_" + qid);
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT correct_answer FROM topic_quiz WHERE question_id=?")) {
                    ps.setInt(1, Integer.parseInt(qid));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getString("correct_answer").equalsIgnoreCase(userAnswer)) {
                            score++;
                        }
                    }
                }
            }

            String resultStatus = (score >= 4) ? "pass" : "fail";

            // --- 2️⃣ Get previous attempt count ---
            int attempts = 0;
            try (PreparedStatement psCheck = conn.prepareStatement(
                    "SELECT COUNT(*) AS attempts FROM student_quiz_attempts WHERE student_id=? AND course_id=? AND quiz_level=?"
            )) {
                psCheck.setString(1, studentId);
                psCheck.setString(2, courseId);
                psCheck.setString(3, quizLevel);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        attempts = rs.getInt("attempts");
                    }
                }
            }

            attempts++; // current attempt

            // --- 3️⃣ Store current attempt ---
            try (PreparedStatement psInsert = conn.prepareStatement(
                    "INSERT INTO student_quiz_attempts (student_id, course_id, quiz_level, score, attempt_number, status) " +
                    "VALUES (?,?,?,?,?,?)")) {
                psInsert.setString(1, studentId);
                psInsert.setString(2, courseId);
                psInsert.setString(3, quizLevel);
                psInsert.setInt(4, score);
                psInsert.setInt(5, attempts);
                psInsert.setString(6, resultStatus);
                psInsert.executeUpdate();
            }

            // --- 4️⃣ Handle NORMAL level ---
            if ("NORMAL".equalsIgnoreCase(quizLevel)) {
                if ("pass".equals(resultStatus)) {
                    session.setAttribute("msg", "🎉 Level 1 passed! Proceeding to next level.");
                    response.sendRedirect("Student_Start_Quiz.jsp?course_id=" + courseId + "&level=HARD");
                } else {
                    session.setAttribute("msg", "❌ Level 1 failed. Please try again.");
                    response.sendRedirect("Student_Start_Quiz.jsp?course_id=" + courseId + "&level=EASY");
                }
                return;
            }

            // --- 5️⃣ Handle EASY/HARD levels ---
            if ("EASY".equalsIgnoreCase(quizLevel) || "HARD".equalsIgnoreCase(quizLevel)) {

                if ("pass".equalsIgnoreCase(resultStatus)) {
                    int points = 0;
                   if(score == 5){
                   points = 10;
                   }else if(score == 4){
                   points = 9;
                   }else{
                   points = 0;
                   }
                    // ✅ PASS → complete course
                    try (PreparedStatement psUpdate = conn.prepareStatement(
                            "UPDATE student_courses SET course_status='completed', points=?,date=NOW() WHERE student_id=? AND course_id=?"
                    )) {
                        psUpdate.setInt(1, points);
                        psUpdate.setString(2, studentId);
                        psUpdate.setString(3, courseId);
                        psUpdate.executeUpdate();
                    }
                    session.setAttribute("msg", "✅ Congratulations! You have completed the course.");
                    response.sendRedirect("Student_View_Course.jsp?msg=COURSE_COMPLETED&score=" + score);
                } else {
                    if (attempts < 2) {
                        // ❌ FAIL → allow second attempt
                        session.setAttribute("msg", "⚠️ Attempt " + attempts + " failed. Try again.");
                        response.sendRedirect("Student_Start_Quiz.jsp?course_id=" + courseId + "&level=" + quizLevel + "&score=" + score);
                    } else {
                        // ❌ FAIL → reset course after 2 attempts
                        conn.createStatement().executeUpdate(
                                "UPDATE student_topics SET status='pending' WHERE student_id='" + studentId + "' AND course_id='" + courseId + "'"
                        );
                        conn.createStatement().executeUpdate(
                                "UPDATE student_modules SET video_status='pending', notes_status='pending', status='pending' " +
                                        "WHERE student_id='" + studentId + "' AND course_id='" + courseId + "'"
                        );
                        conn.createStatement().executeUpdate(
                                "UPDATE student_courses SET course_status='pending' WHERE student_id='" + studentId + "' AND course_id='" + courseId + "'"
                        );

                        session.setAttribute("msg", "❌ You failed the final level. Course restarted.");
                        response.sendRedirect("Student_View_Course.jsp?msg=FAIL_RESET&score=" + score);
                    }
                }
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
