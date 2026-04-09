<%-- 
    Document   : View_Course
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
   /* ══════════════════════════════════════
       TOOLBAR
    ══════════════════════════════════════ */
    .toolbar-wrap {
      background: var(--ivory); border-bottom: 1px solid var(--border);
      box-shadow: var(--shadow-sm);
      position: sticky; top: var(--nav-h); z-index: 200;
    }
    .toolbar {
      max-width: 1280px; margin: 0 auto;
      padding: 12px 28px;
      display: flex; align-items: center; justify-content: space-between;
      gap: 14px; flex-wrap: wrap;
    }
    .toolbar-left  { display: flex; align-items: center; gap: 10px; }
    .toolbar-right { display: flex; align-items: center; gap: 10px; }

    /* Search */
    .search-wrap { position: relative; }
    .search-wrap input {
      padding: 9px 16px 9px 38px; border: 1.5px solid var(--border); border-radius: 100px;
      font-family: var(--font-body); font-size: .86rem; font-weight: 500;
      background: var(--cream2); color: var(--charcoal); outline: none; width: 260px;
      transition: border-color .2s, box-shadow .2s, background .2s;
    }
    .search-wrap input:focus { border-color: var(--teal); background: #fff; box-shadow: 0 0 0 3px var(--teal-ring); }
    .search-wrap i { position: absolute; left: 13px; top: 50%; transform: translateY(-50%); color: var(--stone); font-size: .85rem; pointer-events: none; }

    /* Filter tabs */
    .filter-tabs { display: flex; gap: 6px; }
    .ftab {
      padding: 7px 16px; border-radius: 100px;
      font-size: .82rem; font-weight: 600;
      border: 1.5px solid var(--border); background: var(--ivory); color: var(--stone);
      cursor: pointer; transition: background .2s, color .2s, border-color .2s;
    }
    .ftab:hover { border-color: var(--teal); color: var(--teal); }
    .ftab.active { background: var(--teal); color: #fff; border-color: var(--teal); box-shadow: 0 2px 10px rgba(13,148,136,.28); }

    /* View toggle */
    .view-toggle { display: flex; gap: 4px; }
    .vbtn {
      width: 36px; height: 36px; border-radius: 10px;
      border: 1.5px solid var(--border); background: var(--ivory);
      display: flex; align-items: center; justify-content: center;
      font-size: .9rem; color: var(--stone); cursor: pointer;
      transition: background .2s, color .2s, border-color .2s;
    }
    .vbtn:hover { border-color: var(--teal); color: var(--teal); }
    .vbtn.active { background: var(--teal); color: #fff; border-color: var(--teal); }

    .btn-add-course {
      background: var(--teal); color: #fff;
      padding: 9px 20px; border-radius: 100px;
      font-family: var(--font-body); font-size: .84rem; font-weight: 700;
      border: none; cursor: pointer;
      display: flex; align-items: center; gap: 7px;
      box-shadow: 0 2px 10px rgba(13,148,136,.28);
      transition: background .2s, transform .15s, box-shadow .2s;
    }
    .btn-add-course:hover { background: var(--teal-dark); transform: translateY(-1px); box-shadow: 0 4px 16px rgba(13,148,136,.38); color: #fff; }

    /* ══════════════════════════════════════
       MAIN CONTENT
    ══════════════════════════════════════ */
    .main-content {
      max-width: 1280px; margin: 0 auto;
      padding: 36px 28px 80px;
    }

    /* Results label */
    .results-row {
      display: flex; align-items: center; justify-content: space-between;
      margin-bottom: 20px; flex-wrap: wrap; gap: 10px;
    }
    .results-label { font-size: .82rem; font-weight: 600; color: var(--stone); }
    .results-label strong { color: var(--teal); }

    /* ══════════════════════════════════════
       COURSE CARD (Grid view)
    ══════════════════════════════════════ */
    .courses-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 22px;
    }
    .courses-list { display: flex; flex-direction: column; gap: 14px; }

    /* GRID card */
    .course-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: var(--r-lg);
      overflow: hidden;
      opacity: 0; transform: translateY(20px) scale(.97);
      transition: box-shadow .3s, transform .3s, border-color .3s;
      display: flex; flex-direction: column;
    }
    .course-card.visible { animation: cardIn .5s ease forwards; }
    @keyframes cardIn { from{opacity:0;transform:translateY(20px) scale(.97)} to{opacity:1;transform:translateY(0) scale(1)} }
    .course-card:hover { box-shadow: var(--shadow-lg); transform: translateY(-5px); border-color: rgba(13,148,136,.30); }

    /* thumbnail */
    .c-thumb {
      position: relative; height: 185px; overflow: hidden;
      background: var(--cream2);
    }
    .c-thumb img { width: 100%; height: 100%; object-fit: cover; transition: transform .5s ease; }
    .course-card:hover .c-thumb img { transform: scale(1.06); }
    .c-thumb-overlay {
      position: absolute; inset: 0;
      background: linear-gradient(180deg, transparent 45%, rgba(15,118,110,.65) 100%);
      opacity: 0; transition: opacity .3s;
    }
    .course-card:hover .c-thumb-overlay { opacity: 1; }

    /* status badge on thumb */
    .c-status {
      position: absolute; top: 12px; left: 12px;
      padding: 4px 12px; border-radius: 100px;
      font-size: .68rem; font-weight: 700;
      text-transform: uppercase; letter-spacing: .05em;
      backdrop-filter: blur(8px);
    }
    .status-approved { background: rgba(34,197,94,.18); color: #15803d; border: 1px solid rgba(34,197,94,.28); }
    .status-pending  { background: rgba(251,191,36,.18); color: #92400e; border: 1px solid rgba(251,191,36,.28); }
    .status-rejected { background: rgba(239,68,68,.15);  color: #991b1b; border: 1px solid rgba(239,68,68,.28); }
    .status-default  { background: rgba(120,113,108,.15); color: #57534e; border: 1px solid rgba(120,113,108,.22); }

    /* course ID chip */
    .c-id-chip {
      position: absolute; top: 12px; right: 12px;
      background: rgba(26,26,26,.65); color: #fff;
      padding: 3px 10px; border-radius: 100px;
      font-size: .68rem; font-weight: 700;
      backdrop-filter: blur(4px);
    }

    /* card body */
    .c-body { padding: 18px 20px 20px; display: flex; flex-direction: column; flex: 1; }
    .c-title {
      font-family: var(--font-display);
      font-size: 1.1rem; font-weight: 600; color: var(--charcoal);
      margin-bottom: 8px; line-height: 1.3;
    }
    .c-desc {
      font-size: .86rem; color: var(--stone); line-height: 1.65; margin-bottom: 16px; flex: 1;
      display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
    }

    /* status indicator row */
    .c-meta { display: flex; align-items: center; gap: 8px; margin-bottom: 16px; }
    .c-status-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
    .dot-approved { background: var(--green); }
    .dot-pending  { background: var(--amber); }
    .dot-rejected { background: var(--red); }
    .dot-default  { background: var(--stone); }
    .c-status-text { font-size: .78rem; font-weight: 700; }
    .text-approved { color: var(--green); }
    .text-pending  { color: var(--amber); }
    .text-rejected { color: var(--red); }
    .text-default  { color: var(--stone); }

    /* card actions */
    .c-actions { display: flex; gap: 8px; padding-top: 14px; border-top: 1px solid var(--border); }
    .btn-action {
      flex: 1; padding: 9px 12px; border-radius: 100px; border: 1.5px solid var(--border);
      font-family: var(--font-body); font-size: .82rem; font-weight: 700;
      cursor: pointer; background: none; color: var(--slate);
      display: flex; align-items: center; justify-content: center; gap: 6px;
      transition: background .2s, color .2s, border-color .2s, transform .15s;
    }
    .btn-action:hover { transform: translateY(-1px); }
    .btn-action.edit:hover    { border-color: var(--teal); color: var(--teal); background: var(--teal-pale); }
    .btn-action.delete        { border-color: rgba(239,68,68,.28); color: var(--red); }
    .btn-action.delete:hover  { background: var(--red-pale); border-color: var(--red); }

    /* ══════════════════════════════════════
       LIST VIEW CARD
    ══════════════════════════════════════ */
    .course-list-card {
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: var(--r); padding: 18px 22px;
      display: flex; align-items: center; gap: 18px;
      opacity: 0; transform: translateX(-10px);
      transition: box-shadow .25s, border-color .25s, transform .25s;
    }
    .course-list-card.visible { animation: listIn .4s ease forwards; }
    @keyframes listIn { from{opacity:0;transform:translateX(-10px)} to{opacity:1;transform:translateX(0)} }
    .course-list-card:hover { box-shadow: var(--shadow-md); border-color: rgba(13,148,136,.28); }
    .list-img {
      width: 72px; height: 72px; border-radius: 14px; overflow: hidden;
      flex-shrink: 0; border: 1px solid var(--border);
    }
    .list-img img { width: 100%; height: 100%; object-fit: cover; }
    .list-info { flex: 1; min-width: 0; }
    .list-title { font-family: var(--font-display); font-size: 1rem; font-weight: 600; color: var(--charcoal); margin-bottom: 4px; }
    .list-desc  { font-size: .82rem; color: var(--stone); line-height: 1.5; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .list-meta  { display: flex; align-items: center; gap: 12px; }
    .list-actions { display: flex; gap: 8px; flex-shrink: 0; }

    /* ══════════════════════════════════════
       EMPTY STATE
    ══════════════════════════════════════ */
    .empty-state {
      text-align: center; padding: 80px 24px;
      display: none;
    }
    .empty-state.show { display: block; animation: fadeUp .4s ease both; }
    .empty-icon { font-size: 3.5rem; margin-bottom: 16px; }
    .empty-state h4 { font-family: var(--font-display); font-size: 1.5rem; font-weight: 600; margin-bottom: 10px; }
    .empty-state p  { font-size: .92rem; color: var(--stone); margin-bottom: 24px; }

    /* ══════════════════════════════════════
       DELETE CONFIRM MODAL
    ══════════════════════════════════════ */
    .modal-overlay {
      position: fixed; inset: 0; z-index: 800;
      background: rgba(26,26,26,.55);
      backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px);
      display: none; align-items: center; justify-content: center; padding: 20px;
    }
    .modal-overlay.open { display: flex; }
    .modal-box {
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: 22px; max-width: 420px; width: 100%;
      box-shadow: var(--shadow-lg);
      animation: popIn .3s cubic-bezier(.34,1.25,.64,1) both;
      overflow: hidden;
    }
    @keyframes popIn { from{opacity:0;transform:scale(.88) translateY(16px)} to{opacity:1;transform:scale(1) translateY(0)} }
    .modal-header {
      background: linear-gradient(135deg, var(--red), #f87171);
      padding: 22px 26px 18px;
      display: flex; align-items: flex-start; justify-content: space-between;
    }
    .modal-header h3 { font-family: var(--font-display); font-size: 1.3rem; font-weight: 600; color: #fff; margin-bottom: 3px; }
    .modal-header p  { font-size: .82rem; color: rgba(255,255,255,.80); }
    .modal-x { background: rgba(255,255,255,.2); border: none; width: 32px; height: 32px; border-radius: 9px; color: #fff; font-size: .9rem; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background .2s; flex-shrink: 0; }
    .modal-x:hover { background: rgba(255,255,255,.32); }
    .modal-body { padding: 22px 26px; }
    .modal-course-preview {
      background: var(--cream2); border: 1px solid var(--border);
      border-radius: 12px; padding: 14px 16px;
      margin-bottom: 20px;
      display: flex; align-items: center; gap: 12px;
    }
    .modal-course-preview img { width: 48px; height: 48px; border-radius: 10px; object-fit: cover; flex-shrink: 0; }
    .modal-course-name { font-size: .9rem; font-weight: 700; color: var(--charcoal); }
    .modal-course-desc { font-size: .78rem; color: var(--stone); }
    .modal-warn { font-size: .87rem; color: var(--slate); line-height: 1.65; margin-bottom: 22px; }
    .modal-warn strong { color: var(--red); }
    .modal-actions { display: flex; gap: 10px; }
    .btn-modal-cancel {
      flex: 1; padding: 11px; border-radius: 100px;
      border: 1.5px solid var(--border); background: none;
      font-family: var(--font-body); font-size: .9rem; font-weight: 700;
      color: var(--stone); cursor: pointer;
      transition: border-color .2s, color .2s;
    }
    .btn-modal-cancel:hover { border-color: var(--charcoal); color: var(--charcoal); }
    .btn-modal-delete {
      flex: 1; padding: 11px; border-radius: 100px;
      background: var(--red); color: #fff; border: none;
      font-family: var(--font-body); font-size: .9rem; font-weight: 700;
      cursor: pointer;
      box-shadow: 0 3px 12px rgba(239,68,68,.35);
      transition: background .2s, transform .15s, box-shadow .2s;
    }
    .btn-modal-delete:hover { background: #dc2626; transform: translateY(-1px); box-shadow: 0 5px 18px rgba(239,68,68,.45); }

    /* ══════════════════════════════════════
       ANIMATIONS
    ══════════════════════════════════════ */
    @keyframes fadeUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }

    /* ══════════════════════════════════════
       BACK TO TOP
    ══════════════════════════════════════ */
    .back-top {
      position: fixed; bottom: 28px; right: 28px; z-index: 300;
      width: 44px; height: 44px; background: var(--teal); color: #fff;
      border-radius: 50%; display: flex; align-items: center; justify-content: center;
      font-size: .95rem; cursor: pointer;
      box-shadow: 0 4px 16px rgba(13,148,136,.40);
      opacity: 0; pointer-events: none; transition: opacity .3s, transform .2s;
    }
    .back-top.show { opacity: 1; pointer-events: all; }
    .back-top:hover { transform: translateY(-3px); }

    /* ══════════════════════════════════════
       RESPONSIVE
    ══════════════════════════════════════ */
    @media (max-width: 768px) {
      .filter-tabs { display: none; }
      .search-wrap input { width: 200px; }
      .page-banner { padding: 36px 20px 56px; }
      .main-content { padding: 24px 16px 60px; }
      .toolbar { padding: 10px 16px; }
    }
    @media (max-width: 480px) {
      .courses-grid { grid-template-columns: 1fr; }
      .search-wrap input { width: 160px; }
      .banner-stats { gap: 12px; }
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
                    
  int    totalCourses = 0;
try {
    DbConnection dbT = new DbConnection();
    ResultSet rsC = dbT.Select("SELECT COUNT(*) AS total FROM courses");
    if (rsC.next()) totalCourses = rsC.getInt("total");
    rsC.close();
    dbT.close();
  } catch (Exception e) { /* stats optional */ }
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
        <div class="teacher-avatar" id="teacherAvatar">T</div>
        <div class="teacher-chip-text">
          <span class="teacher-chip-name" id="teacherChipName">Teacher</span>
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
        
        <% String msg = (String) session.getAttribute("msg");
            if (msg != null) {
        %>
        <script> alert("<%=msg%>");</script>
        <% }
        session.removeAttribute("msg");%>
        <!-- ══ TOOLBAR ══ -->
<div class="toolbar-wrap">
  <div class="toolbar">
    <div class="toolbar-left">
      <div class="search-wrap">
        <i class="bi bi-search"></i>
        <input type="text" id="courseSearch" placeholder="Search courses…" autocomplete="off">
      </div>
      <div class="filter-tabs" id="filterTabs">
        <button class="ftab active" data-filter="all">All</button>
        <button class="ftab" data-filter="approved">Approved</button>
        <button class="ftab" data-filter="pending">Pending</button>
      </div>
    </div>
    <div class="toolbar-right">
      <div class="view-toggle">
        <button class="vbtn active" id="vGrid" onclick="setView('grid')" title="Grid view"><i class="bi bi-grid-3x2-gap"></i></button>
        <button class="vbtn" id="vList" onclick="setView('list')" title="List view"><i class="bi bi-list-ul"></i></button>
      </div>
      <a href="Add_Course.jsp" class="btn-add-course"><i class="bi bi-plus-circle"></i> New Course</a>
    </div>
  </div>
</div>
 <div class="main-content">

  <div class="results-row">
    <span class="results-label">Showing <strong id="visibleCount"><%= totalCourses %></strong> course<%= totalCourses != 1 ? "s" : "" %></span>
  </div>

  <!-- GRID VIEW -->
  <div id="gridView" class="courses-grid">
<%
  try {
    DbConnection db1 = new DbConnection();
    ResultSet rs1 = db1.Select("SELECT * FROM courses ORDER BY course_id DESC");

    int idx = 0;
    while (rs1.next()) {
      int    courseId   = rs1.getInt("course_id");
      String courseName = rs1.getString("course_name");
      String desc       = rs1.getString("description");
      String status     = rs1.getString("status");
      if (status == null) status = "";

      String statusClass, dotClass, textClass, statusLabel, statusIcon;
      String filterTag;
      if ("APPROVED".equalsIgnoreCase(status)) {
        statusClass = "status-approved"; dotClass = "dot-approved"; textClass = "text-approved";
        statusLabel = "Approved"; statusIcon = "bi-check-circle-fill"; filterTag = "approved";
      } else if (status.toUpperCase().contains("NOT") || "REJECTED".equalsIgnoreCase(status)) {
        statusClass = "status-rejected"; dotClass = "dot-rejected"; textClass = "text-rejected";
        statusLabel = "Rejected"; statusIcon = "bi-x-circle-fill"; filterTag = "pending";
      } else {
        statusClass = "status-pending"; dotClass = "dot-pending"; textClass = "text-pending";
        statusLabel = "Pending"; statusIcon = "bi-clock-fill"; filterTag = "pending";
      }

      String shortDesc = (desc != null && desc.length() > 90) ? desc.substring(0, 90) + "…" : (desc != null ? desc : "");
      idx++;
%>
    <div class="course-card" 
         data-filter="<%= filterTag %>"
         data-name="<%= courseName.toLowerCase() %>"
         style="animation-delay: <%= (idx * 80) %>ms">
      <div class="c-thumb">
        <img src="course_img.jsp?name=<%= courseId %>" alt="<%= courseName %>">
        <div class="c-thumb-overlay"></div>
        <span class="c-status <%= statusClass %>">
          <i class="bi <%= statusIcon %> me-1" style="font-size:.6rem;"></i><%= statusLabel %>
        </span>
        <span class="c-id-chip">#<%= courseId %></span>
      </div>
      <div class="c-body">
        <div class="c-title"><%= courseName %></div>
        <div class="c-desc"><%= shortDesc %></div>
        <div class="c-meta">
          <div class="c-status-dot <%= dotClass %>"></div>
          <span class="c-status-text <%= textClass %>"><i class="bi <%= statusIcon %> me-1" style="font-size:.7rem;"></i><%= statusLabel %></span>
        </div>
        <div class="c-actions">
            <button class="btn-action edit" onclick="location.href='Edit_Course.jsp?course_id=<%= courseId %>'">
          <i class="bi bi-pencil-square"></i>Edit
        </button>
          <button class="btn-action delete"
                  onclick="openDeleteModal('<%= courseId %>', '<%= courseName.replace("'","\\u0027") %>', '<%= shortDesc.replace("'","\\u0027") %>')">
            <i class="bi bi-trash3"></i> Delete
          </button>
        </div>
      </div>
    </div>
<%
    }
    rs1.close(); db1.close();
  } catch (Exception e) {
    out.println("<p style='color:var(--red);padding:20px;'>Error loading courses: " + e.getMessage() + "</p>");
  }
%>
  </div><!-- /gridView -->

  <!-- LIST VIEW -->
  <div id="listView" class="courses-list" style="display:none;">
<%
  try {
    DbConnection db2 = new DbConnection();
    ResultSet rs2 = db2.Select("SELECT * FROM courses ORDER BY course_id DESC");
    int idx2 = 0;
    while (rs2.next()) {
      int    cId   = rs2.getInt("course_id");
      String cName = rs2.getString("course_name");
      String cDesc = rs2.getString("description");
      String cStat = rs2.getString("status");
      if (cStat == null) cStat = "";

      String sDotCls, sTxtCls, sLbl, sIcon, fTag;
      if ("APPROVED".equalsIgnoreCase(cStat)) {
        sDotCls = "dot-approved"; sTxtCls = "text-approved"; sLbl = "Approved"; sIcon = "bi-check-circle-fill"; fTag = "approved";
      } else if (cStat.toUpperCase().contains("NOT") || "REJECTED".equalsIgnoreCase(cStat)) {
        sDotCls = "dot-rejected"; sTxtCls = "text-rejected"; sLbl = "Rejected"; sIcon = "bi-x-circle-fill"; fTag = "pending";
      } else {
        sDotCls = "dot-pending"; sTxtCls = "text-pending"; sLbl = "Pending"; sIcon = "bi-clock-fill"; fTag = "pending";
      }
      String sDesc = (cDesc != null && cDesc.length() > 100) ? cDesc.substring(0, 100) + "…" : (cDesc != null ? cDesc : "");
      idx2++;
%>
    <div class="course-list-card"
         data-filter="<%= fTag %>"
         data-name="<%= cName.toLowerCase() %>"
         style="animation-delay: <%= (idx2 * 55) %>ms">
      <div class="list-img">
        <img src="course_img.jsp?name=<%= cId %>" alt="<%= cName %>">
      </div>
      <div class="list-info">
        <div class="list-title"><%= cName %></div>
        <div class="list-desc"><%= sDesc %></div>
        <div class="list-meta">
          <div class="c-status-dot <%= sDotCls %>"></div>
          <span class="c-status-text <%= sTxtCls %>" style="font-size:.78rem;">
            <i class="bi <%= sIcon %> me-1" style="font-size:.65rem;"></i><%= sLbl %>
          </span>
          <span style="font-size:.75rem;color:var(--stone);font-weight:600;">#<%= cId %></span>
        </div>
      </div>
      <div class="list-actions">
        <button class="btn-action edit" onclick="location.href='Edit_Course.jsp?course_id=<%= cId %>'">
          <i class="bi bi-pencil-square"></i>Edit
        </button>
        <button class="btn-action delete"
                onclick="openDeleteModal('<%= cId %>', '<%= cName.replace("'","\\u0027") %>', '<%= sDesc.replace("'","\\u0027") %>')">
          <i class="bi bi-trash3"></i>
        </button>
      </div>
    </div>
<% 
    }
    rs2.close(); db2.close();
  } catch (Exception e) { /* errors shown in grid */ }
%>
  </div><!-- /listView -->

  <!-- Empty state -->
  <div class="empty-state" id="emptyState">
    <div class="empty-icon">📭</div>
    <h4>No Courses Found</h4>
    <p>Try a different search or filter, or create your first course.</p>
    <a href="Add_Course.jsp" style="background:var(--teal);color:#fff;padding:12px 28px;border-radius:100px;font-weight:700;font-size:.92rem;display:inline-flex;align-items:center;gap:8px;box-shadow:0 4px 14px rgba(13,148,136,.35);">
      <i class="bi bi-plus-circle"></i> Add New Course
    </a>
  </div>

</div><!-- /main-content -->

<!-- Back to top -->
<div class="back-top" id="backTop" onclick="window.scrollTo({top:0,behavior:'smooth'})">
  <i class="bi bi-arrow-up"></i>
</div>

<!-- ══ DELETE CONFIRM MODAL ══ -->
<div class="modal-overlay" id="deleteModal" onclick="handleModalOverlay(event)">
  <div class="modal-box">
    <div class="modal-header">
      <div>
        <h3>Delete Course</h3>
        <p>This action cannot be undone</p>
      </div>
      <button class="modal-x" onclick="closeDeleteModal()"><i class="bi bi-x-lg"></i></button>
    </div>
    <div class="modal-body">
      <div class="modal-course-preview">
        <img id="modalCourseImg" src="" alt="course">
        <div>
          <div class="modal-course-name" id="modalCourseName">Course Name</div>
          <div class="modal-course-desc" id="modalCourseDesc">Description</div>
        </div>
      </div>
      <p class="modal-warn">
        Are you sure you want to delete <strong id="modalCourseNameWarn">this course</strong>?
        All modules, topics, and quiz data associated with it will be
        <strong>permanently removed</strong>.
      </p>
      <div class="modal-actions">
        <button class="btn-modal-cancel" onclick="closeDeleteModal()"><i class="bi bi-x-circle me-1"></i>Cancel</button>
        <a id="deleteConfirmBtn" href="#" class="btn-modal-delete">
          <i class="bi bi-trash3 me-1"></i>Delete Course
        </a>
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
<script>
/* ── Navbar scroll + back-to-top ── */
var nav    = document.getElementById('skNav');
var backTop = document.getElementById('backTop');
window.addEventListener('scroll', function() {
  nav.classList.toggle('scrolled', window.scrollY > 20);
  backTop.classList.toggle('show', window.scrollY > 300);
}, { passive: true });

/* ── Card scroll reveal ── */
var currentView = 'grid';

function revealCards() {
  var selector = currentView === 'grid' ? '.course-card' : '.course-list-card';
  var cards = document.querySelectorAll(selector);
  var observer = new IntersectionObserver(function(entries) {
    entries.forEach(function(e) {
      if (e.isIntersecting) {
        e.target.classList.add('visible');
        observer.unobserve(e.target);
      }
    });
  }, { threshold: 0.08 });
  cards.forEach(function(c) { observer.observe(c); });
}
revealCards();

/* ── View toggle (grid / list) ── */
function setView(mode) {
  currentView = mode;
  document.getElementById('gridView').style.display = mode === 'grid' ? 'grid' : 'none';
  document.getElementById('listView').style.display = mode === 'list' ? 'flex' : 'none';
  document.getElementById('vGrid').classList.toggle('active', mode === 'grid');
  document.getElementById('vList').classList.toggle('active', mode === 'list');
  // re-reveal
  setTimeout(revealCards, 50);
  applyFilter();
}

/* ── Filter tabs ── */
var activeFilter = 'all';
document.querySelectorAll('.ftab').forEach(function(tab) {
  tab.addEventListener('click', function() {
    document.querySelectorAll('.ftab').forEach(function(t) { t.classList.remove('active'); });
    this.classList.add('active');
    activeFilter = this.getAttribute('data-filter');
    applyFilter();
  });
});

/* ── Live search ── */
document.getElementById('courseSearch').addEventListener('input', function() {
  applyFilter();
});

function applyFilter() {

  var searchVal = document.getElementById('courseSearch').value.toLowerCase().trim();
  var visible = 0;

  var cards = currentView === 'grid'
      ? document.querySelectorAll('.course-card')
      : document.querySelectorAll('.course-list-card');

  cards.forEach(function(el) {

    var name = (el.getAttribute('data-name') || '').toLowerCase();
    var filter = el.getAttribute('data-filter') || '';

    var matchSearch = !searchVal || name.includes(searchVal);
    var matchFilter = activeFilter === 'all' || filter === activeFilter;

    var show = matchSearch && matchFilter;

    el.style.display = show ? '' : 'none';

    if(show) visible++;

  });

  document.getElementById('visibleCount').textContent = visible;
}

/* ── Delete Modal ── */
function openDeleteModal(courseId, courseName, courseDesc) {
  document.getElementById('modalCourseImg').src        = 'course_img.jsp?name=' + courseId;
  document.getElementById('modalCourseName').textContent    = courseName;
  document.getElementById('modalCourseDesc').textContent    = courseDesc;
  document.getElementById('modalCourseNameWarn').textContent = '"' + courseName + '"';
  document.getElementById('deleteConfirmBtn').href       = 'Request5.jsp?course_id=' + courseId;
  document.getElementById('deleteModal').classList.add('open');
  document.body.style.overflow = 'hidden';
}
function closeDeleteModal() {
  var modal = document.getElementById('deleteModal');
  var box   = modal.querySelector('.modal-box');
  box.style.animation = 'popOut .22s ease both';
  setTimeout(function() {
    modal.classList.remove('open');
    document.body.style.overflow = '';
    box.style.animation = '';
  }, 210);
}
function handleModalOverlay(e) {
  if (e.target === document.getElementById('deleteModal')) closeDeleteModal();
}

/* inject pop-out keyframe once */
var _pk = document.createElement('style');
_pk.textContent = '@keyframes popOut{from{opacity:1;transform:scale(1)}to{opacity:0;transform:scale(.9) translateY(12px)}}';
document.head.appendChild(_pk);

/* ESC key */
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape' && document.getElementById('deleteModal').classList.contains('open')) {
    closeDeleteModal();
  }
});
</script>
</body>
</html>
