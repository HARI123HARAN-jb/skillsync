<%-- 
    Document   : chose_topic
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
  * { box-sizing: border-box; margin: 0; padding: 0; }

  .sm-wrap {
    padding: 2.5rem 1rem;
    max-width: 1050px; margin: auto;
    font-family: system-ui, sans-serif;
    background: #f4f6fb; min-height: 100vh;
  }

  /* ── Headings ── */
  .sm-title {
    font-size: 22px; font-weight: 700; color: #1e1b4b;
    text-align: center; margin-bottom: .35rem;
    animation: sm-down .4s ease both;
  }

  .sm-sub {
    text-align: center; font-size: 13px; color: #6b7280;
    margin-bottom: .85rem;
    animation: sm-down .4s .06s ease both;
  }

  /* ── Search ── */
  .sm-search-wrap {
    max-width: 360px; margin: 0 auto 1.6rem;
    position: relative;
    animation: sm-down .4s .10s ease both;
  }

  .sm-search-wrap input {
    width: 100%;
    padding: 9px 14px 9px 38px;
    font-size: 13px;
    border: 1.5px solid #e0e7ff; border-radius: 50px;
    outline: none; background: #fff;
    font-family: inherit; color: #111827;
    transition: border-color .2s, box-shadow .2s;
  }

  .sm-search-wrap input:focus {
    border-color: #4f46e5;
    box-shadow: 0 0 0 3px rgba(79,70,229,.10);
  }

  .sm-search-icon {
    position: absolute; left: 12px;
    top: 50%; transform: translateY(-50%);
    width: 16px; height: 16px;
    color: #9ca3af; pointer-events: none;
  }

  /* ── Keyframes ── */
  @keyframes sm-down {
    from { opacity: 0; transform: translateY(-12px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  @keyframes sm-up {
    from { opacity: 0; transform: translateY(24px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ── Count bar ── */
  .sm-count-bar {
    text-align: center; font-size: 13px; color: #6b7280;
    margin-bottom: 1.5rem;
    animation: sm-down .4s .12s ease both;
  }

  .sm-count-bar span { font-weight: 700; color: #4f46e5; }

  /* ── Grid ── */
  .sm-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 1.25rem;
  }

  /* ── Card ── */
  .sm-card {
    background: #fff;
    border: 0.5px solid #e0e7ff;
    border-radius: 18px; overflow: hidden;
    display: flex; flex-direction: column;
    animation: sm-up .45s cubic-bezier(.22,.68,0,1.2) both;
    transition: box-shadow .25s, transform .25s;
  }

  /* stagger */
  .sm-card:nth-child(1) { animation-delay: .04s; }
  .sm-card:nth-child(2) { animation-delay: .09s; }
  .sm-card:nth-child(3) { animation-delay: .14s; }
  .sm-card:nth-child(4) { animation-delay: .19s; }
  .sm-card:nth-child(5) { animation-delay: .24s; }
  .sm-card:nth-child(6) { animation-delay: .29s; }
  .sm-card:nth-child(7) { animation-delay: .34s; }
  .sm-card:nth-child(8) { animation-delay: .39s; }
  .sm-card:nth-child(9) { animation-delay: .44s; }

  .sm-card:hover {
    box-shadow: 0 8px 32px rgba(79,70,229,.13);
    transform: translateY(-4px);
  }

  .sm-card.sm-hidden { display: none; }

  /* ── Image ── */
  .sm-img-wrap {
    position: relative; width: 100%; height: 185px;
    overflow: hidden; background: #f1f0ff;
  }

  .sm-img-wrap img {
    width: 100%; height: 100%;
    object-fit: cover; display: block;
    transition: transform .4s ease;
  }

  .sm-card:hover .sm-img-wrap img { transform: scale(1.06); }

  .sm-overlay {
    position: absolute; inset: 0;
    background: linear-gradient(to bottom, transparent 40%, rgba(79,70,229,.48));
    opacity: 0; transition: opacity .3s;
    display: flex; align-items: flex-end;
    justify-content: center; padding-bottom: 14px;
  }

  .sm-card:hover .sm-overlay { opacity: 1; }

  .sm-overlay-txt {
    color: #fff; font-size: 12px; font-weight: 600;
    display: flex; align-items: center; gap: 5px;
  }

  .sm-overlay-txt svg { width: 14px; height: 14px; }

  /* ── Body ── */
  .sm-body {
    padding: 1.1rem; flex: 1;
    display: flex; flex-direction: column; gap: 8px;
  }

  .sm-name {
    font-size: 15px; font-weight: 700; color: #1e1b4b;
    line-height: 1.35; text-align: center;
  }

  /* ── Progress ── */
  .sm-progress-wrap {
    background: #f3f4f6; border-radius: 20px;
    height: 7px; overflow: hidden;
  }

  .sm-progress-bar {
    height: 7px; border-radius: 20px;
    width: 0%; transition: width 1s ease;
  }

  .sm-full .sm-progress-bar { background: #10b981; }
  .sm-part .sm-progress-bar { background: #4f46e5; }

  .sm-progress-row {
    display: flex; justify-content: space-between;
    font-size: 11px; color: #6b7280;
  }

  /* ── Badge ── */
  .sm-badge {
    display: inline-flex; align-items: center; gap: 5px;
    font-size: 11px; font-weight: 600;
    padding: 3px 9px; border-radius: 20px;
    margin: 0 auto;
  }

  .sm-badge svg       { width: 11px; height: 11px; }
  .sm-badge-full { background: #d1fae5; color: #065f46; }
  .sm-badge-part { background: #ede9fe; color: #5b21b6; }

  /* ── Buttons ── */
  .sm-btn {
    display: flex; align-items: center;
    justify-content: center; gap: 7px;
    width: 100%; padding: 10px 0;
    border: none; border-radius: 10px;
    font-size: 13px; font-weight: 600;
    cursor: pointer; text-decoration: none;
    transition: background .2s, transform .15s;
    margin-top: auto;
  }

  .sm-btn:active { transform: scale(.97); }
  .sm-btn svg    { width: 15px; height: 15px; flex-shrink: 0; }

  .sm-btn-edit      { background: #f59e0b; color: #78350f; }
  .sm-btn-edit:hover { background: #d97706; }
  .sm-btn-add       { background: #4f46e5; color: #fff; }
  .sm-btn-add:hover  { background: #3730a3; }

  /* ── Empty state ── */
  .sm-empty {
    display: none; text-align: center;
    padding: 3rem 1rem; color: #9ca3af; font-size: 14px;
  }

  .sm-empty svg {
    width: 48px; height: 48px; color: #d1d5db;
    margin: 0 auto 12px; display: block;
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
                DbConnection db1 = new DbConnection();
                ResultSet rs = db1.Select("SELECT * FROM teacher_register WHERE teacher_id='" + id + "' AND teacher_mail='" + name + "'");
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
       
<%
    String courseId = request.getParameter("course_id");
    if (courseId == null || courseId.isEmpty()) {
%>

<!-- ===== STYLES ===== -->

<div class="sm-alert">
  <svg viewBox="0 0 20 20" fill="currentColor">
    <path fill-rule="evenodd"
      d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
      clip-rule="evenodd"/>
  </svg>
  Please select a course first. <a href="select_course1.jsp">Go Back</a>
</div>

<%
    } else {
        DbConnection db = new DbConnection();
        ResultSet rs1 = db.Select(
            "SELECT * FROM topics WHERE course_id='" + courseId + "'"
        );

        /* Pre-fetch all rows so we know the total count */
        java.util.List<String[]> topicList = new java.util.ArrayList<>();
        while (rs1.next()) {
            String  tid   = rs1.getString("topic_id");
            String  tname = rs1.getString("topic_title");
            ResultSet rsC = db.Select(
                "SELECT COUNT(*) AS mc FROM modules WHERE topic_id='" + tid + "'"
            );
            int mc = 0;
            if (rsC.next()) mc = rsC.getInt("mc");
            rsC.close();
            topicList.add(new String[]{ tid, tname, String.valueOf(mc) });
        }
        if (rs1 != null) rs1.close();
%>

<!-- ===== HTML ===== -->
<div class="sm-wrap">

  <div class="sm-title">Select Module to Add Topics</div>
  <div class="sm-sub">Choose a topic to add or edit its modules</div>

  <!-- Search -->
  <div class="sm-search-wrap">
    <svg class="sm-search-icon" viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd"
        d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
        clip-rule="evenodd"/>
    </svg>
    <input type="text" id="smSearch"
           placeholder="Search topics..." oninput="smFilter()">
  </div>

  <!-- Count bar -->
  <div class="sm-count-bar">
    Showing <span id="smVisCount"><%= topicList.size() %></span> topics
  </div>

  <!-- Grid -->
  <div class="sm-grid" id="smGrid">

<%
        for (String[] topic : topicList) {
            String  tid        = topic[0];
            String  tname      = topic[1];
            int     mc         = Integer.parseInt(topic[2]);
            boolean isFull     = mc >= 3;
            int     pct        = Math.min(mc * 34, 100);
            String  cardClass  = isFull ? "sm-full" : "sm-part";
            String  badgeClass = isFull ? "sm-badge-full" : "sm-badge-part";
            String  statusTxt  = isFull ? "Complete"
                               : mc == 0 ? "Not Started" : "In Progress";
            String  nameLower  = tname.toLowerCase();
%>

    <div class="sm-card <%= cardClass %>"
         data-name="<%= nameLower %>">

      <!-- Image -->
      <div class="sm-img-wrap">
        <img src="topic_img.jsp?name=<%= tid %>"
             alt="<%= tname %>"
             onerror="this.src='https://placehold.co/300x185/eef2ff/4f46e5?text=<%= java.net.URLEncoder.encode(tname,"UTF-8") %>'">
        <div class="sm-overlay">
          <div class="sm-overlay-txt">
            <svg viewBox="0 0 20 20" fill="currentColor">
              <path d="M10 12a2 2 0 100-4 2 2 0 000 4z"/>
              <path fill-rule="evenodd"
                d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10z"
                clip-rule="evenodd"/>
            </svg>
            View
          </div>
        </div>
      </div>

      <!-- Body -->
      <div class="sm-body">

        <div class="sm-name"><%= tname %></div>

        <!-- Progress -->
        <div class="sm-progress-wrap">
          <div class="sm-progress-bar" data-w="<%= pct %>%"></div>
        </div>
        <div class="sm-progress-row">
          <span>Modules</span>
          <span><%= mc %> / 3</span>
        </div>

        <!-- Badge -->
        <span class="sm-badge <%= badgeClass %>">
          <% if (isFull) { %>
            <svg viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd"
                d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                clip-rule="evenodd"/>
            </svg>
          <% } else { %>
            <svg viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd"
                d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z"
                clip-rule="evenodd"/>
            </svg>
          <% } %>
          <%= statusTxt %>
        </span>

        <!-- Action button -->
        <% if (isFull) { %>
          <form action="Edit_Modules.jsp" method="get" style="margin-top:auto">
            <input type="hidden" name="topic_id"  value="<%= tid %>">
            <input type="hidden" name="course_id" value="<%= courseId %>">
            <button type="submit" class="sm-btn sm-btn-edit">
              <svg viewBox="0 0 20 20" fill="currentColor">
                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z"/>
              </svg>
              Edit Modules
            </button>
          </form>
        <% } else { %>
          <form action="Add_Modules.jsp" method="get" style="margin-top:auto">
            <input type="hidden" name="topic_id"   value="<%= tid %>">
            <input type="hidden" name="topic_name" value="<%= tname %>">
            <input type="hidden" name="course_id"  value="<%= courseId %>">
            <button type="submit" class="sm-btn sm-btn-add">
              <svg viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd"
                  d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z"
                  clip-rule="evenodd"/>
              </svg>
              <%= mc == 0 ? "Start Adding" : "Add Modules" %>
            </button>
          </form>
        <% } %>

      </div>
    </div>

<%
        }
        db.close();
%>

  </div>

  <!-- Empty state -->
  <div class="sm-empty" id="smEmpty">
    <svg viewBox="0 0 24 24" fill="none"
         stroke="currentColor" stroke-width="1.5">
      <circle cx="11" cy="11" r="8"/>
      <path d="m21 21-4.35-4.35"/>
    </svg>
    No topics match your search.
  </div>

</div>

<!-- ===== JAVASCRIPT ===== -->
<script>
  /* Live search */
  function smFilter() {
    var q     = document.getElementById('smSearch').value.toLowerCase().trim();
    var cards = document.querySelectorAll('#smGrid .sm-card');
    var vis   = 0;

    cards.forEach(function (card) {
      var name = card.getAttribute('data-name') || '';
      if (name.indexOf(q) !== -1) {
        card.classList.remove('sm-hidden');
        vis++;
      } else {
        card.classList.add('sm-hidden');
      }
    });

    document.getElementById('smVisCount').textContent = vis;
    document.getElementById('smEmpty').style.display  = vis === 0 ? 'block' : 'none';
  }

  /* Animate progress bars on load */
  window.addEventListener('load', function () {
    document.querySelectorAll('.sm-progress-bar').forEach(function (bar) {
      var w = bar.getAttribute('data-w') || '0%';
      setTimeout(function () { bar.style.width = w; }, 120);
    });
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
