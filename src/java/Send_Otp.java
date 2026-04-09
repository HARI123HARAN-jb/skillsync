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
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Send_Otp")
public class Send_Otp extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("mail_id");

        if (email == null || email.isEmpty()) {
            throw new ServletException("Email parameter is missing or empty.");
        }

        // Generate 6-digit OTP
        int otp = (int)(Math.random() * 900000) + 100000;

        // Store OTP and email in session
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("mail_id", email);

        // Send OTP to email
        sendEmail(email, otp);

        // Redirect back to login page or to an OTP verification page
        response.sendRedirect("Forgot_Password.jsp");
    }

    private void sendEmail(String recipient, int otp) throws ServletException {
        String host = "smtp.gmail.com"; // Or your SMTP host
        final String from = "javatrios07@gmail.com"; // Replace with your email
        final String password = "ncwbjzphrjztfupn"; // Replace with your email password

        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session mailSession = Session.getInstance(properties, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
           message.setSubject("Your OTP Code");

String msgContent =
"<html>" +
"<head>" +
"<style>" +
"body{font-family:Arial,sans-serif;background:#f4f6f9;margin:0;padding:0;}" +
".container{max-width:500px;margin:40px auto;background:#ffffff;border-radius:8px;" +
"box-shadow:0 2px 10px rgba(0,0,0,0.1);overflow:hidden;text-align:center;}" +
".header{background:#007bff;color:#ffffff;padding:18px;font-size:20px;font-weight:bold;}" +
".content{padding:25px;color:#333;font-size:15px;line-height:1.6;}" +
".otp-box{font-size:28px;font-weight:bold;color:#007bff;background:#f1f5ff;" +
"padding:12px 20px;border-radius:6px;display:inline-block;margin:15px 0;letter-spacing:3px;}" +
".note{font-size:13px;color:#777;margin-top:10px;}" +
".footer{background:#f1f1f1;text-align:center;padding:10px;font-size:12px;color:#777;}" +
"</style>" +
"</head>" +

"<body>" +
"<div class='container'>" +

"<div class='header'>OTP Verification</div>" +

"<div class='content'>" +

"<p>Your One-Time Password (OTP) for verification is:</p>" +

"<div class='otp-box'>" + otp + "</div>" +

"<p>Please enter this OTP to continue. This code is valid for a short time.</p>" +

"<p class='note'>Do not share this OTP with anyone for security reasons.</p>" +

"</div>" +
"</div>" +
"</body>" +
"</html>";

message.setContent(msgContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("OTP sent successfully.");
             System.out.println("Your OTP is: " + otp);
        } catch (MessagingException mex) {
            System.err.println("Failed to send OTP. Error: " + mex.getMessage());
            throw new ServletException("Error sending OTP email.", mex);
        }
    }
}

