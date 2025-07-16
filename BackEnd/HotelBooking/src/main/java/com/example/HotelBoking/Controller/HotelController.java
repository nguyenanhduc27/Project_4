package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.HotelDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Service.HotelService;
import com.example.HotelBoking.Service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/hotels")
public class HotelController {

    @Autowired
    private HotelService hotelService;

    @GetMapping
    public List<Hotel> getAll() {
        return hotelService.getAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Hotel> getById(@PathVariable Long id) {
        Hotel hotel = hotelService.findById(id);
        return hotel != null ? ResponseEntity.ok(hotel) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<Hotel> create(@RequestBody HotelDTO dto) {
        Hotel created = hotelService.add(dto);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Hotel> update(@PathVariable Long id, @RequestBody HotelDTO dto) {
        Hotel updated = hotelService.update(id, dto);
        return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        boolean deleted = hotelService.delete(id);
        return deleted ? ResponseEntity.ok("Xóa thành công") : ResponseEntity.notFound().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<Hotel>> searchHotels(
            @RequestParam("checkIn") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkIn,
            @RequestParam("checkOut") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkOut,
            @RequestParam("city") String city,
            @RequestParam("rooms") int requiredRoomCount
    ) {
        List<Hotel> results = hotelService.searchHotels(checkIn, checkOut, city, requiredRoomCount);
        return ResponseEntity.ok(results);
    }
}

