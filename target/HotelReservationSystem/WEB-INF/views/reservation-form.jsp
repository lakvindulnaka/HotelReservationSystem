<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${mode == 'edit' ? 'Edit Reservation' : 'Reserve a Room'} — Hotel Management System</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="reservations"/>
  <%@ include file="nav.jsp" %>

  <main class="main-content">

    <section class="hero-panel compact-hero">
      <div>
        <p class="hero-kicker">
          <a href="${pageContext.request.contextPath}/rooms${not empty selectedRoom ? '?hotelId='.concat(selectedRoom.hotelId) : ''}" style="color:var(--nav-gold);text-decoration:none">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;vertical-align:middle"><polyline points="15 18 9 12 15 6"/></svg>
            ${not empty selectedRoom ? selectedRoom.hotelName : 'Back'}
          </a>
        </p>
        <h1>${mode == 'edit' ? 'Edit Reservation' : 'Complete Your Booking'}</h1>
        <p>${mode == 'edit' ? 'Update the reservation details below.' : 'Enter your details to confirm the reservation.'}</p>
      </div>
    </section>

    <section class="page fade-in">
      <c:if test="${not empty formError}">
        <div class="alert alert-danger">${formError}</div>
      </c:if>

      <div class="booking-form-layout">

        <%-- ──── LEFT: Guest detail form ──────────────────────────────── --%>
        <div class="booking-form-column">
          <form action="${pageContext.request.contextPath}/reservations" method="post" id="reservationForm" novalidate>
            <input type="hidden" name="id"     value="${form.id}">
            <input type="hidden" name="roomId" value="${form.roomId}">
            <c:if test="${sessionScope.authUser.admin}">
              <input type="hidden" name="status" value="${not empty form.status ? form.status : 'Pending'}">
            </c:if>

            <%-- Enter your details --%>
            <div class="bfc-card">
              <h2 class="bfc-heading">Enter your details</h2>
              <div class="bfc-info-alert">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="8"/><path d="M12 12v4"/></svg>
                Almost done! Fill in the <strong>* required</strong> fields to confirm your booking.
              </div>

              <%-- Name row --%>
              <div class="bfc-two-col">
                <div class="form-group">
                  <label for="firstName">First name <span class="required-star">*</span></label>
                  <input type="text" id="firstName" name="firstName" value="${fn:escapeXml(form.firstName)}"
                         placeholder="e.g. Lakvin" required autocomplete="given-name">
                  <span class="field-error" id="err-firstName"></span>
                </div>
                <div class="form-group">
                  <label for="lastName">Last name <span class="required-star">*</span></label>
                  <input type="text" id="lastName" name="lastName" value="${fn:escapeXml(form.lastName)}"
                         placeholder="e.g. Perera" required autocomplete="family-name">
                  <span class="field-error" id="err-lastName"></span>
                </div>
              </div>

              <%-- Email --%>
              <div class="form-group">
                <label for="guestEmail">Email address <span class="required-star">*</span></label>
                <input type="email" id="guestEmail" name="guestEmail"
                       value="${fn:escapeXml(sessionScope.authUser.email)}"
                       placeholder="you@example.com" required autocomplete="email">
                <span class="form-hint">Confirmation will be sent to this address.</span>
                <span class="field-error" id="err-guestEmail"></span>
              </div>

              <%-- Country --%>
              <div class="form-group">
                <label for="country">Country / Region <span class="required-star">*</span></label>
                <select id="country" name="country" required>
                  <c:set var="sel" value="${not empty form.country ? form.country : 'Sri Lanka'}"/>
                  <option value="Sri Lanka"      ${sel == 'Sri Lanka'      ? 'selected':''}>🇱🇰 Sri Lanka</option>
                  <option value="India"          ${sel == 'India'          ? 'selected':''}>🇮🇳 India</option>
                  <option value="United Kingdom" ${sel == 'United Kingdom' ? 'selected':''}>🇬🇧 United Kingdom</option>
                  <option value="United States"  ${sel == 'United States'  ? 'selected':''}>🇺🇸 United States</option>
                  <option value="Australia"      ${sel == 'Australia'      ? 'selected':''}>🇦🇺 Australia</option>
                  <option value="Germany"        ${sel == 'Germany'        ? 'selected':''}>🇩🇪 Germany</option>
                  <option value="France"         ${sel == 'France'         ? 'selected':''}>🇫🇷 France</option>
                  <option value="China"          ${sel == 'China'          ? 'selected':''}>🇨🇳 China</option>
                  <option value="Japan"          ${sel == 'Japan'          ? 'selected':''}>🇯🇵 Japan</option>
                  <option value="Maldives"       ${sel == 'Maldives'       ? 'selected':''}>🇲🇻 Maldives</option>
                  <option value="Other"          ${sel == 'Other'          ? 'selected':''}>🌍 Other</option>
                </select>
                <span class="field-error" id="err-country"></span>
              </div>

              <%-- Phone --%>
              <div class="form-group">
                <label for="phone">Phone number <span class="required-star">*</span></label>
                <div class="phone-input-row">
                  <div class="phone-prefix">🇱🇰 +94</div>
                  <input type="tel" id="phone" name="phone"
                         value="${fn:escapeXml(form.phone)}"
                         placeholder="71 234 5678" required autocomplete="tel">
                </div>
                <span class="form-hint">Used to verify your booking and for the property to contact you.</span>
                <span class="field-error" id="err-phone"></span>
              </div>

              <%-- Paperless --%>
              <label class="bfc-checkbox-label">
                <input type="checkbox" name="paperlessConfirmation" value="on" ${form.paperlessConfirmation ? 'checked':''}>
                <span>Yes, send me a free paperless confirmation via SMS</span>
              </label>
            </div>

            <%-- Booking details --%>
            <div class="bfc-card" style="margin-top:16px">
              <h2 class="bfc-heading">Booking Details</h2>

              <%-- Room selector (only when no room pre-selected) --%>
              <c:if test="${empty selectedRoom}">
                <div class="form-group">
                  <label for="roomId2">Room <span class="required-star">*</span></label>
                  <select id="roomId2" name="roomId" required>
                    <option value="">Select a room</option>
                    <c:forEach var="h" items="${hotels}">
                      <optgroup label="${h.hotelName}">
                        <c:forEach var="r" items="${rooms}">
                          <c:if test="${r.hotelId == h.id}">
                            <option value="${r.id}" ${form.roomId == r.id ? 'selected':''}>
                              ${r.roomNumber} — ${r.roomType} — LKR <fmt:formatNumber value="${r.pricePerNight}" pattern="#,##0"/> (${r.status})
                            </option>
                          </c:if>
                        </c:forEach>
                      </optgroup>
                    </c:forEach>
                  </select>
                </div>
              </c:if>

              <div class="bfc-two-col">
                <div class="form-group">
                  <label for="checkIn">Check-in date <span class="required-star">*</span></label>
                  <input type="date" id="checkIn" name="checkIn" value="${form.checkIn}" required min="${pageContext.request.getParameter('today')}">
                  <span class="field-error" id="err-checkIn"></span>
                </div>
                <div class="form-group">
                  <label for="checkOut">Check-out date <span class="required-star">*</span></label>
                  <input type="date" id="checkOut" name="checkOut" value="${form.checkOut}" required>
                  <span class="field-error" id="err-checkOut"></span>
                </div>
              </div>

              <div class="form-group">
                <label for="numberOfGuests">Number of guests <span class="required-star">*</span>
                  <c:if test="${not empty selectedRoom}">
                    <span style="color:var(--muted);font-weight:400"> (max ${selectedRoom.capacity})</span>
                  </c:if>
                </label>
                <input type="number" id="numberOfGuests" name="numberOfGuests"
                       value="${form.numberOfGuests > 0 ? form.numberOfGuests : 1}"
                       min="1" max="${not empty selectedRoom ? selectedRoom.capacity : 10}" required>
                <span class="field-error" id="err-guests"></span>
              </div>

              <%-- Admin extras --%>
              <c:if test="${sessionScope.authUser.admin}">
                <div class="form-group">
                  <label for="userId">Guest Account</label>
                  <select id="userId" name="userId">
                    <c:forEach var="u" items="${users}">
                      <option value="${u.id}" ${form.userId == u.id ? 'selected':''}>${u.name} (${u.email})</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="form-group">
                  <label for="statusField">Status</label>
                  <select id="statusField" name="status">
                    <option value="Pending"   ${form.status == 'Pending'   ? 'selected':''}>Pending</option>
                    <option value="Confirmed" ${form.status == 'Confirmed' ? 'selected':''}>Confirmed</option>
                    <option value="Cancelled" ${form.status == 'Cancelled' ? 'selected':''}>Cancelled</option>
                  </select>
                </div>
              </c:if>
            </div>

            <%-- Preferences --%>
            <div class="bfc-card" style="margin-top:16px">
              <h2 class="bfc-heading">Preferences <span style="font-size:13px;font-weight:400;color:var(--muted)">(optional)</span></h2>

              <div class="form-group">
                <label class="bfc-radio-group-label">Who are you booking for?</label>
                <div class="bfc-radio-group">
                  <label class="bfc-radio-label">
                    <input type="radio" name="bookingFor" value="Self" ${form.bookingFor != 'Other' ? 'checked':''}> I'm the main guest
                  </label>
                  <label class="bfc-radio-label">
                    <input type="radio" name="bookingFor" value="Other" ${form.bookingFor == 'Other' ? 'checked':''}> I'm booking for someone else
                  </label>
                </div>
              </div>

              <div class="form-group">
                <label class="bfc-radio-group-label">Are you travelling for work?</label>
                <div class="bfc-radio-group">
                  <label class="bfc-radio-label">
                    <input type="radio" name="travelingForWork" value="yes" ${form.travelingForWork ? 'checked':''}> Yes
                  </label>
                  <label class="bfc-radio-label">
                    <input type="radio" name="travelingForWork" value="no" ${!form.travelingForWork ? 'checked':''}> No
                  </label>
                </div>
              </div>

              <div class="form-group">
                <label for="specialRequests">Special requests</label>
                <textarea id="specialRequests" name="specialRequests" rows="3"
                          placeholder="e.g. early check-in, high floor, extra pillow, sea view…"><c:out value="${form.specialRequests}"/></textarea>
              </div>
            </div>

            <div class="bfc-actions">
              <button type="submit" class="btn btn-primary bfc-submit-btn" id="submitBtn">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                ${mode == 'edit' ? 'Save Changes' : 'Confirm Reservation'}
              </button>
              <a href="${pageContext.request.contextPath}/reservations" class="btn btn-outline">Cancel</a>
            </div>
          </form>
        </div>

        <%-- ──── RIGHT: Booking summary card ──────────────────────────── --%>
        <aside class="booking-summary-col">
          <div class="booking-summary-card">
            <c:choose>
              <c:when test="${not empty selectedRoom}">
                <%-- Hotel image --%>
                <c:set var="sumImg" value="${not empty selectedHotel.image ? selectedHotel.image : (not empty selectedRoom.image ? selectedRoom.image : '')}"/>
                <c:if test="${not empty sumImg}">
                  <div class="bs-hotel-img" style="background-image:url(${sumImg})"></div>
                </c:if>

                <div class="bs-body">
                  <h3 class="bs-heading">Your Booking</h3>

                  <div class="bs-row">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21h18M3 21V7l9-4 9 4v14M9 21V12h6v9"/></svg>
                    <div>
                      <div class="bs-label">Hotel</div>
                      <div class="bs-value"><c:out value="${selectedHotel.hotelName}"/></div>
                    </div>
                  </div>

                  <div class="bs-row">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/></svg>
                    <div>
                      <div class="bs-label">Room</div>
                      <div class="bs-value"><c:out value="${selectedRoom.roomType}"/></div>
                      <c:if test="${not empty selectedRoom.bedType}">
                        <div class="bs-sub"><c:out value="${selectedRoom.bedType}"/></div>
                      </c:if>
                    </div>
                  </div>

                  <div class="bs-row">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                    <div>
                      <div class="bs-label">Capacity</div>
                      <div class="bs-value">Up to ${selectedRoom.capacity} guests</div>
                    </div>
                  </div>

                  <div class="bs-row">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    <div>
                      <div class="bs-label">Status</div>
                      <div class="bs-value"><span class="badge badge-${selectedRoom.status}">${selectedRoom.status}</span></div>
                    </div>
                  </div>

                  <div class="bs-divider"></div>

                  <%-- Price calculator --%>
                  <div class="bs-price-section">
                    <div class="bs-price-row">
                      <span>Price per night</span>
                      <span>LKR <fmt:formatNumber value="${selectedRoom.pricePerNight}" pattern="#,##0"/></span>
                    </div>
                    <div class="bs-price-row" id="nightsRow" style="display:none">
                      <span>Nights</span>
                      <span id="nightsDisplay">—</span>
                    </div>
                    <div class="bs-price-total-row" id="totalRow" style="display:none">
                      <span>Estimated Total</span>
                      <span id="totalDisplay">—</span>
                    </div>
                  </div>

                  <div class="bs-secure-note">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    Secure booking. No hidden fees.
                  </div>
                </div>
              </c:when>
              <c:otherwise>
                <div class="bs-body" style="padding:28px 20px">
                  <h3 class="bs-heading">Booking Summary</h3>
                  <p style="color:var(--muted);font-size:13px;margin-top:8px">Select check-in and check-out dates to see the total price.</p>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </aside>

      </div><%-- /booking-form-layout --%>
    </section>
  </main>

<script>
(function () {
  var ciInput = document.getElementById('checkIn');
  var coInput = document.getElementById('checkOut');
  var rate    = ${not empty selectedRoom ? selectedRoom.pricePerNight : 0};

  function calcNights() {
    if (!ciInput || !coInput || rate === 0) return;
    var ci = ciInput.value, co = coInput.value;
    if (!ci || !co) { hideCalc(); return; }
    var d1 = new Date(ci), d2 = new Date(co);
    var nights = Math.round((d2 - d1) / 86400000);
    if (nights <= 0) { hideCalc(); return; }
    document.getElementById('nightsRow').style.display = '';
    document.getElementById('totalRow').style.display  = '';
    document.getElementById('nightsDisplay').textContent = nights + ' night' + (nights > 1 ? 's' : '');
    document.getElementById('totalDisplay').textContent  =
      'LKR ' + (nights * rate).toLocaleString('en-LK', {minimumFractionDigits:0, maximumFractionDigits:0});
  }

  function hideCalc() {
    if (document.getElementById('nightsRow')) {
      document.getElementById('nightsRow').style.display = 'none';
      document.getElementById('totalRow').style.display  = 'none';
    }
  }

  if (ciInput) ciInput.addEventListener('change', function() { if(coInput.value && new Date(coInput.value) <= new Date(ciInput.value)) coInput.value=''; calcNights(); });
  if (coInput) coInput.addEventListener('change', calcNights);

  // Set today as min for check-in
  if (ciInput && !ciInput.value) {
    var today = new Date(); today.setHours(0,0,0,0);
    var dd = String(today.getDate()).padStart(2,'0');
    var mm = String(today.getMonth()+1).padStart(2,'0');
    ciInput.min = today.getFullYear()+'-'+mm+'-'+dd;
  }

  // Client-side validation on submit
  document.getElementById('reservationForm').addEventListener('submit', function(e) {
    var valid = true;
    function err(id, msg) { var el = document.getElementById(id); if(el){el.textContent=msg;} valid=false; }
    function clr(id)      { var el = document.getElementById(id); if(el){el.textContent=''; } }

    var fn_ = document.getElementById('firstName');
    var ln_ = document.getElementById('lastName');
    var ph_ = document.getElementById('phone');
    var ci_ = document.getElementById('checkIn');
    var co_ = document.getElementById('checkOut');
    var gu_ = document.getElementById('numberOfGuests');

    clr('err-firstName'); clr('err-lastName'); clr('err-phone');
    clr('err-checkIn'); clr('err-checkOut'); clr('err-guests');

    if (fn_ && !fn_.value.trim()) err('err-firstName','First name is required.');
    if (ln_ && !ln_.value.trim()) err('err-lastName','Last name is required.');
    if (ph_ && !ph_.value.trim()) err('err-phone','Phone number is required.');
    if (ci_ && !ci_.value)        err('err-checkIn','Check-in date is required.');
    if (co_ && !co_.value)        err('err-checkOut','Check-out date is required.');
    if (ci_ && co_ && ci_.value && co_.value) {
      if (new Date(co_.value) <= new Date(ci_.value)) err('err-checkOut','Check-out must be after check-in.');
    }
    var maxG = ${not empty selectedRoom ? selectedRoom.capacity : 10};
    if (gu_ && parseInt(gu_.value,10) > maxG) err('err-guests','Exceeds room capacity of ' + maxG + ' guests.');

    if (!valid) e.preventDefault();
  });

  calcNights();
}());
</script>
</body>
</html>
