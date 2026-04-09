<%-- 
    Document   : index1
    Created on : 10-Mar-2026, 18:36:43
    Author     : user
--%>

<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Student Learning Management</title>
  <meta name="description" content="SkillSync – Connect, learn and grow with online courses, quizzes and mentors.">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500;1,600&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- Bootstrap 5 CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    /* ════════════════════════════════════════
       DESIGN TOKENS
    ════════════════════════════════════════ */
    :root {
      --teal:         #0d9488;
      --teal-light:   #99f6e4;
      --teal-dark:    #0f766e;
      --teal-pale:    #f0fdfb;
      --amber:        #d97706;
      --cream:        #fafaf7;
      --cream2:       #f4f4ef;
      --ivory:        #fffffe;
      --charcoal:     #1a1a1a;
      --slate:        #44403c;
      --stone:        #78716c;
      --border:       #e2e8e4;
      --shadow-sm:    0 2px 12px rgba(0,0,0,.08);
      --shadow-md:    0 8px 32px rgba(0,0,0,.10);
      --shadow-lg:    0 20px 60px rgba(0,0,0,.12);
      --r-md:         16px;
      --r-lg:         24px;
      --font-display: 'Cormorant Garamond', Georgia, serif;
      --font-body:    'Plus Jakarta Sans', sans-serif;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body {
      font-family: var(--font-body);
      background: var(--cream);
      color: var(--charcoal);
      overflow-x: hidden;
      line-height: 1.7;
    }
    a { text-decoration: none; color: inherit; transition: color .2s; }
    ul { list-style: none; padding: 0; margin: 0; }
    img { width: 100%; display: block; object-fit: cover; }

    /* ════ PRELOADER ════ */
    #preloader {
      position: fixed; inset: 0; z-index: 9999;
      background: var(--ivory);
      display: flex; flex-direction: column;
      align-items: center; justify-content: center; gap: 20px;
      transition: opacity .6s, visibility .6s;
    }
    #preloader.hide { opacity: 0; visibility: hidden; }
    .pre-logo {
      font-family: var(--font-display);
      font-size: 2.2rem; font-weight: 600; color: orange;
      animation: fadeUp .7s .2s ease both;
    }
    .pre-dots { display: flex; gap: 8px; }
    .pre-dots span {
      width: 8px; height: 8px; border-radius: 50%;
      background: var(--teal-light);
      animation: dotPulse 1.2s ease-in-out infinite;
    }
    .pre-dots span:nth-child(2) { animation-delay:.2s; background:orange; }
    .pre-dots span:nth-child(3) { animation-delay:.4s; background:orange; }
    @keyframes dotPulse { 0%,80%,100%{transform:scale(.7);opacity:.5} 40%{transform:scale(1.1);opacity:1} }

    /* ════ NAVBAR ════ */
    .sk-navbar {
      position: fixed; top: 0; left: 0; right: 0; z-index: 500;
      background: rgba(250,250,247,.94);
      backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px);
      border-bottom: 1px solid var(--border);
      height: 68px; transition: box-shadow .3s;
    }
    .sk-navbar.scrolled { box-shadow: var(--shadow-md); }
    .sk-navbar .container-xl { height: 100%; display: flex; align-items: center; justify-content: space-between; padding: 0 28px; }

    .sk-brand { font-family: var(--font-display); font-size: 1.65rem; font-weight: 600; color: orange; letter-spacing: -.3px; }
    .sk-brand span { color: var(--charcoal); }

    .sk-nav { display: flex; align-items: center; gap: 36px; }
    .sk-nav a { font-size: .88rem; font-weight: 500; color: var(--slate); position: relative; padding-bottom: 2px; }
    .sk-nav a::after { content:''; position:absolute; bottom:-2px; left:0; width:0; height:1.5px; background:orange; transition:width .25s; }
    .sk-nav a:hover { color: orange; }
    .sk-nav a:hover::after { width: 100%; }

    .btn-signin {
      background: orange; color: #fff;
      font-size: .85rem; font-weight: 600;
      padding: 9px 22px; border-radius: 100px;
      border: none; cursor: pointer;
      box-shadow: 0 2px 10px rgba(13,148,136,.30);
      transition: background .2s, transform .15s, box-shadow .2s;
    }
    .btn-signin:hover { background: orange; transform: translateY(-1px); box-shadow: 0 4px 18px rgba(13,148,136,.40); color: #fff; }

    .sk-ham { display: none; flex-direction: column; gap: 5px; cursor: pointer; background: none; border: none; padding: 4px; }
    .sk-ham span { display: block; width: 22px; height: 2px; background: var(--charcoal); border-radius: 2px; transition: .3s; }
    .sk-ham.open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
    .sk-ham.open span:nth-child(2) { opacity: 0; }
    .sk-ham.open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

    .sk-mobile-nav {
      display: none; flex-direction: column;
      background: var(--ivory); border-bottom: 1px solid var(--border);
      padding: 12px 0; position: absolute; top: 68px; left: 0; right: 0;
      box-shadow: var(--shadow-md);
      animation: slideDown .25s ease both;
    }
    .sk-mobile-nav.open { display: flex; }
    @keyframes slideDown { from{opacity:0;transform:translateY(-8px)} to{opacity:1;transform:translateY(0)} }
    .sk-mobile-nav a { padding: 12px 28px; font-size: .9rem; font-weight: 500; color: var(--slate); }
    .sk-mobile-nav a:hover { color: orange; background: var(--teal-pale); }

    /* ════ HERO ════ */
    .hero {
      min-height: 100vh; padding: 110px 0 80px;
      background: var(--cream);
      position: relative; overflow: hidden;
      display: flex; align-items: center;
    }
    /* diagonal right panel */
    .hero-bg-panel {
      position: absolute; top: 0; right: 0;
      width: 52%; height: 100%;
      background: var(--cream2);
      clip-path: polygon(8% 0, 100% 0, 100% 100%, 0 100%);
      pointer-events: none; z-index: 0;
    }
    /* spinning ring */
    .hero-ring {
      position: absolute; top: 50px; right: 6%;
      width: 300px; height: 300px; border-radius: 50%;
      border: 1.5px solid rgba(13,148,136,.14);
      pointer-events: none; z-index: 0;
      animation: slowSpin 20s linear infinite;
    }
    @keyframes slowSpin { to { transform: rotate(360deg); } }
    /* dot pattern */
    .hero-dots {
      position: absolute; top: 90px; left: 3%;
      width: 150px; height: 150px;
      background-image: radial-gradient(circle, rgba(13,148,136,.2) 1.5px, transparent 1.5px);
      background-size: 18px 18px;
      pointer-events: none; z-index: 0;
      animation: floatY 10s ease-in-out infinite;
    }
    @keyframes floatY { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-14px)} }

    .hero-eyebrow {
      display: inline-flex; align-items: center; gap: 8px;
      background: rgba(13,148,136,.10); color: orange;
      padding: 5px 14px; border-radius: 100px;
      font-size: .75rem; font-weight: 700;
      letter-spacing: .08em; text-transform: uppercase;
      border: 1px solid rgba(13,148,136,.20);
      margin-bottom: 22px;
      animation: fadeUp .7s ease both;
    }
    .hero-eyebrow::before { content:''; width:6px; height:6px; border-radius:50%; background:orange; animation: blink 1.4s infinite; }
    @keyframes blink { 0%,100%{opacity:1} 50%{opacity:.2} }

    .hero h1 {
      font-family: var(--font-display);
      font-size: clamp(2.6rem, 5.5vw, 4rem);
      font-weight: 600; line-height: 1.12;
      color: var(--charcoal); margin-bottom: 22px;
      animation: fadeUp .7s .1s ease both;
    }
    .hero h1 em { font-style: italic; color: orange; }

    .hero-desc {
      font-size: 1rem; color: var(--stone);
      max-width: 460px; margin-bottom: 36px;
      font-weight: 400; line-height: 1.75;
      animation: fadeUp .7s .2s ease both;
    }
    .hero-actions { display: flex; gap: 14px; flex-wrap: wrap; animation: fadeUp .7s .3s ease both; }

    .btn-hero-primary {
      background: orange; color: #fff;
      padding: 14px 32px; border-radius: 100px;
      font-size: .93rem; font-weight: 600;
      border: none; cursor: pointer;
      box-shadow: 0 4px 18px rgba(13,148,136,.38);
      transition: background .2s, transform .15s, box-shadow .2s;
      display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-hero-primary:hover { background: orange; transform: translateY(-2px); box-shadow: 0 8px 24px rgba(13,148,136,.45); color: #fff; }

    .btn-hero-outline {
      border: 2px solid var(--border); color: var(--charcoal);
      padding: 13px 28px; border-radius: 100px;
      font-size: .93rem; font-weight: 600;
      display: inline-flex; align-items: center; gap: 8px;
      transition: border-color .2s, color .2s, transform .15s;
    }
    .btn-hero-outline:hover { border-color: orange; color: orange; transform: translateY(-2px); }

    /* stats */
    .hero-stats { display: flex; margin-top: 48px; animation: fadeUp .7s .4s ease both; }
    .hero-stat { padding-right: 28px; border-right: 1px solid var(--border); margin-right: 28px; }
    .hero-stat:last-child { border-right: none; }
    .stat-number { font-family: var(--font-display); font-size: 2rem; font-weight: 700; color: orange; line-height: 1; }
    .stat-text   { font-size: .73rem; font-weight: 600; color: var(--stone); text-transform: uppercase; letter-spacing: .07em; margin-top: 4px; }

    /* hero image */
    .hero-img-wrap { position: relative; animation: fadeUp .7s .15s ease both; }
    .hero-img-main { border-radius: var(--r-lg); overflow: hidden; box-shadow: var(--shadow-lg); border: 1px solid var(--border); }
    .hero-img-main img { height: 420px; border-radius: var(--r-lg); }

    .hero-float-card {
      position: absolute; bottom: -20px; left: -28px;
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: var(--r-md); padding: 16px 20px;
      box-shadow: var(--shadow-md);
      display: flex; align-items: center; gap: 14px;
      min-width: 210px;
      animation: fadeUp .7s .55s ease both;
    }
    .float-icon {
      width: 44px; height: 44px;
      background: var(--teal-pale); border: 1px solid rgba(13,148,136,.20);
      border-radius: 12px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.2rem; color: orange; flex-shrink: 0;
    }
    .float-card-text strong { display: block; font-size: .85rem; font-weight: 700; color: var(--charcoal); }
    .float-card-text span   { font-size: .73rem; color: var(--stone); }

    .hero-cert-tag {
      position: absolute; top: 22px; right: -16px;
      background: orange; border-radius: var(--r-md);
      padding: 13px 18px; display: flex; align-items: center; gap: 12px;
      box-shadow: 0 8px 28px rgba(13,148,136,.40);
      animation: fadeUp .7s .65s ease both;
    }
    .cert-emoji { font-size: 1.5rem; }
    .cert-tag-text strong { display: block; font-size: .82rem; font-weight: 700; color: #fff; }
    .cert-tag-text span   { font-size: .71rem; color: rgba(255,255,255,.78); }

    /* ════ SECTION HELPERS ════ */
    .sec-eyebrow {
      display: inline-block; font-size: .72rem; font-weight: 700;
      letter-spacing: .12em; text-transform: uppercase; color: orange;
      margin-bottom: 10px; position: relative; padding-left: 18px;
    }
    .sec-eyebrow::before { content:''; position:absolute; left:0; top:50%; transform:translateY(-50%); width:10px; height:2px; background:orange; }
    .sec-title { font-family: var(--font-display); font-size: clamp(2rem, 3.5vw, 2.8rem); font-weight: 600; line-height: 1.18; color: var(--charcoal); margin-bottom: 14px; }
    .sec-body  { font-size: .97rem; color: var(--stone); font-weight: 400; max-width: 520px; line-height: 1.75; }
    .sec-center { text-align: center; }
    .sec-center .sec-body { margin: 0 auto; }
    .sec-center .sec-eyebrow { padding-left: 0; }
    .sec-center .sec-eyebrow::before { display: none; }

    @keyframes fadeUp { from{opacity:0;transform:translateY(24px)} to{opacity:1;transform:translateY(0)} }
    .fade-up { opacity: 0; transform: translateY(28px); transition: opacity .65s ease, transform .65s ease; }
    .fade-up.visible { opacity: 1; transform: translateY(0); }

    /* ════ FEATURES STRIP ════ */
    .features-strip { background: orange; padding: 52px 0; }
    .feat-pill {
      display: flex; align-items: center; gap: 14px;
      padding: 20px 22px; border-radius: var(--r-md);
      background: rgba(255,255,255,.10);
      border: 1px solid rgba(255,255,255,.15);
      height: 100%;
      transition: background .25s, transform .25s;
    }
    .feat-pill:hover { background: rgba(255,255,255,.18); transform: translateY(-3px); }
    .feat-icon { width: 46px; height: 46px; background: rgba(255,255,255,.18); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; flex-shrink: 0; }
    .feat-text h5 { font-size: .9rem; font-weight: 700; color: #fff; margin-bottom: 3px; }
    .feat-text p  { font-size: .8rem; color: rgba(255,255,255,.75); margin: 0; line-height: 1.5; }

    /* ════ COURSES ════ */
    .courses-section { padding: 96px 0; background: var(--cream); }
    .course-card {
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: var(--r-lg); overflow: hidden;
      height: 100%;
      transition: box-shadow .3s, transform .3s;
    }
    .course-card:hover { box-shadow: var(--shadow-lg); transform: translateY(-6px); }
    .course-thumb { position: relative; height: 210px; overflow: hidden; }
    .course-thumb img { height: 100%; transition: transform .5s ease; }
    .course-card:hover .course-thumb img { transform: scale(1.06); }

    .c-badge { position: absolute; top: 14px; left: 14px; padding: 5px 13px; border-radius: 100px; font-size: .68rem; font-weight: 700; letter-spacing: .05em; text-transform: uppercase; backdrop-filter: blur(8px); }
    .badge-b { background: rgba(16,185,129,.15); color: #065f46; border: 1px solid rgba(16,185,129,.3); }
    .badge-i { background: rgba(217,119,6,.15);  color: #92400e; border: 1px solid rgba(217,119,6,.3); }
    .badge-a { background: rgba(220,38,38,.12);  color: #991b1b; border: 1px solid rgba(220,38,38,.25); }
    .c-modules-chip { position: absolute; top: 14px; right: 14px; background: rgba(26,26,26,.68); color:#fff; padding: 4px 10px; border-radius: 100px; font-size: .7rem; font-weight: 600; backdrop-filter: blur(4px); }

    .course-body { padding: 22px 24px 26px; }
    .c-cat { font-size: .7rem; font-weight: 700; color: orange; text-transform: uppercase; letter-spacing: .09em; margin-bottom: 8px; display: flex; align-items: center; gap: 6px; }
    .c-cat::before { content:''; width:12px; height:1.5px; background:orange; display:inline-block; }
    .course-body h4 { font-family: var(--font-display); font-size: 1.15rem; font-weight: 600; color: var(--charcoal); margin-bottom: 8px; line-height: 1.3; }
    .course-body p  { font-size: .875rem; color: var(--stone); line-height: 1.7; margin-bottom: 18px; }
    .course-footer { display: flex; align-items: center; justify-content: space-between; padding-top: 16px; border-top: 1px solid var(--border); }
    .c-pace { font-size: .8rem; color: var(--stone); font-weight: 500; }

    .btn-enroll {
      background: orange; color: #fff;
      padding: 8px 20px; border-radius: 100px;
      font-size: .8rem; font-weight: 600;
      border: none; cursor: pointer;
      box-shadow: 0 2px 10px rgba(13,148,136,.28);
      transition: background .2s, transform .15s;
    }
    .btn-enroll:hover { background: orange; transform: translateY(-1px); color: #fff; }

    /* ════ HOW IT WORKS ════ */
    .how-section { padding: 96px 0; background: var(--cream2); }
    .step-col { display: flex; flex-direction: column; align-items: center; text-align: center; }
    .step-circle {
      width: 56px; height: 56px; border-radius: 50%;
      background: var(--ivory); border: 2px solid orange;
      display: flex; align-items: center; justify-content: center;
      font-family: var(--font-display); font-size: 1.2rem; font-weight: 700; color: orange;
      margin-bottom: 18px; z-index: 1;
      box-shadow: 0 4px 16px rgba(13,148,136,.18);
      transition: background .25s, color .25s, transform .25s;
    }
    .step-col:hover .step-circle { background: orange; color: #fff; transform: scale(1.08); }
    .step-emoji { font-size: 1.3rem; margin-bottom: 10px; }
    .step-col h5 { font-family: var(--font-display); font-size: 1.05rem; font-weight: 600; margin-bottom: 8px; color: var(--charcoal); }
    .step-col p  { font-size: .85rem; color: var(--stone); line-height: 1.65; }

    /* ════ TESTIMONIALS ════ */
    .testi-section { padding: 96px 0; background: var(--cream); }
    .testi-card {
      background: var(--ivory); border: 1px solid var(--border);
      border-radius: var(--r-lg); padding: 30px; height: 100%;
      position: relative;
      transition: box-shadow .3s, transform .3s;
    }
    .testi-card:hover { box-shadow: var(--shadow-md); transform: translateY(-4px); }
    .testi-quote { font-family: var(--font-display); font-size: 4rem; line-height:1; color: var(--teal-light); font-weight: 700; position: absolute; top: 16px; right: 22px; user-select:none; }
    .testi-stars { display: flex; gap: 3px; margin-bottom: 14px; }
    .testi-stars i { color: var(--amber); font-size: .85rem; }
    .testi-card blockquote { font-size: .9rem; color: var(--slate); line-height: 1.75; margin-bottom: 22px; font-style: italic; }
    .testi-author { display: flex; align-items: center; gap: 12px; }
    .testi-avatar { width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(135deg, var(--teal-light), orange); display: flex; align-items: center; justify-content: center; font-size: .88rem; font-weight: 700; color: #fff; flex-shrink:0; }
    .testi-name { font-size: .88rem; font-weight: 700; color: var(--charcoal); }
    .testi-role { font-size: .75rem; color: var(--stone); }

    /* ════ FOOTER ════ */
    footer { background: var(--charcoal); color: rgba(255,255,255,.65); padding: 72px 0 36px; }
    .f-brand { font-family: var(--font-display); font-size: 1.65rem; font-weight: 600; color: var(--teal-light); margin-bottom: 12px; display: block; }
    .f-desc  { font-size: .88rem; line-height: 1.75; color: rgba(255,255,255,.5); }
    .f-col-title { font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .12em; color: rgba(255,255,255,.85); margin-bottom: 18px; }
    .f-links { display: flex; flex-direction: column; gap: 10px; }
    .f-links a, .f-links p { font-size: .87rem; color: rgba(255,255,255,.48); transition: color .2s; }
    .f-links a:hover { color: var(--teal-light); }
    .f-bottom { border-top: 1px solid rgba(255,255,255,.08); padding-top: 28px; margin-top: 48px; display: flex; justify-content: space-between; flex-wrap: wrap; gap: 10px; }
    .f-bottom span { font-size: .8rem; color: rgba(255,255,255,.3); }

    /* ════ BACK TO TOP ════ */
    .back-top-btn {
      position: fixed; bottom: 28px; right: 28px; z-index: 400;
      width: 46px; height: 46px; background: orange;
      color: #fff; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: 1rem;
      box-shadow: 0 4px 16px rgba(13,148,136,.40);
      cursor: pointer; opacity: 0; pointer-events: none;
      transition: opacity .3s, transform .2s;
    }
    .back-top-btn.show { opacity: 1; pointer-events: all; }
    .back-top-btn:hover { transform: translateY(-3px); }

    /* ════ LOGIN MODAL ════ */
    .modal-overlay {
      position: fixed; inset: 0; z-index: 800;
      background: rgba(26,26,26,.58);
      backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px);
      display: none; align-items: center; justify-content: center; padding: 20px;
    }
    .modal-overlay.open { display: flex; }
    .modal-box {
      background: var(--ivory); border-radius: 24px;
      width: 100%; max-width: 460px; overflow: hidden;
      box-shadow: var(--shadow-lg); border: 1px solid var(--border);
      animation: modalIn .3s cubic-bezier(.34,1.30,.64,1) both;
    }
    @keyframes modalIn { from{opacity:0;transform:scale(.88) translateY(20px)} to{opacity:1;transform:scale(1) translateY(0)} }

    .modal-head {
      background: linear-gradient(135deg, orange, orange);
      padding: 24px 28px 20px;
      display: flex; justify-content: space-between; align-items: flex-start;
      position: relative; overflow: hidden;
    }
    .modal-head::after { content:''; position:absolute; bottom:-30px; right:-30px; width:90px; height:90px; border-radius:50%; background:rgba(255,255,255,.08); }
    .modal-head h3 { font-family: var(--font-display); font-size: 1.45rem; font-weight: 600; color: #fff; margin-bottom: 3px; }
    .modal-head p  { font-size: .83rem; color: rgba(255,255,255,.78); }
    .modal-x { width:34px; height:34px; background:rgba(255,255,255,.18); border:none; border-radius:10px; color:#fff; font-size:.95rem; cursor:pointer; display:flex; align-items:center; justify-content:center; transition:background .2s, transform .2s; z-index:1; flex-shrink:0; }
    .modal-x:hover { background: rgba(255,255,255,.30); transform: rotate(90deg); }

    .role-tabs { display: flex; border-bottom: 1px solid var(--border); }
    .role-tab { flex:1; padding:13px 0; text-align:center; background:none; border:none; cursor:pointer; font-family:var(--font-body); font-size:.87rem; font-weight:600; color:var(--stone); border-bottom:2.5px solid transparent; margin-bottom:-1px; transition:color .2s, border-color .2s; }
    .role-tab.active { color: orange; border-bottom-color: orange; }
    .role-tab:hover { color: orange; }

    .modal-body { padding: 24px 28px 28px; }
    .login-form-panel { display: none; animation: fadeUp .25s ease both; }
    .login-form-panel.active { display: block; }

    .form-group { margin-bottom: 16px; }
    .form-group label { display:block; font-size:.79rem; font-weight:700; color:var(--charcoal); margin-bottom:6px; }
    .sk-input {
      width: 100%; padding: 11px 16px;
      border: 1.5px solid var(--border); border-radius: 10px;
      font-family: var(--font-body); font-size: .9rem;
      color: var(--charcoal); background: var(--cream2);
      outline: none;
      transition: border-color .2s, box-shadow .2s, background .2s;
    }
    .sk-input:focus { border-color: orange; background: #fff; box-shadow: 0 0 0 3px rgba(13,148,136,.13); }
    .forgot-link { display:block; text-align:right; margin-bottom:18px; font-size:.79rem; font-weight:600; color:orange; }
    .forgot-link:hover { opacity:.75; color:orange; }
    .register-note { text-align:center; font-size:.8rem; color:var(--stone); margin-top:14px; }
    .register-note a { color:orange; font-weight:600; }
    .btn-submit {
      width: 100%; background: orange; color: #fff; padding: 13px;
      border: none; border-radius: 10px;
      font-family: var(--font-body); font-size: .93rem; font-weight: 700;
      cursor: pointer; box-shadow: 0 4px 16px rgba(13,148,136,.35);
      transition: background .2s, transform .15s, box-shadow .2s;
    }
    .btn-submit:hover { background: orange; transform: translateY(-1px); box-shadow: 0 6px 22px rgba(13,148,136,.44); }

    /* ════ RESPONSIVE ════ */
    @media (max-width: 991px) {
      .sk-nav { display: none; }
      .sk-ham { display: flex; }
      .hero-cert-tag { right: 0; }
    }
    @media (max-width: 767px) {
      .hero { padding-top: 90px; }
      .hero-float-card { left: 0; }
      .hero-cert-tag { display: none; }
      .hero-dots, .hero-bg-panel, .hero-ring { display: none; }
      .f-bottom { flex-direction: column; text-align: center; }
    }
    @media (max-width: 575px) {
      .hero-actions { flex-direction: column; }
      .btn-hero-primary, .btn-hero-outline { justify-content: center; }
      .hero-stats { flex-wrap: wrap; gap: 16px; }
      .hero-stat { border-right: none; padding-right: 0; margin-right: 0; }
    }
  </style>
</head>
<body>

<!-- PRELOADER -->
<div id="preloader">
  <div class="pre-logo">SkillSync</div>
  <div class="pre-dots"><span></span><span></span><span></span></div>
</div>

<!-- NAVBAR -->
<nav class="sk-navbar" id="skNavbar">
  <div class="container-xl">
    <a class="sk-brand" href="index.jsp">Skill<span>Sync</span></a>
    <div class="sk-nav" id="desktopNav">
      <a href="#home">Home</a>
      <button class="btn-signin" onclick="openModal()">Sign In</button>
    </div>
    <button class="sk-ham" id="skHam" onclick="toggleMobileNav()">
      <span></span><span></span><span></span>
    </button>
  </div>
  <div class="sk-mobile-nav" id="mobileNav">
    <a href="#home"    onclick="closeMobileNav()">Home</a>
    <a href="javascript:void(0)" onclick="openModal();closeMobileNav()">Sign In</a>
  </div>
</nav>

<!-- HERO -->
<section id="home" class="hero">
  <div class="hero-bg-panel"></div>
  <div class="hero-ring"></div>
  <div class="hero-dots"></div>

  <div class="container-xl px-4 position-relative" style="z-index:1;">
    <div class="row align-items-center g-5">

      <!-- Text -->
      <div class="col-lg-6">
        <div class="hero-eyebrow"><i class="bi bi-mortarboard me-1"></i> Online Learning Platform</div>
        <h1>Welcome to<br><em>Student</em> Learning<br>Management</h1>
        <p class="hero-desc">
          An online platform where students and teachers connect, collaborate, and grow.
          Enroll in courses, attempt quizzes, and track your progress — all in one place.
        </p>
        <div class="hero-actions">
          <a href="#courses" class="btn-hero-primary">
            <i class="bi bi-compass"></i> Explore Courses
          </a>
          <a href="javascript:void(0)" class="btn-hero-outline" onclick="openModal()">
            <i class="bi bi-box-arrow-in-right"></i> Login
          </a>
        </div>
        <div class="hero-stats">
          <div class="hero-stat">
            <div class="stat-number">120+</div>
            <div class="stat-text">Courses</div>
          </div>
          <div class="hero-stat">
            <div class="stat-number">4.8k</div>
            <div class="stat-text">Students</div>
          </div>
          <div class="hero-stat">
            <div class="stat-number">98%</div>
            <div class="stat-text">Satisfaction</div>
          </div>
        </div>
      </div>

      <!-- Image -->
      <div class="col-lg-6">
        <div class="hero-img-wrap">
          <div class="hero-img-main">
            <img src="assets/images/image7.jpg" alt="Student learning online">
          </div>
          <div class="hero-float-card">
            <div class="float-icon"><i class="bi bi-shield-check"></i></div>
            <div class="float-card-text">
              <strong>Certificate Ready</strong>
              <span>Complete &amp; earn your badge</span>
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

<!-- COURSES -->
<section id="courses" class="courses-section">
  <div class="container-xl px-4">
    <div class="sec-center mb-5">
      <div class="sec-eyebrow">Our Courses</div>
      <h2 class="sec-title">Available Courses</h2>
      <p class="sec-body">Browse our learning modules. Complete lessons and test your knowledge with quizzes.</p>
    </div>
    <div class="row g-4 mb-5">

      <div class="col-lg-4 col-md-6 fade-up">
        <div class="course-card">
          <div class="course-thumb">
            <img src="assets/images/image3.jpg" alt="Python Programming">
            <span class="c-badge badge-b">🟢 Beginner</span>
            <span class="c-modules-chip">5 Modules</span>
          </div>
          <div class="course-body">
            <div class="c-cat">Programming</div>
            <h4>Python Programming</h4>
            <p>Learn Python basics and problem solving with real-world examples and hands-on practice.</p>
            <div class="course-footer">
              <span class="c-pace"><i class="bi bi-clock me-1"></i>Self-paced</span>
              <a href="javascript:void(0)" class="btn-enroll" onclick="openModal()">Enroll Now</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg-4 col-md-6 fade-up">
        <div class="course-card">
          <div class="course-thumb">
            <img src="assets/images/image2.jpg" alt="Web Development">
            <span class="c-badge badge-i">🟡 Intermediate</span>
            <span class="c-modules-chip">7 Modules</span>
          </div>
          <div class="course-body">
            <div class="c-cat">Web</div>
            <h4>Web Development</h4>
            <p>Build responsive websites using HTML, CSS, and JavaScript from scratch.</p>
            <div class="course-footer">
              <span class="c-pace"><i class="bi bi-clock me-1"></i>Self-paced</span>
              <a href="javascript:void(0)" class="btn-enroll" onclick="openModal()">Enroll Now</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg-4 col-md-6 fade-up">
        <div class="course-card">
          <div class="course-thumb">
            <img src="assets/images/image5.jpg" alt="C++ Programming">
            <span class="c-badge badge-a">🔴 Advanced</span>
            <span class="c-modules-chip">9 Modules</span>
          </div>
          <div class="course-body">
            <div class="c-cat">Programming</div>
            <h4>C++ Programming</h4>
            <p>Master the fundamentals of C++ programming, OOP concepts, and problem-solving.</p>
            <div class="course-footer">
              <span class="c-pace"><i class="bi bi-clock me-1"></i>Self-paced</span>
              <a href="javascript:void(0)" class="btn-enroll" onclick="openModal()">Enroll Now</a>
            </div>
          </div>
        </div>
      </div>

    </div>
    <div class="text-center">
      <a href="index.jsp" class="btn-hero-primary d-inline-flex">
        <i class="bi bi-grid"></i> View All Courses
      </a>
    </div>
  </div>
</section>

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
          <p><i class="bi bi-telephone me-2" style="color:var(--teal-light)"></i>+91-9876543210</p>
          <p><i class="bi bi-envelope me-2" style="color:var(--teal-light)"></i>support@skillsync.com</p>
          <p><i class="bi bi-geo-alt me-2" style="color:var(--teal-light)"></i>Learning Hub, Chennai, India</p>
        </div>
      </div>
    </div>
    <div class="f-bottom">
      <span>© 2025 SkillSync. All rights reserved.</span>
      <span>Built for students. Designed for growth.</span>
    </div>
  </div>
</footer>

<!-- Back to top -->
<div class="back-top-btn" id="backTopBtn" onclick="window.scrollTo({top:0,behavior:'smooth'})">
  <i class="bi bi-arrow-up"></i>
</div>

<!-- LOGIN MODAL -->
<div class="modal-overlay" id="loginModal" onclick="handleOverlayClick(event)">
  <div class="modal-box">

    <div class="modal-head">
      <div>
        <h3>Welcome Back</h3>
        <p>Select your role and sign in to continue</p>
      </div>
      <button class="modal-x" onclick="closeModal()"><i class="bi bi-x-lg"></i></button>
    </div>

    <div class="role-tabs">
      <button class="role-tab active" onclick="switchRole('student', this)">
        <i class="bi bi-person me-1"></i>Student
      </button>
      <button class="role-tab" onclick="switchRole('teacher', this)">
        <i class="bi bi-person-workspace me-1"></i>Teacher
      </button>
      <button class="role-tab" onclick="switchRole('admin', this)">
        <i class="bi bi-shield me-1"></i>Admin
      </button>
    </div>

    <div class="modal-body">

      <!-- Student -->
      <div class="login-form-panel active" id="panel-student">
        <form action="Student_Login" method="post" onsubmit="return validateLogin('student')" novalidate>
          <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="mail_id" class="sk-input" placeholder="you@example.com" required>
          </div>
          <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" class="sk-input" placeholder="Enter your password" required>
          </div>
          <a href="Forgot_Password.jsp" class="forgot-link">Forgot Password?</a>
          <button type="submit" class="btn-submit">Sign In as Student</button>
        </form>
        <p class="register-note">No account? <a href="Student_Register.jsp">Create one free</a></p>
      </div>

      <!-- Teacher -->
      <div class="login-form-panel" id="panel-teacher">
        <form action="Teacher_Login" method="post" onsubmit="return validateLogin('teacher')" novalidate>
          <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="mail_id" class="sk-input" placeholder="you@example.com" required>
          </div>
          <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" class="sk-input" placeholder="Enter your password" required>
          </div>
          <a href="Forgot_Password1.jsp" class="forgot-link">Forgot Password?</a>
          <button type="submit" class="btn-submit">Sign In as Teacher</button>
        </form>
        <p class="register-note">No account? <a href="Teacher_Register.jsp">Register here</a></p>
      </div>

      <!-- Admin -->
      <div class="login-form-panel" id="panel-admin">
        <form action="Admin_Login" method="post" novalidate>
          <div class="form-group">
            <label>Username</label>
            <input type="text" name="userName" class="sk-input" placeholder="Admin username" required>
          </div>
          <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" class="sk-input" placeholder="Admin password" required>
          </div>
          <div class="mb-3"></div>
          <button type="submit" class="btn-submit" style="background:var(--charcoal);">Sign In as Admin</button>
        </form>
      </div>

    </div>
  </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

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

  /* Modal */
  function openModal() {
    document.getElementById('loginModal').classList.add('open');
    document.body.style.overflow = 'hidden';
  }
  function closeModal() {
    const modal = document.getElementById('loginModal');
    const box   = modal.querySelector('.modal-box');
    box.style.animation = 'modalOut .22s ease both';
    setTimeout(() => {
      modal.classList.remove('open');
      document.body.style.overflow = '';
      box.style.animation = '';
    }, 210);
    location.reload();
  }
  function handleOverlayClick(e) {
    if (e.target === document.getElementById('loginModal')) closeModal();
  }

  /* inject modal-out keyframe */
  const _ks = document.createElement('style');
  _ks.textContent = '@keyframes modalOut{from{opacity:1;transform:scale(1) translateY(0)}to{opacity:0;transform:scale(.9) translateY(16px)}}';
  document.head.appendChild(_ks);

  /* Role switch */
  function switchRole(role, btn) {
    document.querySelectorAll('.role-tab').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.login-form-panel').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    const panel = document.getElementById('panel-' + role);
    panel.classList.add('active');
    panel.style.animation = 'none';
    void panel.offsetWidth;
    panel.style.animation = 'fadeUp .25s ease both';
  }

  /* ESC close */
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape' && document.getElementById('loginModal').classList.contains('open')) closeModal();
  });

  /* Validation */
  function validateLogin(role) {
    const form    = document.getElementById('panel-' + role).querySelector('form');
    const emailEl = form.mail_id;
    const passEl  = form.password;
    const rx      = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    let   ok      = true;
    const errStyle = el => { el.style.borderColor='#ef4444'; el.style.boxShadow='0 0 0 3px rgba(239,68,68,.13)'; el.focus(); };
    const clrStyle = el => { el.style.borderColor=''; el.style.boxShadow=''; };
    if (!rx.test(emailEl.value.trim())) { errStyle(emailEl); ok=false; } else clrStyle(emailEl);
    if (ok && passEl.value.trim().length < 4) { errStyle(passEl); ok=false; } else if(ok) clrStyle(passEl);
    return ok;
  }
  document.querySelectorAll('.sk-input').forEach(inp => {
    inp.addEventListener('input', function() { this.style.borderColor=''; this.style.boxShadow=''; });
  });

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


