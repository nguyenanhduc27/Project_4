package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.BookingDetailDTO;
import com.example.HotelBoking.Entity.BookingDetail;
import com.example.HotelBoking.Repository.BookingDetailRepository;
import com.example.HotelBoking.Service.BookingDetailService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/booking-details")
public class BookingDetailController {

    @Autowired
    private BookingDetailService service;

    // Lấy tất cả danh sách booking detail
    @GetMapping
    public List<BookingDetailDTO> getAll() {
        return service.getAll();
    }

    // Lấy booking detail theo ID
    @GetMapping("/{id}")
    public ResponseEntity<BookingDetailDTO> getById(@PathVariable Long id) {
        BookingDetailDTO dto = service.findById(id);
        return (dto != null) ? ResponseEntity.ok(dto) : ResponseEntity.notFound().build();
    }

    // Thêm mới booking detail
    @PostMapping
    public ResponseEntity<?> add(@RequestBody BookingDetailDTO dto) {
        try {
            BookingDetail entity = service.add(dto);
            return ResponseEntity.ok(service.toDTO(entity));
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    // Cập nhật booking detail
    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody BookingDetailDTO dto) {
        try {
            BookingDetail entity = service.update(id, dto);
            if (entity != null) {
                return ResponseEntity.ok(service.toDTO(entity));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    // Xoá booking detail
    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        boolean deleted = service.delete(id);
        if (deleted) {
            return ResponseEntity.ok("Xoá thành công");
        } else {
            return ResponseEntity.status(404).body("Không tìm thấy ID");
        }
    }
}

