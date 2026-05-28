package com.hotel.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Reservation {
    private int    id;
    private int    userId;
    private int    roomId;
    private String checkIn;
    private String checkOut;
    private int    numberOfGuests;
    private String status;
    private String createdAt;

    // JOIN-populated fields
    private String userName;
    private int    hotelId;
    private String hotelName;
    private String roomNumber;
    private String roomType;
    private double pricePerNight;
    private double totalAmount;

    // Guest contact details
    private String  firstName;
    private String  lastName;
    private String  phone;
    private String  country;
    private String  specialRequests;
    private String  bookingFor;          // 'Self' / 'Other'
    private boolean travelingForWork;
    private boolean paperlessConfirmation;

    // ── Core reservation ──────────────────────────────────────────────────
    public int    getId()            { return id; }
    public void   setId(int id)      { this.id = id; }

    public int  getUserId()              { return userId; }
    public void setUserId(int userId)    { this.userId = userId; }

    public int  getRoomId()            { return roomId; }
    public void setRoomId(int roomId)  { this.roomId = roomId; }

    public String getCheckIn()               { return checkIn; }
    public void   setCheckIn(String ci)      { this.checkIn = ci; }

    public String getCheckOut()              { return checkOut; }
    public void   setCheckOut(String co)     { this.checkOut = co; }

    public int  getNumberOfGuests()                      { return numberOfGuests; }
    public void setNumberOfGuests(int numberOfGuests)    { this.numberOfGuests = numberOfGuests; }

    public String getStatus()                { return status; }
    public void   setStatus(String status)   { this.status = status; }

    public String getCreatedAt()                 { return createdAt; }
    public void   setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    // ── JOIN fields ───────────────────────────────────────────────────────
    public String getUserName()                  { return userName; }
    public void   setUserName(String userName)   { this.userName = userName; }

    public int  getHotelId()               { return hotelId; }
    public void setHotelId(int hotelId)    { this.hotelId = hotelId; }

    public String getHotelName()                   { return hotelName; }
    public void   setHotelName(String hotelName)   { this.hotelName = hotelName; }

    public String getRoomNumber()                    { return roomNumber; }
    public void   setRoomNumber(String roomNumber)   { this.roomNumber = roomNumber; }

    public String getRoomType()                  { return roomType; }
    public void   setRoomType(String roomType)   { this.roomType = roomType; }

    public double getPricePerNight()                       { return pricePerNight; }
    public void   setPricePerNight(double pricePerNight)   { this.pricePerNight = pricePerNight; }

    public double getTotalAmount() {
        if (totalAmount > 0) return totalAmount;
        long n = getNights();
        return n > 0 ? n * pricePerNight : 0;
    }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    // ── Guest detail fields ───────────────────────────────────────────────
    public String getFirstName()                   { return firstName; }
    public void   setFirstName(String firstName)   { this.firstName = firstName; }

    public String getLastName()                    { return lastName; }
    public void   setLastName(String lastName)     { this.lastName = lastName; }

    public String getPhone()             { return phone; }
    public void   setPhone(String phone) { this.phone = phone; }

    public String getCountry()               { return country; }
    public void   setCountry(String country) { this.country = country; }

    public String getSpecialRequests()                       { return specialRequests; }
    public void   setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }

    public String getBookingFor()                    { return bookingFor; }
    public void   setBookingFor(String bookingFor)   { this.bookingFor = bookingFor; }

    public boolean isTravelingForWork()                        { return travelingForWork; }
    public void    setTravelingForWork(boolean travelingForWork) { this.travelingForWork = travelingForWork; }

    public boolean isPaperlessConfirmation()                             { return paperlessConfirmation; }
    public void    setPaperlessConfirmation(boolean paperlessConfirmation) { this.paperlessConfirmation = paperlessConfirmation; }

    /** Full guest display name combining firstName + lastName or falling back to userName. */
    public String getGuestDisplayName() {
        if (firstName != null && !firstName.isBlank()) {
            return firstName + (lastName != null && !lastName.isBlank() ? " " + lastName : "");
        }
        return userName != null ? userName : "";
    }

    // ── Calculated helpers ────────────────────────────────────────────────
    public long getNights() {
        try {
            LocalDate ci = LocalDate.parse(checkIn);
            LocalDate co = LocalDate.parse(checkOut);
            return ChronoUnit.DAYS.between(ci, co);
        } catch (Exception e) {
            return 0;
        }
    }
}
