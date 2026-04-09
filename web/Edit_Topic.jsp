<%-- 
    Document   : Edit_Topic
    Created on : 30-Mar-2026, 15:44:36
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

 
  <link rel="stylesheet" href="assets/css/teacher.css"/>
  <link rel="stylesheet" href="assets/css/teacher_navbar.css"/>
</head>

<body>	
    
    <style>
  * { box-sizing: border-box; margin: 0; padding: 0; }

  .et-wrap {
    padding: 2.5rem 1rem;
    max-width: 1000px;
    margin: auto;
    font-family: system-ui, sans-serif;
    min-height: 100vh;
  }

  /* ── Titles ── */
  .et-title {
    font-size: 22px;
    font-weight: 700;
    color: #1e1b4b;
    text-align: center;
    margin-bottom: .4rem;
    animation: et-down .4s ease both;
  }

  .et-subtitle {
    text-align: center;
    font-size: 13px;
    color: #6b7280;
    margin-bottom: 2rem;
    animation: et-down .4s .05s ease both;
  }

  /* ── Keyframes ── */
  @keyframes et-down {
    from { opacity: 0; transform: translateY(-12px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes et-up {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes et-fade {
    from { opacity: 0; }
    to   { opacity: 1; }
  }

  @keyframes et-spin {
    to { transform: rotate(360deg); }
  }

  /* ── Grid ── */
  .et-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 1.25rem;
    margin-bottom: 2rem;
  }

  /* ── Card ── */
  .et-card {
    background: #fff;
    border: 0.5px solid #e0e7ff;
    border-radius: 16px;
    padding: 1.25rem;
    animation: et-up .45s cubic-bezier(.22,.68,0,1.2) both;
    transition: box-shadow .25s, transform .25s;
  }

  .et-card:hover {
    box-shadow: 0 6px 28px rgba(79,70,229,.12);
    transform: translateY(-3px);
  }

  /* stagger delays — add more if you have more topics */
  .et-card:nth-child(1) { animation-delay: .04s; }
  .et-card:nth-child(2) { animation-delay: .09s; }
  .et-card:nth-child(3) { animation-delay: .14s; }
  .et-card:nth-child(4) { animation-delay: .19s; }
  .et-card:nth-child(5) { animation-delay: .24s; }
  .et-card:nth-child(6) { animation-delay: .29s; }

  .et-card-num {
    font-size: 11px;
    font-weight: 600;
    color: #7c3aed;
    background: #ede9fe;
    padding: 3px 10px;
    border-radius: 20px;
    display: inline-block;
    margin-bottom: 10px;
  }

  /* ── Image preview ── */
  .et-img-wrap {
    position: relative;
    width: 100%;
    height: 150px;
    border-radius: 10px;
    overflow: hidden;
    background: #f1f0ff;
    margin-bottom: 12px;
    border: 1px solid #e0e7ff;
    cursor: pointer;
  }

  .et-img-wrap img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    transition: transform .35s ease;
  }

  .et-img-wrap:hover img { transform: scale(1.05); }

  .et-img-overlay {
    position: absolute;
    inset: 0;
    background: rgba(79,70,229,.55);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity .25s;
    border-radius: 10px;
  }

  .et-img-wrap:hover .et-img-overlay { opacity: 1; }

  .et-overlay-txt {
    color: #fff;
    font-size: 12px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .et-overlay-txt svg { width: 16px; height: 16px; }

  /* ── Form elements ── */
  .et-label {
    display: block;
    font-size: 12px;
    font-weight: 500;
    color: #374151;
    margin-bottom: 5px;
  }

  .et-control {
    width: 100%;
    padding: 8px 12px;
    font-size: 13px;
    border: 1.5px solid #e5e7eb;
    border-radius: 9px;
    color: #111827;
    background: #fafafa;
    outline: none;
    font-family: inherit;
    transition: border-color .2s, box-shadow .2s, background .2s;
    margin-bottom: 6px;
  }

  .et-control:hover  { border-color: #c7d2fe; background: #fff; }
  .et-control:focus  { border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79,70,229,.12); background: #fff; }

  .et-counter {
    font-size: 11px;
    color: #9ca3af;
    text-align: right;
    margin-bottom: 8px;
    margin-top: -4px;
  }

  .et-counter.warn { color: #f59e0b; }
  .et-counter.over { color: #ef4444; }

  /* ── File button ── */
  .et-file-wrap { position: relative; }

  .et-file-wrap input[type="file"] {
    position: absolute;
    inset: 0;
    opacity: 0;
    cursor: pointer;
    z-index: 2;
  }

  .et-file-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 7px;
    padding: 8px 14px;
    border: 1.5px dashed #a5b4fc;
    border-radius: 9px;
    color: #4f46e5;
    font-size: 12px;
    font-weight: 500;
    cursor: pointer;
    background: #f8f7ff;
    transition: background .2s, border-color .2s;
  }

  .et-file-btn:hover { background: #eef2ff; border-color: #4f46e5; }
  .et-file-btn svg   { width: 14px; height: 14px; flex-shrink: 0; }

  .et-file-name {
    font-size: 11px;
    color: #9ca3af;
    margin-top: 4px;
    text-align: center;
  }

  .et-changed-badge {
    display: none;
    font-size: 11px;
    background: #d1fae5;
    color: #065f46;
    padding: 2px 9px;
    border-radius: 12px;
    font-weight: 500;
    margin-top: 4px;
    text-align: center;
  }

  .et-changed-badge.show {
    display: block;
    animation: et-fade .3s ease;
  }

  /* ── Submit ── */
  .et-submit-wrap { text-align: center; padding: .5rem 0 1rem; }

  .et-btn {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    padding: 12px 2.5rem;
    background: #4f46e5;
    color: #fff;
    border: none;
    border-radius: 12px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: background .2s, transform .15s, box-shadow .2s;
    letter-spacing: .01em;
  }

  .et-btn:hover  { background: #3730a3; box-shadow: 0 4px 18px rgba(79,70,229,.3); transform: translateY(-1px); }
  .et-btn:active { transform: scale(.98); }
  .et-btn.loading { opacity: .8; pointer-events: none; }

  .et-spinner {
    width: 17px; height: 17px;
    border: 2px solid rgba(255,255,255,.3);
    border-top-color: #fff;
    border-radius: 50%;
    animation: et-spin .7s linear infinite;
    display: none;
  }

  .et-btn.loading .et-spinner { display: block; }
  .et-btn.loading .et-lbl     { display: none; }

  /* ── Success banner ── */
  .et-success {
    display: none;
    align-items: center;
    gap: 10px;
    background: #ecfdf5;
    border: 1px solid #6ee7b7;
    border-radius: 10px;
    padding: 10px 16px;
    font-size: 13px;
    color: #065f46;
    margin-bottom: 1.4rem;
  }

  .et-success.show { display: flex; animation: et-fade .3s ease; }
  .et-success svg  { width: 17px; height: 17px; flex-shrink: 0; }
</style>
	<!-- PRELOADER -->
<div id="preloader">
  <div class="pre-logo">SkillSync</div>
  <div class="pre-dots"><span></span><span></span><span></span></div>
</div>
        
 <%
        Integer id = (Integer) session.getAttribute("teacher_id");
        String name = (String) session.getAttribute("teacher_mail");

        if (id != null && name != null) {
            try {
                DbConnection db = new DbConnection();
                ResultSet rs = db.Select("SELECT * FROM teacher_register WHERE teacher_id='" + id + "' AND teacher_mail='" + name + "'");
                if (rs.next()) {
                    String teacher_name = rs.getString("teacher_name"); 
    %>
	<!--====== HEADER ======-->
	<!-- ══════════════════════════════════════
     NAVBAR HTML
══════════════════════════════════════ -->
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
        <div class="teacher-avatar" id="teacherAvatar"><img src="teacher_img.jsp?name=<%= id%>" class="card-img" style="width:30px;height: 30px;border-radius: 50%;" alt="Profile Picture"></div>
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
        
 <% String msg = (String) session.getAttribute("msg");
            if (msg != null) {
        %>
        <script> alert("<%=msg%>");</script>
        <% }
        session.removeAttribute("msg");%> 
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
            <img src="assets/images/image7.jpg" alt="Teacher">
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
    String courseId = request.getParameter("course_id");
    ResultSet rs1 = db.Select("SELECT * FROM topics WHERE course_id='" + courseId + "'");
%>

<!-- ===== HTML ===== -->
<div class="et-wrap">

  <div class="et-title">Edit Modules</div>
  <div class="et-subtitle">Update module titles and images</div>

  <div class="et-success" id="etSuccess">
    <svg viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
    </svg>
    All modules updated successfully!
  </div>

  <form id="etForm" action="Update_Topic" method="post" enctype="multipart/form-data">
    <input type="hidden" name="course_id" value="<%= courseId %>">

    <div class="et-grid">

<%
      int i = 0;
      while (rs1.next()) {
          String topicId = rs1.getString("topic_id");
          String topicTitle = rs1.getString("topic_title");
          int topicNum = i + 1;
%>

      <!-- TOPIC CARD -->
      <div class="et-card">

        <span class="et-card-num">Module <%= topicNum %></span>

        <!-- Image (click triggers file input) -->
        <div class="et-img-wrap" onclick="document.getElementById('file_<%= i %>').click()">
          <img src="topic_img.jsp?name=<%= topicId %>"
               id="preview_<%= i %>"
               alt="<%= topicTitle %>"
               onerror="this.src='https://placehold.co/300x150/eef2ff/4f46e5?text=Topic+<%= topicNum %>'">
          <div class="et-img-overlay">
            <div class="et-overlay-txt">
              <svg viewBox="0 0 20 20" fill="currentColor">
                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z"/>
              </svg>
              Click to change
            </div>
          </div>
        </div>

        <!-- Title -->
        <label class="et-label">Module title</label>
        <input type="text"
               class="et-control"
               name="topic_title[]"
               id="title_<%= i %>"
               value="<%= topicTitle %>">
       

        <!-- File input -->
        <div class="et-file-wrap">
          <div class="et-file-btn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
              <polyline points="17 8 12 3 7 8"/>
              <line x1="12" y1="3" x2="12" y2="15"/>
            </svg>
            Change image
          </div>
          <input type="file"
                 id="file_<%= i %>"
                 name="image_<%= i %>"
                 accept="image/*"
                 onchange="etPreview(this,'preview_<%= i %>',<%= i %>)">
        </div>
        <div class="et-file-name" id="fname_<%= i %>">No file chosen</div>
        <div class="et-changed-badge" id="badge_<%= i %>">Image updated</div>

        <input type="hidden" name="topic_id[]" value="<%= topicId %>">

      </div>
      <!-- END TOPIC CARD -->

<%
          i++;
      }
%>

    </div>

    <div class="et-submit-wrap">
      <button type="submit" class="et-btn" id="etBtn">
        <span class="et-lbl">
          <svg viewBox="0 0 20 20" fill="currentColor" style="width:16px;height:16px">
            <path d="M7.707 10.293a1 1 0 10-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L11 11.586V6h5a2 2 0 012 2v7a2 2 0 01-2 2H4a2 2 0 01-2-2V8a2 2 0 012-2h5v5.586l-1.293-1.293z"/>
          </svg>
          Update all
        </span>
        <div class="et-spinner"></div>
      </button>
    </div>

  </form>
</div>

<!-- ===== JAVASCRIPT ===== -->
<script>
  /* Live image preview */
  function etPreview(input, previewId, idx) {
    var file = input.files[0];
    if (!file) return;

    document.getElementById('fname_' + idx).textContent = file.name;
    document.getElementById('badge_' + idx).classList.add('show');

    var reader = new FileReader();
    reader.onload = function(e) {
      var img = document.getElementById(previewId);
      img.style.opacity   = '0';
      img.style.transform = 'scale(.93)';
      img.style.transition= 'opacity .25s, transform .25s';
      setTimeout(function() {
        img.src             = e.target.result;
        img.style.opacity   = '1';
        img.style.transform = 'scale(1)';
      }, 200);
    };
    reader.readAsDataURL(file);
  }

  /* Character counter */
  function etCounter(idx) {
    var inp = document.getElementById('title_' + idx);
    var cnt = document.getElementById('counter_' + idx);
    if (!inp || !cnt) return;
    var len = inp.value.length, max = 80;
    cnt.textContent = len + ' / ' + max;
    cnt.className = 'et-counter' +
      (len >= max ? ' over' : len > max * 0.85 ? ' warn' : '');
  }

  /* Init counters on load */
  (function() {
    var inputs = document.querySelectorAll('[id^="title_"]');
    inputs.forEach(function(el) {
      var idx = el.id.replace('title_', '');
      etCounter(parseInt(idx));
    });

    /* Show success banner if redirected back with ?updated=1 */
    var p = new URLSearchParams(window.location.search);
    if (p.get('updated') === '1') {
      var bar = document.getElementById('etSuccess');
      bar.classList.add('show');
      setTimeout(function() { bar.classList.remove('show'); }, 3500);
    }
  })();

  /* Loading spinner on submit */
  document.getElementById('etForm').addEventListener('submit', function() {
    var btn = document.getElementById('etBtn');
    btn.classList.add('loading');
    btn.disabled = true;
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
	<!-- Back to top -->
<div class="back-top-btn" id="backTopBtn" onclick="window.scrollTo({top:0,behavior:'smooth'})">
  <i class="bi bi-arrow-up"></i>
</div>

	<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
     /* Preloader */
  window.addEventListener('load', () => {
    setTimeout(() => document.getElementById('preloader').classList.add('hide'), 900);
  });
  
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

</body>
</html>


