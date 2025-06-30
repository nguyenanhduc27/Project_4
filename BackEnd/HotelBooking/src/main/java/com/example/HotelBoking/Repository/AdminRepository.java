package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Admin;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminRepository extends JpaRepository<Admin, Long> {
    Admin findByUsername(String username);
    boolean existsByUsername(String username);
}
