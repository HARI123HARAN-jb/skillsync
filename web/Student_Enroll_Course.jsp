<%-- 
    Document   : Student_Enroll_Course
    Created on : 24-Sep-2025, 11:36:56
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
 <%@ page import="java.sql.*,java.io.*" %>
<%@ page import="Connection.DbConnection" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
<%
    int studentId = Integer.parseInt(request.getParameter("student_id"));
    String courseId = request.getParameter("course_id");
    String courseName = request.getParameter("course_name");
    String teacher_id = request.getParameter("teacher_id");
    DbConnection db = new DbConnection();

    // Check if already enrolled
    ResultSet rs = db.Select("SELECT * FROM student_courses WHERE student_id='"+studentId+"' AND course_id='"+courseId+"' and teacher_id='"+ teacher_id+"'");
    if(!rs.next()){
        db.update("INSERT INTO student_courses(student_id, course_id, course_status,teacher_id) VALUES('"+studentId+"','"+courseId+"','pending','"+teacher_id+"')");
    }
    if(rs != null) rs.close();
    if(db != null) db.close();

    // Redirect to topics page
    session.setAttribute("msg", "Enroll Successfully");
    response.sendRedirect("Student_Topics.jsp?course_name="+courseName+"&course_id="+courseId);
%>

    </body>
</html>
