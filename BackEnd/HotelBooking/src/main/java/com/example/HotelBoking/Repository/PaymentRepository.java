package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRepository extends JpaRepository<Payment , Long> {
}
