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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Check_Otp1")
public class Check_Otp1 extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String enteredOtp = request.getParameter("otp");
        Object storedOtp = session.getAttribute("otp");

        if (storedOtp != null && enteredOtp.equals(storedOtp.toString())) {
            // OTP verified — redirect to new password page
            response.sendRedirect("New_Password1.jsp");
        } else {
            session.setAttribute("msg", "Invalid OTP. Try again!");
            response.sendRedirect("Forgot_Password1.jsp");
        }
    }
}
