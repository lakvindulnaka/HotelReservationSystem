package com.hotel.model;

public class Hotel {
    private int    id;
    private String hotelName;
    private String location;
    private String contactNumber;
    private String email;
    private String description;
    private String facilities;
    private String image;
    private int    starRating;

    public int    getId()            { return id; }
    public void   setId(int id)      { this.id = id; }

    public String getHotelName()                   { return hotelName; }
    public void   setHotelName(String hotelName)   { this.hotelName = hotelName; }

    public String getLocation()                    { return location; }
    public void   setLocation(String location)     { this.location = location; }

    public String getContactNumber()                       { return contactNumber; }
    public void   setContactNumber(String contactNumber)   { this.contactNumber = contactNumber; }

    public String getEmail()                 { return email; }
    public void   setEmail(String email)     { this.email = email; }

    public String getDescription()                   { return description; }
    public void   setDescription(String description) { this.description = description; }

    public String getFacilities()                    { return facilities; }
    public void   setFacilities(String facilities)   { this.facilities = facilities; }

    public String getImage()             { return image; }
    public void   setImage(String image) { this.image = image; }

    public int  getStarRating()                  { return starRating; }
    public void setStarRating(int starRating)    { this.starRating = starRating; }

    /** Convenience: returns repeated "★" string for JSP display. */
    public String getStarString() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < Math.min(starRating, 5); i++) sb.append("★");
        return sb.toString();
    }
}
