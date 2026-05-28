<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>
    <c:choose>
      <c:when test="${selectedRoomId > 0}">${selectedRoom.roomType} — Hotels</c:when>
      <c:when test="${selectedHotelId > 0}">${selectedHotel.hotelName} — Hotels</c:when>
      <c:otherwise>Hotels — Hotel Management System</c:otherwise>
    </c:choose>
  </title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="rooms"/>
  <%@ include file="nav.jsp" %>

  <main class="main-content">

  <%-- ══════════════════════════════════════════════════════
       VIEW A — No hotel selected: hotel cards grid
       ══════════════════════════════════════════════════════ --%>
  <c:if test="${selectedHotelId == 0}">
    <section class="hero-panel compact-hero">
      <div>
        <p class="hero-kicker">Hotel Selection</p>
        <h1>Choose Your Hotel</h1>
        <p>Browse our luxury Sri Lankan properties. Select a hotel to view available rooms, photos, and prices.</p>
      </div>
      <c:if test="${sessionScope.authUser.admin}">
        <a href="${pageContext.request.contextPath}/hotels?action=add" class="btn btn-primary">+ Add Hotel</a>
      </c:if>
    </section>

    <section class="page fade-in">
      <c:if test="${param.msg == 'deleted'}"><div class="alert alert-danger">Deleted successfully.</div></c:if>
      <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Updated successfully.</div></c:if>
      <c:if test="${param.msg == 'added'}">  <div class="alert alert-success">Added successfully.</div></c:if>

      <div class="hotel-cards-grid">
        <c:choose>
          <c:when test="${empty hotels}">
            <div class="empty-state">
              <span class="empty-state-icon">🏨</span>
              <span class="empty-state-title">No Hotels Yet</span>
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
                    <a href="${pageContext.request.contextPath}/rooms?hotelId=${h.id}" class="btn btn-primary btn-sm">View Rooms</a>
                    <c:if test="${sessionScope.authUser.admin}">
                      <a href="${pageContext.request.contextPath}/hotels?action=edit&id=${h.id}" class="btn btn-outline btn-sm">Edit</a>
                      <a href="${pageContext.request.contextPath}/hotels?action=delete&id=${h.id}" class="btn btn-danger btn-sm"
                         onclick="return confirm('Delete ${h.hotelName}? This deletes all its rooms too.')">Delete</a>
                    </c:if>
                  </div>
                </div>
              </article>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </div>
    </section>
  </c:if>

  <%-- ══════════════════════════════════════════════════════
       VIEW B — Hotel selected, no room: hotel hero + room list
       ══════════════════════════════════════════════════════ --%>
  <c:if test="${selectedHotelId > 0 and selectedRoomId == 0}">
    <%-- Hotel hero banner --%>
    <c:set var="heroImg" value="${not empty selectedHotel.image ? selectedHotel.image : ''}"/>
    <div class="hotel-detail-hero" style="${not empty heroImg ? 'background-image:url('.concat(heroImg).concat(')') : ''}">
      <div class="hotel-detail-hero-overlay"></div>
      <div class="hotel-detail-hero-content page">
        <a href="${pageContext.request.contextPath}/rooms" class="hotel-detail-back">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
          All Hotels
        </a>
        <div class="hotel-detail-stars"><c:out value="${selectedHotel.starString}"/></div>
        <h1 class="hotel-detail-name"><c:out value="${selectedHotel.hotelName}"/></h1>
        <div class="hotel-detail-location">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
          <c:out value="${selectedHotel.location}"/>
        </div>
        <c:if test="${not empty selectedHotel.facilities}">
          <div class="hotel-detail-pills">
            <c:forTokens var="fac" items="${selectedHotel.facilities}" delims=",">
              <span class="hotel-detail-pill">${fn:trim(fac)}</span>
            </c:forTokens>
          </div>
        </c:if>
      </div>
    </div>

    <section class="page fade-in">
      <c:if test="${param.msg == 'added'}">  <div class="alert alert-success">Room added.</div></c:if>
      <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Room updated.</div></c:if>
      <c:if test="${param.msg == 'deleted'}"><div class="alert alert-danger">Room deleted.</div></c:if>

      <%-- Hotel description --%>
      <c:if test="${not empty selectedHotel.description}">
        <div class="hotel-about-box">
          <h2 class="hotel-about-title">About <c:out value="${selectedHotel.hotelName}"/></h2>
          <p><c:out value="${selectedHotel.description}"/></p>
        </div>
      </c:if>

      <%-- Admin form (add/edit room) --%>
      <c:if test="${sessionScope.authUser.admin}">
        <details class="admin-form-details" ${mode == 'edit' ? 'open' : ''}>
          <summary class="admin-form-summary">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/></svg>
            ${mode == 'edit' ? 'Edit Room' : 'Add New Room to '.concat(selectedHotel.hotelName)}
          </summary>
          <div class="card" style="margin-top:12px">
            <form action="${pageContext.request.contextPath}/rooms" method="post" class="form-grid">
              <input type="hidden" name="id" value="${form.id}">
              <input type="hidden" name="hotelId" value="${selectedHotelId}">
              <div class="form-group">
                <label for="roomNumber">Room Number</label>
                <input type="text" id="roomNumber" name="roomNumber" value="${fn:escapeXml(form.roomNumber)}" placeholder="e.g. CG-101" required>
              </div>
              <div class="form-group">
                <label for="roomType">Room Type</label>
                <input type="text" id="roomType" name="roomType" value="${fn:escapeXml(form.roomType)}" placeholder="e.g. Deluxe Ocean View" required>
              </div>
              <div class="form-group">
                <label for="bedType">Bed Type</label>
                <input type="text" id="bedType" name="bedType" value="${fn:escapeXml(form.bedType)}" placeholder="e.g. 1 King Bed">
              </div>
              <div class="form-group">
                <label for="roomSize">Room Size</label>
                <input type="text" id="roomSize" name="roomSize" value="${fn:escapeXml(form.roomSize)}" placeholder="e.g. 32 m²">
              </div>
              <div class="form-group">
                <label for="pricePerNight">Price Per Night (LKR)</label>
                <input type="number" step="0.01" min="0" id="pricePerNight" name="pricePerNight" value="${form.pricePerNight}" required>
              </div>
              <div class="form-group">
                <label for="capacity">Guest Capacity</label>
                <input type="number" min="1" max="10" id="capacity" name="capacity" value="${form.capacity > 0 ? form.capacity : 2}" required>
              </div>
              <div class="form-group">
                <label for="status">Status</label>
                <select id="status" name="status" required>
                  <option value="Available"   ${form.status == 'Available'   ? 'selected' : ''}>Available</option>
                  <option value="Booked"      ${form.status == 'Booked'      ? 'selected' : ''}>Booked</option>
                  <option value="Maintenance" ${form.status == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                </select>
              </div>
              <div class="form-group full">
                <label for="image">Main Room Image URL</label>
                <input type="url" id="image" name="image" value="${fn:escapeXml(form.image)}" placeholder="https://images.unsplash.com/...">
              </div>
              <div class="form-group full">
                <label for="gallery">Gallery Image URLs <span style="color:var(--muted);font-weight:400;font-size:12px">(comma-separated, 3 extras)</span></label>
                <input type="text" id="gallery" name="gallery" value="${fn:escapeXml(form.gallery)}" placeholder="url1,url2,url3">
              </div>
              <div class="form-group full">
                <label for="facilities">Facilities <span style="color:var(--muted);font-weight:400;font-size:12px">(comma-separated)</span></label>
                <input type="text" id="facilities" name="facilities" value="${fn:escapeXml(form.facilities)}" placeholder="Free Wi-Fi, Air Conditioning, Flat-screen TV">
              </div>
              <div class="form-group full">
                <label for="description">Description</label>
                <textarea id="description" name="description" rows="3" placeholder="Describe room features, bed type, view…"><c:out value="${form.description}"/></textarea>
              </div>
              <div class="form-actions">
                <a href="${pageContext.request.contextPath}/rooms?hotelId=${selectedHotelId}" class="btn btn-outline">Cancel</a>
                <button type="submit" class="btn btn-primary">${mode == 'edit' ? 'Save Changes' : 'Add Room'}</button>
              </div>
            </form>
          </div>
        </details>
      </c:if>

      <%-- Room list (Booking.com horizontal cards) --%>
      <div class="section-heading" style="margin-top:28px">
        <div>
          <h2>Available Rooms</h2>
          <p>${fn:length(rooms)} room types at <c:out value="${selectedHotel.hotelName}"/></p>
        </div>
        <c:if test="${not sessionScope.authUser.admin}">
          <a href="${pageContext.request.contextPath}/reservations?action=add" class="btn btn-primary btn-sm">Reserve Now</a>
        </c:if>
      </div>

      <c:choose>
        <c:when test="${empty rooms}">
          <div class="empty-state">
            <span class="empty-state-icon">🛏</span>
            <span class="empty-state-title">No Rooms Listed</span>
            <span class="empty-state-desc">No rooms have been added for this property yet.</span>
          </div>
        </c:when>
        <c:otherwise>
          <div class="room-list-cards">
            <c:forEach var="room" items="${rooms}">
              <c:set var="roomImg" value="${not empty room.image ? room.image : ''}"/>
              <article class="room-list-card">
                <%-- Image panel --%>
                <div class="room-list-img-panel">
                  <div class="room-list-main-img" style="${not empty roomImg ? 'background-image:url('.concat(roomImg).concat(')') : ''}">
                    <span class="rl-status-badge badge badge-${room.status}">${room.status}</span>
                  </div>
                  <%-- Gallery thumbnails --%>
                  <c:if test="${not empty room.galleryList}">
                    <div class="room-list-thumbs">
                      <c:forEach var="gUrl" items="${room.galleryList}" varStatus="vs">
                        <c:if test="${vs.index < 3}">
                          <div class="room-list-thumb" style="background-image:url(${gUrl})"></div>
                        </c:if>
                      </c:forEach>
                    </div>
                  </c:if>
                </div>

                <%-- Details panel --%>
                <div class="room-list-body">
                  <div class="room-list-header">
                    <div>
                      <span class="chip" style="margin-bottom:6px">${fn:escapeXml(room.roomNumber)}</span>
                      <h3 class="room-list-name"><c:out value="${room.roomType}"/></h3>
                    </div>
                    <div class="room-list-price-badge">
                      <span class="room-list-price">LKR <fmt:formatNumber value="${room.pricePerNight}" pattern="#,##0"/></span>
                      <span class="room-list-per-night">/ night</span>
                    </div>
                  </div>

                  <%-- Meta row --%>
                  <div class="room-list-meta">
                    <c:if test="${not empty room.bedType}">
                      <span class="rl-meta-item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/></svg>
                        <c:out value="${room.bedType}"/>
                      </span>
                    </c:if>
                    <c:if test="${not empty room.roomSize}">
                      <span class="rl-meta-item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><polyline points="15 3 21 3 21 9"/><polyline points="9 21 3 21 3 15"/><line x1="21" y1="3" x2="14" y2="10"/><line x1="3" y1="21" x2="10" y2="14"/></svg>
                        <c:out value="${room.roomSize}"/>
                      </span>
                    </c:if>
                    <span class="rl-meta-item">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                      ${room.capacity} guests
                    </span>
                  </div>

                  <%-- Facility tags --%>
                  <c:if test="${not empty room.facilitiesList}">
                    <div class="room-list-facs">
                      <c:forEach var="fac" items="${room.facilitiesList}" varStatus="vs">
                        <c:if test="${vs.index < 5}">
                          <span class="rl-fac-tag">${fn:trim(fac)}</span>
                        </c:if>
                      </c:forEach>
                      <c:if test="${fn:length(room.facilitiesList) > 5}">
                        <span class="rl-fac-tag rl-fac-more">+${fn:length(room.facilitiesList) - 5} more</span>
                      </c:if>
                    </div>
                  </c:if>

                  <%-- Short description --%>
                  <p class="room-list-desc">
                    <c:choose>
                      <c:when test="${fn:length(room.description) > 160}"><c:out value="${fn:substring(room.description,0,160)}"/>…</c:when>
                      <c:otherwise><c:out value="${room.description}"/></c:otherwise>
                    </c:choose>
                  </p>

                  <%-- Actions --%>
                  <div class="room-list-actions">
                    <a href="${pageContext.request.contextPath}/rooms?hotelId=${selectedHotelId}&roomId=${room.id}" class="btn btn-outline btn-sm">View Details</a>
                    <c:choose>
                      <c:when test="${sessionScope.authUser.admin}">
                        <a href="${pageContext.request.contextPath}/rooms?action=edit&id=${room.id}&hotelId=${selectedHotelId}" class="btn btn-outline btn-sm">Edit</a>
                        <a href="${pageContext.request.contextPath}/rooms?action=delete&id=${room.id}&hotelId=${selectedHotelId}" class="btn btn-danger btn-sm"
                           onclick="return confirm('Delete room ${room.roomNumber}?')">Delete</a>
                      </c:when>
                      <c:when test="${room.available}">
                        <a href="${pageContext.request.contextPath}/reservations?action=add&roomId=${room.id}" class="btn btn-primary btn-sm">Reserve Room</a>
                      </c:when>
                      <c:otherwise>
                        <span class="btn btn-outline btn-sm" style="opacity:.45;cursor:default">Unavailable</span>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </article>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </section>
  </c:if>

  <%-- ══════════════════════════════════════════════════════
       VIEW C — Room detail page
       ══════════════════════════════════════════════════════ --%>
  <c:if test="${selectedRoomId > 0 and not empty selectedRoom}">
    <section class="page fade-in">

      <%-- Breadcrumb --%>
      <nav class="rd-breadcrumb" aria-label="breadcrumb">
        <a href="${pageContext.request.contextPath}/rooms">All Hotels</a>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
        <a href="${pageContext.request.contextPath}/rooms?hotelId=${selectedHotelId}"><c:out value="${selectedHotel.hotelName}"/></a>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
        <span><c:out value="${selectedRoom.roomType}"/></span>
      </nav>

      <div class="rd-layout">

        <%-- Left: Gallery --%>
        <div class="rd-gallery-col">
          <c:set var="roomImg2" value="${not empty selectedRoom.image ? selectedRoom.image : ''}"/>
          <div class="rd-main-img" style="${not empty roomImg2 ? 'background-image:url('.concat(roomImg2).concat(')') : ''}">
            <span class="rd-status badge badge-${selectedRoom.status}">${selectedRoom.status}</span>
          </div>
          <c:if test="${not empty selectedRoom.galleryList}">
            <div class="rd-thumbs">
              <c:forEach var="gUrl" items="${selectedRoom.galleryList}">
                <div class="rd-thumb" style="background-image:url(${gUrl})" onclick="document.querySelector('.rd-main-img').style.backgroundImage='url(${gUrl})'"></div>
              </c:forEach>
            </div>
          </c:if>
        </div>

        <%-- Right: Info --%>
        <div class="rd-info-col">
          <div style="display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:10px">
            <div>
              <span class="chip">${fn:escapeXml(selectedRoom.roomNumber)}</span>
              <h1 class="rd-room-type" style="margin-top:6px"><c:out value="${selectedRoom.roomType}"/></h1>
              <div class="rd-hotel-label">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21h18M3 21V7l9-4 9 4v14M9 21V12h6v9"/></svg>
                <c:out value="${selectedHotel.hotelName}"/> · <c:out value="${selectedHotel.location}"/>
              </div>
            </div>
            <div class="rd-price-block">
              <span class="rd-price">LKR <fmt:formatNumber value="${selectedRoom.pricePerNight}" pattern="#,##0"/></span>
              <span class="rd-price-label">per night</span>
            </div>
          </div>

          <%-- Meta chips --%>
          <div class="rd-meta-chips">
            <c:if test="${not empty selectedRoom.bedType}">
              <div class="rd-chip">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/></svg>
                <c:out value="${selectedRoom.bedType}"/>
              </div>
            </c:if>
            <c:if test="${not empty selectedRoom.roomSize}">
              <div class="rd-chip">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 3 21 3 21 9"/><polyline points="9 21 3 21 3 15"/></svg>
                <c:out value="${selectedRoom.roomSize}"/>
              </div>
            </c:if>
            <div class="rd-chip">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
              ${selectedRoom.capacity} guests max
            </div>
          </div>

          <%-- Facilities --%>
          <c:if test="${not empty selectedRoom.facilitiesList}">
            <div class="rd-section">
              <h3 class="rd-section-title">Room Amenities</h3>
              <div class="rd-fac-grid">
                <c:forEach var="fac" items="${selectedRoom.facilitiesList}">
                  <div class="rd-fac-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                    ${fn:trim(fac)}
                  </div>
                </c:forEach>
              </div>
            </div>
          </c:if>

          <%-- Description --%>
          <c:if test="${not empty selectedRoom.description}">
            <div class="rd-section">
              <h3 class="rd-section-title">About This Room</h3>
              <p class="rd-desc"><c:out value="${selectedRoom.description}"/></p>
            </div>
          </c:if>

          <%-- Check-in rules --%>
          <div class="rd-rules-box">
            <div class="rd-rule"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg> Check-in from 14:00 &nbsp;·&nbsp; Check-out by 12:00</div>
            <div class="rd-rule"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg> Free cancellation up to 48 hours before arrival</div>
          </div>

          <%-- CTA buttons --%>
          <div class="rd-cta-row">
            <c:choose>
              <c:when test="${selectedRoom.available}">
                <a href="${pageContext.request.contextPath}/reservations?action=add&roomId=${selectedRoom.id}" class="btn btn-primary rd-reserve-btn">
                  Reserve This Room
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14"/><path d="M12 5l7 7-7 7"/></svg>
                </a>
              </c:when>
              <c:otherwise>
                <button class="btn btn-outline rd-reserve-btn" disabled style="opacity:.5;cursor:not-allowed">
                  ${selectedRoom.status} — Not Available
                </button>
              </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/rooms?hotelId=${selectedHotelId}" class="btn btn-outline">← All Rooms</a>
            <c:if test="${sessionScope.authUser.admin}">
              <a href="${pageContext.request.contextPath}/rooms?action=edit&id=${selectedRoom.id}&hotelId=${selectedHotelId}" class="btn btn-outline btn-sm">Edit Room</a>
            </c:if>
          </div>
        </div>
      </div>
    </section>
  </c:if>

  </main>
</body>
</html>
