<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mongodb.client.MongoCollection,com.mongodb.client.MongoDatabase" %>
<%@ page import="static com.mongodb.client.model.Filters.and,static com.mongodb.client.model.Filters.eq" %>
<%@ page import="org.bson.Document" %>
<%@ page import="Database.MongoConnection" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Student Enrollment</title>
    </head>
    <body>
<%
    try {
        int studentId = Integer.parseInt(request.getParameter("student_id"));
        int courseId = Integer.parseInt(request.getParameter("course_id"));
        String courseName = request.getParameter("course_name");
        String teacherId = request.getParameter("teacher_id");

        // 🍃 MongoDB Connection
        MongoDatabase database = MongoConnection.getDatabase();
        if (database == null) {
            out.println("<script>alert('Database connection failed!'); window.history.back();</script>");
            return;
        }

        MongoCollection<Document> enrollments = database.getCollection("enrollments");

        // 🔹 Check if already enrolled
        Document existing = enrollments.find(and(eq("student_id", studentId), eq("course_id", courseId))).first();

        if (existing == null) {
            // 🔹 Create enrollment document (Nesting student progress)
            Document enrollment = new Document("student_id", studentId)
                    .append("course_id", courseId)
                    .append("course_name", courseName)
                    .append("teacher_id", teacherId)
                    .append("course_status", "pending")
                    .append("completed_modules", new java.util.ArrayList<Integer>())
                    .append("enrolled_at", new java.util.Date());
            
            enrollments.insertOne(enrollment);
        }

        session.setAttribute("msg", "Enroll Successfully");
        response.sendRedirect("Student_Topics.jsp?course_name=" + courseName + "&course_id=" + courseId);

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.history.back();</script>");
    }
%>
    </body>
</html>
