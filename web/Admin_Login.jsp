<%-- 
    Document   : Admin_Log
    Created on : 12 Nov, 2024, 5:19:47 PM
    Author     : trios
--%>


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
/* Card styling */
.card {
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
    padding: 30px;
    animation: fadeIn 0.6s ease-in-out;
}

/* Title */
.card-title {
    font-size: 24px;
    font-weight: bold;
    color: #333;
    margin-bottom: 20px;
}

/* Input labels */
.formbold-form-label {
    font-size: 15px;
    font-weight: 600;
    color: #444;
    display: block;
    text-align: left;
    margin-bottom: 6px;
}

/* Input fields */
.formbold-form-input {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #ddd;
    border-radius: 10px;
    outline: none;
    font-size: 15px;
    transition: 0.3s;
}

.formbold-form-input:focus {
    border-color: #ff6600;
    box-shadow: 0 0 8px rgba(255, 102, 0, 0.3);
}

/* Login button */
.formbold-btn {
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    background: linear-gradient(135deg, #ff6600, #ff8533);
    border: none;
    border-radius: 50px;
    color: #fff;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s ease;
}

.formbold-btn:hover {
    background: linear-gradient(135deg, #e65c00, #ff751a);
    transform: scale(1.05);
    box-shadow: 0 5px 15px rgba(255, 102, 0, 0.4);
}

/* Fade-in animation */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
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
									<li class="nav-item"><a href="index.jsp">Home</a></li>
								</ul>
							</div> 
						</nav>
					</div>
				</div> 
			</div>
		</div>
	</header>

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

              <script>
function validateLogin() {
    const email = document.getElementsByName("mail_id")[0].value.trim();
    const password = document.getElementsByName("password")[0].value.trim();

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (email === "" || !emailRegex.test(email)) {
        alert("Please enter a valid email address.");
        return false;
    }

    if (password === "" || password.length < 6) {
        alert("Password must be at least 6 characters long.");
        return false;
    }

    return true; // allow form to submit
}
</script>

                        <div class="container-fluid">
            <div class="col-lg-12">
                <div class="row"style="align-items: center;justify-content: center;margin-top: 50px;margin-bottom: 50px;">
                    <div class="card"style="width: 30rem;align-items: center;color: black;">
                        <h1 class="card-title"style="margin-top: 10px;">Admin Login</h1>
                        
                    <form class="login100-form validate-form" action="Admin_Login" method="post">
                        <div class="wrap-input100 validate-input  form-group" data-validate="Username is required">
                            <span class="label-input100">Username</span>
                            <input class="input100" type="text" name="userName" placeholder="Enter username">
                            <span class="focus-input100"></span>
                        </div>
                        <div class="wrap-input100 validate-input  form-group" data-validate = "Password is required">
                            <span class="label-input100">Password</span>
                            <input class="input100" type="password" name="password" placeholder="Enter password">
                            <span class="focus-input100"></span>
                        </div>
                         <div class="form-group">
            <input class="formbold-btn" value="LOGIN" type="submit">
        </div>
                    </form>
                        </div>
                    </div>
                </div>
         </div>

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
   