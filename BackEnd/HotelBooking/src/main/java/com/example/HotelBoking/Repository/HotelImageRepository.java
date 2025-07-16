package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.HotelImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface HotelImageRepository extends JpaRepository<HotelImage, Long> {
    @Query("SELECT h.imageUrl FROM HotelImage h WHERE h.hotel.id = :hotelId AND h.isThumbnail = true")
    String findThumbnailUrlByHotelId(Long hotelId);

    @Query("SELECT h FROM HotelImage h WHERE h.hotel.id = :hotelId")
    java.util.List<HotelImage> findAllByHotelId(Long hotelId);
}