<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment — Hotel Management System</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <c:set var="currentPage" value="payments"/>
  <%@ include file="nav.jsp" %>

  <%-- ════════════════════════════════════════════════════════════════
       CHECKOUT VIEW — shown when action=add or action=edit
       ════════════════════════════════════════════════════════════════ --%>
  <c:choose>
    <c:when test="${not empty mode}">

      <%-- Look up the selected reservation from the list --%>
      <c:set var="selRes" value="${null}"/>
      <c:forEach var="r" items="${reservations}">
        <c:if test="${r.id == form.reservationId}">
          <c:set var="selRes" value="${r}"/>
        </c:if>
      </c:forEach>

      <%-- Top bar --%>
      <header class="pay-topbar">
        <div class="pay-topbar-inner">
          <a href="${pageContext.request.contextPath}/dashboard" class="pay-topbar-brand">
            <span class="brand-mark">HM</span>
            <span class="brand-name">HotelManage</span>
          </a>
          <span class="pay-topbar-secure">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            Secure Payment
          </span>
          <span class="pay-topbar-help">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.56 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
            Need help? <a href="tel:+94112437437">+94 11 243 7437</a>
          </span>
        </div>
      </header>

      <main class="pay-shell">
        <div class="pay-layout">

          <%-- ── LEFT: Booking Summary ─────────────────────────────────────── --%>
          <aside class="pay-summary-col">
            <div class="pay-summary-card">
              <h2 class="pay-summary-title">Booking Summary</h2>

              <%-- Room image --%>
              <div class="pay-summary-img pay-summary-img--placeholder">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/></svg>
              </div>

              <%-- Hotel / room labels --%>
              <c:choose>
                <c:when test="${not empty selRes}">
                  <p class="pay-summary-room"><c:out value="${selRes.roomType}"/></p>
                  <p class="pay-summary-hotel"><c:out value="${selRes.hotelName}"/></p>
                  <p class="pay-summary-loc">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="12" height="12"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    Room #<c:out value="${selRes.roomNumber}"/>
                  </p>

                  <%-- Stay meta --%>
                  <div class="pay-stay-meta">
                    <div class="pay-stay-row">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                      <span class="pay-stay-label">Check-in</span>
                      <span class="pay-stay-val"><c:out value="${selRes.checkIn}"/></span>
                    </div>
                    <div class="pay-stay-row">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                      <span class="pay-stay-label">Check-out</span>
                      <span class="pay-stay-val"><c:out value="${selRes.checkOut}"/></span>
                    </div>
                    <div class="pay-stay-row">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                      <span class="pay-stay-label">Guests</span>
                      <span class="pay-stay-val"><c:out value="${selRes.numberOfGuests}"/> Adult(s)</span>
                    </div>
                    <div class="pay-stay-row">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                      <span class="pay-stay-label">Nights</span>
                      <span class="pay-stay-val"><c:out value="${selRes.nights}"/> Night(s)</span>
                    </div>
                  </div>

                  <%-- Price breakdown --%>
                  <div class="pay-price-breakdown">
                    <div class="pay-price-row">
                      <span>Room Charge</span>
                      <span>LKR <fmt:formatNumber value="${selRes.totalAmount * 0.89}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="pay-price-row">
                      <span>Taxes &amp; Fees (8%)</span>
                      <span>LKR <fmt:formatNumber value="${selRes.totalAmount * 0.08}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="pay-price-row">
                      <span>Service Fee (3%)</span>
                      <span>LKR <fmt:formatNumber value="${selRes.totalAmount * 0.03}" pattern="#,##0.00"/></span>
                    </div>
                  </div>

                  <div class="pay-total-row">
                    <div>
                      <span class="pay-total-label">Total Amount</span>
                      <span class="pay-total-note">Includes all taxes and fees</span>
                    </div>
                    <span class="pay-total-amount">LKR <fmt:formatNumber value="${selRes.totalAmount}" pattern="#,##0.00"/></span>
                  </div>
                </c:when>
                <c:otherwise>
                  <p class="pay-summary-room" style="color:var(--muted);font-style:italic">Select a reservation to see summary</p>
                </c:otherwise>
              </c:choose>

              <div class="pay-secure-note">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                Your payment information is secure and encrypted.
              </div>
            </div>
          </aside>

          <%-- ── RIGHT: Payment Details Form ─────────────────────────────── --%>
          <section class="pay-form-col">
            <div class="pay-form-card">

              <c:if test="${not empty formError}">
                <div class="alert alert-danger" style="margin-bottom:20px">${formError}</div>
              </c:if>

              <h2 class="pay-form-title">Payment Details</h2>

              <%-- Card logos --%>
              <div class="pay-card-logos">
                <span class="pay-accept-label">We accept</span>
                <span class="pay-logo pay-logo-visa">VISA</span>
                <span class="pay-logo pay-logo-mc">MC</span>
                <span class="pay-logo pay-logo-amex">AMEX</span>
                <span class="pay-logo pay-logo-disc">DISC</span>
              </div>

              <form action="${pageContext.request.contextPath}/payments" method="post" id="paymentForm" novalidate>
                <input type="hidden" name="id" value="${form.id}">
                <div class="alert alert-danger pay-card-validation" id="cardValidationError">
                  Please enter card number.
                </div>

                <%-- Reservation selector (compact, shown if no pre-selected reservation) --%>
                <c:if test="${empty selRes}">
                  <div class="pay-field-group">
                    <label class="pay-label" for="reservationId">Reservation</label>
                    <select id="reservationId" name="reservationId" class="pay-select" required>
                      <option value="">— Select your reservation —</option>
                      <c:forEach var="r" items="${reservations}">
                        <option value="${r.id}" data-total="${r.totalAmount}" ${form.reservationId == r.id ? 'selected' : ''}>
                          #${r.id} · <c:out value="${r.roomType}"/> · <c:out value="${r.hotelName}"/>
                        </option>
                      </c:forEach>
                    </select>
                  </div>
                </c:if>
                <c:if test="${not empty selRes}">
                  <input type="hidden" name="reservationId" value="${selRes.id}">
                  <%-- Show a read-only reservation strip --%>
                  <div class="pay-res-strip">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                    <span>Reservation #${selRes.id} · <c:out value="${selRes.roomType}"/> · <c:out value="${selRes.hotelName}"/></span>
                    <a href="${pageContext.request.contextPath}/payments?action=add" class="pay-res-change">Change</a>
                  </div>
                </c:if>

                <%-- ── Card Information ─── --%>
                <div class="pay-section-title">Card Information</div>

                <div class="pay-field-group">
                  <label class="pay-label" for="cardNumber">Card Number</label>
                  <div class="pay-input-icon-wrap">
                    <input type="text" id="cardNumber" name="cardNumber" class="pay-input" placeholder="1234 1234 1234 1234" maxlength="23" inputmode="numeric" autocomplete="cc-number" required>
                    <svg class="pay-input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg>
                  </div>
                </div>

                <div class="pay-field-row">
                  <div class="pay-field-group">
                    <label class="pay-label" for="expiryDate">Expiry Date</label>
                    <input type="text" id="expiryDate" name="expiryDate" class="pay-input" placeholder="MM / YY" maxlength="7" autocomplete="cc-exp" required>
                  </div>
                  <div class="pay-field-group">
                    <label class="pay-label" for="cvv">CVV</label>
                    <div class="pay-input-icon-wrap">
                      <input type="text" id="cvv" name="cvv" class="pay-input" placeholder="123" maxlength="4" inputmode="numeric" autocomplete="cc-csc" required>
                      <svg class="pay-input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    </div>
                  </div>
                </div>

                <div class="pay-field-group">
                  <label class="pay-label" for="cardholderName">Cardholder Name</label>
                  <input type="text" id="cardholderName" name="cardholderName" class="pay-input" placeholder="Name on Card" autocomplete="cc-name" required>
                </div>

                <%-- ── Payment Method & Date (backend fields) ─── --%>
                <div class="pay-section-title" style="margin-top:28px">Payment Details</div>
                <div class="pay-field-row">
                  <div class="pay-field-group">
                    <label class="pay-label" for="paymentMethod">Method</label>
                    <select id="paymentMethod" name="paymentMethod" class="pay-select" required>
                      <option value="Card" ${form.paymentMethod == 'Card' || empty form.paymentMethod ? 'selected' : ''}>Card</option>
                      <option value="Cash" ${form.paymentMethod == 'Cash' ? 'selected' : ''}>Cash</option>
                      <option value="Bank Transfer" ${form.paymentMethod == 'Bank Transfer' ? 'selected' : ''}>Bank Transfer</option>
                      <option value="Online" ${form.paymentMethod == 'Online' ? 'selected' : ''}>Online</option>
                    </select>
                  </div>
                  <div class="pay-field-group">
                    <label class="pay-label" for="paymentDate">Payment Date</label>
                    <input type="date" id="paymentDate" name="paymentDate" class="pay-input" value="${form.paymentDate}" required>
                  </div>
                </div>

                <div class="pay-field-row">
                  <div class="pay-field-group">
                    <label class="pay-label" for="amount">Amount (LKR)</label>
                    <input type="number" step="0.01" min="0" id="amount" name="amount" class="pay-input" value="${not empty form.amount && form.amount > 0 ? form.amount : (not empty selRes ? selRes.totalAmount : '')}" required>
                  </div>
                  <div class="pay-field-group">
                    <label class="pay-label" for="status">Status</label>
                    <c:choose>
                      <c:when test="${sessionScope.authUser.admin}">
                        <select id="status" name="status" class="pay-select" required>
                          <option value="Pending" ${form.status == 'Pending' || empty form.status ? 'selected' : ''}>Pending</option>
                          <option value="Paid" ${form.status == 'Paid' ? 'selected' : ''}>Paid</option>
                          <option value="Failed" ${form.status == 'Failed' ? 'selected' : ''}>Failed</option>
                        <option value="Refunded" ${form.status == 'Refunded' ? 'selected' : ''}>Refunded</option>
                        </select>
                      </c:when>
                      <c:otherwise>
                        <input type="hidden" id="status" name="status" value="${not empty form.status ? form.status : 'Pending'}">
                        <div class="pay-readonly-status">
                          <span class="badge badge-${not empty form.status ? form.status : 'Pending'}">
                            <c:out value="${not empty form.status ? form.status : 'Pending'}"/>
                          </span>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>

                <%-- ── Total & confirm button ─── --%>
                <div class="pay-confirm-bar">
                  <div class="pay-confirm-total">
                    <span class="pay-confirm-total-label">Total Amount</span>
                    <span class="pay-confirm-total-val" id="confirmTotal">
                      <c:choose>
                        <c:when test="${not empty selRes}">LKR <fmt:formatNumber value="${selRes.totalAmount}" pattern="#,##0.00"/></c:when>
                        <c:otherwise>—</c:otherwise>
                      </c:choose>
                    </span>
                  </div>
                  <button type="submit" class="btn pay-confirm-btn">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" width="18" height="18"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    ${mode == 'edit' ? 'Save Changes' : 'Confirm &amp; Pay'}
                  </button>
                </div>

                <p class="pay-terms">
                  By completing this payment, you agree to our <a href="#">Terms &amp; Conditions</a> and <a href="#">Privacy Policy</a>.
                </p>

              </form>
            </div>
          </section>
        </div><!-- /.pay-layout -->
      </main>

    </c:when>

    <%-- ════════════════════════════════════════════════════════════════
         LIST VIEW — admin/user payments table
         ════════════════════════════════════════════════════════════════ --%>
    <c:otherwise>
      <main class="main-content">
        <section class="hero-panel compact-hero">
          <div>
            <p class="hero-kicker">Payments</p>
            <h1>${sessionScope.authUser.admin ? 'Manage Payment Records' : 'My Payments'}</h1>
            <p>View payment history and manage records for all reservations.</p>
          </div>
          <c:if test="${sessionScope.authUser.admin}">
            <a href="${pageContext.request.contextPath}/payments?action=add" class="btn btn-primary">New Payment</a>
          </c:if>
        </section>

        <section class="page fade-in">
          <c:if test="${param.msg == 'added'}"><div class="alert alert-success">Payment saved.</div></c:if>
          <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Payment updated.</div></c:if>
          <c:if test="${param.msg == 'deleted'}"><div class="alert alert-danger">Payment deleted.</div></c:if>

          <div class="card reservation-table-card">
            <div class="table-wrap">
              <table class="reservation-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Reservation</th>
                    <th>Guest</th>
                    <th>Amount</th>
                    <th>Method</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${empty payments}">
                      <tr><td colspan="8"><div class="empty-state">No payment records found.</div></td></tr>
                    </c:when>
                    <c:otherwise>
                      <c:forEach var="p" items="${payments}">
                        <tr>
                          <td>#${p.id}</td>
                          <td><c:out value="${p.reservationLabel}"/></td>
                          <td><span class="guest-name"><c:out value="${p.userName}"/></span></td>
                          <td class="money-cell">LKR <fmt:formatNumber value="${p.amount}" pattern="#,##0.00"/></td>
                          <td><c:out value="${p.paymentMethod}"/></td>
                          <td><c:out value="${p.paymentDate}"/></td>
                          <td><span class="badge badge-${p.status}"><c:out value="${p.status}"/></span></td>
                          <td>
                            <div class="table-actions">
                              <a href="${pageContext.request.contextPath}/payments?action=edit&id=${p.id}" class="btn btn-outline btn-sm">Edit</a>
                              <c:if test="${sessionScope.authUser.admin}">
                                <a href="${pageContext.request.contextPath}/payments?action=delete&id=${p.id}" class="btn btn-danger btn-sm" onclick="return confirm('Delete payment #${p.id}?')">Delete</a>
                              </c:if>
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
        </section>
      </main>
    </c:otherwise>
  </c:choose>

  <script>
    // Card number formatting
    var cardInput = document.getElementById('cardNumber');
    if (cardInput) {
      cardInput.addEventListener('input', function () {
        var v = this.value.replace(/\D/g, '').substring(0, 19);
        this.value = v.replace(/(.{4})/g, '$1 ').trim();
      });
    }
    // Expiry formatting
    var expInput = document.getElementById('expiryDate');
    if (expInput) {
      expInput.addEventListener('input', function () {
        var v = this.value.replace(/\D/g, '').substring(0, 4);
        if (v.length >= 3) v = v.substring(0, 2) + ' / ' + v.substring(2);
        this.value = v;
      });
    }
    var paymentForm = document.getElementById('paymentForm');
    var cardError = document.getElementById('cardValidationError');
    var cvvInput = document.getElementById('cvv');
    var nameInput = document.getElementById('cardholderName');
    if (paymentForm) {
      paymentForm.addEventListener('submit', function (e) {
        var validationMessage = validateCardDetails();
        if (validationMessage) {
          e.preventDefault();
          if (cardError) {
            cardError.textContent = validationMessage;
            cardError.classList.add('show');
          }
          if (window.showToast) {
            window.showToast(validationMessage, 'error');
          }
        } else if (cardError) {
          cardError.classList.remove('show');
        }
      });
    }

    function validateCardDetails() {
      var cardNumber = cardInput ? cardInput.value.trim() : '';
      var expiryDate = expInput ? expInput.value.trim() : '';
      var cvv = cvvInput ? cvvInput.value.trim() : '';
      var cardholder = nameInput ? nameInput.value.trim() : '';

      var cleanCardNumber = cardNumber.replace(/\s/g, '');
      var cleanExpiry = expiryDate.replace(/\s/g, '');
      var cleanCvv = cvv.trim();

      if (!cardNumber) return 'Please enter card number.';
      if (!/^\d{13,19}$/.test(cleanCardNumber)) return 'Please enter a valid card number.';
      if (!expiryDate) return 'Please enter expiry date.';
      if (!isValidExpiry(cleanExpiry)) return 'Please enter a valid expiry date.';
      if (!cleanCvv) return 'Please enter CVV.';
      if (!/^\d{3,4}$/.test(cleanCvv)) return 'Please enter a valid CVV.';
      if (!cardholder) return 'Please enter cardholder name.';

      return '';
    }

    function isValidExpiry(cleanExpiry) {
      if (!/^\d{2}\/\d{2}$/.test(cleanExpiry)) return false;
      var month = parseInt(cleanExpiry.substring(0, 2), 10);
      return month >= 1 && month <= 12;
    }
    // Load the checkout summary when a reservation is selected.
    var resSel = document.getElementById('reservationId');
    var amtInput = document.getElementById('amount');
    if (resSel) {
      resSel.addEventListener('change', function () {
        if (this.value) {
          window.location.href = '${pageContext.request.contextPath}/payments?action=add&reservationId=' + encodeURIComponent(this.value);
        } else if (amtInput) {
          amtInput.value = '';
        }
      });
    }
  </script>
</body>
</html>
