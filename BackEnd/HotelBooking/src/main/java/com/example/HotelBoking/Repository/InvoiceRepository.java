package com.example.HotelBoking.Repository;

import com.example.HotelBoking.Entity.Invoice;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InvoiceRepository extends JpaRepository<Invoice,Long> {
}
