package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.RoomDTO;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    @Autowired
    private RoomService service;

    // Lấy tất cả phòng
    @GetMapping
    public List<Room> getAllRooms() {
        return service.getAll();
    }

    // Lấy phòng theo ID
    @GetMapping("/{id}")
    public Room getRoomById(@PathVariable Long id) {
        return service.findById(id);
    }

    // Thêm phòng mới
    @PostMapping
    public Room addNewRoom(@RequestBody RoomDTO dto) {
        return service.add(dto);
    }

    // Cập nhật phòng
    @PutMapping("/{id}")
    public Room updateRoom(@PathVariable Long id, @RequestBody RoomDTO dto) {
        return service.update(id, dto);
    }

    // Xóa phòng
    @DeleteMapping("/{id}")
    public String deleteRoom(@PathVariable Long id) {
        return service.delete(id) ? "Success Delete" : "Can not find id";
    }

    @GetMapping("/hotels/{hotelId}/rooms")
    public ResponseEntity<List<Room>> getRoomsByHotel(@PathVariable Long hotelId) {
        List<Room> rooms = service.getRoomsByHotelId(hotelId);
        return ResponseEntity.ok(rooms);
    }
}
