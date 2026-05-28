package com.hotel.dao;

import com.hotel.model.Reservation;
import com.hotel.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    private static final String SELECT_WITH_JOINS =
        "SELECT res.*, " +
        "  u.name AS user_name, " +
        "  r.room_number, r.room_type, r.price_per_night, r.hotel_id, " +
        "  h.hotel_name " +
        "FROM reservations res " +
        "JOIN users  u ON res.user_id = u.id " +
        "JOIN rooms  r ON res.room_id = r.id " +
        "JOIN hotels h ON r.hotel_id  = h.id ";

    private Reservation map(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setId(rs.getInt("id"));
        res.setUserId(rs.getInt("user_id"));
        res.setRoomId(rs.getInt("room_id"));
        res.setCheckIn(rs.getString("check_in"));
        res.setCheckOut(rs.getString("check_out"));
        res.setNumberOfGuests(rs.getInt("number_of_guests"));
        res.setStatus(rs.getString("status"));
        res.setCreatedAt(rs.getString("created_at"));

        // JOIN-populated
        res.setUserName(rs.getString("user_name"));
        res.setRoomNumber(rs.getString("room_number"));
        res.setRoomType(rs.getString("room_type"));
        res.setPricePerNight(rs.getDouble("price_per_night"));
        res.setHotelId(rs.getInt("hotel_id"));
        res.setHotelName(rs.getString("hotel_name"));

        // Guest details
        res.setFirstName(rs.getString("first_name"));
        res.setLastName(rs.getString("last_name"));
        res.setPhone(rs.getString("phone"));
        res.setCountry(rs.getString("country"));
        res.setSpecialRequests(rs.getString("special_requests"));
        res.setBookingFor(rs.getString("booking_for"));
        res.setTravelingForWork(rs.getBoolean("traveling_for_work"));
        res.setPaperlessConfirmation(rs.getBoolean("paperless_confirmation"));
        return res;
    }

    public List<Reservation> getAll() {
        List<Reservation> list = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + "ORDER BY res.created_at DESC";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Reservation> getByUser(int userId) {
        List<Reservation> list = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + "WHERE res.user_id = ? ORDER BY res.created_at DESC";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Reservation getById(int id) {
        String sql = SELECT_WITH_JOINS + "WHERE res.id = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private void bind(PreparedStatement ps, Reservation res) throws SQLException {
        ps.setInt   (1,  res.getUserId());
        ps.setInt   (2,  res.getRoomId());
        ps.setString(3,  res.getCheckIn());
        ps.setString(4,  res.getCheckOut());
        ps.setInt   (5,  res.getNumberOfGuests());
        ps.setString(6,  res.getStatus());
        ps.setString(7,  res.getFirstName());
        ps.setString(8,  res.getLastName());
        ps.setString(9,  res.getPhone());
        ps.setString(10, res.getCountry() != null ? res.getCountry() : "Sri Lanka");
        ps.setString(11, res.getSpecialRequests());
        ps.setString(12, res.getBookingFor() != null ? res.getBookingFor() : "Self");
        ps.setBoolean(13, res.isTravelingForWork());
        ps.setBoolean(14, res.isPaperlessConfirmation());
    }

    public int insert(Reservation res) {
        String sql = "INSERT INTO reservations " +
            "(user_id,room_id,check_in,check_out,number_of_guests,status," +
            " first_name,last_name,phone,country,special_requests,booking_for,traveling_for_work,paperless_confirmation) " +
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(ps, res);
            ps.executeUpdate();
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) return generatedKeys.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public void update(Reservation res) {
        String sql = "UPDATE reservations SET " +
            "user_id=?,room_id=?,check_in=?,check_out=?,number_of_guests=?,status=?," +
            "first_name=?,last_name=?,phone=?,country=?,special_requests=?,booking_for=?,traveling_for_work=?,paperless_confirmation=? " +
            "WHERE id=?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, res);
            ps.setInt(15, res.getId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void delete(int id) {
        String sql = "DELETE FROM reservations WHERE id = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void cancel(int id) {
        String sql = "UPDATE reservations SET status = 'Cancelled' WHERE id = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public Reservation getByIdForUser(int id, int userId) {
        String sql = SELECT_WITH_JOINS + "WHERE res.id = ? AND res.user_id = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = ?";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
