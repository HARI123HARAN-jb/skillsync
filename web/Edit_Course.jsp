<%-- 
    Document   : Edit_Course
    Created on : 31-Mar-2026, 17:54:50
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
  :root {
    --primary:       #4f46e5;
    --primary-light: #eef2ff;
    --primary-dark:  #3730a3;
    --border:        #e5e7eb;
  }

  .page-wrapper {
    min-height: 100vh;
    display: flex;
    align-items: flex-start;
    justify-content: center;
    padding: 2.5rem 1rem;
    background: linear-gradient(135deg, #f0f4ff 0%, #faf5ff 100%);
  }

  /* ── Card ── */
  .edit-card {
    background: #fff;
    border-radius: 20px;
    box-shadow: 0 1px 3px rgba(0,0,0,.08), 0 8px 32px rgba(79,70,229,.08);
    padding: 2.5rem 2rem;
    width: 100%;
    max-width: 580px;
    border: 0.5px solid #e0e7ff;
    animation: slideUp .45s cubic-bezier(.22,.68,0,1.2) both;
  }

  @keyframes slideUp {
    from { opacity: 0; transform: translateY(28px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ── Header ── */
  .card-header-area {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 2rem;
    padding-bottom: 1.25rem;
    border-bottom: 1.5px solid #eef2ff;
  }
  .header-icon {
    width: 46px; height: 46px;
    border-radius: 12px;
    background: var(--primary-light);
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0;
  }
  .header-icon svg { width: 22px; height: 22px; }
  .card-header-area h2 { font-size: 20px; font-weight: 600; color: #1e1b4b; }
  .card-header-area p  { font-size: 13px; color: #6b7280; margin-top: 2px; }

  /* ── Form groups ── */
  .form-group { margin-bottom: 1.4rem; animation: fadeInRow .4s ease both; }
  .form-group:nth-child(1) { animation-delay: .05s; }
  .form-group:nth-child(2) { animation-delay: .10s; }
  .form-group:nth-child(3) { animation-delay: .15s; }
  .form-group:nth-child(4) { animation-delay: .20s; }

  @keyframes fadeInRow {
    from { opacity: 0; transform: translateX(-10px); }
    to   { opacity: 1; transform: translateX(0); }
  }

  .form-label {
    display: block;
    font-size: 13px; font-weight: 500;
    color: #374151; margin-bottom: 6px;
  }
  .form-label .required { color: #ef4444; margin-left: 3px; }

  .form-control {
    width: 100%; padding: 10px 14px;
    font-size: 14px;
    border: 1.5px solid var(--border);
    border-radius: 10px;
    color: #111827; background: #fafafa;
    outline: none; font-family: inherit;
    transition: border-color .2s, box-shadow .2s, background .2s;
  }
  .form-control:hover  { border-color: #c7d2fe; background: #fff; }
  .form-control:focus  { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79,70,229,.12); background: #fff; }
  textarea.form-control { resize: vertical; min-height: 100px; line-height: 1.6; }

  /* ── Image preview ── */
  .img-preview-section {
    display: flex; flex-direction: column; align-items: center; gap: 10px;
    background: #f9fafb;
    border: 1.5px dashed #d1d5db;
    border-radius: 14px; padding: 1.25rem;
    transition: border-color .2s;
  }
  .img-preview-section:hover { border-color: var(--primary); }
  .preview-img {
    width: 120px; height: 120px; object-fit: cover;
    border-radius: 12px; border: 2px solid #e0e7ff;
    cursor: zoom-in;
    transition: transform .3s ease, box-shadow .3s;
  }
  .preview-img:hover { transform: scale(1.05); box-shadow: 0 8px 24px rgba(79,70,229,.18); }
  .img-label-small { font-size: 12px; color: #9ca3af; }

  /* ── File input ── */
  .file-input-wrapper { position: relative; }
  .file-input-wrapper input[type="file"] {
    position: absolute; inset: 0; opacity: 0; cursor: pointer; z-index: 2;
  }
  .file-btn {
    display: flex; align-items: center; justify-content: center; gap: 8px;
    padding: 9px 16px; width: 100%;
    border: 1.5px solid var(--primary);
    border-radius: 10px; color: var(--primary);
    font-size: 13px; font-weight: 500;
    cursor: pointer; background: #fff;
    transition: background .2s;
  }
  .file-btn:hover { background: var(--primary-light); }
  .file-btn svg { width: 16px; height: 16px; }
  .file-name-display { font-size: 12px; color: #6b7280; margin-top: 6px; text-align: center; }

  /* ── Character counter ── */
  .char-counter { font-size: 11px; color: #9ca3af; text-align: right; margin-top: 4px; }
  .char-counter.warn { color: #f59e0b; }
  .char-counter.over  { color: #ef4444; }

  /* ── Submit button ── */
  .btn-submit {
    display: flex; align-items: center; justify-content: center; gap: 8px;
    width: 100%; padding: 12px;
    background: var(--primary); color: #fff;
    border: none; border-radius: 12px;
    font-size: 15px; font-weight: 600;
    cursor: pointer; letter-spacing: .01em;
    transition: background .2s, transform .15s, box-shadow .2s;
  }
  .btn-submit:hover  { background: var(--primary-dark); box-shadow: 0 4px 18px rgba(79,70,229,.28); transform: translateY(-1px); }
  .btn-submit:active { transform: scale(.98); }
  .btn-submit.loading { pointer-events: none; opacity: .8; }
  .spinner {
    width: 18px; height: 18px;
    border: 2px solid rgba(255,255,255,.35);
    border-top-color: #fff; border-radius: 50%;
    animation: spin .7s linear infinite; display: none;
  }
  .btn-submit.loading .spinner   { display: block; }
  .btn-submit.loading .btn-label { display: none; }
  @keyframes spin { to { transform: rotate(360deg); } }

  /* ── Success banner ── */
  .success-banner {
    display: none; align-items: center; gap: 10px;
    background: #ecfdf5; border: 1px solid #6ee7b7;
    border-radius: 10px; padding: 10px 14px;
    font-size: 13px; color: #065f46; margin-bottom: 1.2rem;
  }
  .success-banner.show { display: flex; animation: fadeInRow .3s ease; }

  /* ── Invalid course ── */
  .invalid-course-msg {
    display: flex; align-items: center; gap: 8px;
    padding: 12px 16px; background: #fef2f2;
    border: 1px solid #fca5a5; border-radius: 10px;
    color: #b91c1c; font-size: 14px; font-weight: 500;
    max-width: 400px; margin: 2rem auto;
  }
  .invalid-course-msg svg { width: 18px; height: 18px; flex-shrink: 0; }

  .divider { border: none; border-top: 1.5px solid #f3f4f6; margin: 1.5rem 0; }
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
if(courseId == null){
%>
    <div class="invalid-course-msg">
        <svg viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/></svg>
        Invalid Course
    </div>
<%
} else {
    ResultSet rs1 = db.Select("SELECT * FROM courses WHERE course_id='" + courseId + "'");
    String name1 = "", desc = "";
    if(rs1.next()){
        name1 = rs1.getString("course_name");
        desc  = rs1.getString("description");
    }
%>

<!-- ===== HTML ===== -->
<div class="page-wrapper">
  <div class="edit-card">

    <div class="success-banner" id="successBanner">
      <svg viewBox="0 0 20 20" fill="currentColor" style="width:18px;height:18px;flex-shrink:0">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
      </svg>
      Course updated successfully!
    </div>

    <div class="card-header-area">
      <div class="header-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/>
          <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/>
        </svg>
      </div>
      <div>
        <h2>Edit Course</h2>
        <p>Update your course details below</p>
      </div>
    </div>

    <form id="editCourseForm" action="Update_Course" method="post" enctype="multipart/form-data">
      <input type="hidden" name="course_id" value="<%= courseId %>">

      <!-- Course Name -->
      <div class="form-group">
        <label class="form-label">Course Name <span class="required">*</span></label>
        <input type="text" class="form-control" name="course_name"
               value="<%= name1 %>" required
               placeholder="Enter course name"
               maxlength="120" id="courseName">
        <div class="char-counter" id="nameCounter">0 / 120</div>
      </div>

      <!-- Description -->
      <div class="form-group">
        <label class="form-label">Description</label>
        <textarea class="form-control" name="description" rows="4"
                  placeholder="Describe what students will learn..."
                  maxlength="500" id="courseDesc"><%= desc %></textarea>
        <div class="char-counter" id="descCounter">0 / 500</div>
      </div>

      <!-- Current Image -->
      <div class="form-group">
        <label class="form-label">Current Image</label>
        <div class="img-preview-section">
          <img src="course_img.jsp?name=<%= courseId %>"
               alt="<%= name1 %>"
               class="preview-img"
               id="imagePreview"
               onerror="this.src='https://placehold.co/120x120/eef2ff/4f46e5?text=No+Image'">
          <span class="img-label-small">Click to zoom</span>
        </div>
      </div>

      <!-- Change Image -->
      <div class="form-group">
        <label class="form-label">Change Image</label>
        <div class="file-input-wrapper">
          <div class="file-btn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
              <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
            </svg>
            Upload new image
          </div>
          <input type="file" name="image" id="imageInput" accept="image/*">
        </div>
        <div class="file-name-display" id="fileNameDisplay">No file chosen</div>
      </div>

      <hr class="divider">

      <!-- Submit -->
      <button type="submit" class="btn-submit" id="submitBtn">
        <span class="btn-label">
          <svg viewBox="0 0 20 20" fill="currentColor" style="width:17px;height:17px">
            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
          </svg>
          Update Course
        </span>
        <div class="spinner"></div>
      </button>
    </form>

  </div>
</div>

<!-- ===== JAVASCRIPT ===== -->
<script>
  const nameInput      = document.getElementById('courseName');
  const descInput      = document.getElementById('courseDesc');
  const nameCounter    = document.getElementById('nameCounter');
  const descCounter    = document.getElementById('descCounter');
  const imageInput     = document.getElementById('imageInput');
  const imagePreview   = document.getElementById('imagePreview');
  const fileNameDisplay= document.getElementById('fileNameDisplay');
  const form           = document.getElementById('editCourseForm');
  const submitBtn      = document.getElementById('submitBtn');
  const successBanner  = document.getElementById('successBanner');

  /* Character counters */
  function updateCounter(input, counter, max) {
    const len = input.value.length;
    counter.textContent = len + ' / ' + max;
    counter.className = 'char-counter' +
      (len >= max ? ' over' : len > max * 0.9 ? ' warn' : '');
  }
  nameInput.addEventListener('input', () => updateCounter(nameInput, nameCounter, 120));
  descInput.addEventListener('input', () => updateCounter(descInput, descCounter, 500));
  updateCounter(nameInput, nameCounter, 120);
  updateCounter(descInput, descCounter, 500);

  /* Live image preview on file select */
  imageInput.addEventListener('change', function() {
    const file = this.files[0];
    if (!file) return;
    fileNameDisplay.textContent = file.name;
    const reader = new FileReader();
    reader.onload = e => {
      imagePreview.style.opacity   = '0';
      imagePreview.style.transform = 'scale(0.9)';
      imagePreview.style.transition= 'opacity .25s, transform .25s';
      setTimeout(() => {
        imagePreview.src             = e.target.result;
        imagePreview.style.opacity   = '1';
        imagePreview.style.transform = 'scale(1)';
      }, 200);
    };
    reader.readAsDataURL(file);
  });

  /* Loading spinner on submit */
  form.addEventListener('submit', function() {
    submitBtn.classList.add('loading');
    submitBtn.disabled = true;
    /* Remove these lines if you want real form submission to proceed:
    e.preventDefault();
    setTimeout(() => { ... }, 1600);
    */
  });

  /* Zoom image on click */
  imagePreview.addEventListener('click', () => {
    const w = window.open('');
    w.document.write(
      '<body style="margin:0;background:#000;display:flex;align-items:center;justify-content:center;min-height:100vh">' +
      '<img src="' + imagePreview.src + '" style="max-width:90vw;max-height:90vh;border-radius:8px"></body>'
    );
    w.document.close();
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