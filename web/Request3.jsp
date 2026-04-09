<%-- 
    Document   : Request3
    Created on : 20-Sep-2025, 16:03:12
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
    String U_Id = request.getParameter("teacher_id");
    DbConnection db1 = new DbConnection();
    String query = "UPDATE teacher_register SET Admin_Approve='APPROVED' WHERE teacher_id='" + U_Id + "'";
    int i = db1.update(query);

    if (i > 0) {
        session.setAttribute("msg", "Teacher Approved Successfully");
        response.sendRedirect("Send_Mail?teacher_id=" + U_Id);
    }
%>


</body>
</html>

