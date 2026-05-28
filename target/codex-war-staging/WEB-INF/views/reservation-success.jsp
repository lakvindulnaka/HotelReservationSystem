<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Booking confirmed — your room reservation is confirmed at Hotel Management System.">
  <title>Booking Confirmed — Hotel Management System</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="reservations"/>
  <%@ include file="nav.jsp" %>

  <main class="main-content">
    <section class="hero-panel compact-hero">
      <div>
        <p class="hero-kicker">Booking Confirmed</p>
        <h1>Your Reservation is Confirmed!</h1>
        <p>Thank you for choosing us. Your booking details are shown below.</p>
      </div>
    </section>

    <section class="page fade-in">
      <div class="booking-success-card">

        <%-- Success banner --%>
        <div class="success-banner">
          <div class="success-icon-wrap">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="20 6 9 17 4 12"/>
            </svg>
          </div>
          <div>
            <h2 class="success-title">Reservation #${reservation.id} Created</h2>
            <p class="success-subtitle">Status: <span class="badge badge-${reservation.status}">${reservation.status}</span></p>
          </div>
        </div>

        <%-- Hotel & Room details --%>
        <div class="success-details-grid">

          <c:if test="${not empty selectedHotel}">
            <div class="success-detail-section">
              <h3 class="success-section-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21h18M3 21V7l9-4 9 4v14M9 21V12h6v9"/></svg>
                Hotel
              </h3>
              <div class="success-hotel-row">
                <c:if test="${not empty selectedHotel.image}">
                  <div class="success-hotel-img" style="background-image:url(${selectedHotel.image})"></div>
                </c:if>
                <div>
                  <p class="success-hotel-name"><c:out value="${selectedHotel.hotelName}"/></p>
                  <p class="success-hotel-loc">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="12" height="12"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    <c:out value="${selectedHotel.location}"/>
                  </p>
                </div>
              </div>
            </div>
          </c:if>

          <c:if test="${not empty selectedRoom}">
            <div class="success-detail-section">
              <h3 class="success-section-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/></svg>
                Room
              </h3>
              <p class="success-room-type"><c:out value="${selectedRoom.roomType}"/></p>
              <p class="success-room-meta">
                <c:if test="${not empty selectedRoom.bedType}"><span>${selectedRoom.bedType}</span></c:if>
                <c:if test="${not empty selectedRoom.roomSize}"><span>${selectedRoom.roomSize}</span></c:if>
                <c:if test="${selectedRoom.capacity > 0}"><span>Up to ${selectedRoom.capacity} guests</span></c:if>
              </p>
            </div>
          </c:if>

          <div class="success-detail-section">
            <h3 class="success-section-title">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
              Stay Details
            </h3>
            <div class="success-stay-grid">
              <div class="success-stay-item">
                <span class="success-stay-label">Check-In</span>
                <span class="success-stay-value">${reservation.checkIn}</span>
              </div>
              <div class="success-stay-item">
                <span class="success-stay-label">Check-Out</span>
                <span class="success-stay-value">${reservation.checkOut}</span>
              </div>
              <div class="success-stay-item">
                <span class="success-stay-label">Nights</span>
                <span class="success-stay-value">${reservation.nights}</span>
              </div>
              <div class="success-stay-item">
                <span class="success-stay-label">Guests</span>
                <span class="success-stay-value">${reservation.numberOfGuests}</span>
              </div>
            </div>
          </div>

          <div class="success-detail-section success-price-section">
            <h3 class="success-section-title">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
              Total Amount
            </h3>
            <div class="success-total">
              LKR <fmt:formatNumber value="${reservation.totalAmount}" pattern="#,##0.00"/>
            </div>
            <p class="success-price-note">
              <c:if test="${not empty selectedRoom}">
                LKR <fmt:formatNumber value="${selectedRoom.pricePerNight}" pattern="#,##0"/> × ${reservation.nights} night(s)
              </c:if>
            </p>
          </div>

        </div>

        <%-- Guest details --%>
        <c:if test="${not empty reservation.firstName}">
          <div class="success-guest-box">
            <h3 class="success-section-title">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
              Guest Details
            </h3>
            <p><strong><c:out value="${reservation.firstName}"/> <c:out value="${reservation.lastName}"/></strong>
              <c:if test="${not empty reservation.phone}"> · ${reservation.phone}</c:if>
              <c:if test="${not empty reservation.country}"> · ${reservation.country}</c:if>
            </p>
            <c:if test="${not empty reservation.specialRequests}">
              <p class="success-special">Special requests: <em><c:out value="${reservation.specialRequests}"/></em></p>
            </c:if>
          </div>
        </c:if>

        <%-- CTA buttons --%>
        <div class="success-cta-row">
          <a href="${pageContext.request.contextPath}/payments?action=add&reservationId=${reservation.id}"
             class="btn btn-primary success-pay-btn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg>
            Proceed to Payment
          </a>
          <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline">
            ← Back to Dashboard
          </a>
        </div>

      </div>
    </section>
  </main>
</body>
</html>
