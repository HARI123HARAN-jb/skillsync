<%@page import="java.sql.*"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SkillSync – My Courses</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <!-- Font Awesome (for chatbot send icon) -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <link rel="stylesheet" href="assets/css/newstyle.css"/>
  <style>
    /* ══════════════════════════════════════
       DESIGN TOKENS
    ══════════════════════════════════════ */
    :root {
      --teal:         orange;
      --teal-light:   #f6da99;
      --teal-dark:    orange;
      --teal-pale:    #f0fdfb;
      --teal-ring:    rgba(13,148,136,.18);
      --amber:        #d97706;
      --amber-pale:   #fef3c7;
      --green:        #22c55e;
      --green-pale:   #f0fdf4;
      --blue:         #3b82f6;
      --blue-pale:    #eff6ff;
      --orange:       #f97316;
      --orange-pale:  #fff7ed;
      --red:          #ef4444;
      --cream:        #fafaf7;
      --cream2:       #f4f4ef;
      --ivory:        #fffffe;
      --charcoal:     #1a1a1a;
      --slate:        #44403c;
      --stone:        #78716c;
      --border:       #e2e8e4;
      --shadow-sm:    0 2px 10px rgba(0,0,0,.06);
      --shadow-md:    0 6px 28px rgba(0,0,0,.09);
      --shadow-lg:    0 18px 56px rgba(0,0,0,.12);
      --r:            16px;
      --r-sm:         10px;
      --font-display: 'Cormorant Garamond', Georgia, serif;
      --font-body:    'Plus Jakarta Sans', sans-serif;
      --nav-h:        68px;
    }

    /* ══════════════════════════════════════
       BASE
    ══════════════════════════════════════ */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body {
      font-family: var(--font-body);
      background: var(--cream);
      color: var(--charcoal);
      overflow-x: hidden;
      min-height: 100vh;
    }
    a { text-decoration: none; color: inherit; }
    img { display: block; max-width: 100%; }

    /* ══════════════════════════════════════
       NAVBAR
    ══════════════════════════════════════ */
    .sk-nav1 {
      position: fixed; top: 0; left: 0; right: 0; z-index: 400;
      background: rgba(250,250,247,.95);
      backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px);
      border-bottom: 1px solid var(--border);
      height: var(--nav-h);
      display: flex; align-items: center;
      box-shadow: var(--shadow-sm);
      transition: box-shadow .3s;
    }
    .sk-nav1.scrolled { box-shadow: var(--shadow-md); }
    .sk-nav1 .inner {
      width: 100%; max-width: 1280px; margin: 0 auto;
      padding: 0 28px;
      display: flex; align-items: center; justify-content: space-between;
      gap: 16px;
    }
    .sk-brand1 {
      font-family: var(--font-display);
      font-size: 1.6rem; font-weight: 600;
      color: var(--teal); letter-spacing: -.3px; white-space: nowrap;
    }
    .sk-brand1 span { color: var(--charcoal); }

    /* search bar in nav */
    .nav-search {
      flex: 1; max-width: 380px;
      position: relative;
    }
    .nav-search input {
      width: 100%; padding: 9px 16px 9px 40px;
      border: 1.5px solid var(--border); border-radius: 100px;
      font-family: var(--font-body); font-size: .86rem; font-weight: 500;
      background: var(--cream2); color: var(--charcoal);
      outline: none;
      transition: border-color .2s, box-shadow .2s, background .2s;
    }
    .nav-search input:focus {
      border-color: var(--teal); background: #fff;
      box-shadow: 0 0 0 3px var(--teal-ring);
    }
    .nav-search i {
      position: absolute; left: 14px; top: 50%;
      transform: translateY(-50%);
      color: var(--stone); font-size: .85rem; pointer-events: none;
    }

    /* greeting chip */
    .nav-greeting1 {
      display: flex; align-items: center; gap: 10px;
      background: #fff8ed;
      border: 1px solid rgba(13,148,136,.22);
      border-radius: 100px; padding: 6px 16px 6px 8px;
      white-space: nowrap;
    }
    .nav-avatar {
      width: 32px; height: 32px; border-radius: 50%;
      background: linear-gradient(135deg, #f6d699, var(--teal));
      display: flex; align-items: center; justify-content: center;
      font-size: .78rem; font-weight: 800; color: #fff;
      flex-shrink: 0;
    }
    .nav-greeting-text1 { font-size: .82rem; font-weight: 600; color: var(--teal-dark); }

    .btn-logout1 {
      background: none; border: 1.5px solid var(--border);
      border-radius: 100px; padding: 7px 16px;
      font-family: var(--font-body); font-size: .82rem; font-weight: 600;
      color: var(--stone); cursor: pointer;
      display: inline-flex; align-items: center; gap: 6px;
      transition: border-color .2s, color .2s;
      white-space: nowrap;
    }
    .btn-logout1:hover { border-color: var(--red); color: var(--red); }
.btn-logout2 {
      background: none; border: 1.5px solid var(--border);
      border-radius: 100px; padding: 7px 16px;
      font-family: var(--font-body); font-size: .82rem; font-weight: 600;
      color: var(--stone); cursor: pointer;
      display: inline-flex; align-items: center; gap: 6px;
      transition: border-color .2s, color .2s;
      white-space: nowrap;
    }
    .btn-logout2:hover { border-color: orange; color: orange; }
    /* mobile ham */
    .sk-ham1 { display: none; flex-direction: column; gap: 5px; background: none; border: none; cursor: pointer; padding: 4px; }
    .sk-ham1 span { display: block; width: 22px; height: 2px; background: var(--charcoal); border-radius: 2px; transition: .3s; }

    /* ══════════════════════════════════════
       HERO BANNER
    ══════════════════════════════════════ */
    .hero-banner {
      margin-top: var(--nav-h);
      background: linear-gradient(135deg, var(--teal), var(--teal-dark));
      padding: 52px 28px 48px;
      position: relative; overflow: hidden;
    }
    .hero-banner::before {
      content: '';
      position: absolute; top: -60px; right: -60px;
      width: 260px; height: 260px; border-radius: 50%;
      background: rgba(255,255,255,.07);
    }
    .hero-banner::after {
      content: '';
      position: absolute; bottom: -40px; left: 20%;
      width: 160px; height: 160px; border-radius: 50%;
      background: rgba(255,255,255,.05);
    }
    .hero-inner {
      max-width: 1280px; margin: 0 auto;
      display: flex; align-items: center; justify-content: space-between;
      flex-wrap: wrap; gap: 24px; position: relative; z-index: 1;
    }
    .hero-text h1 {
      font-family: var(--font-display);
      font-size: clamp(1.8rem, 3.5vw, 2.6rem);
      font-weight: 600; color: #fff; line-height: 1.15;
      margin-bottom: 8px;
      animation: fadeUp .6s ease both;
    }
    .hero-text h1 em { font-style: italic; color: #99f6e5; }
    .hero-text p {
      font-size: .95rem; color: rgba(255,255,255,.80);
      max-width: 520px; font-weight: 400;
      animation: fadeUp .6s .1s ease both;
    }
    .hero-stats {
      display: flex; gap: 28px; flex-wrap: wrap;
      animation: fadeUp .6s .2s ease both;
    }
    .h-stat {
      background: rgba(255,255,255,.14);
      border: 1px solid rgba(255,255,255,.20);
      border-radius: var(--r);
      padding: 14px 22px; text-align: center;
      min-width: 100px;
    }
    .h-stat-num { font-family: var(--font-display); font-size: 1.7rem; font-weight: 700; color: #fff; line-height: 1; }
    .h-stat-label { font-size: .72rem; color: rgba(255,255,255,.75); font-weight: 600; text-transform: uppercase; letter-spacing: .06em; margin-top: 4px; }

    @keyframes fadeUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }

    /* ══════════════════════════════════════
       MAIN CONTENT
    ══════════════════════════════════════ */
    .main-content {
      max-width: 1280px; margin: 0 auto;
      padding: 44px 28px 100px;
    }

    /* Section header */
    .sec-row {
      display: flex; align-items: center; justify-content: space-between;
      flex-wrap: wrap; gap: 14px; margin-bottom: 28px;
    }
    .sec-label {
      font-size: .72rem; font-weight: 700;
      letter-spacing: .12em; text-transform: uppercase;
      color: var(--teal); margin-bottom: 4px;
    }
    .sec-title {
      font-family: var(--font-display);
      font-size: clamp(1.6rem, 3vw, 2.1rem);
      font-weight: 600; color: var(--charcoal); line-height: 1.2;
    }
    .course-count-badge {
      background: #fdf9f0;
      border: 1px solid rgba(148, 108, 13, 0.22);
      color: var(--teal-dark);
      font-size: .78rem; font-weight: 700;
      padding: 5px 14px; border-radius: 100px;
    }

    /* ══════════════════════════════════════
       FILTER TABS
    ══════════════════════════════════════ */
    .filter-tabs {
      display: flex; gap: 8px; flex-wrap: wrap;
      margin-bottom: 32px;
    }
    .filter-tab {
      padding: 7px 18px; border-radius: 100px;
      font-size: .82rem; font-weight: 600;
      border: 1.5px solid var(--border);
      background: var(--ivory); color: var(--stone);
      cursor: pointer;
      transition: background .2s, color .2s, border-color .2s, box-shadow .2s;
    }
    .filter-tab:hover { border-color: var(--teal); color: var(--teal); }
    .filter-tab.active {
      background: var(--teal); color: #fff;
      border-color: var(--teal);
      box-shadow: 0 2px 10px rgba(13,148,136,.30);
    }

    /* ══════════════════════════════════════
       COURSE CARDS
    ══════════════════════════════════════ */
    .courses-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 24px;
    }

    .course-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 20px;
      overflow: hidden;
      transition: box-shadow .3s, transform .3s, border-color .3s;
      opacity: 0; transform: translateY(24px);
      display: flex; flex-direction: column;
    }
    .course-card.visible {
      animation: cardReveal .55s ease forwards;
    }
    @keyframes cardReveal {
      from { opacity:0; transform:translateY(24px) scale(.97); }
      to   { opacity:1; transform:translateY(0) scale(1); }
    }
    .course-card:hover {
      box-shadow: var(--shadow-lg);
      transform: translateY(-6px);
      border-color: rgba(13,148,136,.35);
    }

    /* course thumbnail */
    .course-thumb {
      position: relative; height: 185px; overflow: hidden;
      background: var(--cream2);
    }
    .course-thumb img {
      width: 100%; height: 100%; object-fit: cover;
      transition: transform .5s ease;
    }
    .course-card:hover .course-thumb img { transform: scale(1.07); }

    /* overlay gradient */
    .thumb-overlay {
      position: absolute; inset: 0;
      background: linear-gradient(180deg, transparent 40%, rgba(15,118,110,.65) 100%);
      opacity: 0; transition: opacity .3s;
    }
    .course-card:hover .thumb-overlay { opacity: 1; }

    /* status badge on thumb */
    .c-status-badge {
      position: absolute; top: 12px; left: 12px;
      padding: 4px 12px; border-radius: 100px;
      font-size: .68rem; font-weight: 700;
      text-transform: uppercase; letter-spacing: .05em;
      backdrop-filter: blur(8px);
    }
    .badge-enrolled   { background: rgba(59,130,246,.16); color: #1d4ed8; border: 1px solid rgba(59,130,246,.28); }
    .badge-completed  { background: rgba(34,197,94,.16);  color: #15803d; border: 1px solid rgba(34,197,94,.28); }
    .badge-new        { background: rgba(249,115,22,.16); color: #c2410c; border: 1px solid rgba(249,115,22,.28); }

    /* progress ring on thumb */
    .progress-ring-wrap {
      position: absolute; bottom: 12px; right: 12px;
      width: 44px; height: 44px;
    }
    .progress-ring-wrap svg { transform: rotate(-90deg); }
    .ring-track { fill: none; stroke: rgba(255,255,255,.25); stroke-width: 4; }
    .ring-fill  {
      fill: none; stroke: #fff; stroke-width: 4;
      stroke-linecap: round;
      stroke-dasharray: 113; stroke-dashoffset: 113;
      transition: stroke-dashoffset 1s ease;
    }
    .ring-text {
      position: absolute; inset: 0;
      display: flex; align-items: center; justify-content: center;
      font-size: .62rem; font-weight: 800; color: #fff;
    }

    /* card body */
    .course-body {
      padding: 20px 22px 22px;
      display: flex; flex-direction: column; flex: 1;
    }
    .c-category {
      font-size: .7rem; font-weight: 700;
      color: var(--teal); text-transform: uppercase;
      letter-spacing: .09em; margin-bottom: 6px;
      display: flex; align-items: center; gap: 5px;
    }
    .c-category::before { content:''; width:10px; height:1.5px; background:var(--teal); display:inline-block; }
    .course-title {
      font-family: var(--font-display);
      font-size: 1.1rem; font-weight: 600;
      color: var(--charcoal); margin-bottom: 8px; line-height: 1.3;
    }
    .course-desc {
      font-size: .85rem; color: var(--stone); line-height: 1.65;
      margin-bottom: 16px; flex: 1;
      display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
    }

    /* linear progress bar */
    .prog-label {
      display: flex; justify-content: space-between;
      font-size: .72rem; font-weight: 700; color: var(--stone); margin-bottom: 5px;
    }
    .prog-track {
      height: 6px; background: var(--cream2);
      border-radius: 99px; overflow: hidden; margin-bottom: 16px;
    }
    .prog-fill {
      height: 100%; border-radius: 99px; width: 0;
      transition: width 1.2s ease;
    }
    .prog-yellow { background: linear-gradient(90deg, #fbbf24, #fde68a); }
    .prog-blue   { background: linear-gradient(90deg, #3b82f6, #93c5fd); }
    .prog-orange { background: linear-gradient(90deg, #f97316, #fdba74); }
    .prog-green  { background: linear-gradient(90deg, #22c55e, #86efac); }

    /* card actions */
    .card-actions { display: flex; gap: 10px; flex-wrap: wrap; }
    .btn-enroll {
      flex: 1; background: var(--teal); color: #fff;
      border: none; border-radius: 100px;
      font-family: var(--font-body); font-size: .82rem; font-weight: 700;
      padding: 9px 18px; cursor: pointer;
      box-shadow: 0 3px 12px rgba(13,148,136,.32);
      transition: background .2s, transform .15s, box-shadow .2s;
      display: flex; align-items: center; justify-content: center; gap: 6px;
    }
    .btn-enroll:hover { background: var(--teal-dark); transform: translateY(-1px); box-shadow: 0 5px 18px rgba(13,148,136,.42); }
    .btn-cert {
      background: linear-gradient(135deg, #ff8900, #f59e0b);
      color: #fff; border: none; border-radius: 100px;
      font-family: var(--font-body); font-size: .82rem; font-weight: 700;
      padding: 9px 18px; cursor: pointer;
      box-shadow: 0 3px 12px rgba(217,119,6,.32);
      transition: transform .15s, box-shadow .2s;
      display: flex; align-items: center; gap: 6px;
      text-decoration: none;
    }
    .btn-cert:hover { transform: translateY(-1px); box-shadow: 0 5px 18px rgba(217,119,6,.42); color: #fff; }

    /* empty state */
    .empty-state {
      text-align: center; padding: 80px 24px;
      display: none;
    }
    .empty-state.show { display: block; animation: fadeUp .4s ease both; }
    .empty-icon { font-size: 3.5rem; margin-bottom: 16px; }
    .empty-state h4 { font-family: var(--font-display); font-size: 1.4rem; font-weight: 600; margin-bottom: 8px; }
    .empty-state p  { font-size: .9rem; color: var(--stone); }

    /* ══════════════════════════════════════
       CHATBOT
    ══════════════════════════════════════ */
    /* Floating toggle button */
    #chatToggleBtn {
      position: fixed; bottom: 28px; right: 28px; z-index: 600;
      width: 58px; height: 58px; border-radius: 50%;
      background: linear-gradient(135deg, var(--teal), var(--teal-dark));
      color: #fff; border: none; cursor: pointer;
      font-size: 1.4rem;
      box-shadow: 0 6px 24px rgba(13,148,136,.50);
      transition: transform .2s, box-shadow .2s;
      display: flex; align-items: center; justify-content: center;
      animation: chatBtnPulse 3s ease-in-out infinite;
    }
    @keyframes chatBtnPulse {
      0%,100% { box-shadow: 0 6px 24px rgba(13,148,136,.50); }
      50%      { box-shadow: 0 6px 36px rgba(13,148,136,.70); }
    }
    #chatToggleBtn:hover { transform: scale(1.08) translateY(-2px); }
    #chatToggleBtn .badge-dot {
      position: absolute; top: 3px; right: 3px;
      width: 12px; height: 12px; border-radius: 50%;
      background: #22c55e; border: 2px solid #fff;
      animation: dotBlink 2s ease infinite;
    }
    @keyframes dotBlink { 0%,100%{opacity:1} 50%{opacity:.4} }

    /* Chat container */
    #chatContainer {
      position: fixed; bottom: 98px; right: 28px; z-index: 590;
      width: 360px; max-height: 520px;
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 24px;
      box-shadow: var(--shadow-lg);
      display: none; flex-direction: column;
      overflow: hidden;
      animation: chatOpen .35s cubic-bezier(.34,1.25,.64,1) both;
    }
    #chatContainer.open {
      display: flex;
    }
    @keyframes chatOpen {
      from { opacity:0; transform: scale(.88) translateY(20px); }
      to   { opacity:1; transform: scale(1)   translateY(0); }
    }

    /* Chat header */
    .chat-header {
      background: linear-gradient(135deg, var(--teal), var(--teal-dark));
      padding: 16px 20px;
      display: flex; align-items: center; gap: 12px;
    }
    .chat-header-avatar {
      width: 38px; height: 38px; border-radius: 50%;
      background: rgba(255,255,255,.22);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.1rem; flex-shrink: 0;
    }
    .chat-header-info { flex: 1; }
    .chat-header-name { font-size: .92rem; font-weight: 700; color: #fff; }
    .chat-header-status {
      font-size: .72rem; color: rgba(255,255,255,.78);
      display: flex; align-items: center; gap: 5px;
    }
    .chat-status-dot { width: 7px; height: 7px; border-radius: 50%; background: green; animation: dotBlink 2s infinite; }
    .chat-close {
      background: rgba(255,255,255,.18); border: none;
      width: 30px; height: 30px; border-radius: 8px;
      cursor: pointer; color: #fff; font-size: .85rem;
      display: flex; align-items: center; justify-content: center;
      transition: background .2s;
    }
    .chat-close:hover { background: rgba(255,255,255,.30); }

    /* Chat messages area */
    #chatBox {
      flex: 1; overflow-y: auto; padding: 16px;
      display: flex; flex-direction: column; gap: 10px;
      scroll-behavior: smooth;
      background: var(--cream);
    }
    #chatBox::-webkit-scrollbar { width: 4px; }
    #chatBox::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

    /* Message bubbles */
    .msg-wrap { display: flex; gap: 8px; animation: msgIn .3s ease both; }
    @keyframes msgIn { from{opacity:0;transform:translateY(8px)} to{opacity:1;transform:translateY(0)} }
    .msg-wrap.user { flex-direction: row-reverse; }

    .msg-avatar {
      width: 28px; height: 28px; border-radius: 50%; flex-shrink: 0;
      display: flex; align-items: center; justify-content: center;
      font-size: .72rem; font-weight: 800;
      margin-top: 2px;
    }
    .msg-avatar.bot-av  { background: linear-gradient(135deg, var(--teal-light), var(--teal)); color: #fff; }
    .msg-avatar.user-av { background: linear-gradient(135deg, #c7d2fe, #818cf8); color: #fff; }

    .msg-bubble {
      max-width: 78%; padding: 10px 14px; border-radius: 18px;
      font-size: .85rem; line-height: 1.6;
    }
    .msg-wrap.bot  .msg-bubble { background: var(--ivory); border: 1px solid var(--border); color: var(--charcoal); border-top-left-radius: 4px; }
    .msg-wrap.user .msg-bubble { background: var(--teal); color: #fff; border-top-right-radius: 4px; }

    .msg-time { font-size: .65rem; color: var(--stone); margin-top: 3px; text-align: right; }
    .msg-wrap.bot .msg-time { text-align: left; }

    /* Typing indicator */
    .typing-indicator { display: flex; gap: 4px; padding: 12px 16px; }
    .typing-dot {
      width: 7px; height: 7px; border-radius: 50%;
      background: var(--stone);
      animation: typingBounce 1.2s ease-in-out infinite;
    }
    .typing-dot:nth-child(2) { animation-delay: .2s; }
    .typing-dot:nth-child(3) { animation-delay: .4s; }
    @keyframes typingBounce { 0%,60%,100%{transform:translateY(0)} 30%{transform:translateY(-6px)} }

    /* Chat input */
    .chat-input-wrap {
      padding: 12px 14px;
      border-top: 1px solid var(--border);
      background: var(--ivory);
      display: flex; gap: 10px; align-items: center;
    }
    #message {
      flex: 1; padding: 10px 16px;
      border: 1.5px solid var(--border); border-radius: 100px;
      font-family: var(--font-body); font-size: .86rem;
      background: var(--cream2); color: var(--charcoal);
      outline: none;
      transition: border-color .2s, box-shadow .2s;
    }
    #message:focus { border-color: var(--teal); box-shadow: 0 0 0 3px var(--teal-ring); background: #fff; }
    .chat-send {
      width: 38px; height: 38px; border-radius: 50%;
      background: var(--teal); color: #fff; border: none; cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      font-size: .85rem;
      box-shadow: 0 2px 10px rgba(13,148,136,.35);
      transition: background .2s, transform .15s, box-shadow .2s;
      flex-shrink: 0;
    }
    .chat-send:hover { background: var(--teal-dark); transform: scale(1.08); box-shadow: 0 4px 16px rgba(13,148,136,.45); }

    /* quick suggestions */
    .chat-suggestions {
      padding: 8px 14px 0;
      display: flex; gap: 6px; flex-wrap: wrap;
      background: var(--ivory); border-top: 1px solid var(--border);
    }
    .suggestion-chip {
      background: var(--teal-pale); border: 1px solid rgba(13,148,136,.22);
      color: var(--teal-dark); font-size: .74rem; font-weight: 600;
      padding: 4px 12px; border-radius: 100px; cursor: pointer;
      transition: background .2s, border-color .2s;
    }
    .suggestion-chip:hover { background: rgba(13,148,136,.15); border-color: var(--teal); }

    /* ══════════════════════════════════════
       BACK TO TOP
    ══════════════════════════════════════ */
    .back-top {
      position: fixed; bottom: 28px; left: 28px; z-index: 300;
      width: 44px; height: 44px; background: var(--ivory);
      border: 1.5px solid var(--border); color: var(--slate); border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: .95rem; cursor: pointer;
      box-shadow: var(--shadow-sm);
      opacity: 0; pointer-events: none;
      transition: opacity .3s, transform .2s, border-color .2s, color .2s;
    }
    .back-top.show { opacity: 1; pointer-events: all; }
    .back-top:hover { border-color: var(--teal); color: var(--teal); transform: translateY(-2px); }

    /* ══════════════════════════════════════
       NO-ACCESS / LOGIN REDIRECT
    ══════════════════════════════════════ */
    .access-denied {
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
      padding: 40px 24px;
    }
    .access-card {
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: 24px; box-shadow: var(--shadow-lg);
      padding: 48px 40px; text-align: center; max-width: 440px;
    }
    .access-icon { font-size: 3rem; margin-bottom: 18px; }
    .access-card h3 { font-family: var(--font-display); font-size: 1.7rem; font-weight: 600; margin-bottom: 10px; }
    .access-card p  { font-size: .9rem; color: var(--stone); margin-bottom: 24px; }
    .btn-go-login {
      background: var(--teal); color: #fff;
      padding: 13px 32px; border-radius: 100px;
      font-weight: 700; font-size: .93rem;
      box-shadow: 0 4px 16px rgba(13,148,136,.38);
      transition: background .2s, transform .15s;
      display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-go-login:hover { background: var(--teal-dark); transform: translateY(-2px); color: #fff; }

    /* ══════════════════════════════════════
       RESPONSIVE
    ══════════════════════════════════════ */
    @media (max-width: 768px) {
      .nav-search  { display: none; }
      .nav-greeting-text1 { display: none; }
      .hero-stats  { gap: 14px; }
      .h-stat      { padding: 10px 14px; min-width: 80px; }
      #chatContainer { width: calc(100vw - 32px); right: 16px; }
      .main-content { padding: 28px 16px 80px; }
    }
    @media (max-width: 480px) {
      .courses-grid { grid-template-columns: 1fr; }
      .hero-banner  { padding: 36px 20px 32px; }
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
    /* ── Notification Bell ─────────────────────────────── */
.notif-wrap {
  position: relative;
}

.notif-btn {
  width: 38px; height: 38px; border-radius: 50%;
  background: var(--ivory);
  border: 1.5px solid var(--border);
  color: var(--slate);
  display: flex; align-items: center; justify-content: center;
  font-size: 1rem; cursor: pointer;
  transition: border-color .2s, color .2s, box-shadow .2s;
  position: relative;
  flex-shrink: 0;
}
.notif-btn:hover {
  border-color: orange;
  color: orange;
  box-shadow: 0 2px 10px rgba(249,115,22,.18);
}

/* Red badge counter */
.notif-count {
  position: absolute; top: -4px; right: -4px;
  min-width: 18px; height: 18px;
  background: #ef4444;
  color: #fff; font-size: .62rem; font-weight: 800;
  border-radius: 100px; border: 2px solid var(--cream);
  display: flex; align-items: center; justify-content: center;
  padding: 0 4px; line-height: 1;
  animation: notifPop .4s cubic-bezier(.34,1.56,.64,1) both;
}
.notif-count.hidden { display: none; }

@keyframes notifPop {
  from { transform: scale(0); opacity: 0; }
  to   { transform: scale(1); opacity: 1; }
}

/* Bell shake when there are new items */
.notif-btn.has-new .bi-bell-fill {
  animation: bellShake 1s ease 0.5s both;
}
@keyframes bellShake {
  0%,100% { transform: rotate(0); }
  15%     { transform: rotate(15deg); }
  30%     { transform: rotate(-12deg); }
  45%     { transform: rotate(10deg); }
  60%     { transform: rotate(-8deg); }
  75%     { transform: rotate(5deg); }
}

/* ── Dropdown Panel ─────────────────────────────────── */
.notif-panel {
  position: absolute; top: calc(100% + 12px); right: 0;
  width: 320px;
  background: var(--ivory);
  border: 1px solid var(--border);
  border-radius: 18px;
  box-shadow: 0 12px 48px rgba(0,0,0,.13);
  z-index: 500;
  overflow: hidden;
  display: none;
  flex-direction: column;
  animation: notifSlide .28s cubic-bezier(.34,1.2,.64,1) both;
}
.notif-panel.open { display: flex; }

@keyframes notifSlide {
  from { opacity: 0; transform: translateY(-10px) scale(.97); }
  to   { opacity: 1; transform: translateY(0)     scale(1); }
}

/* Panel header */
.notif-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: 14px 18px 10px;
  border-bottom: 1px solid var(--border);
}
.notif-header-title {
  font-family: var(--font-display);
  font-size: 1rem; font-weight: 600; color: var(--charcoal);
  display: flex; align-items: center; gap: 7px;
}
.notif-header-title i { color: orange; font-size: .95rem; }

.notif-mark-all {
  font-size: .72rem; font-weight: 700; color: orange;
  background: none; border: none; cursor: pointer;
  padding: 0; transition: opacity .2s;
}
.notif-mark-all:hover { opacity: .7; }

/* Scrollable list */
.notif-list {
  max-height: 300px; overflow-y: auto;
  padding: 8px 0;
}
.notif-list::-webkit-scrollbar { width: 4px; }
.notif-list::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

/* Individual item */
.notif-item {
  display: flex; align-items: flex-start; gap: 12px;
  padding: 11px 18px;
  cursor: pointer;
  transition: background .15s;
  position: relative;
  border-bottom: 1px solid #f4f4ef;
}
.notif-item:last-child { border-bottom: none; }
.notif-item:hover { background: #fff8ed; }

.notif-item.unread::before {
  content: '';
  position: absolute; left: 7px; top: 50%;
  transform: translateY(-50%);
  width: 6px; height: 6px; border-radius: 50%;
  background: orange;
}

.notif-icon {
  width: 36px; height: 36px; border-radius: 10px;
  background: #fff3e0;
  display: flex; align-items: center; justify-content: center;
  font-size: .95rem; flex-shrink: 0;
  color: orange;
}

.notif-body { flex: 1; min-width: 0; }
.notif-course-name {
  font-size: .82rem; font-weight: 600; color: var(--charcoal);
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
  margin-bottom: 2px;
}
.notif-meta {
  font-size: .72rem; color: var(--stone); font-weight: 400;
}
.notif-meta span { color: orange; font-weight: 600; }

/* Empty state inside panel */
.notif-empty {
  padding: 32px 18px; text-align: center; color: var(--stone);
  font-size: .85rem;
}
.notif-empty i { font-size: 1.8rem; display: block; margin-bottom: 8px; opacity: .4; }

/* Footer link */
.notif-footer {
  border-top: 1px solid var(--border);
  padding: 10px 18px;
  text-align: center;
}
.notif-footer a {
  font-size: .78rem; font-weight: 700; color: orange;
  display: inline-flex; align-items: center; gap: 5px;
  transition: opacity .2s;
}
.notif-footer a:hover { opacity: .75; }
  </style>
</head>
<body>

<%
  Integer studentId = (Integer) session.getAttribute("student_id");
  String studentMail = (String) session.getAttribute("student_mail");
  boolean loggedIn = (studentId != null && studentMail != null);
  String studentName = "";

  if (loggedIn) {
    try {
      DbConnection db0 = new DbConnection();
      ResultSet rs0 = db0.Select("SELECT student_name FROM student_register WHERE student_id='" + studentId + "' AND student_mail='" + studentMail + "'");
      if (rs0.next()) studentName = rs0.getString("student_name");
      rs0.close(); db0.close();
    } catch (Exception ignored) {}
  }

  // Stats
  int totalCourses = 0, enrolledCount = 0, completedCount = 0;
  if (loggedIn) {
    try {
      DbConnection dbS = new DbConnection();
      ResultSet rsT = dbS.Select("SELECT COUNT(*) AS c FROM courses WHERE status='APPROVED'");
      if (rsT.next()) totalCourses = rsT.getInt("c");
      ResultSet rsE = dbS.Select("SELECT COUNT(*) AS c FROM student_courses WHERE student_id='" + studentId + "'");
      if (rsE.next()) enrolledCount = rsE.getInt("c");
      ResultSet rsC = dbS.Select("SELECT COUNT(*) AS c FROM student_courses WHERE student_id='" + studentId + "' AND course_status='completed'");
      if (rsC.next()) completedCount = rsC.getInt("c");
      rsT.close(); rsE.close(); rsC.close(); dbS.close();
    } catch (Exception ignored) {}
  }

  // First letter of name for avatar
  String avatarLetter = (studentName != null && !studentName.isEmpty()) ? String.valueOf(studentName.charAt(0)).toUpperCase() : "S";
  String firstName = (studentName != null && studentName.contains(" ")) ? studentName.split(" ")[0] : studentName;
%>


<%
// ── Notification Data ──────────────────────────────────────────────
// NOTE: Requires a 'created_at' DATETIME column on your courses table.
//       If your column has a different name, change 'created_at' below.


java.util.List<String[]> notifCourses = new java.util.ArrayList<>();
if (loggedIn) {
    try {
        DbConnection dbN = new DbConnection();

        // ── Insert new notifications for courses not yet tracked ──
        // Only for courses student hasn't enrolled in
        dbN.insert(
            "INSERT IGNORE INTO student_notifications (student_id, course_id) " +
            "SELECT '" + studentId + "', c.course_id " +
            "FROM courses c " +
            "WHERE c.status = 'APPROVED' " +
            "  AND c.course_id NOT IN ( " +
            "        SELECT course_id FROM student_courses " +
            "        WHERE student_id = '" + studentId + "' " +
            "  ) " +
            "  AND c.course_id NOT IN ( " +
            "        SELECT course_id FROM student_notifications " +
            "        WHERE student_id = '" + studentId + "' " +
            "  )"
        );

        // ── Reset is_read=0 for notifications older than 2 days ──
        // So they show again after 2 days if student still hasn't enrolled
        dbN.insert(
            "UPDATE student_notifications " +
            "SET is_read = 0, last_shown = NOW() " +
            "WHERE student_id = '" + studentId + "' " +
            "  AND is_read = 1 " +
            "  AND last_shown <= DATE_SUB(NOW(), INTERVAL 2 DAY) " +
            "  AND course_id NOT IN ( " +
            "        SELECT course_id FROM student_courses " +
            "        WHERE student_id = '" + studentId + "' " +
            "  )"
        );

        // ── Remove notifications for courses student enrolled in ──
        dbN.insert(
            "DELETE FROM student_notifications " +
            "WHERE student_id = '" + studentId + "' " +
            "  AND course_id IN ( " +
            "        SELECT course_id FROM student_courses " +
            "        WHERE student_id = '" + studentId + "' " +
            "  )"
        );

        // ── Fetch unread notifications to display ──
        ResultSet rsN = dbN.Select(
            "SELECT sn.course_id, c.course_name " +
            "FROM student_notifications sn " +
            "JOIN courses c ON c.course_id = sn.course_id " +
            "WHERE sn.student_id = '" + studentId + "' " +
            "  AND sn.is_read = 0 " +
            "ORDER BY sn.notif_id DESC LIMIT 20"
        );
        while (rsN.next()) {
            notifCourses.add(new String[]{
                rsN.getString("course_id"),
                rsN.getString("course_name"),
                ""
            });
        }
        rsN.close(); dbN.close();
    } catch (Exception eN) {}
}
int notifCount = notifCourses.size();
%>



<% if (!loggedIn) { %>
<!-- ══ ACCESS DENIED ══ -->
<div class="access-denied">
  <div class="access-card">
    <div class="access-icon">🔒</div>
    <h3>Please Sign In</h3>
    <p>You need to log in as a student to view your courses.</p>
    <a href="index.jsp" class="btn-go-login">
      <i class="bi bi-box-arrow-in-right"></i> Go to Login
    </a>
  </div>
</div>

<% } else { %>

<!-- ══ NAVBAR ══ -->
<nav class="sk-nav1" id="skNav">
  <div class="inner">
<!--    <a class="sk-brand1" href="index.jsp">Skill<span>Sync</span></a>-->
<a class="sk-brand1" href="index.jsp" style="display:flex; align-items:center; gap:8px;">
  <img src="assets/images/logo.png" style="width:25px; height:100%;">
  REC
</a>
    <div class="nav-search">
      <i class="bi bi-search"></i>
      <input type="text" id="searchCourse" placeholder="Search courses…" autocomplete="off">
    </div>
<div class="notif-wrap" id="notifWrap">

  <!-- Bell button -->
  <button class="notif-btn <%= notifCount > 0 ? "has-new" : "" %>"
          id="notifBtn"
          onclick="toggleNotif(event)"
          title="New Course Notifications">
    <i class="bi bi-bell-fill"></i>
    <span class="notif-count <%= notifCount == 0 ? "hidden" : "" %>"
          id="notifCount"><%= notifCount %></span>
  </button>

  <!-- Dropdown panel -->
  <div class="notif-panel" id="notifPanel">

    <!-- Header -->
    <div class="notif-header">
      <div class="notif-header-title">
        <i class="bi bi-bell-fill"></i>
        New Courses
      </div>
      <% if (notifCount > 0) { %>
      <button class="notif-mark-all" onclick="markAllRead()">Mark all read</button>
      <% } %>
    </div>

    <!-- List -->
    <div class="notif-list" id="notifList">
      <% if (notifCourses.isEmpty()) { %>
      <div class="notif-empty">
        <i class="bi bi-check2-circle"></i>
        You're all caught up! No new courses.
      </div>
      <% } else {
           for (String[] nc : notifCourses) {
             String ncId   = nc[0];
             String ncName = nc[1];
             String ncDate = (nc[2] != null && nc[2].length() >= 10) ? nc[2].substring(0, 10) : "";
      %>
      <div class="notif-item unread" data-course-id="<%= ncId %>"
           onclick="goToCourse('<%= ncId %>')">
        <div class="notif-icon"><i class="bi bi-mortarboard-fill"></i></div>
        <div class="notif-body">
          <div class="notif-course-name"><%= ncName %></div>
          <div class="notif-meta">
            <span>New Course</span> &nbsp;·&nbsp; Added <%= ncDate %>
          </div>
        </div>
      </div>
      <% } } %>
    </div>

    <!-- Footer -->
    <% if (notifCount > 0) { %>
    <div class="notif-footer">
      <a href="#coursesGrid" onclick="closeNotif(); scrollToCourses();">
        <i class="bi bi-grid-fill"></i> View all courses
        <i class="bi bi-arrow-right"></i>
      </a>
    </div>
    <% } %>

  </div><!-- /notif-panel -->
</div><!-- /notif-wrap -->
    <div style="display:flex;align-items:center;gap:12px;">
      <div class="nav-greeting1">
        <div class="nav-avatar"><img src="student_img.jsp?name=<%= studentId %>" alt="<%= avatarLetter %>" style="width:30px;height:30px; border-radius:50%;"></div>
        <span class="nav-greeting-text1">Hi, <%= firstName %>!</span>
      </div>
      <a href="Student_View_Course.jsp" class="btn-logout2">Home</a>
      <a href="Student_Profile.jsp" class="btn-logout2">My Profile</a>
      <a href=index.jsp class="btn-logout1">
        <i class="bi bi-box-arrow-right"></i> Logout
      </a>
    </div>
  </div>
</nav>

<!-- ══ HERO BANNER ══ -->
<div class="hero-banner">
  <div class="hero-inner">
     
    <div class="hero-text">
         <div class="avatar-ring">
      <img src="student_img.jsp?name=<%= studentId %>" alt="<%= studentName %>">
    </div>
      <h1>Welcome back, <em><%= firstName %>!</em></h1>
      <p>Continue your learning journey — explore courses, track progress, and earn certificates.</p>
    </div>
    <div class="hero-stats">
      <div class="h-stat">
        <div class="h-stat-num"><%= totalCourses %></div>
        <div class="h-stat-label">Courses</div>
      </div>
      <div class="h-stat">
        <div class="h-stat-num"><%= enrolledCount %></div>
        <div class="h-stat-label">Enrolled</div>
      </div>
      <div class="h-stat">
        <div class="h-stat-num"><%= completedCount %></div>
        <div class="h-stat-label">Completed</div>
      </div>
    </div>
  </div>
</div>

<!-- ══ MAIN CONTENT ══ -->
<div class="main-content">

  <!-- Section header + count -->
  <div class="sec-row">
    <div>
      <div class="sec-label">Browse &amp; Enroll</div>
      <h2 class="sec-title">Available Courses</h2>
    </div>
    <span class="course-count-badge" id="courseCountBadge">
      <i class="bi bi-grid me-1"></i><span id="courseCountNum"><%= totalCourses %></span> Courses
    </span>
  </div>

  <!-- Filter tabs -->
  <div class="filter-tabs" id="filterTabs">
    <button class="filter-tab active" data-filter="all">All Courses</button>
    <button class="filter-tab" data-filter="enrolled">Enrolled</button>
    <button class="filter-tab" data-filter="completed">Completed</button>
    <button class="filter-tab" data-filter="new">Not Enrolled</button>
  </div>

  <!-- Courses grid -->
  <div class="courses-grid" id="coursesGrid">
<%
  // Load search param
  String search = request.getParameter("search");

  try {
    DbConnection db = new DbConnection();
    String sql = "SELECT * FROM courses WHERE status='APPROVED'";
    if (search != null && !search.trim().isEmpty()) {
      sql += " AND (course_name LIKE '%" + search + "%' OR description LIKE '%" + search + "%')";
    }
    ResultSet rsCourses = db.Select(sql);

    while (rsCourses.next()) {
      String courseId   = rsCourses.getString("course_id");
      String courseName = rsCourses.getString("course_name");
      String courseDesc = rsCourses.getString("description");

      // Enrollment status
      ResultSet rsEnroll = db.Select(
        "SELECT course_status FROM student_courses WHERE student_id='" + studentId + "' AND course_id='" + courseId + "'"
      );
      String courseStatus = "";
      if (rsEnroll.next()) courseStatus = rsEnroll.getString("course_status");
      rsEnroll.close();

      // Progress
      ResultSet rsTotal = db.Select("SELECT COUNT(*) AS total FROM topics WHERE course_id='" + courseId + "'");
      int totalTopics = 0;
      if (rsTotal.next()) totalTopics = rsTotal.getInt("total");
      rsTotal.close();

      ResultSet rsCompleted = db.Select(
        "SELECT COUNT(*) AS completed FROM student_topics st " +
        "JOIN topics t ON st.topic_id=t.topic_id " +
        "WHERE st.student_id='" + studentId + "' AND t.course_id='" + courseId + "' AND st.status='completed'"
      );
      int completedTopics = 0;
      if (rsCompleted.next()) completedTopics = rsCompleted.getInt("completed");
      rsCompleted.close();

      int progress = totalTopics > 0 ? (completedTopics * 100 / totalTopics) : 0;
      String progressColor = progress <= 30 ? "prog-yellow" : (progress <= 70 ? "prog-blue" : (progress <= 95 ? "prog-orange" : "prog-green"));

      boolean isCompleted = "completed".equalsIgnoreCase(courseStatus);
      boolean isEnrolled  = !courseStatus.isEmpty();
      String filterTag    = isCompleted ? "completed" : (isEnrolled ? "enrolled" : "new");
      String badgeClass   = isCompleted ? "badge-completed" : (isEnrolled ? "badge-enrolled" : "badge-new");
      String badgeLabel   = isCompleted ? "✓ Completed" : (isEnrolled ? "• Enrolled" : "New");
%>
    <div class="course-card" data-filter="<%= filterTag %>" data-title="<%= courseName.toLowerCase() %>">
      <!-- Thumbnail -->
      <div class="course-thumb">
        <img src="course_img.jsp?name=<%= courseId %>" alt="<%= courseName %>" loading="lazy">
        <div class="thumb-overlay"></div>
        <span class="c-status-badge <%= badgeClass %>"><%= badgeLabel %></span>

        <!-- Progress ring -->
        <div class="progress-ring-wrap" title="<%= progress %>% complete">
          <svg viewBox="0 0 42 42" width="44" height="44">
            <circle class="ring-track" cx="21" cy="21" r="18"/>
            <circle class="ring-fill" cx="21" cy="21" r="18"
              data-progress="<%= progress %>"/>
          </svg>
          <div class="ring-text"><%= progress %>%</div>
        </div>
      </div>

      <!-- Body -->
      <div class="course-body">
        <div class="c-category">Course</div>
        <h4 class="course-title"><%= courseName %></h4>
        <p class="course-desc"><%= courseDesc %></p>

        <!-- Linear progress bar -->
        <div class="prog-label">
          <span><i class="bi bi-book me-1"></i>Progress</span>
          <span><%= completedTopics %>/<%= totalTopics %> Topics</span>
        </div>
        <div class="prog-track">
          <div class="prog-fill <%= progressColor %>" data-progress="<%= progress %>"></div>
        </div>

        <!-- Actions -->
        <div class="card-actions">
          <% if (isCompleted) { %>
          <a href="Download_Certificate?course_id=<%= courseId %>&student_id=<%= studentId %>"
             class="btn-cert" target="_blank">
            <i class="bi bi-award"></i> Certificate
          </a>
          <% } %>
          <form action="Student_Enroll_Course.jsp" method="post" style="flex:1;display:flex;">
            <input type="hidden" name="student_id"  value="<%= studentId %>">
            <input type="hidden" name="course_id"   value="<%= courseId %>">
            <input type="hidden" name="course_name" value="<%= courseName %>">
            <input type="hidden" name="teacher_id"  value="<%= rsCourses.getString("teacher_id") %>">
            <button type="submit" class="btn-enroll">
              <i class="bi bi-<%= isEnrolled ? "play-circle" : "plus-circle" %>"></i>
              <%= isEnrolled ? "Continue" : "Enroll Now" %>
            </button>
          </form>
        </div>
      </div>
    </div>
<% 
    } // end while
    rsCourses.close(); db.close();
  } catch (Exception e) {
    out.println("<p style='color:red;padding:20px;'>Error loading courses: " + e.getMessage() + "</p>");
  }
%>
  </div><!-- /courses-grid -->

  <!-- Empty state -->
  <div class="empty-state" id="emptyState">
    <div class="empty-icon">📭</div>
    <h4>No Courses Found</h4>
    <p>Try a different search or filter.</p>
  </div>

</div><!-- /main-content -->

<!-- ══ CHATBOT ══ -->
<button id="chatToggleBtn" onclick="toggleChat()" title="Chat with SkillSync AI">
  <i class="bi bi-chat-dots-fill"></i>
  <div class="badge-dot"></div>
</button>

<div id="chatContainer">
  <div class="chat-header">
    <div class="chat-header-avatar">🤖</div>
    <div class="chat-header-info">
      <div class="chat-header-name">SkillSync Assistant</div>
      <div class="chat-header-status">
        <div class="chat-status-dot"></div> Online
      </div>
    </div>
    <button class="chat-close" onclick="toggleChat()" title="Close">
      <i class="bi bi-x-lg"></i>
    </button>
  </div>

  <!-- Quick suggestions -->
  <div class="chat-suggestions" id="chatSuggestions">
    <span class="suggestion-chip" onclick="sendSuggestion('What courses are available?')">📚 Courses</span>
    <span class="suggestion-chip" onclick="sendSuggestion('How do I enroll?')">📝 Enroll</span>
    <span class="suggestion-chip" onclick="sendSuggestion('How to get a certificate?')">🏅 Certificate</span>
  </div>

  <div id="chatBox"></div>

  <div class="chat-input-wrap">
    <input type="text" id="message" placeholder="Ask me anything…" autocomplete="off">
    <button class="chat-send" onclick="sendMessage()" title="Send">
      <i class="fa-solid fa-paper-plane"></i>
    </button>
  </div>
</div>

<!-- Back to top -->
<div class="back-top" id="backTop" onclick="window.scrollTo({top:0,behavior:'smooth'})">
  <i class="bi bi-arrow-up"></i>
</div>

<% } // end logged-in block %>


<script>
var notifOpen = false;

function toggleNotif(e) {
    e.stopPropagation();
    notifOpen = !notifOpen;
    var panel = document.getElementById('notifPanel');
    if (notifOpen) {
        panel.classList.add('open');
    } else {
        closeNotif();
    }
}

function closeNotif() {
    notifOpen = false;
    var panel = document.getElementById('notifPanel');
    if (panel) panel.classList.remove('open');
}

document.addEventListener('click', function(e) {
    var wrap = document.getElementById('notifWrap');
    if (wrap && !wrap.contains(e.target)) closeNotif();
});

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeNotif();
});

function goToCourse(courseId) {
    closeNotif();

    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'MarkNotifRead', true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhr.send('course_id=' + courseId);

    var allTab = document.querySelector('.filter-tab[data-filter="all"]');
    if (allTab) allTab.click();

    var grid = document.getElementById('coursesGrid');
    if (grid) grid.scrollIntoView({ behavior: 'smooth', block: 'start' });

    var item = document.querySelector('.notif-item[data-course-id="' + courseId + '"]');
    if (item) item.classList.remove('unread');
    updateBadge();
}

function scrollToCourses() {
    var grid = document.getElementById('coursesGrid');
    if (grid) grid.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function markAllRead() {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'MarkNotifRead', true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhr.send('mark_all=true');

    document.querySelectorAll('.notif-item.unread').forEach(function(item) {
        item.classList.remove('unread');
    });
    updateBadge();
}

function updateBadge() {
    var unread = document.querySelectorAll('.notif-item.unread').length;
    var badge  = document.getElementById('notifCount');
    var btn    = document.getElementById('notifBtn');
    if (badge) {
        badge.textContent = unread;
        badge.classList.toggle('hidden', unread === 0);
    }
    if (btn) btn.classList.toggle('has-new', unread > 0);
}
</script>
<!-- FOOTER -->
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
    String msg = (String) session.getAttribute("msg");
            if (msg != null) {
        %>
        <script> alert("<%= msg%>");</script>
        <% }
        session.removeAttribute("msg");
        %>
<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>


        
<script>
/* ═══════════════════════════════════════
   NAVBAR SCROLL SHADOW
═══════════════════════════════════════ */
var nav    = document.getElementById('skNav');
var backTop = document.getElementById('backTop');
window.addEventListener('scroll', function() {
  if (nav) nav.classList.toggle('scrolled', window.scrollY > 20);
  if (backTop) backTop.classList.toggle('show', window.scrollY > 300);
});

/* ═══════════════════════════════════════
   COURSE CARD SCROLL REVEAL
═══════════════════════════════════════ */
var cardObserver = new IntersectionObserver(function(entries) {
  entries.forEach(function(entry, idx) {
    if (entry.isIntersecting) {
      entry.target.style.animationDelay = (idx % 3 * 0.09) + 's';
      entry.target.classList.add('visible');
      cardObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.10 });

document.querySelectorAll('.course-card').forEach(function(card) {
  cardObserver.observe(card);
});

/* ═══════════════════════════════════════
   ANIMATE PROGRESS BARS + RINGS
═══════════════════════════════════════ */
var progObserver = new IntersectionObserver(function(entries) {
  entries.forEach(function(entry) {
    if (entry.isIntersecting) {
      /* linear bars */
      entry.target.querySelectorAll('.prog-fill').forEach(function(bar) {
        var pct = bar.getAttribute('data-progress');
        setTimeout(function() { bar.style.width = pct + '%'; }, 200);
      });
      /* svg rings */
      entry.target.querySelectorAll('.ring-fill').forEach(function(ring) {
        var pct = ring.getAttribute('data-progress');
        var circumference = 2 * Math.PI * 18; // r=18
        var offset = circumference - (pct / 100) * circumference;
        setTimeout(function() { ring.style.strokeDashoffset = offset; }, 300);
      });
      progObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.15 });

document.querySelectorAll('.course-card').forEach(function(card) {
  progObserver.observe(card);
});

/* ═══════════════════════════════════════
   LIVE SEARCH
═══════════════════════════════════════ */
var searchInput = document.getElementById('searchCourse');
if (searchInput) {
  searchInput.addEventListener('input', function() {
    var filter = this.value.toLowerCase().trim();
    var cards   = document.querySelectorAll('.course-card');
    var visible = 0;
    cards.forEach(function(card) {
      var title = card.getAttribute('data-title') || '';
      var match = !filter || title.includes(filter);
      card.style.display = match ? '' : 'none';
      if (match) visible++;
    });
    document.getElementById('emptyState').classList.toggle('show', visible === 0);
    var num = document.getElementById('courseCountNum');
    if (num) num.textContent = visible;
  });
}

/* ═══════════════════════════════════════
   FILTER TABS
═══════════════════════════════════════ */
document.querySelectorAll('.filter-tab').forEach(function(tab) {
  tab.addEventListener('click', function() {
    document.querySelectorAll('.filter-tab').forEach(function(t) { t.classList.remove('active'); });
    this.classList.add('active');
    var filter  = this.getAttribute('data-filter');
    var cards   = document.querySelectorAll('.course-card');
    var visible = 0;
    cards.forEach(function(card) {
      var match = filter === 'all' || card.getAttribute('data-filter') === filter;
      card.style.display = match ? '' : 'none';
      if (match) visible++;
    });
    // clear search
    if (searchInput) searchInput.value = '';
    document.getElementById('emptyState').classList.toggle('show', visible === 0);
    var num = document.getElementById('courseCountNum');
    if (num) num.textContent = visible;
  });
});

/* ═══════════════════════════════════════
   CHATBOT
═══════════════════════════════════════ */
var chatOpen = false;

function toggleChat() {
  var container = document.getElementById('chatContainer');
  chatOpen = !chatOpen;
  if (chatOpen) {
    container.classList.add('open');
    // show welcome message on first open
    if (document.getElementById('chatBox').children.length === 0) {
      setTimeout(function() {
        appendBot('👋 Hi! I\'m your SkillSync assistant. Ask me anything about your courses, progress, or certificates!');
      }, 400);
    }
    setTimeout(function() {
      document.getElementById('message').focus();
    }, 450);
  } else {
    container.style.animation = 'chatClose .25s ease both';
    setTimeout(function() {
      container.classList.remove('open');
      container.style.animation = '';
    }, 240);
  }
}

// inject close animation keyframe
var _ca = document.createElement('style');
_ca.textContent = '@keyframes chatClose{from{opacity:1;transform:scale(1) translateY(0)}to{opacity:0;transform:scale(.88) translateY(20px)}}';
document.head.appendChild(_ca);

function appendBot(text) {
  var chatBox = document.getElementById('chatBox');
  var wrap = document.createElement('div');
  wrap.className = 'msg-wrap bot';
  wrap.innerHTML =
    '<div class="msg-avatar bot-av"><i class="bi bi-robot"></i></div>' +
    '<div>' +
      '<div class="msg-bubble">' + text + '</div>' +
      '<div class="msg-time">' + getTime() + '</div>' +
    '</div>';
  chatBox.appendChild(wrap);
  chatBox.scrollTop = chatBox.scrollHeight;
}

function appendUser(text) {
  var chatBox = document.getElementById('chatBox');
  var wrap = document.createElement('div');
  wrap.className = 'msg-wrap user';
  wrap.innerHTML =
    '<div class="msg-avatar user-av"><i class="bi bi-person-fill"></i></div>' +
    '<div>' +
      '<div class="msg-bubble">' + text + '</div>' +
      '<div class="msg-time">' + getTime() + '</div>' +
    '</div>';
  chatBox.appendChild(wrap);
  chatBox.scrollTop = chatBox.scrollHeight;
}

function showTyping() {
  var chatBox = document.getElementById('chatBox');
  var typing = document.createElement('div');
  typing.id = 'typingIndicator';
  typing.className = 'msg-wrap bot';
  typing.innerHTML =
    '<div class="msg-avatar bot-av"><i class="bi bi-robot"></i></div>' +
    '<div class="msg-bubble" style="padding:10px 14px;">' +
      '<div class="typing-indicator">' +
        '<div class="typing-dot"></div>' +
        '<div class="typing-dot"></div>' +
        '<div class="typing-dot"></div>' +
      '</div>' +
    '</div>';
  chatBox.appendChild(typing);
  chatBox.scrollTop = chatBox.scrollHeight;
  return typing;
}

function getTime() {
  var now = new Date();
  return now.getHours().toString().padStart(2,'0') + ':' + now.getMinutes().toString().padStart(2,'0');
}

function sendMessage() {
  var input = document.getElementById('message');
  var text  = input.value.trim();
  if (!text) return;

  appendUser(text);
  input.value = '';

  // hide suggestions after first message
  var sugg = document.getElementById('chatSuggestions');
  if (sugg) sugg.style.display = 'none';

  var typing = showTyping();

  var xhr = new XMLHttpRequest();
  xhr.open('POST', 'ChatServlet', true);
  xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
  xhr.onreadystatechange = function() {
    if (xhr.readyState === 4) {
      if (typing && typing.parentNode) typing.parentNode.removeChild(typing);
      if (xhr.status === 200) {
        try {
          var response = JSON.parse(xhr.responseText);
          appendBot(response.reply || 'I received your message!');
        } catch(e) {
          appendBot('Sorry, I had trouble processing that. Please try again.');
        }
      } else {
        appendBot('⚠️ Server error. Please try again in a moment.');
      }
    }
  };
  xhr.send('message=' + encodeURIComponent(text));
}

function sendSuggestion(text) {
  document.getElementById('message').value = text;
  sendMessage();
}

/* Enter key */
document.getElementById('message').addEventListener('keypress', function(e) {
  if (e.key === 'Enter') sendMessage();
});

/* close on ESC */
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape' && chatOpen) toggleChat();
});
</script>
</body>
</html>
