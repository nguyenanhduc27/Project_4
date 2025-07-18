package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.BookingDTO;
import com.example.HotelBoking.Entity.Booking;
import com.example.HotelBoking.Enum.BookingStatus;
import com.example.HotelBoking.Service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:8080", "http://localhost:3001"})
public class BookingController {

    @Autowired
    private BookingService service;

    // Lấy tất cả booking
    @GetMapping
    public List<Booking> getAllBookings() {
        return service.getAll();
    }

    // Lấy booking theo ID
    @GetMapping("/{id}")
    public Booking getBookingById(@PathVariable Long id) {
        return service.getById(id);
    }

    // Thêm booking mới
    @PostMapping
    public ResponseEntity<?> createBooking(@RequestBody BookingDTO dto) {
        try {
            Booking booking = service.add(dto);
            return ResponseEntity.ok(booking);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Lỗi dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Lỗi server: " + e.getMessage());
        }
    }

    // Cập nhật booking
    @PutMapping("/{id}")
    public Booking updateBooking(@PathVariable Long id, @RequestBody BookingDTO dto) {
        return service.update(id , dto);
    }

    // Xoá booking
    @DeleteMapping("/{id}")
    public String deleteBooking(@PathVariable Long id) {
        return service.delete(id) ? "Success Delete Booking" : "Can not find ID Booking";
    }

    @GetMapping("/user/{userId}")
    public List<Booking> getBookingsByUser(@PathVariable Long userId) {
        return service.getBookingUser(userId);
    }

    @GetMapping("/status")
    public List<Booking> getBookingsByStatus(@RequestParam BookingStatus status) {
        return service.getBookingsByStatus(status);
    }


}
