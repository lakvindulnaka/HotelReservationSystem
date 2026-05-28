package com.hotel.dao;

import com.hotel.model.Room;
import com.hotel.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    private static final String SELECT_WITH_HOTEL =
        "SELECT r.*, h.hotel_name " +
        "FROM rooms r JOIN hotels h ON r.hotel_id = h.id ";

    private Room map(ResultSet rs) throws SQLException {
        Room r = new Room();
        r.setId(rs.getInt("id"));
        r.setHotelId(rs.getInt("hotel_id"));
        r.setHotelName(rs.getString("hotel_name"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setRoomType(rs.getString("room_type"));
        r.setPricePerNight(rs.getDouble("price_per_night"));
        r.setCapacity(rs.getInt("capacity"));
        r.setStatus(rs.getString("status"));
        r.setDescription(rs.getString("description"));
        r.setImage(rs.getString("image"));
        r.setBedType(rs.getString("bed_type"));
        r.setRoomSize(rs.getString("room_size"));
        r.setGallery(rs.getString("gallery"));
        r.setFacilities(rs.getString("facilities"));
        return r;
    }

    public List<Room> getAll() {
        List<Room> list = new ArrayList<>();
        String sql = SELECT_WITH_HOTEL + "ORDER BY r.hotel_id, r.id";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Room> getByHotel(int hotelId) {
        List<Room> list = new ArrayList<>();
        String sql = SELECT_WITH_HOTEL + "WHERE r.hotel_id = ? ORDER BY r.id";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, hotelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Room getById(int id) {
        String sql = SELECT_WITH_HOTEL + "WHERE r.id = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private void bind(PreparedStatement ps, Room r) throws SQLException {
        ps.setInt   (1, r.getHotelId());
        ps.setString(2, r.getRoomNumber());
        ps.setString(3, r.getRoomType());
        ps.setDouble(4, r.getPricePerNight());
        ps.setInt   (5, r.getCapacity());
        ps.setString(6, r.getStatus());
        ps.setString(7, r.getDescription());
        ps.setString(8, r.getImage());
        ps.setString(9, r.getBedType());
        ps.setString(10, r.getRoomSize());
        ps.setString(11, r.getGallery());
        ps.setString(12, r.getFacilities());
    }

    public void insert(Room r) {
        String sql = "INSERT INTO rooms (hotel_id,room_number,room_type,price_per_night,capacity,status,description,image,bed_type,room_size,gallery,facilities) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, r);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void update(Room r) {
        String sql = "UPDATE rooms SET hotel_id=?,room_number=?,room_type=?,price_per_night=?,capacity=?,status=?,description=?,image=?,bed_type=?,room_size=?,gallery=?,facilities=? WHERE id=?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, r);
            ps.setInt(13, r.getId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void delete(int id) {
        String sql = "DELETE FROM rooms WHERE id = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public int countAll() {
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM rooms");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Room> getAvailable() {
        List<Room> list = new ArrayList<>();
        String sql = SELECT_WITH_HOTEL + "WHERE r.status = 'Available' ORDER BY r.hotel_id, r.id";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
