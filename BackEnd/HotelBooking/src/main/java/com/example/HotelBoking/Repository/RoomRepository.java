package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RoomRepository extends JpaRepository<Room, Long> {
    List<Room> findByHotelId(Long hotelId);
}
