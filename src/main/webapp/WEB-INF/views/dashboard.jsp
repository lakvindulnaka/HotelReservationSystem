<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Hotel Management System dashboard — overview of reservations, rooms, payments, and guest feedback.">
  <title>Dashboard — Hotel Management System</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="dashboard"/>
  <%@ include file="nav.jsp" %>

  <main class="main-content">
    <section class="hero-panel">
      <div>
        <p class="hero-kicker">${isAdmin ? 'Administration' : 'Guest Portal'}</p>
        <h1>
          <c:choose>
            <c:when test="${isAdmin}">Hotel Management System</c:when>
            <c:otherwise>Welcome, <c:out value="${sessionScope.authUser.name}"/></c:otherwise>
          </c:choose>
        </h1>
        <p>${isAdmin ? 'Oversee hotels, rooms, reservations, payments, and customer feedback from one place.' : 'Choose a hotel below to browse rooms and make a reservation.'}</p>
      </div>
      <div class="hero-actions">
        <c:choose>
          <c:when test="${isAdmin}">
            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-light">View Rooms</a>
            <a href="${pageContext.request.contextPath}/reservations?action=add" class="btn btn-primary">New Reservation</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-light">Browse Hotels</a>
            <a href="${pageContext.request.contextPath}/feedback?action=add" class="btn btn-primary">Leave a Review</a>
          </c:otherwise>
        </c:choose>
      </div>
    </section>

    <section class="page fade-in">
      <c:if test="${not empty dbError}">
        <div class="alert alert-danger">Database error: <c:out value="${dbError}"/></div>
      </c:if>
      <c:if test="${not empty successMsg}">
        <div class="alert alert-success"><c:out value="${successMsg}"/></div>
      </c:if>

      <c:choose>
        <c:when test="${isAdmin}">

          <%-- ── Admin stat cards ─────────────────────────────────────────── --%>
          <div class="stats-grid">
            <div class="stat-card" style="--card-accent:#006ce4">
              <div class="stat-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
              </div>
              <div class="stat-icon">Users</div>
              <div class="stat-value">${userCount}</div>
              <div class="stat-label">Registered accounts</div>
            </div>

            <div class="stat-card" style="--card-accent:#008234">
              <div class="stat-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 21h18M3 21V7l9-4 9 4v14M9 21V12h6v9"/></svg>
              </div>
              <div class="stat-icon">Hotels</div>
              <div class="stat-value">${hotelCount}</div>
              <div class="stat-label">Hotel properties</div>
            </div>

            <div class="stat-card" style="--card-accent:#f0a000">
              <div class="stat-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 20v-3a4 4 0 0 1 4-4h12a4 4 0 0 1 4 4v3"/><path d="M4 13V9a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v4"/><path d="M7 7V5a1 1 0 0 1 1-1h8a1 1 0 0 1 1 1v2"/></svg>
              </div>
              <div class="stat-icon">Rooms</div>
              <div class="stat-value">${availableRoomCount}<span style="font-size:16px;color:var(--muted);font-weight:600">/${roomCount}</span></div>
              <div class="stat-label">Available of total</div>
            </div>

            <div class="stat-card" style="--card-accent:#5b45d9">
              <div class="stat-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
              </div>
              <div class="stat-icon">Bookings</div>
              <div class="stat-value">${confirmedCount}</div>
              <div class="stat-label">Confirmed reservations</div>
            </div>

            <div class="stat-card" style="--card-accent:#00a36c">
              <div class="stat-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
              </div>
              <div class="stat-icon">Revenue</div>
              <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></div>
              <div class="stat-label">Total revenue (LKR)</div>
            </div>

            <div class="stat-card" style="--card-accent:#e8698a">
              <div class="stat-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
              </div>
              <div class="stat-icon">Rating</div>
              <div class="stat-value"><fmt:formatNumber value="${averageRating}" pattern="0.0"/></div>
              <div class="stat-label">Average guest rating</div>
            </div>
          </div>

          <%-- ── Recent Reservations table ─────────────────────────────── --%>
          <div class="section-heading">
            <div>
              <h2>Recent Reservations</h2>
              <p>Overview — Pending: ${pendingCount}&nbsp;&nbsp;·&nbsp;&nbsp;Confirmed: ${confirmedCount}&nbsp;&nbsp;·&nbsp;&nbsp;Cancelled: ${cancelledCount}</p>
            </div>
            <a href="${pageContext.request.contextPath}/reservations" class="btn btn-outline btn-sm">View All</a>
          </div>

          <div class="card">
            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Guest</th>
                    <th>Room</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Guests</th>
                    <th>Status</th>
                    <th>Total</th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${empty recentReservations}">
                      <tr>
                        <td colspan="8">
                          <div class="empty-state">
                            <span class="empty-state-icon">📋</span>
                            <span class="empty-state-title">No Reservations Yet</span>
                            <span class="empty-state-desc">Reservation records will appear here once guests make bookings.</span>
                          </div>
                        </td>
                      </tr>
                    </c:when>
                    <c:otherwise>
                      <c:forEach var="r" items="${recentReservations}" end="7">
                        <tr>
                          <td>#${r.id}</td>
                          <td><span class="guest-name">${r.userName}</span></td>
                          <td><span class="chip">${r.roomNumber} — ${r.roomType}</span></td>
                          <td>${r.checkIn}</td>
                          <td>${r.checkOut}</td>
                          <td>${r.numberOfGuests}</td>
                          <td><span class="badge badge-${r.status}">${r.status}</span></td>
                          <td class="money-cell">LKR <fmt:formatNumber value="${r.totalAmount}" pattern="#,##0.00"/></td>
                        </tr>
                      </c:forEach>
                    </c:otherwise>
                  </c:choose>
                </tbody>
              </table>
            </div>
          </div>

        </c:when>
        <c:otherwise>

          <%-- ── Forbidden access message ──────────────────────────────── --%>
          <c:if test="${not empty forbiddenError}">
            <div class="alert alert-danger" style="margin-bottom:18px;">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16" style="flex-shrink:0"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
              <c:out value="${forbiddenError}"/>
            </div>
          </c:if>

          <%-- ── Hotel cards grid ─────────────────────────────────────── --%>
          <div class="section-heading">
            <div>
              <h2>Choose a Hotel</h2>
              <p>Browse our luxury Sri Lankan properties and select a hotel to view available rooms.</p>
            </div>
            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-outline btn-sm">Browse All Hotels</a>
          </div>

          <div class="hotel-cards-grid" style="margin-bottom:32px">
            <c:choose>
              <c:when test="${empty hotels}">
                <div class="empty-state">
                  <span class="empty-state-icon">🏨</span>
                  <span class="empty-state-title">No Hotels Available</span>
                  <span class="empty-state-desc">Please check back soon.</span>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="h" items="${hotels}">
                  <article class="hotel-card">
                    <c:set var="hImg" value="${not empty h.image ? h.image : ''}"/>
                    <div class="hotel-card-img" style="${not empty hImg ? 'background-image:url('.concat(hImg).concat(')') : ''}">
                      <div class="hotel-card-img-overlay"></div>
                      <div class="hotel-card-location-badge">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                        <c:out value="${h.location}"/>
                      </div>
                    </div>
                    <div class="hotel-card-body">
                      <div style="display:flex;align-items:center;justify-content:space-between;gap:8px">
                        <h3 class="hotel-card-name"><c:out value="${h.hotelName}"/></h3>
                        <span style="color:#f0c060;font-size:13px;white-space:nowrap"><c:out value="${h.starString}"/></span>
                      </div>
                      <p class="hotel-card-desc">
                        <c:choose>
                          <c:when test="${fn:length(h.description) > 130}"><c:out value="${fn:substring(h.description,0,130)}"/>…</c:when>
                          <c:otherwise><c:out value="${h.description}"/></c:otherwise>
                        </c:choose>
                      </p>
                      <c:if test="${not empty h.facilities}">
                        <div class="hotel-facility-pills">
                          <c:forTokens var="fac" items="${h.facilities}" delims=",">
                            <span class="facility-pill">${fn:trim(fac)}</span>
                          </c:forTokens>
                        </div>
                      </c:if>
                      <div class="hotel-card-actions">
                        <div class="hotel-price">
                          <c:choose>
                            <c:when test="${not empty hotelStartingPrices[h.id]}">
                              Starting from <strong>LKR <fmt:formatNumber value="${hotelStartingPrices[h.id]}" pattern="#,##0"/></strong> / night
                            </c:when>
                            <c:otherwise>View rooms for pricing</c:otherwise>
                          </c:choose>
                        </div>
                        <a href="${pageContext.request.contextPath}/rooms?hotelId=${h.id}" class="btn btn-primary btn-sm">View Rooms</a>
                      </div>
                    </div>
                  </article>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>

          <%-- ── My Reservations ──────────────────────────────────────── --%>
          <div class="section-heading">
            <div>
              <h2>My Reservations</h2>
              <p>Your current and past booking history.</p>
            </div>
          </div>

          <div class="card">
            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Hotel</th>
                    <th>Room</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Status</th>
                    <th>Total</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${empty myReservations}">
                      <tr>
                        <td colspan="8">
                          <div class="empty-state">
                            <span class="empty-state-icon">🛏</span>
                            <span class="empty-state-title">No Reservations Yet</span>
                            <span class="empty-state-desc">Browse hotels above and select a room to make your first booking.</span>
                          </div>
                        </td>
                      </tr>
                    </c:when>
                    <c:otherwise>
                      <c:forEach var="r" items="${myReservations}">
                        <tr>
                          <td>#${r.id}</td>
                          <td><span class="chip" style="font-size:11px">${r.hotelName}</span></td>
                          <td><span class="chip">${r.roomNumber} — ${r.roomType}</span></td>
                          <td>${r.checkIn}</td>
                          <td>${r.checkOut}</td>
                          <td><span class="badge badge-${r.status}">${r.status}</span></td>
                          <td class="money-cell">LKR <fmt:formatNumber value="${r.totalAmount}" pattern="#,##0.00"/></td>
                          <td>
                            <div class="table-actions">
                              <a href="${pageContext.request.contextPath}/payments?action=add&reservationId=${r.id}" class="btn btn-outline btn-sm">Pay</a>
                              <a href="${pageContext.request.contextPath}/feedback?action=add&reservationId=${r.id}" class="btn btn-outline btn-sm">Review</a>
                            </div>
                          </td>
                        </tr>
                      </c:forEach>
                    </c:otherwise>
                  </c:choose>
                </tbody>
              </table>
            </div>
          </div>

        </c:otherwise>
      </c:choose>
    </section>
  </main>
</body>
</html>
