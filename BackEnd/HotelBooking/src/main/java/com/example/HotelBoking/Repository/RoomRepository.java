package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Entity.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.time.LocalDate;

@Repository
public interface RoomRepository extends JpaRepository<Room, Integer> {
    List<Room> findByHotel_Id(Integer hotelId);
    
    // Thêm method để tìm room theo roomTypeId
    List<Room> findByRoomType_Id(Integer roomTypeId);
    
    // Thêm method để tìm room theo hotel và roomType
    List<Room> findByHotel_IdAndRoomType_Id(Integer hotelId, Integer roomTypeId);

    @Query(value = "SELECT COUNT(r.id) FROM Room r WHERE r.roomType.id = :roomTypeId AND r.hotel.id = :hotelId AND r.id NOT IN (" +
            "SELECT bd.room.id FROM BookingDetail bd JOIN bd.booking b " +
            "WHERE b.status <> 'Cancelled' AND (b.checkIn < :checkOut AND b.checkOut > :checkIn))")
    int countAvailableRooms(@Param("roomTypeId") Integer roomTypeId, @Param("hotelId") Integer hotelId, @Param("checkIn") LocalDate checkIn, @Param("checkOut") LocalDate checkOut);

    @Query("SELECT r FROM Room r WHERE r.roomType.id = :roomTypeId AND r.hotel.id = :hotelId AND r.id NOT IN (" +
            "SELECT bd.room.id FROM BookingDetail bd JOIN bd.booking b " +
            "WHERE b.status <> 'Cancelled' AND (b.checkIn < :checkOut AND b.checkOut > :checkIn))")
    List<Room> findAvailableRooms(@Param("roomTypeId") Integer roomTypeId,
                                  @Param("hotelId") Integer hotelId,
                                  @Param("checkIn") LocalDate checkIn,
                                  @Param("checkOut") LocalDate checkOut);
}
