<%-- 
    Document   : Edit_Quiz
    Created on : 31-Mar-2026, 16:26:14
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

  .eq-wrap {
    padding: 2.5rem 1rem;
    max-width: 960px;
    margin: auto;
    font-family: system-ui, sans-serif;
    min-height: 100vh;
  }

  .eq-title {
    font-size: 22px; font-weight: 700; color: #1e1b4b;
    text-align: center; margin-bottom: .4rem;
    animation: eq-down .4s ease both;
  }

  .eq-sub {
    text-align: center; font-size: 13px; color: #6b7280;
    margin-bottom: 1.2rem;
    animation: eq-down .4s .06s ease both;
  }

  @keyframes eq-down {
    from { opacity: 0; transform: translateY(-12px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes eq-up {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes eq-fade {
    from { opacity: 0; }
    to   { opacity: 1; }
  }

  @keyframes eq-spin {
    to { transform: rotate(360deg); }
  }

  /* ── Level badge ── */
  .eq-level-badge {
    display: flex; align-items: center; justify-content: center;
    gap: 6px; padding: 5px 18px;
    border-radius: 20px; font-size: 13px; font-weight: 600;
    margin: 0 auto 1.75rem; width: fit-content;
  }

  .eq-badge-easy   { background: #d1fae5; color: #065f46; }
  .eq-badge-normal { background: #fef9c3; color: #854d0e; }
  .eq-badge-hard   { background: #fee2e2; color: #991b1b; }

  /* ── Success banner ── */
  .eq-success {
    display: none; align-items: center; gap: 10px;
    background: #ecfdf5; border: 1px solid #6ee7b7;
    border-radius: 10px; padding: 10px 16px;
    font-size: 13px; color: #065f46; margin-bottom: 1.2rem;
  }

  .eq-success.show { display: flex; animation: eq-fade .3s ease; }
  .eq-success svg  { width: 17px; height: 17px; flex-shrink: 0; }

  /* ── Quiz card grid ── */
  .eq-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 1.25rem;
    margin-bottom: 1.75rem;
  }

  .eq-card {
    background: #fff;
    border: 0.5px solid #e0e7ff;
    border-radius: 16px;
    overflow: hidden;
    animation: eq-up .45s cubic-bezier(.22,.68,0,1.2) both;
  }

  .eq-card:nth-child(1) { animation-delay: .04s; }
  .eq-card:nth-child(2) { animation-delay: .09s; }
  .eq-card:nth-child(3) { animation-delay: .14s; }
  .eq-card:nth-child(4) { animation-delay: .19s; }
  .eq-card:nth-child(5) { animation-delay: .24s; }

  .eq-card-header {
    background: #4f46e5;
    padding: 12px 16px;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .eq-card-header h5 { color: #fff; font-size: 14px; font-weight: 600; margin: 0; }

  .eq-q-num {
    background: rgba(255,255,255,.18);
    color: #fff;
    font-size: 11px; font-weight: 600;
    padding: 2px 9px; border-radius: 20px;
  }

  .eq-card-body { padding: 1.1rem; }

  /* ── Form elements ── */
  .eq-label {
    display: block; font-size: 12px; font-weight: 500;
    color: #374151; margin-bottom: 5px;
  }

  .eq-control {
    width: 100%; padding: 8px 12px; font-size: 13px;
    border: 1.5px solid #e5e7eb; border-radius: 9px;
    color: #111827; background: #fafafa;
    outline: none; font-family: inherit;
    transition: border-color .2s, box-shadow .2s, background .2s;
    margin-bottom: 10px;
  }

  .eq-control:hover  { border-color: #c7d2fe; background: #fff; }
  .eq-control:focus  { border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79,70,229,.12); background: #fff; }

  textarea.eq-control { resize: vertical; min-height: 68px; line-height: 1.5; margin-bottom: 4px; }

  .eq-char-c {
    font-size: 11px; text-align: right;
    color: #9ca3af; margin-bottom: 8px; margin-top: 0;
  }

  .eq-char-c.warn { color: #f59e0b; }
  .eq-char-c.over { color: #ef4444; }

  .eq-opt-grid {
    display: grid; grid-template-columns: 1fr 1fr;
    gap: 8px; margin-bottom: 10px;
  }

  .eq-opt-grid .eq-control { margin-bottom: 0; }

  .eq-select {
    width: 100%; padding: 8px 12px; font-size: 13px;
    border: 1.5px solid #e5e7eb; border-radius: 9px;
    color: #111827; background: #fafafa;
    outline: none; font-family: inherit;
    transition: border-color .2s, box-shadow .2s;
  }

  .eq-select:focus { border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79,70,229,.12); }

  /* ── Submit ── */
  .eq-submit-wrap { text-align: center; padding: .5rem 0; }

  .eq-btn {
    display: inline-flex; align-items: center; gap: 8px;
    padding: 12px 2.5rem;
    background: #10b981; color: #fff;
    border: none; border-radius: 12px;
    font-size: 15px; font-weight: 600;
    cursor: pointer;
    transition: background .2s, transform .15s, box-shadow .2s;
  }

  .eq-btn:hover  { background: #059669; box-shadow: 0 4px 18px rgba(16,185,129,.3); transform: translateY(-1px); }
  .eq-btn:active { transform: scale(.98); }
  .eq-btn.loading { opacity: .8; pointer-events: none; }

  .eq-spinner {
    width: 17px; height: 17px;
    border: 2px solid rgba(255,255,255,.3);
    border-top-color: #fff; border-radius: 50%;
    animation: eq-spin .7s linear infinite; display: none;
  }

  .eq-btn.loading .eq-spinner { display: block; }
  .eq-btn.loading .eq-lbl     { display: none; }

  /* ── Quiz type row ── */
  .eq-type-row {
    display: flex; align-items: center; justify-content: center;
    gap: 10px; margin-top: 1rem;
    font-size: 13px; color: #6b7280;
  }

  .eq-type-box {
    padding: 6px 18px;
    border: 1.5px solid #e5e7eb;
    border-radius: 8px; font-size: 13px;
    font-weight: 600; color: #374151;
    background: #f9fafb;
  }
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
    String quizType = request.getParameter("quiz_type");

    if (courseId == null || courseId.isEmpty()) {
%>
    <p style="color:red;text-align:center;padding:2rem;">
      Invalid course. <a href="Select_Quiz_Level.jsp">Go Back</a>
    </p>
<%
    } else {
        ResultSet rs1 = db.Select(
            "SELECT * FROM topic_quiz WHERE course_id='" + courseId +
            "' AND status='" + quizType + "'"
        );

        String levelLabel = "EASY".equals(quizType)   ? "Beginner"     :
                            "NORMAL".equals(quizType) ? "Intermediate" : "Advanced";

        String badgeClass  = "EASY".equals(quizType)   ? "eq-badge-easy"   :
                             "NORMAL".equals(quizType) ? "eq-badge-normal" : "eq-badge-hard";

        String levelIcon   = "EASY".equals(quizType)   ? "🎯" :
                             "NORMAL".equals(quizType) ? "⚡" : "📚";
        int i = 1;
%>


<!-- ===== HTML ===== -->
<div class="eq-wrap">

  <div class="eq-title">Edit Quiz Questions</div>
  <div class="eq-sub">Update all questions for the selected difficulty level</div>

  <div class="eq-level-badge <%= badgeClass %>">
    <%= levelIcon %> &nbsp;<%= levelLabel %> Level &nbsp;&middot;&nbsp; <%= quizType %>
  </div>

  <div class="eq-success" id="eqSuccess">
    <svg viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
    </svg>
    Quiz updated successfully!
  </div>

  <form id="eqForm" action="Update_Quiz" method="post">

    <input type="hidden" name="course_id" value="<%= courseId %>">
    <input type="hidden" name="status"    value="<%= quizType %>">

    <div class="eq-grid">

<%
      while (rs1.next()) {
          String correctAns = rs1.getString("correct_answer");
%>

      <div class="eq-card">

        <div class="eq-card-header">
          <span class="eq-q-num">Q<%= i %></span>
          <h5>Question <%= i %></h5>
        </div>

        <div class="eq-card-body">

          <input type="hidden" name="question_id_<%= i %>" value="<%= rs1.getString("question_id") %>">

          <!-- Question -->
          <label class="eq-label">Question text</label>
          <textarea class="eq-control"
                    name="question<%= i %>"
                    id="qt_<%= i %>"
                    rows="3"
                    required><%= rs1.getString("question") %></textarea>

          <!-- Options -->
          <div class="eq-opt-grid">
            <input type="text" class="eq-control"
                   name="option<%= i %>_a"
                   value="<%= rs1.getString("option_a") %>"
                   placeholder="Option A">
            <input type="text" class="eq-control"
                   name="option<%= i %>_b"
                   value="<%= rs1.getString("option_b") %>"
                   placeholder="Option B">
            <input type="text" class="eq-control"
                   name="option<%= i %>_c"
                   value="<%= rs1.getString("option_c") %>"
                   placeholder="Option C">
            <input type="text" class="eq-control"
                   name="option<%= i %>_d"
                   value="<%= rs1.getString("option_d") %>"
                   placeholder="Option D">
          </div>

          <!-- Correct Answer -->
          <label class="eq-label">Correct answer</label>
          <select class="eq-select" name="answer<%= i %>">
            <option value="">Select</option>
            <option value="A" <%= "A".equals(correctAns) ? "selected" : "" %>>A</option>
            <option value="B" <%= "B".equals(correctAns) ? "selected" : "" %>>B</option>
            <option value="C" <%= "C".equals(correctAns) ? "selected" : "" %>>C</option>
            <option value="D" <%= "D".equals(correctAns) ? "selected" : "" %>>D</option>
          </select>

        </div>
      </div>

<%
          i++;
      }
%>

    </div>

    <input type="hidden" name="count" value="<%= i - 1 %>">

    <div class="eq-submit-wrap">
      <button type="submit" class="eq-btn" id="eqBtn">
        <span class="eq-lbl">
          <svg viewBox="0 0 20 20" fill="currentColor" style="width:16px;height:16px">
            <path d="M7.707 10.293a1 1 0 10-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L11 11.586V6h5a2 2 0 012 2v7a2 2 0 01-2 2H4a2 2 0 01-2-2V8a2 2 0 012-2h5v5.586l-1.293-1.293z"/>
          </svg>
          Update quiz
        </span>
        <div class="eq-spinner"></div>
      </button>
    </div>

    <div class="eq-type-row">
      <span>Quiz type:</span>
      <div class="eq-type-box"><%= quizType %></div>
    </div>

  </form>
</div>

<!-- ===== JAVASCRIPT ===== -->
<script>
  /* Character counter for each question textarea */
  function eqChar(n) {
    var ta = document.getElementById('qt_' + n);
    var cc = document.getElementById('eqcc_' + n);
    if (!ta || !cc) return;
    var len = ta.value.length, max = 300;
    cc.textContent = len + ' / ' + max;
    cc.className = 'eq-char-c' +
      (len >= max ? ' over' : len > max * 0.85 ? ' warn' : '');
  }

  /* Init all counters on page load */
  (function () {
    document.querySelectorAll('[id^="qt_"]').forEach(function (el) {
      var n = parseInt(el.id.replace('qt_', ''));
      eqChar(n);
    });

    /* Show success banner if redirected with ?updated=1 */
    var p = new URLSearchParams(window.location.search);
    if (p.get('updated') === '1') {
      var s = document.getElementById('eqSuccess');
      s.classList.add('show');
      setTimeout(function () { s.classList.remove('show'); }, 3500);
    }
  })();

  /* Loading spinner on submit */
  document.getElementById('eqForm').addEventListener('submit', function () {
    var btn = document.getElementById('eqBtn');
    btn.classList.add('loading');
    btn.disabled = true;
  });
</script>

<%
    }
%>

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