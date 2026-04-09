<%@page import="java.sql.*"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SkillSync – Course Topics</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    /* ══════════════════════════════════════
       TOKENS
    ══════════════════════════════════════ */
    :root {
      --orange:       #f97316;
      --orange-dark:  #ea6c0a;
      --orange-light: #fff7ed;
      --orange-mid:   #fed7aa;
      --orange-ring:  rgba(249,115,22,.18);
      --green:        #22c55e;
      --green-pale:   #f0fdf4;
      --green-dark:   #15803d;
      --blue:         #3b82f6;
      --blue-pale:    #eff6ff;
      --red:          #ef4444;
      --cream:        #fafaf7;
      --cream2:       #f4f4ef;
      --ivory:        #fffffe;
      --charcoal:     #1a1a1a;
      --slate:        #44403c;
      --stone:        #78716c;
      --stone-light:  #a8a29e;
      --border:       #e8e3da;
      --shadow-sm:    0 2px 10px rgba(0,0,0,.05);
      --shadow-md:    0 6px 28px rgba(0,0,0,.09);
      --shadow-lg:    0 18px 56px rgba(0,0,0,.13);
      --r:            16px;
      --r-sm:         10px;
      --font-display: 'Cormorant Garamond', Georgia, serif;
      --font-body:    'Plus Jakarta Sans', sans-serif;
      --sidebar-w:    280px;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body {
      font-family: var(--font-body);
      background: var(--cream);
      color: var(--charcoal);
      min-height: 100vh;
      overflow-x: hidden;
    }
    a { text-decoration: none; color: inherit; }

    /* ══════════════════════════════════════
       TOP STRIPE
    ══════════════════════════════════════ */
    .top-stripe {
      height: 4px;
      background: linear-gradient(90deg, var(--orange), #fbbf24, var(--orange-dark));
      position: fixed; top: 0; left: 0; right: 0; z-index: 999;
    }

    /* ══════════════════════════════════════
       BREADCRUMB
    ══════════════════════════════════════ */
    .breadcrumb-bar {
      background: var(--ivory);
      border-bottom: 1px solid var(--border);
      padding: 13px 32px;
      margin-top: 4px;
      display: flex; align-items: center; gap: 9px;
      font-size: .8rem; color: var(--stone);
      animation: slideDown .4s ease both;
      position: sticky; top: 4px; z-index: 100;
    }
    .breadcrumb-bar a { color: var(--orange); font-weight: 600; transition: opacity .2s; }
    .breadcrumb-bar a:hover { opacity: .75; }
    .breadcrumb-bar .sep { opacity: .4; }
    .breadcrumb-bar .current { color: var(--charcoal); font-weight: 600; }
    .breadcrumb-bar .course-chip {
      margin-left: auto;
      background: var(--orange-light);
      border: 1px solid var(--orange-mid);
      color: var(--orange-dark);
      font-size: .72rem; font-weight: 700;
      padding: 4px 12px; border-radius: 100px;
      display: flex; align-items: center; gap: 5px;
    }

    /* ══════════════════════════════════════
       PAGE LAYOUT  (sidebar + main)
    ══════════════════════════════════════ */
    .page-layout {
      display: grid;
      grid-template-columns: var(--sidebar-w) 1fr;
      gap: 0;
      min-height: calc(100vh - 57px);
    }

    /* ══════════════════════════════════════
       SIDEBAR
    ══════════════════════════════════════ */
    .sidebar {
      background: var(--ivory);
      border-right: 1px solid var(--border);
      display: flex; flex-direction: column;
      position: sticky; top: 57px;
      height: calc(100vh - 57px);
      overflow-y: auto;
    }
    .sidebar::-webkit-scrollbar { width: 4px; }
    .sidebar::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

    .sidebar-header {
      padding: 22px 20px 14px;
      border-bottom: 1px solid var(--border);
    }
    .sidebar-eyebrow {
      font-size: .65rem; font-weight: 700; letter-spacing: .12em;
      text-transform: uppercase; color: var(--orange); margin-bottom: 4px;
    }
    .sidebar-title {
      font-family: var(--font-display);
      font-size: 1.15rem; font-weight: 600; color: var(--charcoal);
    }

    /* Progress bar in sidebar */
    .sidebar-progress-wrap { padding: 14px 20px; border-bottom: 1px solid var(--border); }
    .sp-label {
      display: flex; justify-content: space-between;
      font-size: .72rem; font-weight: 700; color: var(--stone);
      margin-bottom: 6px;
    }
    .sp-track {
      height: 7px; background: var(--cream2);
      border-radius: 100px; overflow: hidden; border: 1px solid var(--border);
    }
    .sp-fill {
      height: 100%; border-radius: 100px; width: 0;
      background: linear-gradient(90deg, var(--orange), #fbbf24);
      transition: width 1.2s ease;
    }

    /* Module list */
    .module-list { padding: 12px 12px; flex: 1; }

    .module-item {
      display: flex; align-items: center; gap: 10px;
      padding: 11px 14px; border-radius: var(--r-sm);
      cursor: pointer; margin-bottom: 4px;
      transition: background .2s, transform .15s;
      position: relative;
      border: 1.5px solid transparent;
    }
    .module-item:hover:not(.locked) {
      background: var(--orange-light);
      border-color: var(--orange-mid);
      transform: translateX(3px);
    }
    .module-item.active-module {
      background: var(--orange-light);
      border-color: var(--orange);
    }
    .module-item.locked {
      opacity: .5; cursor: not-allowed;
    }

    .mod-num {
      width: 28px; height: 28px; border-radius: 8px;
      display: flex; align-items: center; justify-content: center;
      font-size: .7rem; font-weight: 800; flex-shrink: 0;
      background: var(--cream2); color: var(--stone);
      transition: background .2s, color .2s;
    }
    .module-item.active-module .mod-num,
    .module-item:hover:not(.locked) .mod-num {
      background: var(--orange); color: #fff;
    }
    .module-item.completed-module .mod-num {
      background: var(--green-pale); color: var(--green-dark);
    }

    .mod-label { font-size: .83rem; font-weight: 600; color: var(--charcoal); flex: 1; }
    .module-item.locked .mod-label { color: var(--stone-light); }

    .mod-status-icon { font-size: .85rem; flex-shrink: 0; }
    .mod-status-icon.done   { color: var(--green); }
    .mod-status-icon.locked { color: var(--stone-light); }

    /* ══════════════════════════════════════
       MAIN CONTENT PANEL
    ══════════════════════════════════════ */
    .main-panel {
      padding: 32px 36px 80px;
      overflow-y: auto;
    }

    /* Welcome state */
    .welcome-state {
      display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      min-height: 60vh;
      text-align: center;
      opacity: 0; animation: fadeUp .5s .2s ease forwards;
    }
    .welcome-icon {
      width: 80px; height: 80px; border-radius: 22px;
      background: var(--orange-light);
      display: flex; align-items: center; justify-content: center;
      font-size: 2rem; color: var(--orange-dark);
      margin: 0 auto 20px;
      box-shadow: 0 8px 32px var(--orange-ring);
    }
    .welcome-state h3 {
      font-family: var(--font-display);
      font-size: 1.7rem; font-weight: 600; margin-bottom: 8px;
    }
    .welcome-state p { font-size: .9rem; color: var(--stone); max-width: 320px; }

    /* Topic header */
    .topic-header {
      margin-bottom: 28px;
      opacity: 0; animation: fadeUp .45s ease forwards;
    }
    .topic-eyebrow {
      font-size: .68rem; font-weight: 700;
      text-transform: uppercase; letter-spacing: .13em;
      color: var(--orange); margin-bottom: 6px;
      display: flex; align-items: center; gap: 6px;
    }
    .topic-title {
      font-family: var(--font-display);
      font-size: clamp(1.5rem, 3vw, 2.1rem);
      font-weight: 700; color: var(--charcoal); line-height: 1.2;
    }

    /* Module cards grid */
    .modules-grid {
      display: flex; flex-direction: column; gap: 14px;
    }

    .module-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: var(--r);
      display: flex; align-items: center; gap: 16px;
      padding: 18px 22px;
      box-shadow: var(--shadow-sm);
      transition: box-shadow .25s, transform .2s, border-color .2s;
      opacity: 0;
      text-decoration: none; color: inherit;
    }
    .module-card.anim { animation: cardIn .4s ease forwards; }
    .module-card:hover:not(.card-locked) {
      box-shadow: var(--shadow-md);
      transform: translateX(6px);
      border-color: var(--orange-mid);
    }
    .module-card.card-locked {
      opacity: .55; cursor: not-allowed; pointer-events: none;
    }
    .module-card.card-locked:hover { transform: none; }

    .mc-icon {
      width: 46px; height: 46px; border-radius: 13px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.1rem; flex-shrink: 0;
    }
    .mc-icon.open   { background: var(--orange-light); color: var(--orange-dark); }
    .mc-icon.done   { background: var(--green-pale);   color: var(--green-dark); }
    .mc-icon.locked { background: var(--cream2);        color: var(--stone-light); }

    .mc-body { flex: 1; min-width: 0; }
    .mc-title {
      font-size: .92rem; font-weight: 700; color: var(--charcoal);
      margin-bottom: 3px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .mc-card-locked .mc-title { color: var(--stone); }
    .mc-meta { font-size: .75rem; color: var(--stone); display: flex; align-items: center; gap: 6px; }

    .mc-badge {
      padding: 4px 12px; border-radius: 100px;
      font-size: .68rem; font-weight: 700;
      text-transform: uppercase; letter-spacing: .04em;
      white-space: nowrap; flex-shrink: 0;
    }
    .badge-done    { background: var(--green-pale); color: var(--green-dark); border: 1px solid #bbf7d0; }
    .badge-open    { background: var(--orange-light); color: var(--orange-dark); border: 1px solid var(--orange-mid); }
    .badge-locked  { background: var(--cream2); color: var(--stone); border: 1px solid var(--border); }

    .mc-arrow { color: var(--stone-light); font-size: .85rem; flex-shrink: 0; transition: color .2s, transform .2s; }
    .module-card:hover:not(.card-locked) .mc-arrow { color: var(--orange); transform: translateX(3px); }

    /* ══════════════════════════════════════
       COURSE COMPLETION BANNER
    ══════════════════════════════════════ */
    .completion-banner {
      background: linear-gradient(135deg, #f0fdf4, #dcfce7);
      border: 1.5px solid #86efac;
      border-radius: 20px;
      padding: 28px 32px;
      display: flex; align-items: center; gap: 20px;
      flex-wrap: wrap;
      margin-top: 32px;
      box-shadow: 0 4px 24px rgba(34,197,94,.15);
      opacity: 0; animation: fadeUp .5s .3s ease forwards;
    }
    .completion-icon {
      width: 60px; height: 60px; border-radius: 18px;
      background: linear-gradient(135deg, #22c55e, #16a34a);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.6rem; flex-shrink: 0;
      box-shadow: 0 6px 20px rgba(34,197,94,.35);
    }
    .completion-body { flex: 1; }
    .completion-body h4 {
      font-family: var(--font-display);
      font-size: 1.3rem; font-weight: 700; color: #14532d;
      margin-bottom: 5px;
    }
    .completion-body p { font-size: .87rem; color: #166534; margin: 0; }

    .btn-quiz {
      background: linear-gradient(135deg, var(--green), #16a34a);
      color: #fff; border: none; border-radius: 100px;
      font-family: var(--font-body); font-size: .87rem; font-weight: 700;
      padding: 13px 28px; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px;
      box-shadow: 0 4px 18px rgba(34,197,94,.38);
      transition: transform .15s, box-shadow .2s;
      text-decoration: none;
      white-space: nowrap;
    }
    .btn-quiz:hover {
      transform: translateY(-2px);
      box-shadow: 0 7px 26px rgba(34,197,94,.48);
      color: #fff;
    }

    /* Pending banner */
    .pending-banner {
      background: linear-gradient(135deg, #fff8f0, #fff3e5);
      border: 1.5px solid var(--orange-mid);
      border-radius: 20px;
      padding: 22px 28px;
      display: flex; align-items: center; gap: 16px;
      flex-wrap: wrap;
      margin-top: 32px;
      opacity: 0; animation: fadeUp .5s .4s ease forwards;
    }
    .pending-icon {
      width: 48px; height: 48px; border-radius: 14px;
      background: var(--orange-light);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.3rem; color: var(--orange-dark); flex-shrink: 0;
    }
    .pending-body h5 {
      font-size: .92rem; font-weight: 700; color: var(--orange-dark); margin-bottom: 3px;
    }
    .pending-body p { font-size: .82rem; color: var(--stone); margin: 0; }

    /* ══════════════════════════════════════
       EMPTY / ERROR STATES
    ══════════════════════════════════════ */
    .empty-state {
      text-align: center; padding: 60px 24px; color: var(--stone);
    }
    .empty-state i { font-size: 2.2rem; display: block; margin-bottom: 12px; opacity: .35; }
    .empty-state p { font-size: .9rem; }

    /* ══════════════════════════════════════
       TOAST
    ══════════════════════════════════════ */
    .toast-stack {
      position: fixed; bottom: 28px; right: 28px; z-index: 9999;
      display: flex; flex-direction: column; gap: 10px;
    }
    .sk-toast {
      min-width: 270px;
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: 14px; padding: 13px 16px;
      display: flex; align-items: flex-start; gap: 11px;
      box-shadow: var(--shadow-lg);
      animation: toastIn .32s cubic-bezier(.34,1.25,.64,1) both;
    }
    .sk-toast.removing { animation: toastOut .28s ease forwards; }
    .toast-icon {
      width: 34px; height: 34px; border-radius: 9px;
      display: flex; align-items: center; justify-content: center;
      font-size: .9rem; flex-shrink: 0;
    }
    .toast-info    .toast-icon { background: var(--orange-light); color: var(--orange-dark); }
    .toast-success .toast-icon { background: var(--green-pale);   color: var(--green-dark); }
    .toast-title { font-size: .82rem; font-weight: 700; color: var(--charcoal); margin-bottom: 1px; }
    .toast-msg   { font-size: .76rem; color: var(--stone); }

    @keyframes toastIn  { from{opacity:0;transform:translateX(36px)} to{opacity:1;transform:translateX(0)} }
    @keyframes toastOut { from{opacity:1} to{opacity:0;transform:translateX(36px)} }

    /* ══════════════════════════════════════
       ANIMATIONS
    ══════════════════════════════════════ */
    @keyframes slideDown { from{opacity:0;transform:translateY(-12px)} to{opacity:1;transform:translateY(0)} }
    @keyframes fadeUp    { from{opacity:0;transform:translateY(18px)}  to{opacity:1;transform:translateY(0)} }
    @keyframes cardIn    { from{opacity:0;transform:translateX(-12px)} to{opacity:1;transform:translateX(0)} }

    /* ══════════════════════════════════════
       RESPONSIVE
    ══════════════════════════════════════ */
    @media (max-width: 768px) {
      :root { --sidebar-w: 100%; }
      .page-layout { grid-template-columns: 1fr; }
      .sidebar { position: relative; height: auto; border-right: none; border-bottom: 1px solid var(--border); }
      .main-panel { padding: 22px 18px 60px; }
      .breadcrumb-bar { padding: 11px 16px; }
      .breadcrumb-bar .course-chip { display: none; }
    }
  </style>
</head>
<body>

<div class="top-stripe"></div>

<%
  Integer id = (Integer) session.getAttribute("student_id");
  String name = (String) session.getAttribute("student_mail");

  if (id != null && name != null) {
    try {
      DbConnection db1 = new DbConnection();
      ResultSet rs1 = db1.Select(
        "SELECT * FROM student_register WHERE student_id='" + id + "' AND student_mail='" + name + "'"
      );
      if (rs1.next()) {
        String student_name = rs1.getString("student_name");
%>

<!-- Session message -->
<%
  String msg = (String) session.getAttribute("msg");
  if (msg != null) {
%>
<script>
  window.addEventListener('DOMContentLoaded', function() {
    showToast('info', 'Notice', '<%= msg %>');
  });
</script>
<% }
   session.removeAttribute("msg");
%>

<%
  String courseName  = request.getParameter("course_name");
  String courseid    = request.getParameter("course_id");
  Integer studentId  = (Integer) session.getAttribute("student_id");

  if (studentId == null) {
    response.sendRedirect("index.jsp");
    return;
  }

  DbConnection db = new DbConnection();
  ResultSet rs = null;

  // ── Gather all topics + completion counts for sidebar progress ──
  int totalTopics     = 0;
  int completedTopics = 0;

  ResultSet rsCount = db.Select(
    "SELECT t.topic_id, st.status FROM topics t " +
    "LEFT JOIN student_topics st ON t.topic_id = st.topic_id AND st.student_id='" + studentId + "' " +
    "WHERE t.course_id='" + courseid + "'"
  );
  while (rsCount != null && rsCount.next()) {
    totalTopics++;
    if ("completed".equalsIgnoreCase(rsCount.getString("status"))) completedTopics++;
  }
  if (rsCount != null) rsCount.close();

  int progressPct = totalTopics > 0 ? (completedTopics * 100 / totalTopics) : 0;

  // ── Check overall completion ──
  boolean allTopicsCompleted = (totalTopics > 0 && completedTopics == totalTopics);

  try {
    rs = db.Select("SELECT * FROM topics WHERE course_id='" + courseid + "' ORDER BY topic_id ASC");
%>

<!-- ── Breadcrumb ──────────────────────────────── -->
<div class="breadcrumb-bar">
  <i class="bi bi-house-fill" style="color:var(--orange);"></i>
  <a href="Student_View_Course.jsp">My Course</a>
  <span class="sep"><i class="bi bi-chevron-right"></i></span>
  <span class="current">Topics</span>
  <div class="course-chip">
    <i class="bi bi-mortarboard-fill"></i>
    <%= courseName != null ? courseName : "Course" %>
  </div>
</div>

<!-- ── Page Layout ────────────────────────────── -->
<div class="page-layout">

  <!-- ══ SIDEBAR ══ -->
  <aside class="sidebar">
    <div class="sidebar-header">
      <div class="sidebar-eyebrow"><i class="bi bi-list-ul me-1"></i>Modules</div>
      <div class="sidebar-title"><%= courseName != null ? courseName : "Course" %></div>
    </div>

    <!-- Progress -->
    <div class="sidebar-progress-wrap">
      <div class="sp-label">
        <span>Progress</span>
        <span id="progressLabel"><%= completedTopics %>/<%= totalTopics %></span>
      </div>
      <div class="sp-track">
        <div class="sp-fill" id="sidebarProgress" data-target="<%= progressPct %>"></div>
      </div>
    </div>

    <!-- Module list -->
    <div class="module-list" id="moduleList">
      <%
        rs.beforeFirst();
        int moduleCounter = 1;
        boolean prevCompleted = true;

        while (rs.next()) {
          int topicId = rs.getInt("topic_id");

          ResultSet rsModules = db.Select(
            "SELECT * FROM topics WHERE topic_id='" + topicId + "' ORDER BY topic_id ASC"
          );
          while (rsModules.next()) {
            String mId    = rsModules.getString("topic_id");
            String mTitle = rsModules.getString("topic_title");

            ResultSet rsStatus = db.Select(
              "SELECT status FROM student_topics WHERE student_id='" + studentId + "' AND topic_id='" + topicId + "'"
            );
            String modStatus = "pending";
            if (rsStatus.next()) {
              modStatus = rsStatus.getString("status");
            } else {
              db.update(
                "INSERT INTO student_topics(student_id, topic_id, course_id, status) " +
                "VALUES('" + studentId + "','" + topicId + "','" + courseid + "','pending')"
              );
            }
            boolean isCompleted = "completed".equals(modStatus);
            boolean accessible  = prevCompleted;
      %>
      <div class="module-item
                  <%= !accessible ? "locked" : "" %>
                  <%= isCompleted ? "completed-module" : "" %>"
           id="sidebar-mod-<%= topicId %>"
           onclick="<%= accessible ? "showTopic(" + topicId + ")" : "return false;" %>">
        <div class="mod-num"><%= moduleCounter %></div>
        <div class="mod-label"><%= mTitle %></div>
        <% if (isCompleted) { %>
          <i class="bi bi-check-circle-fill mod-status-icon done"></i>
        <% } else if (!accessible) { %>
          <i class="bi bi-lock-fill mod-status-icon locked"></i>
        <% } else { %>
          <i class="bi bi-chevron-right mod-status-icon" style="color:var(--stone-light);font-size:.75rem;"></i>
        <% } %>
      </div>
      <%
            prevCompleted = isCompleted;
            moduleCounter++;
            if (rsStatus  != null) try { rsStatus.close();  } catch (Exception e) {}
          }
          if (rsModules != null) rsModules.close();
        }
      %>
    </div>
  </aside>

  <!-- ══ MAIN PANEL ══ -->
  <main class="main-panel" id="mainPanel">

    <!-- Welcome state (shown before any module clicked) -->
    <div class="welcome-state" id="welcomeState">
      <div class="welcome-icon"><i class="bi bi-book-fill"></i></div>
      <h3>Select a Module</h3>
      <p>Choose a module from the sidebar to view its topics and lessons.</p>
    </div>

    <!-- Topic detail area (hidden until module clicked) -->
    <div id="topicDetailArea" style="display:none;">

      <div class="topic-header" id="topicHeader">
        <div class="topic-eyebrow" id="topicEyebrow">
          <i class="bi bi-folder2-open"></i> Topic
        </div>
        <div class="topic-title" id="topicTitle">—</div>
      </div>

      <div class="modules-grid" id="modulesGrid">
        <!-- filled by JS -->
      </div>

    </div>

    <!-- ══ COMPLETION / PENDING BANNERS ══ -->
    <% if (allTopicsCompleted) { %>
    <div class="completion-banner" id="completionBanner">
      <div class="completion-icon">🏆</div>
      <div class="completion-body">
        <h4>All Modules Completed!</h4>
        <p>Fantastic work, <%= student_name %>! You're ready to take the final course quiz.</p>
      </div>
      <a href="Student_Start_Quiz.jsp?course_id=<%= courseid %>" class="btn-quiz">
        <i class="bi bi-pencil-square"></i> Start Course Quiz
      </a>
    </div>
    <% } else { %>
    <div class="pending-banner" id="pendingBanner">
      <div class="pending-icon"><i class="bi bi-hourglass-split"></i></div>
      <div class="pending-body">
        <h5>Course Quiz Locked</h5>
        <p>Complete all modules to unlock the final course quiz.</p>
      </div>
    </div>
    <% } %>

  </main>
</div><!-- /page-layout -->

<%-- Build topic data as JS object so showTopic() can render without extra requests --%>
<script>
var TOPIC_DATA = {};
<%
  rs.beforeFirst();
  while (rs.next()) {
    int tId       = rs.getInt("topic_id");
    String tTitle = rs.getString("topic_title");

    out.println("TOPIC_DATA[" + tId + "] = {");
    out.println("  title: " + escapeJS(tTitle) + ",");
    out.println("  modules: [");

    boolean prevMod = true;
    ResultSet rsTM = db.Select(
      "SELECT * FROM modules WHERE topic_id='" + tId + "' ORDER BY modules_id ASC"
    );
    while (rsTM.next()) {
      String mId    = rsTM.getString("modules_id");
      String mTitle = rsTM.getString("module_title");

      ResultSet rsMSt = db.Select(
        "SELECT status FROM student_modules WHERE student_id='" + studentId +
        "' AND modules_id='" + mId + "' AND topic_id='" + tId + "'"
      );
      String mSt = "pending";
      if (rsMSt.next()) mSt = rsMSt.getString("status");
      boolean mDone       = "completed".equals(mSt);
      boolean mAccessible = prevMod;

      String url = "Student_Modules.jsp?module_id=" + mId +
                   "&topic_id=" + tId +
                   "&course_id=" + courseid +
                   "&course_name=" + (courseName != null ? courseName.replace(" ","+") : "");

      out.println("    {");
      out.println("      id: '" + mId + "',");
      out.println("      title: " + escapeJS(mTitle) + ",");
      out.println("      done: " + mDone + ",");
      out.println("      accessible: " + mAccessible + ",");
      out.println("      url: '" + url + "'");
      out.println("    },");

      prevMod = mDone;
      if (rsMSt != null) try { rsMSt.close(); } catch (Exception ex) {}
    }
    rsTM.close();

    out.println("  ]");
    out.println("};");
  }
%>
</script>

<%!
  // Helper to escape strings for JS
  private String escapeJS(String s) {
    if (s == null) return "''";
    return "'" + s.replace("\\","\\\\").replace("'","\\'").replace("\n","\\n").replace("\r","") + "'";
  }
%>

<%
  } catch (Exception e) {
    out.println("<div style='padding:40px;color:red;'>Error: " + e.getMessage() + "</div>");
  } finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (db != null) db.close();
  }
%>

<!-- Toast stack -->
<div class="toast-stack" id="toastStack"></div>

<%
      } // end rs1.next()
    } catch (Exception e) {
      out.println("Error: " + e.getMessage());
    }
  } else {
    session.setAttribute("msg", "Session Out Please Login");
    response.sendRedirect("index.jsp");
  }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ══════════════════════════════════════
   SIDEBAR PROGRESS ANIMATE
══════════════════════════════════════ */
window.addEventListener('load', function() {
  var fill = document.getElementById('sidebarProgress');
  if (fill) {
    var target = fill.getAttribute('data-target') || '0';
    setTimeout(function() { fill.style.width = target + '%'; }, 300);
  }
});

/* ══════════════════════════════════════
   SHOW TOPIC
══════════════════════════════════════ */
var activeTopicId = null;

function showTopic(topicId) {
  var data = TOPIC_DATA[topicId];
  if (!data) return;

  activeTopicId = topicId;

  // Update sidebar active state
  document.querySelectorAll('.module-item').forEach(function(el) {
    el.classList.remove('active-module');
  });
  var sideItem = document.getElementById('sidebar-mod-' + topicId);
  if (sideItem) sideItem.classList.add('active-module');

  // Show detail area, hide welcome
  document.getElementById('welcomeState').style.display    = 'none';
  document.getElementById('topicDetailArea').style.display = 'block';

  // Set header
  document.getElementById('topicEyebrow').innerHTML = '<i class="bi bi-folder2-open"></i> Topic';
  document.getElementById('topicTitle').textContent  = data.title;

  // Reset animation on header
  var hdr = document.getElementById('topicHeader');
  hdr.style.animation = 'none';
  void hdr.offsetWidth;
  hdr.style.animation = '';
  hdr.style.opacity   = '0';
  hdr.style.animation = 'fadeUp .4s ease forwards';

  // Render module cards
  var grid = document.getElementById('modulesGrid');
  grid.innerHTML = '';

  if (!data.modules || data.modules.length === 0) {
    grid.innerHTML = '<div class="empty-state"><i class="bi bi-inbox"></i><p>No modules in this topic yet.</p></div>';
    return;
  }

  data.modules.forEach(function(mod, idx) {
    var iconClass   = mod.done ? 'done' : (mod.accessible ? 'open' : 'locked');
    var iconBI      = mod.done ? 'bi-check-circle-fill' : (mod.accessible ? 'bi-play-circle-fill' : 'bi-lock-fill');
    var badgeClass  = mod.done ? 'badge-done' : (mod.accessible ? 'badge-open' : 'badge-locked');
    var badgeLabel  = mod.done ? '✓ Completed' : (mod.accessible ? 'Open' : 'Locked');
    var cardClass   = mod.accessible ? '' : 'card-locked';
    var tag         = mod.accessible ? 'a' : 'div';
    var hrefAttr    = mod.accessible ? 'href="' + mod.url + '"' : '';
    var metaText    = mod.done ? 'Completed' : (mod.accessible ? 'Click to open' : 'Finish previous module first');

    var html = '<' + tag + ' ' + hrefAttr + ' class="module-card ' + cardClass + '" ' +
               'style="animation-delay:' + (idx * 0.07) + 's;">' +
      '<div class="mc-icon ' + iconClass + '"><i class="bi ' + iconBI + '"></i></div>' +
      '<div class="mc-body">' +
        '<div class="mc-title">' + escHTML(mod.title) + '</div>' +
        '<div class="mc-meta"><i class="bi bi-info-circle" style="font-size:.7rem;"></i>' + metaText + '</div>' +
      '</div>' +
      '<span class="mc-badge ' + badgeClass + '">' + badgeLabel + '</span>' +
      (mod.accessible ? '<i class="bi bi-arrow-right mc-arrow"></i>' : '') +
    '</' + tag + '>';

    grid.insertAdjacentHTML('beforeend', html);
  });

  // Trigger card animations
  setTimeout(function() {
    grid.querySelectorAll('.module-card').forEach(function(card) {
      card.classList.add('anim');
    });
  }, 20);

  // Scroll main panel to top on mobile
  var main = document.getElementById('mainPanel');
  if (main && window.innerWidth <= 768) main.scrollIntoView({ behavior: 'smooth' });
}

function escHTML(str) {
  var d = document.createElement('div');
  d.textContent = str || '';
  return d.innerHTML;
}

/* ══════════════════════════════════════
   TOAST
══════════════════════════════════════ */
function showToast(type, title, message) {
  var stack  = document.getElementById('toastStack');
  var icons  = { success: 'bi-check2-circle', info: 'bi-info-circle-fill' };
  var toast  = document.createElement('div');
  toast.className = 'sk-toast toast-' + type;
  toast.innerHTML =
    '<div class="toast-icon"><i class="bi ' + (icons[type] || icons.info) + '"></i></div>' +
    '<div><div class="toast-title">' + title + '</div><div class="toast-msg">' + message + '</div></div>';
  stack.appendChild(toast);
  setTimeout(function() {
    toast.classList.add('removing');
    setTimeout(function() { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 300);
  }, 3600);
}

/* Auto-open first accessible topic */
window.addEventListener('DOMContentLoaded', function() {
  var firstKey = Object.keys(TOPIC_DATA)[0];
  if (firstKey) {
    // Don't auto-open; let the welcome screen show
  }
});
</script>
</body>
</html>
