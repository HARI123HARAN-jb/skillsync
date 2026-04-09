<%@page import="java.sql.*"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SkillSync – Module Viewer</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    /* ══════════════════════════════════════
       DESIGN TOKENS
    ══════════════════════════════════════ */
    :root {
      --orange:       #f97316;
      --orange-dark:  #ea6c0a;
      --orange-light: #fff7ed;
      --orange-ring:  rgba(249,115,22,.18);
      --green:        #22c55e;
      --green-pale:   #f0fdf4;
      --blue:         #3b82f6;
      --blue-pale:    #eff6ff;
      --red:          #ef4444;
      --cream:        #fafaf7;
      --cream2:       #f4f4ef;
      --ivory:        #fffffe;
      --charcoal:     #1a1a1a;
      --slate:        #44403c;
      --stone:        #78716c;
      --border:       #e8e3da;
      --shadow-sm:    0 2px 10px rgba(0,0,0,.05);
      --shadow-md:    0 6px 28px rgba(0,0,0,.09);
      --shadow-lg:    0 18px 56px rgba(0,0,0,.13);
      --r:            16px;
      --r-sm:         10px;
      --font-display: 'Cormorant Garamond', Georgia, serif;
      --font-body:    'Plus Jakarta Sans', sans-serif;
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
       TOP PROGRESS STRIPE
    ══════════════════════════════════════ */
    .top-stripe {
      height: 4px;
      background: linear-gradient(90deg, var(--orange), #fbbf24, var(--orange-dark));
      position: fixed; top: 0; left: 0; right: 0; z-index: 999;
    }

    /* ══════════════════════════════════════
       BREADCRUMB BAR
    ══════════════════════════════════════ */
    .breadcrumb-bar {
      background: var(--ivory);
      border-bottom: 1px solid var(--border);
      padding: 14px 32px;
      margin-top: 4px;
      display: flex; align-items: center; gap: 10px;
      font-size: .8rem; color: var(--stone);
      animation: slideDown .4s ease both;
    }
    .breadcrumb-bar a {
      color: var(--orange); font-weight: 600;
      transition: opacity .2s;
    }
    .breadcrumb-bar a:hover { opacity: .75; }
    .breadcrumb-bar .sep { opacity: .4; }
    .breadcrumb-bar .current { color: var(--charcoal); font-weight: 600; }

    /* ══════════════════════════════════════
       LAYOUT
    ══════════════════════════════════════ */
    .module-wrapper {
      max-width: 1060px;
      margin: 0 auto;
      padding: 36px 28px 100px;
    }

    /* ══════════════════════════════════════
       MODULE HEADER
    ══════════════════════════════════════ */
    .module-header {
      margin-bottom: 36px;
      opacity: 0;
      animation: fadeUp .55s .1s ease forwards;
    }
    .module-eyebrow {
      font-size: .7rem; font-weight: 700;
      letter-spacing: .14em; text-transform: uppercase;
      color: var(--orange); margin-bottom: 6px;
      display: flex; align-items: center; gap: 7px;
    }
    .module-title {
      font-family: var(--font-display);
      font-size: clamp(1.8rem, 3.5vw, 2.6rem);
      font-weight: 700; color: var(--charcoal);
      line-height: 1.15; margin-bottom: 18px;
    }

    /* Progress stepper */
    .progress-stepper {
      display: flex; align-items: center; gap: 0;
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 100px;
      padding: 6px 8px;
      width: fit-content;
      box-shadow: var(--shadow-sm);
    }
    .step {
      display: flex; align-items: center; gap: 7px;
      padding: 6px 16px; border-radius: 100px;
      font-size: .75rem; font-weight: 700;
      transition: background .2s, color .2s;
      white-space: nowrap;
    }
    .step.done     { background: var(--green-pale);   color: #15803d; }
    .step.active   { background: var(--orange-light); color: var(--orange-dark); }
    .step.locked   { color: var(--stone); opacity: .6; }
    .step-icon     { font-size: .85rem; }
    .step-divider  { width: 24px; height: 2px; background: var(--border); flex-shrink: 0; }

    /* ══════════════════════════════════════
       SECTION CARDS
    ══════════════════════════════════════ */
    .section-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 20px;
      overflow: hidden;
      margin-bottom: 28px;
      box-shadow: var(--shadow-sm);
      opacity: 0;
      transition: box-shadow .3s;
    }
    .section-card:hover { box-shadow: var(--shadow-md); }
    .section-card.anim-1 { animation: fadeUp .5s .15s ease forwards; }
    .section-card.anim-2 { animation: fadeUp .5s .25s ease forwards; }
    .section-card.anim-3 { animation: fadeUp .5s .35s ease forwards; }

    .section-header {
      display: flex; align-items: center; gap: 14px;
      padding: 20px 26px;
      border-bottom: 1px solid var(--border);
      background: var(--cream);
      cursor: pointer;
      user-select: none;
      transition: background .2s;
    }
    .section-header:hover { background: #f7f5f0; }

    .section-icon {
      width: 44px; height: 44px; border-radius: 12px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.1rem; flex-shrink: 0;
    }
    .icon-video  { background: #fff1f0; color: #dc2626; }
    .icon-notes  { background: var(--blue-pale); color: var(--blue); }
    .icon-quiz   { background: var(--orange-light); color: var(--orange-dark); }

    .section-title-wrap { flex: 1; }
    .section-label {
      font-size: .68rem; font-weight: 700;
      text-transform: uppercase; letter-spacing: .1em;
      color: var(--stone); margin-bottom: 2px;
    }
    .section-title {
      font-family: var(--font-display);
      font-size: 1.05rem; font-weight: 600; color: var(--charcoal);
    }

    .section-badge {
      padding: 4px 12px; border-radius: 100px;
      font-size: .7rem; font-weight: 700;
      text-transform: uppercase; letter-spacing: .04em;
      white-space: nowrap;
    }
    .badge-done     { background: var(--green-pale); color: #15803d; border: 1px solid #bbf7d0; }
    .badge-pending  { background: #fff8f0; color: var(--orange-dark); border: 1px solid #fed7aa; }
    .badge-locked   { background: var(--cream2); color: var(--stone); border: 1px solid var(--border); }

    .section-chevron {
      font-size: .85rem; color: var(--stone);
      transition: transform .3s;
    }
    .section-card.collapsed .section-chevron { transform: rotate(-90deg); }

    .section-body { padding: 26px; }
    .section-card.collapsed .section-body { display: none; }

    /* ══════════════════════════════════════
       VIDEO PLAYER
    ══════════════════════════════════════ */
    .video-container {
      position: relative;
      width: 100%;
      aspect-ratio: 16/9;
      background: #0f0f0f;
      border-radius: var(--r);
      overflow: hidden;
      box-shadow: var(--shadow-lg);
    }
    .video-container video {
      width: 100%; height: 100%;
      display: block;
    }
    .video-overlay {
      position: absolute; inset: 0;
      background: linear-gradient(135deg, rgba(249,115,22,.15), rgba(0,0,0,.35));
      display: flex; align-items: center; justify-content: center;
      cursor: pointer;
      transition: opacity .3s;
      z-index: 2;
    }
    .video-overlay.hidden { opacity: 0; pointer-events: none; }
    .play-btn {
      width: 72px; height: 72px; border-radius: 50%;
      background: rgba(255,255,255,.92);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.8rem; color: var(--orange-dark);
      box-shadow: 0 8px 32px rgba(0,0,0,.25);
      transition: transform .2s, box-shadow .2s;
    }
    .video-overlay:hover .play-btn {
      transform: scale(1.1);
      box-shadow: 0 12px 40px rgba(0,0,0,.35);
    }

    /* Video info bar */
    .video-info-bar {
      display: flex; align-items: center; justify-content: space-between;
      flex-wrap: wrap; gap: 10px;
      margin-top: 16px; padding: 12px 18px;
      background: var(--cream2);
      border-radius: var(--r-sm);
      border: 1px solid var(--border);
      font-size: .82rem; color: var(--stone);
    }
    .video-info-bar .vi-item {
      display: flex; align-items: center; gap: 6px; font-weight: 600;
    }
    .vi-item i { color: var(--orange); }

    /* ══════════════════════════════════════
       NOTES VIEWER
    ══════════════════════════════════════ */
    .pdf-embed-wrap {
      border-radius: var(--r);
      overflow: hidden;
      border: 1px solid var(--border);
      box-shadow: var(--shadow-sm);
      margin-bottom: 16px;
    }
    .pdf-embed-wrap embed {
      display: block; width: 100%; height: 520px;
    }
    .notes-actions {
      display: flex; align-items: center; gap: 12px; flex-wrap: wrap;
    }

    /* ══════════════════════════════════════
       BUTTONS
    ══════════════════════════════════════ */
    .btn-primary-sk {
      background: var(--orange); color: #fff;
      border: none; border-radius: 100px;
      font-family: var(--font-body); font-size: .85rem; font-weight: 700;
      padding: 11px 26px; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px;
      box-shadow: 0 4px 16px rgba(249,115,22,.35);
      transition: background .2s, transform .15s, box-shadow .2s;
      text-decoration: none;
    }
    .btn-primary-sk:hover {
      background: var(--orange-dark);
      transform: translateY(-2px);
      box-shadow: 0 6px 24px rgba(249,115,22,.45);
      color: #fff;
    }
    .btn-outline-sk {
      background: transparent; color: var(--orange);
      border: 1.5px solid var(--orange); border-radius: 100px;
      font-family: var(--font-body); font-size: .85rem; font-weight: 700;
      padding: 10px 24px; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px;
      transition: background .2s, color .2s, transform .15s;
      text-decoration: none;
    }
    .btn-outline-sk:hover {
      background: var(--orange-light);
      transform: translateY(-1px);
      color: var(--orange-dark);
    }
    .btn-success-sk {
      background: linear-gradient(135deg, #22c55e, #16a34a); color: #fff;
      border: none; border-radius: 100px;
      font-family: var(--font-body); font-size: .85rem; font-weight: 700;
      padding: 11px 26px; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px;
      box-shadow: 0 4px 16px rgba(34,197,94,.3);
      transition: transform .15s, box-shadow .2s;
    }
    .btn-success-sk:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 24px rgba(34,197,94,.42);
    }

    /* ══════════════════════════════════════
       QUIZ SECTION
    ══════════════════════════════════════ */
    .quiz-locked-banner {
      display: flex; align-items: center; gap: 16px;
      padding: 20px 24px;
      background: linear-gradient(135deg, #fff8f0, #fff3e6);
      border: 1px solid #fed7aa;
      border-radius: var(--r);
    }
    .quiz-locked-icon {
      width: 52px; height: 52px; border-radius: 14px;
      background: var(--orange-light); color: var(--orange-dark);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.4rem; flex-shrink: 0;
    }
    .quiz-locked-text h5 {
      font-family: var(--font-display);
      font-size: 1.1rem; font-weight: 600; margin-bottom: 4px;
    }
    .quiz-locked-text p { font-size: .85rem; color: var(--stone); margin: 0; }

    /* Checklist inside locked banner */
    .unlock-checklist {
      display: flex; gap: 12px; margin-top: 14px; flex-wrap: wrap;
    }
    .uc-item {
      display: flex; align-items: center; gap: 7px;
      font-size: .78rem; font-weight: 600;
      padding: 5px 12px; border-radius: 100px;
    }
    .uc-done    { background: var(--green-pale); color: #15803d; }
    .uc-pending { background: #fee2e2; color: #991b1b; }

    /* Quiz form */
    .quiz-form { }
    .quiz-q-card {
      background: var(--cream);
      border: 1px solid var(--border);
      border-radius: var(--r);
      padding: 22px 26px;
      margin-bottom: 18px;
      transition: border-color .2s, box-shadow .2s;
    }
    .quiz-q-card:hover { border-color: rgba(249,115,22,.35); box-shadow: var(--shadow-sm); }

    .q-number {
      display: inline-flex; align-items: center; justify-content: center;
      width: 28px; height: 28px; border-radius: 8px;
      background: var(--orange-light); color: var(--orange-dark);
      font-size: .72rem; font-weight: 800;
      margin-bottom: 10px;
    }
    .q-text {
      font-size: .95rem; font-weight: 600; color: var(--charcoal);
      margin-bottom: 16px; line-height: 1.55;
    }

    /* Radio options */
    .option-list { display: flex; flex-direction: column; gap: 10px; }
    .option-label {
      display: flex; align-items: center; gap: 12px;
      padding: 12px 16px;
      border: 1.5px solid var(--border);
      border-radius: var(--r-sm);
      cursor: pointer;
      font-size: .88rem; font-weight: 500;
      transition: border-color .2s, background .2s;
      position: relative;
    }
    .option-label:hover { border-color: var(--orange); background: var(--orange-light); }
    .option-label input[type="radio"] { display: none; }
    .option-label input[type="radio"]:checked + .option-dot { background: var(--orange); border-color: var(--orange); }
    .option-label:has(input:checked) { border-color: var(--orange); background: var(--orange-light); }
    .option-dot {
      width: 18px; height: 18px; border-radius: 50%;
      border: 2px solid var(--border);
      flex-shrink: 0;
      transition: background .2s, border-color .2s;
    }
    .option-key {
      width: 24px; height: 24px; border-radius: 6px;
      background: var(--cream2); color: var(--stone);
      font-size: .7rem; font-weight: 800;
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0;
    }
    .option-label:has(input:checked) .option-key {
      background: var(--orange); color: #fff;
    }

    /* Submit row */
    .quiz-submit-row {
      display: flex; align-items: center; justify-content: space-between;
      flex-wrap: wrap; gap: 14px;
      padding: 20px 26px;
      background: var(--cream2);
      border-radius: var(--r);
      border: 1px solid var(--border);
    }
    .quiz-submit-info { font-size: .82rem; color: var(--stone); font-weight: 500; }
    .quiz-submit-info strong { color: var(--charcoal); }

    /* No quiz message */
    .no-quiz-msg {
      text-align: center; padding: 40px 24px; color: var(--stone);
    }
    .no-quiz-msg i { font-size: 2rem; display: block; margin-bottom: 10px; opacity: .4; }
    .no-quiz-msg p { font-size: .9rem; }

    /* ══════════════════════════════════════
       TOAST
    ══════════════════════════════════════ */
    .toast-stack {
      position: fixed; bottom: 28px; right: 28px; z-index: 9999;
      display: flex; flex-direction: column; gap: 10px;
    }
    .sk-toast {
      min-width: 280px; max-width: 360px;
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: 14px; padding: 14px 18px;
      display: flex; align-items: flex-start; gap: 12px;
      box-shadow: var(--shadow-lg);
      animation: toastIn .35s cubic-bezier(.34,1.25,.64,1) both;
    }
    .sk-toast.removing { animation: toastOut .3s ease forwards; }
    .toast-icon {
      width: 36px; height: 36px; border-radius: 10px;
      display: flex; align-items: center; justify-content: center;
      font-size: .95rem; flex-shrink: 0;
    }
    .toast-success .toast-icon { background: var(--green-pale); color: #15803d; }
    .toast-info    .toast-icon { background: var(--orange-light); color: var(--orange-dark); }
    .toast-body { flex: 1; }
    .toast-title { font-size: .85rem; font-weight: 700; color: var(--charcoal); margin-bottom: 2px; }
    .toast-msg   { font-size: .78rem; color: var(--stone); }

    @keyframes toastIn  { from{opacity:0;transform:translateX(40px)} to{opacity:1;transform:translateX(0)} }
    @keyframes toastOut { from{opacity:1;transform:translateX(0)} to{opacity:0;transform:translateX(40px)} }

    /* ══════════════════════════════════════
       KEYFRAMES
    ══════════════════════════════════════ */
    @keyframes slideDown { from{opacity:0;transform:translateY(-14px)} to{opacity:1;transform:translateY(0)} }
    @keyframes fadeUp    { from{opacity:0;transform:translateY(20px)}  to{opacity:1;transform:translateY(0)} }

    /* ══════════════════════════════════════
       RESPONSIVE
    ══════════════════════════════════════ */
    @media (max-width: 640px) {
      .module-wrapper { padding: 24px 16px 80px; }
      .breadcrumb-bar { padding: 12px 16px; }
      .section-body   { padding: 18px; }
      .progress-stepper { flex-wrap: wrap; border-radius: var(--r); }
      .step-divider { display: none; }
    }
    /* ── Video controls styling ─────────────── */
#moduleVideo::-webkit-media-controls-panel {
  background: linear-gradient(transparent, rgba(0,0,0,0.75));
}
#moduleVideo::-webkit-media-controls-play-button,
#moduleVideo::-webkit-media-controls-timeline {
  filter: brightness(1.2);
}
/* Hide picture-in-picture */
#moduleVideo::-webkit-media-controls-toggle-closed-captions-button,
#moduleVideo::-webkit-media-controls-fullscreen-button {
  display: none !important;
}
.video-container {
    position: relative;
}

.video-controls {
    position: absolute;
    bottom: 15px;
    right: 15px;
    z-index: 3;
}

#settingsBtn {
    
    color: white;
    border: none;
    padding: 8px 10px;
    border-radius: 50%;
    cursor: pointer;
    font-size: 16px;
}

.settings-menu {
    display: none;
    position: absolute;
    bottom: 40px;
    right: 0;
    background: rgba(28,28,28,0.95);
    color: white;
    border-radius: 8px;
    padding: 8px 0;
    width: 150px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.3);
}

.menu-title {
    padding: 8px 12px;
    font-size: 13px;
    border-bottom: 1px solid #444;
}

.speed-option {
    padding: 8px 12px;
    cursor: pointer;
}

.speed-option:hover {
    background: #444;
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
      ResultSet rs = db1.Select(
        "SELECT * FROM student_register WHERE student_id='" + id + "' AND student_mail='" + name + "'"
      );
      if (rs.next()) {
        String student_name = rs.getString("student_name");
%>

<!-- ── Breadcrumb ────────────────────────────────────── -->
<div class="breadcrumb-bar">
  <i class="bi bi-house-fill" style="color:var(--orange);"></i>
  <a href="Student_View_Course.jsp">My Course</a>
  <span class="sep"><i class="bi bi-chevron-right"></i></span>
  <span class="current">Topic Viewer</span>
</div>

<%
  String moduleId   = request.getParameter("module_id");
  String topic_id   = request.getParameter("topic_id");
  Integer studentId = (Integer) session.getAttribute("student_id");
  String course_id  = request.getParameter("course_id");
  String course_name = request.getParameter("course_name");

  DbConnection db = new DbConnection();

  // Ensure student_modules entry exists
  ResultSet rsCheck = db.Select(
    "SELECT * FROM student_modules WHERE student_id='" + studentId +
    "' AND modules_id='" + moduleId + "' AND topic_id='" + topic_id + "'"
  );
  if (!rsCheck.next()) {
    db.update(
      "INSERT INTO student_modules(student_id, modules_id, topic_id, video_status, notes_status, status, course_id) " +
      "VALUES('" + studentId + "','" + moduleId + "','" + topic_id +
      "','pending','pending','pending','" + course_id + "')"
    );
  }

  ResultSet rsStatus = db.Select(
    "SELECT video_status, notes_status, status FROM student_modules " +
    "WHERE student_id='" + studentId + "' AND modules_id='" + moduleId + "' AND topic_id='" + topic_id + "'"
  );

  String videoStatus  = "pending";
  String notesStatus  = "pending";
  String moduleStatus = "pending";
  if (rsStatus.next()) {
    videoStatus  = rsStatus.getString("video_status");
    notesStatus  = rsStatus.getString("notes_status");
    moduleStatus = rsStatus.getString("status");
  }

  boolean videoDone = "completed".equals(videoStatus);
  boolean notesDone = "completed".equals(notesStatus);
  boolean quizReady = videoDone && notesDone
                   || "ready_for_quiz".equals(moduleStatus)
                   || "completed".equals(moduleStatus);

  ResultSet rsModule = db.Select("SELECT * FROM modules WHERE modules_id='" + moduleId + "'");
  if (rsModule.next()) {
    String moduleTitle = rsModule.getString("module_title");
    String videoPath   = rsModule.getString("video_path");
    String notesPath   = rsModule.getString("notes_path");
    String topicName   = rsModule.getString("topic_name");
%>

<!-- ── Module Wrapper ─────────────────────────────────── -->
<div class="module-wrapper">

  <!-- Module Header -->
  <div class="module-header">
    <div class="module-eyebrow">
      <i class="bi bi-mortarboard-fill"></i>
      <%= course_name != null ? course_name : "Course" %>
    </div>
    <h1 class="module-title"><%= moduleTitle %></h1>

    <!-- Progress Stepper -->
    <div class="progress-stepper">
      <div class="step <%= videoDone ? "done" : "active" %>">
        <span class="step-icon"><i class="bi bi-<%= videoDone ? "check-circle-fill" : "play-circle-fill" %>"></i></span>
        Video
      </div>
      <div class="step-divider"></div>
      <div class="step <%= notesDone ? "done" : (videoDone ? "active" : "locked") %>">
        <span class="step-icon"><i class="bi bi-<%= notesDone ? "check-circle-fill" : "file-earmark-text-fill" %>"></i></span>
        Notes
      </div>
      <div class="step-divider"></div>
      <div class="step <%= "completed".equals(moduleStatus) ? "done" : (quizReady ? "active" : "locked") %>">
        <span class="step-icon"><i class="bi bi-<%= "completed".equals(moduleStatus) ? "check-circle-fill" : "question-circle-fill" %>"></i></span>
        Quiz
      </div>
    </div>
  </div>

  <!-- ══ VIDEO SECTION ══ -->
<div class="section-card anim-1" id="videoSection">
  <div class="section-header" onclick="toggleSection('videoSection')">
    <div class="section-icon icon-video"><i class="bi bi-play-circle-fill"></i></div>
    <div class="section-title-wrap">
      <div class="section-label">Step 1</div>
      <div class="section-title">Watch the Video</div>
    </div>
    <span class="section-badge <%= videoDone ? "badge-done" : "badge-pending" %>">
      <i class="bi bi-<%= videoDone ? "check-lg" : "clock" %> me-1"></i>
      <%= videoDone ? "Completed" : "Pending" %>
    </span>
    <i class="bi bi-chevron-down section-chevron"></i>
  </div>

  <div class="section-body">
    <div class="video-container">

      <video id="moduleVideo" controls preload="metadata" 
             controlsList="nodownload noremoteplayback">
        <source src="<%= rsModule.getString("video_path") %>" type="video/mp4">
        Your browser does not support the video tag.
      </video>

      <!-- ✅ Overlay with Play Button + Resume Label -->
      <div id="overlay" style="
          position: absolute; top:0; left:0; width:100%; height:100%;
          z-index:2; cursor:pointer;
          background:rgba(0,0,0,0.40);
          display:flex; flex-direction:column;
          align-items:center; justify-content:center;">

        <!-- Big Play Button -->
        <div id="playCircle" style="
            width:75px; height:75px;
            background:rgba(255,255,255,0.95);
            border-radius:50%;
            display:flex; align-items:center; justify-content:center;
            box-shadow:0 4px 18px rgba(0,0,0,0.35);
            transition:transform 0.2s;">
          <i class="bi bi-play-fill" style="font-size:2rem; color:#1d4ed8; margin-left:6px;"></i>
        </div>

        <!-- Resume label — shown only if saved progress exists -->
        <div id="resumeLabel" style="
            display:none; margin-top:12px;
            background:rgba(0,0,0,0.55); color:#fff;
            font-size:0.88rem; font-weight:600;
            padding:5px 16px; border-radius:20px;">
          ▶ Resume from <span id="resumeTimeText">0:00</span>
        </div>

      </div>

      <!-- 💾 Auto-save indicator (top-right corner) -->
      <div id="saveIndicator" style="
          display:none; position:absolute;
          top:10px; right:12px; z-index:5;
          background:rgba(0,0,0,0.55); color:#4ade80;
          font-size:0.75rem; padding:4px 10px;
          border-radius:20px; pointer-events:none;">
        💾 Saving...
      </div>

    </div><!-- end .video-container -->
  </div><!-- end .section-body (temp close for controls outside) -->

  <!-- ✅ Your original controls — kept exactly as-is -->
  <div class="video-controls">
    <button id="settingsBtn">⏩</button>
    <div id="settingsMenu" class="settings-menu">
      <div class="menu-title">Playback Speed</div>
      <div class="speed-option" data-speed="0.5">0.5x</div>
      <div class="speed-option" data-speed="1">1x (Normal)</div>
      <div class="speed-option" data-speed="1.25">1.25x</div>
      <div class="speed-option" data-speed="1.5">1.5x</div>
      <div class="speed-option" data-speed="2">2x</div>
    </div>
  </div>

  <!-- Re-open section-body for info bar -->
  <div class="section-body" style="padding-top:0;">
    <div class="video-info-bar">
      <div class="vi-item">
        <i class="bi bi-info-circle-fill"></i>
        Forward skipping is disabled to ensure complete learning.
      </div>
      <div class="vi-item">
        <i class="bi bi-shield-check-fill"></i>
        Progress is auto-saved every 5 seconds.
      </div>
    </div>

    <% if (videoDone) { %>
    <div class="mt-3 d-flex align-items-center gap-2"
         style="color:#15803d; font-size:.85rem; font-weight:600;">
      <i class="bi bi-check-circle-fill"></i> Video completed — great job!
    </div>
    <% } %>
  </div>

</div><!-- end .section-card -->
</div>

  <!-- ══ NOTES SECTION ══ -->
  <div class="section-card anim-2 <%= !videoDone ? "collapsed" : "" %>" id="notesSection">
    <div class="section-header" onclick="toggleSection('notesSection')">
      <div class="section-icon icon-notes"><i class="bi bi-file-earmark-text-fill"></i></div>
      <div class="section-title-wrap">
        <div class="section-label">Step 2</div>
        <div class="section-title">Read the Notes</div>
      </div>
      <% if (!videoDone) { %>
      <span class="section-badge badge-locked"><i class="bi bi-lock-fill me-1"></i>Locked</span>
      <% } else { %>
      <span class="section-badge <%= notesDone ? "badge-done" : "badge-pending" %>">
        <i class="bi bi-<%= notesDone ? "check-lg" : "clock" %> me-1"></i>
        <%= notesDone ? "Completed" : "Pending" %>
      </span>
      <% } %>
      <i class="bi bi-chevron-down section-chevron"></i>
    </div>
    <div class="section-body">
      <% if (!videoDone) { %>
      <div class="quiz-locked-banner">
        <div class="quiz-locked-icon"><i class="bi bi-lock-fill"></i></div>
        <div class="quiz-locked-text">
          <h5>Complete the Video First</h5>
          <p>Watch the video fully to unlock notes.</p>
        </div>
      </div>
      <% } else { %>
      <div class="pdf-embed-wrap">
        <embed src="<%= notesPath %>" type="application/pdf" width="100%" height="520px">
      </div>
      <div class="notes-actions">
        <a href="<%= notesPath %>" target="_blank" class="btn-outline-sk">
          <i class="bi bi-download"></i> Download PDF
        </a>
        <% if (!notesDone) { %>
        <button class="btn-success-sk" onclick="markNotesComplete('<%= moduleId %>', '<%= topic_id %>')">
          <i class="bi bi-check2-circle"></i> Mark Notes Completed
        </button>
        <% } else { %>
        <div style="display:flex;align-items:center;gap:7px;color:#15803d;font-size:.85rem;font-weight:600;">
          <i class="bi bi-check-circle-fill"></i> Notes completed!
        </div>
        <% } %>
      </div>
      <% } %>
    </div>
  </div>

  <!-- ══ QUIZ SECTION ══ -->
  <div class="section-card anim-3 <%= !quizReady ? "collapsed" : "" %>" id="quizSection">
    <div class="section-header" onclick="toggleSection('quizSection')">
      <div class="section-icon icon-quiz"><i class="bi bi-question-circle-fill"></i></div>
      <div class="section-title-wrap">
        <div class="section-label">Step 3</div>
        <div class="section-title">Take the Quiz</div>
      </div>
      <% if (!quizReady) { %>
      <span class="section-badge badge-locked"><i class="bi bi-lock-fill me-1"></i>Locked</span>
      <% } else if ("completed".equals(moduleStatus)) { %>
      <span class="section-badge badge-done"><i class="bi bi-award-fill me-1"></i>Done</span>
      <% } else { %>
      <span class="section-badge badge-pending"><i class="bi bi-pencil-fill me-1"></i>Ready</span>
      <% } %>
      <i class="bi bi-chevron-down section-chevron"></i>
    </div>
    <div class="section-body">
      <% if (!quizReady) { %>
      <div class="quiz-locked-banner">
        <div class="quiz-locked-icon"><i class="bi bi-lock-fill"></i></div>
        <div class="quiz-locked-text">
          <h5>Quiz is Locked</h5>
          <p>Complete both Video and Notes to unlock the quiz.</p>
          <div class="unlock-checklist">
            <div class="uc-item <%= videoDone ? "uc-done" : "uc-pending" %>">
              <i class="bi bi-<%= videoDone ? "check-circle-fill" : "x-circle-fill" %>"></i>
              Video
            </div>
            <div class="uc-item <%= notesDone ? "uc-done" : "uc-pending" %>">
              <i class="bi bi-<%= notesDone ? "check-circle-fill" : "x-circle-fill" %>"></i>
              Notes
            </div>
          </div>
        </div>
      </div>
      <% } else {
           ResultSet rsQuiz = db.Select(
             "SELECT * FROM quiz WHERE module_id='" + moduleId + "' ORDER BY RAND() LIMIT 3"
           );
           boolean hasQuestions = false;
           java.util.List<String[]> questions = new java.util.ArrayList<>();
           while (rsQuiz.next()) {
             questions.add(new String[]{
               rsQuiz.getString("quiz_id"),
               rsQuiz.getString("question"),
               rsQuiz.getString("option_a"),
               rsQuiz.getString("option_b"),
               rsQuiz.getString("option_c"),
               rsQuiz.getString("option_d")
             });
           }
           rsQuiz.close();
           hasQuestions = !questions.isEmpty();

           if (hasQuestions) {
      %>
      <form action="Submit_Quiz" method="post" class="quiz-form" id="quizForm">
        <input type="hidden" name="module_id"   value="<%= moduleId %>">
        <input type="hidden" name="topic_name"  value="<%= topicName %>">
        <input type="hidden" name="topic_id"    value="<%= topic_id %>">
        <input type="hidden" name="course_id"   value="<%= course_id %>">
        <input type="hidden" name="course_name" value="<%= course_name %>">
        <input type="hidden" name="totalQuestions" value="<%= questions.size() %>">

        <%
          String[] optKeys = {"A","B","C","D"};
          for (int qi = 0; qi < questions.size(); qi++) {
            String[] q = questions.get(qi);
            int qNum = qi + 1;
        %>
        <div class="quiz-q-card">
          <div class="q-number">Q<%= qNum %></div>
          <div class="q-text"><%= q[1] %></div>
          <input type="hidden" name="quizId<%= qNum %>" value="<%= q[0] %>">
          <div class="option-list">
            <% for (int oi = 0; oi < 4; oi++) { %>
            <label class="option-label">
              <input type="radio" name="answer<%= qNum %>" value="<%= optKeys[oi] %>" required>
              <div class="option-dot"></div>
              <div class="option-key"><%= optKeys[oi] %></div>
              <span><%= q[2 + oi] %></span>
            </label>
            <% } %>
          </div>
        </div>
        <% } %>

        <div class="quiz-submit-row">
          <div class="quiz-submit-info">
            <strong><%= questions.size() %></strong> questions &nbsp;·&nbsp;
            Answer all to submit
          </div>
          <button type="submit" class="btn-primary-sk" onclick="return validateQuiz()">
            <i class="bi bi-send-fill"></i> Submit Quiz
          </button>
        </div>
      </form>
      <% } else { %>
      <div class="no-quiz-msg">
        <i class="bi bi-inbox"></i>
        <p>No quiz questions available for this topic yet.</p>
      </div>
      <% } } %>
    </div>
  </div>

</div><!-- /module-wrapper -->

<%
  } else { %>
<div style="padding:60px;text-align:center;color:var(--stone);">
  <i class="bi bi-exclamation-circle" style="font-size:2rem;"></i>
  <p style="margin-top:12px;">Topic not found.</p>
</div>
<% } %>

<!-- Toast stack -->
<div class="toast-stack" id="toastStack"></div>

<!-- ══ SESSION MESSAGE ══ -->
<%
  String msg = (String) session.getAttribute("msg");
  if (msg != null) {
%>
<script>
  window.addEventListener('DOMContentLoaded', function() {
    showToast('info', 'Notice', '<%= msg %>');
  });
</script>
<%
  }
  session.removeAttribute("msg");
%>

<script>
// ── Elements ──────────────────────────────────────────
const video         = document.getElementById("moduleVideo");
const overlay       = document.getElementById("overlay");
const playCircle    = document.getElementById("playCircle");
const resumeLabel   = document.getElementById("resumeLabel");
const resumeTimeText= document.getElementById("resumeTimeText");
const saveIndicator = document.getElementById("saveIndicator");
let isCompleted = false;
var moduleId = '<%= moduleId %>';
var topicId  = '<%= topic_id %>';

let lastTime    = 0;       // tracks furthest watched point
let ignoreSeek  = false;   // suppresses our own seeks
let saveInterval= null;    // 5-second save timer
let saveTimer   = null;    // indicator hide timer

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HELPER: format seconds → "m:ss"
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function fmt(sec) {
    if (isNaN(sec) || sec < 0) return "0:00";
    const m = Math.floor(sec / 60);
    const s = Math.floor(sec % 60);
    return m + ":" + (s < 10 ? "0" : "") + s;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 1. ON PAGE LOAD — fetch saved position from DB
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
window.addEventListener('load', () => {
    fetch("GetVideoProgress?module_id=" + moduleId + "&topic_id=" + topicId)
        .then(res => res.json())
        .then(data => {

            // ✅ If already completed — just play from beginning, no resume
            if (data.completed === true) {
                isCompleted = true;
                overlay.style.display = 'flex'; // show plain play button
                resumeLabel.style.display = 'none'; // hide resume label
                return;
            }

            const saved = parseFloat(data.seconds) || 0;
            if (saved > 2) {
                // Silently move video to saved position
                ignoreSeek = true;
                video.currentTime = saved;
                lastTime = saved;
                setTimeout(() => { ignoreSeek = false; }, 600);

                // Show "Resume from X:XX" on the overlay
                resumeTimeText.textContent = fmt(saved);
                resumeLabel.style.display  = "block";
            }
        })
        .catch(err => console.log("Progress load error:", err));
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 2. OVERLAY CLICK — hide overlay, start video
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
overlay.addEventListener('click', () => {
    overlay.style.display = 'none';
    video.play();
});

// Hover effect on play circle
playCircle.addEventListener('mouseenter', () => {
    playCircle.style.transform = 'scale(1.12)';
});
playCircle.addEventListener('mouseleave', () => {
    playCircle.style.transform = 'scale(1)';
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 3. VIDEO PLAY — start 5-second auto-save interval
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
video.addEventListener('play', () => {
    if (saveInterval) clearInterval(saveInterval);
    saveInterval = setInterval(() => {
        saveProgress(video.currentTime); // ✅ saves every 5 seconds
    }, 5000);
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 4. VIDEO PAUSE — save immediately when student stops
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
video.addEventListener('pause', () => {
    saveProgress(video.currentTime); // ✅ save on pause/stop
    if (saveInterval) clearInterval(saveInterval);
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 5. SAVE PROGRESS — calls SaveVideoProgress servlet
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ── In saveProgress() function — add course_id ──
function saveProgress(seconds) {
    if (isCompleted) return;
    if (seconds < 1) return;

    saveIndicator.style.display = 'block';
    if (saveTimer) clearTimeout(saveTimer);
    saveTimer = setTimeout(() => {
        saveIndicator.style.display = 'none';
    }, 1500);

    // ✅ Added &course_id=
    fetch("SaveVideoProgress?module_id=" + moduleId
          + "&topic_id=" + topicId
          + "&course_id=<%= course_id %>"   // ← ADD THIS
          + "&seconds=" + seconds)
        .catch(err => console.log("Save error:", err));
}

// ── In beforeunload — add course_id ──
window.addEventListener('beforeunload', () => {
    navigator.sendBeacon(
        "SaveVideoProgress?module_id=" + moduleId
        + "&topic_id=" + topicId
        + "&course_id=<%= course_id %>"     // ← ADD THIS
        + "&seconds=" + video.currentTime
    );
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 6. TRACK lastTime (furthest point watched)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
video.addEventListener('timeupdate', () => {
    if (!ignoreSeek && !video.paused && video.currentTime > lastTime) {
        lastTime = video.currentTime;
    }
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 7. BLOCK FORWARD SKIP
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
video.addEventListener('seeking', () => {
    if (isCompleted) return;
    if (ignoreSeek) return;
    const jump = video.currentTime - lastTime;
    if (jump > 0.5) {
        video.pause();
        alert("⛔ Skipping forward is not allowed! Please watch the video fully.");
        ignoreSeek = true;
        video.currentTime = lastTime; // ✅ snap back to last watched point
        setTimeout(() => {
            video.play();
            ignoreSeek = false;
        }, 400);
    }
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 8. VIDEO ENDED — mark complete + DELETE progress row
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
video.addEventListener('ended', () => {
    if (saveInterval) clearInterval(saveInterval);

    // ✅ DELETE progress from DB (video fully watched)
    fetch("DeleteVideoProgress?module_id=" + moduleId
          + "&topic_id=" + topicId)
        .then(() => {
            // Mark video as completed in student_modules
            return fetch("Update_Status?module_id=" + moduleId
                  + "&topic_id=" + topicId
                  + "&status=video_completed");
        })
        .then(() => {
            alert("✅ Video Completed! Please check Notes.");
            location.reload();
        })
        .catch(err => console.log("Complete error:", err));
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 9. SAVE ON TAB CLOSE / LOGOUT (sendBeacon is reliable)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
window.addEventListener('beforeunload', () => {
    navigator.sendBeacon(
        "SaveVideoProgress?module_id=" + moduleId
        + "&topic_id=" + topicId
        + "&seconds=" + video.currentTime
    );
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 10. DISABLE right-click & keyboard skipping
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
video.addEventListener('contextmenu', e => e.preventDefault());
window.addEventListener('keydown', e => {
    if (isCompleted) return;
    if (["ArrowRight", "ArrowLeft", " "].includes(e.key)) e.preventDefault();
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 11. SPEED SETTINGS (your original code — unchanged)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
const settingsBtn  = document.getElementById("settingsBtn");
const settingsMenu = document.getElementById("settingsMenu");
const speedOptions = document.querySelectorAll(".speed-option");

settingsBtn.addEventListener("click", () => {
    settingsMenu.style.display =
        settingsMenu.style.display === "block" ? "none" : "block";
});

speedOptions.forEach(option => {
    option.addEventListener("click", () => {
        video.playbackRate = parseFloat(option.dataset.speed);
        localStorage.setItem("videoSpeed", option.dataset.speed);
        settingsMenu.style.display = "none";
    });
});
</script>

<script>
/* ══════════════════════════════════════
   SECTION COLLAPSE TOGGLE
══════════════════════════════════════ */
function toggleSection(id) {
  var card = document.getElementById(id);
  if (card) card.classList.toggle('collapsed');
}

/* ══════════════════════════════════════
   TOAST SYSTEM
══════════════════════════════════════ */
function showToast(type, title, message) {
  var stack = document.getElementById('toastStack');
  var icons = { success: 'bi-check2-circle', info: 'bi-info-circle-fill' };
  var toast = document.createElement('div');
  toast.className = 'sk-toast toast-' + type;
  toast.innerHTML =
    '<div class="toast-icon"><i class="bi ' + (icons[type]||icons.info) + '"></i></div>' +
    '<div class="toast-body">' +
      '<div class="toast-title">' + title + '</div>' +
      '<div class="toast-msg">'  + message + '</div>' +
    '</div>';
  stack.appendChild(toast);
  setTimeout(function() {
    toast.classList.add('removing');
    setTimeout(function() { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 300);
  }, 3800);
}

/* ══════════════════════════════════════
   MARK NOTES COMPLETE
══════════════════════════════════════ */
function markNotesComplete(moduleId, topic_id) {
  fetch("Update_Status?module_id=" + moduleId + "&topic_id=" + topic_id + "&status=notes_completed")
    .then(function() {
      showToast('success', 'Notes Completed!', 'Quiz is now unlocked. Good luck!');
      setTimeout(function() { location.reload(); }, 1800);
    });
}


/* ══════════════════════════════════════
   QUIZ VALIDATION
══════════════════════════════════════ */
function validateQuiz() {
  var form  = document.getElementById('quizForm');
  var total = parseInt(form.querySelector('[name="totalQuestions"]').value);
  for (var i = 1; i <= total; i++) {
    var radios = form.querySelectorAll('[name="answer' + i + '"]');
    var answered = Array.from(radios).some(function(r) { return r.checked; });
    if (!answered) {
      showToast('info', 'Incomplete', 'Please answer Question ' + i + ' before submitting.');
      return false;
    }
  }
  return true;
}
</script>

<%
      } // end rs.next()
    } catch (Exception e) {
      out.println("<div style='padding:40px;color:red;'>Error: " + e.getMessage() + "</div>");
    }
  } else {
    session.setAttribute("msg", "Session Out Please Login");
    response.sendRedirect("index.jsp");
  }
%>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>
