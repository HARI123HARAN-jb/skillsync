<%-- 
    Document   : Student_Profile
    Created on : 17-Feb-2026, 12:37:11
    Author     : user
--%>

<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Integer id = (Integer) session.getAttribute("student_id");
        String mail = (String) session.getAttribute("student_mail");

        if (id != null && mail != null) {
            try {
                DbConnection db1 = new DbConnection();
                ResultSet rs2 = db1.Select("SELECT * FROM student_register WHERE student_id='" + id + "' AND student_mail='" + mail + "'");
                if (rs2.next()) {
                    String student_name = rs2.getString("student_name"); 
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SkillSync – My Profile</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <!-- Font Awesome for stars -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <style>
    /* ══════════════════════════════════════
       DESIGN TOKENS
    ══════════════════════════════════════ */
    :root {
      --teal:        orange;
      --teal-dark:   orange;
      --teal-light:  #99f6e4;
      --teal-pale:   #f0fdfb;
      --teal-ring:   rgba(13,148,136,.18);
      --gold:        #d97706;
      --gold-light:  #fbbf24;
      --gold-pale:   #fef3c7;
      --silver:      #94a3b8;
      --silver-pale: #f1f5f9;
      --bronze:      #cd7f32;
      --bronze-pale: #fdf2e9;
      --cream:       #fafaf7;
      --cream2:      #f4f4ef;
      --ivory:       #fffffe;
      --charcoal:    #1a1a1a;
      --slate:       #44403c;
      --stone:       #78716c;
      --border:      #e2e8e4;
      --red:         #ef4444;
      --green:       #22c55e;
      --shadow-sm:   0 2px 10px rgba(0,0,0,.06);
      --shadow-md:   0 6px 28px rgba(0,0,0,.09);
      --shadow-lg:   0 20px 60px rgba(0,0,0,.12);
      --r:           16px;
      --font-display:'Cormorant Garamond', Georgia, serif;
      --font-body:   'Plus Jakarta Sans', sans-serif;
      --nav-h:       68px;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body {
      font-family: var(--font-body);
      background: var(--cream);
      color: var(--charcoal);
      overflow-x: hidden;
      padding-top: var(--nav-h);
    }
    a { text-decoration: none; color: inherit; }
    ul { list-style: none; margin: 0; padding: 0; }

    /* ══════════════════════════════════════
       NAVBAR
    ══════════════════════════════════════ */
    .sk-nav {
      position: fixed; top: 0; left: 0; right: 0; z-index: 400;
      height: var(--nav-h);
      background: rgba(250,250,247,.96);
      backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px);
      border-bottom: 1px solid var(--border);
      display: flex; align-items: center;
      transition: box-shadow .3s;
    }
    .sk-nav.scrolled { box-shadow: var(--shadow-md); }
    .nav-inner {
      max-width: 1280px; margin: 0 auto; width: 100%;
      padding: 0 28px;
      display: flex; align-items: center; justify-content: space-between; gap: 16px;
    }
    .sk-brand { font-family: var(--font-display); font-size: 1.6rem; font-weight: 600; color: var(--teal); letter-spacing: -.3px; }
    .sk-brand span { color: var(--charcoal); }
    .nav-tabs-row { display: flex; gap: 4px; align-items: center; }
    .nav-tab {
      padding: 7px 16px; border-radius: 100px;
      font-size: .85rem; font-weight: 600; color: var(--stone);
      transition: background .2s, color .2s;
      display: flex; align-items: center; gap: 6px;
    }
    .nav-tab:hover { background: var(--teal-pale); color: var(--teal); }
    .nav-tab.active { background: var(--teal); color: #fff; box-shadow: 0 2px 10px rgba(13,148,136,.30); }
    .btn-back {
      display: flex; align-items: center; gap: 7px;
      padding: 8px 18px; border-radius: 100px;
      border: 1.5px solid var(--border); background: none;
      font-family: var(--font-body); font-size: .84rem; font-weight: 600;
      color: var(--stone); cursor: pointer;
      transition: border-color .2s, color .2s;
    }
    .btn-back:hover { border-color: var(--teal); color: var(--teal); }

    /* ══════════════════════════════════════
       PROFILE HERO BANNER
    ══════════════════════════════════════ */
    .profile-hero {
      background: linear-gradient(135deg, var(--teal), var(--teal-dark));
      padding: 52px 28px 80px;
      position: relative; overflow: hidden;
    }
    .profile-hero::before {
      content: '';
      position: absolute; top: -60px; right: -60px;
      width: 260px; height: 260px; border-radius: 50%;
      background: rgba(255,255,255,.07);
    }
    .profile-hero::after {
      content: '';
      position: absolute; bottom: -40px; left: 18%;
      width: 180px; height: 180px; border-radius: 50%;
      background: rgba(255,255,255,.05);
    }
    .hero-inner {
      max-width: 1280px; margin: 0 auto;
      display: flex; align-items: center; gap: 28px;
      position: relative; z-index: 1;
      flex-wrap: wrap;
    }

    /* Avatar ring */
    .avatar-ring {
      width: 110px; height: 110px; border-radius: 50%;
      border: 3px solid rgba(255,255,255,.40);
      padding: 4px; flex-shrink: 0;
      position: relative;
    }
    .avatar-ring img {
      width: 100%; height: 100%; border-radius: 50%;
      object-fit: cover;
      display: block;
    }
    .avatar-online {
      position: absolute; bottom: 6px; right: 6px;
      width: 16px; height: 16px; border-radius: 50%;
      background: var(--green); border: 2px solid var(--teal-dark);
    }

    .hero-name {
      font-family: var(--font-display);
      font-size: clamp(1.6rem, 3vw, 2.2rem);
      font-weight: 600; color: #fff; line-height: 1.1; margin-bottom: 4px;
    }
    .hero-email { font-size: .88rem; color: rgba(255,255,255,.72); margin-bottom: 12px; }
    .hero-pills { display: flex; gap: 8px; flex-wrap: wrap; }
    .hero-pill {
      background: rgba(255,255,255,.15);
      border: 1px solid rgba(255,255,255,.25);
      color: #fff; font-size: .75rem; font-weight: 600;
      padding: 4px 12px; border-radius: 100px;
      display: flex; align-items: center; gap: 5px;
    }

    /* ══════════════════════════════════════
       TAB CONTENT AREA
    ══════════════════════════════════════ */
    .page-content {
      max-width: 1280px; margin: -36px auto 80px;
      padding: 0 28px;
      position: relative; z-index: 2;
    }

    /* Tab nav card */
    .tab-nav-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 20px;
      padding: 6px;
      display: flex; gap: 4px;
      margin-bottom: 28px;
      box-shadow: var(--shadow-md);
    }
    .tab-btn {
      flex: 1; padding: 12px 16px;
      border: none; border-radius: 14px;
      font-family: var(--font-body);
      font-size: .87rem; font-weight: 700;
      color: var(--stone); cursor: pointer; background: none;
      transition: background .2s, color .2s, box-shadow .2s;
      display: flex; align-items: center; justify-content: center; gap: 7px;
    }
    .tab-btn:hover { background: var(--teal-pale); color: var(--teal); }
    .tab-btn.active {
      background: var(--teal); color: #fff;
      box-shadow: 0 3px 14px rgba(13,148,136,.35);
    }

    /* Tab panels */
    .tab-panel { display: none; animation: panelIn .3s ease both; }
    .tab-panel.active { display: block; }
    @keyframes panelIn { from{opacity:0;transform:translateY(12px)} to{opacity:1;transform:translateY(0)} }

    /* ══════════════════════════════════════
       PROFILE CARD
    ══════════════════════════════════════ */
    .profile-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 20px;
      overflow: hidden;
      box-shadow: var(--shadow-md);
    }
    .pc-header {
      background: linear-gradient(135deg, var(--teal), var(--teal-dark));
      padding: 20px 28px;
      display: flex; align-items: center; justify-content: space-between;
    }
    .pc-header h3 { font-family: var(--font-display); font-size: 1.2rem; font-weight: 600; color: #fff; }
    .pc-header p  { font-size: .8rem; color: rgba(255,255,255,.72); }

    .pc-body { padding: 28px; }

    /* Profile field rows */
    .profile-row {
      display: flex; align-items: flex-start; gap: 14px;
      padding: 14px 0; border-bottom: 1px solid var(--border);
    }
    .profile-row:last-child { border-bottom: none; padding-bottom: 0; }
    .pr-icon {
      width: 36px; height: 36px; border-radius: 10px;
      background: var(--teal-pale);
      border: 1px solid rgba(13,148,136,.18);
      display: flex; align-items: center; justify-content: center;
      font-size: .85rem; color: var(--teal); flex-shrink: 0;
      margin-top: 2px;
    }
    .pr-label { font-size: .72rem; font-weight: 700; color: var(--stone); text-transform: uppercase; letter-spacing: .07em; margin-bottom: 3px; }
    .pr-value { font-size: .93rem; font-weight: 600; color: var(--charcoal); }

    /* Edit profile form */
    .edit-panel {
      display: none; padding: 28px;
      animation: panelIn .3s ease both;
    }
    .edit-panel.show { display: block; }
    .ef-group { margin-bottom: 16px; }
    .ef-label { display: block; font-size: .78rem; font-weight: 700; color: var(--charcoal); margin-bottom: 6px; }
    .ef-input, .ef-textarea {
      width: 100%; padding: 10px 16px;
      border: 1.5px solid var(--border); border-radius: 10px;
      font-family: var(--font-body); font-size: .9rem; font-weight: 500;
      color: var(--charcoal); background: var(--cream2);
      outline: none;
      transition: border-color .2s, box-shadow .2s, background .2s;
    }
    .ef-input:focus, .ef-textarea:focus {
      border-color: var(--teal); background: #fff;
      box-shadow: 0 0 0 3px var(--teal-ring);
    }
    .ef-textarea { resize: vertical; min-height: 80px; }
    .ef-actions { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 6px; }
    .btn-save {
      background: var(--teal); color: #fff;
      border: none; border-radius: 100px;
      font-family: var(--font-body); font-size: .87rem; font-weight: 700;
      padding: 10px 24px; cursor: pointer;
      box-shadow: 0 3px 12px rgba(13,148,136,.32);
      transition: background .2s, transform .15s;
      display: flex; align-items: center; gap: 6px;
    }
    .btn-save:hover { background: var(--teal-dark); transform: translateY(-1px); }
    .btn-cancel {
      background: none; border: 1.5px solid var(--border);
      border-radius: 100px; font-family: var(--font-body);
      font-size: .87rem; font-weight: 600; color: var(--stone);
      padding: 10px 22px; cursor: pointer;
      transition: border-color .2s, color .2s;
    }
    .btn-cancel:hover { border-color: var(--red); color: var(--red); }
    .btn-edit {
      background: none; border: 1.5px solid rgba(255,255,255,.40);
      color: #fff; border-radius: 100px;
      font-family: var(--font-body); font-size: .82rem; font-weight: 700;
      padding: 7px 18px; cursor: pointer;
      display: flex; align-items: center; gap: 6px;
      transition: background .2s;
    }
    .btn-edit:hover { background: rgba(255,255,255,.15); }

    /* ══════════════════════════════════════
       BADGES SECTION
    ══════════════════════════════════════ */
    .badges-grid {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 20px;
    }
    .badge-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 20px; padding: 28px 20px;
      text-align: center;
      opacity: 0; transform: translateY(20px) scale(.96);
      transition: box-shadow .3s, transform .3s, border-color .3s;
      position: relative; overflow: hidden;
    }
    .badge-card.visible {
      animation: badgeReveal .55s ease forwards;
    }
    @keyframes badgeReveal {
      from { opacity:0; transform:translateY(20px) scale(.96); }
      to   { opacity:1; transform:translateY(0)    scale(1); }
    }
    .badge-card:hover { box-shadow: var(--shadow-lg); transform: translateY(-5px); }

    /* Gold badge */
    .badge-card.gold   { border-color: rgba(217,119,6,.35); }
    .badge-card.gold::before   { content:''; position:absolute; top:0; left:0; right:0; height:4px; background:linear-gradient(90deg,var(--gold),var(--gold-light)); border-radius:20px 20px 0 0; }
    /* Silver badge */
    .badge-card.silver { border-color: rgba(148,163,184,.35); }
    .badge-card.silver::before { content:''; position:absolute; top:0; left:0; right:0; height:4px; background:linear-gradient(90deg,#64748b,var(--silver)); border-radius:20px 20px 0 0; }
    /* Bronze badge */
    .badge-card.bronze { border-color: rgba(205,127,50,.35); }
    .badge-card.bronze::before { content:''; position:absolute; top:0; left:0; right:0; height:4px; background:linear-gradient(90deg,var(--bronze),#e8a25c); border-radius:20px 20px 0 0; }

    /* Badge image with glow */
    .badge-img-wrap {
      position: relative; display: inline-block;
      width: 80px; height: 80px; margin: 0 auto 14px;
    }
    .badge-img-wrap img {
      width: 80px; height: 80px; object-fit: contain;
      position: relative; z-index: 1;
      filter: drop-shadow(0 4px 12px rgba(0,0,0,.15));
      transition: transform .3s;
    }
    .badge-card:hover .badge-img-wrap img { transform: rotate(-5deg) scale(1.1); }
    .badge-glow {
      position: absolute; inset: -10px;
      border-radius: 50%;
      animation: glowPulse 2.5s ease-in-out infinite;
    }
    .gold   .badge-glow { background: radial-gradient(circle, rgba(251,191,36,.30) 0%, transparent 65%); }
    .silver .badge-glow { background: radial-gradient(circle, rgba(148,163,184,.25) 0%, transparent 65%); }
    .bronze .badge-glow { background: radial-gradient(circle, rgba(205,127,50,.25) 0%, transparent 65%); }
    @keyframes glowPulse { 0%,100%{opacity:.6} 50%{opacity:1} }

    .badge-course-name {
      font-family: var(--font-display);
      font-size: 1rem; font-weight: 600;
      color: var(--charcoal); margin-bottom: 10px; line-height: 1.3;
    }

    /* Stars */
    .star-row { display: flex; justify-content: center; gap: 4px; }
    .star-row .fa-star { font-size: .9rem; transition: transform .2s; }
    .badge-card.gold   .star-row .fa-star { color: var(--gold-light); }
    .badge-card.silver .star-row .fa-star { color: var(--silver); }
    .badge-card.bronze .star-row .fa-star { color: var(--bronze); }
    .badge-card:hover .star-row .fa-star { animation: starPop .3s ease both; }
    @keyframes starPop { 0%{transform:scale(1)} 50%{transform:scale(1.3)} 100%{transform:scale(1)} }

    /* Badge type label */
    .badge-type-label {
      display: inline-block;
      font-size: .68rem; font-weight: 800;
      text-transform: uppercase; letter-spacing: .07em;
      padding: 3px 10px; border-radius: 100px; margin-top: 10px;
    }
    .gold   .badge-type-label { background: var(--gold-pale);   color: var(--gold); }
    .silver .badge-type-label { background: var(--silver-pale); color: #64748b; }
    .bronze .badge-type-label { background: var(--bronze-pale); color: var(--bronze); }

    /* Empty badges state */
    .empty-badges {
      text-align: center; padding: 64px 24px;
      animation: panelIn .4s ease both;
    }
    .empty-icon { font-size: 3rem; margin-bottom: 14px; }
    .empty-badges h4 { font-family: var(--font-display); font-size: 1.4rem; font-weight: 600; margin-bottom: 8px; }
    .empty-badges p  { font-size: .9rem; color: var(--stone); }

    /* ══════════════════════════════════════
       LEADERBOARD
    ══════════════════════════════════════ */
    .leaderboard-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 20px; overflow: hidden;
      box-shadow: var(--shadow-md);
    }
    .lb-header {
      background: linear-gradient(135deg, var(--teal), var(--teal-dark));
      padding: 22px 28px;
      display: flex; align-items: center; gap: 14px;
    }
    .lb-header-icon {
      width: 44px; height: 44px; border-radius: 12px;
      background: rgba(255,255,255,.18);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.3rem;
    }
    .lb-header h3 { font-family: var(--font-display); font-size: 1.3rem; font-weight: 600; color: #fff; margin-bottom: 2px; }
    .lb-header p  { font-size: .8rem; color: rgba(255,255,255,.72); }

    .lb-table-wrap { padding: 8px 0; }
    .lb-table {
      width: 100%; border-collapse: collapse;
    }
    .lb-table thead th {
      padding: 12px 20px;
      font-size: .72rem; font-weight: 800;
      text-transform: uppercase; letter-spacing: .09em;
      color: var(--stone); text-align: left;
      border-bottom: 1px solid var(--border);
    }
    .lb-table tbody tr {
      transition: background .18s;
      opacity: 0; transform: translateX(-12px);
    }
    .lb-table tbody tr.row-in {
      animation: rowSlide .4s ease forwards;
    }
    @keyframes rowSlide { from{opacity:0;transform:translateX(-12px)} to{opacity:1;transform:translateX(0)} }
    .lb-table tbody tr:hover { background: var(--cream2); }
    .lb-table tbody td {
      padding: 14px 20px;
      border-bottom: 1px solid var(--border);
      font-size: .9rem; font-weight: 600; color: var(--charcoal);
    }
    .lb-table tbody tr:last-child td { border-bottom: none; }

    /* Rank cell */
    .rank-cell { display: flex; align-items: center; gap: 8px; font-size: 1rem; }
    .rank-num  { font-family: var(--font-display); font-size: 1rem; font-weight: 700; color: var(--stone); }

    /* Top 3 row highlights */
    .lb-table tbody tr.rank-1 { background: rgba(251,191,36,.06); }
    .lb-table tbody tr.rank-2 { background: rgba(148,163,184,.06); }
    .lb-table tbody tr.rank-3 { background: rgba(205,127,50,.06); }
    .lb-table tbody tr.rank-1 td { border-bottom-color: rgba(251,191,36,.15); }

    /* Points badge */
    .pts-badge {
      display: inline-flex; align-items: center; gap: 5px;
      background: var(--teal-pale); color: var(--teal-dark);
      border: 1px solid rgba(13,148,136,.18);
      padding: 4px 12px; border-radius: 100px;
      font-size: .82rem; font-weight: 800;
    }

    /* Current student row highlight */
    .lb-table tbody tr.is-me td { color: var(--teal); }
    .lb-table tbody tr.is-me { background: var(--teal-pale) !important; }

    /* ══════════════════════════════════════
       PROGRESS MINI CARDS (top of badges)
    ══════════════════════════════════════ */
    .mini-stats-row {
      display: grid; grid-template-columns: repeat(3,1fr); gap: 14px;
      margin-bottom: 24px;
    }
    .mini-stat {
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: var(--r); padding: 18px 16px; text-align: center;
      box-shadow: var(--shadow-sm);
      transition: box-shadow .2s, transform .2s;
    }
    .mini-stat:hover { box-shadow: var(--shadow-md); transform: translateY(-2px); }
    .ms-icon { font-size: 1.5rem; margin-bottom: 6px; }
    .ms-num  { font-family: var(--font-display); font-size: 1.5rem; font-weight: 700; color: var(--teal); line-height: 1; }
    .ms-label{ font-size: .72rem; font-weight: 700; color: var(--stone); text-transform: uppercase; letter-spacing: .06em; margin-top: 4px; }

    /* ══════════════════════════════════════
       RESPONSIVE
    ══════════════════════════════════════ */
    @media (max-width: 768px) {
      .nav-tabs-row { display: none; }
      .badges-grid { grid-template-columns: repeat(2,1fr); }
      .mini-stats-row { grid-template-columns: repeat(3,1fr); }
      .hero-inner { gap: 20px; }
    }
    @media (max-width: 480px) {
      .badges-grid { grid-template-columns: 1fr; }
      .mini-stats-row { grid-template-columns: 1fr 1fr; }
      .tab-btn span { display: none; }
    }
  </style>
</head>
<body>

<%
  if (id == null || mail == null) {
%>
<!-- Not logged in -->
<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:40px;">
  <div style="background:#fff;border:1px solid var(--border);border-radius:24px;box-shadow:var(--shadow-lg);padding:48px 40px;text-align:center;max-width:440px;">
    <div style="font-size:3rem;margin-bottom:16px;">🔒</div>
    <h3 style="font-family:var(--font-display);font-size:1.7rem;font-weight:600;margin-bottom:10px;">Please Sign In</h3>
    <p style="font-size:.9rem;color:var(--stone);margin-bottom:24px;">You need to log in to view your profile.</p>
    <a href="index.jsp" style="background:var(--teal);color:#fff;padding:12px 28px;border-radius:100px;font-weight:700;font-size:.93rem;display:inline-flex;align-items:center;gap:8px;box-shadow:0 4px 16px rgba(13,148,136,.38);">
      <i class="bi bi-box-arrow-in-right"></i> Go to Login
    </a>
  </div>
</div>
<%
} else {
  // ── DB queries ──────────────────────────────────────────────────────────
  DbConnection db = new DbConnection();
  ResultSet rs1 = db.Select("SELECT * FROM student_register WHERE student_id='" + id + "' AND student_mail='" + mail + "'");

  String studentName = "", studentMail = "", collegeName = "", department = "", degree = "", address = "", gender = "", age = "", registerId = "";
  int studentIdInt = 0;
  if (rs1.next()) {
    studentIdInt = rs1.getInt("student_id");
    studentName  = rs1.getString("student_name");
    studentMail  = rs1.getString("student_mail");
    collegeName  = rs1.getString("college_name");
    department   = rs1.getString("department");
    degree       = rs1.getString("degree");
    address      = rs1.getString("address");
    try { gender      = rs1.getString("gender");     } catch(Exception e){}
    try { age         = rs1.getString("age");         } catch(Exception e){}
    try { registerId  = rs1.getString("register_id"); } catch(Exception e){}
  }

  // Badge query
  ResultSet rsBadge = db.Select(
    "SELECT c.course_name, sqa.quiz_level, sqa.status, sqa.score " +
    "FROM courses c " +
    "JOIN student_courses sc ON c.course_id = sc.course_id " +
    "JOIN student_quiz_attempts sqa ON sc.course_id = sqa.course_id " +
    "WHERE sc.student_id='" + id + "' " +
    "AND sc.course_status='completed' " +
    "AND sqa.student_id='" + id + "'"
  );

  Map<String,String>  normalStatus = new LinkedHashMap<>();
  Map<String,String>  hardStatus   = new LinkedHashMap<>();
  Map<String,String>  easyStatus   = new LinkedHashMap<>();
  Map<String,Integer> scoreMap     = new LinkedHashMap<>();

  while (rsBadge.next()) {
    String course = rsBadge.getString("course_name");
    String level  = rsBadge.getString("quiz_level");
    String status = rsBadge.getString("status");
    int    score  = rsBadge.getInt("score");
    if      ("NORMAL".equalsIgnoreCase(level)) normalStatus.put(course, status);
    else if ("HARD".equalsIgnoreCase(level))   { hardStatus.put(course, status); scoreMap.put(course, score); }
    else if ("EASY".equalsIgnoreCase(level))   { easyStatus.put(course, status); scoreMap.put(course, score - 1); }
  }
  rsBadge.close();

  // Leaderboard query
  ResultSet rsLB = db.Select(
"SELECT c.student_id, sc.student_name, SUM(c.points) AS total_points " +
"FROM student_courses c " +
"JOIN student_register sc ON c.student_id = sc.student_id " +
"WHERE c.course_status='completed' " +
"GROUP BY c.student_id " +
"ORDER BY total_points DESC, c.student_id ASC"
);

  // Gather leaderboard into list for rendering
  List<Integer> lbIds   = new ArrayList<>();
  List<String>  lbNames = new ArrayList<>();
  List<Integer> lbPts   = new ArrayList<>();
  while (rsLB.next()) {
    lbIds.add(rsLB.getInt("student_id"));
    lbNames.add(rsLB.getString("student_name"));
    lbPts.add(rsLB.getInt("total_points"));
  }
  rsLB.close();

  // Count badges
  int badgeCount = 0;
  for (String course : normalStatus.keySet()) {
    String nS = normalStatus.get(course);
    String hS = hardStatus.get(course);
    String eS = easyStatus.get(course);
    boolean completed = ("pass".equalsIgnoreCase(nS) && "pass".equalsIgnoreCase(hS))
                     || ("fail".equalsIgnoreCase(nS) && "pass".equalsIgnoreCase(eS));
    if (completed) badgeCount++;
  }

  // My rank
  int myRank = 0;
  for (int r = 0; r < lbIds.size(); r++) {
    if (lbIds.get(r) == id) { myRank = r + 1; break; }
  }

  String firstLetter = (studentName != null && !studentName.isEmpty()) ? String.valueOf(studentName.charAt(0)).toUpperCase() : "S";
  String firstName   = (studentName != null && studentName.contains(" ")) ? studentName.split(" ")[0] : studentName;
%>

<!-- NAVBAR -->
<nav class="sk-nav" id="skNav">
  <div class="nav-inner">
<!--    <a class="sk-brand" href="Student_View_Course.jsp">Skill<span>Sync</span></a>-->
<a class="sk-brand" href="index.jsp" style="display:flex; align-items:center; gap:8px;">
  <img src="assets/images/logo.png" style="width:25px; height:100%;">
  REC
</a>
    <div class="nav-tabs-row">
      <a href="Student_View_Course.jsp" class="nav-tab"><i class="bi bi-grid"></i> Courses</a>
      <a href="Student_Profile.jsp" class="nav-tab active"><i class="bi bi-person-circle"></i> Profile</a>
    </div>
    <a href="index.jsp" class="btn-back">
      <i class="bi bi-box-arrow-right"></i> Logout
    </a>
  </div>
</nav>

<!-- PROFILE HERO BANNER -->
<div class="profile-hero">
  <div class="hero-inner">
    <div class="avatar-ring">
      <img src="student_img.jsp?name=<%= studentIdInt %>" alt="<%= studentName %>">
      <div class="avatar-online"></div>
    </div>
    <div>
      <div class="hero-name"><%= studentName %></div>
      <div class="hero-email"><%= studentMail %></div>
      <div class="hero-pills">
        <span class="hero-pill"><i class="bi bi-building"></i> <%= collegeName %></span>
        <span class="hero-pill"><i class="bi bi-diagram-3"></i> <%= department %></span>
        <% if (!degree.isEmpty()) { %><span class="hero-pill"><i class="bi bi-mortarboard"></i> <%= degree %></span><% } %>
        <% if (myRank > 0) { %><span class="hero-pill"><i class="bi bi-trophy"></i> Rank #<%= myRank %></span><% } %>
      </div>
    </div>
    <div class="ms-auto d-none d-md-flex" style="gap:14px;align-items:center;">
      <!-- hero stat pills -->
      <div style="background:rgba(255,255,255,.14);border:1px solid rgba(255,255,255,.22);border-radius:14px;padding:12px 20px;text-align:center;">
        <div style="font-family:var(--font-display);font-size:1.6rem;font-weight:700;color:#fff;line-height:1;"><%= badgeCount %></div>
        <div style="font-size:.7rem;font-weight:700;color:rgba(255,255,255,.65);text-transform:uppercase;letter-spacing:.06em;margin-top:3px;">Badges</div>
      </div>
      <div style="background:rgba(255,255,255,.14);border:1px solid rgba(255,255,255,.22);border-radius:14px;padding:12px 20px;text-align:center;">
        <div style="font-family:var(--font-display);font-size:1.6rem;font-weight:700;color:#fff;line-height:1;"><%= myRank > 0 ? "#" + myRank : "—" %></div>
        <div style="font-size:.7rem;font-weight:700;color:rgba(255,255,255,.65);text-transform:uppercase;letter-spacing:.06em;margin-top:3px;">Rank</div>
      </div>
    </div>
  </div>
</div>

<!-- PAGE CONTENT -->
<div class="page-content">

  <!-- Tab navigation -->
  <div class="tab-nav-card">
    <button class="tab-btn active" onclick="switchTab('profile', this)">
      <i class="bi bi-person-circle"></i> <span>Profile</span>
    </button>
    <button class="tab-btn" onclick="switchTab('badges', this)">
      <i class="bi bi-award"></i> <span>Badges (<%= badgeCount %>)</span>
    </button>
    <button class="tab-btn" onclick="switchTab('leaderboard', this)">
      <i class="bi bi-trophy"></i> <span>Leaderboard</span>
    </button>
  </div>

  <!-- ═══════ TAB: PROFILE ═══════ -->
  <div class="tab-panel active" id="tab-profile">
    <div class="row g-4">

      <!-- Profile view card -->
      <div class="col-lg-7">
        <div class="profile-card">
          <div class="pc-header">
            <div>
              <h3>Personal Information</h3>
              <p>Your account details registered with SkillSync</p>
            </div>
            <button class="btn-edit" onclick="showEdit()">
              <i class="bi bi-pencil-square"></i> Edit
            </button>
          </div>

          <!-- View mode -->
          <div class="pc-body" id="viewProfile">
            <div class="profile-row">
              <div class="pr-icon"><i class="bi bi-person"></i></div>
              <div><div class="pr-label">Full Name</div><div class="pr-value"><%= studentName %></div></div>
            </div>
            <div class="profile-row">
              <div class="pr-icon"><i class="bi bi-envelope"></i></div>
              <div><div class="pr-label">Email Address</div><div class="pr-value"><%= studentMail %></div></div>
            </div>
            <div class="profile-row">
              <div class="pr-icon"><i class="bi bi-building"></i></div>
              <div><div class="pr-label">College Name</div><div class="pr-value"><%= collegeName %></div></div>
            </div>
            <div class="profile-row">
              <div class="pr-icon"><i class="bi bi-diagram-3"></i></div>
              <div><div class="pr-label">Department</div><div class="pr-value"><%= department %></div></div>
            </div>
            <div class="profile-row">
              <div class="pr-icon"><i class="bi bi-mortarboard"></i></div>
              <div><div class="pr-label">Degree</div><div class="pr-value"><%= degree.isEmpty() ? "—" : degree %></div></div>
            </div>
            <% if (!registerId.isEmpty()) { %>
            <div class="profile-row">
              <div class="pr-icon"><i class="bi bi-card-text"></i></div>
              <div><div class="pr-label">Register ID</div><div class="pr-value"><%= registerId %></div></div>
            </div>
            <% } %>
            <div class="profile-row">
              <div class="pr-icon"><i class="bi bi-geo-alt"></i></div>
              <div><div class="pr-label">Address</div><div class="pr-value"><%= address.isEmpty() ? "—" : address %></div></div>
            </div>
            <% if (!gender.isEmpty()) { %>
            <div class="profile-row">
              <div class="pr-icon"><i class="bi bi-gender-ambiguous"></i></div>
              <div><div class="pr-label">Gender</div><div class="pr-value"><%= gender %></div></div>
            </div>
            <% } %>
            <% if (!age.isEmpty()) { %>
            <div class="profile-row">
              <div class="pr-icon"><i class="bi bi-calendar2"></i></div>
              <div><div class="pr-label">Age</div><div class="pr-value"><%= age %></div></div>
            </div>
            <% } %>
          </div>

          <!-- Edit mode -->
          <div class="edit-panel" id="editProfile">
            <form action="UpdateStudentProfile" method="post">
              <input type="hidden" name="student_id" value="<%= studentIdInt %>">
              <div class="row g-3">
                <div class="col-md-6">
                  <div class="ef-group">
                    <label class="ef-label">Full Name</label>
                    <input type="text" name="student_name" class="ef-input" value="<%= studentName %>" required>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="ef-group">
                    <label class="ef-label">Email Address</label>
                    <input type="email" name="student_mail" class="ef-input" value="<%= studentMail %>" required>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="ef-group">
                    <label class="ef-label">College Name</label>
                    <input type="text" name="college_name" class="ef-input" value="<%= collegeName %>" required>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="ef-group">
                    <label class="ef-label">Department</label>
                    <input type="text" name="department" class="ef-input" value="<%= department %>" required>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="ef-group">
                    <label class="ef-label">Degree</label>
                    <input type="text" name="degree" class="ef-input" value="<%= degree %>">
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="ef-group">
                    <label class="ef-label">Register ID</label>
                    <input type="text" name="register_id" class="ef-input" value="<%= registerId %>">
                  </div>
                </div>
                <div class="col-12">
                  <div class="ef-group">
                    <label class="ef-label">Address</label>
                    <textarea name="address" class="ef-textarea" required><%= address %></textarea>
                  </div>
                </div>
              </div>
              <div class="ef-actions">
                <button type="submit" class="btn-save"><i class="bi bi-check-circle"></i> Save Changes</button>
                <button type="button" class="btn-cancel" onclick="cancelEdit()"><i class="bi bi-x-circle"></i> Cancel</button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- Quick info sidebar -->
      <div class="col-lg-5">
        <div class="profile-card" style="margin-bottom:16px;">
          <div class="pc-header">
            <div><h3>Account Summary</h3><p>Your platform overview</p></div>
          </div>
          <div class="pc-body">
            <div class="profile-row">
              <div class="pr-icon" style="background:var(--gold-pale);border-color:rgba(217,119,6,.18);color:var(--gold);"><i class="bi bi-award"></i></div>
              <div><div class="pr-label">Badges Earned</div><div class="pr-value"><%= badgeCount %> badge<%= badgeCount != 1 ? "s" : "" %></div></div>
            </div>
            <div class="profile-row">
              <div class="pr-icon" style="background:rgba(59,130,246,.10);border-color:rgba(59,130,246,.18);color:#3b82f6;"><i class="bi bi-trophy"></i></div>
              <div><div class="pr-label">Leaderboard Rank</div><div class="pr-value"><%= myRank > 0 ? "#" + myRank + " of " + lbIds.size() : "Not yet ranked" %></div></div>
            </div>
            <div class="profile-row">
              <div class="pr-icon" style="background:rgba(34,197,94,.10);border-color:rgba(34,197,94,.18);color:#22c55e;"><i class="bi bi-shield-check"></i></div>
              <div><div class="pr-label">Account Status</div><div class="pr-value" style="color:var(--green);">✓ Active</div></div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>

  <!-- ═══════ TAB: BADGES ═══════ -->
  <div class="tab-panel" id="tab-badges">

    <!-- Mini stats -->
    <div class="mini-stats-row">
      <div class="mini-stat">
        <div class="ms-icon">🏅</div>
        <div class="ms-num"><%= badgeCount %></div>
        <div class="ms-label">Badges Earned</div>
      </div>
      <div class="mini-stat">
        <div class="ms-icon">⭐</div>
        <div class="ms-num" id="goldCount">0</div>
        <div class="ms-label">Gold Badges</div>
      </div>
      <div class="mini-stat">
        <div class="ms-icon">🥈</div>
        <div class="ms-num" id="silverCount">0</div>
        <div class="ms-label">Silver Badges</div>
      </div>
    </div>

    <% boolean anyBadge = false; %>
    <div class="badges-grid" id="badgesGrid">
<%
  int goldCnt = 0, silverCnt = 0, bronzeCnt = 0;
  for (String course : normalStatus.keySet()) {
    String nS = normalStatus.get(course);
    String hS = hardStatus.get(course);
    String eS = easyStatus.get(course);
    boolean completed = ("pass".equalsIgnoreCase(nS) && "pass".equalsIgnoreCase(hS))
                     || ("fail".equalsIgnoreCase(nS) && "pass".equalsIgnoreCase(eS));
    if (!completed) continue;
    anyBadge = true;

    int finalStars = scoreMap.containsKey(course) ? scoreMap.get(course) : 0;
    String badgeClass, badgeImage, badgeLabel;
    if (finalStars == 5) {
      badgeClass = "gold"; badgeImage = "assets/images/badge.png"; badgeLabel = "Gold"; goldCnt++;
    } else if (finalStars == 4) {
      badgeClass = "silver"; badgeImage = "assets/images/sliver.png"; badgeLabel = "Silver"; silverCnt++;
    } else {
      badgeClass = "bronze"; badgeImage = "assets/images/bronze.png"; badgeLabel = "Bronze"; bronzeCnt++;
    }
%>
      <div class="badge-card <%= badgeClass %>">
        <div class="badge-img-wrap">
          <div class="badge-glow"></div>
          <img src="<%= badgeImage %>" alt="<%= badgeLabel %> Badge">
        </div>
        <div class="badge-course-name"><%= course %></div>
        <div class="star-row">
          <% for (int s = 1; s <= 5; s++) { %>
            <% if (s <= finalStars) { %><i class="fa-solid fa-star"></i><% } else { %><i class="fa-regular fa-star" style="opacity:.25;"></i><% } %>
          <% } %>
        </div>
        <span class="badge-type-label"><%= badgeLabel %></span>
      </div>
<% } %>
    </div>

    <% if (!anyBadge) { %>
    <div class="empty-badges">
      <div class="empty-icon">🎯</div>
      <h4>No Badges Yet</h4>
      <p>Complete courses and pass quizzes to earn gold, silver, and bronze badges!</p>
    </div>
    <% } %>

    <!-- inject badge counts for JS -->
    <script>
      document.getElementById('goldCount').textContent   = '<%= goldCnt %>';
      document.getElementById('silverCount').textContent = '<%= silverCnt %>';
    </script>
  </div>

  <!-- ═══════ TAB: LEADERBOARD ═══════ -->
  <div class="tab-panel" id="tab-leaderboard">
    <div class="leaderboard-card">
      <div class="lb-header">
        <div class="lb-header-icon">🏆</div>
        <div>
          <h3>Top Students Leaderboard</h3>
          <p>Ranked by total course completion points</p>
        </div>
      </div>
      <div class="lb-table-wrap">
        <table class="lb-table">
          <thead>
            <tr>
              <th style="width:80px;">Rank</th>
              <th>Student Name</th>
              <th style="text-align:right;">Points</th>
            </tr>
          </thead>
          <tbody id="lbBody">
<%
  for (int r = 0; r < lbIds.size(); r++) {
    int    rId   = lbIds.get(r);
    String rName = lbNames.get(r);
    int    rPts  = lbPts.get(r);
    int    rRank = r + 1;
    boolean isMe = (rId == id);
    String rowClass = isMe ? "is-me" : "";
    if (rRank == 1) rowClass += " rank-1";
    else if (rRank == 2) rowClass += " rank-2";
    else if (rRank == 3) rowClass += " rank-3";
    String medal = rRank == 1 ? "🥇" : rRank == 2 ? "🥈" : rRank == 3 ? "🥉" : String.valueOf(rRank);
%>
            <tr class="<%= rowClass.trim() %>">
              <td><div class="rank-cell"><span><%= medal %></span><% if (rRank > 3) { %><span class="rank-num"></span><% } %></div></td>
              <td>
                <%= rName %>
                <% if (isMe) { %><span style="margin-left:8px;font-size:.72rem;font-weight:800;background:var(--teal-pale);color:var(--teal);padding:2px 8px;border-radius:100px;">You</span><% } %>
              </td>
              <td style="text-align:right;"><span class="pts-badge"><i class="bi bi-star-fill" style="font-size:.7rem;"></i> <%= rPts %> pts</span></td>
            </tr>
<% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div><!-- /tab-leaderboard -->

</div><!-- /page-content -->

<%
  db.close();
} // end logged-in block
%>

<% String msg = (String) session.getAttribute("msg");
            if (msg != null) {
        %>
        <script> alert("<%=msg%>");</script>
        <% }
        session.removeAttribute("msg");%> 
<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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
<script>
  /* ── Navbar scroll ── */
  var nav = document.getElementById('skNav');
  if (nav) window.addEventListener('scroll', function() {
    nav.classList.toggle('scrolled', window.scrollY > 20);
  }, { passive: true });

  /* ── Tab switcher ── */
  function switchTab(name, btn) {
    document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
    document.querySelectorAll('.tab-btn').forEach(function(b)   { b.classList.remove('active'); });
    document.getElementById('tab-' + name).classList.add('active');
    btn.classList.add('active');

    if (name === 'badges')       animateBadges();
    if (name === 'leaderboard')  animateLeaderboard();
  }

  /* ── Profile edit toggle ── */
  function showEdit() {
    document.getElementById('viewProfile').style.display = 'none';
    var ep = document.getElementById('editProfile');
    ep.classList.add('show');
    ep.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
  function cancelEdit() {
    document.getElementById('editProfile').classList.remove('show');
    document.getElementById('viewProfile').style.display = 'block';
  }

  /* ── Badge scroll reveal ── */
  function animateBadges() {
    var cards = document.querySelectorAll('.badge-card');
    cards.forEach(function(card, i) {
      card.classList.remove('visible');
      card.style.animationDelay = (i * 0.10) + 's';
      setTimeout(function() { card.classList.add('visible'); }, i * 80);
    });
  }

  /* ── Leaderboard row animation ── */
  function animateLeaderboard() {
    var rows = document.querySelectorAll('#lbBody tr');
    rows.forEach(function(row, i) {
      row.classList.remove('row-in');
      row.style.animationDelay = (i * 0.06) + 's';
      setTimeout(function() { row.classList.add('row-in'); }, i * 55);
    });
  }

  /* ── Initial load animations ── */
  window.addEventListener('DOMContentLoaded', function() {
    // Always animate leaderboard & badges on first load
    animateBadges();
    animateLeaderboard();

    // Scroll to section if hash present
    var hash = window.location.hash;
    if (hash === '#badges') {
      var b = document.querySelector('[onclick="switchTab(\'badges\', this)"]');
      if (b) b.click();
    } else if (hash === '#leaderboard') {
      var l = document.querySelector('[onclick="switchTab(\'leaderboard\', this)"]');
      if (l) l.click();
    }
  });
</script>
</body>
</html>
