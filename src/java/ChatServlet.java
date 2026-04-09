/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author user
 */
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.json.JSONObject;
@WebServlet(urlPatterns = {"/ChatServlet"})
public class ChatServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

      String userMsg = request.getParameter("message");

        String botReply = ChatBotService.getReply(userMsg, getServletContext());

       
request.setCharacterEncoding("UTF-8");   
    response.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");
        JSONObject json = new JSONObject();
        json.put("reply", botReply);

        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();

    }
}
