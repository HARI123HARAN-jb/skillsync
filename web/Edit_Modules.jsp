<%-- 
    Document   : Edit_Modules
    Created on : 30-Mar-2026, 15:23:42
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

  .em-page-wrap {
    padding: 2.5rem 1rem;
    max-width: 820px;
    margin: auto;
    background: #f4f6fb;
    min-height: 100vh;
  }

  /* ── Page title ── */
  .em-page-title {
    font-size: 22px;
    font-weight: 700;
    color: #1e1b4b;
    text-align: center;
    margin-bottom: 2rem;
    animation: em-fadeDown .4s ease both;
  }

  @keyframes em-fadeDown {
    from { opacity: 0; transform: translateY(-14px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes em-slideUp {
    from { opacity: 0; transform: translateY(24px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes em-fadeIn {
    from { opacity: 0; }
    to   { opacity: 1; }
  }

  @keyframes em-spin {
    to { transform: rotate(360deg); }
  }

  /* ── Module card ── */
  .em-module-card {
    background: #fff;
    border: 0.5px solid #e0e7ff;
    border-radius: 16px;
    overflow: hidden;
    margin-bottom: 1.75rem;
    animation: em-slideUp .45s cubic-bezier(.22,.68,0,1.2) both;
  }

  .em-module-card:nth-child(1) { animation-delay: .05s; }
  .em-module-card:nth-child(2) { animation-delay: .12s; }
  .em-module-card:nth-child(3) { animation-delay: .19s; }
  .em-module-card:nth-child(4) { animation-delay: .26s; }

  .em-card-header {
    background: #4f46e5;
    padding: 14px 20px;
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .em-card-header-num {
    background: rgba(255,255,255,.18);
    color: #fff;
    font-size: 12px;
    font-weight: 600;
    padding: 3px 10px;
    border-radius: 20px;
    flex-shrink: 0;
  }

  .em-card-header h5 {
    color: #fff;
    font-size: 15px;
    font-weight: 600;
    margin: 0;
  }

  .em-card-body { padding: 1.5rem; }

  /* ── Form elements ── */
  .em-label {
    display: block;
    font-size: 13px;
    font-weight: 500;
    color: #374151;
    margin-bottom: 6px;
  }

  .em-label .req { color: #ef4444; margin-left: 2px; }

  .em-control {
    width: 100%;
    padding: 9px 13px;
    font-size: 14px;
    border: 1.5px solid #e5e7eb;
    border-radius: 10px;
    color: #111827;
    background: #fafafa;
    outline: none;
    font-family: inherit;
    transition: border-color .2s, box-shadow .2s, background .2s;
  }

  .em-control:hover  { border-color: #c7d2fe; background: #fff; }
  .em-control:focus  { border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79,70,229,.12); background: #fff; }

  .em-select {
    width: 100%;
    padding: 9px 13px;
    font-size: 14px;
    border: 1.5px solid #e5e7eb;
    border-radius: 10px;
    color: #111827;
    background: #fafafa;
    outline: none;
    font-family: inherit;
    transition: border-color .2s, box-shadow .2s;
  }

  .em-select:focus { border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79,70,229,.12); }

  .em-mb { margin-bottom: 1.1rem; }

  .em-opt-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
    margin-bottom: 10px;
  }

  /* ── Video & PDF ── */
  .em-current-badge {
    display: inline-block;
    background: #eef2ff;
    color: #3730a3;
    font-size: 11px;
    font-weight: 500;
    padding: 3px 10px;
    border-radius: 20px;
    margin-bottom: 8px;
  }

  .em-video-wrap {
    background: #f1f0ff;
    border: 1px solid #e0e7ff;
    border-radius: 12px;
    padding: 10px;
    margin-bottom: 8px;
  }

  .em-video-wrap video {
    width: 100%;
    max-width: 480px;
    height: 210px;
    border-radius: 8px;
    display: block;
    background: #000;
  }

  .em-pdf-box {
    width: 100%;
    height: 180px;
    border: 1px solid #e0e7ff;
    border-radius: 10px;
    display: block;
    background: #f9f9f9;
  }

  /* ── File button ── */
  .em-file-wrap { position: relative; margin-top: 8px; }

  .em-file-wrap input[type="file"] {
    position: absolute;
    inset: 0;
    opacity: 0;
    cursor: pointer;
    z-index: 2;
  }

  .em-file-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 9px 16px;
    width: 100%;
    border: 1.5px solid #4f46e5;
    border-radius: 10px;
    color: #4f46e5;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    background: #fff;
    transition: background .2s;
  }

  .em-file-btn:hover { background: #eef2ff; }
  .em-file-btn svg   { width: 15px; height: 15px; flex-shrink: 0; }
  .em-file-name      { font-size: 12px; color: #6b7280; margin-top: 5px; text-align: center; }

  /* ── Section divider & quiz ── */
  .em-divider { border: none; border-top: 1.5px solid #f3f4f6; margin: 1.25rem 0; }

  .em-section-title {
    font-size: 14px;
    font-weight: 600;
    color: #4f46e5;
    margin-bottom: 1rem;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .em-section-title svg { width: 16px; height: 16px; flex-shrink: 0; }

  .em-quiz-box {
    background: #f8f7ff;
    border: 1px solid #e0e7ff;
    border-radius: 12px;
    padding: 1rem 1.1rem;
    margin-bottom: 1rem;
    animation: em-fadeIn .35s ease both;
  }

  .em-quiz-label {
    font-size: 13px;
    font-weight: 600;
    color: #4338ca;
    margin-bottom: 8px;
    display: block;
  }

  /* ── Submit ── */
  .em-submit-wrap { text-align: center; padding: 1rem 0 .5rem; }

  .em-btn-submit {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 13px 2.5rem;
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

  .em-btn-submit:hover  { background: #3730a3; box-shadow: 0 4px 18px rgba(79,70,229,.28); transform: translateY(-1px); }
  .em-btn-submit:active { transform: scale(.98); }
  .em-btn-submit.loading { opacity: .8; pointer-events: none; }

  .em-spinner {
    width: 18px; height: 18px;
    border: 2px solid rgba(255,255,255,.35);
    border-top-color: #fff;
    border-radius: 50%;
    animation: em-spin .7s linear infinite;
    display: none;
  }

  .em-btn-submit.loading .em-spinner  { display: block; }
  .em-btn-submit.loading .em-btn-lbl  { display: none; }

  /* ── Success banner ── */
  .em-success-bar {
    display: none;
    align-items: center;
    gap: 10px;
    background: #ecfdf5;
    border: 1px solid #6ee7b7;
    border-radius: 10px;
    padding: 10px 16px;
    font-size: 13px;
    color: #065f46;
    margin-bottom: 1.2rem;
  }

  .em-success-bar.show { display: flex; animation: em-fadeIn .3s ease; }
  .em-success-bar svg  { width: 18px; height: 18px; flex-shrink: 0; }
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
    String topicId   = request.getParameter("topic_id");
    String course_id = request.getParameter("course_id");

    ResultSet rs1 = db.Select(
        "SELECT * FROM modules WHERE topic_id='" + topicId +
        "' AND course_id='" + course_id + "'"
    );
%>

<!-- ===== HTML ===== -->
<div class="em-page-wrap">

  <div class="em-page-title">Edit Topics</div>

  <div class="em-success-bar" id="emSuccessBar">
    <svg viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
    </svg>
    All modules updated successfully!
  </div>

  <form id="emModuleForm" action="Update_Modules" method="post" enctype="multipart/form-data">

    <input type="hidden" name="topic_id"  value="<%= topicId %>">
    <input type="hidden" name="course_id" value="<%= course_id %>">

<%
    int moduleCount = 0;
    int i = 1;

    while (rs1.next()) {
        String moduleId    = rs1.getString("modules_id");
        String moduleTitle = rs1.getString("module_title");
        String videoPath   = rs1.getString("video_path");
        String notesPath   = rs1.getString("notes_path");
        moduleCount++;
%>

    <!-- MODULE CARD -->
    <div class="em-module-card">

      <div class="em-card-header">
        <span class="em-card-header-num">Module</span>
        <h5>Topic <%= i %> &mdash; <%= moduleTitle %></h5>
      </div>

      <div class="em-card-body">

        <input type="hidden" name="module_id_<%= i %>" value="<%= moduleId %>">

        <!-- Title -->
        <div class="em-mb">
          <label class="em-label">Topic title <span class="req">*</span></label>
          <input type="text" class="em-control"
                 name="module_title_<%= i %>"
                 value="<%= moduleTitle %>" required>
        </div>

        <!-- Current Video -->
        <div class="em-mb">
          <span class="em-current-badge">Current video</span>
          <div class="em-video-wrap">
            <video controls preload="metadata"
                   controlsList="nodownload noremoteplayback">
              <source src="<%= videoPath %>" type="video/mp4">
              Your browser does not support the video tag.
            </video>
          </div>
          <div class="em-file-wrap">
            <div class="em-file-btn">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
                <polyline points="17 8 12 3 7 8"/>
                <line x1="12" y1="3" x2="12" y2="15"/>
              </svg>
              Change video
            </div>
            <input type="file" name="video_<%= i %>" accept="video/*"
                   onchange="emShowFile(this)">
          </div>
          <div class="em-file-name">No file chosen</div>
        </div>

        <!-- Current Notes -->
        <div class="em-mb">
          <span class="em-current-badge">Current notes</span>
          <embed src="<%= notesPath %>" class="em-pdf-box">
          <div class="em-file-wrap">
            <div class="em-file-btn">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/>
                <polyline points="14 2 14 8 20 8"/>
              </svg>
              Change notes PDF
            </div>
            <input type="file" name="notes_<%= i %>" accept=".pdf"
                   onchange="emShowFile(this)">
          </div>
          <div class="em-file-name">No file chosen</div>
        </div>

        <hr class="em-divider">

        <!-- Quiz Section -->
        <div class="em-section-title">
          <svg viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd"/>
          </svg>
          Quiz questions
        </div>

<%
        ResultSet qrs = db.Select("SELECT * FROM quiz WHERE module_id='" + moduleId + "'");
        int q = 1;
        while (qrs.next()) {
            String quizId     = qrs.getString("quiz_id");
            String correctAns = qrs.getString("correct_answer");
%>

        <div class="em-quiz-box">

          <input type="hidden" name="quiz_id_<%= i %>_<%= q %>" value="<%= quizId %>">

          <span class="em-quiz-label">Question <%= q %></span>

          <div class="em-mb">
            <input type="text" class="em-control"
                   name="q_<%= i %>_<%= q %>"
                   value="<%= qrs.getString("question") %>"
                   placeholder="Enter question..." required>
          </div>

          <div class="em-opt-grid">
            <input type="text" class="em-control"
                   name="q_<%= i %>_<%= q %>_a"
                   value="<%= qrs.getString("option_a") %>" placeholder="Option A">
            <input type="text" class="em-control"
                   name="q_<%= i %>_<%= q %>_b"
                   value="<%= qrs.getString("option_b") %>" placeholder="Option B">
            <input type="text" class="em-control"
                   name="q_<%= i %>_<%= q %>_c"
                   value="<%= qrs.getString("option_c") %>" placeholder="Option C">
            <input type="text" class="em-control"
                   name="q_<%= i %>_<%= q %>_d"
                   value="<%= qrs.getString("option_d") %>" placeholder="Option D">
          </div>

          <select class="em-select" name="q_<%= i %>_<%= q %>_correct">
            <option value="">Select correct answer</option>
            <option value="A" <%= "A".equals(correctAns) ? "selected" : "" %>>A</option>
            <option value="B" <%= "B".equals(correctAns) ? "selected" : "" %>>B</option>
            <option value="C" <%= "C".equals(correctAns) ? "selected" : "" %>>C</option>
            <option value="D" <%= "D".equals(correctAns) ? "selected" : "" %>>D</option>
          </select>

        </div>

<%
            q++;
        }
        qrs.close();
%>

        <input type="hidden" name="questionCount_<%= i %>" value="<%= q - 1 %>">

      </div>
    </div>

<%
        i++;
    }
%>

    <input type="hidden" name="moduleCount" value="<%= moduleCount %>">

    <div class="em-submit-wrap">
      <button type="submit" class="em-btn-submit" id="emSubmitBtn">
        <span class="em-btn-lbl">
          <svg viewBox="0 0 20 20" fill="currentColor" style="width:17px;height:17px">
            <path d="M7.707 10.293a1 1 0 10-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L11 11.586V6h5a2 2 0 012 2v7a2 2 0 01-2 2H4a2 2 0 01-2-2V8a2 2 0 012-2h5v5.586l-1.293-1.293z"/>
          </svg>
          Update all modules
        </span>
        <div class="em-spinner"></div>
      </button>
    </div>

  </form>
</div>

<!-- ===== JAVASCRIPT ===== -->
<script>
  function emShowFile(input) {
    var nameEl = input.parentElement.nextElementSibling;
    if (nameEl && nameEl.classList.contains('em-file-name') && input.files[0]) {
      nameEl.textContent = input.files[0].name;
    }
  }

  document.getElementById('emModuleForm').addEventListener('submit', function() {
    var btn = document.getElementById('emSubmitBtn');
    btn.classList.add('loading');
    btn.disabled = true;

    /* Remove the setTimeout block below for real form submission.
       It's only here to show the success banner in the preview. */
    var self = this;
    // self.submit(); // ← uncomment for real submit without the demo delay
  });

  /* Optional: show success banner after server redirects back.
     Set a URL parameter ?updated=1 in your servlet redirect, then check: */
  (function(){
    var params = new URLSearchParams(window.location.search);
    if (params.get('updated') === '1') {
      var bar = document.getElementById('emSuccessBar');
      bar.classList.add('show');
      setTimeout(function(){ bar.classList.remove('show'); }, 3500);
    }
  })();
</script>
        <br><br>
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



