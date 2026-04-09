<%-- 
    Document   : Teacher_Approve
    Created on : 20 Sep, 2025, 5:41:28 PM
    Author     : Admin
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
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,500&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
 <link rel="stylesheet" href="assets/css/admin.css"/>
</head>

<body>
    <style>
       
/* --- General Container --- */
.carousel-container {
    max-width: 1200px;
    margin: 20px auto;
    padding: 0 15px;
}

.header-title {
    text-align: center;
    color: #F2A92C;
    font-size: 28px;
    margin-bottom: 30px;
}

/* --- Cards Layout --- */
.container1 {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 20px;
}

.card1 {
    background-color: #fff;
    width: 280px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    overflow: hidden;
    transition: transform 0.3s, box-shadow 0.3s;
}

.card1:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15);
}

/* --- Card Image --- */
.card1-image {
    text-align: center;
    background-color: #f9f9f9;
    padding: 15px 0;
}

.card1-image img {
    border-radius: 50%;
    border: 2px solid #F2A92C;
    width: 100px;
    height: 100px;
    object-fit: cover;
}

/* --- Card Content --- */
.card1-content {
    padding: 15px;
    text-align: left;
}

.card-text {
    font-size: 14px;
    line-height: 1.6;
    color: #333;
}

/* --- Card Actions --- */
.card-actions {
    display: flex;
    justify-content: space-between;
    margin-top: 15px;
}

.card-actions .btn {
    padding: 8px 15px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 600;
    text-decoration: none;
    transition: 0.3s;
    color: #fff;
}

.approved-btn {
    background-color: #28a745;
}

.approved-btn:hover {
    background-color: #218838;
}

.rejected-btn {
    background-color: #dc3545;
}

.rejected-btn:hover {
    background-color: #c82333;
}

/* --- Responsive --- */
@media (max-width: 768px) {
    .card1 {
        width: 90%;
    }
}
    </style>
	<!--====== PRELOADER ======-->
	<div class="preloader">
		<div class="loader">
			<div class="ytp-spinner">
				<div class="ytp-spinner-container">
					<div class="ytp-spinner-rotator">
						<div class="ytp-spinner-left"><div class="ytp-spinner-circle"></div></div>
						<div class="ytp-spinner-right"><div class="ytp-spinner-circle"></div></div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!--====== HEADER ======-->
	<header class="sk-admin-nav" id="adminNav">
  <div class="nav-inner">
    <a class="sk-brand" href="Admin_Home.jsp">
      Skill<span>Sync</span>
      <span class="admin-badge">Admin</span>
    </a>

    <!-- Desktop Links -->
    <ul class="sk-nav-list" id="desktopNav">
      <li class="sk-nav-item active">
        <a href="Admin_Home.jsp"><i class="bi bi-house"></i> Home</a>
      </li>

      <!-- Approval Dropdown -->
      <li class="sk-dd" id="ddApproval">
        <button class="sk-dd-btn" onclick="toggleDD('ddApproval')">
          <i class="bi bi-patch-check"></i> Approval
          <i class="bi bi-chevron-down dd-caret"></i>
        </button>
        <ul class="sk-dd-menu">
          <li><a href="Student_Approve.jsp"><span class="mi"><i class="bi bi-person-check"></i></span> Student Approval</a></li>
          <li><a href="Teacher_Approve.jsp"><span class="mi"><i class="bi bi-person-workspace"></i></span> Teacher Approval</a></li>
          <div class="dd-divider"></div>
          <li><a href="Admin_Course.jsp"><span class="mi"><i class="bi bi-journal-check"></i></span> Course Approval</a></li>
        </ul>
      </li>

      <!-- View Dropdown -->
      <li class="sk-dd" id="ddView">
        <button class="sk-dd-btn" onclick="toggleDD('ddView')">
          <i class="bi bi-bar-chart"></i> View
          <i class="bi bi-chevron-down dd-caret"></i>
        </button>
        <ul class="sk-dd-menu">
          <li><a href="Course_Status.jsp"><span class="mi"><i class="bi bi-graph-up"></i></span> Student Course Status</a></li>
          <li><a href="Teacher_Detail.jsp"><span class="mi"><i class="bi bi-people"></i></span> Teacher Course Detail</a></li>
        </ul>
      </li>
    </ul>

    <!-- Right side -->
    <div class="d-flex align-items-center gap-3">
      <div class="admin-chip">
        <div class="admin-avatar">A</div>
        <span class="admin-chip-label">Administrator</span>
      </div>
      <a href="index.jsp" class="btn-logout">
        <i class="bi bi-box-arrow-right"></i> Logout
      </a>
      <button class="sk-ham" id="skHam" onclick="toggleDrawer()">
        <span></span><span></span><span></span>
      </button>
    </div>
  </div>
</header>

	<!--====== HERO ======-->
	<section id="home" class="hero">
  <div class="hero-geo-1"></div>
  <div class="hero-geo-2"></div>
  <div class="hero-grid"></div>
  <div class="hero-ring"></div>
  <div class="hero-ring-2"></div>

  <!-- Floating particles -->
  <div class="particle" style="width:6px;height:6px;background:var(--gold-light);bottom:15%;left:12%;animation-duration:8s;animation-delay:0s;"></div>
  <div class="particle" style="width:4px;height:4px;background:var(--teal);bottom:30%;left:22%;animation-duration:11s;animation-delay:2s;"></div>
  <div class="particle" style="width:5px;height:5px;background:var(--gold);bottom:10%;left:70%;animation-duration:9s;animation-delay:1s;"></div>
  <div class="particle" style="width:3px;height:3px;background:#fff;bottom:40%;left:80%;animation-duration:13s;animation-delay:3s;"></div>

  <div class="hero-inner">
    <div class="row align-items-center g-5">
      <div class="col-lg-7">
        <div class="hero-eyebrow"><i class="bi bi-shield-check me-1"></i> Admin Control Panel</div>
        <h1>Welcome to<br><em>SkillSync</em><br>Administration</h1>
        <p class="hero-desc">
          Manage students, teachers, and courses from one powerful dashboard.
          Approve registrations, track progress, and keep the platform running smoothly.
        </p>
        <div class="hero-actions">
          <a href="#approvals" class="btn-hero">
            <i class="bi bi-patch-check"></i> Manage Approvals
          </a>
          <a href="#courses" class="btn-hero-outline">
            <i class="bi bi-grid"></i> View Courses
          </a>
        </div>

        <!-- Quick actions grid -->
        
      </div>

      <!-- Right decorative column (visible on large screens) -->
      <div class="col-lg-5 d-none d-lg-block">
        <div style="position:relative;">
          <!-- Floating dashboard preview cards -->
          <div style="background:rgba(255,255,255,.07);border:1px solid rgba(255,255,255,.12);border-radius:20px;padding:24px;margin-bottom:16px;animation:fadeUp .7s .5s ease both;">
            <div style="display:flex;align-items:center;gap:14px;margin-bottom:16px;">
              <div style="width:40px;height:40px;border-radius:12px;background:rgba(217,119,6,.20);display:flex;align-items:center;justify-content:center;color:var(--gold-light);font-size:1.1rem;"><i class="bi bi-graph-up-arrow"></i></div>
              <div>
                <div style="font-size:.78rem;font-weight:700;color:rgba(255,255,255,.50);text-transform:uppercase;letter-spacing:.06em;">Platform Growth</div>
                <div style="font-family:var(--font-display);font-size:1.4rem;font-weight:700;color:#fff;line-height:1.1;">+24% <span style="font-size:.85rem;color:#86efac;font-family:var(--font-body);">↑ this month</span></div>
              </div>
            </div>
            <div style="height:6px;background:rgba(255,255,255,.08);border-radius:99px;overflow:hidden;">
              <div style="height:100%;width:72%;background:linear-gradient(90deg,var(--gold),var(--gold-light));border-radius:99px;transition:width 1.5s ease;" class="anim-bar" data-w="72%"></div>
            </div>
          </div>
          <div style="background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.10);border-radius:20px;padding:20px;animation:fadeUp .7s .6s ease both;">
            <div style="font-size:.75rem;font-weight:700;color:rgba(255,255,255,.45);text-transform:uppercase;letter-spacing:.07em;margin-bottom:14px;">Pending Actions</div>
            <div style="display:flex;flex-direction:column;gap:10px;">
              <div style="display:flex;align-items:center;justify-content:space-between;">
                <span style="font-size:.87rem;font-weight:600;color:rgba(255,255,255,.75);display:flex;align-items:center;gap:8px;"><i class="bi bi-person-plus" style="color:var(--gold-light);"></i> New Students</span>
                <span style="background:rgba(217,119,6,.22);color:var(--gold-light);font-size:.75rem;font-weight:800;padding:2px 10px;border-radius:100px;">12</span>
              </div>
              <div style="display:flex;align-items:center;justify-content:space-between;">
                <span style="font-size:.87rem;font-weight:600;color:rgba(255,255,255,.75);display:flex;align-items:center;gap:8px;"><i class="bi bi-book" style="color:#93c5fd;"></i> Courses Pending</span>
                <span style="background:rgba(59,130,246,.20);color:#93c5fd;font-size:.75rem;font-weight:800;padding:2px 10px;border-radius:100px;">4</span>
              </div>
              <div style="display:flex;align-items:center;justify-content:space-between;">
                <span style="font-size:.87rem;font-weight:600;color:rgba(255,255,255,.75);display:flex;align-items:center;gap:8px;"><i class="bi bi-person-workspace" style="color:#86efac;"></i> New Teachers</span>
                <span style="background:rgba(34,197,94,.18);color:#86efac;font-size:.75rem;font-weight:800;padding:2px 10px;border-radius:100px;">3</span>
              </div>
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
            <div class="carousel-container">
                 
    
      <h2 class="header-title">Professor Approval List</h2>
       <div class="container1">
     
    <div class="row justify-content-center">
        <%
            DbConnection db1 = new DbConnection();
            String query = "select * from teacher_register where Admin_Approve='NOT APPROVED'";
            ResultSet rs = db1.Select(query);
            while (rs.next()) {
                String U_Id=rs.getString("teacher_id");
        %>
         <div class="card1">
    <div class="card1-image">
        <img src="teacher_img.jsp?name=<%=rs.getInt("teacher_id")%>" class="card-img" style="width:100px;height: 100px;" alt="Profile Picture">
    </div>
      <div class="card1-content">
        <p class="card-text">
            <strong>Teacher Name:</strong> <%= rs.getString("teacher_name") %><br>
            <strong>Email ID:</strong> <%= rs.getString("teacher_mail") %><br>
            <strong>College Name:</strong> <%= rs.getString("college_name") %><br>
            <strong>Department:</strong> <%= rs.getString("department") %><br>
            <strong>Degree:</strong> <%= rs.getString("degree") %><br>
            <strong>Address:</strong> <%= rs.getString("address") %><br>                                       
        </p>
        <div class="card-actions">
    <a href="Request3.jsp?teacher_id=<%=rs.getString("teacher_id")%>" class="btn approved-btn">Approve</a> 
   
    <a href="Request4.jsp?teacher_id=<%=rs.getString("teacher_id")%>" class="btn rejected-btn">Reject</a>
</div>

    </div>
</div>

                
                
        <br>
        <%
            }
        %>
    </div>
</div>
    </div>
   
	<!--====== FOOTER ======-->
	<footer id="footer">
  <div class="container-xl">
    <div class="row g-5">
      <div class="col-lg-4 col-md-6">
        <span class="footer-brand">SkillSync</span>
        <p class="footer-desc">A platform where students and teachers collaborate for better learning outcomes. Managed with precision by the admin panel.</p>
      </div>
      <div class="col-lg-2 col-md-3 col-6">
        <div class="f-col-title">Quick Links</div>
        <div class="f-links">
          <a href="Admin_Home.jsp">Home</a>
          <a href="Student_Approve.jsp">Student Approval</a>
          <a href="Teacher_Approve.jsp">Teacher Approval</a>
          <a href="Admin_Course.jsp">Course Approval</a>
        </div>
      </div>
      <div class="col-lg-2 col-md-3 col-6">
        <div class="f-col-title">View</div>
        <div class="f-links">
          <a href="Course_Status.jsp">Course Status</a>
          <a href="Teacher_Detail.jsp">Teacher Detail</a>
          <a href="index.jsp">Logout</a>
        </div>
      </div>
      <div class="col-lg-3 col-md-6">
        <div class="f-col-title">Contact</div>
        <div class="f-links">
          <p><i class="bi bi-telephone me-2" style="color:var(--gold-light)"></i>+91-9876543210</p>
          <p><i class="bi bi-envelope me-2"  style="color:var(--gold-light)"></i>support@skillsync.com</p>
          <p><i class="bi bi-geo-alt me-2"   style="color:var(--gold-light)"></i>Learning Hub, Chennai, India</p>
        </div>
      </div>
    </div>
  </div>
</footer>

	<div class="back-top" id="backTop" onclick="window.scrollTo({top:0,behavior:'smooth'})">
  <i class="bi bi-arrow-up"></i>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

	<script>
  /* ── Navbar scroll ── */
  var nav    = document.getElementById('adminNav');
  var backTop = document.getElementById('backTop');
  window.addEventListener('scroll', function() {
    nav.classList.toggle('scrolled', window.scrollY > 20);
    backTop.classList.toggle('show', window.scrollY > 320);
  }, { passive: true });

  /* ── Dropdown ── */
  function toggleDD(id) {
    var target = document.getElementById(id);
    var wasOpen = target.classList.contains('open');
    document.querySelectorAll('.sk-dd').forEach(function(d) { d.classList.remove('open'); });
    if (!wasOpen) target.classList.add('open');
  }
  document.addEventListener('click', function(e) {
    if (!e.target.closest('.sk-dd')) {
      document.querySelectorAll('.sk-dd').forEach(function(d) { d.classList.remove('open'); });
    }
  });
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      document.querySelectorAll('.sk-dd').forEach(function(d) { d.classList.remove('open'); });
      closeDrawer();
    }
  });

  /* ── Mobile drawer ── */
  function toggleDrawer() {
    var drawer = document.getElementById('skDrawer');
    var ham    = document.getElementById('skHam');
    var open   = drawer.classList.toggle('open');
    ham.classList.toggle('open', open);
    document.body.style.overflow = open ? 'hidden' : '';
  }
  function closeDrawer() {
    document.getElementById('skDrawer').classList.remove('open');
    document.getElementById('skHam').classList.remove('open');
    document.body.style.overflow = '';
  }

  /* ── Scroll reveal ── */
  var io = new IntersectionObserver(function(entries) {
    entries.forEach(function(e, i) {
      if (e.isIntersecting) {
        e.target.style.transitionDelay = (i * 0.09) + 's';
        e.target.classList.add('visible');
        io.unobserve(e.target);
      }
    });
  }, { threshold: 0.10 });
  document.querySelectorAll('.fade-up').forEach(function(el) { io.observe(el); });

  /* ── Animate progress bars when visible ── */
  var barObs = new IntersectionObserver(function(entries) {
    entries.forEach(function(e) {
      if (e.isIntersecting) {
        e.target.querySelectorAll('.anim-bar').forEach(function(bar) {
          var w = bar.getAttribute('data-w');
          setTimeout(function() { bar.style.width = w; }, 300);
        });
        barObs.unobserve(e.target);
      }
    });
  }, { threshold: 0.2 });
  document.querySelectorAll('.anim-bar').forEach(function(bar) {
    bar.style.width = '0';
    barObs.observe(bar.closest('[style]') || bar.parentNode);
  });

  /* ── Active nav highlight ── */
  var page = window.location.pathname.split('/').pop() || 'Admin_Home.jsp';
  document.querySelectorAll('.sk-nav-item').forEach(function(li) {
    var link = li.querySelector('a');
    if (link && link.getAttribute('href') === page) {
      li.classList.add('active');
    }
  });

  /* ── Smooth scroll ── */
  document.querySelectorAll('a[href^="#"]').forEach(function(a) {
    a.addEventListener('click', function(e) {
      var t = document.querySelector(a.getAttribute('href'));
      if (t) { e.preventDefault(); t.scrollIntoView({ behavior: 'smooth' }); closeDrawer(); }
    });
  });
</script>


</body>
</html>
