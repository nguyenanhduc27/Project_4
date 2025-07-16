package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface HotelRepository extends JpaRepository<Hotel, Long> {
    List<Hotel> findByCity(String city);
}

