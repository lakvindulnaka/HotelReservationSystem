<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hotels — Hotel Management System</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="hotels"/>
  <%@ include file="nav.jsp" %>

  <main class="main-content">
    <section class="hero-panel compact-hero">
      <div>
        <p class="hero-kicker">${sessionScope.authUser.admin ? 'Hotel Management' : 'Hotel Selection'}</p>
        <h1>Our Hotel Properties</h1>
        <p>Manage your hotel portfolio — add, edit or remove properties.</p>
      </div>
      <c:if test="${sessionScope.authUser.admin}">
        <a href="${pageContext.request.contextPath}/hotels?action=add" class="btn btn-primary">+ Add Hotel</a>
      </c:if>
    </section>

    <section class="page module-layout fade-in">

      <%-- ── Alert messages ──────────────────────────────────────────────── --%>
      <c:if test="${param.msg == 'added'}"><div class="alert alert-success">Hotel added successfully.</div></c:if>
      <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Hotel updated successfully.</div></c:if>
      <c:if test="${param.msg == 'deleted'}"><div class="alert alert-danger">Hotel record deleted.</div></c:if>

      <%-- ── Admin form (create / edit) ──────────────────────────────────── --%>
      <c:if test="${sessionScope.authUser.admin}">
      <div class="card module-form-card">
        <div class="card-header">
          <div>
            <div class="card-title">${mode == 'edit' ? 'Edit Hotel' : 'Add New Hotel'}</div>
            <div class="card-subtitle">Hotel ID is assigned automatically.</div>
          </div>
        </div>
        <form action="${pageContext.request.contextPath}/hotels" method="post" class="form-grid">
          <input type="hidden" name="id" value="${form.id}">
          <div class="form-group">
            <label for="hotelName">Hotel Name</label>
            <input type="text" id="hotelName" name="hotelName" value="${fn:escapeXml(form.hotelName)}" placeholder="e.g. Cinnamon Grand Colombo" required>
          </div>
          <div class="form-group">
            <label for="location">Location</label>
            <input type="text" id="location" name="location" value="${fn:escapeXml(form.location)}" placeholder="City, Sri Lanka" required>
          </div>
          <div class="form-group">
            <label for="contactNumber">Contact Number</label>
            <input type="tel" id="contactNumber" name="contactNumber" value="${fn:escapeXml(form.contactNumber)}" placeholder="+94 11 XXX XXXX" required>
          </div>
          <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="${fn:escapeXml(form.email)}" placeholder="reservations@hotel.com" required>
          </div>
          <div class="form-group full">
            <label for="image">Hotel Image URL
              <span style="font-weight:400;color:var(--muted);font-size:11px">(Unsplash or official photo)</span>
            </label>
            <input type="url" id="image" name="image" value="${fn:escapeXml(form.image)}" placeholder="https://images.unsplash.com/...">
          </div>
          <div class="form-group full">
            <label for="description">Description</label>
            <textarea id="description" name="description" placeholder="Describe the hotel…"><c:out value="${form.description}"/></textarea>
          </div>
          <div class="form-group full">
            <label for="facilities">Facilities <span style="font-weight:400;color:var(--muted);font-size:11px">(comma-separated)</span></label>
            <textarea id="facilities" name="facilities" placeholder="Pool, restaurant, Wi-Fi, spa…"><c:out value="${form.facilities}"/></textarea>
          </div>
          <div class="form-actions">
            <a href="${pageContext.request.contextPath}/hotels" class="btn btn-outline">Clear</a>
            <button type="submit" class="btn btn-primary">${mode == 'edit' ? 'Save Changes' : 'Add Hotel'}</button>
          </div>
        </form>
      </div>
      </c:if>

      <%-- ── Hotel cards grid ──────────────────────────────────────────────── --%>
      <div>
        <div class="section-heading">
          <div>
            <h2>Hotel Properties</h2>
            <p>Click <strong>View Rooms</strong> on any hotel to browse its available rooms.</p>
          </div>
        </div>

        <div class="hotel-cards-grid">
          <c:choose>
            <c:when test="${empty hotels}">
              <div class="empty-state">
                <span class="empty-state-icon">🏨</span>
                <span class="empty-state-title">No Hotels Added Yet</span>
                <span class="empty-state-desc">Use the form above to add your first hotel property.</span>
              </div>
            </c:when>
            <c:otherwise>
              <c:forEach var="h" items="${hotels}">
                <article class="hotel-card">
                  <%-- Hotel image --%>
                  <div class="hotel-card-img"
                       style="<c:if test='${not empty h.image}'>background-image:url(<c:out value='${h.image}'/>)</c:if>">
                    <div class="hotel-card-img-overlay"></div>
                    <div class="hotel-card-location-badge">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                      <c:out value="${h.location}"/>
                    </div>
                  </div>
                  <%-- Hotel body --%>
                  <div class="hotel-card-body">
                    <h3 class="hotel-card-name"><c:out value="${h.hotelName}"/></h3>
                    <p class="hotel-card-desc"><c:out value="${h.description}"/></p>
                    <%-- Facility pills --%>
                    <c:if test="${not empty h.facilities}">
                      <div class="hotel-facility-pills">
                        <c:forTokens var="fac" items="${h.facilities}" delims=",">
                          <span class="facility-pill"><c:out value="${fac}"/></span>
                        </c:forTokens>
                      </div>
                    </c:if>
                    <%-- Actions --%>
                    <div class="hotel-card-actions">
                      <a href="${pageContext.request.contextPath}/rooms?hotelId=${h.id}" class="btn btn-primary btn-sm">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:13px;height:13px"><path d="M2 20v-3a4 4 0 0 1 4-4h12a4 4 0 0 1 4 4v3"/><path d="M4 13V9a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v4"/></svg>
                        View Rooms
                      </a>
                      <c:if test="${sessionScope.authUser.admin}">
                        <a href="${pageContext.request.contextPath}/hotels?action=edit&id=${h.id}" class="btn btn-outline btn-sm">Edit</a>
                        <a href="${pageContext.request.contextPath}/hotels?action=delete&id=${h.id}"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Delete hotel: ${h.hotelName}? This will also delete all its rooms.')">Delete</a>
                      </c:if>
                    </div>
                  </div>
                </article>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

    </section>
  </main>
</body>
</html>
