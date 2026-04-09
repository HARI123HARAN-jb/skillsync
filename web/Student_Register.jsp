<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- ══ Read session messages from backend ══ --%>
<%
    String sessionMsg    = (String) session.getAttribute("msg");
    String sessionMsg1   = (String) session.getAttribute("msg1");
    String sessionName   = (String) session.getAttribute("student_name");
    String sessionMail   = (String) session.getAttribute("student_mail");

    boolean isSuccess    = "Successfully Register".equals(sessionMsg);
    boolean isDuplicate  = sessionMsg != null && sessionMsg.contains("Already exist");
    boolean hasMsg       = sessionMsg != null;

    // Clear after reading so they don't persist on refresh
    session.removeAttribute("msg");
    session.removeAttribute("msg1");
    session.removeAttribute("student_name");
    session.removeAttribute("student_mail");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SkillSync – Student Registration</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    /* ══════════════════════════════════════
       TOKENS  (matches SkillSync palette)
    ══════════════════════════════════════ */
    :root {
      --teal:        #0d9488;
      --teal-light:  #99f6e4;
      --teal-dark:   #0f766e;
      --teal-pale:   #f0fdfb;
      --teal-ring:   rgba(13,148,136,.18);
      --cream:       #fafaf7;
      --cream2:      #f4f4ef;
      --ivory:       #fffffe;
      --charcoal:    #1a1a1a;
      --slate:       #44403c;
      --stone:       #78716c;
      --border:      #e2e8e4;
      --red:         #ef4444;
      --red-pale:    rgba(239,68,68,.13);
      --green:       #22c55e;
      --shadow-sm:   0 2px 12px rgba(0,0,0,.07);
      --shadow-md:   0 8px 32px rgba(0,0,0,.10);
      --shadow-lg:   0 24px 64px rgba(0,0,0,.13);
      --r:           14px;
      --font-display:'Cormorant Garamond', Georgia, serif;
      --font-body:   'Plus Jakarta Sans', sans-serif;
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
      min-height: 100vh;
      overflow-x: hidden;
    }
    a { text-decoration: none; color: inherit; }

    /* ══════════════════════════════════════
       PAGE BACKGROUND DECORATION
    ══════════════════════════════════════ */
    .page-bg {
      position: fixed; inset: 0; pointer-events: none; z-index: 0;
      overflow: hidden;
    }
    /* diagonal teal panel top-right */
    .page-bg::before {
      content: '';
      position: absolute; top: 0; right: 0;
      width: 40%; height: 100%;
      background: var(--teal-pale);
      clip-path: polygon(18% 0, 100% 0, 100% 100%, 0 100%);
    }
    /* subtle dot grid */
    .page-bg::after {
      content: '';
      position: absolute; bottom: 60px; left: 4%;
      width: 140px; height: 140px;
      background-image: radial-gradient(circle, rgba(13,148,136,.18) 1.5px, transparent 1.5px);
      background-size: 18px 18px;
      animation: floatDots 9s ease-in-out infinite;
    }
    @keyframes floatDots { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-12px)} }

    /* spinning ring */
    .page-ring {
      position: fixed; bottom: -80px; right: -80px;
      width: 360px; height: 360px; border-radius: 50%;
      border: 1.5px solid rgba(13,148,136,.14);
      pointer-events: none; z-index: 0;
      animation: ringRotate 22s linear infinite;
    }
    @keyframes ringRotate { to { transform: rotate(360deg); } }

    /* ══════════════════════════════════════
       NAVBAR
    ══════════════════════════════════════ */
    .sk-nav {
      position: sticky; top: 0; z-index: 200;
      background: rgba(250,250,247,.94);
      backdrop-filter: blur(14px);
      border-bottom: 1px solid var(--border);
      height: 64px;
      display: flex; align-items: center;
    }
    .sk-nav .nav-inner {
      width: 100%; max-width: 1100px; margin: 0 auto;
      padding: 0 24px;
      display: flex; align-items: center; justify-content: space-between;
    }
    .sk-brand {
      font-family: var(--font-display);
      font-size: 1.6rem; font-weight: 600;
      color: var(--teal); letter-spacing: -.3px;
    }
    .sk-brand span { color: var(--charcoal); }
    .nav-signin {
      font-size: .85rem; font-weight: 600;
      color: var(--teal);
      display: inline-flex; align-items: center; gap: 6px;
      padding: 7px 18px; border-radius: 100px;
      border: 1.5px solid rgba(13,148,136,.30);
      transition: background .2s, color .2s, border-color .2s;
    }
    .nav-signin:hover {
      background: var(--teal); color: #fff;
      border-color: var(--teal);
    }

    /* ══════════════════════════════════════
       PAGE WRAPPER
    ══════════════════════════════════════ */
    .page-wrapper {
      position: relative; z-index: 1;
      padding: 48px 16px 72px;
      min-height: calc(100vh - 64px);
      display: flex; align-items: flex-start; justify-content: center;
    }

    /* ══════════════════════════════════════
       REGISTRATION CARD
    ══════════════════════════════════════ */
    .reg-card {
      background: var(--ivory);
      border: 1px solid var(--border);
      border-radius: 24px;
      box-shadow: var(--shadow-lg);
      overflow: hidden;
      width: 100%; max-width: 680px;
      animation: cardIn .55s cubic-bezier(.34,1.20,.64,1) both;
    }
    @keyframes cardIn {
      from { opacity: 0; transform: translateY(32px) scale(.97); }
      to   { opacity: 1; transform: translateY(0)    scale(1); }
    }

    /* card header band */
    .reg-header {
      background: linear-gradient(135deg, var(--teal), var(--teal-dark));
      padding: 28px 36px 24px;
      position: relative; overflow: hidden;
    }
    .reg-header::before {
      content: '';
      position: absolute; top: -40px; right: -40px;
      width: 140px; height: 140px; border-radius: 50%;
      background: rgba(255,255,255,.09);
    }
    .reg-header::after {
      content: '';
      position: absolute; bottom: -28px; left: 25%;
      width: 90px; height: 90px; border-radius: 50%;
      background: rgba(255,255,255,.06);
    }
    .reg-header-icon {
      width: 52px; height: 52px;
      background: rgba(255,255,255,.20);
      border-radius: 16px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.5rem; margin-bottom: 14px;
    }
    .reg-header h2 {
      font-family: var(--font-display);
      font-size: 1.9rem; font-weight: 600;
      color: #fff; margin-bottom: 4px; line-height: 1.1;
    }
    .reg-header p { font-size: .87rem; color: rgba(255,255,255,.80); }
    .reg-header-signin {
      position: absolute; top: 26px; right: 28px;
      background: rgba(255,255,255,.18);
      border: 1px solid rgba(255,255,255,.28);
      color: #fff; font-size: .8rem; font-weight: 600;
      padding: 7px 16px; border-radius: 100px;
      display: inline-flex; align-items: center; gap: 6px;
      transition: background .2s;
      z-index: 1;
    }
    .reg-header-signin:hover { background: rgba(255,255,255,.30); color: #fff; }

    /* progress steps */
    .reg-steps {
      display: flex; align-items: center; justify-content: center;
      gap: 0; padding: 20px 36px 0;
      border-bottom: 1px solid var(--border);
      background: var(--cream2);
      overflow-x: auto;
    }
    .step-item {
      display: flex; flex-direction: column; align-items: center;
      gap: 6px; flex: 1; min-width: 70px;
      cursor: pointer;
    }
    .step-dot {
      width: 32px; height: 32px; border-radius: 50%;
      background: var(--cream);
      border: 2px solid var(--border);
      display: flex; align-items: center; justify-content: center;
      font-size: .78rem; font-weight: 700; color: var(--stone);
      transition: background .3s, border-color .3s, color .3s, transform .2s;
      position: relative; z-index: 1;
    }
    .step-item.active .step-dot {
      background: var(--teal); border-color: var(--teal);
      color: #fff; transform: scale(1.1);
      box-shadow: 0 4px 12px rgba(13,148,136,.35);
    }
    .step-item.done .step-dot {
      background: var(--teal); border-color: var(--teal); color: #fff;
    }
    .step-label {
      font-size: .68rem; font-weight: 600; color: var(--stone);
      text-align: center; white-space: nowrap;
    }
    .step-item.active .step-label { color: var(--teal); }
    .step-connector {
      flex: 1; height: 2px; background: var(--border);
      margin-bottom: 22px; min-width: 20px; max-width: 60px;
      position: relative; overflow: hidden;
    }
    .step-connector .sc-fill {
      position: absolute; top: 0; left: 0; bottom: 0;
      background: var(--teal); width: 0;
      transition: width .5s ease;
    }

    /* ══════════════════════════════════════
       FORM BODY
    ══════════════════════════════════════ */
    .reg-body { padding: 32px 36px 36px; }

    /* Step panels */
    .step-panel { display: none; }
    .step-panel.active {
      display: block;
      animation: stepIn .35s ease both;
    }
    @keyframes stepIn { from{opacity:0;transform:translateX(18px)} to{opacity:1;transform:translateX(0)} }

    .step-title {
      font-family: var(--font-display);
      font-size: 1.25rem; font-weight: 600;
      color: var(--charcoal); margin-bottom: 6px;
    }
    .step-sub { font-size: .83rem; color: var(--stone); margin-bottom: 24px; }

    /* ── Field groups ── */
    .field-group { margin-bottom: 18px; }
    .field-group label {
      display: block; font-size: .8rem; font-weight: 700;
      color: var(--charcoal); margin-bottom: 6px;
    }
    .field-required { color: var(--red); margin-left: 2px; }

    /* floating-label input wrapper */
    .input-wrap { position: relative; }
    .input-icon {
      position: absolute; left: 14px; top: 50%;
      transform: translateY(-50%);
      color: var(--stone); font-size: .95rem;
      pointer-events: none;
      transition: color .2s;
    }
    .sk-field {
      width: 100%; padding: 11px 16px 11px 40px;
      border: 1.5px solid var(--border);
      border-radius: var(--r);
      font-family: var(--font-body);
      font-size: .9rem; font-weight: 500;
      color: var(--charcoal);
      background: var(--cream2);
      outline: none;
      transition: border-color .2s, box-shadow .2s, background .2s;
    }
    .sk-field:focus {
      border-color: var(--teal);
      background: #fff;
      box-shadow: 0 0 0 3px var(--teal-ring);
    }
    .sk-field:focus ~ .input-icon,
    .input-wrap:focus-within .input-icon { color: var(--teal); }

    /* no-icon variant */
    .sk-field.no-icon { padding-left: 16px; }

    /* valid / error states */
    .sk-field.is-valid   { border-color: var(--green); }
    .sk-field.is-invalid { border-color: var(--red); box-shadow: 0 0 0 3px var(--red-pale); }
    .field-tick {
      position: absolute; right: 14px; top: 50%;
      transform: translateY(-50%);
      font-size: .85rem; display: none;
    }
    .sk-field.is-valid   + .field-tick { display: block; color: var(--green); }
    .sk-field.is-invalid + .field-tick { display: block; color: var(--red); }

    .err-msg {
      font-size: .74rem; font-weight: 600; color: var(--red);
      margin-top: 5px; display: none;
      animation: errIn .2s ease both;
    }
    @keyframes errIn { from{opacity:0;transform:translateY(-4px)} to{opacity:1;transform:translateY(0)} }
    .err-msg.show { display: block; }

    /* Gender radio */
    .gender-row { display: flex; gap: 14px; }
    .gender-opt {
      flex: 1;
      border: 1.5px solid var(--border);
      border-radius: var(--r);
      padding: 12px 16px;
      display: flex; align-items: center; gap: 10px;
      cursor: pointer;
      background: var(--cream2);
      transition: border-color .2s, background .2s, box-shadow .2s;
    }
    .gender-opt input[type="radio"] { display: none; }
    .gender-opt .radio-custom {
      width: 18px; height: 18px; border-radius: 50%;
      border: 2px solid var(--border);
      background: #fff;
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0;
      transition: border-color .2s;
    }
    .gender-opt .radio-custom::after {
      content: ''; width: 8px; height: 8px; border-radius: 50%;
      background: var(--teal); display: none;
    }
    .gender-opt:has(input:checked) {
      border-color: var(--teal);
      background: var(--teal-pale);
      box-shadow: 0 0 0 3px var(--teal-ring);
    }
    .gender-opt:has(input:checked) .radio-custom { border-color: var(--teal); }
    .gender-opt:has(input:checked) .radio-custom::after { display: block; }
    .gender-opt span { font-size: .88rem; font-weight: 600; color: var(--slate); }

    /* File upload */
    .file-upload-area {
      border: 2px dashed var(--border);
      border-radius: var(--r);
      background: var(--cream2);
      padding: 32px 20px;
      text-align: center;
      cursor: pointer;
      transition: border-color .25s, background .25s;
      position: relative;
    }
    .file-upload-area:hover, .file-upload-area.drag-over {
      border-color: var(--teal);
      background: var(--teal-pale);
    }
    .file-upload-area input[type="file"] {
      position: absolute; inset: 0; opacity: 0; cursor: pointer;
    }
    .file-icon { font-size: 2rem; color: var(--teal); margin-bottom: 10px; }
    .file-text { font-size: .85rem; font-weight: 600; color: var(--slate); margin-bottom: 4px; }
    .file-sub  { font-size: .75rem; color: var(--stone); }
    .file-preview {
      display: none; margin-top: 14px;
      align-items: center; gap: 12px;
    }
    .file-preview.show { display: flex; }
    .file-preview img {
      width: 56px; height: 56px; border-radius: 50%;
      object-fit: cover; border: 2px solid var(--teal);
    }
    .file-preview-name { font-size: .82rem; font-weight: 600; color: var(--charcoal); }
    .file-preview-size { font-size: .74rem; color: var(--stone); }

    /* ══════════════════════════════════════
       NAVIGATION BUTTONS
    ══════════════════════════════════════ */
    .step-nav {
      display: flex; justify-content: space-between; align-items: center;
      margin-top: 28px; padding-top: 20px;
      border-top: 1px solid var(--border);
    }
    .btn-prev {
      border: 1.5px solid var(--border);
      background: none; color: var(--slate);
      font-family: var(--font-body);
      font-size: .88rem; font-weight: 600;
      padding: 11px 24px; border-radius: 100px;
      cursor: pointer;
      display: inline-flex; align-items: center; gap: 7px;
      transition: border-color .2s, color .2s, transform .15s;
    }
    .btn-prev:hover { border-color: var(--teal); color: var(--teal); transform: translateX(-2px); }
    .btn-prev:disabled { opacity: .35; pointer-events: none; }

    .btn-next {
      background: var(--teal); color: #fff;
      font-family: var(--font-body);
      font-size: .88rem; font-weight: 700;
      padding: 12px 28px; border-radius: 100px;
      border: none; cursor: pointer;
      display: inline-flex; align-items: center; gap: 7px;
      box-shadow: 0 4px 16px rgba(13,148,136,.38);
      transition: background .2s, transform .15s, box-shadow .2s;
    }
    .btn-next:hover { background: var(--teal-dark); transform: translateX(2px); box-shadow: 0 6px 22px rgba(13,148,136,.44); }

    .btn-submit-final {
      background: linear-gradient(135deg, var(--teal), var(--teal-dark));
      color: #fff; font-family: var(--font-body);
      font-size: .93rem; font-weight: 700;
      padding: 13px 36px; border-radius: 100px;
      border: none; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px;
      box-shadow: 0 4px 18px rgba(13,148,136,.42);
      transition: transform .15s, box-shadow .2s;
    }
    .btn-submit-final:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(13,148,136,.50); }

    /* loading spinner */
    .spin {
      width: 16px; height: 16px;
      border: 2.5px solid rgba(255,255,255,.4);
      border-top-color: #fff;
      border-radius: 50%;
      animation: spin .7s linear infinite;
      display: none;
    }
    @keyframes spin { to { transform: rotate(360deg); } }
    .btn-submit-final.loading .spin { display: block; }
    .btn-submit-final.loading .btn-label { display: none; }

    /* ══════════════════════════════════════
       SUCCESS SCREEN
    ══════════════════════════════════════ */
    .success-screen {
      display: none; text-align: center; padding: 40px 20px;
      animation: stepIn .4s ease both;
    }
    .success-screen.show { display: block; }
    .success-circle {
      width: 88px; height: 88px; border-radius: 50%;
      background: rgba(34,197,94,.12);
      border: 3px solid var(--green);
      display: flex; align-items: center; justify-content: center;
      font-size: 2.2rem;
      margin: 0 auto 20px;
      animation: popIn .5s .1s ease both;
    }
    @keyframes popIn { from{transform:scale(0)} 70%{transform:scale(1.2)} to{transform:scale(1)} }
    .success-screen h3 { font-family: var(--font-display); font-size: 1.8rem; font-weight: 600; color: var(--charcoal); margin-bottom: 8px; }
    .success-screen p  { font-size: .9rem; color: var(--stone); margin-bottom: 24px; }

    /* ══════════════════════════════════════
       PROGRESS BAR (top of card)
    ══════════════════════════════════════ */
    .top-progress {
      height: 4px; background: var(--border); border-radius: 0;
    }
    .top-progress-fill {
      height: 100%;
      background: linear-gradient(90deg, var(--teal), var(--teal-light));
      border-radius: 0; width: 0;
      transition: width .5s ease;
    }

    /* ══════════════════════════════════════
       TOAST NOTIFICATION
    ══════════════════════════════════════ */
    .sk-toast {
      position: fixed; top: 84px; right: 24px; z-index: 9999;
      background: var(--ivory);
      border: 1.5px solid var(--border);
      border-radius: 16px;
      padding: 16px 20px;
      min-width: 300px; max-width: 380px;
      box-shadow: var(--shadow-lg);
      display: flex; align-items: flex-start; gap: 14px;
      animation: toastIn .45s cubic-bezier(.34,1.25,.64,1) both;
      pointer-events: all;
    }
    @keyframes toastIn {
      from { opacity:0; transform: translateX(60px) scale(.92); }
      to   { opacity:1; transform: translateX(0)    scale(1); }
    }
    .sk-toast.hide {
      animation: toastOut .3s ease both;
    }
    @keyframes toastOut {
      from { opacity:1; transform: translateX(0); }
      to   { opacity:0; transform: translateX(60px); }
    }
    .toast-icon {
      width: 38px; height: 38px; border-radius: 12px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.1rem; flex-shrink: 0;
    }
    .toast-icon.success { background: rgba(34,197,94,.12); color: var(--green); border: 1.5px solid rgba(34,197,94,.25); }
    .toast-icon.error   { background: rgba(239,68,68,.10);  color: var(--red);   border: 1.5px solid rgba(239,68,68,.22); }
    .toast-icon.info    { background: rgba(13,148,136,.10); color: var(--teal);  border: 1.5px solid rgba(13,148,136,.22); }
    .toast-title { font-size: .88rem; font-weight: 700; color: var(--charcoal); margin-bottom: 3px; }
    .toast-body  { font-size: .8rem;  color: var(--stone); line-height: 1.5; }
    .toast-close {
      margin-left: auto; background: none; border: none;
      font-size: .9rem; color: var(--stone); cursor: pointer;
      padding: 2px 4px; border-radius: 6px;
      transition: background .2s, color .2s; flex-shrink: 0;
    }
    .toast-close:hover { background: var(--cream2); color: var(--charcoal); }

    /* toast progress bar */
    .toast-progress {
      position: absolute; bottom: 0; left: 0;
      height: 3px; border-radius: 0 0 16px 16px;
      animation: toastProgress linear forwards;
    }
    .sk-toast { position: fixed; overflow: hidden; }
    .toast-progress.success { background: var(--green); }
    .toast-progress.error   { background: var(--red);   }
    @keyframes toastProgress { from { width:100%; } to { width:0; } }

    /* ══════════════════════════════════════
       SUCCESS OVERLAY (post-registration)
    ══════════════════════════════════════ */
    .reg-success-overlay {
      display: none;
      text-align: center; padding: 48px 28px 40px;
    }
    .reg-success-overlay.show { display: block; animation: stepIn .45s ease both; }
    .reg-success-circle {
      width: 96px; height: 96px; border-radius: 50%;
      background: rgba(34,197,94,.12);
      border: 3px solid var(--green);
      display: flex; align-items: center; justify-content: center;
      font-size: 2.6rem;
      margin: 0 auto 24px;
      animation: popIn .55s .1s ease both;
    }
    .reg-success-overlay h2 {
      font-family: var(--font-display);
      font-size: 2rem; font-weight: 600;
      color: var(--charcoal); margin-bottom: 10px;
    }
    .reg-success-overlay .sub {
      font-size: .93rem; color: var(--stone); margin-bottom: 8px;
    }
    .reg-id-badge {
      display: inline-block;
      background: var(--teal-pale);
      border: 1.5px solid rgba(13,148,136,.30);
      color: var(--teal-dark);
      font-size: .88rem; font-weight: 700;
      padding: 8px 20px; border-radius: 100px;
      margin-bottom: 28px;
    }
    .reg-success-actions { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }

    /* ══════════════════════════════════════
       RESPONSIVE
    ══════════════════════════════════════ */
    @media (max-width: 600px) {
      .reg-header { padding: 22px 22px 20px; }
      .reg-body   { padding: 24px 22px 28px; }
      .reg-steps  { padding: 16px 16px 0; }
      .gender-row { flex-direction: column; gap: 10px; }
      .reg-header-signin { position: static; margin-top: 12px; display: inline-flex; }
      .step-connector { display: none; }
    }
  </style>
</head>
<body>

<!-- ══ TOAST CONTAINER (rendered by JSP session) ══ -->
<div id="toastContainer"></div>

<!-- ══ JSP SESSION TOAST TRIGGER ══ -->
<%-- Fire on page load based on session messages --%>
<script id="sessionData"
  data-success="<%= isSuccess %>"
  data-duplicate="<%= isDuplicate %>"
  data-msg="<%= sessionMsg  != null ? sessionMsg.replace("\"","&quot;")  : "" %>"
  data-msg1="<%= sessionMsg1 != null ? sessionMsg1.replace("\"","&quot;") : "" %>"
  data-name="<%= sessionName != null ? sessionName.replace("\"","&quot;") : "" %>"
  data-mail="<%= sessionMail != null ? sessionMail.replace("\"","&quot;") : "" %>"
></script>

<!-- Background decoration -->
<div class="page-bg"></div>
<div class="page-ring"></div>

<!-- Navbar -->
<nav class="sk-nav">
  <div class="nav-inner">
    <a class="sk-brand" href="index.jsp">Skill<span>Sync</span></a>
    <a href="index.jsp" class="nav-signin">
      <i class="bi bi-box-arrow-in-right"></i> Sign In
    </a>
  </div>
</nav>

<!-- Page Content -->
<div class="page-wrapper">
  <div class="reg-card">

    <!-- Top progress bar -->
    <div class="top-progress">
      <div class="top-progress-fill" id="topProgress"></div>
    </div>

    <!-- Header band -->
    <div class="reg-header">
      <a href="index.jsp" class="reg-header-signin">
        <i class="bi bi-box-arrow-in-right"></i> Sign In
      </a>
      <div class="reg-header-icon">🎓</div>
      <h2>Create Your Account</h2>
      <p>Join SkillSync — it's free and takes less than 2 minutes</p>
    </div>

    <!-- Step indicator -->
    <div class="reg-steps" id="stepsBar">
      <div class="step-item active" id="stepTab0" onclick="goToStep(0)">
        <div class="step-dot" id="stepDot0">1</div>
        <div class="step-label">Personal</div>
      </div>
      <div class="step-connector"><div class="sc-fill" id="sc0"></div></div>
      <div class="step-item" id="stepTab1" onclick="goToStep(1)">
        <div class="step-dot" id="stepDot1">2</div>
        <div class="step-label">Academic</div>
      </div>
      <div class="step-connector"><div class="sc-fill" id="sc1"></div></div>
      <div class="step-item" id="stepTab2" onclick="goToStep(2)">
        <div class="step-dot" id="stepDot2">3</div>
        <div class="step-label">Account</div>
      </div>
      <div class="step-connector"><div class="sc-fill" id="sc2"></div></div>
      <div class="step-item" id="stepTab3" onclick="goToStep(3)">
        <div class="step-dot" id="stepDot3">4</div>
        <div class="step-label">Profile</div>
      </div>
    </div>

    <!-- Form -->
    <div class="reg-body">
      <form action="Student_Register" method="post" enctype="multipart/form-data" 
            id="regForm" novalidate>

        <!-- ── STEP 1: Personal Info ── -->
        <div class="step-panel active" id="panel0">
          <div class="step-title">Personal Information</div>
          <div class="step-sub">Tell us a little about yourself</div>

          <div class="row g-3">
            <div class="col-12">
              <div class="field-group">
                <label for="student_name">Full Name <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-person input-icon"></i>
                  <input type="text" name="student_name" id="student_name"
                         class="sk-field" placeholder="Enter your full name">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-student_name">Please enter your full name.</div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="field-group">
                <label>Gender <span class="field-required">*</span></label>
                <div class="gender-row">
                  <label class="gender-opt">
                    <input type="radio" name="gender" value="Male" id="male">
                    <span class="radio-custom"></span>
                    <span>♂ Male</span>
                  </label>
                  <label class="gender-opt">
                    <input type="radio" name="gender" value="Female" id="female">
                    <span class="radio-custom"></span>
                    <span>♀ Female</span>
                  </label>
                </div>
                <div class="err-msg" id="err-gender">Please select your gender.</div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="field-group">
                <label for="age">Age <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-calendar2 input-icon"></i>
                  <input type="number" name="age" id="age"
                         class="sk-field" placeholder="Enter your age" min="15" max="60">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-age">Enter a valid age (15–60).</div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="field-group">
                <label for="ph_no">Phone Number <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-telephone input-icon"></i>
                  <input type="text" name="ph_no" id="ph_no"
                         class="sk-field" placeholder="10-digit mobile number" maxlength="10">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-ph_no">Enter a valid 10-digit phone number.</div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="field-group">
                <label for="address">Address <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-geo-alt input-icon"></i>
                  <input type="text" name="address" id="address"
                         class="sk-field" placeholder="Your city / area">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-address">Please enter your address.</div>
              </div>
            </div>
          </div>

          <div class="step-nav">
            <button type="button" class="btn-prev" disabled>
              <i class="bi bi-arrow-left"></i> Back
            </button>
            <button type="button" class="btn-next" onclick="nextStep(0)">
              Next <i class="bi bi-arrow-right"></i>
            </button>
          </div>
        </div>

        <!-- ── STEP 2: Academic Info ── -->
        <div class="step-panel" id="panel1">
          <div class="step-title">Academic Details</div>
          <div class="step-sub">Your college and course information</div>

          <div class="row g-3">
            <div class="col-12">
              <div class="field-group">
                <label for="college_name">College Name <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-building input-icon"></i>
                  <input type="text" name="college_name" id="college_name"
                         class="sk-field" placeholder="Enter your college name">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-college_name">Please enter your college name.</div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="field-group">
                <label for="department">Department <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-diagram-3 input-icon"></i>
                  <input type="text" name="department" id="department"
                         class="sk-field" placeholder="e.g. Computer Science">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-department">Please enter your department.</div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="field-group">
                <label for="degree">Degree <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-mortarboard input-icon"></i>
                  <input type="text" name="degree" id="degree"
                         class="sk-field" placeholder="e.g. B.E / B.Tech / BCA">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-degree">Please enter your degree.</div>
              </div>
            </div>

            <div class="col-12">
              <div class="field-group">
                <label for="register_id">College Register ID <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-card-text input-icon"></i>
                  <input type="text" name="register_id" id="register_id"
                         class="sk-field" placeholder="Enter your register / roll number">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-register_id">Please enter your register ID.</div>
              </div>
            </div>
          </div>

          <div class="step-nav">
            <button type="button" class="btn-prev" onclick="prevStep(1)">
              <i class="bi bi-arrow-left"></i> Back
            </button>
            <button type="button" class="btn-next" onclick="nextStep(1)">
              Next <i class="bi bi-arrow-right"></i>
            </button>
          </div>
        </div>

        <!-- ── STEP 3: Account Info ── -->
        <div class="step-panel" id="panel2">
          <div class="step-title">Account Setup</div>
          <div class="step-sub">Create your SkillSync login credentials</div>

          <div class="row g-3">
            <div class="col-12">
              <div class="field-group">
                <label for="mail_id">Email Address <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-envelope input-icon"></i>
                  <input type="email" name="mail_id" id="mail_id"
                         class="sk-field" placeholder="you@example.com">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-mail_id">Please enter a valid email address.</div>
              </div>
            </div>

            <div class="col-12">
              <div class="field-group">
                <label for="password">Password <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-lock input-icon"></i>
                  <input type="password" name="password" id="password"
                         class="sk-field" placeholder="Min. 8 characters">
                  <button type="button" class="field-tick" id="togglePass"
                          style="background:none;border:none;cursor:pointer;padding:0;display:flex;align-items:center;color:var(--stone);">
                    <i class="bi bi-eye" id="eyeIcon"></i>
                  </button>
                </div>
                <div class="err-msg" id="err-password">Password must be at least 8 characters.</div>

                <!-- strength bar -->
                <div style="margin-top:8px;">
                  <div style="height:4px;background:var(--border);border-radius:99px;overflow:hidden;">
                    <div id="strengthBar" style="height:100%;width:0;border-radius:99px;transition:width .3s,background .3s;"></div>
                  </div>
                  <div id="strengthLabel" style="font-size:.72rem;font-weight:600;color:var(--stone);margin-top:4px;"></div>
                </div>
              </div>
            </div>

            <div class="col-12">
              <div class="field-group">
                <label for="confirm_password">Confirm Password <span class="field-required">*</span></label>
                <div class="input-wrap">
                  <i class="bi bi-lock-fill input-icon"></i>
                  <input type="password" name="confirm_password" id="confirm_password"
                         class="sk-field" placeholder="Re-enter password">
                  <span class="field-tick"><i class="bi bi-check-circle-fill"></i></span>
                </div>
                <div class="err-msg" id="err-confirm_password">Passwords do not match.</div>
              </div>
            </div>
          </div>

          <div class="step-nav">
            <button type="button" class="btn-prev" onclick="prevStep(2)">
              <i class="bi bi-arrow-left"></i> Back
            </button>
            <button type="button" class="btn-next" onclick="nextStep(2)">
              Next <i class="bi bi-arrow-right"></i>
            </button>
          </div>
        </div>

        <!-- ── STEP 4: Profile Photo ── -->
        <div class="step-panel" id="panel3">
          <div class="step-title">Profile Photo</div>
          <div class="step-sub">Upload a clear photo — JPG or PNG, max 5 MB</div>

          <div class="field-group">
            <div class="file-upload-area" id="dropZone">
              <input type="file" name="image" id="Image" accept="image/*" required
                     onchange="previewFile(this)">
              <div class="file-icon"><i class="bi bi-cloud-arrow-up"></i></div>
              <div class="file-text">Click to upload or drag &amp; drop</div>
              <div class="file-sub">JPG, PNG, WEBP · Max 5 MB</div>
              <div class="file-preview" id="filePreview">
                <img id="previewImg" src="" alt="preview">
                <div>
                  <div class="file-preview-name" id="previewName"></div>
                  <div class="file-preview-size" id="previewSize"></div>
                </div>
              </div>
            </div>
            <div class="err-msg" id="err-image">Please upload a profile photo.</div>
          </div>

          <!-- Summary review -->
          <div style="background:var(--teal-pale);border:1px solid rgba(13,148,136,.22);border-radius:var(--r);padding:16px 20px;margin-bottom:4px;">
            <div style="font-size:.78rem;font-weight:700;color:var(--teal-dark);text-transform:uppercase;letter-spacing:.08em;margin-bottom:12px;">
              <i class="bi bi-check2-all me-1"></i> Registration Summary
            </div>
            <div id="summaryGrid" style="display:grid;grid-template-columns:1fr 1fr;gap:6px 24px;font-size:.82rem;"></div>
          </div>

          <div class="step-nav">
            <button type="button" class="btn-prev" onclick="prevStep(3)">
              <i class="bi bi-arrow-left"></i> Back
            </button>
            <button type="submit" class="btn-submit-final" id="submitBtn"
                    >
              <span class="btn-label"><i class="bi bi-person-check me-1"></i> Register Now</span>
              <span class="spin"></span>
            </button>
          </div>
        </div>

        <!-- ── SUCCESS SCREEN (shown when backend redirects back with msg=Successfully Register) ── -->
        <div class="reg-success-overlay" id="successOverlay">
          <div class="reg-success-circle">✓</div>
          <h2>Registration Successful!</h2>
          <p class="sub">Welcome to SkillSync, <strong id="successName"></strong>!</p>
          <p class="sub" style="margin-bottom:14px;">Your account has been created. Your ID is:</p>
          <div class="reg-id-badge" id="successIdBadge">
            <i class="bi bi-person-badge me-2"></i><span id="successId">—</span>
          </div>
          <p class="sub" style="font-size:.82rem;margin-bottom:24px;color:var(--stone);">
            Registered email: <strong id="successMail"></strong>
          </p>
          <div class="reg-success-actions">
            <a href="index.jsp" class="btn-next text-decoration-none" style="display:inline-flex;">
              <i class="bi bi-box-arrow-in-right"></i> Sign In Now
            </a>
            <a href="Student_Register.jsp" class="btn-prev text-decoration-none" style="display:inline-flex;border:1.5px solid var(--border);">
              <i class="bi bi-person-plus"></i> Register Another
            </a>
          </div>
        </div>

      </form>
    </div><!-- /reg-body -->
  </div><!-- /reg-card -->
</div><!-- /page-wrapper -->

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
  /* ═══════════════════════════════════════
     TOAST SYSTEM
  ═══════════════════════════════════════ */
  function showToast(type, title, body, duration) {
    duration = duration || 5000;
    var container = document.getElementById('toastContainer');
    var toast = document.createElement('div');
    toast.className = 'sk-toast';
    var iconMap = { success: 'bi-check-circle-fill', error: 'bi-x-circle-fill', info: 'bi-info-circle-fill' };
    var labelMap = { success: 'Success', error: 'Error', info: 'Info' };
    toast.innerHTML =
      '<div class="toast-icon ' + type + '"><i class="bi ' + (iconMap[type]||'bi-info-circle-fill') + '"></i></div>' +
      '<div style="flex:1">' +
        '<div class="toast-title">' + title + '</div>' +
        '<div class="toast-body">' + body + '</div>' +
      '</div>' +
      '<button class="toast-close" onclick="dismissToast(this.parentNode)"><i class="bi bi-x"></i></button>' +
      '<div class="toast-progress ' + type + '" style="animation-duration:' + duration + 'ms"></div>';
    container.appendChild(toast);
    setTimeout(function() { dismissToast(toast); }, duration);
  }

  function dismissToast(toast) {
    if (!toast || !toast.parentNode) return;
    toast.classList.add('hide');
    setTimeout(function() { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 320);
  }

  /* ═══════════════════════════════════════
     SESSION MESSAGE HANDLER
     Reads data attributes injected by JSP
  ═══════════════════════════════════════ */
  window.addEventListener('DOMContentLoaded', function() {
    var sd = document.getElementById('sessionData');
    if (!sd) return;

    var isSuccess   = sd.dataset.success   === 'true';
    var isDuplicate = sd.dataset.duplicate === 'true';
    var msg         = sd.dataset.msg  || '';
    var msg1        = sd.dataset.msg1 || '';
    var name        = sd.dataset.name || '';
    var mail        = sd.dataset.mail || '';

    if (isSuccess) {
      /* ── Show the full success overlay ── */
      hideForm();
      document.getElementById('successOverlay').classList.add('show');

      /* Parse student ID from msg1 e.g. "Your User Identification Number Is :\n42" */
      var idMatch = msg1.match(/(\d+)\s*$/);
      var studentId = idMatch ? idMatch[1] : '—';

      document.getElementById('successName').textContent  = name || 'Student';
      document.getElementById('successMail').textContent  = mail || '';
      document.getElementById('successId').textContent    = 'ID: ' + studentId;

      /* Also show a toast */
      showToast('success',
        '🎉 Registration Successful!',
        'Welcome ' + (name || '') + '! Your Student ID is ' + studentId + '.',
        8000);

    } else if (isDuplicate) {
      /* Duplicate email — show error toast (user will be on index.jsp, but
         if redirect brings them back here, handle gracefully) */
      showToast('error',
        'Account Already Exists',
        'This email is already registered. Please sign in instead.',
        7000);

    } else if (msg && msg.trim() !== '') {
      /* Generic backend message */
      showToast('info', 'Notice', msg, 6000);
    }
  });

  /* Hide form panels and steps bar when showing success */
  function hideForm() {
    document.querySelectorAll('.step-panel').forEach(function(p) { p.style.display = 'none'; });
    document.getElementById('stepsBar').style.display = 'none';
    document.getElementById('topProgress').style.display = 'none';
    var hdr = document.querySelector('.reg-header p');
    if (hdr) hdr.textContent = 'Your account is ready. Welcome aboard!';
  }

  /* ═══════════════════════════════════════
     STEP NAVIGATION
  ═══════════════════════════════════════ */
  var currentStep = 0;
  var totalSteps  = 4;
  var stepsCompleted = [false, false, false, false];

  function updateUI(step) {
    document.querySelectorAll('.step-panel').forEach(function(p, i) {
      p.classList.toggle('active', i === step);
    });
    for (var i = 0; i < totalSteps; i++) {
      var tab = document.getElementById('stepTab' + i);
      var dot = document.getElementById('stepDot' + i);
      tab.classList.remove('active', 'done');
      if (i === step) { tab.classList.add('active'); dot.innerHTML = i + 1; }
      else if (i < step) { tab.classList.add('done'); dot.innerHTML = '<i class="bi bi-check2" style="font-size:.75rem"></i>'; }
      else { dot.innerHTML = i + 1; }
    }
    for (var j = 0; j < 3; j++) {
      var fill = document.getElementById('sc' + j);
      fill.style.width = (j < step) ? '100%' : '0';
    }
    document.getElementById('topProgress').style.width =
      (((step) / (totalSteps - 1)) * 100) + '%';
    currentStep = step;
  }

  function goToStep(step) {
    if (step > currentStep && !stepsCompleted[currentStep]) return;
    updateUI(step);
  }

  function nextStep(step) {
    if (!validateStep(step)) return;
    stepsCompleted[step] = true;
    if (step === totalSteps - 2) buildSummary();
    updateUI(step + 1);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function prevStep(step) {
    updateUI(step - 1);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  /* ═══════════════════════════════════════
     PER-STEP VALIDATION
  ═══════════════════════════════════════ */
  function validateStep(step) {
    var ok = true;
    if (step === 0) {
      ok = chkReq('student_name', /\S{2}/, 'Please enter your full name.') && ok;
      ok = chkRadio('gender', 'err-gender') && ok;
      ok = chkReq('age', /^(1[5-9]|[2-5]\d|60)$/, 'Enter a valid age (15–60).') && ok;
      ok = chkReq('ph_no', /^\d{10}$/, 'Enter a valid 10-digit phone number.') && ok;
      ok = chkReq('address', /\S{3}/, 'Please enter your address.') && ok;
    } else if (step === 1) {
      ok = chkReq('college_name', /\S{2}/, 'Please enter your college name.') && ok;
      ok = chkReq('department', /\S{2}/, 'Please enter your department.') && ok;
      ok = chkReq('degree', /\S{2}/, 'Please enter your degree.') && ok;
      ok = chkReq('register_id', /\S{3}/, 'Please enter your register ID.') && ok;
    } else if (step === 2) {
      ok = chkReq('mail_id', /^[^\s@]+@[^\s@]+\.[^\s@]+$/, 'Please enter a valid email address.') && ok;
      ok = chkReq('password', /^.{8,}$/, 'Password must be at least 8 characters.') && ok;
      ok = chkConfirm() && ok;
    }
    return ok;
  }

  function chkReq(id, rx, msg) {
    var el  = document.getElementById(id);
    var err = document.getElementById('err-' + id);
    if (!el) return true;
    var v = el.value.trim();
    if (!rx.test(v)) {
      el.classList.remove('is-valid'); el.classList.add('is-invalid');
      if (err) { err.textContent = msg; err.classList.add('show'); }
      el.style.animation = 'errShake .35s ease';
      setTimeout(function(){ el.style.animation = ''; }, 400);
      return false;
    }
    el.classList.remove('is-invalid'); el.classList.add('is-valid');
    if (err) err.classList.remove('show');
    return true;
  }

  function chkRadio(name, errId) {
    var checked = document.querySelector('input[name="' + name + '"]:checked');
    var err = document.getElementById(errId);
    if (!checked) { if (err) err.classList.add('show'); return false; }
    if (err) err.classList.remove('show'); return true;
  }

  function chkConfirm() {
    var p1  = document.getElementById('password').value;
    var p2  = document.getElementById('confirm_password');
    var err = document.getElementById('err-confirm_password');
    if (p1 !== p2.value || p2.value.length < 8) {
      p2.classList.add('is-invalid'); p2.classList.remove('is-valid');
      if (err) err.classList.add('show'); return false;
    }
    p2.classList.remove('is-invalid'); p2.classList.add('is-valid');
    if (err) err.classList.remove('show'); return true;
  }

  /* ═══════════════════════════════════════
     FULL FORM VALIDATION (final submit)
  ═══════════════════════════════════════ */
  function Validate_Data(submit) {
    var ok = true;
    for (var i = 0; i < 3; i++) ok = validateStep(i) && ok;
    var img    = document.getElementById('Image');
    var imgErr = document.getElementById('err-image');
    if (!img.files || img.files.length === 0) {
      if (imgErr) imgErr.classList.add('show'); ok = false;
    } else {
      if (imgErr) imgErr.classList.remove('show');
    }
    if (ok && submit) {
      var btn = document.getElementById('submitBtn');
      btn.classList.add('loading'); btn.disabled = true;
    }
    return ok;
  }

  /* ═══════════════════════════════════════
     REAL-TIME FIELD VALIDATION
  ═══════════════════════════════════════ */
  var rules = {
    student_name:     /\S{2}/,
    college_name:     /\S{2}/,
    department:       /\S{2}/,
    degree:           /\S{2}/,
    register_id:      /\S{3}/,
    mail_id:          /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    password:         /^.{8,}$/,
    ph_no:            /^\d{10}$/,
    age:              /^(1[5-9]|[2-5]\d|60)$/,
    address:          /\S{3}/
  };
  Object.keys(rules).forEach(function(id) {
    var el = document.getElementById(id);
    if (!el) return;
    el.addEventListener('input', function() {
      var err = document.getElementById('err-' + id);
      if (rules[id].test(this.value.trim())) {
        this.classList.remove('is-invalid'); this.classList.add('is-valid');
        if (err) err.classList.remove('show');
      } else {
        this.classList.remove('is-valid');
        if (this.value.length > 0) this.classList.add('is-invalid');
      }
    });
  });

  document.getElementById('confirm_password').addEventListener('input', function() {
    var p1 = document.getElementById('password').value;
    if (this.value === p1 && p1.length >= 8) {
      this.classList.remove('is-invalid'); this.classList.add('is-valid');
      document.getElementById('err-confirm_password').classList.remove('show');
    } else {
      this.classList.remove('is-valid');
      if (this.value.length > 0) this.classList.add('is-invalid');
    }
  });

  /* ═══════════════════════════════════════
     PASSWORD STRENGTH
  ═══════════════════════════════════════ */
  document.getElementById('password').addEventListener('input', function() {
    var v = this.value, s = 0;
    if (v.length >= 8)          s++;
    if (/[A-Z]/.test(v))        s++;
    if (/[0-9]/.test(v))        s++;
    if (/[^A-Za-z0-9]/.test(v)) s++;
    var bar = document.getElementById('strengthBar');
    var lbl = document.getElementById('strengthLabel');
    var w = ['0%','30%','55%','78%','100%'];
    var c = ['','#ef4444','#f97316','#fbbf24','#22c55e'];
    var l = ['','Weak — add uppercase & numbers','Fair — add a symbol','Good — almost there','Strong password ✓'];
    bar.style.width = w[s]; bar.style.background = c[s];
    lbl.textContent = l[s]; lbl.style.color = c[s];
  });

  /* ═══════════════════════════════════════
     TOGGLE PASSWORD VISIBILITY
  ═══════════════════════════════════════ */
  document.getElementById('togglePass').addEventListener('click', function() {
    var inp  = document.getElementById('password');
    var icon = document.getElementById('eyeIcon');
    inp.type = inp.type === 'password' ? 'text' : 'password';
    icon.className = inp.type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
  });

  /* ═══════════════════════════════════════
     FILE UPLOAD PREVIEW
  ═══════════════════════════════════════ */
  function previewFile(input) {
    var err = document.getElementById('err-image');
    if (!input.files || !input.files[0]) return;
    var file = input.files[0];
    if (file.size > 50 * 1024 * 1024) {
      err.textContent = 'File too large. Maximum size is 5 MB.';
      err.classList.add('show'); input.value = ''; return;
    }
    err.classList.remove('show');
    var reader = new FileReader();
    reader.onload = function(e) {
      document.getElementById('previewImg').src  = e.target.result;
      document.getElementById('previewName').textContent = file.name;
      document.getElementById('previewSize').textContent = (file.size / 1024).toFixed(1) + ' KB';
      document.getElementById('filePreview').classList.add('show');
    };
    reader.readAsDataURL(file);
  }

  /* drag & drop */
  var dz = document.getElementById('dropZone');
  ['dragover','dragenter'].forEach(function(ev) {
    dz.addEventListener(ev, function(e) { e.preventDefault(); dz.classList.add('drag-over'); });
  });
  ['dragleave','drop'].forEach(function(ev) {
    dz.addEventListener(ev, function(e) { e.preventDefault(); dz.classList.remove('drag-over'); });
  });

  /* ═══════════════════════════════════════
     SUMMARY BUILD (step 4 review panel)
  ═══════════════════════════════════════ */
  function buildSummary() {
    var fields = [
      { l:'Name',       id:'student_name' },
      { l:'Age',        id:'age' },
      { l:'Phone',      id:'ph_no' },
      { l:'Email',      id:'mail_id' },
      { l:'College',    id:'college_name' },
      { l:'Department', id:'department' },
      { l:'Degree',     id:'degree' },
      { l:'Reg. ID',    id:'register_id' },
    ];
    var grid = document.getElementById('summaryGrid');
    var html = '';
    fields.forEach(function(f) {
      var el  = document.getElementById(f.id);
      var val = el ? (el.value || '—') : '—';
      html += '<div>'
            + '<span style="color:var(--stone);font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;">' + f.l + '</span><br>'
            + '<span style="color:var(--charcoal);font-weight:600;font-size:.85rem;">' + val + '</span>'
            + '</div>';
    });
    /* Gender (radio) */
    var genderEl = document.querySelector('input[name="gender"]:checked');
    html += '<div>'
          + '<span style="color:var(--stone);font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;">Gender</span><br>'
          + '<span style="color:var(--charcoal);font-weight:600;font-size:.85rem;">' + (genderEl ? genderEl.value : '—') + '</span>'
          + '</div>';
    grid.innerHTML = html;
  }

  /* ═══════════════════════════════════════
     INJECT KEYFRAMES
  ═══════════════════════════════════════ */
  var _ks = document.createElement('style');
  _ks.textContent = '@keyframes errShake{0%,100%{transform:translateX(0)}20%{transform:translateX(-5px)}40%{transform:translateX(5px)}60%{transform:translateX(-4px)}80%{transform:translateX(4px)}}';
  document.head.appendChild(_ks);

  /* init */
  updateUI(0);
</script>
</body>
</html>
