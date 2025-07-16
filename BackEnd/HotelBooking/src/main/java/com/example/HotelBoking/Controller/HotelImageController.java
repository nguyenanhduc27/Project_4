package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.HotelImageDTO;
import com.example.HotelBoking.Entity.HotelImage;
import com.example.HotelBoking.Service.HotelImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/hotel-images")
public class HotelImageController {

    @Autowired
    private HotelImageService service;

    @GetMapping
    public ResponseEntity<List<HotelImageDTO>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<HotelImageDTO> getById(@PathVariable Long id) {
        HotelImageDTO dto = service.findById(id);
        return dto != null ? ResponseEntity.ok(dto) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<HotelImage> add(@RequestBody HotelImageDTO dto) {
        try {
            HotelImage created = service.add(dto);
            return ResponseEntity.ok(created);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<HotelImage> update(@PathVariable Long id, @RequestBody HotelImageDTO dto) {
        HotelImage updated = service.update(id, dto);
        return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        return service.delete(id)
                ? ResponseEntity.ok("Deleted successfully")
                : ResponseEntity.status(404).body("HotelImage not found");
    }
}


