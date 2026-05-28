package com.hotel.model;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Room {
    private int    id;
    private int    hotelId;
    private String hotelName;
    private String roomNumber;
    private String roomType;
    private double pricePerNight;
    private int    capacity;
    private String status;
    private String description;
    private String image;
    private String bedType;
    private String roomSize;
    /** Comma-separated gallery URLs (3 extras beyond the main image). */
    private String gallery;
    /** Comma-separated facility labels. */
    private String facilities;

    // ── Getters / Setters ─────────────────────────────────────────────────
    public int    getId()            { return id; }
    public void   setId(int id)      { this.id = id; }

    public int  getHotelId()              { return hotelId; }
    public void setHotelId(int hotelId)   { this.hotelId = hotelId; }

    public String getHotelName()                   { return hotelName; }
    public void   setHotelName(String hotelName)   { this.hotelName = hotelName; }

    public String getRoomNumber()                    { return roomNumber; }
    public void   setRoomNumber(String roomNumber)   { this.roomNumber = roomNumber; }

    public String getRoomType()                  { return roomType; }
    public void   setRoomType(String roomType)   { this.roomType = roomType; }

    public double getPricePerNight()                       { return pricePerNight; }
    public void   setPricePerNight(double pricePerNight)   { this.pricePerNight = pricePerNight; }

    public int  getCapacity()              { return capacity; }
    public void setCapacity(int capacity)  { this.capacity = capacity; }

    public String getStatus()                { return status; }
    public void   setStatus(String status)   { this.status = status; }

    public String getDescription()                   { return description; }
    public void   setDescription(String description) { this.description = description; }

    public String getImage()             { return image; }
    public void   setImage(String image) { this.image = image; }

    public String getBedType()               { return bedType; }
    public void   setBedType(String bedType) { this.bedType = bedType; }

    public String getRoomSize()                { return roomSize; }
    public void   setRoomSize(String roomSize) { this.roomSize = roomSize; }

    public String getGallery()               { return gallery; }
    public void   setGallery(String gallery) { this.gallery = gallery; }

    public String getFacilities()                    { return facilities; }
    public void   setFacilities(String facilities)   { this.facilities = facilities; }

    // ── Helpers ──────────────────────────────────────────────────────────
    public boolean isAvailable() { return "Available".equalsIgnoreCase(status); }

    /** Split gallery CSV into a List suitable for JSP iteration. */
    public List<String> getGalleryList() {
        if (gallery == null || gallery.isBlank()) return Collections.emptyList();
        return Arrays.asList(gallery.split(","));
    }

    /** Split facilities CSV into a List. */
    public List<String> getFacilitiesList() {
        if (facilities == null || facilities.isBlank()) return Collections.emptyList();
        return Arrays.asList(facilities.split(","));
    }
}
