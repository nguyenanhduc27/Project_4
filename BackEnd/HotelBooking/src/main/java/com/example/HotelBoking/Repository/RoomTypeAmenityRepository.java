package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.RoomTypeAmenity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface RoomTypeAmenityRepository extends JpaRepository<RoomTypeAmenity, Long> {
    @Query("SELECT r.amenityName FROM RoomTypeAmenity r WHERE r.roomTypeId = ?1")
    List<String> findAmenityNamesByRoomTypeId(Integer roomTypeId);
} 