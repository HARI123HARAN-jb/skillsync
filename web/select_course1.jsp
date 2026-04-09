<%-- 
    Document   : select_course1
    Created on : 23-Sep-2025, 14:45:00
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
  * { box-sizing: border-box; margin: 0; padding: 0; }

  .sc-wrap {
    padding: 2.5rem 1rem;
    max-width: 1050px;
    margin: auto;
    font-family: system-ui, sans-serif;
    min-height: 100vh;
  }

  /* ── Headings ── */
  .sc-title {
    font-size: 22px; font-weight: 700; color: #1e1b4b;
    text-align: center; margin-bottom: .35rem;
    animation: sc-down .4s ease both;
  }

  .sc-sub {
    text-align: center; font-size: 13px; color: #6b7280;
    margin-bottom: .85rem;
    animation: sc-down .4s .06s ease both;
  }

  /* ── Search ── */
  .sc-search-wrap {
    max-width: 360px; margin: 0 auto 1.75rem;
    position: relative;
    animation: sc-down .4s .10s ease both;
  }

  .sc-search-wrap input {
    width: 100%;
    padding: 9px 14px 9px 38px;
    font-size: 13px;
    border: 1.5px solid #e0e7ff;
    border-radius: 50px;
    outline: none; background: #fff;
    font-family: inherit; color: #111827;
    transition: border-color .2s, box-shadow .2s;
  }

  .sc-search-wrap input:focus {
    border-color: #4f46e5;
    box-shadow: 0 0 0 3px rgba(79,70,229,.10);
  }

  .sc-search-icon {
    position: absolute; left: 12px;
    top: 50%; transform: translateY(-50%);
    width: 16px; height: 16px;
    color: #9ca3af; pointer-events: none;
  }

  /* ── Keyframes ── */
  @keyframes sc-down {
    from { opacity: 0; transform: translateY(-12px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes sc-up {
    from { opacity: 0; transform: translateY(24px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ── Count bar ── */
  .sc-count-bar {
    text-align: center; font-size: 13px; color: #6b7280;
    margin-bottom: 1.5rem;
    animation: sc-down .4s .12s ease both;
  }

  .sc-count-bar span { font-weight: 700; color: #4f46e5; }

  /* ── Grid ── */
  .sc-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 1.25rem;
  }

  /* ── Card ── */
  .sc-card {
    background: #fff;
    border: 0.5px solid #e0e7ff;
    border-radius: 18px;
    overflow: hidden;
    display: flex; flex-direction: column;
    animation: sc-up .45s cubic-bezier(.22,.68,0,1.2) both;
    transition: box-shadow .25s, transform .25s;
  }

  /* stagger delays */
  .sc-card:nth-child(1) { animation-delay: .04s; }
  .sc-card:nth-child(2) { animation-delay: .09s; }
  .sc-card:nth-child(3) { animation-delay: .14s; }
  .sc-card:nth-child(4) { animation-delay: .19s; }
  .sc-card:nth-child(5) { animation-delay: .24s; }
  .sc-card:nth-child(6) { animation-delay: .29s; }
  .sc-card:nth-child(7) { animation-delay: .34s; }
  .sc-card:nth-child(8) { animation-delay: .39s; }
  .sc-card:nth-child(9) { animation-delay: .44s; }

  .sc-card:hover {
    box-shadow: 0 8px 32px rgba(79,70,229,.13);
    transform: translateY(-4px);
  }

  .sc-card.sc-hidden { display: none; }

  /* ── Image ── */
  .sc-img-wrap {
    position: relative; width: 100%; height: 190px;
    overflow: hidden; background: #f1f0ff;
  }

  .sc-img-wrap img {
    width: 100%; height: 100%;
    object-fit: cover; display: block;
    transition: transform .4s ease;
  }

  .sc-card:hover .sc-img-wrap img { transform: scale(1.06); }

  .sc-overlay {
    position: absolute; inset: 0;
    background: linear-gradient(to bottom, transparent 40%, rgba(79,70,229,.48));
    opacity: 0; transition: opacity .3s;
    display: flex; align-items: flex-end;
    justify-content: center; padding-bottom: 14px;
  }

  .sc-card:hover .sc-overlay { opacity: 1; }

  .sc-overlay-txt {
    color: #fff; font-size: 12px; font-weight: 600;
    display: flex; align-items: center; gap: 5px;
  }

  .sc-overlay-txt svg { width: 14px; height: 14px; }

  /* ── Body ── */
  .sc-body {
    padding: 1.1rem; flex: 1;
    display: flex; flex-direction: column; gap: 10px;
  }

  .sc-name {
    font-size: 15px; font-weight: 700; color: #1e1b4b;
    line-height: 1.35; text-align: center;
  }

  .sc-id-badge {
    display: inline-flex; align-items: center;
    justify-content: center;
    background: #f3f4f6; color: #6b7280;
    font-size: 11px; font-weight: 500;
    padding: 3px 10px; border-radius: 20px;
    margin: 0 auto;
  }

  /* ── Button ── */
  .sc-btn {
    display: flex; align-items: center;
    justify-content: center; gap: 7px;
    width: 100%; padding: 10px 0;
    border: none; border-radius: 10px;
    font-size: 13px; font-weight: 600;
    cursor: pointer; text-decoration: none;
    background: #4f46e5; color: #fff;
    transition: background .2s, transform .15s;
    margin-top: auto;
  }

  .sc-btn:hover  { background: #3730a3; }
  .sc-btn:active { transform: scale(.97); }
  .sc-btn svg    { width: 15px; height: 15px; flex-shrink: 0; }

  /* ── Empty state ── */
  .sc-empty {
    display: none; text-align: center;
    padding: 3rem 1rem; color: #9ca3af; font-size: 14px;
  }

  .sc-empty svg {
    width: 48px; height: 48px; color: #d1d5db;
    margin: 0 auto 12px; display: block;
  }
</style>
	
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


    <%
    ResultSet rs1 = db.Select("SELECT * FROM courses ORDER BY course_name ASC");

    /* count total for the display bar */
    java.util.List<String[]> courseList = new java.util.ArrayList<>();
    while (rs1.next()) {
        courseList.add(new String[]{
            rs1.getString("course_id"),
            rs1.getString("course_name")
        });
    }
    if (rs1 != null) rs1.close();
%>

<!-- ===== HTML ===== -->
<div class="sc-wrap">

  <div class="sc-title">Select a Course</div>
  <div class="sc-sub">Pick a course to manage its topics</div>

  <!-- Search -->
  <div class="sc-search-wrap">
    <svg class="sc-search-icon" viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd"
        d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
        clip-rule="evenodd"/>
    </svg>
    <input type="text" id="scSearch"
           placeholder="Search courses..."
           oninput="scFilter()">
  </div>

  <!-- Count bar -->
  <div class="sc-count-bar" id="scCountBar">
    Showing <span id="scVisCount"><%= courseList.size() %></span> courses
  </div>

  <!-- Grid -->
  <div class="sc-grid" id="scGrid">

<%
    for (String[] course : courseList) {
        String cId   = course[0];
        String cName = course[1];
        String nameLower = cName.toLowerCase();
%>

    <div class="sc-card" data-name="<%= nameLower %>">

      <!-- Image -->
      <div class="sc-img-wrap">
        <img src="course_img.jsp?name=<%= cId %>"
             alt="<%= cName %>"
             onerror="this.src='https://placehold.co/300x190/eef2ff/4f46e5?text=<%= java.net.URLEncoder.encode(cName,"UTF-8") %>'">
        <div class="sc-overlay">
          <div class="sc-overlay-txt">
            <svg viewBox="0 0 20 20" fill="currentColor">
              <path d="M10 12a2 2 0 100-4 2 2 0 000 4z"/>
              <path fill-rule="evenodd"
                d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10z"
                clip-rule="evenodd"/>
            </svg>
            View Topics
          </div>
        </div>
      </div>

      <!-- Body -->
      <div class="sc-body">
        <div class="sc-name"><%= cName %></div>
        <a href="chose_topic.jsp?course_id=<%= cId %>" class="sc-btn">
          <svg viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd"
              d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z"
              clip-rule="evenodd"/>
          </svg>
          Next
        </a>
      </div>

    </div>

<%
    }
%>

  </div>

  <!-- Empty state -->
  <div class="sc-empty" id="scEmpty">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
      <circle cx="11" cy="11" r="8"/>
      <path d="m21 21-4.35-4.35"/>
    </svg>
    No courses match your search.
  </div>

</div>

<!-- ===== JAVASCRIPT ===== -->
<script>
  function scFilter() {
    var q     = document.getElementById('scSearch').value.toLowerCase().trim();
    var cards = document.querySelectorAll('#scGrid .sc-card');
    var vis   = 0;

    cards.forEach(function (card) {
      var name = card.getAttribute('data-name') || '';
      if (name.indexOf(q) !== -1) {
        card.classList.remove('sc-hidden');
        vis++;
      } else {
        card.classList.add('sc-hidden');
      }
    });

    document.getElementById('scVisCount').textContent = vis;
    document.getElementById('scEmpty').style.display  = vis === 0 ? 'block' : 'none';
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

