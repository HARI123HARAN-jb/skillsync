<%-- 
    Document   : Request4
    Created on : 20-Sep-2025, 16:03:34
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
            String U_Id=request.getParameter("teacher_id");
            DbConnection db1=new DbConnection();
            String query="update student_learning.teacher_register set Admin_Approve='REJECTED' where teacher_id='"+U_Id+"'";
            int i=db1.update(query);
            if(i>0)
            {
                session.setAttribute("msg", "Teacher Rejected Sucessfully");
                response.sendRedirect("Send_Mail1?teacher_id=" + U_Id);
            }
        %>

</body>
</html>
