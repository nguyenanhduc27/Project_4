package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Entity.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Integer> {
    List<Room> findByHotel_Id(Integer hotelId);
}
