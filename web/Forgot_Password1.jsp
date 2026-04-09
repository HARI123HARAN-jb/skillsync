<%-- 
    Document   : Forgot_Password1
    Created on : 11-Oct-2025, 16:31:15
    Author     : user
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="no-js" lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<title>Student Learning Management Website</title>
	<meta name="description" content="A Student Learning Management Website for online courses, quizzes, mentors, and student-teacher interaction.">

	<!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500;1,600&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- Bootstrap 5 CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <link rel="stylesheet" href="assets/css/newstyle.css"/>
</head>

<body>
    <style>
        
/* Card styling */
.card {
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
    padding: 30px;
    text-align: center;
    animation: fadeIn 0.6s ease-in-out;
}

/* Title */
.card-title {
    font-size: 24px;
    font-weight: bold;
    color: #333;
    margin-bottom: 20px;
}

 .formbold-main-wrapper {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            width: 400px;
        }

        .formbold-form-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-top: 5px;
        }

        .formbold-form-label {
            font-weight: bold;
        }

        .formbold-btn {
            background-color: #ff7e00;
            border: none;
            color: white;
            padding: 10px 20px;
            margin-top: 15px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .formbold-btn:hover {
            background-color: #ff9100;
        }

        .container2 {
            display: none;
        }
/* Fade-in animation */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}
    </style>
	<!-- PRELOADER -->
<div id="preloader">
  <div class="pre-logo">SkillSync</div>
  <div class="pre-dots"><span></span><span></span><span></span></div>
</div>

<!-- NAVBAR -->
<nav class="sk-navbar" id="skNavbar">
  <div class="container-xl">
    <a class="sk-brand" href="index.jsp" style="display:flex; align-items:center; gap:8px;">
  <img src="assets/images/logo.png" style="width:25px; height:100%;">
  REC
</a>
    <div class="sk-nav" id="desktopNav">
      <a href="index.jsp"    onclick="closeMobileNav()">Home</a>
    </div>
    <button class="sk-ham" id="skHam" onclick="toggleMobileNav()">
      <span></span><span></span><span></span>
    </button>
  </div>
  <div class="sk-mobile-nav" id="mobileNav">
    <a href="index.jsp"    onclick="closeMobileNav()">Home</a>
    <a href="javascript:void(0)" onclick="openModal();closeMobileNav()">Sign In</a>
  </div>
</nav>

<!-- HERO -->
<section id="home" class="hero">
  <div class="hero-bg-panel"></div>
  <div class="hero-ring"></div>
  <div class="hero-dots"></div>

  <div class="container-xl px-4 position-relative" style="z-index:1;">
    <div class="row align-items-center g-5">

      <!-- Text -->
      <div class="col-lg-6">
        <div class="hero-eyebrow">🎓 Online Learning Platform</div>
        <h1>Welcome to<br><em>Student</em> Learning<br>Management</h1>
        <p class="hero-desc">
          An online platform where students and teachers connect, collaborate, and grow.
          Enroll in courses, attempt quizzes, and track your progress — all in one place.
        </p>
        <div class="hero-actions">
          <a href="#courses" class="btn-hero-primary">
            <i class="bi bi-compass"></i> Explore Courses
          </a>
          <a href="javascript:void(0)" class="btn-hero-outline" onclick="openModal()">
            <i class="bi bi-box-arrow-in-right"></i> Login
          </a>
        </div>
        <div class="hero-stats">
          <div class="hero-stat">
            <div class="stat-number">120+</div>
            <div class="stat-text">Courses</div>
          </div>
          <div class="hero-stat">
            <div class="stat-number">4.8k</div>
            <div class="stat-text">Students</div>
          </div>
          <div class="hero-stat">
            <div class="stat-number">98%</div>
            <div class="stat-text">Satisfaction</div>
          </div>
        </div>
      </div>

      <!-- Image -->
      <div class="col-lg-6">
        <div class="hero-img-wrap">
          <div class="hero-img-main">
            <img src="assets/images/image7.jpg" alt="Student learning online">
          </div>
          <div class="hero-float-card">
            <div class="float-icon"><i class="bi bi-shield-check"></i></div>
            <div class="float-card-text">
              <strong>Certificate Ready</strong>
              <span>Complete &amp; earn your badge</span>
            </div>
          </div>
          <div class="hero-cert-tag">
            <div class="cert-emoji">🏆</div>
            <div class="cert-tag-text">
              <strong>Top Rated Platform</strong>
              <span>Loved by 4,800+ students</span>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</section>
<% String msg = (String) session.getAttribute("msg");
            if (msg != null) {
        %>
        <script> alert("<%=msg%>");</script>
        <% }
        session.removeAttribute("msg");%>
 <div class="container-fluid">
            <div class="col-lg-12">
                <div class="row"style="align-items: center;justify-content: center;">
                    <div class="card"style="width: 30rem;align-items: center;color: black;margin-top: 50px;margin-bottom: 50px;">
                        <h5 class="card-title"style="margin-top: 10px;">Forgot Password</h5>
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

    <script>
        function sendOTP(event) {
            event.preventDefault();
            var email = document.getElementById('mail_id').value;

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'Send_Otp1', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function () {
                if (xhr.status === 200) {
                    document.querySelector('.container1').style.display = 'none';
                    document.querySelector('.container2').style.display = 'block';
                } else {
                    alert('Error sending OTP');
                }
            };
            xhr.send('mail_id=' + encodeURIComponent(email));
        }
    </script>
                   <div class="container1">
        <div class="formbold-main-wrapper">
            <form action="Send_Otp1" method="post" onsubmit="sendOTP(event)">
                <label class="formbold-form-label">Email ID</label>
                <input type="email" name="mail_id" id="mail_id" class="formbold-form-input" placeholder="Enter your Email ID" required>
                <input class="formbold-btn" type="submit" value="SEND OTP">
            </form>
        </div>
    </div>

    <div class="container2">
        <div class="formbold-main-wrapper">
            <form action="Check_Otp1" method="post">
                <label class="formbold-form-label">Enter OTP</label>
                <input type="text" name="otp" id="otp" class="formbold-form-input" placeholder="Enter your OTP" required>
                <input class="formbold-btn" type="submit" value="VERIFY OTP">
            </form>
        </div>
    </div>
        </div>
    </div>
                 </div>
             </div>
    	
	<!--====== FOOTER ======-->
	<footer id="footer">
  <div class="container-xl px-4">
    <div class="row g-5">
      <div class="col-lg-4 col-md-6">
        <span class="f-brand">SkillSync</span>
        <p class="f-desc">A platform where students and teachers collaborate for better learning outcomes. Learn, grow, and achieve together.</p>
      </div>
      <div class="col-lg-2 col-md-3 col-6">
        <div class="f-col-title">Quick Links</div>
        <div class="f-links">
          <a href="index.jsp">Home</a>
          <a href="#courses">Courses</a>
          <a href="javascript:void(0)" onclick="openModal()">Student Login</a>
          <a href="javascript:void(0)" onclick="openModal()">Teacher Login</a>
        </div>
      </div>
      <div class="col-lg-2 col-md-3 col-6">
        <div class="f-col-title">Our Courses</div>
        <div class="f-links">
          <a href="javascript:void(0)">Python</a>
          <a href="javascript:void(0)">Web Development</a>
          <a href="javascript:void(0)">C++ Programming</a>
          <a href="javascript:void(0)">Data Science</a>
        </div>
      </div>
      <div class="col-lg-3 col-md-6">
        <div class="f-col-title">Contact Us</div>
        <div class="f-links">
          <p><i class="bi bi-telephone me-2" style="color:orange"></i>+91-9876543210</p>
          <p><i class="bi bi-envelope me-2" style="color:orange"></i>support@skillsync.com</p>
          <p><i class="bi bi-geo-alt me-2" style="color:orange"></i>Learning Hub, Chennai, India</p>
        </div>
      </div>
    </div>
  </div>
</footer>

<!-- Back to top -->
<div class="back-top-btn" id="backTopBtn" onclick="window.scrollTo({top:0,behavior:'smooth'})">
  <i class="bi bi-arrow-up"></i>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
     /* Preloader */
  window.addEventListener('load', () => {
    setTimeout(() => document.getElementById('preloader').classList.add('hide'), 900);
  });

  /* Navbar scroll */
  const navbar  = document.getElementById('skNavbar');
  const backBtn = document.getElementById('backTopBtn');
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 30);
    backBtn.classList.toggle('show', window.scrollY > 300);
  });

  /* Mobile nav */
  function toggleMobileNav() {
    document.getElementById('mobileNav').classList.toggle('open');
    document.getElementById('skHam').classList.toggle('open');
  }
  function closeMobileNav() {
    document.getElementById('mobileNav').classList.remove('open');
    document.getElementById('skHam').classList.remove('open');
  }

  /* Scroll reveal */
  const io = new IntersectionObserver((entries) => {
    entries.forEach((e, i) => {
      if (e.isIntersecting) {
        e.target.style.transitionDelay = (i * 0.09) + 's';
        e.target.classList.add('visible');
        io.unobserve(e.target);
      }
    });
  }, { threshold: 0.11 });
  document.querySelectorAll('.fade-up').forEach(el => io.observe(el));

    /* Smooth scroll */
  document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', e => {
      const target = document.querySelector(a.getAttribute('href'));
      if (target) { e.preventDefault(); target.scrollIntoView({ behavior: 'smooth' }); closeMobileNav(); }
    });
  });
</script>
</body>
</html>


