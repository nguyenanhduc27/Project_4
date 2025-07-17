package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.HotelAmenity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface HotelAmenityRepository extends JpaRepository<HotelAmenity, Long> {
    @Query("SELECT h.amenityName FROM HotelAmenity h WHERE h.hotelId = ?1")
    List<String> findAmenityNamesByHotelId(Integer hotelId);
} 