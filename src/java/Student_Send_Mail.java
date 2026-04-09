/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author user
 */
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.*;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Student_Send_Mail")
public class Student_Send_Mail extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentId = request.getParameter("student_id");
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Connect to database
            conn = new Database.DbConnection().getConnection();

            // Fetch teacher details
            String sql = "SELECT student_name, student_mail FROM student_register WHERE student_id = ? and Admin_Approve='APPROVED'";
            ps = conn.prepareStatement(sql);
            ps.setString(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                String studentName = rs.getString("student_name");
                String studentEmail = rs.getString("student_mail");
                
                // Send approval email
                sendApprovalEmail(studentEmail, studentName);

                request.getSession().setAttribute("msg", "Approval email sent successfully to student.");
            } else {
                request.getSession().setAttribute("msg", "Student not found in database.");
            }

            response.sendRedirect("Student_Approve.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", "Error sending email: " + e.getMessage());
            response.sendRedirect("Student_Approve.jsp");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    private void sendApprovalEmail(String recipient, String studentName) throws MessagingException {
        String host = "smtp.gmail.com";
        final String from = "javatrios07@gmail.com"; // your Gmail
        final String password = "ncwbjzphrjztfupn";   // your app password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        Message message = new MimeMessage(session);
        try {
            message.setFrom(new InternetAddress(from, "E-Learning Admin"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(Student_Send_Mail.class.getName()).log(Level.SEVERE, null, ex);
        }
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
        message.setSubject("Your Account Has Been Approved!");

String msgContent =
"<html>" +
"<head>" +
"<style>" +
"body{font-family:Arial,sans-serif;background:#f4f6f9;margin:0;padding:0;}" +
".container{max-width:600px;margin:30px auto;background:#ffffff;border-radius:8px;" +
"box-shadow:0 2px 8px rgba(0,0,0,0.1);overflow:hidden;}" +
".header{background:#28a745;color:#ffffff;text-align:center;padding:20px;font-size:22px;font-weight:bold;}" +
".content{padding:25px;color:#333;font-size:15px;line-height:1.6;}" +
".name{color:#28a745;font-weight:bold;}" +
".success{background:#eafaf1;border-left:5px solid #28a745;padding:12px;margin:15px 0;border-radius:4px;}" +
".btn{display:inline-block;margin-top:15px;padding:10px 20px;background:#007bff;color:#fff;text-decoration:none;border-radius:5px;font-size:14px;}" +
".footer{background:#f1f1f1;text-align:center;padding:12px;font-size:12px;color:#777;}" +
"</style>" +
"</head>" +

"<body>" +
"<div class='container'>" +

"<div class='header'>Your Account Approved</div>" +

"<div class='content'>" +

"<p>Hello <span class='name'>" + studentName + "</span>,</p>" +

"<div class='success'>" +
"Congratulations! Your account has been successfully approved by the administrator." +
"</div>" +

"<p>You can now log in to the <b>E-Learning Platform</b> and start accessing your courses and learning materials.</p>" +

"<p>We wish you a <b>successful and enjoyable learning journey!</b></p>" +

"<p class='btn'>Login to Platform</p>" +

"<p style='margin-top:20px;'>Best regards,<br><b>E-Learning Admin Team</b></p>" +

"</div>" +
"</div>" +
"</body>" +
"</html>";

message.setContent(msgContent, "text/html; charset=utf-8");
        Transport.send(message);

        System.out.println("Approval email sent to: " + recipient);
    }
}


