package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookingRepository extends JpaRepository<Booking, Long> {

}
