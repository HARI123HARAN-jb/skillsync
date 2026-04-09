<%-- 
    Document   : chose_modules
    Created on : 22-Sep-2025, 18:10:01
    Author     : user
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="no-js" lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<title>Student Learning Management Website</title>
	<meta name="description" content="A Student Learning Management Website for online courses, quizzes, mentors, and student-teacher interaction.">

	<link rel="shortcut icon" href="assets/images/favicon.png" type="image/png">
	<link rel="stylesheet" href="assets/css/animate.css">
	<link rel="stylesheet" href="assets/css/LineIcons.2.0.css">
	<link rel="stylesheet" href="assets/css/bootstrap-5.0.5-alpha.min.css">
	<link rel="stylesheet" href="assets/css/style.css">
</head>

<body>
    <style>
        .hero-area {
  position: relative;
  z-index: 1;
  min-height: 100vh; /* Full screen */
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center; /* center text */
  background: url("assets/images/image1.jpg") no-repeat center center/cover;
  animation: fadeInBg 2s ease-in-out;
}

/* Dark overlay for text visibility */
.hero-area::after {
  content: "";
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background: rgba(0, 0, 0, 0.55);
  z-index: -1;
}

.hero-content {
  position: relative;
  z-index: 2;
  color: #fff;
  max-width: 100%; /* prevent text too wide */
}

.hero-content h2 {
  font-size: 58px;
  font-weight: 800;
  line-height: 1.2;
}

.hero-content p {
  font-size: 20px;
  line-height: 32px;
  color: #f1f1f1;
}

.hero-content .main-btn {
  background: #F2A92C;
  padding: 14px 32px;
  border-radius: 50px;
  color: #fff;
  font-weight: 600;
  transition: all 0.3s ease;
}

.hero-content .main-btn:hover {
  background: #d98c00;
  transform: translateY(-3px);
}
h2{
    align-items: center;
}
/* --- Modules List Container --- */
.container-modules {
    width: 90%;
    max-width: 900px;
    margin: 40px auto;
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
}

/* --- Module Card --- */
.module-card {
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 5px 18px rgba(0,0,0,0.1);
    width: 250px;
    padding: 20px;
    text-align: center;
    transition: transform 0.3s, box-shadow 0.3s;
}

.module-card.locked {
    opacity: 0.6;
    cursor: not-allowed;
}

.module-card:hover:not(.locked) {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.15);
}

.module-card a {
    display: block;
    font-weight: 600;
    color: #F2A92C;
    margin-bottom: 10px;
    text-decoration: none;
    font-size: 16px;
}

.module-card a:hover {
    color: #d98c00;
}

/* --- Module Status --- */
.module-status {
    font-size: 14px;
    color: #555;
}

/* --- Locked Tooltip --- */
.locked-tooltip {
    font-size: 13px;
    color: red;
    margin-top: 5px;
} 
.back-link-container {
    text-align: center;
    margin-top: 30px;
}

.back-link {
    display: inline-block;
    background: linear-gradient(90deg, #ff7b00, #ffb347); /* orange gradient */
    color: white;
    text-decoration: none;
    padding: 12px 25px;
    border-radius: 8px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s ease;
    box-shadow: 0 4px 10px rgba(255, 140, 0, 0.3);
}

.back-link:hover {
    background: linear-gradient(90deg, #ffb347, #ff7b00);
    transform: translateY(-3px);
    box-shadow: 0 6px 15px rgba(255, 140, 0, 0.4);
    color: black;
}

.back-link:active {
    transform: scale(0.98);
}
    </style>
	<!--====== PRELOADER ======-->
	<div class="preloader">
		<div class="loader">
			<div class="ytp-spinner">
				<div class="ytp-spinner-container">
					<div class="ytp-spinner-rotator">
						<div class="ytp-spinner-left"><div class="ytp-spinner-circle"></div></div>
						<div class="ytp-spinner-right"><div class="ytp-spinner-circle"></div></div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!--====== HEADER ======-->
	<header class="header_area">
		<div id="header_navbar" class="header_navbar">
			<div class="container">
				<div class="row align-items-center">
					<div class="col-xl-12">
						<nav class="navbar navbar-expand-lg">
							<a class="navbar-brand">
								<span class="title">SkillSync</span>
							</a>
							<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent">
								<span class="toggler-icon"></span>
								<span class="toggler-icon"></span>
								<span class="toggler-icon"></span>
							</button>
							<div class="collapse navbar-collapse sub-menu-bar" id="navbarSupportedContent">
								<ul id="nav" class="navbar-nav ml-auto">
									<li class="nav-item"><a href="Student_Home.jsp">Home</a></li>
                                                                        <li class="nav-item"><a href="Student_View_Course.jsp">View Course</a></li>
									<li class="nav-item"><a href="index.jsp">Logout</a></li>
								</ul>
							</div> 
						</nav>
					</div>
				</div> 
			</div>
		</div>
	</header>
<%
        Integer id = (Integer) session.getAttribute("student_id");
        String name = (String) session.getAttribute("student_mail");

        if (id != null && name != null) {
            try {
                DbConnection db1 = new DbConnection();
                ResultSet rs = db1.Select("SELECT * FROM student_register WHERE student_id='" + id + "' AND student_mail='" + name + "'");
                if (rs.next()) {
                    String student_name = rs.getString("student_name"); 
    %>
	<!--====== HERO ======-->
	<section id="home" class="hero-area bg_cover">
  <div class="container">
    <div class="hero-content">
      <h2 class="wow fadeInUp" data-wow-delay=".2s">
        Welcome to Student Learning Management
      </h2>
      <p class="wow fadeInUp" data-wow-delay=".4s">
        An online platform for students and teachers to connect, learn, and grow.  
        Enroll in courses, complete topics, attempt quizzes, and track your progress.
      </p>
      <div class="hero-btns">
        <a href="#courses" class="main-btn wow fadeInUp" data-wow-delay=".6s">Explore Courses</a>
      </div>
    </div>
  </div>
</section>
        
<%
String topic_id = request.getParameter("topic_id");
String courseName = request.getParameter("course_name");
String course_id = request.getParameter("course_id");
Integer studentId = (Integer) session.getAttribute("student_id");

if(studentId == null){
    response.sendRedirect("index.jsp"); // redirect if not logged in
    return;
}

DbConnection db = new DbConnection();
ResultSet rsModules = null;

try {
    // Get all modules of this topic
    rsModules = db.Select("SELECT * FROM modules WHERE topic_id='" + topic_id + "' ORDER BY modules_id ASC");

    boolean allCompleted = true;
    while(rsModules.next()) {
        String moduleId = rsModules.getString("modules_id");

        // Check student's module status
        ResultSet rsStatus = db.Select("SELECT status FROM student_modules WHERE student_id='"+studentId+"' AND modules_id='"+moduleId+"' AND topic_id='"+topic_id+"'");
        String status = "pending";
        if(rsStatus.next()) {
            status = rsStatus.getString("status");
        }
        if(!"completed".equals(status)) {
            allCompleted = false;
        }

        if(rsStatus != null) try { rsStatus.close(); } catch(Exception e) {}
    }

    // If all modules completed, update topic status
    if(allCompleted){
        db.update("UPDATE student_topics SET status='completed' WHERE student_id='"+studentId+"' AND topic_id='"+topic_id+"'");

        // Redirect to main topic page
        response.sendRedirect("Student_Topics.jsp?course_id="+course_id+"&course_name="+courseName);
        return;
    }else{
         response.sendRedirect("Student_Topics.jsp?course_id="+course_id+"&course_name="+courseName);
        return;
    }

} catch(Exception e){
    out.println("Error: " + e.getMessage());
} finally {
    if(rsModules != null) try { rsModules.close(); } catch(Exception e) {}
    if(db != null) db.close();
}
%>



	<!--====== FOOTER ======-->
	<footer id="footer" class="footer-area pt-70">
		<div class="container">
			<div class="row">
				<div class="col-xl-3 col-lg-3 col-md-6">
					<div class="footer-widget">
						<a href="index.jsp" class="logo d-blok">
							<span class="title">SkillSync</span>
						</a>
						<p>A platform where students and teachers collaborate for better learning outcomes.</p>
					</div>
				</div>
				<div class="col-xl-2 col-lg-2 offset-xl-1 offset-lg-1 col-md-6">
					<div class="footer-widget">
						<h5>Quick Links</h5>
						<ul>
							<li><a href="index.jsp">Home</a></li>
							<li><a href="#courses">Courses</a></li>
							<li><a href="index.jsp">Student Login</a></li>
							<li><a href="index.jsp">Teacher Login</a></li>
						</ul>
					</div>
				</div>
                             <div class="col-xl-2 col-lg-2 col-md-6">
					<div class="footer-widget">
						<h5>Our Course</h5>
						<ul>
							<li><a href="javascript:void(0)">Python</a></li>
							<li><a href="javascript:void(0)">Web Development</a></li>
							<li><a href="javascript:void(0)">Data Science</a></li>
							<li><a href="javascript:void(0)">Machine Learning</a></li>
						</ul>
					</div>
				</div>
				<div class="col-xl-3 col-lg-3 col-md-6">
					<div class="footer-widget">
						<h5>Contact Us</h5>
						<ul>
							<li><p>Phone: +91-9876543210</p></li>
							<li><p>Email: support@studentlms.com</p></li>
							<li><p>Address: Learning Hub, Chennai, India</p></li>
						</ul>
					</div>
				</div>
			</div>
			
		</div>
	</footer>
        <% String msg = (String) session.getAttribute("msg");
            if (msg != null) {
        %>
        <script> alert("<%=msg%>");</script>
        <% }
        session.removeAttribute("msg");%> 
        
<% 
              }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        } else {
            session.setAttribute("msg", "Session Out Please Login");
            response.sendRedirect("index.jsp");
        }
    %>
	<a href="#" class="back-to-top btn-hover"><i class="lni lni-chevron-up"></i></a>

	<script src="assets/js/bootstrap.bundle-5.0.0.alpha-min.js"></script>
	<script src="assets/js/wow.min.js"></script>
	<script src="assets/js/main.js"></script>

	<script>


    // Get the navbar

    // for menu scroll 
    var pageLink = document.querySelectorAll('.page-scroll');
    
    pageLink.forEach(elem => {
        elem.addEventListener('click', e => {
            e.preventDefault();
            document.querySelector(elem.getAttribute('href')).scrollIntoView({
                behavior: 'smooth',
                offsetTop: 1 - 60,
            });
        });
    });

    // section menu active
    function onScroll(event) {
        var sections = document.querySelectorAll('.page-scroll');
        var scrollPos = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;

        for (var i = 0; i < sections.length; i++) {
            var currLink = sections[i];
            var val = currLink.getAttribute('href');
            var refElement = document.querySelector(val);
            var scrollTopMinus = scrollPos + 73;
            if (refElement.offsetTop <= scrollTopMinus && (refElement.offsetTop + refElement.offsetHeight > scrollTopMinus)) {
                document.querySelector('.page-scroll').classList.remove('active');
                currLink.classList.add('active');
            } else {
                currLink.classList.remove('active');
            }
        }
    };

    window.document.addEventListener('scroll', onScroll);


    //===== close navbar-collapse when a  clicked
    let navbarToggler = document.querySelector(".navbar-toggler");    
    var navbarCollapse = document.querySelector(".navbar-collapse");

    document.querySelectorAll(".page-scroll").forEach(e =>
        e.addEventListener("click", () => {
            navbarToggler.classList.remove("active");
            navbarCollapse.classList.remove('show')
        })
    );
    navbarToggler.addEventListener('click', function() {
        navbarToggler.classList.toggle("active");
    });

	</script>


</body>
</html>
