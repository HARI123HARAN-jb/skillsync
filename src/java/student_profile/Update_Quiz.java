/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package student_profile;

import Connection.DbConnection;
import java.io.*;

import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Update_Quiz")
public class Update_Quiz extends HttpServlet {
@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
HttpSession session = request.getSession(true);
        String courseId = request.getParameter("course_id");
        String status = request.getParameter("status");
        try {
            DbConnection db = new DbConnection();
            Connection conn = db.getConnection();

            int count = Integer.parseInt(request.getParameter("count"));

            for(int i = 1; i <= count; i++){

                String qid = request.getParameter("question_id_" + i);
                String question = request.getParameter("question" + i);
                String a = request.getParameter("option" + i + "_a");
                String b = request.getParameter("option" + i + "_b");
                String c = request.getParameter("option" + i + "_c");
                String d = request.getParameter("option" + i + "_d");
                String ans = request.getParameter("answer" + i);

                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE topic_quiz SET question=?, option_a=?, option_b=?, option_c=?, option_d=?, correct_answer=? WHERE question_id=? and status=?"
                );

                ps.setString(1, question);
                ps.setString(2, a);
                ps.setString(3, b);
                ps.setString(4, c);
                ps.setString(5, d);
                ps.setString(6, ans);
                ps.setString(7, qid);
                ps.setString(8,status);
                ps.executeUpdate();
                ps.close();
            }
            session.setAttribute("msg", "✅ Quiz updated successfully!");
            response.sendRedirect("Teacher_Add_Quiz_Type.jsp?course_id="+courseId);

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}
