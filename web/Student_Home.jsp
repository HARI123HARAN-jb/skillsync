<%-- 
    Document   : student_Home
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
.formbold-btn {
  display: inline-block;
  width: 100%;
  background-color: #F2A92C; /* golden color */
  color: #fff;
  font-size: 18px;
  font-weight: 600;
  padding: 12px 20px;
  border: none;
  border-radius: 50px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: center;
}

.formbold-btn:hover {
  background-color: #d98c00; /* darker on hover */
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0,0,0,0.2);
}

.container-student {
    width: 90%;
    max-width: 1200px;
    margin: 40px auto;
}
/* --- Course List --- */
.course-list {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
}

.course-card {
    background-color: #fff;
    border-radius: 15px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    width: 250px;
    padding: 20px;
    text-align: center;
    transition: transform 0.3s, box-shadow 0.3s;
}

.course-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 30px rgba(0,0,0,0.15);
}

.course-card img {
    width: 100px;
    height: 100px;
    border-radius: 10px;
    object-fit: cover;
    margin-bottom: 15px;
}

.course-card a {
    display: block;
    font-weight: 600;
    color: #F2A92C;
    margin-bottom: 10px;
    text-decoration: none;
    font-size: 18px;
}

.course-card a:hover {
    color: #d98c00;
}

/* --- Progress bar --- */
.progress-container {
    background-color: #e9ecef;
    border-radius: 10px;
    height: 12px;
    width: 100%;
    margin-bottom: 10px;
    overflow: hidden;
}

.progress-bar {
    height: 12px;
    background-color: #F2A92C;
    width: 0%;
    border-radius: 10px;
    transition: width 0.5s ease;
}

/* --- Certificate link --- */
.certificate {
    display: inline-block;
    margin-top: 190px;
    padding: 6px 12px;
    background-color: #28a745;
    color: #fff;
    border-radius: 50px;
    text-decoration: none;
    font-size: 14px;
    transition: background 0.3s;
    width:200px;
    height:50px;
}

.certificate:hover {
    background-color: #218838;
}
h2, h3 {
    text-align: center;
    color: #333;
}
/* --- Responsive --- */
@media(max-width:768px){
    .course-list {
        flex-direction: column;
        align-items: center;
    }
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
                DbConnection db = new DbConnection();
                ResultSet rs = db.Select("SELECT * FROM student_register WHERE student_id='" + id + "' AND student_mail='" + name + "'");
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
<!--====== COURSES ======-->
	<section id="courses" class="course-area pt-140 pb-70">
		<div class="container">
			<div class="section-title text-center mb-50">
				<h2 class="mb-15 wow fadeInUp" data-wow-delay=".2s">Available Courses</h2>
				<p class="wow fadeInUp" data-wow-delay=".4s">Browse our learning modules. Complete lessons and test your knowledge with quizzes.</p>
			</div>
			<div class="row mb-30">
				<div class="col-xl-4 col-lg-4 col-md-6">
					<div class="single-course">
						<div class="course-img"><img src="assets/images/image3.jpg" alt=""></div>
						<div class="course-info">
							<h4>Python Programming</h4>
							<p>Learn Python basics and problem solving with real examples.</p>
						</div>
					</div>
				</div>
				<div class="col-xl-4 col-lg-4 col-md-6">
					<div class="single-course">
						<div class="course-img"><img src="assets/images/image2.jpg" alt=""></div>
						<div class="course-info">
							<h4>Web Development</h4>
							<p>Build responsive websites using HTML, CSS, and JavaScript.</p>
						</div>
					</div>
				</div>
				<div class="col-xl-4 col-lg-4 col-md-6">
    <div class="single-course">
        <div class="course-img">
             <img src="assets/images/image5.jpg" alt="C++ Course" style="height:285px;">
        </div>
        <div class="course-info">
            <h4>C++ Programming</h4>
            <p>Learn the fundamentals of C++ programming,and problem-solving.</p>
        </div>
    </div>
</div>			</div>
			<div class="text-center">
				<a href="index.jsp" class="main-btn">View All Courses</a>
			</div>
		</div>
	</section>

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
