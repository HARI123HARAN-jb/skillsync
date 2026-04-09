<%-- 
    Document   : Teacher_Add_Quiz_Type
    Created on : 13-Jan-2026, 14:33:35
    Author     : user
--%>

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

  <link rel="stylesheet" href="assets/css/newstyle.css"/>
  <link rel="stylesheet" href="assets/css/teacher.css"/>
</head>

<body>
    <style>
  * { box-sizing: border-box; margin: 0; padding: 0; }

  .ql-wrap {
    padding: 2.5rem 1rem;
    max-width: 860px;
    margin: auto;
    font-family: system-ui, sans-serif;
    min-height: 100vh;
  }

  .ql-title {
    font-size: 22px; font-weight: 700; color: #1e1b4b;
    text-align: center; margin-bottom: .4rem;
    animation: ql-down .4s ease both;
  }

  .ql-sub {
    text-align: center; font-size: 13px; color: #6b7280;
    margin-bottom: 2rem;
    animation: ql-down .4s .06s ease both;
  }

  @keyframes ql-down {
    from { opacity: 0; transform: translateY(-12px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes ql-up {
    from { opacity: 0; transform: translateY(22px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes ql-pulse {
    0%,100% { transform: scale(1); }
    50%      { transform: scale(1.08); }
  }

  /* ── Level grid ── */
  .ql-level-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1.25rem;
    margin-bottom: 2rem;
  }

  .ql-level-card {
    background: #fff;
    border: 0.5px solid #e0e7ff;
    border-radius: 18px;
    padding: 1.75rem 1.25rem;
    text-align: center;
    animation: ql-up .45s cubic-bezier(.22,.68,0,1.2) both;
    transition: box-shadow .25s, transform .25s;
  }

  .ql-level-card:nth-child(1) { animation-delay: .04s; }
  .ql-level-card:nth-child(2) { animation-delay: .10s; }
  .ql-level-card:nth-child(3) { animation-delay: .16s; }
  .ql-level-card:hover { box-shadow: 0 8px 30px rgba(79,70,229,.13); transform: translateY(-4px); }

  /* ── Icon ── */
  .ql-icon-wrap {
    width: 70px; height: 70px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    margin: 0 auto 14px; font-size: 30px;
    animation: ql-pulse 2.5s ease-in-out infinite;
  }

  .ql-easy   .ql-icon-wrap { background: #d1fae5; }
  .ql-normal .ql-icon-wrap { background: #fef9c3; }
  .ql-hard   .ql-icon-wrap { background: #fee2e2; }

  .ql-level-title { font-size: 16px; font-weight: 700; color: #1e1b4b; margin-bottom: 4px; }

  /* ── Progress bar ── */
  .ql-progress-wrap {
    background: #f3f4f6; border-radius: 20px;
    height: 8px; margin: 10px 0 6px; overflow: hidden;
  }

  .ql-progress-bar { height: 8px; border-radius: 20px; transition: width 1s ease; }
  .ql-easy   .ql-progress-bar { background: #10b981; }
  .ql-normal .ql-progress-bar { background: #f59e0b; }
  .ql-hard   .ql-progress-bar { background: #ef4444; }

  .ql-progress-txt { font-size: 12px; color: #6b7280; margin-bottom: 12px; }

  /* ── Badges ── */
  .ql-completed-badge {
    display: inline-block; background: #d1fae5; color: #065f46;
    font-size: 11px; font-weight: 600; padding: 3px 10px;
    border-radius: 20px; margin-bottom: 10px;
  }

  .ql-pending-badge {
    display: inline-block; background: #ede9fe; color: #5b21b6;
    font-size: 11px; font-weight: 600; padding: 3px 10px;
    border-radius: 20px; margin-bottom: 10px;
  }

  /* ── Action buttons ── */
  .ql-action-btn {
    display: inline-flex; align-items: center; justify-content: center;
    gap: 7px; width: 100%; padding: 10px 0;
    border: none; border-radius: 10px;
    font-size: 14px; font-weight: 600;
    cursor: pointer; text-decoration: none;
    transition: background .2s, transform .15s;
  }

  .ql-action-btn:active { transform: scale(.97); }
  .ql-action-btn svg    { width: 15px; height: 15px; }

  .ql-btn-add  { background: #4f46e5; color: #fff; }
  .ql-btn-add:hover  { background: #3730a3; }
  .ql-btn-edit { background: #f59e0b; color: #78350f; }
  .ql-btn-edit:hover { background: #d97706; }
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
    <a class="sk-brand" href="Teacher_Home.jsp">
      Skill<span>Sync</span>
      <span class="sk-brand-badge">Teacher</span>
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


<%
    int courseId = Integer.parseInt(request.getParameter("course_id"));
    int teacherId = (Integer) session.getAttribute("teacher_id");

    int easyCount = 0, normalCount = 0, hardCount = 0;

    ResultSet rsCount = db.Select(
        "SELECT status, COUNT(*) AS total FROM topic_quiz WHERE course_id='" + courseId + "' GROUP BY status"
    );
    while (rsCount.next()) {
        String type = rsCount.getString("status");
        int total   = rsCount.getInt("total");
        if ("EASY".equalsIgnoreCase(type))   easyCount   = total;
        if ("NORMAL".equalsIgnoreCase(type)) normalCount = total;
        if ("HARD".equalsIgnoreCase(type))   hardCount   = total;
    }
    rsCount.close();

    boolean easyDone   = easyCount   >= 5;
    boolean normalDone = normalCount >= 5;
    boolean hardDone   = hardCount   >= 5;

    int easyPct   = Math.min(easyCount   * 20, 100);
    int normalPct = Math.min(normalCount * 20, 100);
    int hardPct   = Math.min(hardCount   * 20, 100);
%>

<!-- ===== HTML ===== -->
<div class="ql-wrap">
  <div class="ql-title">Select Quiz Level</div>
  <div class="ql-sub">Choose a difficulty level to add or edit quiz questions</div>

  <div class="ql-level-grid">

    <!-- EASY -->
    <div class="ql-level-card ql-easy">
      <div class="ql-icon-wrap">🎯</div>
      <div class="ql-level-title">Beginner Level</div>
      <div class="ql-progress-wrap">
        <div class="ql-progress-bar" data-width="<%= easyPct %>%" style="width:0%"></div>
      </div>
      <div class="ql-progress-txt"><%= easyCount %> / 5 questions</div>
      <% if (easyDone) { %>
        <span class="ql-completed-badge">Completed</span>
      <% } else { %>
        <span class="ql-pending-badge"><%= easyCount == 0 ? "Not Started" : "In Progress" %></span>
      <% } %>
      <a href="<%= easyDone ? "Edit_Quiz.jsp?course_id="+courseId+"&quiz_type=EASY"
                            : "Teacher_Add_Quiz.jsp?course_id="+courseId+"&quiz_type=EASY" %>"
         class="ql-action-btn <%= easyDone ? "ql-btn-edit" : "ql-btn-add" %>">
        <% if (easyDone) { %>
          <svg viewBox="0 0 20 20" fill="currentColor"><path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z"/></svg>
          Edit Questions
        <% } else { %>
          <svg viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd"/></svg>
          Add Questions
        <% } %>
      </a>
    </div>

    <!-- NORMAL -->
    <div class="ql-level-card ql-normal">
      <div class="ql-icon-wrap">⚡</div>
      <div class="ql-level-title">Intermediate Level</div>
      <div class="ql-progress-wrap">
        <div class="ql-progress-bar" data-width="<%= normalPct %>%" style="width:0%"></div>
      </div>
      <div class="ql-progress-txt"><%= normalCount %> / 5 questions</div>
      <% if (normalDone) { %>
        <span class="ql-completed-badge">Completed</span>
      <% } else { %>
        <span class="ql-pending-badge"><%= normalCount == 0 ? "Not Started" : "In Progress" %></span>
      <% } %>
      <a href="<%= normalDone ? "Edit_Quiz.jsp?course_id="+courseId+"&quiz_type=NORMAL"
                              : "Teacher_Add_Quiz.jsp?course_id="+courseId+"&quiz_type=NORMAL" %>"
         class="ql-action-btn <%= normalDone ? "ql-btn-edit" : "ql-btn-add" %>">
        <% if (normalDone) { %>
          <svg viewBox="0 0 20 20" fill="currentColor"><path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z"/></svg>
          Edit Questions
        <% } else { %>
          <svg viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd"/></svg>
          Add Questions
        <% } %>
      </a>
    </div>

    <!-- HARD -->
    <div class="ql-level-card ql-hard">
      <div class="ql-icon-wrap">📚</div>
      <div class="ql-level-title">Advanced Level</div>
      <div class="ql-progress-wrap">
        <div class="ql-progress-bar" data-width="<%= hardPct %>%" style="width:0%"></div>
      </div>
      <div class="ql-progress-txt"><%= hardCount %> / 5 questions</div>
      <% if (hardDone) { %>
        <span class="ql-completed-badge">Completed</span>
      <% } else { %>
        <span class="ql-pending-badge"><%= hardCount == 0 ? "Not Started" : "In Progress" %></span>
      <% } %>
      <a href="<%= hardDone ? "Edit_Quiz.jsp?course_id="+courseId+"&quiz_type=HARD"
                            : "Teacher_Add_Quiz.jsp?course_id="+courseId+"&quiz_type=HARD" %>"
         class="ql-action-btn <%= hardDone ? "ql-btn-edit" : "ql-btn-add" %>">
        <% if (hardDone) { %>
          <svg viewBox="0 0 20 20" fill="currentColor"><path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z"/></svg>
          Edit Questions
        <% } else { %>
          <svg viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd"/></svg>
          Add Questions
        <% } %>
      </a>
    </div>

  </div>
</div>

<!-- ===== JS: Animate progress bars on load ===== -->
<script>
  window.addEventListener('load', function () {
    document.querySelectorAll('.ql-progress-bar').forEach(function (bar) {
      var target = bar.getAttribute('data-width') || '0%';
      setTimeout(function () { bar.style.width = target; }, 100);
    });
  });
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



