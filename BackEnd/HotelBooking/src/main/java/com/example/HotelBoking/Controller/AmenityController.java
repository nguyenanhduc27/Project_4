package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.AmenityDTO;
import com.example.HotelBoking.Entity.Amenity;
import com.example.HotelBoking.Service.AmenityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/amenities")
public class AmenityController {

    @Autowired
    private AmenityService service;

    // Lấy tất cả amenities
    @GetMapping
    public List<AmenityDTO> getAll() {
        return service.getAll();
    }

    // Lấy amenity theo ID
    @GetMapping("/{id}")
    public ResponseEntity<AmenityDTO> getById(@PathVariable Long id) {
        AmenityDTO dto = service.findById(id);
        return (dto != null) ? ResponseEntity.ok(dto) : ResponseEntity.notFound().build();
    }

    // Thêm mới amenity
    @PostMapping
    public ResponseEntity<?> add(@RequestBody AmenityDTO dto) {
        try {
            Amenity entity = service.add(dto);
            return ResponseEntity.ok(service.toDTO(entity));
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    // Cập nhật amenity
    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody AmenityDTO dto) {
        try {
            Amenity entity = service.update(id, dto);
            if (entity != null) {
                return ResponseEntity.ok(service.toDTO(entity));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    // Xoá amenity
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

