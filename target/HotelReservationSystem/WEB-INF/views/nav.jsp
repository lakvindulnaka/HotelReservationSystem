<%-- Shared top navigation partial --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="site-header">
  <div class="site-header-inner">
    <a class="brand" href="${pageContext.request.contextPath}/dashboard" aria-label="HotelManage dashboard">
      <span class="brand-mark">HM</span>
      <span class="brand-name">HotelManage</span>
    </a>

    <%-- Mobile hamburger button --%>
    <button class="nav-toggle" id="navToggle" aria-label="Toggle navigation" aria-expanded="false">
      <span></span><span></span><span></span>
    </button>

    <nav class="primary-nav" id="primaryNav" aria-label="Main navigation">
      <a href="${pageContext.request.contextPath}/dashboard"
         class="nav-item ${currentPage == 'dashboard' ? 'active' : ''}">
        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/></svg>
        Dashboard
      </a>

      <a href="${pageContext.request.contextPath}/rooms"
         class="nav-item ${currentPage == 'rooms' ? 'active' : ''}">
        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 21h18M3 21V7l9-4 9 4v14M9 21V12h6v9"/></svg>
        Hotels
      </a>
      <c:if test="${sessionScope.authUser.admin}">
      <a href="${pageContext.request.contextPath}/reservations"
         class="nav-item ${currentPage == 'reservations' ? 'active' : ''}">
        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
        Reservations
      </a>
      <a href="${pageContext.request.contextPath}/payments"
         class="nav-item ${currentPage == 'payments' ? 'active' : ''}">
        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg>
        Payments
      </a>
      </c:if>
      <a href="${pageContext.request.contextPath}/feedback"
         class="nav-item ${currentPage == 'feedback' ? 'active' : ''}">
        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/><path d="M8 10h.01M12 10h.01M16 10h.01"/></svg>
        Feedback
      </a>
    </nav>

    <div class="header-actions">
      <div class="user-dropdown" id="userDropdown">
        <button class="user-trigger" id="userTrigger" aria-haspopup="true" aria-expanded="false">
          <span class="user-avatar">
            <c:choose>
              <c:when test="${sessionScope.authUser.admin}">A</c:when>
              <c:otherwise>U</c:otherwise>
            </c:choose>
          </span>
          <span class="user-info">
            <span class="user-name"><c:out value="${sessionScope.authUser.name}"/></span>
            <span class="user-role">${sessionScope.authUser.role}</span>
          </span>
          <svg class="chevron-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>
        </button>
        <div class="dropdown-menu" id="dropdownMenu" role="menu">
          <div class="dropdown-header">
            <span class="dropdown-name"><c:out value="${sessionScope.authUser.name}"/></span>
            <span class="dropdown-email">${sessionScope.authUser.role} Account</span>
          </div>
          <div class="dropdown-divider"></div>
          <a href="${pageContext.request.contextPath}/logout" class="dropdown-item dropdown-item-danger" role="menuitem">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            Sign Out
          </a>
        </div>
      </div>
    </div>
  </div>
</header>

<%-- Toast notification container --%>
<div class="toast-container" id="toastContainer" aria-live="polite"></div>

<script>
(function () {
  // ── User dropdown ──────────────────────────────────────────────────────
  var trigger = document.getElementById('userTrigger');
  var menu    = document.getElementById('dropdownMenu');
  var dropdown = document.getElementById('userDropdown');

  if (trigger && menu) {
    trigger.addEventListener('click', function (e) {
      e.stopPropagation();
      var open = menu.classList.toggle('open');
      trigger.setAttribute('aria-expanded', open);
    });

    document.addEventListener('click', function () {
      menu.classList.remove('open');
      trigger.setAttribute('aria-expanded', 'false');
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') {
        menu.classList.remove('open');
        trigger.setAttribute('aria-expanded', 'false');
      }
    });
  }

  // ── Mobile nav toggle ──────────────────────────────────────────────────
  var navBtn = document.getElementById('navToggle');
  var navEl  = document.getElementById('primaryNav');

  if (navBtn && navEl) {
    navBtn.addEventListener('click', function () {
      var open = navEl.classList.toggle('nav-open');
      navBtn.classList.toggle('nav-toggle-open', open);
      navBtn.setAttribute('aria-expanded', open);
    });
  }

  // ── Toast helper (global) ──────────────────────────────────────────────
  window.showToast = function (message, type) {
    type = type || 'info';
    var container = document.getElementById('toastContainer');
    if (!container) return;

    var toast = document.createElement('div');
    toast.className = 'toast toast-' + type;

    var icons = {
      success: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>',
      error:   '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>',
      info:    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="8"/><path d="M12 12v4"/></svg>'
    };

    toast.innerHTML =
      '<span class="toast-icon">' + (icons[type] || icons.info) + '</span>' +
      '<span class="toast-msg">' + message + '</span>' +
      '<button class="toast-close" aria-label="Dismiss">&times;</button>';

    toast.querySelector('.toast-close').addEventListener('click', function () {
      dismissToast(toast);
    });

    container.appendChild(toast);
    requestAnimationFrame(function () { toast.classList.add('toast-show'); });

    setTimeout(function () { dismissToast(toast); }, 4500);
  };

  function dismissToast(toast) {
    toast.classList.remove('toast-show');
    toast.addEventListener('transitionend', function () {
      if (toast.parentNode) toast.parentNode.removeChild(toast);
    }, { once: true });
  }
}());
</script>
