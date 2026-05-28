package com.hotel.dao;

import com.hotel.model.Hotel;
import com.hotel.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HotelDAO {

    private Hotel map(ResultSet rs) throws SQLException {
        Hotel h = new Hotel();
        h.setId(rs.getInt("id"));
        h.setHotelName(rs.getString("hotel_name"));
        h.setLocation(rs.getString("location"));
        h.setContactNumber(rs.getString("contact_number"));
        h.setEmail(rs.getString("email"));
        h.setDescription(rs.getString("description"));
        h.setFacilities(rs.getString("facilities"));
        h.setImage(rs.getString("image"));
        h.setStarRating(rs.getInt("star_rating"));
        return h;
    }

    public List<Hotel> getAll() {
        List<Hotel> list = new ArrayList<>();
        String sql = "SELECT * FROM hotels ORDER BY id";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Hotel getById(int id) {
        String sql = "SELECT * FROM hotels WHERE id = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private void bind(PreparedStatement ps, Hotel h) throws SQLException {
        ps.setString(1, h.getHotelName());
        ps.setString(2, h.getLocation());
        ps.setString(3, h.getContactNumber());
        ps.setString(4, h.getEmail());
        ps.setString(5, h.getDescription());
        ps.setString(6, h.getFacilities());
        ps.setString(7, h.getImage());
        ps.setInt(8, h.getStarRating() > 0 ? h.getStarRating() : 5);
    }

    public void insert(Hotel h) {
        String sql = "INSERT INTO hotels (hotel_name,location,contact_number,email,description,facilities,image,star_rating) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, h);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void update(Hotel h) {
        String sql = "UPDATE hotels SET hotel_name=?,location=?,contact_number=?,email=?,description=?,facilities=?,image=?,star_rating=? WHERE id=?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, h);
            ps.setInt(9, h.getId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void delete(int id) {
        String sql = "DELETE FROM hotels WHERE id = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public java.util.Map<Integer, Double> getStartingPriceMap() {
        java.util.Map<Integer, Double> map = new java.util.HashMap<>();
        String sql = "SELECT hotel_id, MIN(price_per_night) AS min_price FROM rooms GROUP BY hotel_id";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("hotel_id"), rs.getDouble("min_price"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    public int countAll() {
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM hotels");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
