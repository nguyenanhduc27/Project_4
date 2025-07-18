package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.BookingDetail;
import com.example.HotelBoking.Enum.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface BookingDetailRepository extends JpaRepository<BookingDetail, Long> {
    @Query("SELECT CASE WHEN COUNT(bd) > 0 THEN true ELSE false END " +
            "FROM BookingDetail bd " +
            "WHERE bd.room.id = :roomId " +
            "AND bd.booking.status IN :statuses " +
            "AND :checkOut > bd.booking.checkIn " +
            "AND :checkIn < bd.booking.checkOut")
    boolean existsActiveBooking(
            @Param("roomId") Integer roomId,
            @Param("statuses") List<BookingStatus> statuses,
            @Param("checkIn") LocalDate checkIn,
            @Param("checkOut") LocalDate checkOut
    );

}
