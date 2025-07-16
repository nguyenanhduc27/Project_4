package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.BookingDTO;
import com.example.HotelBoking.Entity.Booking;
import com.example.HotelBoking.Enum.BookingStatus;
import com.example.HotelBoking.Service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    @Autowired
    private BookingService service;

    // Lấy tất cả bookings
    @GetMapping
    public List<BookingDTO> getAll() {
        return service.getAll();
    }

    // Lấy booking theo ID
    @GetMapping("/{id}")
    public ResponseEntity<BookingDTO> getById(@PathVariable Long id) {
        BookingDTO dto = service.findById(id);
        return (dto != null) ? ResponseEntity.ok(dto) : ResponseEntity.notFound().build();
    }

    // Thêm mới booking
    @PostMapping
    public ResponseEntity<?> add(@RequestBody BookingDTO dto) {
        try {
            Booking entity = service.add(dto);
            return ResponseEntity.ok(service.toDTO(entity));
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    // Cập nhật booking
    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody BookingDTO dto) {
        try {
            Booking entity = service.update(id, dto);
            if (entity != null) {
                return ResponseEntity.ok(service.toDTO(entity));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    // Xoá booking
    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        boolean deleted = service.delete(id);
        if (deleted) {
            return ResponseEntity.ok("Xoá thành công");
        } else {
            return ResponseEntity.status(404).body("Không tìm thấy ID");
        }
    }

    // Lấy danh sách booking của user
    @GetMapping("/user/{userId}")
    public List<BookingDTO> getBookingsByUser(@PathVariable Long userId) {
        return service.getBookingUser(userId).stream().map(service::toDTO).collect(Collectors.toList());
    }

    // Lấy danh sách booking theo trạng thái
    @GetMapping("/status/{status}")
    public List<BookingDTO> getBookingsByStatus(@PathVariable BookingStatus status) {
        return service.getBookingsByStatus(status).stream().map(service::toDTO).collect(Collectors.toList());
    }
}
