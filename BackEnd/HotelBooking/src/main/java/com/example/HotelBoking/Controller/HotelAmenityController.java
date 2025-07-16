package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.HotelAmenityDTO;
import com.example.HotelBoking.Entity.HotelAmenity;
import com.example.HotelBoking.Repository.HotelAmenityRepository;
import com.example.HotelBoking.Service.HotelAmenityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/hotel-amenities")
public class HotelAmenityController {

    @Autowired
    private HotelAmenityService service;

    // Lấy tất cả danh sách hotel amenities
    @GetMapping
    public List<HotelAmenityDTO> getAll() {
        return service.getAll();
    }

    // Lấy hotel amenity theo ID
    @GetMapping("/{id}")
    public ResponseEntity<HotelAmenityDTO> getById(@PathVariable Long id) {
        HotelAmenityDTO dto = service.findById(id);
        return (dto != null) ? ResponseEntity.ok(dto) : ResponseEntity.notFound().build();
    }

    // Thêm mới hotel amenity
    @PostMapping
    public ResponseEntity<?> add(@RequestBody HotelAmenityDTO dto) {
        try {
            HotelAmenity entity = service.add(dto);
            return ResponseEntity.ok(service.toDTO(entity));
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    // Cập nhật hotel amenity
    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody HotelAmenityDTO dto) {
        try {
            HotelAmenity entity = service.update(id, dto);
            if (entity != null) {
                return ResponseEntity.ok(service.toDTO(entity));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    // Xoá hotel amenity
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

