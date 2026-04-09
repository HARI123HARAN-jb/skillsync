<%-- 
    Document   : Request5
    Created on : 23-Sep-2025, 16:48:23
    Author     : user
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DbConnection"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Student Learning</title>

</head>
<body>

     <% String msg=(String)session.getAttribute("msg");
    if(msg!=null){
    %>
    <script> alert("<%=msg %>"); </script>
    <% } session.removeAttribute("msg");  %>

    
    
        <%
    String U_Id = request.getParameter("course_id");
    DbConnection db1 = new DbConnection();
    String query = "DELETE FROM courses WHERE course_id='" + U_Id + "'";
    int i = db1.update(query);

    if (i > 0) {
        session.setAttribute("msg", "Course Deleted Successfully");
        response.sendRedirect("View_Course.jsp");
    } else {
        session.setAttribute("msg", "Error! Course not deleted.");
        response.sendRedirect("View_Course.jsp");
    }
%>


</body>
</html>

