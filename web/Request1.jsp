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
    String U_Id = request.getParameter("student_id");
    DbConnection db1 = new DbConnection();
    String query = "UPDATE student_learning.student_register SET Admin_Approve='APPROVED' WHERE student_id='" + U_Id + "'";
    int i = db1.update(query);
    if(i > 0) {
        session.setAttribute("msg", "Student Approved Successfully");
        response.sendRedirect("Student_Send_Mail?student_id=" + U_Id);
    }
%>


</body>
</html>
