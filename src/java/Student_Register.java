/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/Student_Register"})
@MultipartConfig(maxFileSize = 50 * 1024 * 1024) // 5MB
public class Student_Register extends HttpServlet {
@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // 🔹 Get form fields
            String student_name = request.getParameter("student_name");
            String mail_id = request.getParameter("mail_id");
            String password = request.getParameter("password");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String ph_no = request.getParameter("ph_no");
            String college_name = request.getParameter("college_name");
            String department = request.getParameter("department");
            String degree = request.getParameter("degree");
            String age = request.getParameter("age");
            String register_id = request.getParameter("register_id");

            // 🔹 Get uploaded image
            Part imagePart = request.getPart("image");
            InputStream imageStream = null;

            if (imagePart != null) {
                imageStream = imagePart.getInputStream();
            }

            // 🔹 Database connection
            Connection con = new Connection.DbConnection().getConnection();

            // 🔹 Check duplicate email
            PreparedStatement check = con.prepareStatement(
                    "SELECT * FROM student_register WHERE student_mail=?");
            check.setString(1, mail_id);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {

                session.setAttribute("msg", "Email already exists!");
                response.sendRedirect("index.jsp");
                return;
            }

            // 🔹 Insert student
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO student_register (student_id,student_name,student_mail,college_name,department,degree,register_id,address,gender,age,password,mobile,image,Admin_Approve) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,'NOT APPROVED')");

            ps.setInt(1, 0);
            ps.setString(2, student_name);
            ps.setString(3, mail_id);
            ps.setString(4, college_name);
            ps.setString(5, department);
            ps.setString(6, degree);
            ps.setString(7, register_id);
            ps.setString(8, address);
            ps.setString(9, gender);
            ps.setString(10, age);
            ps.setString(11, password);
            ps.setString(12,ph_no);
            ps.setBlob(13, imageStream);

            ps.executeUpdate();

            // 🔹 Get generated student id
            PreparedStatement getId = con.prepareStatement(
                    "SELECT student_id FROM student_register WHERE student_mail=?");
            getId.setString(1, mail_id);
            ResultSet r = getId.executeQuery();

            int studentId = 0;
            if (r.next()) {
                studentId = r.getInt("student_id");
            }

            // 🔹 Success message
            session.setAttribute("msg", "Successfully Register");
            session.setAttribute("msg1", "Your User Identification Number: " + studentId);
            session.setAttribute("student_name", student_name);
            session.setAttribute("student_mail", mail_id);

            response.sendRedirect("Student_Register.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}