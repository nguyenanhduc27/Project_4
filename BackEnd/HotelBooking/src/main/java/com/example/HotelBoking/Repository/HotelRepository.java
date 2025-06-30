package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HotelRepository extends JpaRepository<Hotel, Long> {
}
