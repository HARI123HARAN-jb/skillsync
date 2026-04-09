/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import Database.DbConnection;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 *
 * @author admin
 */
@WebServlet(urlPatterns = {"/Teacher_Register"})
public class Teacher_Register extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, FileUploadException, ClassNotFoundException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session=request.getSession(true);
       
        try {
         
            
            String teacher_name="",Mail_ID="",password="",address="",gender="",ph_no="",college_name="",department="",degree="",age="",register_id="";
            
            String saveFile="";
           // String contentType = request.getContentType();
            // Create a factory for disk-based file items
            DiskFileItemFactory factory = new DiskFileItemFactory();

// Set factory constraints
            factory.setSizeThreshold(4012);
//factory.setRepository("c:");

// Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);

// Set overall request size constraint
            //upload.setSizeMax(10024);

// Parse the request
            List items = null;
            try {
               items = upload.parseRequest(request);
            } catch (FileUploadException e) {
                e.printStackTrace();
            }
            byte[] data = null;
            String fileName = null;
// Process the uploaded items
            Iterator iter = items.iterator();
            while (iter.hasNext()) {
                FileItem item = (FileItem) iter.next();

                if (item.isFormField()) {
                    //processFormField(item);

                    String name = item.getFieldName();
                    String value = item.getString();

                    if (name.equalsIgnoreCase("teacher_name")) {
                        teacher_name = value;
                        System.out.println("teacher_name" + teacher_name);
                    } 
                  
                  else  if (name.equalsIgnoreCase("mail_id")) {
                        Mail_ID = value;
                        System.out.println("mail_id" + Mail_ID);
                    }
                  
                  else  if (name.equalsIgnoreCase("password")) {
                        password = value;
                        System.out.println("password" + password);
                    }
                  
                  else  if (name.equalsIgnoreCase("address")) {
                        address = value;
                        System.out.println("address" + address);
                    }
                   else  if (name.equalsIgnoreCase("college_name")) {
                        college_name = value;
                        System.out.println("college_name" + college_name);
                    }
                    else  if (name.equalsIgnoreCase("department")) {
                        department = value;
                        System.out.println("department" + department);
                    }
                    else  if (name.equalsIgnoreCase("degree")) {
                        degree = value;
                        System.out.println("degree" + degree);
                    }
                    else  if (name.equalsIgnoreCase("register_id")) {
                        register_id = value;
                        System.out.println("register_id" + register_id);
                    }
                    else  if (name.equalsIgnoreCase("age")) {
                        age = value;
                        System.out.println("age" + age);
                    }
                     else  if (name.equalsIgnoreCase("gender")) {
                        gender = value;
                        System.out.println("gender" + gender);
                    }
                      else  if (name.equalsIgnoreCase("ph_no")) {
                        ph_no = value;
                        System.out.println("ph_no" + ph_no);
                    }
                       
                    else {
                        System.out.println("ERROR");
                    }
                } else {
                    data = item.get();
                    fileName = item.getName();
                }
            }
            saveFile = fileName;
                    String path1 = request.getSession().getServletContext().getRealPath("/");
              // String patt=path.replace("\\build", "");
               
               String strPath1 = path1+"\\"+saveFile;
            File ff1 = new File(strPath1);
            FileOutputStream fileOut1 = new FileOutputStream(ff1);
            fileOut1.write(data, 0, data.length);
            fileOut1.flush();
            fileOut1.close();
        out.println(saveFile);
 

FileInputStream fis11 = null;
File image1 = null;
//FileInputStream fis11 = null;
File image11 = null;
	Connection con7=null;
	PreparedStatement st7=null;
      
       
PreparedStatement st11=null;

image1 = new File(strPath1);
fis11 = new FileInputStream(image1);
        
       

     con7 = new Database.DbConnection().getConnection();
  
     
String query="Select * from teacher_register where teacher_mail='"+Mail_ID+"'";
System.out.println(query);
            Statement st=con7.createStatement();
ResultSet rs=st.executeQuery(query);

if(rs.next())
{
    
   session.setAttribute("msg","Already exist Please Check Values");
      response.sendRedirect("index.jsp");  
}
else
{
        st7 =con7.prepareStatement("insert into teacher_register values (?,?,?,?,?,?,?,?,?,?,?,?,'NOT APPROVED')");

st7.setInt(1,0);
st7.setString(2,teacher_name);
st7.setString(3,Mail_ID);
st7.setString(4,college_name);
st7.setString(5,department);
st7.setString(6,degree);
st7.setString(7,register_id);
st7.setString(8,address);
st7.setString(9,gender);
st7.setString(10,age);
st7.setString(11,password);
if(fileName != "")
        st7.setBinaryStream(12, (InputStream)fis11, (int)(image1.length()));
else
    st7.setBinaryStream(12, null);

      int i =st7.executeUpdate();
      DbConnection db = new DbConnection();
            int jh = 0;
                String q1 ="Select * from teacher_register where teacher_mail='" + Mail_ID + "' ";
                ResultSet rf = st.executeQuery(q1);
                if (rf.next()) {
                    jh = rf.getInt("teacher_id");
                }
                session.setAttribute("msg1", "Your User Idendification Number Is :\n" + jh);
                session.setAttribute("msg", "Successfully Register");
                session.setAttribute("teacher_name", teacher_name);
                session.setAttribute("teacher_mail", Mail_ID);
                response.sendRedirect("Teacher_Register.jsp");
}   
      
        }
        catch(Exception e)
        {
       out.println(e);
        }
        finally {            
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (FileUploadException ex) {
            Logger.getLogger(Teacher_Register.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Teacher_Register.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Teacher_Register.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (FileUploadException ex) {
            Logger.getLogger(Teacher_Register.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Teacher_Register.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Teacher_Register.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
