<%@page import="java.sql.*"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SkillSync – Course Quiz</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    /* ══════════════════════════════════════
       TOKENS
    ══════════════════════════════════════ */
    :root {
      --ink:          #0f0f14;
      --ink-soft:     #2d2d3a;
      --ink-muted:    #6b6b80;
      --cream:        #fafaf7;
      --cream2:       #f4f4ef;
      --ivory:        #ffffff;
      --border:       #e8e4dd;
      --orange:       #f97316;
      --orange-dark:  #ea6c0a;
      --orange-pale:  #fff7ed;
      --orange-mid:   #fed7aa;
      --orange-glow:  rgba(249,115,22,.20);
      --green:        #22c55e;
      --green-dark:   #15803d;
      --green-pale:   #f0fdf4;
      --blue:         #3b82f6;
      --blue-pale:    #eff6ff;
      --red:          #ef4444;
      --red-pale:     #fef2f2;
      --gold:         #f59e0b;
      --shadow-sm:    0 2px 12px rgba(0,0,0,.06);
      --shadow-md:    0 8px 32px rgba(0,0,0,.10);
      --shadow-lg:    0 20px 60px rgba(0,0,0,.14);
      --r:            18px;
      --r-sm:         10px;
      --font-d:       'Cormorant Garamond', Georgia, serif;
      --font-b:       'Plus Jakarta Sans', sans-serif;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body {
      font-family: var(--font-b);
      background: var(--cream);
      color: var(--ink);
      min-height: 100vh;
      overflow-x: hidden;
    }

    /* ══════════════════════════════════════
       TOP STRIPE
    ══════════════════════════════════════ */
    .top-stripe {
      height: 4px;
      background: linear-gradient(90deg, var(--orange), #fbbf24, var(--orange-dark));
      position: fixed; top: 0; left: 0; right: 0; z-index: 999;
    }

    /* ══════════════════════════════════════
       QUIZ HEADER BAR (sticky)
    ══════════════════════════════════════ */
    .quiz-header-bar {
      position: fixed; top: 4px; left: 0; right: 0; z-index: 500;
      background: rgba(15,15,20,.94);
      backdrop-filter: blur(18px); -webkit-backdrop-filter: blur(18px);
      border-bottom: 1px solid rgba(255,255,255,.07);
      padding: 0 28px;
      height: 64px;
      display: flex; align-items: center; justify-content: space-between; gap: 16px;
      box-shadow: 0 4px 24px rgba(0,0,0,.25);
      animation: slideDown .4s ease both;
    }

    .qh-brand {
      font-family: var(--font-d);
      font-size: 1.4rem; font-weight: 600; color: var(--orange);
      display: flex; align-items: center; gap: 8px;
      white-space: nowrap;
    }
    .qh-brand span { color: #fff; }

    .qh-center {
      flex: 1; display: flex; align-items: center; justify-content: center; gap: 20px;
    }

    /* Progress dots in header */
    .q-dots { display: flex; gap: 6px; align-items: center; }
    .q-dot {
      width: 10px; height: 10px; border-radius: 50%;
      background: rgba(255,255,255,.2);
      transition: background .3s, transform .2s;
    }
    .q-dot.answered { background: var(--orange); transform: scale(1.2); }
    .q-dot.current  { background: #fff; box-shadow: 0 0 6px rgba(255,255,255,.5); }

    /* Timer widget */
    .timer-widget {
      display: flex; align-items: center; gap: 10px;
      background: rgba(255,255,255,.06);
      border: 1px solid rgba(255,255,255,.1);
      border-radius: 100px;
      padding: 7px 18px;
      white-space: nowrap;
    }
    .timer-icon { font-size: .95rem; color: var(--orange); }
    .timer-label { font-size: .7rem; font-weight: 600; color: rgba(255,255,255,.45); text-transform: uppercase; letter-spacing: .08em; }
    .timer-value {
      font-family: var(--font-d);
      font-size: 1.4rem; font-weight: 700; color: #fff;
      letter-spacing: .03em; min-width: 52px; text-align: center;
    }
    .timer-widget.warning .timer-value { color: #fbbf24; animation: timerPulse .8s ease-in-out infinite; }
    .timer-widget.danger  .timer-value { color: var(--red); animation: timerPulse .4s ease-in-out infinite; }
    @keyframes timerPulse { 0%,100%{opacity:1} 50%{opacity:.55} }

    /* ══════════════════════════════════════
       MAIN LAYOUT
    ══════════════════════════════════════ */
    .quiz-page {
      padding-top: 72px; /* below fixed header */
      min-height: 100vh;
    }

    /* Hero strip */
    .quiz-hero {
      background: var(--ink);
      padding: 40px 28px 52px;
      position: relative; overflow: hidden;
      text-align: center;
    }
    .quiz-hero::before {
      content: '';
      position: absolute; inset: 0;
      background: radial-gradient(ellipse 70% 80% at 50% 0%, rgba(249,115,22,.12) 0%, transparent 70%);
      pointer-events: none;
    }
    .quiz-hero-eyebrow {
      display: inline-flex; align-items: center; gap: 7px;
      background: rgba(249,115,22,.12); border: 1px solid rgba(249,115,22,.28);
      border-radius: 100px; padding: 5px 16px;
      font-size: .72rem; font-weight: 700; letter-spacing: .08em;
      text-transform: uppercase; color: var(--orange); margin-bottom: 14px;
      animation: fadeUp .5s ease both;
    }
    .quiz-hero h1 {
      font-family: var(--font-d);
      font-size: clamp(1.8rem, 4vw, 2.8rem);
      font-weight: 700; color: #fff; margin-bottom: 8px;
      animation: fadeUp .5s .06s ease both;
    }
    .quiz-hero p {
      font-size: .9rem; color: rgba(255,255,255,.5);
      animation: fadeUp .5s .12s ease both;
    }
    /* Stats chips under hero */
    .quiz-meta-chips {
      display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;
      margin-top: 20px;
      animation: fadeUp .5s .18s ease both;
    }
    .meta-chip {
      display: flex; align-items: center; gap: 6px;
      background: rgba(255,255,255,.06); border: 1px solid rgba(255,255,255,.1);
      border-radius: 100px; padding: 6px 16px;
      font-size: .78rem; font-weight: 600; color: rgba(255,255,255,.65);
    }
    .meta-chip i { color: var(--orange); }

    /* ══════════════════════════════════════
       QUIZ BODY
    ══════════════════════════════════════ */
    .quiz-body {
      max-width: 760px; margin: 0 auto;
      padding: 36px 24px 100px;
    }

    /* Question card */
    .q-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 22px;
      margin-bottom: 22px;
      overflow: hidden;
      box-shadow: var(--shadow-sm);
      opacity: 0;
      transition: box-shadow .25s, border-color .25s;
    }
    .q-card.anim { animation: cardIn .45s ease forwards; }
    .q-card:hover { box-shadow: var(--shadow-md); }
    .q-card.answered-card { border-color: var(--orange-mid); }

    @keyframes cardIn {
      from { opacity:0; transform: translateY(20px); }
      to   { opacity:1; transform: translateY(0); }
    }

    /* Question header */
    .q-card-header {
      display: flex; align-items: center; gap: 14px;
      padding: 18px 22px;
      background: var(--cream);
      border-bottom: 1px solid var(--border);
    }
    .q-num-badge {
      width: 34px; height: 34px; border-radius: 10px;
      background: var(--orange-pale); color: var(--orange-dark);
      font-size: .78rem; font-weight: 800;
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0;
    }
    .q-num-badge.done { background: var(--green-pale); color: var(--green-dark); }
    .q-text {
      font-size: .95rem; font-weight: 600; color: var(--ink);
      line-height: 1.55; flex: 1;
    }
    .q-check-icon { font-size: 1rem; color: var(--green); opacity: 0; transition: opacity .3s; flex-shrink: 0; }
    .q-card.answered-card .q-check-icon { opacity: 1; }

    /* Options */
    .q-options { padding: 16px 22px 20px; display: flex; flex-direction: column; gap: 10px; }

    .opt-label {
      display: flex; align-items: center; gap: 13px;
      padding: 13px 16px;
      border: 1.5px solid var(--border);
      border-radius: var(--r-sm);
      cursor: pointer; font-size: .9rem; font-weight: 500; color: var(--ink-soft);
      transition: border-color .18s, background .18s, transform .15s;
      position: relative; user-select: none;
    }
    .opt-label:hover { border-color: var(--orange-mid); background: var(--orange-pale); transform: translateX(3px); }
    .opt-label input[type="radio"] { display: none; }

    /* Custom radio dot */
    .opt-radio {
      width: 20px; height: 20px; border-radius: 50%;
      border: 2px solid var(--border);
      flex-shrink: 0; display: flex; align-items: center; justify-content: center;
      transition: border-color .18s, background .18s;
    }
    .opt-radio::after {
      content: ''; width: 8px; height: 8px; border-radius: 50%;
      background: var(--orange); opacity: 0; transition: opacity .18s;
    }

    /* Option key letter */
    .opt-key {
      width: 26px; height: 26px; border-radius: 7px;
      background: var(--cream2); color: var(--ink-muted);
      font-size: .72rem; font-weight: 800;
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0; transition: background .18s, color .18s;
    }

    /* Selected state */
    .opt-label:has(input:checked) {
      border-color: var(--orange);
      background: var(--orange-pale);
    }
    .opt-label:has(input:checked) .opt-radio { border-color: var(--orange); }
    .opt-label:has(input:checked) .opt-radio::after { opacity: 1; }
    .opt-label:has(input:checked) .opt-key { background: var(--orange); color: #fff; }

    /* ══════════════════════════════════════
       SUBMIT ROW
    ══════════════════════════════════════ */
    .submit-row {
      position: fixed; bottom: 0; left: 0; right: 0; z-index: 400;
      background: var(--ivory);
      border-top: 1px solid var(--border);
      padding: 14px 28px;
      display: flex; align-items: center; justify-content: space-between; gap: 16px;
      flex-wrap: wrap;
      box-shadow: 0 -6px 28px rgba(0,0,0,.08);
      animation: slideUp .5s .3s ease both;
    }

    .submit-info { font-size: .83rem; color: var(--ink-muted); font-weight: 500; }
    .submit-info strong { color: var(--ink); }
    .answered-count { color: var(--orange); font-weight: 700; }

    .btn-submit {
      background: var(--orange); color: #fff;
      border: none; border-radius: 100px;
      font-family: var(--font-b); font-size: .9rem; font-weight: 700;
      padding: 13px 36px; cursor: pointer;
      display: inline-flex; align-items: center; gap: 9px;
      box-shadow: 0 6px 24px var(--orange-glow);
      transition: background .2s, transform .15s, box-shadow .2s;
    }
    .btn-submit:hover {
      background: var(--orange-dark);
      transform: translateY(-2px);
      box-shadow: 0 8px 32px var(--orange-glow);
    }
    .btn-submit:disabled {
      background: var(--border); color: var(--ink-muted);
      box-shadow: none; cursor: not-allowed; transform: none;
    }

    @keyframes slideUp   { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
    @keyframes slideDown { from{opacity:0;transform:translateY(-14px)} to{opacity:1;transform:translateY(0)} }
    @keyframes fadeUp    { from{opacity:0;transform:translateY(18px)}  to{opacity:1;transform:translateY(0)} }

    /* ══════════════════════════════════════
       STATES: COMPLETED / LOCKED
    ══════════════════════════════════════ */
    .state-page {
      min-height: calc(100vh - 72px);
      display: flex; align-items: center; justify-content: center;
      padding: 40px 24px;
    }
    .state-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 24px;
      padding: 52px 44px; text-align: center;
      max-width: 480px; width: 100%;
      box-shadow: var(--shadow-lg);
      animation: fadeUp .5s ease both;
    }
    .state-icon {
      width: 80px; height: 80px; border-radius: 24px;
      display: flex; align-items: center; justify-content: center;
      font-size: 2rem; margin: 0 auto 22px;
    }
    .state-icon.success { background: var(--green-pale); color: var(--green-dark); box-shadow: 0 8px 32px rgba(34,197,94,.2); }
    .state-icon.locked  { background: var(--orange-pale); color: var(--orange-dark); box-shadow: 0 8px 32px var(--orange-glow); }

    .state-card h3 {
      font-family: var(--font-d);
      font-size: 1.9rem; font-weight: 700; color: var(--ink); margin-bottom: 10px;
    }
    .state-card p { font-size: .9rem; color: var(--ink-muted); line-height: 1.7; margin-bottom: 28px; }

    .btn-go {
      display: inline-flex; align-items: center; gap: 8px;
      background: var(--orange); color: #fff;
      border-radius: 100px; padding: 13px 32px;
      font-family: var(--font-b); font-size: .9rem; font-weight: 700;
      box-shadow: 0 6px 24px var(--orange-glow);
      transition: background .2s, transform .15s;
      text-decoration: none;
    }
    .btn-go:hover { background: var(--orange-dark); transform: translateY(-2px); color: #fff; }

    /* ══════════════════════════════════════
       TOAST
    ══════════════════════════════════════ */
    .toast-stack {
      position: fixed; bottom: 88px; right: 24px; z-index: 9999;
      display: flex; flex-direction: column; gap: 10px;
    }
    .sk-toast {
      min-width: 260px; max-width: 340px;
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: 14px; padding: 13px 16px;
      display: flex; align-items: flex-start; gap: 11px;
      box-shadow: var(--shadow-lg);
      animation: toastIn .3s cubic-bezier(.34,1.25,.64,1) both;
    }
    .sk-toast.removing { animation: toastOut .25s ease forwards; }
    .t-icon {
      width: 34px; height: 34px; border-radius: 9px;
      display: flex; align-items: center; justify-content: center;
      font-size: .9rem; flex-shrink: 0;
    }
    .t-icon.warn    { background: #fef9c3; color: #a16207; }
    .t-icon.success { background: var(--green-pale); color: var(--green-dark); }
    .t-icon.info    { background: var(--orange-pale); color: var(--orange-dark); }
    .t-title { font-size: .82rem; font-weight: 700; color: var(--ink); margin-bottom: 1px; }
    .t-msg   { font-size: .76rem; color: var(--ink-muted); }

    @keyframes toastIn  { from{opacity:0;transform:translateX(36px)} to{opacity:1;transform:translateX(0)} }
    @keyframes toastOut { from{opacity:1} to{opacity:0;transform:translateX(36px)} }

    /* ══════════════════════════════════════
       CONFIRM MODAL
    ══════════════════════════════════════ */
    .modal-overlay {
      position: fixed; inset: 0; z-index: 800;
      background: rgba(0,0,0,.55); backdrop-filter: blur(4px);
      display: none; align-items: center; justify-content: center; padding: 24px;
    }
    .modal-overlay.show { display: flex; }
    .modal-box {
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: 24px; padding: 40px 36px; text-align: center;
      max-width: 400px; width: 100%;
      box-shadow: var(--shadow-lg);
      animation: fadeUp .3s ease both;
    }
    .modal-icon { font-size: 2.2rem; margin-bottom: 14px; }
    .modal-box h4 { font-family: var(--font-d); font-size: 1.5rem; font-weight: 700; margin-bottom: 8px; }
    .modal-box p  { font-size: .87rem; color: var(--ink-muted); margin-bottom: 26px; line-height: 1.65; }
    .modal-btns { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
    .btn-modal-cancel {
      background: var(--cream2); color: var(--ink-soft);
      border: 1px solid var(--border); border-radius: 100px;
      font-family: var(--font-b); font-size: .85rem; font-weight: 700;
      padding: 11px 26px; cursor: pointer;
      transition: background .2s;
    }
    .btn-modal-cancel:hover { background: var(--border); }
    .btn-modal-confirm {
      background: var(--orange); color: #fff;
      border: none; border-radius: 100px;
      font-family: var(--font-b); font-size: .85rem; font-weight: 700;
      padding: 11px 26px; cursor: pointer;
      box-shadow: 0 4px 16px var(--orange-glow);
      transition: background .2s, transform .15s;
    }
    .btn-modal-confirm:hover { background: var(--orange-dark); transform: translateY(-1px); }

    /* ══════════════════════════════════════
       RESPONSIVE
    ══════════════════════════════════════ */
    @media (max-width: 640px) {
      .quiz-header-bar { padding: 0 16px; }
      .qh-center { display: none; }
      .quiz-body { padding: 24px 14px 100px; }
      .submit-row { padding: 12px 16px; }
      .q-card-header { padding: 14px 16px; }
      .q-options { padding: 12px 16px 16px; }
      .state-card { padding: 36px 24px; }
    }
  </style>
</head>
<body>

<div class="top-stripe"></div>
<div class="toast-stack" id="toastStack"></div>

<!-- Confirm Submit Modal -->
<div class="modal-overlay" id="confirmModal">
  <div class="modal-box">
    <div class="modal-icon">📝</div>
    <h4>Submit Quiz?</h4>
    <p>Make sure you've answered all questions. Once submitted, you cannot change your answers.</p>
    <div class="modal-btns">
      <button class="btn-modal-cancel" onclick="closeModal()">Go Back</button>
      <button class="btn-modal-confirm" onclick="doSubmit()"><i class="bi bi-send-fill me-1"></i>Submit Now</button>
    </div>
  </div>
</div>

<%
  Integer studentId = (Integer) session.getAttribute("student_id");
  String courseId   = request.getParameter("course_id");

  if (studentId == null) { response.sendRedirect("index.jsp"); return; }

  if (courseId == null || courseId.trim().isEmpty()) {
%>
<div class="quiz-page">
  <div class="state-page">
    <div class="state-card">
      <div class="state-icon locked"><i class="bi bi-exclamation-triangle-fill"></i></div>
      <h3>Course Not Found</h3>
      <p>Course ID is missing. Please go back and try again.</p>
      <a href="Student_View_Course.jsp" class="btn-go"><i class="bi bi-arrow-left"></i> Go Home</a>
    </div>
  </div>
</div>
<%
    return;
  }

  DbConnection db = new DbConnection();

  // Check course status
  ResultSet rsStatus = db.Select(
    "SELECT course_status FROM student_courses WHERE student_id=" + studentId + " AND course_id='" + courseId + "'"
  );
  boolean canAttempt = true;
  if (rsStatus.next()) {
    String status = rsStatus.getString("course_status");
    if ("completed".equalsIgnoreCase(status)) canAttempt = false;
  }
  rsStatus.close();

  if (!canAttempt) {
%>
<!-- ══ ALREADY COMPLETED ══ -->
<div class="quiz-page">
  <div class="state-page">
    <div class="state-card">
      <div class="state-icon success"><i class="bi bi-award-fill"></i></div>
      <h3>Quiz Completed!</h3>
      <p>You have already completed this course quiz. Congratulations on finishing the course! Check your certificate below.</p>
      <a href="Student_View_Course.jsp" class="btn-go"><i class="bi bi-house-fill"></i> Back to Courses</a>
    </div>
  </div>
</div>
<%
  } else {
    // Check all topics completed
    boolean allTopicsCompleted = true;
    ResultSet rsTopics = db.Select(
      "SELECT t.topic_id, st.status FROM topics t " +
      "LEFT JOIN student_topics st ON t.topic_id = st.topic_id AND st.student_id=" + studentId +
      " WHERE t.course_id='" + courseId + "'"
    );
    while (rsTopics != null && rsTopics.next()) {
      if (!"completed".equalsIgnoreCase(rsTopics.getString("status"))) {
        allTopicsCompleted = false; break;
      }
    }
    if (rsTopics != null) rsTopics.close();

    if (!allTopicsCompleted) {
%>
<!-- ══ TOPICS NOT DONE ══ -->
<div class="quiz-page">
  <div class="state-page">
    <div class="state-card">
      <div class="state-icon locked"><i class="bi bi-lock-fill"></i></div>
      <h3>Quiz Locked</h3>
      <p>You must complete all course topics before you can attempt the quiz. Keep going — you're almost there!</p>
      <a href="Student_Enroll_Course.jsp?course_id=<%= courseId %>" class="btn-go">
        <i class="bi bi-book-fill"></i> Continue Learning
      </a>
    </div>
  </div>
</div>
<%
    } else {
      // Fetch questions
      String level = request.getParameter("level");
      if (level == null) level = "NORMAL";

      ResultSet rsQuiz = db.Select(
        "SELECT * FROM topic_quiz WHERE course_id='" + courseId + "' AND status='" + level + "' " +
        "ORDER BY RAND() LIMIT 5"
      );

      // Buffer questions
      java.util.List<String[]> questions = new java.util.ArrayList<>();
      while (rsQuiz != null && rsQuiz.next()) {
        questions.add(new String[]{
          rsQuiz.getString("question_id"),
          rsQuiz.getString("question"),
          rsQuiz.getString("option_a"),
          rsQuiz.getString("option_b"),
          rsQuiz.getString("option_c"),
          rsQuiz.getString("option_d")
        });
      }
      if (rsQuiz != null) rsQuiz.close();

      int totalQ = questions.size();
      String[] optKeys = {"A","B","C","D"};
%>

<!-- ══ QUIZ HEADER BAR ══ -->
<div class="quiz-header-bar" id="quizHeaderBar">
  <div class="qh-brand">Skill<span>Sync</span></div>

  <div class="qh-center">
    <!-- Question dot tracker -->
    <div class="q-dots" id="qDots">
      <% for (int di = 0; di < totalQ; di++) { %>
      <div class="q-dot <%= di == 0 ? "current" : "" %>" id="dot-<%= di %>"></div>
      <% } %>
    </div>
  </div>

  <!-- Timer -->
  <div class="timer-widget" id="timerWidget">
    <i class="bi bi-clock-fill timer-icon"></i>
    <div>
      <div class="timer-label">Time Left</div>
      <div class="timer-value" id="timerDisplay">02:00</div>
    </div>
  </div>
</div>

<!-- ══ QUIZ PAGE ══ -->
<div class="quiz-page">

  <!-- Hero strip -->
  <div class="quiz-hero">
    <div class="quiz-hero-eyebrow"><i class="bi bi-pencil-square"></i> Course Assessment</div>
    <h1>Course Quiz</h1>
    <p>Answer all questions carefully. Your progress is tracked automatically.</p>
    <div class="quiz-meta-chips">
      <div class="meta-chip"><i class="bi bi-question-circle-fill"></i> <%= totalQ %> Questions</div>
      <div class="meta-chip"><i class="bi bi-clock-fill"></i> 2 Minutes</div>
      <div class="meta-chip"><i class="bi bi-shield-check-fill"></i> Auto-submit on timeout</div>
      <div class="meta-chip"><i class="bi bi-bar-chart-fill"></i> Level: <%= level %></div>
    </div>
  </div>

  <!-- Quiz body -->
  <div class="quiz-body">
    <form id="quizForm" action="Student_Quiz_Submit" method="post">
      <input type="hidden" name="student_id" value="<%= studentId %>">
      <input type="hidden" name="course_id"  value="<%= courseId %>">
      <input type="hidden" name="quiz_level" value="<%= level %>">

      <%
        for (int qi = 0; qi < questions.size(); qi++) {
          String[] q = questions.get(qi);
          int qNum = qi + 1;
      %>
      <div class="q-card" id="qcard-<%= qi %>" data-index="<%= qi %>">
        <div class="q-card-header">
          <div class="q-num-badge" id="qbadge-<%= qi %>">Q<%= qNum %></div>
          <div class="q-text"><%= q[1] %></div>
          <i class="bi bi-check-circle-fill q-check-icon" id="qcheck-<%= qi %>"></i>
        </div>
        <div class="q-options">
          <input type="hidden" name="question_id" value="<%= q[0] %>">
          <% for (int oi = 0; oi < 4; oi++) { %>
          <label class="opt-label" onclick="markAnswered(<%= qi %>)">
            <input type="radio" name="answer_<%= q[0] %>" value="<%= optKeys[oi] %>" required>
            <div class="opt-radio"></div>
            <div class="opt-key"><%= optKeys[oi] %></div>
            <span><%= q[2 + oi] %></span>
          </label>
          <% } %>
        </div>
      </div>
      <%
        } // end for
      %>

    </form><!-- /quizForm -->
  </div><!-- /quiz-body -->

</div><!-- /quiz-page -->

<!-- ══ FIXED SUBMIT ROW ══ -->
<div class="submit-row">
  <div class="submit-info">
    <strong><span class="answered-count" id="answeredCount">0</span>/<%= totalQ %></strong> answered
    &nbsp;·&nbsp; Answer all questions to submit
  </div>
  <button class="btn-submit" id="submitBtn" onclick="confirmSubmit()">
    <i class="bi bi-send-fill"></i> Submit Quiz
  </button>
</div>

<script>
/* ══════════════════════════════════════
   TIMER
══════════════════════════════════════ */
(function() {
  var totalTime   = 2 * 60; // 2 minutes
  var display     = document.getElementById('timerDisplay');
  var widget      = document.getElementById('timerWidget');
  var form        = document.getElementById('quizForm');
  var warned30    = false;
  var warned60    = false;

  function pad(n) { return n < 10 ? '0' + n : n; }

  function tick() {
    var mins = Math.floor(totalTime / 60);
    var secs = totalTime % 60;
    display.textContent = pad(mins) + ':' + pad(secs);

    if (totalTime <= 30 && !warned30) {
      warned30 = true;
      widget.classList.add('danger');
      showToast('warn', '⚠️ Hurry Up!', '30 seconds remaining!');
    } else if (totalTime <= 60 && !warned60) {
      warned60 = true;
      widget.classList.add('warning');
      showToast('warn', 'Time Warning', '1 minute remaining!');
    }

    if (totalTime <= 0) {
      clearInterval(timer);
      showToast('info', "Time's Up!", 'Quiz is being submitted automatically...');
      setTimeout(function() { form.submit(); }, 1200);
      return;
    }
    totalTime--;
  }

  tick();
  var timer = setInterval(tick, 1000);
})();

/* ══════════════════════════════════════
   ANSWER TRACKING
══════════════════════════════════════ */
var answeredSet = {};
var totalQ      = <%= totalQ %>;

function markAnswered(idx) {
  if (!answeredSet[idx]) {
    answeredSet[idx] = true;
    // Update card style
    var card  = document.getElementById('qcard-' + idx);
    var badge = document.getElementById('qbadge-' + idx);
    if (card)  card.classList.add('answered-card');
    if (badge) badge.classList.add('done');
    // Update dot
    var dot = document.getElementById('dot-' + idx);
    if (dot) { dot.classList.remove('current'); dot.classList.add('answered'); }
    // Next dot becomes current
    var nextDot = document.getElementById('dot-' + (idx + 1));
    if (nextDot) nextDot.classList.add('current');
  }
  updateCount();
}

function updateCount() {
  var count   = Object.keys(answeredSet).length;
  var el      = document.getElementById('answeredCount');
  var btn     = document.getElementById('submitBtn');
  if (el) el.textContent = count;
  if (btn) btn.disabled = (count < totalQ);
}

// Init submit button as disabled
window.addEventListener('DOMContentLoaded', function() {
  updateCount();

  // Stagger card animations
  document.querySelectorAll('.q-card').forEach(function(card, idx) {
    setTimeout(function() { card.classList.add('anim'); }, idx * 90 + 100);
  });
});

// Listen to radio changes (in case user uses keyboard)
document.querySelectorAll('.opt-label input[type="radio"]').forEach(function(radio) {
  radio.addEventListener('change', function() {
    var card = radio.closest('.q-card');
    if (card) markAnswered(parseInt(card.getAttribute('data-index')));
  });
});

/* ══════════════════════════════════════
   CONFIRM MODAL
══════════════════════════════════════ */
function confirmSubmit() {
  var count = Object.keys(answeredSet).length;
  if (count < totalQ) {
    showToast('warn', 'Incomplete', 'Please answer all ' + totalQ + ' questions before submitting.');
    return;
  }
  document.getElementById('confirmModal').classList.add('show');
}

function closeModal() {
  document.getElementById('confirmModal').classList.remove('show');
}

function doSubmit() {
  closeModal();
  document.getElementById('quizForm').submit();
}

// Close modal on overlay click
document.getElementById('confirmModal').addEventListener('click', function(e) {
  if (e.target === this) closeModal();
});

/* ══════════════════════════════════════
   TOAST
══════════════════════════════════════ */
function showToast(type, title, message) {
  var stack  = document.getElementById('toastStack');
  var icons  = { warn:'bi-exclamation-triangle-fill', success:'bi-check2-circle', info:'bi-info-circle-fill' };
  var toast  = document.createElement('div');
  toast.className = 'sk-toast';
  toast.innerHTML =
    '<div class="t-icon ' + type + '"><i class="bi ' + (icons[type]||icons.info) + '"></i></div>' +
    '<div><div class="t-title">' + title + '</div><div class="t-msg">' + message + '</div></div>';
  stack.appendChild(toast);
  setTimeout(function() {
    toast.classList.add('removing');
    setTimeout(function() { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 280);
  }, 3600);
}
</script>

<%
    } // end allTopicsCompleted
  } // end canAttempt
  db.close();
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
