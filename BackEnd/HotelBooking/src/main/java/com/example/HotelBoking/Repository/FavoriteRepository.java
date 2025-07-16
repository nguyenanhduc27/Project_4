package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FavoriteRepository extends JpaRepository<Favorite , Long> {
}
