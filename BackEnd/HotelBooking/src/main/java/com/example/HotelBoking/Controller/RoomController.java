package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.RoomDTO;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Entity.RoomAmenity;
import com.example.HotelBoking.Service.RoomAmenityService;
import com.example.HotelBoking.Service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    @Autowired
    private RoomService service;

    @GetMapping
    public List<RoomDTO> getAllRooms() {
        return service.getAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<RoomDTO> getRoomById(@PathVariable Long id) {
        RoomDTO dto = service.findById(id);
        return dto != null ? ResponseEntity.ok(dto) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<?> createRoom(@RequestBody RoomDTO dto) {
        try {
            return ResponseEntity.ok(service.add(dto));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateRoom(@PathVariable Long id, @RequestBody RoomDTO dto) {
        try {
            Room updated = service.update(id, dto);
            return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteRoom(@PathVariable Long id) {
        return service.delete(id)
                ? ResponseEntity.ok("Deleted successfully")
                : ResponseEntity.status(404).body("Room not found");
    }

    @GetMapping("/hotel/{hotelId}")
    public ResponseEntity<List<RoomDTO>> getRoomsByHotel(@PathVariable Long hotelId) {
        List<Room> rooms = service.getRoomsByHotelId(hotelId);
        List<RoomDTO> dtos = rooms.stream().map(service::toDTO).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }
}



