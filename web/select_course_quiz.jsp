<%-- 
    Document   : select_course_quiz
    Created on : 24-Sep-2025, 14:46:24
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

	<!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500;1,600&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- Bootstrap 5 CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

 <link rel="stylesheet" href="assets/css/teacher_navbar.css"/>
  <link rel="stylesheet" href="assets/css/teacher.css"/>
</head>

<body>
    <style>

/* Card hover effect */
.course-card {
  transition: transform 0.3s, box-shadow 0.3s;
  border-radius: 20px;
  background: linear-gradient(145deg, #f0f4ff, #d9e4ff);
  position: relative;
  display: flex;
  flex-direction: column;
}

.course-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 15px 25px rgba(0, 0, 0, 0.2);
}

/* Course image styling */
.course-card img {
  width: 150px;
  height: 150px;
  object-fit: cover;
  border-radius: 50px;
  margin: 0 auto 15px auto;
  transition: transform 0.3s;
}

.course-card img:hover {
  transform: scale(1.05);
}

/* Button styling */
.course-card .btn {
  font-weight: bold;
  transition: transform 0.2s, box-shadow 0.2s;
}

.course-card .btn:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 12px rgba(0,0,0,0.2);
}

/* Card text styling */
.course-card h5 {
  font-size: 1.25rem;
  color: #0d6efd;
}

.course-card p {
  font-size: 0.95rem;
  color: #555;
}

/* Animation for card entrance */
@keyframes fadeInUp {
  0% {opacity: 0; transform: translateY(20px);}
  100% {opacity: 1; transform: translateY(0);}
}

.course-card {
  animation: fadeInUp 0.5s ease forwards;
}
    </style>
	<!-- PRELOADER -->
<div id="preloader">
  <div class="pre-logo">SkillSync</div>
  <div class="pre-dots"><span></span><span></span><span></span></div>
</div>
        
<%
        Integer teacher_id = (Integer) session.getAttribute("teacher_id");
        String name = (String) session.getAttribute("teacher_mail");

        if (teacher_id != null && name != null) {
            try {
                DbConnection db = new DbConnection();
                ResultSet rs = db.Select("SELECT * FROM teacher_register WHERE teacher_id='" + teacher_id + "' AND teacher_mail='" + name + "'");
                if (rs.next()) {
                    String teacher_name = rs.getString("teacher_name"); 
    %>
	<!--====== HEADER ======-->
	<header class="sk-teacher-nav" id="teacherNav">
  <div class="sk-nav-inner">

    <!-- Brand -->
   <a class="sk-brand" href="Teacher_Home.jsp" style="display:flex; align-items:center; gap:8px;">
  <img src="assets/images/logo.png" style="width:25px; height:100%;">
  REC
</a>

    <!-- Desktop nav links -->
    <ul class="sk-nav-links" id="desktopLinks">

      <!-- Home -->
      <li class="sk-link" data-page="Teacher_Home.jsp">
        <a href="Teacher_Home.jsp">
          <i class="bi bi-house"></i> Home
        </a>
      </li>

      <!-- Courses dropdown -->
      <li class="sk-dropdown" id="ddCourses" data-page="courses">
        <button class="sk-dropbtn" onclick="toggleDropdown('ddCourses')">
          <i class="bi bi-book"></i> Courses
          <i class="bi bi-chevron-down caret"></i>
        </button>
        <ul class="sk-dropdown-menu">
          <li>
            <a href="Add_Course.jsp">
              <span class="menu-icon"><i class="bi bi-plus-circle"></i></span>
              Add Course
            </a>
          </li>
          <li>
            <a href="select_course.jsp">
              <span class="menu-icon"><i class="bi bi-collection"></i></span>
              Add Modules
            </a>
          </li>
          <li>
            <a href="select_course1.jsp">
              <span class="menu-icon"><i class="bi bi-file-earmark-text"></i></span>
              Add Topic
            </a>
          </li>
          <div class="dd-divider"></div>
          <li>
            <a href="select_course_quiz.jsp">
              <span class="menu-icon"><i class="bi bi-patch-question"></i></span>
              Add Quiz
            </a>
          </li>
        </ul>
      </li>

      <!-- View dropdown -->
      <li class="sk-dropdown" id="ddView" data-page="view">
        <button class="sk-dropbtn" onclick="toggleDropdown('ddView')">
          <i class="bi bi-eye"></i> View
          <i class="bi bi-chevron-down caret"></i>
        </button>
        <ul class="sk-dropdown-menu">
          <li>
            <a href="View_Course.jsp">
              <span class="menu-icon"><i class="bi bi-grid-3x2-gap"></i></span>
              View Courses
            </a>
          </li>
          <li>
            <a href="Student_Course_State.jsp">
              <span class="menu-icon"><i class="bi bi-people"></i></span>
              View Students
            </a>
          </li>
        </ul>
      </li>

    </ul><!-- /sk-nav-links -->

    <!-- Right side: teacher chip + logout -->
    <div style="display:flex;align-items:center;gap:12px;">

      <div class="teacher-chip">
        <div class="teacher-avatar" id="teacherAvatar"><img src="teacher_img.jsp?name=<%= teacher_id%>" class="card-img" style="width:30px;height: 30px;border-radius: 50%;" alt="Profile Picture"></div>
        <div class="teacher-chip-text">
          <span class="teacher-chip-name" id="teacherChipName"><%= teacher_name%></span>
          <span class="teacher-chip-role">Instructor</span>
        </div>
      </div>

      <a href="index.jsp" class="btn-sk-logout">
        <i class="bi bi-box-arrow-right"></i>
        <span>Logout</span>
      </a>

      <!-- Hamburger -->
      <button class="sk-ham" id="skHam" onclick="toggleDrawer()" aria-label="Menu">
        <span></span><span></span><span></span>
      </button>
    </div>

  </div>
</header>

	<!--====== HERO ======-->
	<section id="home" class="hero">
  <div class="hero-bg-panel"></div>
  <div class="hero-ring"></div>
  <div class="hero-ring-2"></div>
  <div class="hero-dots"></div>

  <div class="container-xl px-4 position-relative" style="z-index:1;">
    <div class="row align-items-center g-5">
      <div class="col-lg-6">
        <div class="hero-eyebrow"><i class="bi bi-person-workspace me-1"></i> Teacher Portal</div>
        <h1>Welcome to<br><em>SkillSync</em><br>Learning Management</h1>
        <div class="hero-teacher-name">Madam / Sir , <%= teacher_name %></div>
        <p class="hero-desc">
          Create and manage courses, add topics and quizzes, and track how your students are performing — all in one place.
        </p>
        <div class="hero-actions">
          <a href="#courses" class="btn-hero-primary"><i class="bi bi-compass"></i> Explore Courses</a>
          <a href="Add_Course.jsp" class="btn-hero-outline"><i class="bi bi-plus-circle"></i> Add New Course</a>
        </div>
        <div class="hero-stats">
          <div class="hero-stat"><div class="stat-number">120+</div><div class="stat-text">Courses</div></div>
          <div class="hero-stat"><div class="stat-number">4.8k</div><div class="stat-text">Students</div></div>
          <div class="hero-stat"><div class="stat-number">98%</div><div class="stat-text">Satisfaction</div></div>
        </div>
      </div>
      <div class="col-lg-6">
        <div class="hero-img-wrap">
          <div class="hero-img-main">
            <img src="assets/images/image7.jpg" alt="Teacher teaching online">
          </div>
          <div class="hero-float-card">
            <div class="float-icon"><i class="bi bi-shield-check"></i></div>
            <div class="float-card-text">
              <strong>Certificate Ready</strong>
              <span>Students earn badges on completion</span>
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


<div class="container mt-5">

    <h2 class="text-center text-primary mb-4 fw-bold">Select a Course</h2>

    <div class="row">
    <%
        ResultSet rs1 = db.Select("SELECT * FROM courses ORDER BY course_name ASC");

        while (rs1.next()) {
            int courseId = rs1.getInt("course_id");
            String courseName = rs1.getString("course_name");

            int easyCount = 0, normalCount = 0, hardCount = 0;

            ResultSet rsEasy = db.Select("SELECT COUNT(*) AS cnt FROM topic_quiz WHERE course_id='" + courseId + "' AND status='EASY'");
            if (rsEasy.next()) easyCount = rsEasy.getInt("cnt");
            rsEasy.close();

            ResultSet rsNormal = db.Select("SELECT COUNT(*) AS cnt FROM topic_quiz WHERE course_id='" + courseId + "' AND status='NORMAL'");
            if (rsNormal.next()) normalCount = rsNormal.getInt("cnt");
            rsNormal.close();

            ResultSet rsHard = db.Select("SELECT COUNT(*) AS cnt FROM topic_quiz WHERE course_id='" + courseId + "' AND status='HARD'");
            if (rsHard.next()) hardCount = rsHard.getInt("cnt");
            rsHard.close();

            boolean allCompleted = easyCount >= 5 && normalCount >= 5 && hardCount >= 5;
    %>

        <div class="col-md-4 mb-4">

            <div class="card course-card shadow-lg text-center p-4 h-100">

                <h5 class="fw-bold mb-3"><%= courseName %></h5>
<img src="course_img.jsp?name=<%= courseId %>" alt="<%= courseName %>" style="width:200px;height: 200px;margin:10px; border-radius:50px;margin-left: 50px !important; ">
                <p class="text-muted">
                    Level 1: <%= easyCount %>/5,
                    Level 2: <%= normalCount %>/5,
                    Level 3: <%= hardCount %>/5
                </p>

                <div class="mt-auto">
                    <% if(allCompleted){ %>
                        <a href="Teacher_Add_Quiz_Type.jsp?course_id=<%=courseId%>" 
                           class="btn btn-warning w-100">
                           ✏️ Edit Quiz
                        </a>
                    <% } else { %>
                        <a href="Teacher_Add_Quiz_Type.jsp?course_id=<%=courseId%>" 
                           class="btn btn-primary w-100">
                           ➕ Add Quiz
                        </a>
                    <% } %>
                </div>

            </div>

        </div>

    <%
        }
        rs1.close();
        db.close();
    %>
    </div> <!-- end row -->

</div>

<script>
    const select = document.getElementById("courseSelect");
const nextBtn = document.getElementById("nextBtn");
const editBtn = document.getElementById("editBtn");

select.addEventListener("change", function () {
    const selectedOption = select.options[select.selectedIndex];
    const isCompleted = selectedOption.getAttribute("data-complete");

    if (isCompleted === "true") {
        nextBtn.style.display = "none";
        editBtn.style.display = "inline-block";
    } else {
        nextBtn.style.display = "inline-block";
        editBtn.style.display = "none";
    }
});

// Redirect to edit page
function goToEdit() {
    const courseId = select.value;
    if (courseId) {
        window.location.href = "Teacher_Add_Quiz_Type.jsp?course_id=" + courseId;
    }
}
</script>
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
    
	<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
(function() {
  /* ── Navbar scroll shadow ── */
  var nav = document.getElementById('teacherNav');
  window.addEventListener('scroll', function() {
    nav.classList.toggle('scrolled', window.scrollY > 20);
  }, { passive: true });

  /* ── Active page highlight ── */
  var currentPage = window.location.pathname.split('/').pop() || 'Teacher_Home.jsp';
  document.querySelectorAll('.sk-nav-links .sk-link').forEach(function(li) {
    if (li.getAttribute('data-page') === currentPage) {
      li.classList.add('active-page');
    }
  });
  // highlight dropdown if any child matches
  ['ddCourses','ddView'].forEach(function(id) {
    var dd = document.getElementById(id);
    if (!dd) return;
    dd.querySelectorAll('a').forEach(function(a) {
      if (a.getAttribute('href') === currentPage) {
        dd.classList.add('active-page');
      }
    });
  });
  // highlight drawer links
  document.querySelectorAll('.drawer-link').forEach(function(link) {
    if (link.getAttribute('href') === currentPage) {
      link.classList.add('active');
    }
  });

  /* ── Dropdown toggle ── */
  window.toggleDropdown = function(id) {
    var target = document.getElementById(id);
    var wasOpen = target.classList.contains('open');
    // close all
    document.querySelectorAll('.sk-dropdown').forEach(function(d) { d.classList.remove('open'); });
    if (!wasOpen) target.classList.add('open');
  };

  // Close dropdown on outside click
  document.addEventListener('click', function(e) {
    if (!e.target.closest('.sk-dropdown')) {
      document.querySelectorAll('.sk-dropdown').forEach(function(d) { d.classList.remove('open'); });
    }
  });

  // Close dropdown on ESC
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      document.querySelectorAll('.sk-dropdown').forEach(function(d) { d.classList.remove('open'); });
      closeDrawer();
    }
  });

  var tName = window.teacherDisplayName || '';
  if (tName) {
    var firstLetter = tName.charAt(0).toUpperCase();
    var firstName   = tName.split(' ')[0];
    ['teacherAvatar','drawerAvatar'].forEach(function(id) {
      var el = document.getElementById(id);
      if (el) el.textContent = firstLetter;
    });
    var chip = document.getElementById('teacherChipName');
    if (chip) chip.textContent = firstName;
    var dn = document.getElementById('drawerName');
    if (dn) dn.textContent = tName;
  }

})();
</script>

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


