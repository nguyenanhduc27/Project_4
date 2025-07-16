package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.RoomTypeDTO;
import com.example.HotelBoking.Entity.RoomType;
import com.example.HotelBoking.Service.RoomTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/room-types")
public class RoomTypeController {

    @Autowired
    private RoomTypeService service;

    @GetMapping
    public List<RoomTypeDTO> getAll() {
        return service.getAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<RoomTypeDTO> getById(@PathVariable Long id) {
        RoomTypeDTO dto = service.findById(id);
        return dto != null ? ResponseEntity.ok(dto) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody RoomTypeDTO dto) {
        return ResponseEntity.ok(service.add(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody RoomTypeDTO dto) {
        RoomType updated = service.update(id, dto);
        return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        return service.delete(id)
                ? ResponseEntity.ok("Deleted successfully")
                : ResponseEntity.status(404).body("Room Type not found");
    }
}


