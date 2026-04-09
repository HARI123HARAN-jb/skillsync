<%-- 
    Document   : Add_Modules
    Created on : 10 Jun, 2025, 3:56:18 PM
    Author     : Admin1
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
/* Container */
.module-container {
    max-width: 800px;
    margin: 40px auto;
    padding: 30px;
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 25px rgba(0,0,0,0.1);
}

/* Page title */
.page-title {
    text-align: center;
    color: #F2A92C;
    font-size: 28px;
    margin-bottom: 30px;
}

/* Module card */
.module-card {
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 25px;
    background-color: #fafafa;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}

/* Form group */
.form-group {
    margin-bottom: 15px;
}

.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 5px;
}

.form-group input[type="text"],
.form-group input[type="file"],
.form-group textarea {
    width: 100%;
    padding: 8px 12px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 15px;
}

/* Quiz heading */
.module-card h4 {
    margin-top: 20px;
    color: #333;
}

/* Submit button */
.form-submit {
    text-align: center;
    margin-top: 20px;
}

.btn-submit {
    background-color: #F2A92C;
    color: #fff;
    border: none;
    padding: 12px 25px;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s, transform 0.2s;
}

.btn-submit:hover {
    background-color: #e09c1c;
    transform: translateY(-2px);
}

/* Responsive */
@media (max-width: 576px) {
    .module-container {
        padding: 20px;
        margin: 20px;
    }
}
    </style>
	<!--====== PRELOADER ======-->
	<!-- PRELOADER -->
<div id="preloader">
  <div class="pre-logo">SkillSync</div>
  <div class="pre-dots"><span></span><span></span><span></span></div>
</div>
<%
   String topicId = request.getParameter("topic_id");
   String topicName = request.getParameter("topic_name");
   Integer teacher_id = (Integer) session.getAttribute("teacher_id");
   String course_id = request.getParameter("course_id");
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


<div class="module-container">
    <h2 class="page-title">Add Topics for Module <%= topicName %></h2>

   <script>
function generateTopics() {
    var count = parseInt(document.getElementById("topicCountInput").value);
    if (isNaN(count) || count < 3 || count > 10) {
        alert("⚠️ Please enter a number between 3 and 10");
        return;
    }

    // ✅ Set hidden field value for backend
    document.getElementById("topicCountHidden").value = count;

    var container = document.getElementById("topicContainer");
    container.innerHTML = "";

    for (var i = 1; i <= count; i++) {
        var topicHTML = "<div class='module-card form-group'>" +
            "<h3>Topic " + i + "</h3>" +
            "<label>Topic Title:</label>" +
            "<input type='text' name='topic" + i + "_title' required><br>" +
            "<label>Upload Video:</label>" +
            "<input type='file' name='topic" + i + "_video' required><br>" +
            "<label>Upload Notes:</label>" +
            "<input type='file' name='topic" + i + "_notes' required><br><hr>" +
            "<h4>Quiz Questions for Topic " + i + ":</h4>";

        for (var q = 1; q <= 3; q++) {
            topicHTML += "<div class='form-group' style='margin-left: 20px; margin-bottom: 15px;'>" +
                "<label>Question " + q + ":</label><br>" +
                "<input type='text' name='topic" + i + "_q" + q + "' required><br>" +
                "<label>Option A:</label> <input type='text' name='topic" + i + "_q" + q + "_a' required><br>" +
                "<label>Option B:</label> <input type='text' name='topic" + i + "_q" + q + "_b' required><br>" +
                "<label>Option C:</label> <input type='text' name='topic" + i + "_q" + q + "_c' required><br>" +
                "<label>Option D:</label> <input type='text' name='topic" + i + "_q" + q + "_d' required><br>" +
                "<label>Correct Answer (A/B/C/D):</label> <input type='text' name='topic" + i + "_q" + q + "_correct' required><br><hr>" +
                "</div>";
        }

        topicHTML += "</div>";
        container.innerHTML += topicHTML;
    }

    document.getElementById("mainForm").style.display = "block";
    attachValidation();
}
function attachValidation() {
    var form = document.getElementById("mainForm");
    form.onsubmit = function (e) {
        var valid = true;
        var count = parseInt(document.getElementById("topicCountHidden").value);

        for (var i = 1; i <= count; i++) {
            // --- Validate Video ---
            var videoInput = document.getElementsByName("topic" + i + "_video")[0];
            if (videoInput && videoInput.files && videoInput.files.length > 0) {
                var videoFile = videoInput.files[0];
                var videoExt = videoFile.name.substring(videoFile.name.lastIndexOf('.') + 1).toLowerCase();
                if (videoExt != 'mp4' && videoExt != 'mov' && videoExt != 'avi' && videoExt != 'mkv') {
                    alert("❌ Invalid video format for Topic " + i + ". Allowed: mp4, mov, avi, mkv");
                    valid = false;
                    break;
                }
            }

            // --- Validate Notes ---
            var notesInput = document.getElementsByName("topic" + i + "_notes")[0];
            if (notesInput && notesInput.files && notesInput.files.length > 0) {
                var notesFile = notesInput.files[0];
                var notesExt = notesFile.name.substring(notesFile.name.lastIndexOf('.') + 1).toLowerCase();
                if (notesExt != 'doc' && notesExt != 'docx' && notesExt != 'pdf' && notesExt != 'txt') {
                    alert("❌ Invalid notes format for Topic " + i + ". Allowed: doc, docx, pdf, txt");
                    valid = false;
                    break;
                }
            }
        }

        // ❌ Stop form submit if invalid
        if (!valid) {
            if (e && e.preventDefault) e.preventDefault();
            else window.event.returnValue = false;
            return false;
        }

        return true;
    };
}
document.addEventListener("DOMContentLoaded", function () {
    var input = document.getElementById("topicCountInput");
    input.addEventListener("input", generateTopics);
    input.addEventListener("change", generateTopics);
});
</script>
    <div>
   <label for="moduleCount">Enter or adjust the number of modules (3–10):
       <input type="number" id="topicCountInput" min="3" max="10">
   </label>
    
    <!--<button type="button" class="btn" onclick="generateTopics()">Generate</button>-->
</div>

<form id="mainForm" action="Add_Modules" method="post" enctype="multipart/form-data" style="display:none; margin-top:30px;">
    <input type="hidden" name="topic_id" value="<%= topicId %>"> 
    <input type="hidden" name="topic_name" value="<%= topicName %>"> 
    <input type="hidden" name="teacher_id" value="<%= teacher_id %>"> 
    <input type="hidden" name="course_id" value="<%= course_id %>">
    <input type="hidden" name="topicCount" id="topicCountHidden">

    <div id="topicContainer"></div>

    <div style="text-align:center;" class="form-group">
        <input type="submit" class="btn-submit" value="Save All Topics">
    </div>
</form>
</div>
<script type="text/javascript">
window.onload = function () {
    var form = document.getElementById("mainForm"); // ✅ attach to form, not div
    if (!form) {
        alert("Form with id 'mainForm' not found!");
        return;
    }

    form.onsubmit = function (e) {
        var valid = true;

        // Get topic count from hidden input
        var count = parseInt(document.getElementById("topicCountHidden").value);
        if (isNaN(count) || count <= 0) {
            alert("⚠️ Please generate topics first before submitting.");
            if (e && e.preventDefault) e.preventDefault();
            else window.event.returnValue = false;
            return false;
        }

        // ✅ Loop through all generated topics
        for (var i = 1; i <= count; i++) {
            // --- Validate Video ---
            var videoInput = document.getElementsByName("topic" + i + "_video")[0];
            if (videoInput && videoInput.files && videoInput.files.length > 0) {
                var videoFile = videoInput.files[0];
                var videoExt = videoFile.name.substring(videoFile.name.lastIndexOf('.') + 1).toLowerCase();
                if (videoExt != 'mp4' && videoExt != 'mov' && videoExt != 'avi' && videoExt != 'mkv') {
                    alert("❌ Invalid video format for Topic " + i + ". Allowed: mp4, mov, avi, mkv");
                    valid = false;
                    break;
                }
            }

            // --- Validate Notes ---
            var notesInput = document.getElementsByName("topic" + i + "_notes")[0];
            if (notesInput && notesInput.files && notesInput.files.length > 0) {
                var notesFile = notesInput.files[0];
                var notesExt = notesFile.name.substring(notesFile.name.lastIndexOf('.') + 1).toLowerCase();
                if (notesExt != 'doc' && notesExt != 'docx' && notesExt != 'pdf' && notesExt != 'txt') {
                    alert("❌ Invalid notes format for Topic " + i + ". Allowed: doc, docx, pdf, txt");
                    valid = false;
                    break;
                }
            }
        }

        // Stop form if invalid
        if (!valid) {
            if (e && e.preventDefault) e.preventDefault();
            else window.event.returnValue = false; // old IE
            return false;
        }
    };
};
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
