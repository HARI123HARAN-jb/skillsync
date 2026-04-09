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
import java.io.InputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

@WebServlet("/Update_Topic")
@MultipartConfig(maxFileSize = 1024 * 1024 * 50)
public class Update_Topic extends HttpServlet {
@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

       
        String courseId = request.getParameter("course_id");
        String[] topicIds = request.getParameterValues("topic_id[]");
        String[] titles = request.getParameterValues("topic_title[]");

        try {
            DbConnection db = new DbConnection();
            Connection conn = db.getConnection();

            for (int i = 0; i < topicIds.length; i++) {

    String topic_id = topicIds[i];
    String topic = titles[i];

    Part filePart = request.getPart("image_" + i);

    InputStream inputStream = null;

    if (filePart != null && filePart.getSize() > 0) {
        inputStream = filePart.getInputStream();
    }

    String sql;

    if (inputStream != null) {
        sql = "UPDATE topics SET topic_title=?, image=? WHERE topic_id=?";
        PreparedStatement ps = conn.prepareStatement(sql);

        ps.setString(1, topic);
        ps.setBlob(2, inputStream);
        ps.setString(3, topic_id);

        ps.executeUpdate();
        ps.close();

    } else {
        sql = "UPDATE topics SET topic_title=? WHERE topic_id=?";
        PreparedStatement ps = conn.prepareStatement(sql);

        ps.setString(1, topic);
        ps.setString(2, topic_id);

        ps.executeUpdate();
        ps.close();
    }
}
            session.setAttribute("msg", "✅ Module updated successfully!");
            response.sendRedirect("Edit_Topic.jsp?course_id="+courseId);

            conn.close();
            db.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
