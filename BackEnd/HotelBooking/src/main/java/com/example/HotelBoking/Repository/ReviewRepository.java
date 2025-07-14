package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewRepository extends JpaRepository<Review, Long> {
}
