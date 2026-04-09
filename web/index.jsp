<%-- 
    Document   : index
    Created on : 22-Sep-2025, 18:10:01
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

  <link rel="stylesheet" href="assets/css/newstyle.css"/>
  <style>
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
      margin-left: 80px;
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
  </style>
</head>
<body>

<!-- PRELOADER -->
<div id="preloader">
  <div class="pre-logo">SkillSync</div>
  <div class="pre-dots"><span></span><span></span><span></span></div>
</div>

<!-- HERO -->
<section id="home" class="hero" style="padding: 0;">
    
  <div class="hero-bg-panel"></div>
  <div class="hero-ring"></div>
  <div class="hero-dots"></div>

  <div class="container-xl px-4 position-relative" style="z-index:1;">
    <div class="row align-items-center g-5">
        <a class="sk-brand" href="index.jsp" style="display:flex; align-items:center; gap:8px;">
  <img src="assets/images/logo.png" style="width:25px; height:100%;">
  REC
</a>
      <!-- Text -->
      <div class="col-lg-6">
        <div class="hero-eyebrow">🎓 Online Learning Platform</div>
        <h1>Welcome to<br><em>Student</em> Learning<br>Management</h1>
        <p class="hero-desc">
          An online platform where students and teachers connect, collaborate, and grow.
          Enroll in courses, attempt quizzes, and track your progress — all in one place.
        </p>
        
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
  <div class="modal-box">

    <div class="modal-head">
      <div>
        <h3>Welcome Back</h3>
        <p>Select your role and sign in to continue</p>
      </div>
      
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
        <p class="register-note">No account? <a href="Student_Register.jsp">Create a New Account</a></p>
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

    </div>
  </div>
</section>


 <% String msg = (String) session.getAttribute("msg");
            if (msg != null) {
        %>
        <script> alert("<%=msg%>");</script>
        <% }
        session.removeAttribute("msg");%> 
<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
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